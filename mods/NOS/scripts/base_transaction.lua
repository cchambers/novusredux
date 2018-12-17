require 'default:base_transaction'

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
	local buyerBank = buyer:GetEquippedObject("Bank")
	local bankWorth = CountResourcesInContainer(buyerBank,"coins")
	local price = transactionData.Price
	local amount = transactionData.Amount
	if( Merchant.CurrencyInfo.CurrencyType == "coins" ) then
		if( bankWorth < price ) then
			Merchant.DoCantAfford(buyer)
			activeTransactions[transactionId] = nil
			return
		else
			local stockCount = Merchant.CountStock(item)
			if ( stockCount >= amount ) then
				-- everything checks out lets take the coins
				transactionData.State = "TakeCoins"		
				--DebugMessage("price",tostring(price),tostring(transactionId))	
				RequestConsumeResource(buyerBank,"coins",price,transactionId,this)
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

