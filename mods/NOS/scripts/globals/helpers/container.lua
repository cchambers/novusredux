

function IsInBank(item)
	local result = false
	ForEachParentContainerRecursive(item,false,function (contObj)
			if(GetEquipSlot(contObj) == "Bank") then
				result = true
				-- found it stop searching
				return false
			end
			-- keep looking
			return true
		end)

	return result
end

function IsBankerInRange(user)
	-- This objvar is the only way to know if its a banker atm
	return FindObject(SearchHasObjVar("AI-EnableBank",OBJECT_INTERACTION_RANGE),user) ~= nil
end

function CreateObjInBackpackOrAtLocation(targetObj, createTemplate, createId, ...)
	local backpackObj = targetObj:GetEquippedObject("Backpack")
	
	local canCreate,reason = CanCreateItemInContainer(createTemplate,backpackObj)
	if(canCreate) then
		local dropPos = GetRandomDropPosition(backpackObj)
		CreateObjInContainer(createTemplate, backpackObj, dropPos, createId, ...)
	else
		createId = createId or uuid()
		if(targetObj:IsPlayer()) then
			targetObj:SystemMessage("[$1854]","info")
		end
		RegisterSingleEventHandler(EventType.CreatedObject,createId,
			function (success,objRef)
				Decay(objRef)
			end)
		CreateObj(createTemplate, targetObj:GetLoc(), createId, ...)
	end	

	return canCreate, reason
end

function JumbleContainerContents(lootObjects)
	for index, item in pairs(lootObjects) do
		if(item:GetLoc() == Loc.Zero) then
			local randomLoc = GetRandomDropPosition(this)
			item:UpdateContainerPosition(randomLoc)
		end
	end	
end

function TryStack(objToStack, containerObj, testOnly)
	-- if this is a stackable object look to see if we can stack it
	local resourceType = objToStack:GetObjVar("ResourceType")
	if( resourceType ~= nil and IsStackable(objToStack) ) then
		local resourceObj = FindResourceInContainer(containerObj,resourceType)
		if( resourceObj ~= nil and IsStackable(resourceObj) ) then
			if not(testOnly) then
				RequestStackOnto(resourceObj,objToStack)
			end
			return true
		end
	end

	return false
end

function GetContainerMaxWeight(container)
    if ( container ~= nil ) then
        local equipSlot = GetEquipSlot(container)
        if ( equipSlot == "Bank" ) then
			return ServerSettings.Misc.BankWeightLimit
        end
	end
	local maxWeight = container:GetSharedObjectProperty("MaxWeight")
	if ( maxWeight == nil or maxWeight == 0 ) then
		return ServerSettings.Misc.DefaultContainerWeightLimit
	end
	return maxWeight
end

function CanAddWeightToContainer(container,objWeight)
	if(objWeight == 0) then return true end
	-- check weight requirement on all parent containers with a max weight
	local weightCont = nil
	local maxWeight = 0
	local canAdd = true

	ForEachParentContainerRecursive(container,true,
		function (parentCont)			
			maxWeight = GetContainerMaxWeight(parentCont)

			if(maxWeight ~= nil and not parentCont:IsPlayer()) then
				local curWeight = GetContentsWeight(parentCont)
				--DebugMessage("CHECKING WEIGHT",curWeight,objWeight,maxWeight)
		
				if(curWeight + objWeight > maxWeight) then
					canAdd = false
					weightCont = parentCont
					maxWeight = maxWeight
					return false
				end				
			end

			return true
		end)

	return canAdd,weightCont,maxWeight
end

function CanCreateItemInContainer(template,container,amount)
	amount = amount or 1

	local reason = nil

	if(container == nil) then
		return false,"invalidcontainer"
	end

	local templateResource = GetTemplateObjVar(template,"ResourceType")
	if ( container:IsFull() and not CanAddToStack(templateResource,container) ) then
		return false, "full"
	end

	local templateWeight = GetCreationWeight(template,amount)
	if(templateWeight ~= -1) then
		local canAdd = CanAddWeightToContainer(container,templateWeight)
		if not(canAdd) then
			return false, "overweight"
		end
	end

	return true
