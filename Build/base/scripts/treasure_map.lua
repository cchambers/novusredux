require 'incl_regions'
require 'incl_player_titles'

function ValidateUse(user)
	if( user == nil or not(user:IsValid()) ) then
		return false
	end

	if( this:TopmostContainer() ~= user ) then
		user:SystemMessage("[$2644]","info")
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

function IsPrecise()
	return this:GetObjVar("Precise")
end

function CanRead(user,difficulty)
	if(IsPrecise()) then
		return true
	end

	local difficulty = difficulty
	local skillValue = GetSkillLevel(user,"TreasureHuntingSkill")
	
	return skillValue >= difficulty - 25
end

function DecipherMap(user)
	local difficulty = this:GetObjVar("Difficulty")
	if not(CanRead(user,difficulty)) then
		user:SystemMessage("You have no chance of deciphering this map.","info")
		return
	end

	local skillLevel = GetSkillLevel(user,"TreasureHuntingSkill")
	local decipherChance = SkillValueMinMax(skillLevel, difficulty - 25, difficulty + 25 )
	if(IsPrecise() or CheckSkillChance(user,"TreasureHuntingSkill", skillLevel, decipherChance)) then
		local regionalName = this:GetObjVar("RegionalName")
		this:SetObjVar("Deciphered",true)
		user:SystemMessage("You decipher the map and find it to be in "..regionalName[2]..".","info")
		SetTooltipEntry(this,"decipher",regionalName[2])
		RemoveUseCase(this,"Decipher")
		AddUseCase(this,"Study",true,"HasObject")

		local accuracyRoll = math.random(1,math.clamp(decipherChance,0,1)*100)
		local accuracyDist = 15
		local accuracyStr = "Vague"
		if(accuracyRoll > 99) then
			accuracyStr = "Precise"
			this:SetObjVar("Precise",true)
			accuracyDist = 2
			CheckAchievementStatus(user, "TreasureHunting", "DecipherPrecise", 1)
		elseif( accuracyRoll > 90) then
			accuracyStr = "Accurate"
			accuracyDist = 5
		elseif(accuracyRoll > 50) then
			accuracyStr = "Approximate"
			accuracyDist = 10
		else
			accuracyStr = "Vague"
			accuracyDist = 15
		end
		this:SetObjVar("Accuracy",accuracyDist)
		local name,color = StripColorFromString(this:GetName())
		this:SetName((color or "") .. accuracyStr .. " " .. name .. "[-]")
	elseif(Success(ServerSettings.Durability.Chance.OnMapDecipher)) then
		user:SystemMessage("You fail to decipher the map and damage it in the process.","info")
		AdjustDurability(this, ServerSettings.Durability.FailHit.OnMapDecipher)
	else
		user:SystemMessage("You fail to decipher the map.","info")
	end
end

function StudyMap(user)
	local regionalName = this:GetObjVar("RegionalName")
	if not(this:HasObjVar("Deciphered")) then
		DebugMessage("ERROR: Studying map thats not deciphered!")
		return
	end

	local difficulty = this:GetObjVar("Difficulty")
	if not(CanRead(user,difficulty)) then
		user:SystemMessage("You have no chance of studying this map.","info")
		return
	end

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
		return
	end

	if (regionRef ~= nil) then
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
			return
		end
	end

	local difficulty = this:GetObjVar("Difficulty")
	if not(IsPrecise() or CheckSkill(user,"TreasureHuntingSkill", difficulty)) then
		user:SystemMessage("You damage the map slightly while attempting to read it.","info")
		AdjustDurability(this,-1)
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
	local accuracyDist = this:GetObjVar("Accuracy") or 5
	if( distance > accuracyDist ) then
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

		user:SystemMessage("[$2647]"..direction..".","info")
	else
		user:SystemMessage("[$2648]","info")
	end
end

RegisterEventHandler(EventType.LoadedFromBackup, "", function ()
	--DebugMessage("Fired")
	if (not this:HasObjVar("MapLocation")) then
		--DebugMessage("Finding location")
		FindTreasureLocation()
	end
end)

function FindTreasureLocation()
	if (not this:HasObjVar("RegionalName")) then
		DebugMessage("[treasure_map] Had a map with no map regions.")
		this:Destroy()
		return
	end
	--DebugMessage(ServerSettings.WorldName,this:GetObjVar("Shard"),ServerSettings.WorldName == this:GetObjVar("Shard"))
	if( ServerSettings.WorldName == "NewCelador" ) then
		local regionRef = GetRegion(this:GetObjVar("RegionalName")[1])
		if (regionRef ~= nil) then
			--DebugMessage(this:GetObjVar("RegionalName")[1])
			--DebugMessage(regionRef.RegionName)
			local excludedRegions = {}
			table.insert(excludedRegions,GetRegion("NoHousing"))
			table.insert(excludedRegions,GetRegion("Water"))
			local subregion = ServerSettings.SubregionName

			local mapLocation = GetRandomPassableLocation(regionRef.RegionName,true)
			mapLocation = TryRelocateMapLocation(mapLocation,regionRef,1, excludedRegions, subregion)

			if(mapLocation ~= nil ) then
				this:SetObjVar("MapLocation",mapLocation)
			else
				this:Destroy()
				return
			end
		end
	end
end

