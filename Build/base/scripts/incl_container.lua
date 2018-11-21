

function CreateObjInBackpackOrAtLocation(targetObj, createTemplate, createId, ...)
	local backpackObj = targetObj:GetEquippedObject("Backpack")
	
	local canCreate,reason = CanCreateItemInContainer(createTemplate,backpackObj)
	if(canCreate) then
		local dropPos = GetRandomDropPosition(backpackObj)
		CreateObjInContainer(createTemplate, backpackObj, dropPos, createId, ...)
	else
		createId = createId or uuid()
		if(targetObj:IsPlayer()) then
			targetObj:SystemMessage("[$1854]")
		end
		CreateObj(createTemplate, targetObj:GetLoc(), createId, ...)
		RegisterSingleEventHandler(EventType.CreatedObject,createId,
			function (success,objRef)
				Decay(objRef)
			end)
	end	

	return canCreate, reason
end