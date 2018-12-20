CraftingOrderTable = nil

require 'base_ai_mob'
require 'base_ai_settings'
require 'base_transaction'
require 'merchant_helpers'

function IsFriend(target)
    --My only enemy is the enemy
    if (AI.InAggroList(target)) then
        --DebugMessage(1)
        return false
    else
        --DebugMessage(2)
        return true
    end
end

AI.Settings.CanWander = false


MINIMUM_STACK_VALUE = 10

this:SetObjVar("IsMerchant",true)

if (AI == nil) then
	AI={}
end

AI.MerchantSellerSpeech = {
    "What you see is what you get.",
    "Prices are final. Sorry.",
    "The price is right there.",
    "Well if you're looking, you'll find it here!",
    "I sell only the best wares!",
    "We'll have more in stock tomorrow.",
    "Do you have enough coins?"
}

AI.HowToPurchaseMessages = {
	"[$1664]"
}

AI.InteractMessages = 
{
	"What can I help you with today, my good friend?",
}

AI.NotInterestedMessage = 
{
	"I'm not interested in that.",
}

AI.NotYoursMessage = {
	"That is not yours to sell!",
}

AI.CantAffordPurchaseMessages = {
	"[$1665]"
}

function GetModifiedBuyerPrice(itemPrice, buyer)
	-- DAB TODO: MERCHANT REPUTATION CAN GET SO HIGH THAT MERCHANTS PAY YOU TO BUY STUFF
	do return itemPrice end

	if (itemPrice == nil) then
		LuaDebugCallStack("[base_merchant] Error: itemPrice == nil")
	end
	--D*ebugMessage("b" .. tostring(buyer))
	--local buyerPriceMod = buyer:GetObjVar("merchantReputation") or 1
	--if(buyerPriceMod > 0) then
	--	buyerPriceMod =100 - (buyerPriceMod / 4)
	--else
	--	buyerPriceMod = 100 - (buyerPriceMod * 2.5)
	----end
	
	--DebugMessage("itemPrice: ".. itemPrice)
	--itemPrice = (itemPrice * buyerPriceMod) / 100
	return math.ceil(itemPrice)
end

function GetModifiedSellValue(itemValue,seller)
	-- DAB TODO: MERCHANT REPUTATION CAN GET SO HIGH THAT MERCHANTS PAY YOU TO BUY STUFF
	do return itemPrice end

	local sellerPriceMod = seller:GetObjVar("merchantReputation") or 1

	if(sellerPriceMod > 0) then
		sellerPriceMod =100 - (sellerPriceMod / 4)
	else
		sellerPriceMod = 100 + (sellerPriceMod * .8)
	end
	--DebugMessage("itemValue: ".. itemValue)
	--DebugMessage("sellerPriceMod:" ..sellerPriceMod)
	itemValue = (itemValue * sellerPriceMod) / 100
	return math.ceil(itemValue)
end

function CanUserSell(item,user)
	local topmost = item:TopmostContainer() or item
	if( topmost ~= user ) then		
		return false
	end	
	if (IsDead(this)) then 
		return false
	end
	if (this:DistanceFrom(user) > OBJECT_INTERACTION_RANGE) then
		return false
	end

	return true
end

function GetItemSellValue(item,user)	
	return (GetItemValue(item,Merchant.CurrencyInfo.Resource) * 0.5)	
end

function GetItemPurchaseValue(item,user)
	return math.ceil(GetItemValue(item,Merchant.CurrencyInfo.Resource) * 1)	
end

