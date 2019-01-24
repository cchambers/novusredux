require 'default:globals.mobile_extensions_misc'

function RequestConsumeResource(target,resourceType,amount,transactionId,responseObj, ...)	
	if (resourceType == "coins") then
		target:SendMessage("ConsumeCoins", amount, transactionId, responseObj, ...)
	else
		target:SendMessage("ConsumeResource",resourceType, amount, transactionId, responseObj, ...)
	end
end