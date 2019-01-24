require 'default:globals.mobile_extensions_misc'

function RequestConsumeResource(target,resourceType,amount,transactionId,responseObj, ...)
	if (resourceType == "coins") then
		target:SendMessage("ConsumeCoins", amount, transactionId, responseObj, ...)
	else
		target:SendMessage("ConsumeResource", resourceType, amount, transactionId, responseObj, ...)
	end
end

function CountCoins(target)
	local bankObj = target:GetEquippedObject("Bank")
	if( bankObj == nil ) then
		return 0
	end

	return CountResourcesInContainer(bankObj,"coins")	
end