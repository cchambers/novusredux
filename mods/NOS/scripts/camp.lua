
DEFAULT_LIFETIME = 30 * 60 -- 30 minutes



PLAYER_DESPAWN_RANGE = 40.0

DefaultDifficultySettings = 
{
	['Easy'] = {
		['MobCount'] = 2,
		['MobTemplates'] =  { "cultist_mage_apprentice", "cultist_warrior_rookie","cultist_mage_apprentice_female", "cultist_warrior_rookie_female" },
		['TreasureTemplate'] = "treasurechest_cultistcamp_easy",
	},

	['Medium'] = {
		['MobCount'] = 2,
		['MobTemplates'] =  { "cultist_mage_apprentice", "cultist_mage_devout", "cultist_warrior_rookie", "cultist_warrior_veteran", "cultist_mage_apprentice_female", "cultist_mage_devout_female", "cultist_warrior_rookie_female", "cultist_warrior_veteran_female" },
		['TreasureTemplate'] = "treasurechest_cultistcamp_medium",
	},

	['Hard'] = {
		['MobCount'] = 3,
		['MobTemplates'] =  { "cultist_mage_apprentice", "cultist_mage_devout", "cultist_warrior_rookie", "cultist_warrior_veteran", "cultist_mage_apprentice_female", "cultist_mage_devout_female", "cultist_warrior_rookie_female", "cultist_warrior_veteran_female"},
		['BossTemplates'] = { "cultist_boss_archmage", "cultist_boss_weaponmaster" },
		['TreasureTemplate'] = "treasurechest_cultistcamp_hard",	
	}
}
if (initializer ~= nil) then
	DifficultySettings = initializer.DifficultySettings or DefaultDifficultySettings
else
	DifficultySettings = DefaultDifficultySettings
end

function GetLifetime()
	return this:GetObjVar("Lifetime") or DEFAULT_LIFETIME
end

function GetDifficulty()
	return this:GetObjVar("Difficulty") or "Medium"
end

function HandleDelayedInit()	
end

