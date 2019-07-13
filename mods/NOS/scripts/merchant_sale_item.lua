require 'NOS:stackable_helpers'

RegisterEventHandler(EventType.Timer, "check_valid", 
	function ()
		local merchant = this:GetObjVar("merchantOwner")

		if( merchant == nil or not(merchant:IsValid())) then
			--DebugMessage("Destroying at A")
			this:Destroy()
		else
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(4 + math.random()),"check_valid")
		end
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, "merchant_sale_item", 
	function()
		this:SetObjVar("LockedDown",true)
		this:SetSharedObjectProperty("DenyPickup", true)
		this:SetObjVar("handlesPickup",true)
		if (this:HasObjVar("UnitWeight")) then
			local unitWeight = this:GetObjVar("UnitWeight")
			local actualWeight = math.max(1,unitWeight)
			this:SetSharedObjectProperty("Weight",actualWeight)
		end
	end)

RegisterEventHandler(EventType.Message,"InitSaleItem", 
	function(itemPrice,merchantObj,stackCount)
		if ( this:HasObjVar("TamingDifficulty") ) then
			this:SetObjVar("MobileTeamType", "Villagers")
			SetKarma(this,5000)
			this:SendMessage("UpdateName")
			this:AddModule("guard_protect")
			RemoveUseCase(this, "Inspect")
		else
			SetItemTooltip(this, true)

			if IsStackable(this) then
				-- if no stack size has been set for a stackable item, set the default size.
				if stackCount == nil or stackCount < 1 then
					stackCount = ServerSettings.Merchants.DefaultStackSize
				end
				MerchantUpdateStackCount(this, stackCount)
			elseif(stackCount > 1) then
				this:SetObjVar("NumAvailable",stackCount)
			end
		end
		
		this:SetObjVar("merchantOwner",merchantObj)

		if(itemPrice ~= nil and itemPrice > 0 ) then			
			this:SetObjVar("itemPrice",itemPrice)

			local priceStr = ValueToAmountStr(itemPrice)
			SetTooltipEntry(this,"item_price","Price: "..priceStr.."\n",100)
		end

		AddUseCase(this,"Buy")
		SetOverrideDefaultInteraction(this,"Buy")

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(4 + math.random()),"check_valid")
	end)

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if( usedType ~= "Buy" or user == nil or not(user:IsValid()) or not(user:IsPlayer()) ) then
			return
		end

		if ( this:HasObjVar("TamingDifficulty") and not CanAddToActivePets(user, this) ) then
			user:SystemMessage("You cannot control anymore pets.","info")
			return
		end

		local merchant = this:GetObjVar("merchantOwner")
		if( merchant ~= nil ) then
			local stackCount = this:GetObjVar("StackCount") or 0
			if stackCount > 1 then
				OpenSplitWindow(user, "1")
			else		
				merchant:SendMessage("SellItem",user,this)
			end
		end
	end)

this:ScheduleTimerDelay(TimeSpan.FromSeconds(4 + math.random()),"check_valid")