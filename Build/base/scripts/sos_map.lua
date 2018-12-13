require 'incl_regions'
require 'incl_player_titles'

function ValidateUse(user)
	if( user == nil or not(user:IsValid()) ) then
		return false
	end

	if( this:TopmostContainer() ~= user ) then
		user:SystemMessage("The map must be in your backpack before you can use it.","info")
		return false
	end

	return true
end

function GetRandomKeyInTable(_table)
	local resultTable = {}
	for i,j in pairs(_table) do
		table.insert(resultTable,i) 
	end
	return resultTable[math.random(1,#resultTable)]
end

function GetRandomRegionSubsetLocation(regionSubset)
	if (regionSubset == nil) then
		return nil
	end

	local maxTries = 20

	while (maxTries > 0) do
		local spawnLoc = regionSubset:GetRandomLocation()
		if (spawnLoc ~= nil) then
			return spawnLoc
		end
		maxTries = maxTries-1
	end
	return nil
end

function StudyMap(user)
	local regionalName = this:GetObjVar("RegionalName")
	if (regionalName == nil) then
		user:SystemMessage("[$2645]","info")
		return
	end
	
	if (ServerSettings.WorldName ~= "NewCelador") then
		user:SystemMessage("[$2646]","info")
		return
	end

	local regionRef = GetRegion(regionalName[1])
	if (regionRef == nil) then
		user:SystemMessage("The map points you towards "..regionalName[2],"info")
		SetTooltipEntry(this,"decipher",regionalName[2])
		return
	end

	local overlappingRegions = GetRegionsAtLoc(user:GetLoc())
	local selectedRegion = nil
	for regions, region in pairs(overlappingRegions) do
		if (region == regionRef.RegionName) then
			selectedRegion = region
			--DebugMessage(region.." is "..regionRef.RegionName)
		else
			--DebugMessage(region.." is not "..regionRef.RegionName)
		end
	end

	if (selectedRegion == nil)then
		user:SystemMessage("The map points you towards "..regionalName[2],"info")
		SetTooltipEntry(this,"decipher",regionalName[2])
		return
	end

	local mapLocation = this:GetObjVar("MapLocation")
	if( mapLocation == nil ) then
		user:SystemMessage("This map is too damaged to read","info")
		return
	end
	--user:SendMessage("OpenMapWindow")
	--AddMapMarker(user,{Icon="marker_diamond1", Location=mapLocation, Map=this:GetObjVar("Shard"), Tooltip="Buried Treasure"},"TreasureMapMarker"..this.Id)
	local myLoc = user:GetLoc()
	local distance = myLoc:Distance(mapLocation)
	if( distance > 58 ) then
		local angleTo = user:GetLoc():YAngleTo(mapLocation)

		local direction = nil
		if( angleTo > 337 or angleTo <= 22 ) then
			direction = "North"
		elseif( angleTo > 22 and angleTo <= 67 ) then
			direction = "Northeast"
		elseif( angleTo > 67 and angleTo <= 112 ) then
			direction = "East"	
		elseif( angleTo > 112 and angleTo <= 157 ) then
			direction = "Southeast"			
		elseif( angleTo > 157 and angleTo <= 202 ) then
			direction = "South"
		elseif( angleTo > 202 and angleTo <= 247 ) then
			direction = "Southwest"
		elseif( angleTo > 247 and angleTo <= 292 ) then
			direction = "West"
		else
			direction = "Northwest"
		end

		user:SystemMessage("You finish studying the map. You believe the sunken treasure is to the "..direction..".","info")
	else
		user:SystemMessage("You finish studying the map. You believe the sunken treasure is nearby.","info")
	end
end

function FindSosLocation()
	if (not this:HasObjVar("RegionalName")) then
		DebugMessage("[sos_map] ERROR: no regional name.")
		this:Destroy()
		return
	end

	--DebugMessage(ServerSettings.WorldName,this:GetObjVar("Shard"),ServerSettings.WorldName == this:GetObjVar("Shard"))
	if( ServerSettings.WorldName == "NewCelador" ) then
		local regionRef = GetRegion(this:GetObjVar("RegionalName")[1])
		if (regionRef ~= nil) then
			--DebugMessage(this:GetObjVar("RegionalName")[1])
			--DebugMessage(regionRef.RegionName)

			--local mapLocation = GetRandomPassableLocation(regionRef.RegionName)
			local regionalCoast = GameRegion.GetRegionSubset(GetRegion("Water"), regionRef)
			mapLocation = GetRandomRegionSubsetLocation(regionalCoast)

			if(mapLocation ~= nil ) then
				this:SetObjVar("MapLocation",mapLocation)
			end
		end
	end
end

RegisterEventHandler(EventType.LoadedFromBackup, "", 
	function ()
		--DebugMessage("Fired")
		if (not this:HasObjVar("MapLocation") ) and this:HasObjVar("RegionalName") then
			--DebugMessage("Finding location")
			FindSosLocation()
		end
	end)


RegisterSingleEventHandler(EventType.ModuleAttached,"sos_map",
	function()
		this:SetObjVar("Reward",initializer.Rewards[math.random(1,#(initializer.Rewards))])
	
		--DebugMessage(DumpTable(MapRegions))
		AddUseCase(this,"Study",true,"HasObject")

		if not (this:HasObjVar("RegionalName")) then
            local mapRegionIndex = GetRandomKeyInTable(initializer.RegionalNames)
            this:SetObjVar("RegionalName",initializer.RegionalNames[mapRegionIndex])
        end
		FindSosLocation()
	end)

studyLoc = nil

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Study") then return end

		if not( ValidateUse(user) ) then return end

		studyLoc = user:GetLoc()
		user:SystemMessage("You begin to study the map.","info")
		user:PlayObjectSound("event:/objects/pickups/scroll/scroll_pickup")
		--this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"study",user)
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"study",user)
	end)

RegisterEventHandler(EventType.Timer,"study",
	function (user)
		if not( ValidateUse(user) ) then return end

		if( studyLoc:Distance(user:GetLoc()) < 1 ) then
			StudyMap(user)
		else
			user:SystemMessage("You fail to decipher the map. Your concentration was interrupted.","info")
		end
	end)

RegisterEventHandler(EventType.Message,"FoundSosTreasure",
	function(user)
		if( user == nil or not(user:IsValid()) ) then return end

		local mapLocation = this:GetObjVar("MapLocation")
		local reward = this:GetObjVar("Reward")
		
		--RemoveMapMarker(user,"TreasureMapMarker"..this.Id)

		--First get nearby passable loc
		local nearbyLoc = GetNearbyPassableLoc(user,180,1.5,3)

		--If no passable loc found, try with different angle
		if (not(IsPassable(nearbyLoc))) then
			nearbyLoc = GetNearbyPassableLoc(user,-180,1.5,3)
		end

		--If no passable loc found yet, fails to fish up treasure
		if (not(IsPassable(nearbyLoc))) then
			user:NpcSpeechToUser("The line snaps!",user,"info")
			return
		end

		user:PlayObjectSound("event:/ui/skill_gain")

		CreateObj(reward, nearbyLoc)

		local lifetimeStats = user:GetObjVar("LifetimePlayerStats")
		lifetimeStats.SunkenTreasureMaps = (lifetimeStats.SunkenTreasureMaps or 0) + 1
		CheckAchievementStatus(user, "Fishing", "FishingTreasure", lifetimeStats.SunkenTreasureMaps)

		user:SetObjVar("LifetimePlayerStats",lifetimeStats)

		user:SystemMessage("You fished something up.","info")
		user:SystemMessage("The treasure map disintegrates in your hands.","info")
		this:Destroy()
	end)