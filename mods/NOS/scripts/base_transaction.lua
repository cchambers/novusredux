require 'stackable_helpers'

-- This script aids with trade of resources for an item/template
-- It ensures that the transaction completes on both sides
-- It is shared between npc merchants and player run merchants

Merchant = {
	CurrencyInfo =
	{
		CurrencyType = "coins",
		ObjVarName = nil,
		CurrencyDisplayStr = "coins",
		Resource = "coins",
	}
}

activeTransactions = {}


function Merchant.DoPurchase(buyer,item,itemPrice)
	-- THIS NEEDS TO BE OVERRIDDEN BY THE MERCHANT SCRIPT
end

function Merchant.DoCantAfford(buyer)
    -- THIS NEEDS TO BE OVERRIDDEN BY THE MERCHANT SCRIPT
end

function Merchant.DoPurchaseComplete(buyer)
	-- THIS NEEDS TO BE OVERRIDDEN BY THE MERCHANT SCRIPT
end

function Merchant.HasStock(item, amount)
	-- THIS NEEDS TO BE OVERRIDDEN BY THE MERCHANT SCRIPT
end

function Merchant.DoNotEnoughStock(buyer)
	-- THIS NEEDS TO BE OVERRIDDEN BY THE MERCHANT SCRIPT
end

function Merchant.DoOutOfStock(buyer)
	-- THIS NEEDS TO BE OVERRIDDEN BY THE MERCHANT SCRIPT
end

function ClearTransaction(transactionId)
	activeTransactions[transactionId] = nil
end

function ValidateTransaction(curState, transactionId)

	local transactionData = activeTransactions[transactionId]

	-- transaction in wrong state
	if( transactionData == nil or transactionData.State ~= curState ) then		
		return false
	end	

	-- buyer no longer valid
	local buyer = transactionData.Buyer
	if( buyer == nil or not(buyer:IsValid()) ) then		
		return false
	end
	
	local item = transactionData.Item
	-- something happened to the display item
	if( item == nil or not(item:IsValid()) ) then	
		return false
	end

	return true
end

function InitiateTransaction(buyer,buyItem,itemPrice, amount)
	itemPrice = itemPrice or buyItem:GetObjVar("itemPrice")

	if amount < 1 then amount = 1 end

	if IsStackable(buyItem) and amount > 1 then
		itemPrice = itemPrice * amount
	end

	local transactionId = uuid()

	activeTransactions[transactionId] = { State="Confirm", Item=buyItem, Buyer = buyer, Price = itemPrice, Amount = amount }
	ShowTransactionConfirm(transactionId,buyer,buyItem,itemPrice, amount)
end

function ShowTransactionConfirm(transactionId,buyer,buyItem,itemPrice, amount)
	local num = "the"
	local name = ""
	if IsStackable(buyItem) then
		if amount > 1 then
			num = amount
			name = GetPluralName(buyItem)
		else
			num = "a"
			name = GetSingularName(buyItem)
		end
	else
		name = buyItem:GetName()	
	end

	local body = "Do you wish to purchase "..num.." "..StripColorFromString(name).." for "..ValueToAmountStr(itemPrice,false,true).. "?"

	ClientDialog.Show{
	    TargetUser = buyer,
	    DialogId = transactionId,
	    TitleStr = "Confirm Purchase",
	    DescStr = body,
	    Height = 150,
	    Button1Str = "Purchase",
	    Button2Str = "Cancel",
	    ResponseObj = this,
	    ResponseFunc = function (user,buttonId)
				if( buttonId == 0) then
					--Checks if the user is close enough to purchase
					if (CanBuyItem(buyer, buyItem)) then
						local itemTemplate = buyItem:GetObjVar("PurchaseTemplate") or buyItem:GetCreationTemplateId()
						local backpackObj = buyer:GetEquippedObject("Backpack")
						local canCreate, reason = CanCreateItemInContainer(itemTemplate,backpackObj,amount)

						if (canCreate) then
							HandleTransactionConfirm(buyer,transactionId)
						elseif (backpackObj ~= nil) then
							ShowPurchaseOnGroundConfirm(user, buyItem, amount, reason, transactionId)
						end
					end
				else
					ClearTransaction(transactionId)
				end
			end,
	}
end