function TryRelocateMapLocation(mapLocation, regionRef, try, excludedRegions, subregion)
	if (try > 10) then
		DebugMessage("Failed to create treasure map (tried 10 times)")
		return nil
	elseif (mapLocation == nil) then
		mapLocation = GetRandomPassableLocation(regionRef.RegionName,true)
		mapLocation = TryRelocateMapLocation(mapLocation,regionRef,try+1, excludedRegions, subregion)
		return mapLocation
	end

	local invalidRegion = false

	if (not IsPassable(mapLocation)) then
		mapLocation = GetRandomPassableLocation(regionRef.RegionName,true)
		mapLocation = TryRelocateMapLocation(mapLocation,regionRef,try + 1, excludedRegions, subregion)
		return mapLocation
	end

	for key,value in pairs(excludedRegions) do
		if (value:Contains(mapLocation)) then
			invalidRegion = true
			break
		end
	end

	local regionsAtLoc = GetRegionsAtLoc(mapLocation)
	for key,value in pairs(regionsAtLoc) do
		if (string.find(tostring(value),"Subregion") and string.find(tostring(value),subregion) == nil) then
			invalidRegion = true
			break
		end
	end


	local nearbyGuard = nil
	if (invalidRegion == false) then
		nearbyGuard = FindObjects(SearchMulti(
		{
			SearchRange(mapLocation,15),
			SearchObjVar("IsGuard",true),
		}))
	end

	if (invalidRegion == true or #nearbyGuard ~= 0) then
		mapLocation = GetRandomPassableLocation(regionRef.RegionName,true)
		mapLocation = TryRelocateMapLocation(mapLocation,regionRef,try + 1, excludedRegions, subregion)
	end
	return mapLocation
end

RegisterSingleEventHandler(EventType.ModuleAttached,"treasure_map",
	function()
		this:SetObjVar("Reward",initializer.Rewards[math.random(1,#(initializer.Rewards))])
		--this:SetObjVar("MapRegions",initializer.MapRegions)		

		--DebugMessage(DumpTable(MapRegions))
		AddUseCase(this,"Decipher",true,"HasObject")

		if (initializer.RegionalNames and not (this:HasObjVar("RegionalName"))) then
            local mapRegion = GetRandomKeyInTable(initializer.RegionalNames)
			--DebugMessage(RegionalNames[mapRegion])
            this:SetObjVar("RegionalName",initializer.RegionalNames[mapRegion])
        end
		FindTreasureLocation()
	end)

studyLoc = nil

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if not(HasUseCase(this,usedType)) then 
			user:SystemMessage("You can't do that.","info")
			return 
		end

		if not( ValidateUse(user) ) then return end

		studyLoc = user:GetLoc()

		if(usedType == "Decipher") then
			user:SystemMessage("You begin to decipher the map.","info")
			user:PlayObjectSound("event:/objects/pickups/scroll/scroll_pickup")
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"study",user)
		elseif(usedType == "Study") then 			
			user:SystemMessage("You begin to study the map.","info")
			user:PlayObjectSound("event:/objects/pickups/scroll/scroll_pickup")
			--this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"study",user)
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"study",user)
		end
	end)

RegisterEventHandler(EventType.Timer,"study",
	function (user)
		if not( ValidateUse(user) ) then return end

		if( studyLoc:Distance(user:GetLoc()) < 1 ) then
			if not(this:GetObjVar("Deciphered")) then
				DecipherMap(user)
			else
				StudyMap(user)
			end
		else
			user:SystemMessage("[$2649]","info")
		end
	end)

RegisterEventHandler(EventType.Message,"FoundTreasure",
	function(user)
		if( user == nil or not(user:IsValid()) ) then return end

		local mapLocation = this:GetObjVar("MapLocation")
		local reward = this:GetObjVar("Reward")

		user:PlayObjectSound("event:/ui/skill_gain")
		
		local lifetimeStats = user:GetObjVar("LifetimePlayerStats")
		lifetimeStats.TreasureMaps = (lifetimeStats.TreasureMaps or 0) + 1
		CheckAchievementStatus(user, "TreasureHunting", "TreausreNumber", lifetimeStats.TreasureMaps)

		local name,color = StripColorFromString(GetTemplateData(this:GetCreationTemplateId()).Name)
		lifetimeStats[name] = (lifetimeStats[name] or 0) + 1
		CheckAchievementStatus(user, "TreasureHunting", name, lifetimeStats[name])

		user:SetObjVar("LifetimePlayerStats",lifetimeStats)
		--RemoveMapMarker(user,"TreasureMapMarker"..this.Id)

		--If treasure chest created, auto unstuck mobiles on treasure chest
		RegisterSingleEventHandler(EventType.CreatedObject, "treasure_chest_created", function(success, treasureChest)
			if ( not success ) then
				if ( tresaureChest ) then
					treasureChest:Destroy()
				end
				return
			end

	        -- auto unstuck mobiles on treasure chest
	        MoveMobilesOutOfObject(treasureChest)
	    end)

		CreateObj(reward, mapLocation, "treasure_chest_created")

		user:SystemMessage("You dug something up.", "info")
		user:SystemMessage("The treasure map disintegrates in your hands.", "info")
		--user:SendMessage("RequestSkillGainCheck", "TreasureHunterSkill", treasurehunterSkill)
		this:Destroy()
	end)