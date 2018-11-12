---- Settings
-- How often the spawner checks for missing mobs (Can be overridden by objvar SpawnGridPulseFrequency)
mSpawnPulseFrequency = TimeSpan.FromSeconds(5)
-- Regions to exclude as valid spawn locations (Overridden in initializer ExcludeRegions)
mExcludeRegions = {}
-- Regions to override the exclude (Overridden in initializer ExcludeRegions)
mExcludeOverrideRegions = {}

-- Default delay between when a mob goes missing and when it re-appears (Can be overridden in the spawn entry using DelayMin)
mDefaultSpawnDelay = TimeSpan.FromMinutes(4)

-- How often do we spawn mobs from the queue
mSpawnQueueFrequency = TimeSpan.FromSeconds(0.250)
-- How many mobs do we spawn each queue tick
mSpawnQueueSpawnCount = 1
----------------

mSpawnQueue = {}
mGridData = nil
mGridSize = nil
mDataDirty = false
mSubregionGameRegion = nil


function SchedulePulseTimer()
	local pulseOverride = this:GetObjVar("SpawnGridPulseFrequency")
	if(pulseOverride) then
		mSpawnPulseFrequency = TimeSpan.FromSeconds(pulseOverride)
	end

	this:ScheduleTimerDelay(mSpawnPulseFrequency,"grid_spawn_pulse")
end

function GetSpawnDelay(spawnInfo)
	if(spawnInfo.DelayMin) then
		return TimeSpan.FromMinutes(DelayMin)
	end

	return mDefaultSpawnDelay
end

function ShouldSpawn(spawnInfo,spawnIndex)	
	local spawnRefs = spawnInfo.SpawnRefs
	-- have we ever spawned this mob
	if( not(spawnRefs) or not(spawnRefs[spawnIndex]) ) then
		return true
	end

	--DebugMessage("TEST "..spawnIndex,DumpTable(spawnInfo.SpawnRefs[spawnIndex]))

	local isValid = spawnRefs[spawnIndex].ObjRef and spawnRefs[spawnIndex].ObjRef:IsValid()
	local isDead = spawnRefs[spawnIndex].ObjRef and IsDead(spawnRefs[spawnIndex].ObjRef)
	
	-- the mob is still on the map and hes not a pet, no spawn
	if( isValid and not(isDead) and not(spawnRefs[spawnIndex].ObjRef:HasObjVar("controller")) ) then
		return false
	end

	-- check if this is the first time hes disappeared
	local spawnDelay = GetSpawnDelay(spawnInfo)

	-- no spawn delay just spawn
	if( spawnDelay.TotalSeconds == 0 ) then
		return true
	end

	-- this mob just disappeared or died
	if( not(spawnRefs[spawnIndex].GoneTime) ) then	
		--DebugMessage("MOB DISAPPEARED")	
		spawnRefs[spawnIndex].GoneTime = DateTime.UtcNow
		mDataDirty = true
		return false
	end
	
	--DebugMessage("Checking GoneTime "..tostring(DateTime.UtcNow).." "..tostring(spawnRefs[spawnIndex].GoneTime + spawnDelay))
	-- check if the spawn delay has elapsed
	return DateTime.UtcNow > (spawnRefs[spawnIndex].GoneTime + spawnDelay)
end

