require 'default:globals.mobile_extensions_misc'

function RequestConsumeResource(target,resourceType,amount,transactionId,responseObj, ...)
	if (resourceType == "coins") then
		target:SendMessage("ConsumeCoins", amount, transactionId, responseObj, ...)
	else
		target:SendMessage("ConsumeResource", resourceType, amount, transactionId, responseObj, ...)
	end
end

function CountCoins(target)

	local total = 0
	local bankObj = target:GetEquippedObject("Bank")
	if( bankObj == nil ) then
		return 0
	end
	
	local backpackObj = target:GetEquippedObject("Backpack")
	if( backpackObj == nil ) then
		return 0
	end

	total = CountResourcesInContainer(bankObj,"coins")
	total = total + CountResourcesInContainer(backpackObj,"coins")	

	return total
end