end

function CanObjectFitInContainer(obj, container)
	return TryPutObjectInContainer(obj, container, Loc(0,0,0), false, false, true)
end

function TryPutObjectInContainer(obj, container, locInContainer, canOverfill, tryStack, testOnly, source, dropper)
	if(obj == container or container:IsContainedBy(obj)) then
		return false,"You can't put an object inside itself!"
	end

	local topContainer = obj:TopmostContainer()
	local topContainerInContainer = container:TopmostContainer() or container
	if (topContainer ~= nil and topContainer:IsPlayer() and (not topContainerInContainer:IsContainedBy(topContainer))) then
		if (not(topContainer:HasLineOfSightToObj(topContainerInContainer,ServerSettings.Combat.LOSEyeLevel))) then
			return false, "Container is not in sight."
		end
	end

	local objWeight = obj:GetSharedObjectProperty("Weight") or -1
	if(objWeight == nil or objWeight == -1) then
		return false,"That is too heavy for that container."
	end

	if ( dropper ~= nil ) then
		local topCont = container:TopmostContainer() or container
		-- can't drop onto corpses
		if ( container:IsContainer() ) then
			if ( topCont:IsMobile() and not(IsInPetPack(container,this,topCont,true)) ) then
				if ( not( IsDemiGod(dropper) ) or TestMortal(dropper) ) then
					--can't drop into mobiles that are inside of other mobiles(mounts)
					if ( container ~= topCont and container:IsMobile() and topCont:IsMobile() ) then
						return false,"That is unreachable."
					elseif ( IsDead(topCont) ) then
						if ( source ~= nil and topCont ~= source ) then
							-- disallow dropping stuff directly onto a corpse
							return false,"Cannot drop items onto a corpse."
						end
					elseif ( topCont ~= dropper ) then
						-- Check to see if we're allowed to drop an item on a pet.
						if ( 
							-- Is it a pet?
							topCont:HasObjVar("HasPetPack") and 
							-- Are we the pet owner, or someone in their group?
							(GetPetOwner(topCont) == dropper or ShareGroup(GetPetOwner(topCont), dropper)) 
						) then
							container = topCont:GetEquippedObject("Backpack")
							if ( container == nil ) then
								return false,"That pet does not have a pack."
							end
						-- Else, we are not allowed to drop on this pet.
						else
							return false, "Cannot drop that onto someone else's pack."
						end
					-- search for nearby banker
					elseif(IsInEquippedContainer("Bank",container,dropper,true) and not(IsBankerInRange(dropper))) then						
						return false, "You can not access your bank from here."
					elseif(IsInEquippedContainer("TempPack",container,dropper,true)) then
						DebugMessage("ERROR: Hacker detected. Dropping to TempPack: "..dropper:GetAttachedUserId())
						return false, "Not permitted."						
					end
				end
			end
		end

		-- locked
		local grant = false
		-- check if the container we are dropping onto is locked
		if ( container:HasObjVar("locked") ) then
			-- allow plot secure containers to work like unlocked containers only for those with permission
			if ( container:HasObjVar("SecureContainer") ) then
				grant = Plot.HasObjectControl(dropper, container, container:HasObjVar("FriendContainer"))
			end
		else
			grant = true
		end
		-- also apply the same check to the topmost container
		if ( grant and topCont ~= container and topCont:HasObjVar("locked") ) then
			grant = false
			if ( topCont:HasObjVar("SecureContainer") ) then
				grant = Plot.HasObjectControl(dropper, topCont, topCont:HasObjVar("FriendContainer"))
			end
		end
		if not( grant ) then
			return false, "Container is Locked."
		end

		-- stop players from putting things other than food into a cooking pot
		if ( container:HasModule("cooking_crafting") and not CookingHelper.IsIngredient(obj) ) then
			return false, "That cannot be cooked."
		end

		if ( not(IsDemiGod(dropper)) and container:HasObjVar("merchantContainer") ) then
			return false, "You are not allowed to do that."
		end
	end

	-- make sure this container or its parents are not for sale
	local isSaleContainer = false
    ForEachParentContainerRecursive(container,true,
        function (parentObj)
            if(parentObj:HasModule("hireling_merchant_sale_item")) then                
                isSaleContainer = true
                return false
            end
            return true
        end)

    if(isSaleContainer) then
        return false,"[$1853]"
    end

	if not(canOverfill) then
		local canAdd,weightCont,maxWeight = CanAddWeightToContainer(container,objWeight)

		-- if this would put any of our parent containers over their max weight then fail
		if not(canAdd) then
			return false,StripColorFromString(weightCont:GetName()).." cannot support any more weight. (Max: " .. tostring(maxWeight) .. " stones)"
		end
	end

	if( tryStack ) then
		if( TryStack(obj,container,testOnly) ) then
			return true
		end
	end

	if(locInContainer == nil) then
		locInContainer = GetRandomDropPosition(container)
	end

	if( canOverfill or container:CanHold(obj) ) then
		if not(testOnly) then
			obj:MoveToContainer(container, locInContainer)
		end
		return true
	end

	return false,"There is not enough room for that object."
