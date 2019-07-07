
-- wander around in the specified region, if we
-- are not in that region, it will wander towards it
function WanderInRegion(regionName,identifier,wanderSpeed)	
	local wanderLoc = nil
	local myLoc = this:GetLoc()
	local region = nil
	if (regionName ~= nil) then
		region = GetRegion(regionName)
	end

	-- if we are in our home region, pick a location nearby that is still in our home region
	if( region ~= nil ) then
		if( region:Contains(myLoc) ) then
			local maxTries = 20    
	    	while(maxTries > 0 and (wanderLoc == nil or not(region:Contains(wanderLoc)) or not(IsPassable(wanderLoc) or TrapAtLocation(wanderLoc)))) do
	      		wanderLoc = myLoc:Project(math.random(0,360), math.random(1,3))
	      		maxTries = maxTries - 1
	    	end

	    	if(maxTries <= 0) then
	    		--DebugMessage("ERROR: WanderInRegion failed to find a location - "..tostring(this:GetName())..", Loc: "..tostring(this:GetLoc())..", Region: "..tostring(region))
	    		return false
	    	end
	  	-- otherwise wander towards our home region
	  	else
			local regionLoc = region:GetRandomLocation()
			wanderLoc = myLoc:Project(myLoc:YAngleTo(regionLoc), math.random(5,10))
		end
	else		
		local spawnLoc = this:GetObjVar("SpawnPosition") or myLoc
		wanderLoc = spawnLoc:Project(math.random(0,360), math.random(2,4))
	end

	if( wanderLoc ~= nil ) then
		-- we dont want to pass nil for a string identifier
		if( identifier == nil ) then identifier = "" end
		if( wanderSpeed == nil ) then wanderSpeed = 1.0 end

		--DebugMessage("WANDERING TO "..tostring(wanderLoc).." MyLoc: "..tostring(myLoc).." #"..this.Id)

		this:PathTo(wanderLoc,wanderSpeed,identifier)
		return wanderLoc
	end

	return false
end

function WanderTowards(destLoc,variation,wanderspeed,identifier)
	if (destLoc == Loc(0,0,0) or destLoc == nil) then LuaDebugCallStack("[incl_regions] ERROR: destination location is nil or at the origin!") end
	local myLoc = this:GetLoc()
	local wanderLoc = nil
	if( variation == nil or variation == 0 ) then
		wanderLoc = myLoc:Project(myLoc:YAngleTo(destLoc), math.random(5,10))
		if not(IsPassable(wanderLoc)) then
  			wanderLoc = nil
  		end
  	else
		local maxTries = 20    
		while(maxTries > 0 and wanderLoc == nil) do
			local actualVariation = math.random(variation) - (variation/2)
	  		wanderLoc = myLoc:Project(myLoc:YAngleTo(destLoc) + actualVariation, math.random(5,10))
	  		if not(IsPassable(wanderLoc)) then
	  			wanderLoc = nil
	  		end
	  		maxTries = maxTries - 1
		end
	end

	if( wanderLoc ~= nil ) then
		-- we dont want to pass nil for a string identifier
		if( identifier == nil ) then identifier = "" end

		this:PathTo(wanderLoc,wanderspeed,identifier)
		return true
	end

	return false
end

function WanderInFacingDirection(targetMob,angleRange,minDist,maxDist,speed,identifier)
    local maxTries = 20
    if (target == nil) then target = this end
    
    local wanderLoc = GetNearbyPassableLoc(targetMob,angleRange,minDist,maxDist)

    if( wanderLoc ~= nil ) then
		-- we dont want to pass nil for a string identifier
		if( identifier == nil ) then 
			this:PathTo(wanderLoc,speed)
		else
			this:PathTo(wanderLoc,speed,identifier)
		end
		
		return true
	end

	return false
end