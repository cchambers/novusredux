-- TODO: Store this information in a more consistent manner

-- Regen rate is in units per second

function GetResourceSourceId(objRef)
	local sourceId = objRef:GetSharedObjectProperty("ResourceSourceId")

	-- for dynamics you can also use an objvar to define source id
	if( not(objRef:IsPermanent()) and objRef:HasObjVar("ResourceSourceId") ) then
		sourceId = objRef:GetObjVar("ResourceSourceId")
	end

	return sourceId
end

function GetResourceSourceInfo(objRef)
	local sourceId = GetResourceSourceId(objRef)

	if( sourceId ~= nil ) then
		return ResourceData.ResourceSourceInfo[sourceId]
	end
	--LuaDebugCallStack("[ResourceSourceInfo] sourceId is nil!")
end

function GetRequiredTool(objRef)
	local requiredTool = nil
	if( not(objRef:IsPermanent()) and objRef:HasObjVar("HarvestToolType") ) then
		requiredTool = objRef:GetObjVar("HarvestToolType")
		--DebugMessage("Attempted to harvest non-permanent object")
	else
		local sourceId = GetResourceSourceId(objRef)
		--DebugMessage("sourceId is "..tostring(sourceId).." Id is ".. objRef.Id)
		if( sourceId ~= nil and ResourceData.ResourceSourceInfo[sourceId] ~= nil ) then
			-- tool required
			requiredTool = ResourceData.ResourceSourceInfo[sourceId].ToolType
			--DebugMessage("ToolType is " .. tostring(requiredTool))
		end
	end

	return requiredTool
end

function GetHarvestToolInBackpack(user,toolType)
	local backpackObj = user:GetEquippedObject("Backpack")  
	if( backpackObj ~= nil ) then
		--DebugMessage("Tooltype is "..tostring(toolType))
		local packObj = FindItemInContainerRecursive(backpackObj,
        function(item)            
            return item:GetObjVar("ToolType") == toolType
        end)
		--DFB HACK: Check the equipped object to see if it's a tool also.
		local equippedObj = user:GetEquippedObject("RightHand")
		if (equippedObj ~= nil and equippedObj:GetObjVar("ToolType") == toolType) then
			packObj = equippedObj
		end

		return packObj
	end
end

function GetResourceDisplayName(resourceType)
	local displayName = resourceType
	if(ResourceData.ResourceInfo[resourceType] ~= nil) then
		if(ResourceData.ResourceInfo[resourceType].DisplayName ~= nil) then
			displayName = ResourceData.ResourceInfo[resourceType].DisplayName
		elseif(ResourceData.ResourceInfo[resourceType].Template) then
			displayName = GetTemplateObjectName(ResourceData.ResourceInfo[resourceType].Template)
			ResourceData.ResourceInfo[resourceType].DisplayName = displayName
		end	
	end

	return StripColorFromString(displayName)
end