function GetSpawnLocs(numSpawnItems)
	local spawnLocs = {}
	local centerLoc = this:GetLoc()

	local spawnInc = 360 / numSpawnItems
	local deviation = math.max(0,(spawnInc/2) - 15)

	for i=1, numSpawnItems do
		local spawnDist = 3 + (math.random() / 2)
		local spawnAngle = (spawnInc * i) + math.random(-deviation,deviation)
		spawnLocs[#spawnLocs+1] = centerLoc:Project(spawnAngle, spawnDist)
	end

	return spawnLocs
end


function SpawnCamp()
	local difficulty = GetDifficulty()

	--DebugMessage("[cultist_camp::SpawnCamp] Spawning camp at ".. tostring(this:GetLoc()) .." with difficulty "..tostring(difficulty))

	local settings = DifficultySettings[difficulty]
	
	local hasBoss = settings.BossTemplates ~= nil

	-- add 1 for the treasure chest
	local spawnCount = settings.MobCount + 1
	-- add 1 for the boss
	if( hasBoss ) then
		spawnCount = spawnCount + 1
	end

	-- get random spawn positions around the fire
	local spawnLocs = GetSpawnLocs(spawnCount)

	local spawnIndex = 1
	for i=1, settings.MobCount do
		local templateId = settings.MobTemplates[math.random(#settings.MobTemplates)]
   		CreateObj(templateId, spawnLocs[spawnIndex], "created", "mob_spawn", i)
   		spawnIndex = spawnIndex + 1
	end

	if( hasBoss ) then
		local templateId = settings.BossTemplates[math.random(#settings.BossTemplates)]
   		CreateObj(templateId, spawnLocs[spawnIndex], "created", "boss")
   		spawnIndex = spawnIndex + 1
   	end	 

   	if( settings.TreasureTemplate ~= nil ) then
		CreateObj(settings.TreasureTemplate, spawnLocs[spawnIndex], "created", "chest")	
	end
end

function GetKeyContainer()	
	local keyHolder = this:GetObjVar("spawnedBoss")

	-- if there is no boss then put it on the first cultist
	if( keyHolder == nil ) then
		local spawnedList = this:GetObjVar("spawnedMobs")
		--DebugMessage("Spawned list: "..tostring(spawnedList))
		if( spawnedList ~= nil and #spawnedList > 0 ) then
			keyHolder = spawnedList[1]
		end
	end

	-- grab the key holders backpack
	if( keyHolder ~= nil and keyHolder:IsValid() ) then
		return keyHolder:GetEquippedObject("Backpack")
	end

	return nil
end

function HandleCampDecay()
	--DebugMessage("CAMP DECAY")	

	-- if there are players around reschedule the decay
	-- check camp first
	local nearbyPlayers = FindObjects(SearchPlayerInRange(PLAYER_DESPAWN_RANGE,true))
	if( #nearbyPlayers > 0) then
		-- schedule our timer for the camp to despawn
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(60), "camp_decay")
		return
	end

	-- check any cultists that are not near the camp
	local spawnedMobs = this:GetObjVar("spawnedMobs") or {}
	if (spawnedMobs ~= nil) then
		for index, mob in pairs(spawnedMobs) do		
			if( mob ~= nil and mob:IsValid() and mob:DistanceFrom(this) > 5 ) then
				local nearbyPlayers = FindObjects(SearchPlayerInRange(PLAYER_DESPAWN_RANGE,true),mob)
				if( #nearbyPlayers > 0) then
					-- schedule our timer for the camp to despawn
					this:ScheduleTimerDelay(TimeSpan.FromSeconds(DESPAWN_TIME), "camp_decay")
					return
				end
			end
		end
	end

	-- check le boss
	local bossRef = this:GetObjVar("spawnedBoss")
	if( bossRef ~= nil and bossRef:IsValid() and bossRef:DistanceFrom(this) > 5) then
		local nearbyPlayers = FindObjects(SearchPlayerInRange(PLAYER_DESPAWN_RANGE,true),bossRef)
		if( #nearbyPlayers > 0) then
			-- schedule our timer for the camp to despawn
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(60), "camp_decay")
			return
		end
	end

	-- no players, destroy camp
	for index, mob in pairs(spawnedMobs) do
		if( mob ~= nil and mob:IsValid() ) then
			mob:Destroy()
		end
	end

	if( bossRef ~= nil and bossRef:IsValid() ) then
		bossRef:Destroy()
	end

	local spawnedProps = this:GetObjVar("spawnedProps") or {}
	for index, prop in pairs(spawnedProps) do
		if( prop ~= nil and prop:IsValid() ) then
			prop:Destroy()
		end
	end

	this:Destroy()
end

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
	function()
		-- wait till the creator has a chance to set objvars before initializing
		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1000), "delayed_init")
	end)
RegisterEventHandler(EventType.Timer, "delayed_init", 
	function()
	    -- schedule our timer for the camp to despawn
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(GetLifetime()), "camp_decay")
		SpawnCamp()
	end)
RegisterEventHandler(EventType.Timer, "camp_decay", 
	function()
		HandleCampDecay()
	end)
RegisterEventHandler(EventType.Timer, "treasure_delay", 
	function(objRef)
		local keyContainer = GetKeyContainer()

		if( keyContainer ~= nil ) then
			--DebugMessage("Key Container Found "..tostring(keyContainer:GetName())..", "..tostring(keyContainer.Id))
			-- this fancy script will create a key for this chest automatically
			objRef:SetObjVar("OneTimeKey",true)
			objRef:SetObjVar("keyDestinationContainer",keyContainer)
			objRef:AddModule("create_key")
			-- DAB TODO: FILL WITH FAT LEWTS!
		end
	end)
RegisterEventHandler(EventType.CreatedObject, "created", 
	function(success,objRef,spawnType,spawnIndex)
		if( success ) then
			if(spawnType == "mob_spawn" or spawnType == "boss") then
				local facing = objRef:GetLoc():YAngleTo(this:GetLoc())
				objRef:SetFacing(facing)

				if( spawnType == "mob_spawn" ) then
					AddToListObjVar(this,"spawnedMobs",objRef)
				else
					this:SetObjVar("spawnedBoss",objRef)
				end
				objRef:SetObjVar("controller",this)
				objRef:SetObjVar("AI-CanWander",false)
				objRef:SetObjVar("AI-StationedLeash",true)
				objRef:SetObjVar("AI-Leash",true)
				objRef:SetObjVar("homeLoc",objRef:GetLoc())		
			elseif(spawnType == "chest") then
				-- wait for the camp to finish setup so we have access to the mob's packs
				this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"treasure_delay",objRef)
				AddToListObjVar(this,"spawnedProps",objRef)
			end
		end
	end)