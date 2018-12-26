require 'default:base_mobile_advanced'
-- remove the specified amount from the players inventory, the objects are identified by the resource type
function HandleConsumeCoins(resourceType,amount,transactionId,responseObj,...)
	local success = false

	--DebugMessage(tostring(resourceType) .."   ".. tostring(amount) .."   "..tostring(transactionId) .."   "..tostring(response) .."   "..tostring(success))
	local backpackObj = this:GetEquippedObject("Backpack")
	if( backpackObj ~= nil and CountResourcesInContainer(backpackObj,resourceType) >= amount ) then
		local resourceObjs = GetResourcesInContainer(backpackObj,resourceType)
		-- sort stackable objects from smallest to largest
		table.sort(resourceObjs,function(a,b) return GetStackCount(a)<GetStackCount(b) end)
		local remainingAmount = amount
		for index, resourceObj in pairs(resourceObjs) do
			local resourceCount = GetStackCount(resourceObj)
			if( resourceCount > remainingAmount ) then				
				RequestSetStackCount(resourceObj,resourceCount - remainingAmount)
				remainingAmount = 0
			else
				remainingAmount = remainingAmount - resourceCount
				resourceObj:Destroy()
			end

			if( remainingAmount == 0 ) then
				break
			end
		end

		success = true
	end

	
	--DebugMessage(tostring(resourceType) .."   ".. tostring(amount) .."   "..tostring(transactionId) .."   "..tostring(response) .."   "..tostring(success))
	if( responseObj ~= nil and responseObj:IsValid() ) then
		responseObj:SendMessage("ConsumeResourceResponse",success,transactionId,this,...)
	end
end

RegisterEventHandler(EventType.Message, "ConsumeCoins", HandleConsumeCoins)