function ValidateSellItem(item,user)
	local resourceType = item:GetObjVar("ResourceType")
	if (resourceType == "coins") then
		QuickDialogMessage(this,user,"[$1666]")
		return 0
	end
	if( not(CanUserSell(item,user)) ) then
    	QuickDialogMessage(this,user,AI.NotYoursMessage[math.random(1,#AI.NotYoursMessage)])
    	return 0
    end
    local sellValue = GetItemSellValue(item,user)

    --DebugMessage("Initial Sell Val: " ..sellValue)
    if( sellValue == 0 ) then
    	QuickDialogMessage(this,user,AI.NotInterestedMessage[math.random(1,#AI.NotInterestedMessage)])
    	return 0
    end

    return sellValue
end

function GiveCurrency(user,amount)
	local backpackObj = user:GetEquippedObject("Backpack")
	if( backpackObj ~= nil ) then
		-- todo: make an easier way to create stacks
    	local packObjects = backpackObj:GetContainedObjects()
     	for index, packObj in pairs(packObjects) do	
     		--note that this is why we now have a default resource of coins,
     		--DFB TODO: Add functionality to sell objvar values
     		if( packObj:GetObjVar("ResourceType") == Merchant.CurrencyInfo.Resource ) then
     			RequestAddToStack(packObj,amount)
     			return
     		end
     	end
     	if (Merchant.CurrencyInfo.CurrencyType == "coins") then
    		CreateObjInBackpack(user,"coin_purse","merchant_sell_coins",amount)
    	else
	        local templateId = ResourceData.ResourceInfo[Merchant.CurrencyInfo.Resource].Template
    		CreateObjInBackpack(user,templateId,"merchant_sell_coins",amount)
    	end
    end
end

function Merchant.DoPurchase(buyer, item, price, amount)
	local itemTemplate = item:GetObjVar("PurchaseTemplate") or item:GetCreationTemplateId()
	local createSuccess = false
	if (not CanBuyItem(buyer,item)) then
		return
	end
	if ( item:HasObjVar("TamingDifficulty") ) then
		local createId = uuid() .. "CreatePet"
		RegisterSingleEventHandler(EventType.CreatedObject, createId, function(success, objRef)
			if ( success ) then
				SetCreatureAsPet(objRef, buyer)
			end
		end)
		CreateObj(itemTemplate, buyer:GetLoc(), createId)
		createSuccess = true
	else
		local backpackObj = buyer:GetEquippedObject("Backpack")
		-- TODO: Verify creation success and refund money on failure
		if( backpackObj ~= nil ) then			
			-- first try to stack
			local resourceType = item:GetObjVar("ResourceType")
			if( TryAddToStack(resourceType, backpackObj, amount) ) then			
				createSuccess = true
			end
		end

		-- create item since it didn't stack, will go to ground if can't add to backpack
		if (createSuccess == false) then
			local createId = "created_stack_item_"..uuid()
			RegisterSingleEventHandler(EventType.CreatedObject, createId,
				function(success, objRef, amount, template, buyer)
					if success then

						local canCreate,reason = CanCreateItemInContainer(template,backpackObj, amount)
						if not (canCreate) then
							objRef:SetWorldPosition(buyer:GetLoc())
						end
						if amount > 1 then
							RequestSetStack(objRef,amount)
						end
						SetItemTooltip(objRef)
						
					end
				end)
			local canCreateInBag, reason = CreateObjInBackpackOrAtLocation(buyer, itemTemplate, createId, amount, itemTemplate, buyer)
			createSuccess = true
			if not(canCreateInBag) then
				buyer:SystemMessage(reason)
			end
		end
	end

	if (createSuccess) then
		-- item bought, update stock of merchant for item.
		if Merchant.UpdateStock(this, item, amount) then
			Merchant.DoPurchaseComplete(buyer)
		end
	end	
end

function Merchant.DoAppraise(user)
	-- start the appraisal process
	user:RequestClientTargetGameObj(this, "merchant_appraise")
end

function Merchant.DoSell(user)
	-- start the sale process
	backpackObj = user:GetEquippedObject("Backpack")
    backpackObj:SendOpenContainer(user)
	user:SystemMessage("[$1667]","info")
	user:RequestClientTargetGameObj(this, "merchant_sell")
end

function Merchant.DoCantAfford(buyer)
	QuickDialogMessage(this,buyer,AI.CantAffordPurchaseMessages[math.random(1,#AI.CantAffordPurchaseMessages)],-1)
end

function Merchant.DoPurchaseComplete(buyer)
	local myRep = buyer:GetObjVar("merchantReputation") or 0
    myRep = myRep + .1
    buyer:SetObjVar("merchantReputation", myRep)
	QuickDialogMessage(this,buyer,"Thank you for your patronage "..buyer:GetName()..".",-1)
end

function HandleSaleItemCreated(success, objRef, position)
	if ( success ) then
		local stockData = this:GetObjVar("StockData")
		stockData = stockData.ItemInventory
		
		if ( stockData[position] == nil ) then
			LuaDebugCallStack("ERROR: Position not found in StockData")
			DebugTable(stockData)
			--DebugMessage("Position ", position)
			objRef:Destroy()
			return
		end

		objRef:SetObjVar("PurchaseTemplate",stockData[position].Template)

		local price = tonumber(stockData[position].Price)
		if ( price == nil or price == 0 ) then price = GetItemPurchaseValue(objRef) end
		if ( price == nil or price == 0 ) then
			DebugMessage("ERROR: Item for sale has no calculated value! " .. objRef:GetCreationTemplateId())
			objRef:Destroy()
		else
			if ( stockData[position].UnlimitedStock ) then
				objRef:SetObjVar("UnlimitedStock", true)
			end
			if ( stockData[position].UniqueId ) then
				objRef:SetObjVar("MerchantUniqueId", stockData[position].UniqueId)
			end
			local amount = ServerSettings.Merchants.DefaultStackSize or 1
			if ( stockData[position].Amount ~= nil ) then
				amount = tonumber(stockData[position].Amount)
			end
			objRef:SetObjVar("StockPosition", position)
			AddToStock(this, position, objRef)
			objRef:AddModule("merchant_sale_item")
			objRef:SendMessage("InitSaleItem", price, this, amount)			
		end
	end
end

function CanBuyItem(buyer, item)
	if (IsDead(this)) then 
		return false
	end
	if (item == nil) then 
		return false
	end
	if (buyer == nil) then 
		return false 
	end

	local topmost = item:TopmostContainer() or item
	if (topmost:DistanceFrom(buyer) > OBJECT_INTERACTION_RANGE) then
		buyer:SystemMessage("Too far away.", "info")
		return false
	end
	return true
end

function HandleSellItem(buyer,item, amount)
	if( buyer == nil or not(buyer:IsValid()) ) then return end
	if( item == nil or not(item:IsValid()) ) then return end
	if( amount == nil) then amount = 0 end
	if (not CanBuyItem(buyer,item)) then return end
	
	local itemPrice = item:GetObjVar("itemPrice") or 0
	if(itemPrice == 0) then 
		itemPrice = math.floor(0.5+GetItemValue(item,Merchant.CurrencyInfo.Resource))
	end
	itemPrice = GetModifiedBuyerPrice(itemPrice, buyer)

	InitiateTransaction(buyer,item,itemPrice, amount)
end

function HandleAppraiseTargeted(target,user)
	if( target == nil or not target:IsValid()) then return end
	--DebugMessage("Target = "..tostring(target:GetName())) 
    if( user == nil or not(user:IsValid())) then return end

    if (user:DistanceFrom(this) > 20) then
    	return 
    end

    local sellValue = ValidateSellItem(target,user)
    local stackCount = GetStackCount(target)

	local dur = target:GetObjVar("Durability")
	local durabilityStr = ""
	if (dur ~= nil) then
		durabilityStr = GetDurabilityString(target)
	end

    if( sellValue > 0 ) then
    	--DebugMessage(sellValue,dur)
    	if (not IsStackable(target) and sellValue < 1) then
    		QuickDialogMessage(this,user,"That's worthless. I would never buy that.")
    		return
    	end
    	if (stackCount < MINIMUM_STACK_VALUE and sellValue/stackCount < 1) then
    		local SingularName = target:GetObjVar("SingularName") or target:GetName()
    		QuickDialogMessage(this,user,SingularName.."[$1668]"..tostring(MINIMUM_STACK_VALUE)..".\n\nThe amount you have there is worthless.")
    		Merchant.DoAppraise(user)
    		return
    	end

    	local amountToSell = stackCount
		local amount = math.ceil(amountToSell * sellValue)
    	if (sellValue < 1) then
    		local SingularName = target:GetObjVar("SingularName") or target:GetName()
    		local remainder = stackCount % MINIMUM_STACK_VALUE    		
    		amountToSell = stackCount - remainder
    		--DebugMessage("INFO",sellValue,stackCount,amountToSell,amount)
    		QuickDialogMessage(this,user,SingularName.."[$1669]"..tostring(MINIMUM_STACK_VALUE)..".\n\nI'd give you "..math.ceil(amount).." "..Merchant.CurrencyInfo.CurrencyDisplayStr.." for "..tostring(amountToSell).." of them. No more.")
    		Merchant.DoAppraise(user)
    		return
    	end

    	QuickDialogMessage(this,user,"I'll give you "..math.ceil(amount).." "..Merchant.CurrencyInfo.CurrencyDisplayStr.." for the "..durabilityStr.." "..target:GetName())
    	Merchant.DoAppraise(user)
    end
end

function GetSellValue(item, user)
	local sellValue = ValidateSellItem(item,user)
	local stackCount = GetStackCount(item)
	if ( sellValue > 0 ) then
		sellValue = math.floor(sellValue * stackCount)
	else
		sellValue = 0
	end
    if ( (sellValue * stackCount) < 1 ) then
    	QuickDialogMessage(this,user,"[$1671]")
    	return nil
    end
    if ( item:GetObjVar("Durability") ~= nil ) then
    	QuickDialogMessage(this,user,"[$1670]")
    	return nil
    end

	return sellValue
end

function HandleSellTargeted(target,user)
	if( target == nil or not target:IsValid()) then return end
	--DebugMessage("Target = "..tostring(target:GetName())) 
    if( user == nil or not(user:IsValid())) then return end

    if (user:DistanceFrom(this) > 20) then
    	return 
    end
    
	local sellValue = GetSellValue(target, user)
	if ( sellValue == nil ) then return end

	local body = "Sell "..StripColorFromString(target:GetName()).." for "..ValueToAmountStr(sellValue,false,true).. "?"

	ClientDialog.Show{
	    TargetUser = user,
	    DialogId = transactionId,
	    TitleStr = "Confirm Sell",
	    DescStr = body,
	    Height = 150,
	    Button1Str = "Sell",
	    Button2Str = "Cancel",
	    ResponseObj = this,
	    ResponseFunc = function (user,buttonId)
				if( buttonId == 0) then
					HandleSellConfirm(target,user)
				end
			end,
	}

end
	
function HandleSellConfirm(target,user)
	if( target == nil or not target:IsValid() ) then return end
    if( user == nil or not user:IsValid() ) then return end

	local sellValue = GetSellValue(target, user)
	if ( sellValue == nil ) then return end

	target:Destroy()
	-- TODO: Handle other currencies
	GiveCurrency(user, sellValue)
	
	local myRep = user:GetObjVar("merchantReputation") or 0
	myRep = myRep + .1
	user:SetObjVar("merchantReputation", myRep)

	user:SystemMessage("You receive " .. ValueToAmountStr(sellValue,false,true) .. ".", "info")

	QuickDialogMessage(this,user,"Here is your "..ValueToAmountStr(sellValue,false,true)..". Thank you for your patronage "..user:GetName()..".")

    Merchant.DoSell(user)
end

RegisterEventHandler(EventType.CreatedObject, "merchant_sell_coins", 
	function(success,objRef,amount)
		if(success and amount > 1) then
			RequestSetStack(objRef,amount)
		end
	end
)

function SetNPCDialogTimer()
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1500), "RespondNPC")
end

function SpeakToNPC()
	this:NpcSpeech(AI.MerchantSellerSpeech[math.random(1,#AI.MerchantSellerSpeech)])
end

function GetNearestGuard(regionName)
	local nearbyGuards = nil
	if (regionName == nil) then
	nearbyGuards = FindObjects(SearchMulti(
		    {
		        SearchMobileInRange(15),
		        SearchHasObjVar("IsGuard"),
		    }))
	else
	nearbyGuards = FindObjects(SearchMulti(
		    {
		        SearchMobileInRegion(regionName),
		        SearchHasObjVar("IsGuard"),
		    }))
	end
	if (nearbyGuards == nil) then return nil end
	local nearestGuard = nil
	local nearestDistance = 0
	for index, guardObj in pairs(nearbyGuards) do
		local distance = this:DistanceFrom(guardObj)
		if( nearestGuard == nil or distance < nearestDistance) then
			nearestGuard = guardObj
			nearestDistance = distance
		end
	end

	return nearestGuard
end

RegisterEventHandler(EventType.CreatedObject, "sale_item_created", HandleSaleItemCreated)
RegisterEventHandler(EventType.Message,"SellItem", HandleSellItem)
RegisterEventHandler(EventType.Message,"NPCAskPrice", SetNPCDialogTimer)
RegisterEventHandler(EventType.Timer,"RespondNPC", SpeakToNPC)
RegisterEventHandler(EventType.ClientTargetGameObjResponse, "merchant_appraise", HandleAppraiseTargeted)
RegisterEventHandler(EventType.ClientTargetGameObjResponse, "merchant_sell", HandleSellTargeted)



function CreateSaleItem(position, merchantContainers, stockData)
	stockData = stockData or this:GetObjVar("StockData")
	if ( stockData.ItemInventory ) then
		stockData = stockData.ItemInventory
	end

	if ( stockData[position] == nil ) then
		LuaDebugCallStack("Position not found in StockData")
		DebugTable(stockData)
		DebugMessage("Position ", position)
		return
	end

	if ( stockData[position].RelativeLoc ~= nil ) then
		if ( stockData[position].Container ~= nil and merchantContainers[stockData[position].Container] ~= nil) then
			itemLoc = ParseLoc(stockData[position].RelativeLoc)
		else
			itemLoc = this:GetLoc():Add(ParseLoc(stockData[position].RelativeLoc))
		end
	else
		itemLoc = ParseLoc(stockData[position].Loc)
	end
	
	local itemRot = Loc(0,0,0)
	local itemScale = Loc(1,1,1)
	if ( stockData[position].Rotation ~= nil ) then
		itemRot = ParseLoc(stockData[position].Rotation)
	end

	--DebugMessage("A "..tostring(itemLoc))
	if ( itemLoc ~= nil ) then
		local containerObject = nil
		if ( stockData[position].Container ~= nil and merchantContainers[stockData[position].Container] ~= nil ) then
			containerObject = merchantContainers[stockData[position].Container]				
		end

		if( stockData[position].Container ~= nil and containerObject == nil ) then
			DebugMessage("ERROR: [Merchant:Init] Merchant container not found "..this:GetName().." for item "..stockData[position].Template.." container "..stockData[position].Container)
			return
		else
			local amount = 1
			if ( stockData[position].Amount ~= nil ) then
				amount = tonumber(stockData[position].Amount)
			end
			--DebugMessage("Template: "..tostring(stockData[position].Template).." Location:"..tostring(itemLoc))
			local displayTemplate = stockData[position].DisplayTemplate or stockData[position].Template
			CreateObjExtended(displayTemplate,containerObject,itemLoc,itemRot,itemScale,"sale_item_created",position)
		end
	end
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),function ( ... )
	AddUseCase(this,"Interact",true)
	
	if (AI.GetSetting("MerchantEnabled")) then
		AddUseCase(this,"Sell",false)
		AddUseCase(this,"Appraise",false)
	end
	if (AI.GetSetting("EnableBank")) then
		AddUseCase(this,"Bank",false)
	end
	-- if (AI.GetSetting("EnableTax")) then
	-- 	AddUseCase(this,"Tax",false)
	-- end
	if (this:GetObjVar("CraftOrderSkill") ~= nil) then
		CraftingOrderTable = CraftingOrderDefines[this:GetObjVar("CraftOrderSkill")]
		this:ScheduleTimerDelay(TimeSpan.FromMinutes(60), "ChangeOrder")
	end
end)

RegisterEventHandler(EventType.CreatedObject, "CreatedCraftingOrder", 
	function (success, objRef, orderInfo, user)
		objRef:SetObjVar("OrderInfo", orderInfo)
		objRef:SetObjVar("OrderOwner", user)
		objRef:SetObjVar("OrderSkill", this:GetObjVar("CraftOrderSkill"))
	end)

RegisterEventHandler(EventType.Message,"UseObject",function (user,useType)
	if not (useType == "Sell" or useType == "Appraise" or useType == "Bank" ) then return end

	if (useType == "Sell") then
		Merchant.DoSell(user)
	elseif (useType == "Appraise") then
		Merchant.DoAppraise(user)
	elseif (useType == "Bank" and AI.GetSetting("EnableBank")) then
		OpenBank(user,this)
	elseif (useType == "Tax" and AI.GetSetting("EnableTax")) then
		OpenTax(user,this)
	end
end)

RegisterEventHandler(EventType.Timer, "ChangeOrder", 
	function ()
		this:DelObjVar("Commissions")
		this:ScheduleTimerDelay(TimeSpan.FromMinutes(60), "ChangeOrder")
	end)

function Restock()
	local restockInSeconds = ServerSettings.Merchants.DefaultRestockInSeconds
	-- get the current stock
	local currentStock = GetMerchantStock(this)
	-- get the data that represents a fully stocked vendor
	local stockData = this:GetObjVar("StockData")

	if ( stockData ~= nil and stockData.ItemInventory ~= nil) then
		-- get the in game objects for the containers
		local merchantContainers = GetMerchantContainerObjects(stockData)

		-- loop the item inventory
		for position,data in pairs(stockData.ItemInventory) do
			local stockItem = currentStock[position]
			local itemMissing = not(stockItem) or not stockItem:IsValid()			

			-- if the item exists but is out of stock, destroy it and mark it missing
			if (not(itemMissing) and stockItem:HasObjVar("OutOfStock")) then
				stockItem:Destroy()
				itemMissing = true
			end

			if (itemMissing) then
				-- item not in stock (doesn't exist) create it.
				CreateSaleItem(position, merchantContainers, stockData)
			else
				-- item is in stock, check if it's stackable
				if ( currentStock[position] and IsStackable(currentStock[position]) ) then
					local maxStack = data.Amount or ServerSettings.Merchants.DefaultStackSize
					if ( maxStack ~= currentStock[position]:GetObjVar("StackCount") ) then
						-- update the stack back to full
						MerchantUpdateStackCount(currentStock[position], maxStack)
					end
				end
				-- don't have to re-stock existing non-stackable items
			end
		end

		if ( stockData.RestockIntervalSeconds ~= nil ) then
			restockInSeconds = stockData.RestockIntervalSeconds
		end

	end
	--DebugMessage(this:GetName().." will restock again in "..restockInSeconds.." seconds")
	this:SetObjVar("LastRestock", DateTime.UtcNow)
	-- stagger the resocks so they don't all fire in the same moment
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(restockInSeconds + math.random(0, 0)), "RestockTimer")
end
RegisterEventHandler(EventType.Timer, "RestockTimer", Restock)

--- Get the game objects that represent each merchant container.
function GetMerchantContainerObjects(stockData)
	local merchantContainers = {}
	if ( stockData.MerchantContainers ~= nil ) then
		for position,data in pairs(stockData.MerchantContainers) do
			local findResult = FindObjects(SearchMulti({
				SearchObjectInRange(10),
				SearchObjVar("merchantContainer", data.Name),
			}))

			if( #findResult > 0 ) then				
				local containerObject = findResult[1]

				merchantContainers[data.Name] = containerObject

				if ( data.DisplayName ~= nil ) then
					containerObject:SetName(data.DisplayName)
				end

				if ( data.TooltipStr ~= nil ) then
					SetTooltipEntry(containerObject, "merchant_container", data.TooltipStr)
				end

			end
		end
	end
	return merchantContainers
end

-- On first run save the data needed to restock as an object variable
if ( initializer ~= nil ) then
	local stockData = {
		MerchantContainers = initializer.MerchantContainers,
		ItemInventory = initializer.ItemInventory,
		RestockIntervalSeconds = initializer.RestockIntervalSeconds,
	}
	this:SetObjVar("StockData", stockData)
	--- Set all stock to false (no stock)
	if(stockData.ItemInventory) then
		SetInitialMerchantStock(this, #stockData.ItemInventory)
		-- Do the initial restock
		Restock()
	end
elseif not( this:HasTimer("RestockTimer") ) then
	Restock()
end