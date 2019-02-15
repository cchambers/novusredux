require 'default:globals.helpers.container'


function TryPutObjectInContainer(obj, container, locInContainer, canOverfill, tryStack, testOnly)
    
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