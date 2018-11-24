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