require 'default:globals.helpers.plot'

local PointsToString = {
    "South",
    "East",
    "North",
    "West",
    "Center",
}

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

Plot.Refresh = function(controller)
    local newDate = DateTime.UtcNow:Add(TimeSpan.FromSeconds(30))
    SetGlobalVar("Plot."..controller.Id, function(record)
        record.Decay = newDate
        return true
    end)
end

Plot.Decay = function(controller) 
    -- erase plot and unlock everything, pack furniture?
end