function ShowPurchaseOnGroundConfirm(user, buyItem, amount, reason, transactionId)
	local num = "the"
	local name = ""
	if IsStackable(buyItem) then
		if amount > 1 then
			num = amount
			name = GetPluralName(buyItem)
		else
			num = "a"
			name = GetSingularName(buyItem)
		end
	else
		name = buyItem:GetName()	
	end

    ClientDialog.Show{
        TargetUser = user,
        ResponseObj = this,
        DialogId = "PurchaseOnGroundWindow",
        TitleStr = "WARNING",
        DescStr = "Purchasing "..num.." "..name.." will cause your backpack to be "..reason..". This action will cause your purchased items to be placed on the ground. Do you wish to purchase?",
        Button1Str = "Ok.",
        Button2Str = "Cancel.",
        ResponseFunc=function(user,buttonId)
            if (user == nil) then return end

            if (buttonId == nil) then return end

            if (buttonId == 0) then
            	HandleTransactionConfirm(user, transactionId)
            end
        end,
    }
end

function HandleTransactionConfirm(user,transactionId)

	if( not(ValidateTransaction("Confirm",transactionId))) then
		DebugMessage("ERROR: HandleTransactionConfirm Failed",tostring(user),tostring(transactionId))
		ClearTransaction(transactionId)
		return
	end

	local transactionData = activeTransactions[transactionId]

	-- make sure they can afford it
	local item = transactionData.Item
	local buyer = transactionData.Buyer
	local price = transactionData.Price
	local amount = transactionData.Amount
	if( Merchant.CurrencyInfo.CurrencyType == "coins" ) then
		if( CountCoins(buyer) < price ) then
			Merchant.DoCantAfford(buyer)
			activeTransactions[transactionId] = nil
			return
		else
			local stockCount = Merchant.CountStock(item)
			if ( stockCount >= amount ) then
				-- everything checks out lets take the coins
				transactionData.State = "TakeCoins"		
				--DebugMessage("price",tostring(price),tostring(transactionId))	
				RequestConsumeResource(buyer,"coins",price,transactionId,this)
			elseif(stockCount == 0) then
				Merchant.DoOutOfStock(buyer)
			else
				Merchant.DoNotEnoughStock(buyer)
			end
		end
	elseif( Merchant.CurrencyInfo.CurrencyType == "objvar" ) then
		curValue = buyer:GetObjVar(Merchant.CurrencyInfo.ObjVarName) or 0
		if( curValue < price ) then
			Merchant.DoCantAfford(buyer)
			activeTransactions[transactionId] = nil
			return
		else
			local stockCount = Merchant.CountStock(item)
			if ( stockCount >= amount ) then
				-- everything checks out 
				buyer:SetObjVar(Merchant.CurrencyInfo.ObjVarName, curValue - price)
				Merchant.DoPurchase(transactionData.Buyer,transactionData.Item)
			elseif(stockCount == 0) then
				Merchant.DoOutOfStock(buyer)
			else
				Merchant.DoNotEnoughStock(buyer)
			end
		end
	elseif (Merchant.CurrencyInfo.CurrencyType == "resource") then
		local resourceType = Merchant.CurrencyInfo.Resource
		if (resourceType == nil) then
			LuaDebugCallStack("CURRENCY RESOURCE IS NIL") 
			return
		end
		if( CountResourcesInContainer(buyer,resourceType) < price ) then
			Merchant.DoCantAfford(buyer)
			activeTransactions[transactionId] = nil
			return
		else
			local stockCount = Merchant.CountStock(item)
			if ( stockCount >= amount ) then
				-- everything checks out lets take the coins
				transactionData.State = "TakeCoins"			
				RequestConsumeResource(buyer,resourceType,price,transactionId,this)
			elseif(stockCount == 0) then
				Merchant.DoOutOfStock(buyer)
			else
				Merchant.DoNotEnoughStock(buyer)
			end
		end
	end
end

function HandleConsumeResourceResponse(success,transactionId,buyer)		
	if( not(ValidateTransaction("TakeCoins",transactionId))) then
		activeTransactions[transactionId] = nil
		return
	end

	-- something went wrong taking the coins
	if( not(success) ) then
		DebugMessage("ERROR: HandleConsumeResourceResponse failed",tostring(transactionId),tostring(buyer))
		Merchant.DoCantAfford(buyer)		
	-- we have taken the coins complete the transaction
	else
		local transactionData = activeTransactions[transactionId]
		Merchant.DoPurchase(transactionData.Buyer,transactionData.Item,transactionData.Price, transactionData.Amount)		
	end

	activeTransactions[transactionId] = nil
end

RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", HandleConsumeResourceResponse)