function Pulse()	
	SchedulePulseTimer()

	-- sometimes the pulse fires before loaded from backup
	if not(mGridData) then
		return
	end

	-- wait till the last pulse is fully spawned before pulsing again
	if(#mSpawnQueue > 0) then
		--DebugMessage("SPAWN PULSE: Waiting on spawns "..#mSpawnQueue)
		return
	end

	--DebugMessage("SPAWN PULSE: Checking spawns")

	local globalMultiplier = this:GetObjVar("SpawnMultiplier") or 1	

	for i,gridSpawns in pairs(mGridData) do
		local spawnMultiplier = gridSpawns.SpawnMultiplier or 1
		for j,gridSpawn in pairs(gridSpawns.Spawns) do	
			local spawnCount = math.floor(gridSpawn.Count * spawnMultiplier * globalMultiplier)
			if(spawnCount > 0) then
				for k=1,spawnCount do
					--DebugMessage("SPAWN PULSE: Checking spawn "..DumpTable(gridSpawn))
					if( ShouldSpawn(gridSpawn,k) ) then
						--DebugMessage("SPAWN PULSE: Queuing "..gridSpawn.TemplateId)
						table.insert(mSpawnQueue,{
		                    Template = gridSpawn.TemplateId,
		                    GridLoc = gridSpawns.GridLoc,
		                    GridIndex = i,
		                    GridSpawnIndex = j,
		                    SpawnIndex = k
		                })
					end
				end
			end
		end
	end

	if(mDataDirty) then
		this:SetObjVar("SpawnGridData",mGridData)
		mDataDirty = false
	end

	if(#mSpawnQueue > 0 and not(this:HasTimer("grid_spawn_queue"))) then
		DoSpawnQueue()
	end
end

function IsValidGridLoc(curLoc)
	-- check server subregion
	if(mSubregionGameRegion and not(mSubregionGameRegion:Contains(curLoc))) then
		--DebugMessage("A "..tostring(curLoc))
		return false
	end

	local skipExclude = false
	if(mExcludeOverrideRegions) then
		for i,regionRef in pairs(mExcludeOverrideRegions) do
			if(regionRef:Contains(curLoc)) then
				--DebugMessage("B")
				skipExclude = true
			end
		end
	end

	if not(skipExclude) and (mExcludeRegions) then
		for i,regionRef in pairs(mExcludeRegions) do
			if(regionRef:Contains(curLoc)) then
				--DebugMessage("B")
				return false
			end
		end
	end

	return IsValidLoc(curLoc,true)
end

function GetGridSpawnLocation(gridLoc)
	-- TODO: Exclude certain regions
	local gridTopLeftX = gridLoc[1] * mGridSize
	local gridTopLeftY = gridLoc[2] * mGridSize	

	local spawnLoc = nil
	local maxTries = 20
	while(not(spawnLoc) and maxTries > 0) do
		local curLoc = Loc(gridTopLeftX + (math.random() * mGridSize),0,gridTopLeftY + (math.random() * mGridSize))
		--DebugMessage("gridTopLeftX",tostring(gridTopLeftX),"gridTopLeftY",tostring(gridTopLeftY),"curLoc",tostring(curLoc))

		if(IsValidGridLoc(curLoc)) then
			spawnLoc = curLoc
		end

		maxTries = maxTries - 1
	end

	if(maxTries == 0) then
		--DebugMessage("ERROR: Failed to find valid location. GridLoc: "..DumpTable(gridLoc))
	end

	return spawnLoc
end

function DoSpawnQueue()
	--DebugMessage("SPAWN PULSE: DoSpawnQueue "..#mSpawnQueue)
	local spawnCount = mSpawnQueueSpawnCount
	while(spawnCount > 0) do
		if(#mSpawnQueue > 0) then
			local spawnIndex = math.random(1,#mSpawnQueue)
			local spawnInfo = mSpawnQueue[spawnIndex]
			table.remove(mSpawnQueue,spawnIndex)

			local spawnLoc = GetGridSpawnLocation(spawnInfo.GridLoc)
			if(spawnLoc) then
				--DebugMessage("SPAWN PULSE: DoSpawnQueue Spawning "..spawnInfo.Template.." at "..tostring(spawnLoc))
				CreateObj(spawnInfo.Template, spawnLoc, "grid_spawn_created", spawnInfo)				
			end
			this:ScheduleTimerDelay(mSpawnQueueFrequency,"grid_spawn_queue")
		end
		spawnCount = spawnCount - 1
	end
end

RegisterEventHandler(EventType.Timer,"grid_spawn_pulse",function ()
		Pulse()
	end)

RegisterEventHandler(EventType.Timer,"grid_spawn_queue",function ()
		DoSpawnQueue()
	end)

RegisterEventHandler(EventType.CreatedObject,"grid_spawn_created",
	function (success,objRef,spawnData)
		if(success) then
			mGridData = mGridData or this:GetObjVar("SpawnGridData")
			local spawnInfo = mGridData[spawnData.GridIndex].Spawns[spawnData.GridSpawnIndex] 
			if not(spawnInfo.SpawnRefs) then
				spawnInfo.SpawnRefs = {}
			end
			-- todo update ai to wander only in grid
			objRef:SetObjVar("homeGrid", {GridLoc=spawnData.GridLoc,GridSize=mGridSize})

			-- Use this for debugging purposes
			--objRef:SetObjVar("GridSpawnData", spawnData)
			if(objRef:IsMobile()) then
				objRef:SetFacing( math.random(0, 360))
			end

			spawnInfo.SpawnRefs[spawnData.SpawnIndex] = { ObjRef = objRef }
			mDataDirty = true
		end
	end)

function OnLoad()		
	local subregionName = GetSubregionName()
	if(subregionName ~= nil) then
		mSubregionGameRegion = GetRegion("Subregion-"..subregionName)
	end

	-- we convert the region names to actual region refs for performance reasons
	local excludeRegionNames = this:GetObjVar("ExcludeRegions")
	if(excludeRegionNames) then
		mExcludeRegions = {}
		for i, regionName in pairs(excludeRegionNames) do
			local regionRef = GetRegion(regionName)
			if(regionRef) then
				table.insert(mExcludeRegions,regionRef)
			end
		end
	end

	-- we convert the region names to actual region refs for performance reasons
	local excludeOverrideRegionNames = this:GetObjVar("ExcludeOverrideRegions")
	if(excludeOverrideRegionNames) then
		mExcludeOverrideRegions = {}
		for i, regionName in pairs(excludeOverrideRegionNames) do
			local regionRef = GetRegion(regionName)
			if(regionRef) then
				table.insert(mExcludeOverrideRegions,regionRef)
			end
		end
	end

	SchedulePulseTimer()
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function()
		if(initializer.GridInfo) then
			-- In order to be able to use defines, we need to deepcopy this bad boy
			mGridData = deepcopy(initializer.GridInfo)
			this:SetObjVar("SpawnGridData",mGridData)
		else
			DebugMessage("ERROR: Grid spawner requires GridInfo in initializer Template: "..this:GetCreationTemplateId())
		end

		if(initializer.GridSize) then
			this:SetObjVar("SpawnGridSize",initializer.GridSize)
			mGridSize = initializer.GridSize
		else
			DebugMessage("ERROR: Grid spawner requires GridSize in initializer Template: "..this:GetCreationTemplateId())
		end

		if(initializer.ExcludeRegions) then
			this:SetObjVar("ExcludeRegions",initializer.ExcludeRegions)			
		end

		if(initializer.ExcludeOverrideRegions) then
			this:SetObjVar("ExcludeOverrideRegions",initializer.ExcludeOverrideRegions)			
		end

		OnLoad()
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function()
		mGridData = this:GetObjVar("SpawnGridData")
		mGridSize = this:GetObjVar("SpawnGridSize")

		OnLoad()		
	end)

RegisterEventHandler(EventType.Message,"DumpGridData",
	function()
		DebugMessage("------------------")
		DebugMessage(DumpTable(mGridData))
		DebugMessage("------------------")
	end)