require 'incl_container'

function PackObject(user,objRef)
	if(objRef == nil or not(objRef:IsValid())) then return end	

	local templateId = objRef:GetCreationTemplateId()

	CreatePackedObjectInBackpack(user,templateId)
end

function RegisterCreateHandler(handle)
	RegisterSingleEventHandler(EventType.CreatedObject,handle,
		function(success,objRef,packed_template)
			--DebugMessage("CreatePackedObject "..tostring(templateId).." "..tostring(packed_template).." "..tostring(success))
			if(success) then
				objRef:SetObjVar("UnpackedTemplate",packed_template)

				local templateData = GetTemplateData(packed_template)
				if(templateData ~= nil) then
					objRef:SetName(StripColorFromString(templateData.Name).." (Packed)")

					if(templateData.LuaModules ~= nil and templateData.LuaModules.create_key ~= nil) then
						objRef:SetObjVar("ShouldCreateKey",true)
					end
				end
			end
		end)
end

function CreatePackedObjectInCarrySlot(user,templateId,handle)
	if (handle == nil) then handle = uuid() end
	local carriedObject = user:CarriedObject()
	if (carriedObject ~= nil) then
		this:SystemMessage("You are already carrying something.")
		return
	end
	RegisterCreateHandler(handle)
	CreateObjInCarrySlot(user,"packed_object",handle,templateId)
end

function CreatePackedObjectInBackpack(user,templateId,handle)
	if (handle == nil) then handle = uuid() end
	
	RegisterCreateHandler(handle)
	CreateObjInBackpackOrAtLocation(user, "packed_object", handle, templateId)	
end

function CreatePackedObjectInContainer(templateId,contObj,spawnLoc,handle)
	if (handle == nil) then handle = uuid() end
	
	spawnLoc = spawnLoc or GetRandomDropPosition(contObj)
	--DebugMessage("CreatePackedObjectInContainer "..tostring(handle))
	RegisterCreateHandler(handle)
	CreateObjInContainer("packed_object", contObj, spawnLoc, handle, templateId)	
end

function CreatePackedObjectAtLoc(templateId,spawnLoc,handle)
	if (handle == nil) then handle = uuid() end

	RegisterCreateHandler(handle)
	CreateObj("packed_object",spawnLoc,handle,templateId)
end