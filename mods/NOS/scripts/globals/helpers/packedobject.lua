
function PackObject(user,objRef)
	if(objRef == nil or not(objRef:IsValid())) then return end	

	local templateId = objRef:GetCreationTemplateId()
	local isExteriorDecoration = objRef:GetObjVar("ExteriorDecoration")

    CreatePackedObjectInBackpack(user,templateId,isExteriorDecoration)
    
    user:SystemMessage("Object packed.", "info")

	objRef:Destroy()
end

function RegisterPackedObjectCreateHandler(handle)
	RegisterSingleEventHandler(EventType.CreatedObject,handle,
		function(success,objRef,packed_template,isExteriorDecoration)
			DebugMessage("CreatePackedObject "..tostring(templateId).." "..tostring(packed_template).." "..tostring(success))
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

function CreatePackedObjectInContainer(templateId,isExteriorDecoration,contObj,spawnLoc,handle)
	if (handle == nil) then handle = uuid() end
	
	spawnLoc = spawnLoc or GetRandomDropPosition(contObj)
	RegisterPackedObjectCreateHandler(handle)
	CreateObjInContainer("packed_object", contObj, spawnLoc, handle, templateId, isExteriorDecoration)	
end

function CreatePackedObjectAtLoc(templateId,spawnLoc,handle)
	if (handle == nil) then handle = uuid() end

	RegisterPackedObjectCreateHandler(handle)
	CreateObj("packed_object",spawnLoc,handle,templateId,false)
end



function RegisterPackedFurnitureCreateHandler(oldObj,handle)
	RegisterSingleEventHandler(EventType.CreatedObject,handle,
		function(success,objRef,packed_template,isExteriorDecoration)
			DebugMessage("CreatePackedObject "..tostring(templateId).." "..tostring(packed_template).." "..tostring(success))
			if(success) then
				objRef:SetObjVar("UnpackedTemplate",packed_template)
				SetItemTooltip(objRef)
				objRef:SetObjVar("Material",oldObj:GetObjVar("Material"))
				objRef:SetHue(oldObj:GetHue())
				if(isExteriorDecoration) then 
					objRef:SetObjVar("ExteriorDecoration",true)
				end
			end
		end)
end


function CreatePackedFurnitureInBackpack(objRef,user,templateId,isExteriorDecoration,handle)
	if (handle == nil) then handle = uuid() end
	RegisterPackedFurnitureCreateHandler(objRef,handle)
	CreateObjInBackpackOrAtLocation(user, "packed_object", handle, templateId, isExteriorDecoration)	
end

-- We need this to keep objVars of released items (ie: colored furniture) without breaking merchant stuff by overwriting the PackObject Function
-- We want to keep:
-- * crafters mark
-- * material
-- * hue
function PackFurniture(user,objRef)
	if(objRef == nil or not(objRef:IsValid())) then return end	

	DebugMessage("PackFurniture has been called by: "..tostring(user).." for Object: "..tostring(objRef).." ")

	local templateId = objRef:GetCreationTemplateId()
	local isExteriorDecoration = objRef:GetObjVar("ExteriorDecoration")

    CreatePackedFurnitureInBackpack(objRef,user,templateId,isExteriorDecoration)
    
    user:SystemMessage("Object packed.", "info")

	objRef:Destroy()
end