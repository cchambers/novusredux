
function PackObject(user,objRef)
	if ( objRef == nil or not objRef:IsValid() ) then return end	

	Create.PackedObject.InBackpack(objRef:GetCreationTemplateId(), user, nil, function(packed)
		if ( packed ) then
			objRef:Destroy()
			user:SystemMessage("Object packed.", "info")
		else
			user:SystemMessage("Failed to pack object.", "info")
		end
	end)
    
end

function RegisterPackedObjectCreateHandler(handle)
	RegisterSingleEventHandler(EventType.CreatedObject,handle,
		function(success,objRef,packed_template,isExteriorDecoration)
			--DebugMessage("CreatePackedObject "..tostring(templateId).." "..tostring(packed_template).." "..tostring(success))
			if(success) then
				objRef:SetObjVar("UnpackedTemplate",packed_template)
				SetItemTooltip(objRef)
				if(isExteriorDecoration) then 
					objRef:SetObjVar("ExteriorDecoration",true)
				end
			end
		end)
end

function CreatePackedObjectInBackpack(user,templateId,isExteriorDecoration,handle)
	if (handle == nil) then handle = uuid() end
	
	RegisterPackedObjectCreateHandler(handle)
	CreateObjInBackpackOrAtLocation(user, "packed_object", handle, templateId, isExteriorDecoration)	
end

function CreatePackedObjectAtLoc(templateId,spawnLoc,handle)
	if (handle == nil) then handle = uuid() end

	RegisterPackedObjectCreateHandler(handle)
	CreateObj("packed_object",spawnLoc,handle,templateId,false)
end

Create.PackedObject = {}

Create.PackedObject.InContainer = function(template, container, loc, cb, noTooltip)
	if not( cb ) then cb = function(obj) end end
	Create.InContainer("packed_object", container, loc, function(obj)
		if ( obj ) then
			obj:SetObjVar("UnpackedTemplate", template)
			if not( noTooltip ) then
				SetItemTooltip(obj)
			end
		end
		cb(obj)
	end, true)
end

Create.PackedObject.InBackpack = function(template, mobile, loc, cb, noTooltip)
	if not( cb ) then cb = function(obj) end end
	Create.InBackpack("packed_object", mobile, loc, function(obj)
		if ( obj ) then
			obj:SetObjVar("UnpackedTemplate", template)
			if not( noTooltip ) then
				SetItemTooltip(obj)
			end
		end
		cb(obj)
	end, true)
end
