require 'incl_container'

CLOTH_SCRAPS_PER_BOLT = 5

RegisterEventHandler(EventType.ModuleAttached, GetCurrentModule(), function()
		if not( this:IsPlayer() ) then
			-- module was attached to fabric
			AddUseCase(this,"Cut into Cloth Scraps", true)
		else
			-- module was attached to player that cut fabric
			RequestConsumeResource(this,"Fabric", initializer.StackCount, "CutToClothScrapsConsumeResource", this)
		end
	end)

function DelayCleanup()
	-- deleting module too quickly after attach can cause it to never be detached.
	CallFunctionDelayed(TimeSpan.FromSeconds(0.01), function()
		this:DelModule("cut_to_cloth") --cleanup
	end)
end

if ( this:IsPlayer() ) then
	-- only players need this event handler
	RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", 
		function (success, transactionId, user)
			if ( user == this and this:IsPlayer() ) then
				if ( transactionId == "CutToClothScrapsConsumeResource" ) then
					if ( success ) then
						local scrapCount = initializer.StackCount * CLOTH_SCRAPS_PER_BOLT
						this:SystemMessage("You create "..scrapCount.." cloth scraps.")

						local backpack = this:GetEquippedObject("Backpack")
						if ( backpack == nil ) then return end

						local added, addtostackreason = TryAddToStack("ClothScraps", backpack, scrapCount)
						if ( added ) then
							DelayCleanup()
							return
						end

						local createId = "cut_to_cloth_"..uuid()
						local canCreateInBag, reason = CreateObjInBackpackOrAtLocation(this, "resource_clothscraps", createId, scrapCount)
						RegisterSingleEventHandler(EventType.CreatedObject, createId,
							function(success, objRef, amount)
								if success and amount > 1 then
									RequestSetStack(objRef,amount)
								end
								SetItemTooltip(objRef)
								DelayCleanup()
							end)
					end
				end
			end
		end)
else
	-- only fabric (or stuff that can be cut_to_ClothScraps) need this event handler.
	RegisterEventHandler(EventType.Message, "UseObject", function(user, useType)
			if ( useType == "Cut into Cloth Scraps" ) then
				if ( user:HasModule("cut_to_cloth") ) then
					-- incase it got stuck for whatever reason, we don't want the player to loose their resources.
					user:DelModule("cut_to_cloth")
				end

				if( this:TopmostContainer() ~= user ) then
					user:SystemMessage("That must be in your backpack to use it.","info")
    		 		return false
    		 	end
    		 	
				user:AddModule("cut_to_cloth", { StackCount = (GetStackCount(this) or 0)})
			end
		end)
end