end

function CanAddToStack(resourceType, containerObj)
	local resourceObj = FindResourceInContainer(containerObj,resourceType)
	if( resourceObj ~= nil and IsStackable(resourceObj) ) then
		return true	
	end

	return false
end

function TryAddToStack(resourceType, containerObj, count)	
	if (containerObj == nil) then return false end
	if (resourceType == nil) then return false end
	if (count == nil) then return false end
	local resourceObj = FindResourceInContainer(containerObj,resourceType)
	if( resourceObj ~= nil and IsStackable(resourceObj) ) then
		local addWeight = GetUnitWeight(resourceObj,count)
		if(CanAddWeightToContainer(containerObj,addWeight)) then
			RequestAddToStack(resourceObj,count)
			return true, resourceObj
		else
			return false, "Weight"
		end
	end

	return false, "NotFound"
end

function GetCapacity(containerObj)
	if (containerObj == nil) then return 0 end
	return containerObj:GetSharedObjectProperty("Capacity") or 0;
end

function FindObjectInContainer(containerObj,creationTemplate)
	local contObjects = containerObj:GetContainedObjects()
  	for index, contObj in pairs(contObjects) do
  		if(contObj:GetCreationTemplateId() == creationTemplate) then
  			return contObj
  		end
  	end	
end

-- close every sub container as well as the container
function CloseContainerRecursive(user,containerObj)
	local contObjects = containerObj:GetContainedObjects()
  	for index, contObj in pairs(contObjects) do
  		if(contObj:IsContainer()) then
  			CloseContainerRecursive(user,contObj)  			
  		end
  	end

  	containerObj:SendCloseContainer(user)
end

