require 'default:globals.helpers.plot'

--- Validate the plot bound with error output to player
-- @param playerObj
-- @param bound AABox2
-- @param size Loc
-- @param ignoreLoc Loc - if a plot bound matches will not be included
Plot.ValidateBound = function(playerObj, bound, size, ignoreLoc)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.ValidateBound] playerObj not provided.")
        return false
    end
    if not( bound ) then
        LuaDebugCallStack("[Plot.ValidateBound] bound not provided.")
        return false
    end

    local housingRegion = GetRegion("Housing")	
	-- if this map has no valid housing region, fail
	if(housingRegion == nil) then
		playerObj:SystemMessage("That land cannot be claimed.", "info")
		return false
    end
    
    -- if any of the four corners are not in a housing area then fail
    --[[ -- don't need this since we are allowing housing anywhere (except further checks down lower) that has a Housing region
	local pointsToCheck = bound.Points
	table.insert(pointsToCheck,bound.Center)
	for i=1,#pointsToCheck do
		if not( housingRegion:Contains(pointsToCheck[i]) ) then 
			playerObj:SystemMessage("That land cannot be claimed.", "info")
			return false
		end
    end]]
    
    -- if any of the four corners are not passable then fail
    local pointsToCheck = bound.Points
    pointsToCheck[#pointsToCheck+1] = bound.Center
    local loc, collisionInfo, any, blocked
    for i=1,#pointsToCheck do
        loc = Loc(pointsToCheck[i])
        if not( IsPassable(loc) ) then
            collisionInfo = GetCollisionInfoAtLoc(loc) or {}
            blocked = #collisionInfo < 1
            if not( blocked ) then
                for ii=1,#collisionInfo do
                    any = (type(collisionInfo[ii]) == "userdata") -- static collision
                    if not( any ) then
                        local obj = GameObj(tonumber(StringSplit(collisionInfo[ii], " ")[3]))
                        if ( obj and obj:IsValid() ) then
                            any = not( obj:HasObjVar("IsPlotObject") or obj:HasObjVar("LockedDown") )
                        end
                    end
                    if ( any ) then
                        blocked = true
                        break
                    end
                end
            end
            if ( blocked ) then
                playerObj:SystemMessage("Something is blocking the "..PointsToString[i].." point.", "info")
                return false
            end
        end
	end

	local noHousingRegion = GetRegion("NoHousing")
	if ( noHousingRegion ~= nil and noHousingRegion:Intersects(bound) ) then
		playerObj:SystemMessage("That land cannot be claimed.", "info")
		return false
    end

	local waterRegion = GetRegion("Water")
	if(waterRegion ~= nil and waterRegion:Intersects(bound)) then
		playerObj:SystemMessage("Can only claim land, not water.", "info")
		return false
	end

    -- prevent plots from encroaching on other plots
    local nearbyPlots = Plot.GetNearby(Plot.PointToLoc(bound.Center))
    for i=1,#nearbyPlots do
        local plot = nearbyPlots[i]
        local bbounds = Plot.GetBufferedBounds(plot, ignoreLoc)
        for i=1,#bbounds do
            if ( bound:Intersects(bbounds[i]) ) then
                -- now check the unbuffered bounds to give the player better information
                local bounds = Plot.GetBounds(plot, ignoreLoc)
                for ii=1,#bounds do
                    if ( bound:Intersects(bounds[ii]) ) then
                        playerObj:SystemMessage("That land is already claimed.", "info")
                        return false
                    end
                end
                playerObj:SystemMessage("Too close to existing plot.", "info")
                return false
            end
        end
    end

    -- -- expand the bound to find stuff nearby including a 'buffer'
	-- local searcher = PermanentObjSearchRect(Box2(AABox2(bound.TopLeft.X-2,bound.TopLeft.Z-2,bound.Width+4,bound.Height+4)))
    -- local anyPermanent = FindPermanentObjects(searcher)
    -- if ( #anyPermanent > 0 ) then
    --     playerObj:SystemMessage("There is something in the way.", "info")
    --     return false
    -- end
    
    return true
end

--- Release a locked down object from a plot
-- @param playerObj
-- @param object - The object to release
Plot.Release = function(playerObj, controller, object)
    local success, controller, house, isPackedObject = Plot.TryRelease(playerObj, object)
    local tmpHue

    if ( success ) then

        if ( object:IsContainer() ) then
            CloseContainerRecursive(playerObj, object)
            if ( house ) then
                Plot.AlterContainerCountBy(house, -1)
                if not( isPackedObject ) then
                    object:DelObjVar("SecureContainer")
                    object:DelObjVar("locked")
                    RemoveTooltipEntry(object,"lock")
                    if ( object:HasObjVar("FriendContainer") ) then
                        RemoveUseCase(object,"Secure: Owners")
                        RemoveTooltipEntry(object,"friend_container")
                        object:DelObjVar("FriendContainer")
                    else
                        RemoveUseCase(object,"Secure: Friends")
                    end
                end
            else
                Plot.AlterLockCountBy(controller, -1)
            end
        else
            -- remove a lockdown
            Plot.AlterLockCountBy(house or controller, -1)
        end

        tmpHue = object:GetHue()
        DebugMessage("tmpHue = "..tostring(tmpHue))

        -- handle packed objects
        if ( isPackedObject ) then
            PackFurniture(playerObj, object)
            return
        end

		object:DelObjVar("LockedDown")
		object:DelObjVar("NoReset")
        object:DelObjVar("PlotController")

        if ( house ) then
            object:DelObjVar("PlotHouse")
        end
		RemoveTooltipEntry(object,"locked_down")
		Decay(object)

		if(object:HasModule("hireling_merchant_sale_item")) then
			object:SendMessage("RemoveFromSale")
		end

		local saleItem = FindItemsInContainerRecursive(object, 
			function(item)
				return ( item:HasModule("hireling_merchant_sale_item") )
			end)

		for key,value in pairs(saleItem) do
			if (value:HasModule("hireling_merchant_sale_item")) then
				value:SendMessage("RemoveFromSale")
			end
        end

        playerObj:SystemMessage("Object Released.", "info")
    end
    
    return success
end

--- Unpack a packed object, does not check before unpacking, this must be called from the context of the plot controller (send the controller a message of Unpack)
-- @param playerObj
-- @param packedObj
-- @param loc
-- @return boolean
Plot.Unpack = function(playerObj, packedObj, loc, cb)
    local success, controller, template, house, isContainer = Plot.TryUnpack(playerObj, packedObj, loc)

    if ( success ) then
        playerObj:PlayAnimation("kneel")

        RegisterSingleEventHandler(EventType.CreatedObject, "UnpackCreate", function(success, objRef)
            if ( success ) then
                objRef:SetObjVar("IsPackedObject", true)
                objRef:SetObjVar("LockedDown", true)
                objRef:SetObjVar("NoReset", true)
                objRef:SetObjVar("PlotController", controller)
                SetItemTooltip(objRef)
                
                if ( packedObj:HasObjVar("ExteriorDecoration") ) then
                    objRef:SetObjVar("ExteriorDecoration", true)
                end

                if ( house ) then
                    objRef:SetObjVar("PlotHouse", house)
                else
                    if ( isContainer ) then
                        ClientDialog.Show{
                            TargetUser = playerObj,
                            DialogId = "UnsecureContainer",
                            TitleStr = "Container Not Secure",
                            DescStr = "Containers locked down outside are not secure.\n\nTo make a Container secure, place it in a house.",
                            Button1Str = "Ok",
                        }
                    end
                end

                if ( house and isContainer ) then
                    SetTooltipEntry(objRef,"locked_down","Secure",98)
                    AddUseCase(objRef, "Secure: Friends", false, "HasHouseControl")
                    objRef:SetObjVar("SecureContainer", true)
                    objRef:SetObjVar("locked", true)
                    objRef:SetHue(packedObj:GetHue())
                    objRef:SetObjVar("Material", packedObj:GetObjVar("Material"))
                    --objRef:SetHue(Materials[material])
                    Plot.AlterContainerCountBy(house, 1)
                else
                    SetTooltipEntry(objRef,"locked_down","Locked Down",98)
                    objRef:SetHue(packedObj:GetHue())
                    objRef:SetObjVar("Material", packedObj:GetObjVar("Material"))
                    --objRef:SetHue(Materials[material])
                    Plot.AlterLockCountBy(house or controller, 1)
                end

                MoveMobilesOutOfObject(objRef)
                
                packedObj:Destroy()

                if ( cb ) then cb(objRef) end
                
            else
                if ( cb ) then cb(nil) end
            end
        end)
        local success, error = pcall(function() CreateObj(template, loc, "UnpackCreate") end)
        if not( success ) then
            DebugMessage(error)
            cb(nil)
        end
    else
        if ( cb ) then cb(nil) end
    end
end

