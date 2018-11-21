require 'incl_regions'
require 'incl_player_titles'

function ValidateUse(user)
	if( user == nil or not(user:IsValid()) ) then
		return false
	end

	if( this:TopmostContainer() ~= user ) then
		user:SystemMessage("[FA0C0C] The map must be in your backpack before you can use it.","info")
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
	if (this:GetObjVar("RegionalName") == nil) then
		user:SystemMessage("[$2645]","info")
		return
	end
	
	if (GetWorldName() ~= "NewCelador") then
		user:SystemMessage("[$2646]","info")
		return
	end

	local regionRef = GetRegion("Area-"..this:GetObjVar("RegionalName"))
	if (regionRef == nil) then
		user:SystemMessage("The map points you towards "..this:GetObjVar("RegionalName"),"info")
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
		user:SystemMessage("The map points you towards "..this:GetObjVar("RegionalName"),"info")
		SetTooltipEntry(this,"decipher",this:GetObjVar("RegionalName"))
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

	--DebugMessage(GetWorldName(),this:GetObjVar("Shard"),GetWorldName() == this:GetObjVar("Shard"))
	if( GetWorldName() == "NewCelador" ) then
		local regionRef = GetRegion("Area-"..this:GetObjVar("RegionalName"))
		if (regionRef ~= nil) then
			--DebugMessage("Area-"..this:GetObjVar("RegionalName"))
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
		user:PlayObjectSound("ScrollPickup")
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

		user:PlayObjectSound("SkillGain")
		
		local lifetimeStats = user:GetObjVar("LifetimePlayerStats")
		lifetimeStats.TreasureMaps = (lifetimeStats.TreasureMaps or 0) + 1
		PlayerTitles.CheckTitleGain(user,AllTitles.ActivityTitles.TreasureHunter,lifetimeStats.TreasureMaps)
		user:SetObjVar("LifetimePlayerStats",lifetimeStats)
		--RemoveMapMarker(user,"TreasureMapMarker"..this.Id)
		CreateObj(reward, user:GetLoc():Project(180, 1.5))
		user:SystemMessage("You fished something up.","info")
		user:SystemMessage("The treasure map disintegrates in your hands.","info")
		this:Destroy()
	end)