--- Consumes resource objects from a lua list (array) that match the specified resource type.
-- @param contents array - ( the contents of a container normally ) DOES NOT GET CONTENTS OF CONTAINERS IN THE LIST
-- @param resourceType string - The ResourceType to consume
-- @param amount(optional) double - The amount of the resource to consume, defaults to 1
-- @param objVarName(optional) string - Can be used to check against a different objvar than 'ResourceType' (defaults to ResourceType)
-- @return true if the amount was consumed, false if the amount couldn't be consumed.
function ConsumeResource(contents, resourceType, amount, objVarName)
	if not( contents ) then contents = {} end
	-- there are no contents to be consumed.
	if ( #contents < 1 ) then return false end
	amount = amount or 1
	if ( amount < 1 ) then
		local topmost = contents[1]:TopmostContainer()
		local owner = topmost
		if ( topmost and IsPet(topmost) ) then
			owner = topmost:HasObjVar("controller") and topmost:GetObjVar("controller") or topmost:GetObjectOwner()
		end
		LuaDebugCallStack("[ConsumeResource] negative amount provided: " .. amount .. " topmost: "..topmost.Id.." owner: "..owner.Id)
		return false
	end
	objVarName = objVarName or "ResourceType"
	
	local resourceObjs = {}
	local total = 0
	for i,resourceObj in pairs(contents) do
		if ( resourceObj:GetObjVar(objVarName) == resourceType ) then
			table.insert(resourceObjs, resourceObj)
			total = total + GetStackCount(resourceObj)
		end
	end

	if ( total >= amount ) then
		-- sort stackable objects from smallest to largest
		table.sort(resourceObjs,function(a,b) return GetStackCount(a)<GetStackCount(b) end)
		local remainingAmount = amount
		for index, resourceObj in pairs(resourceObjs) do
			local resourceCount = GetStackCount(resourceObj)
			if ( resourceCount > remainingAmount ) then				
				RequestSetStackCount(resourceObj,resourceCount - remainingAmount)
				remainingAmount = 0
			else
				remainingAmount = remainingAmount - resourceCount
				resourceObj:Destroy()
			end

			if ( remainingAmount == 0 ) then
				break
			end
		end
		return true
	end
	return false
end

--- Convenience function to consume resources directly from a container recursively
-- @param container
-- @param resourceType string
-- @param amount(optional) double - The amount of the resource to consume, defaults to 1
-- @param objVarName(optional) string - defaults to "ResourceType"
-- @return true or false (success/fail)
function ConsumeResourceContainer(container, resourceType, amount, objVarName)
	local contents = GetResourcesInContainer(container, resourceType, objVarName)
	return ( contents and ConsumeResource(contents, resourceType, amount, objVarName) )
end

--- Convenience function to consume resources directly from a mobile's backpack, recursively.
-- @param mobileObj
-- @param resourceType string
-- @param amount(optional) double - The amount of the resource to consume, defaults to 1
-- @param objVarName(optional) string - defaults to "ResourceType"
-- @return true or false (success/fail)
function ConsumeResourceBackpack(mobileObj, resourceType, amount, objVarName)
	local backpack = mobileObj:GetEquippedObject("Backpack")
	return ( backpack and ConsumeResourceContainer(backpack, resourceType, amount, objVarName) )
end

function WarnContainerOverflow(container, user, capacity)
	if ( capacity == nil ) then capacity = container:GetSharedObjectProperty("Capacity") end
    -- anytime a container is opened that has more items in it than capacity it can handle,
    -- warn the user that anything picked up from here cannot be placed back in here
    local numItems = container:GetSharedObjectProperty("NumItems")
    if ( numItems > capacity ) then
        local name = StripColorFromString(container:GetName())
        ClientDialog.Show{
            TargetUser = user,
            DialogId = "WarnContainerFull"..container.Id,
            TitleStr = name .. " Is Overflowing!",
            DescStr = name.." is over its item limit. If you pick up an item from here, you will not be able to place it back until enough items have been removed. Item limits are displayed below the item list view.",
            Button1Str = "Ok",
        }
    end
end

--- Will set a backpack to proper possesive english text for mobile.
-- @param mobile
-- @param backpack
function RenameBackpack(mobile, backpack)
	local mName, mColor = StripColorFromString(mobile:GetName())
	local bName, bColor = StripColorFromString(backpack:GetName())
	backpack:SetName(string.format("%s%s Backpack[-]", bColor, EnglishPossessive(mName)))
  end


function TryPutObjectInContainer(obj, container, locInContainer, canOverfill, tryStack, testOnly, source, dropper)

	local ResourceTypes = container:GetObjVar("ResourceTypes")
	if (ResourceTypes ~= nil) then
		local type = obj:GetObjVar("ResourceType") or nil
		local isGood = false
		for k, v in pairs(ResourceTypes[1]) do
			if (ResourceTypes[1][k] == type) then
				isGood = true
			end
		end
		
		if (isGood == false) then
			return false,"This container is for specific items."
		end
	end


	if(obj == container or container:IsContainedBy(obj)) then
		return false,"You can't put an object inside itself!"
	end

	local topContainer = obj:TopmostContainer()
	local topContainerInContainer = container:TopmostContainer() or container
	if (topContainer ~= nil and topContainer:IsPlayer() and (not topContainerInContainer:IsContainedBy(topContainer))) then
		if (not(topContainer:HasLineOfSightToObj(topContainerInContainer,ServerSettings.Combat.LOSEyeLevel))) then
			return false, "Container is not in sight."
		end
	end

	local objWeight = obj:GetSharedObjectProperty("Weight") or -1
	if(objWeight == nil or objWeight == -1) then
		return false,"That is too heavy for that container."
	end

	if ( dropper ~= nil ) then
		local topCont = container:TopmostContainer() or container
		-- can't drop onto corpses
		if ( container:IsContainer() ) then
			if ( topCont:IsMobile() and not(IsInPetPack(container,this,topCont,true)) ) then
				if ( not( IsDemiGod(dropper) ) or TestMortal(dropper) ) then
					--can't drop into mobiles that are inside of other mobiles(mounts)
					if ( container ~= topCont and container:IsMobile() and topCont:IsMobile() ) then
						return false,"That is unreachable."
					elseif ( IsDead(topCont) ) then
						if ( source ~= nil and topCont ~= source ) then
							-- disallow dropping stuff directly onto a corpse
							return false,"Cannot drop items onto a corpse."
						end
					elseif ( topCont ~= dropper ) then
						if ( topCont:HasObjVar("HasPetPack") ) then
							container = topCont:GetEquippedObject("Backpack")
							if ( container == nil ) then
								return false,"That pet does not have a pack."
							end
						else
							return false, "Cannot drop that onto someone else's pack."
						end
					end
				end
			end
		end

		-- locked
		local grant = false
		-- check if the container we are dropping onto is locked
		if ( container:HasObjVar("locked") ) then
			-- allow plot secure containers to work like unlocked containers only for those with permission
			if ( container:HasObjVar("SecureContainer") ) then
				grant = Plot.HasObjectControl(dropper, container, container:HasObjVar("FriendContainer"))
			end
		else
			grant = true
		end
		-- also apply the same check to the topmost container
		if ( grant and topCont ~= container and topCont:HasObjVar("locked") ) then
			grant = false
			if ( topCont:HasObjVar("SecureContainer") ) then
				grant = Plot.HasObjectControl(dropper, topCont, topCont:HasObjVar("FriendContainer"))
			end
		end
		if not( grant ) then
			return false, "Container is Locked."
		end

		-- stop players from putting things other than food into a cooking pot
		if ( container:HasModule("cooking_crafting") and not IsIngredient(obj) ) then
			return false, "That cannot be cooked."
		end

		if ( not(IsDemiGod(dropper)) and container:HasObjVar("merchantContainer") ) then
			return false, "You are not allowed to do that."
		end
	end

	-- make sure this container or its parents are not for sale
	local isSaleContainer = false
    ForEachParentContainerRecursive(container,true,
        function (parentObj)
            if(parentObj:HasModule("hireling_merchant_sale_item")) then                
                isSaleContainer = true
                return false
            end
            return true
        end)

    if(isSaleContainer) then
        return false,"[$1853]"
    end

	if not(canOverfill) then
		local canAdd,weightCont,maxWeight = CanAddWeightToContainer(container,objWeight)

		-- if this would put any of our parent containers over their max weight then fail
		if not(canAdd) then
			return false,StripColorFromString(weightCont:GetName()).." cannot support any more weight. (Max: " .. tostring(maxWeight) .. " stones)"
		end
	end

	if( tryStack ) then
		if( TryStack(obj,container,testOnly) ) then
			return true
		end
	end

	if(locInContainer == nil) then
		locInContainer = GetRandomDropPosition(container)
	end

	if( canOverfill or container:CanHold(obj) ) then
		if not(testOnly) then
			obj:MoveToContainer(container, locInContainer)
		end
		return true
	end

	return false,"There is not enough room for that object."
end