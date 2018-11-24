campLocations = {}
campMaxNumber = 6

SPAWN_DELAY_SECS = TimeSpan.FromSeconds(60) -- 1 minute spawn delay

function OnModuleLoaded()
	Initialize()
	--DebugMessage("this should print 3 times")
end

function OnLoadedFromBackup()
	-- this ensures that the timer does not get hosed 
	Initialize()
end

function Initialize()
	--DebugMessage("initalizing")
	this:ScheduleTimerDelay(SPAWN_DELAY_SECS,"spawn_check")
end

function CheckSpawn()
	--DebugMessage("CheckSpawn")
	this:ScheduleTimerDelay(SPAWN_DELAY_SECS,"spawn_check")

	local spawnedCamps = this:GetObjVar("SpawnedCamps") or {}
	for i,j in pairs(spawnedCamps) do
		--DebugMessage("Camp at location "..tostring(j:GetLoc()) .." camp is valid:"..tostring(j:IsValid()))
		if not j:IsValid() then
			spawnedCamps[i] = nil
			--DebugMessage("Removing camp at "..tostring(i))
		end
	end
	this:SetObjVar("SpawnedCamps",spawnedCamps)
	campSize = CountTable(spawnedCamps)
	-- start at a random index and go through the list to find an available location
	local curIndex = math.random(#campLocations)
	local checkCount = 0
	while(checkCount < #campLocations) do
		curObj = spawnedCamps[curIndex]
            local plotController = Plot.GetAtLoc(campLocations[curIndex].Loc) --you don't want cultists making a camp inside a house
            if ( plotController == nil ) then
				if( curObj == nil or not(curObj:IsValid()) ) then
					if (campSize <= campMaxNumber) then
						SpawnCamp(curIndex)
						--DebugMessage("Camp Spawned")
						break
					end
				end
			end
		curIndex = (curIndex % #campLocations) + 1
		checkCount = checkCount + 1
	end

end

function SpawnCamp(locIndex)
	--DebugMessage("Camp Spawned!")
	CreateObj(this:GetObjVar("CampTemplate"), campLocations[locIndex].Loc, "camp_created", locIndex)
end

function HandleCampCreated(success,objRef,locIndex)
	if( success ) then
		local campLoc = campLocations[locIndex]

		-- set camp difficulty
		local difficulty = campLoc.Difficulties[math.random(#campLoc.Difficulties)]
		objRef:SetObjVar("Difficulty",difficulty)

		-- update tracking objvar
		local spawnedCamps = this:GetObjVar("SpawnedCamps") or {}
		spawnedCamps[locIndex] = objRef
		this:SetObjVar("SpawnedCamps", spawnedCamps)

		--DebugMessage("[cultist_camp_spawner::HandleCampCreated] Created camp at " .. tostring(campLoc.Loc).. "Difficulty: "..difficulty)
	end
end

if( initializer ~= nil ) then
	campLocations = initializer.campLocations
	if( initializer.maxCamps ~= nil ) then
		campMaxNumber = initializer.maxCamps
	end
	this:SetObjVar("CampLocations",campLocations)
	this:SetObjVar("MaxCamps",campMaxNumber)
	--DebugMessage("Camp Locations are generated")
	--DebugMessage(DumpTable(campLocations))
elseif( this:HasObjVar("CampLocations")) then
	campLocations = this:GetObjVar("CampLocations")
	campMaxNumber = this:GetObjVar("MaxCamps")
	--DebugMessage("Camp Locations are objvars")
	--DebugMessage(DumpTable(campLocations))
else
	campLocations = {}
	--DebugMessage("Camp Locations are nil")
end

RegisterSingleEventHandler(EventType.ModuleAttached,GetCurrentModule(),OnModuleLoaded)
RegisterSingleEventHandler(EventType.LoadedFromBackup,nil,OnLoadedFromBackup)
RegisterEventHandler(EventType.Timer,"spawn_check",CheckSpawn)
RegisterEventHandler(EventType.CreatedObject, "camp_created", HandleCampCreated)