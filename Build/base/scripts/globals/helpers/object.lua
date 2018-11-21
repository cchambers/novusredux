
-- DAB HACK: Tooltip string should be a dictionary so you can update individual items
function SetTooltip(targetObj,tooltipInfo)
	if(tooltipInfo == nil) then
		tooltipInfo = targetObj:GetObjVar("TooltipInfo") or {}
	end
	
	local array = {}
	for key, value in pairs(tooltipInfo) do
		table.insert(array,{Tooltip=value.TooltipString,Priority=value.Priority})		
	end
	table.sort(array,function(a,b) return (a.Priority or 0) > (b.Priority or 0) end)

	local tooltipStr = ""
	for i,entry in pairs(array) do
		tooltipStr = tooltipStr .. entry.Tooltip .. "\n"
	end

	targetObj:SetObjVar("TooltipInfo", tooltipInfo)
	targetObj:SetSharedObjectProperty("TooltipString",StripTrailingNewline(tooltipStr))
end

function SetTooltipEntry(targetObj,identifier,tooltipString,priority)
	if(identifier == nil or identifier == "") then return end
	if(tooltipString == nil or tooltipString == "") then return end

	local tooltipInfo = targetObj:GetObjVar("TooltipInfo") or {}


	if(tooltipInfo[identifier] == nil 
			or tooltipInfo[identifier].TooltipString ~= tooltipString
			or tooltipInfo[identifier].Priority ~= priority) then
		tooltipInfo[identifier] = {TooltipString = tooltipString, Priority = (priority or 0)}
		targetObj:SetObjVar("TooltipInfo",tooltipInfo)

		SetTooltip(targetObj,tooltipInfo)
	end
end

function RemoveTooltipEntry(targetObj,identifier)
	if(identifier == nil or identifier == "") then return end

	local tooltipInfo = targetObj:GetObjVar("TooltipInfo") or {}
	if(tooltipInfo[identifier] ~= nil) then
		tooltipInfo[identifier] = nil
		targetObj:SetObjVar("TooltipInfo",tooltipInfo)

		SetTooltip(targetObj,tooltipInfo)
	end
end

function HasTooltipEntry(targetObj,identifier)
	local tooltipInfo = targetObj:GetObjVar("TooltipInfo") or {}

	return tooltipInfo[identifier] ~= nil
end

-- stackable helpers (see stackable.lua)

function IsStackable(target)
	if not(target) then
		LuaDebugCallStack("ERROR: IsStackable passed nil target")
	end
	return target:HasModule("stackable") or target:HasModule("coins")
end

function CanStack(target,otherObj)
	if( otherObj == nil ) then
		return false
	end

	if (otherObj:GetSharedObjectProperty("Weight") == -1) then return false
	elseif (target:GetSharedObjectProperty("Weight") == -1) then return false end

	if not(IsStackable(otherObj) and IsStackable(target)) then
		return false
	end

	return otherObj:GetObjVar("ResourceType") == target:GetObjVar("ResourceType")
end

function GetStackCount(target)
	if( IsStackable(target) ) then
		return target:GetObjVar("StackCount") or 1
	else
		return 1
	end 
end

function RequestSetStackCount(target,amount)
	target:SendMessage("SetStackCount",amount)
end

function RequestAddToStack(target,amount)
	if( IsStackable(target) ) then
		target:SendMessage("AdjustStack",amount)
	end
end

function RequestSetStack(target,amount)
	if( IsStackable(target) ) then
		target:SendMessage("SetStackCount",amount)
	end
end

function RequestRemoveFromStack(target,amount)
	if( IsStackable(target) ) then
		target:SendMessage("AdjustStack",-amount)
	else
		target:Destroy()
	end
end

function RequestStackOnto(target,otherObj)
	if(CanStack(target,otherObj)) then
		target:SendMessage("StackOnto",otherObj)
	end
end

function RequestSplitInto(target,amount,destContainer,destLocation)
	target:SendMessage("StackSplit",amount,destContainer,destLocation)
end
-- container functions

--DFB NOTE: Remove this if we change GetContainedObjects to return all the objects in subcontainers.
function GetAllContainedObjects(target)
	return FindItemsInContainerRecursive(target,function(item) 
		return true
	end)
end

