
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

local _merchantOwner
function GetMerchantOwner()
	if ( _merchantOwner == nil ) then
		_merchantOwner = this:GetObjVar("merchantOwner")
	end
	return _merchantOwner
end

local _merchantPlot
function GetMerchantPlot(merchantOwner)
	if ( _merchantPlot == nil and merchantOwner ~= nil and merchantOwner:IsValid() ) then
		_merchantPlot = merchantOwner:GetObjVar("PlotController")
	end
	return _merchantPlot
end

function IsItemOwner(user)
	local merchant = GetMerchantOwner()
	if ( merchant ) then
		local plot = GetMerchantPlot(merchant)
		if ( plot ) then
			return Plot.IsOwner(user, plot)
		end
	end
	return false
end

function RemoveFromSale(buyer)
	this:DelObjVar("OriginalWeight")
	
	this:DelObjVar("itemOwner")
	this:DelObjVar("itemPrice")
	this:SetSharedObjectProperty("DenyPickup", false)
	this:DelObjVar("LockedDown")

	local merchant = GetMerchantOwner()
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

	this:DelObjVar("merchantOwner")

	this:DelModule("hireling_merchant_sale_item")
end

RegisterEventHandler(EventType.Timer, "check_valid_hireling", 
	function ()
		local merchant = GetMerchantOwner()
		if ( merchant and merchant:IsValid() and merchant:HasObjVar("ShopLocation") ) then
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(math.random(100,200)),"check_valid_hireling")
		else
			RemoveFromSale()
		end
	end)

RegisterEventHandler(EventType.ModuleAttached,"hireling_merchant_sale_item", 
	function()
		if( IsLockedDown(this) ) then ReleaseObject(this) end

		if ( this:DecayScheduled() ) then this:RemoveDecay() end

        this:SetObjVar("NoReset",true)
		this:SetObjVar("LockedDown",true)
		this:SetSharedObjectProperty("DenyPickup", true)

		if ( HasUseCase(this,"Split Stack") ) then
			RemoveUseCase(this,"Split Stack")
		end

		if(initializer.Price ~= nil and initializer.Price > 0 ) then
			this:SetObjVar("itemPrice",initializer.Price)

			local priceStr = ValueToAmountStr(initializer.Price)
			SetTooltipEntry(this,"item_price","Price: "..priceStr.."\n",100)
		end

		_merchantOwner = initializer.Merchant
		this:SetObjVar("merchantOwner", _merchantOwner)
		local merchantSaleItem = _merchantOwner:GetObjVar("merchantSaleItem") or {}
		merchantSaleItem[#merchantSaleItem+1] = this
		_merchantOwner:SetObjVar("merchantSaleItem", merchantSaleItem)

		AddUseCase(this,"Buy")
		SetOverrideDefaultInteraction(this,"Buy")
		AddUseCase(this,"Remove from Sale",false,"HasPlotControl") --TODO this should be HasMerchantControl

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(5), "check_valid_hireling")
	end)

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if( user == nil or not(user:IsValid()) or not(user:IsPlayer()) ) then
			return
		end
		--DebugMessage(usedType)
		if ( usedType == "Buy" or usedType == "Use" ) then
			local merchant = GetMerchantOwner()
			if ( merchant ~= nil ) then			
				merchant:SendMessage("SellItem",user,this)
			end
		elseif( usedType == "Remove from Sale" ) then
			if ( IsItemOwner(user) ) then
				RemoveFromSale()
				user:SystemMessage("The item is no longer for sale.","info")
			end
		end
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"", function ()
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(math.random(5,20)),"check_valid_hireling")
	OnLoad()
end)

RegisterEventHandler(EventType.Message, "RemoveFromSale", RemoveFromSale)