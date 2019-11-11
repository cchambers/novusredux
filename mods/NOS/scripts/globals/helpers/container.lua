require 'default:globals.helpers.container'


MagicContainerItems = {
	reagents = {
		"Blackpearl",
		"Bloodmoss",
		"Mandrake",
		"Garlic",
		"Ginseng",
		"Spidersilk",
		"Sulfurousash",
		"Nightshade",
		"LemonGrass",
		"Moss",
		"Mushrooms"
	},
	arrows = {
		"Arrows",
		"AshArrows",
		"BlightwoodArrows",
		"BroodwoodArrows",
	},
}

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