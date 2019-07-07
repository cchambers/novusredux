function GetNearbyPassableLoc(targetObj,angleRange,minDist,maxDist)
	if(targetObj == nil) then
		targetObj = this
	end

	if(not(targetObj) or not(targetObj:IsValid())) then
		return nil
	end

	angleRange = angleRange or 360
	minDist = minDist or 3
	maxDist = maxDist or 10

	local maxTries = 20
    local moveAngle = math.random(angleRange,angleRange*2)-angleRange
    local nearbyLoc = targetObj:GetLoc():Project(moveAngle, math.random(minDist,maxDist))
    -- try to find a passable location
    while(maxTries > 0 and not(IsPassable(nearbyLoc)) ) do
    	local moveAngle = math.random(angleRange,angleRange*2)-angleRange
        nearbyLoc = targetObj:GetLoc():Project(moveAngle, math.random(minDist,maxDist))
        maxTries = maxTries - 1
    end

    return nearbyLoc
end

function GetNearbyPassableLocFromLoc(targetLoc,minDist,maxDist)	
	local angleRange = 360
	minDist = minDist or 3
	maxDist = maxDist or 10

	local maxTries = 20
    local moveAngle = math.random(angleRange,angleRange*2)-angleRange
    local nearbyLoc = targetLoc:Project(moveAngle, math.random(minDist,maxDist))
    -- try to find a passable location
    while(maxTries > 0 and not(IsPassable(nearbyLoc)) ) do
    	local moveAngle = math.random(angleRange,angleRange*2)-angleRange
        nearbyLoc = targetLoc:Project(moveAngle, math.random(minDist,maxDist))
        maxTries = maxTries - 1
    end

    return nearbyLoc
end

function IsValidLoc(spawnLoc,excludeHousing,excludeRegions)
	if(spawnLoc == nil) then
		LuaDebugCallStack("Invalid Location!")
		return false
	end

	if not(IsPassable(spawnLoc)) then
		return false
	end

	if(excludeHousing) then
		local plotController = Plot.GetAtLoc(spawnLoc)
		if ( plotController ~= nil ) then return false end
	end
	if (excludeRegions ~= nil)then
		for i, region in pairs (excludeRegions) do
			if (IsLocInRegion(spawnLoc, region)) then
				return false
			end
		end
	end
	return true
end

function GetRandomPassableLocationFromRegion(region,excludeHousing, excludeRegions)
    local maxTries = 20
    local spawnLoc = region:GetRandomLocation()
    -- try to find a passable location
    while(maxTries > 0 
    		and not(IsValidLoc(spawnLoc,excludeHousing,excludeRegions)) ) do
        spawnLoc = region:GetRandomLocation()
        maxTries = maxTries - 1
    end

    if(maxTries > 0) then
	    return spawnLoc
	end

	return nil
end 

function GetRandomPassableLocation(regionName,excludeHousing,excludeRegions)
	local region = GetRegion(regionName)
	if( region == nil ) then
		--LuaDebugCallStack("REGION IS NIL: "..tostring(regionName))
		return nil
	end
    return GetRandomPassableLocationFromRegion(region,excludeHousing, excludeRegions)
end 

function GetRandomPassableLocationInRadius(loc,radius,excludeHousing)
    local maxTries = 20

    local spawnDist = math.random() * radius
    local spawnAngle = math.random() * 360
    local spawnLoc = loc:Project(spawnAngle,spawnDist)

    -- try to find a passable location
    while(maxTries > 0 
    		and not(IsValidLoc(spawnLoc,excludeHousing,excludeRegions)) ) do

        spawnDist = math.random() * radius
	    spawnAngle = math.random() * 360
	    spawnLoc = loc:Project(spawnAngle,spawnDist)
    end

    if(maxTries > 0) then
	    return spawnLoc
	end

	return nil
end 

function GetRandomLocationInObjectBounds(bounds)
    if(bounds == nil or #bounds == 0) then
        return nil
    end

    local bounds3 = bounds[math.random(#bounds)]
    local curBounds = bounds3:Flatten()

    return Loc(curBounds:GetRandomLocation())
end

function GetRandomDungeonSpawnLocation(regionName)
    --DebugMessage("GetRandomSpawnLocation "..tostring(entry.Region))
    local region = GetRegion(regionName)
    if( region == nil ) then
        --LuaDebugCallStack("REGION IS NIL: "..regionName)
        return nil
    end

    local searcher = PermanentObjSearchMulti{
            PermanentObjSearchRegion(regionName),
            PermanentObjSearchHasObjectBounds(),
            PermanentObjSearchVisualState("Default")
        }

    --local objs1 = FindPermanentObjects(PermanentObjSearchRegion(regionName))
    --local objs2 = FindPermanentObjects(PermanentObjSearchHasObjectBounds())
    --local objs3 = FindPermanentObjects(PermanentObjSearchVisualState("Default"))
    --DebugMessage("TEST",tostring(#objs1),tostring(#objs2),tostring(#objs3))

    local objs = FindPermanentObjects(searcher)
    if(#objs == 0) then
        --DebugMessage("ERROR: No dungeon tiles found in region "..tostring(regionName))
        return nil
    end

    local curPermObj = objs[math.random(#objs)]
    local curBounds = curPermObj:GetPermanentObjectBounds()
    local spawnLoc = GetRandomLocationInObjectBounds(curBounds)
    local maxTries = 20
    while(maxTries > 0 and (spawnLoc ~= nil and not(spawnLoc:IsValid()) or not(IsPassable(spawnLoc)) or TrapAtLocation(spawnLoc))) do--(spawnLoc,false))) do
        local curPermObj = objs[math.random(#objs)]
        local curBounds = curPermObj:GetPermanentObjectBounds()
        spawnLoc = GetRandomLocationInObjectBounds(curBounds)
        maxTries = maxTries - 1        
    end

    if(maxTries <= 0) then
        --DebugMessage("ERROR: Tried 20 times for a passable location and failed. "..regionName)
        return nil
    end

    return spawnLoc,curPermObj
    --return Loc(0,0,0),PermanentObj(0)
end