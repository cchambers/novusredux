function GetOwnerMerchant()
	local itemOwner = this:GetObjVar("itemOwner")
	local topMost = this:TopmostContainer() or this
	-- DAB TODO: THIS ASSUMES EACH PLAYER CAN ONLY HAVE ONE MERCHANT
	return FindObject(SearchMulti
									   {
								    	   SearchMobileInRange(20),
										   SearchModule("ai_hireling_merchant"),
										   SearchObjVar("HirelingOwner",itemOwner)
									   },topMost)
end

function OnLoad()
	if (this:GetSharedObjectProperty("DenyPickup") == false) then
		this:SetSharedObjectProperty("DenyPickup", true)
		local itemTemplate = this:GetCreationTemplateId()
		local originalWeight = this:GetObjVar("OriginalWeight")
		if (originalWeight ~= nil) then
			this:SetSharedObjectProperty("Weight",originalWeight)
		end
	end
end

function RemoveFromSale(buyer)
	this:DelObjVar("OriginalWeight")
	
	this:DelObjVar("itemOwner")
	this:DelObjVar("itemPrice")
	this:SetSharedObjectProperty("DenyPickup", false)
	this:DelObjVar("LockedDown")

	local merchant = this:GetObjVar("merchantOwner")
	local merchantSaleItem = merchant:GetObjVar("merchantSaleItem")
	if (merchant:GetObjVar("merchantSaleItem") ~= nil) then
		for key,value in pairs(merchantSaleItem) do
			if (value == this) then
				table.remove(merchantSaleItem, key)
				break
			end
		end
		merchant:SetObjVar("merchantSaleItem",merchantSaleItem)
	end

	RemoveTooltipEntry(this,"item_price")

	RemoveUseCase(this,"Buy")
	ClearOverrideDefaultInteraction(this)
	--DebugMessage("Yes, exactly what you think is happening is happening.")
	RemoveUseCase(this,"Remove from Sale")
	this:DelModule("hireling_merchant_sale_item")
	this:DelObjVar("NoReset")

	local stackCount = this:GetObjVar("StackCount") or 1
	if ( stackCount > 1 ) then
		AddUseCase(this,"Split Stack", false)
	end

	if(buyer ~= nil) then
		local backpackObj = buyer:GetEquippedObject("Backpack")
	    if(backpackObj) then
	        local dropPos = GetRandomDropPosition(backpackObj)
	        local success,reason = TryPutObjectInContainer(this, backpackObj, dropPos)
	        if not(success) then
	            buyer:SystemMessage(reason.." The item has fell to the ground.")
	            this:SetWorldPosition(buyer:GetLoc())
	        end
	    else
	        this:SetWorldPosition(buyer:GetLoc())
	    end
	end
end

RegisterEventHandler(EventType.Timer, "check_valid", 
	function ()
		local isInOwnerHouse = true		
		local containingHouse = GetContainingHouseForObj(this)
		if not(containingHouse) then
			isInOwnerHouse = false
		else
			local houseOwner = containingHouse:GetObjVar("Owner")
			local itemOwner = this:GetObjVar("itemOwner")
			if(houseOwner ~= itemOwner) then
				isInOwnerHouse = false
			end
		end		

		if not(isInOwnerHouse) then
			RemoveFromSale()
		else
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(100 + math.random()),"check_valid_hireling")
		end
	end)

RegisterEventHandler(EventType.ModuleAttached,"hireling_merchant_sale_item", 
	function()
		if(IsLockedDown(this)) then
			ReleaseObject(this)
		end

		if(this:DecayScheduled()) then
            this:RemoveDecay()
        end

        this:SetObjVar("NoReset",true)
		this:SetObjVar("LockedDown",true)
		this:SetSharedObjectProperty("DenyPickup", true)
		
		this:SetObjVar("itemOwner",initializer.Owner)

		if ( HasUseCase(this,"Split Stack") ) then
			RemoveUseCase(this,"Split Stack")
		end

		if(initializer.Price ~= nil and initializer.Price > 0 ) then
			this:SetObjVar("itemPrice",initializer.Price)

			local priceStr = ValueToAmountStr(initializer.Price)
			SetTooltipEntry(this,"item_price","Price: "..priceStr.."\n",100)
		end

		local merchant = GetOwnerMerchant()
		if (merchant ~= nil) then
			this:SetObjVar("merchantOwner", merchant)
		end
		local merchantSaleItem = merchant:GetObjVar("merchantSaleItem")
		local testing = nil
		if (merchantSaleItem == nil) then
			merchantSaleItem = {}
		end

		table.insert(merchantSaleItem, this)
		merchant:SetObjVar("merchantSaleItem",merchantSaleItem)

		AddUseCase(this,"Buy")
		SetOverrideDefaultInteraction(this,"Buy")
		AddUseCase(this,"Remove from Sale",false,"OwnsContainedHouse")

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(4 + math.random()),"check_valid_hireling")
	end)

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if( user == nil or not(user:IsValid()) or not(user:IsPlayer()) ) then
			return
		end
		--DebugMessage(usedType)
		if(usedType == "Buy" or usedType == "Use") then
			local playerOwner = this:GetObjVar("itemOwner")
			-- DAB TODO: THIS ASSUMES EACH PLAYER CAN ONLY HAVE ONE MERCHANT
			local merchant = GetOwnerMerchant()

			if( merchant ~= nil ) then			
				merchant:SendMessage("SellItem",user,this)
			end
		elseif(usedType == "Remove from Sale") then
			local playerOwner = this:GetObjVar("itemOwner")
			if(not(IsGod(user)) and playerOwner ~= user) then
				return
			end
			
			RemoveFromSale()
		end
	end)
RegisterEventHandler(EventType.LoadedFromBackup,"",function ( ... )
		-- body
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(4 + math.random()),"check_valid_hireling")
	end)

RegisterEventHandler(EventType.Message, "RemoveFromSale", RemoveFromSale)

RegisterSingleEventHandler(EventType.LoadedFromBackup,"",
	function ( ... )
		OnLoad()
	end)