--takes a table of arguments and count's the total number of items
function HasItemsInContainer(target,args)
	--args table should be organized like this:
	--{ {"template_name",<count>}, {"template_name",<count>} }

	--create the count table
	local countTable = {}
	local items = FindItemsInContainerRecursive(target)
	--now for each item in the container, count it and add it to a variable
	for i,j in pairs(items) do
		local template_name = j:GetCreationTemplateId()

		for n,entry in pairs(args) do
			if (entry[1] == template_name) then
				-- assume count is 1
				local count = 1
				--if it's a stackable item, then the count is the stack count
				if (IsStackable(j)) then
					count = GetStackCount(j)
				end

				-- add to the count table
				countTable[template_name] = (countTable[template_name] or 0) + count
			end
		end
	end

	--finally we check to see if the count table is finished
	for index,entry in pairs(args) do
		local template_name = entry[1]
		-- if the required amount is not specified you must have atleast one to satisfy
		local requiredAmt = entry[2] or 1
		local amtFound = countTable[template_name] or 0		
		if(amtFound < requiredAmt) then
			return false
		end
	end

	return true
end

--pass the creation template in the args with the amount and it will destroy that number of objects,
--even if it's in a stack, returns true if the requested items were in the container
function ConsumeItemsInContainer(target,args,forceConsume)
	--args table should be organized like this:
	--{ {"template_name",<count>}, {"template_name",<count>} }
	--DFBTODO: Change these to key,number pairs

	--check to make sure we have the items to destroy
	if( not(forceConsume) and not(HasItemsInContainer(target,args)) ) then
		return false --if not return false
	end

	--create the count table
	local countTable = {}
	for i,j in pairs(args) do
		countTable[j[1]] = j[2] or "All"
	end
	--DebugMessage("CONTAINED OBJECTS:"..tostring(DumpTable(GetAllContainedObjects(target))))
	for index,item in pairs(GetAllContainedObjects(target)) do --for each item
	--DebugMessage("ITEM:"..tostring(item:GetName()))
		for countTemplate,amount in pairs(countTable) do --check each destroy table
			--DebugMessage("Template is "..tostring(countTemplate)..", amount is "..tostring(amount))
			local template_name = item:GetCreationTemplateId() --get the template name
			--DebugMessage("templateName == "..tostring(template_name))
			if (countTemplate == template_name) then --if it matches the template in the arguments
				--DebugMessage("Amount = "..tostring(amount))
				if (amount == "All" or amount > 0) then --if we still have items to destroy for this type
					--DebugMessage(1)
					if (amount == "All") then --if the key is all, meaning the user didn't specify an amount
						item:Destroy() --destroy everything that matches in the container
						--DebugMessage("Destroying")
					else--otherwise the user specified an amount
						if (IsStackable(item)) then --if it's a stack of items 
							if (GetStackCount(item) >= amount) then 						--if there's more in the stack then we need
								--DebugMessage("removing amount")
								RequestRemoveFromStack(item,amount) 							--remove what we need from the stack
								countTable[countTemplate] = countTable[countTemplate] - amount 	--keep track so we don't destroy any more
							else 															--otherwise the stack is less than what we need
								local removeAmount = GetStackCount(item) --get the amount to remove
								item:Destroy() --destroy the stack
								--DebugMessage("Next")
								countTable[countTemplate] = countTable[countTemplate] - removeAmount --keep track of how many items we've destroyed
							end
						else--it's not a stack of items so just destroy it and remove one from teh count table
							item:Destroy()
							--DebugMessage("Not stackable")
							countTable[countTemplate] = countTable[countTemplate] - 1
						end
					end
				end
			end
		end
	end

	--final check to make sure we removed all the items and nothing more
	for i,j in pairs(countTable) do
		if (j ~= 0 and j ~= "All") then --will probably never happen unless I'm writing this wrong
			DebugMessage("[globals_object_extensions|ConsumeItemsInContainer] ERROR: Removed stack amount is nonzero! Template Name is "..tostring(i) ..", amount left is "..tostring(j))
			return false
		end
	end

	--the deed is done
	return true
end

function GetResourcesInContainer(target, resourceType, objVarName)
	objVarName = objVarName or "ResourceType"
	-- DAB HACK: Passing an invalid game obj as the source obj forces FindObjects 
	-- to include this object in the search. 
	return FindItemsInContainerRecursive(target,function(item) 
			return item:GetObjVar(objVarName) == resourceType
		end) or {}
end

function CountResourcesInContainer(target,resourceType)
	local resourceObjs = GetResourcesInContainer(target,resourceType)
	local total = 0
	for index, resourceObj in pairs(resourceObjs) do
		total = total + GetStackCount(resourceObj)
	end

	return total
end

