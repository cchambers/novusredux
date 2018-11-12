require 'incl_keyhelpers'

function ValidateUse(user)
	if( user == nil or not(user:IsValid()) or IsDead(user)) then
		return false
	end

	if (this:TopmostContainer() ~= user) then
		user:SystemMessage("That must be in your backpack to unpack it.","info")
		return false
	end

	return true
end

userObj = nil

function RequestPlacementLoc(user)
	local unpackedTemplate = this:GetObjVar("UnpackedTemplate")	
	if( unpackedTemplate == nil ) then
		return
	end

	user:SystemMessage("Where do you wish to place this object?","info")
	user:RequestClientTargetLocPreview(this, "targetLoc",unpackedTemplate,Loc(0,0,0))
end

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Unpack" and usedType ~="Use") then return end
		
		if not(ValidateUse(user) ) then
			return
		end

		RequestPlacementLoc(user)

		userObj = user
	end)

RegisterEventHandler(EventType.ClientTargetLocResponse, "targetLoc", 
	function(success, targetLoc)
		-- validate target
		if( not(success)) then
			return
		end

		local unpackedTemplate = this:GetObjVar("UnpackedTemplate")	
		if( unpackedTemplate ~= nil ) then
			if (not GetContainingHouseForLoc(targetLoc)) then			
				userObj:SystemMessage("You can only unpack objects at a housing plot.","event")
				RequestPlacementLoc(userObj)
				return
			end

			if not(IsPassable(targetLoc)) then				
				userObj:SystemMessage("[$2380]","event")
				RequestPlacementLoc(userObj)
				return
			end

			local bounds = GetTemplateObjectBounds(unpackedTemplate)
			if (bounds ~= nil and #bounds ~= 0) then
				local newBounds = bounds[1]
				newBounds = newBounds:Add(targetLoc):Flatten()
				local box = Box2(newBounds)

				if (MoveMobiles(box, targetLoc) == false) then
					RequestPlacementLoc(userObj)
					return
				end
			end

			userObj:PlayAnimation("kneel")		

			CreateObj(unpackedTemplate,targetLoc,"unpackedCreate")
		end
	end)

RegisterEventHandler(EventType.CreatedObject, "key", 
	function(success,objRef,user)
		this:Destroy()
	end)

RegisterEventHandler(EventType.CreatedObject, "unpackedCreate", 
	function(success,objRef)
		if( success ) then
			user = userObj
			objRef:SetObjVar("PackedTemplate", this:GetCreationTemplateId())
			objRef:AddModule("repackable_object")
			local houseControlObj = GetContainingHouseForObj(objRef)

			local houseKey = GetKey(user,houseControlObj:GetObjVar("DoorObject"))
			if(houseControlObj ~= nil and (IsHouseOwner(userObj,houseControlObj) or houseKey ~= nil)) then
				houseControlObj:SendMessage("ObjectPlaced",objRef,userObj)
			else
				Decay(objRef, decayTime)
			end

			if (objRef:HasObjVar("ShouldCreateKey")) then
				-- if this container is being placed in a house
				if ( houseControlObj ~= nil ) then
					-- assign the houses key to work with this chest
					local houseLockUniqueId = houseControlObj:GetObjVar("HouseLockUniqueId")
					if ( houseLockUniqueId ~= nil ) then
						objRef:SetObjVar("lockUniqueId", houseLockUniqueId)
						-- lock the chest
						objRef:SendMessage("Lock")

						user:SystemMessage("[$2381]")
					else
						user:SystemMessage("[$2382]")
					end
				else
					-- not being placed in a house
					this:AddModule("create_key")
				end
			end
			
			this:Destroy()
		end
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function ()
         SetTooltipEntry(this,"packed", "Can be unpacked and placed in the world.")
         AddUseCase(this,"Unpack",true,"HasObject")
    end)