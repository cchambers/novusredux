-- This module handles spawning schools of fish and also maintains a resource grid so you can't fish the same location forever

require 'incl_fishing'

DEFAULT_SCHOOl_COUNT = 20
SCHOOL_MIN_SKILL_CUTOFF = 10

SPAWN_DELAY_SECS = TimeSpan.FromSeconds(5)

-- fish resource grid resets on server restart
fishResourceGrid = {}

--Override this because timers are shared.

function OnModuleLoaded()
	if(initializer and initializer.FishRegions) then
		this:SetObjVar("FishRegions",initializer.FishRegions)
	end

	Initialize()
	--DebugMessage("this should print 3 times")
end

function OnLoadedFromBackup()
	-- this ensures that the timer does not get hosed 
	Initialize()
end

function Initialize()
	--DebugMessage("initalizing")
	this:ScheduleTimerDelay(SPAWN_DELAY_SECS,"check_fish_spawn")
end

function CheckFishSpawn()
	--DebugMessage("CheckFishSpawn")
	this:ScheduleTimerDelay(SPAWN_DELAY_SECS,"check_fish_spawn")

	local spawnedCamps = this:GetObjVar("SpawnedFish") or {}
	for i,j in pairs(spawnedCamps) do
		--DebugMessage("Fish at location "..tostring(j:GetLoc()) .." Fish is valid:"..tostring(j:IsValid()))
		if not j:IsValid() then
			spawnedCamps[i] = nil
			--DebugMessage("Removing Fish at "..tostring(i))
		end
	end
	this:SetObjVar("SpawnedFish",spawnedCamps)
	campSize = CountTable(spawnedCamps)
	local schoolMax = this:GetObjVar("FishSchoolCount") or DEFAULT_SCHOOl_COUNT
	--DebugMessage("CheckFishSpawn",tostring(campSize),tostring(schoolMax))
	-- start at a random index and go through the list to find an available location
	if (campSize <= schoolMax) then
		SpawnCamp(curIndex)
		--DebugMessage("Fish Spawned")
	end
end

function SpawnCamp()
	--DebugMessage("Camp Spawned!")
	local region = GetRegion("Water")
	local loc = this:GetLoc()
	if (region ~= nil) then
		loc = region:GetRandomLocation()
	else
		--DebugMessage("[fish_controller] ERROR: NO WATER REGION ON MAP!!!")
		return
	end
	local schoolTemplate = GetSchoolOfFishTypeRoll(GetFishResourceTable(this,loc),SCHOOL_MIN_SKILL_CUTOFF)
	if(schoolTemplate) then
		--DebugMessage("CREATING FISH SCHOOL "..schoolTemplate..", "..tostring(loc))
		CreateTempObj(schoolTemplate, loc, "fish_created" )
	end
end

function HandleFishCreated(success,objRef)
	if( success ) then
		-- update tracking objvar
		local spawnedCamps = this:GetObjVar("SpawnedFish") or {}
		table.insert(spawnedCamps,objRef)
		this:SetObjVar("SpawnedFish", spawnedCamps)
		-- make fish schools decay every 5-10 minutes
		-- DAB TODO: Fish schools should decay with repeated use
		objRef:SetObjVar("DecayTime",300 + math.random(0,300))
		--DebugMessage("[cultist_camp_spawner::HandleCampCreated] Created camp at " .. tostring(campLoc.Loc).. "Difficulty: "..difficulty)
	end
end

-- you can send 0 as the depletion amount to check if there is a fish resource at this location
function HandleRequestFishResource(user,fishLoc)	
	local depletionAmount = 1
	local fishResult = nil

	local gridKeyX = math.floor(fishLoc.X / ServerSettings.Resources.Fish.GridElementSize)
	local gridKeyY = math.floor(fishLoc.Z / ServerSettings.Resources.Fish.GridElementSize)
	if not(fishResourceGrid[gridKeyX]) then
		fishResourceGrid[gridKeyX] = {}
	end
	local elementInfo = fishResourceGrid[gridKeyX][gridKeyY] or {}	

	--DebugMessage("HandleRequestFishResource",tostring(gridKeyX),tostring(gridKeyY))
	
	-- if the element was previously completely depleted, check to see if it's regenerated yet
	if(elementInfo.TimeDepleted) then
		local elapsed = DateTime.UtcNow:Subtract(elementInfo.TimeDepleted)
		if(elapsed < ServerSettings.Resources.Fish.GridElementRegenRate) then
			--DebugMessage("HandleRequestFishResource","Depleted")
			-- Resource is depleted, send failed response
			user:SendMessage("RequestFishResourceResponse",fishResult)
			return
		else
			--DebugMessage("HandleRequestFishResource","Depleted Regen Complete")
			elementInfo.TimeDepleted = nil
			elementInfo.Depletion = 0
		end
	end
	
	if(depletionAmount > 0) then
		elementInfo.Depletion = (elementInfo.Depletion or 0) + depletionAmount
		--DebugMessage("HandleRequestFishResource","New Depletion",tostring(elementInfo.Depletion))
	
		if(elementInfo.Depletion >= ServerSettings.Resources.Fish.GridElementCount) then
			--DebugMessage("HandleRequestFishResource","Full Depletion, Entering Regen")
			elementInfo.TimeDepleted = DateTime.UtcNow
		end

		local fishResourceTable = GetFishResourceTable(this,fishLoc)
        fishResult = GetFishRoll(fishResourceTable)
        --DebugMessage("fishResult",DumpTable(fishResult))
	end

	if(elementInfo.Depletion == 0) then
		fishResourceGrid[gridKeyX][gridKeyY] = nil
	else
		fishResourceGrid[gridKeyX][gridKeyY] = elementInfo
	end
	
	--DebugMessage("HandleRequestFishResource","Success")
	user:SendMessage("RequestFishResourceResponse",fishResult)
end

function HandleReset( ... )
	fishResourceGrid = {}
end

if( initializer ~= nil ) then

	--DebugMessage("Camp Locations are generated")
	--DebugMessage(DumpTable(campLocations))
	--DebugMessage("Camp Locations are objvars")
	--DebugMessage(DumpTable(campLocations))
else
	campLocations = {}
	--DebugMessage("Camp Locations are nil")
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),OnModuleLoaded)
RegisterSingleEventHandler(EventType.LoadedFromBackup,nil,OnLoadedFromBackup)
RegisterEventHandler(EventType.Timer,"check_fish_spawn",CheckFishSpawn)
RegisterEventHandler(EventType.CreatedObject, "fish_created", HandleFishCreated)
RegisterEventHandler(EventType.Message,"RequestFishResource",HandleRequestFishResource)
RegisterEventHandler(EventType.Message,"ResetFishResources",HandleReset)