function FindResourceInContainer(target, resourceType)
	if( resourceType ~= nil ) then
		local containedObjects = target:GetContainedObjects()
	    for index, containedObj in pairs(containedObjects) do
			local curResourceType = containedObj:GetObjVar("ResourceType")
			if( curResourceType == resourceType ) then
				return containedObj
			end
		end
	end

	return nil
end

function IncrementObjVar(target,objVarName,delta)
	local objVarValue = target:GetObjVar(objVarName) or 0
	target:SetObjVar(objVarName,objVarValue + delta)
end

function AppendToObjVar(target,objVarName,appendStr)
	local objVarValue = target:GetObjVar(objVarName) or ""
	target:SetObjVar(objVarName,objVarValue .. appendStr)
end

-- Use cases should be used in 
function AddUseCase(target,menuStr,isDefault,restrictions)
	if (HasUseCase(target,menuStr)) then return end
	if(isDefault) then
		SetDefaultInteraction(target,menuStr)
	end
	AddToListObjVar(target, "UseCases", {MenuStr=menuStr,Restrictions=restrictions})	
end

-- Use cases should be used in 
function SetDefaultInteraction(target,defaultInteraction)
	if(IsDefaultInteractionOveridden(target)) then
		target:SetObjVar("OldDefaultInteraction",defaultInteraction)
	else
		target:SetSharedObjectProperty("DefaultInteraction",defaultInteraction)
	end
end

function ClearDefaultInteraction(target)
	if(IsDefaultInteractionOveridden(target) and target:HasObjVar("OldDefaultInteraction")) then
		target:DelObjVar("OldDefaultInteraction")
	else
		target:SetSharedObjectProperty("DefaultInteraction","Use")
	end
end

function RemoveDefaultInteraction(target,defaultInteraction)
	if(IsDefaultInteractionOveridden(target)) then
		if(target:GetObjVar("OldDefaultInteraction") == defaultInteraction) then
			target:DelObjVar("OldDefaultInteraction")
		end
	else
		if(target:GetSharedObjectProperty("DefaultInteraction") == defaultInteraction) then
			target:SetSharedObjectProperty("DefaultInteraction","Use")
		end
	end
end

function RemoveUseCase(target,menuStr)
	local useCases = target:GetObjVar("UseCases")
	if(useCases ~= nil) then
		for i,useCase in pairs(useCases) do
			if(useCase.MenuStr == menuStr) then
				table.remove(useCases,i)
				target:SetObjVar("UseCases",useCases)

				RemoveDefaultInteraction(target,menuStr)
				return
			end
		end
	end
end

function IsDefaultInteractionOveridden(target)
	return target:GetObjVar("DefaultInteractionOveridden")
end

function SetOverrideDefaultInteraction(target,defaultInteraction)
	target:SetObjVar("DefaultInteractionOveridden",true)
	local oldAction = target:GetSharedObjectProperty("DefaultInteraction")
	if(oldAction) then
		target:SetObjVar("OldDefaultInteraction",oldAction)
	end
	target:SetSharedObjectProperty("DefaultInteraction",defaultInteraction)
end

function ClearOverrideDefaultInteraction(target)
	target:DelObjVar("DefaultInteractionOveridden")
	local oldAction = target:GetObjVar("OldDefaultInteraction")
	if(oldAction) then
		target:SetSharedObjectProperty("DefaultInteraction",oldAction)
	else
		target:SetSharedObjectProperty("DefaultInteraction","Use")
	end
end

function HasUseCase(target,menuStr)
	local useCases = target:GetObjVar("UseCases")
	if(useCases ~= nil) then
		for i,useCase in pairs(useCases) do
			if(useCase.MenuStr == menuStr) then
				return true
			end
		end
	end
	return false
end

function GetWeight(target)
	return target:GetSharedObjectProperty("Weight") or -1	
end

function GetContentsWeight(target)
	if not(target:IsContainer()) then
		return 0
	end

	local result = 0
	for i,containedObj in pairs(target:GetContainedObjects()) do
		local objWeight = GetWeight(containedObj)
		if(objWeight > 0) then
			result = result + objWeight
		end
	end

	return result
end

function IsInTradeContainer(target)
	local result = false
	local depth = 0
	ForEachParentContainerRecursive(target,false,function (contObj)		
			--DebugMessage("Checking "..contObj:GetName())	
			if(GetEquipSlot(contObj) == "Trade") then
				result = true
				-- found it stop searching
				return false
			end
			-- keep looking
			--DebugMessage("Inc depth "..tostring(depth))
			depth = depth + 1
			return true
		end)

	return result, depth
end