--Spawned in the world. Spawns objects for assigned mission.
--This is created once a player has accepted a mission from a dispatcher

MissionControllerInit = MissionControllerInit or {}

--Spawn prefab and set up mission when player get's nearby
--Depending on the type of mission, run variant of MissionControllerInit afterwards
function InitMissionController()
	local missionData = this:GetObjVar("MissionData")
	local missionInfo = GetMissionTable(missionData.Key)

	if (missionInfo.PrefabName ~= nil) then
		local spawnLoc = GetNearbyRandomMissionSpawnLoc(missionInfo.PrefabName)

		if (spawnLoc == nil) then
			DebugMessage("Mission controller "..tostring(this).." failed to spawn prefab "..missionInfo.PrefabName)
			DestroyMissionController()
		end
		this:SetObjVar("PrefabSpawnLoc", spawnLoc)

		if (missionInfo.PrefabName ~= nil) then
			CreatePrefab(missionInfo.PrefabName, spawnLoc, Loc(0, 0, 0), "prefab_object_spawned")
		end
	end
	this:SetObjVar("ObjectivesCompleted", 0)

	local missionType = missionInfo.MissionType
	if (MissionControllerInit[missionType]) then
		MissionControllerInit[missionType]()
	end
end

--Spawn instance of BossTemplate and add mission_objective module to it
function MissionControllerInit.Boss()
	local missionData = this:GetObjVar("MissionData")
	local missionInfo = GetMissionTable(missionData.Key)

	for i = #missionInfo.BossTemplate, 1, -1 do
		local bossSpawnLoc = GetNearbyPassableLocFromLoc(this:GetObjVar("PrefabSpawnLoc"))
		CreateObj(missionInfo.BossTemplate[i], bossSpawnLoc, "BossSpawned")
	end
	this:SetObjVar("ObjectiveCount", #missionInfo.BossTemplate)
end

RegisterEventHandler(EventType.CreatedObject, "BossSpawned", 
	function(success, objRef)
		if (success) then
			local missionData = this:GetObjVar("MissionData")
			objRef:SetObjVar("MissionSource", this)
			objRef:SetObjVar("MissionData", missionData)
			objRef:AddModule("mission_objective")
			objRef:SetObjVar("MissionKey", missionData.Key)

			local prefabObjects = this:GetObjVar("PrefabObjects") or {}
			table.insert(prefabObjects, objRef)
			this:SetObjVar("PrefabObjects", prefabObjects)
		else
			DebugMessage(tostring(this).." INVALID BOSS MOB TEMPLATE. ENDING MISSION.")
			DestroyMissionController()
		end
	end)

function MissionControllerInit.Lair()
	local missionData = this:GetObjVar("MissionData")
	local missionInfo = GetMissionTable(missionData.Key)

	local prefabObjects = this:GetObjVar("PrefabObjects")

	this:SetObjVar("ObjectivesCompleted", 0)
	local objectiveCount = 0
	for i, j in pairs(prefabObjects) do
		if (j:HasModule("destructable_mob_spawner") or j:HasModule("destroyable_object")) then
			j:SetObjVar("MissionSource", this)
			j:SetObjVar("MissionData", missionData)
			j:AddModule("mission_objective", {Key = missionData.Key})
			j:SetObjVar("MissionKey", missionData.Key)
			objectiveCount = objectiveCount + 1
		end
	end

	if (objectiveCount == 0) then
		DebugMessage(tostring(this).." NO destructable_mob_spawner FOUNDS. ENDING MISSION.")
		DestroyMissionController()
	else
		this:SetObjVar("ObjectiveCount", objectiveCount)
	end
end

--Notifies player of victory and destroys itself
function CompleteMission()
	local missionData = this:GetObjVar("MissionData")
	local missionOwner = this:GetObjVar("MissionOwner")
	missionOwner:SendMessage("EndMission", missionData.ID, true)
	DestroyMissionController()
end

--Adds a short decay to prefab objects before destroying this controller
--If the object is a dead mob, add a default  
function DestroyMissionController()
	RegisterSingleEventHandler(EventType.Timer, "DestroyMissionController",
		function()
			local prefabObjects = this:GetObjVar("PrefabObjects") or {}
			if (prefabObjects ~= nil) then
				for i, j in pairs(prefabObjects) do
					if (j:HasModule("mission_objective")) then
						j:DelModule("mission_objective")
					end
					if (j:IsMobile() and IsDead(j)) then
						Decay(j)
					else
						Decay(j, 150)
					end
				end
			end
			this:Destroy()
		end)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "DestroyMissionController")
end

function GetNearbyRandomMissionSpawnLoc(prefabName)
	local prefabExtents = GetPrefabExtents(prefabName)
    local spawnLoc = GetNearbyPassableLoc(this, 360, 10, 25)
    local relBounds = GetRelativePrefabExtents(prefabName, spawnLoc, prefabExtents)

    local i = 0
    while (i < 20) do
	    if(CheckBounds(relBounds,false)) then
	    	return spawnLoc
	    else
	    	spawnLoc = GetNearbyPassableLoc(this, 360, 10, 25)
    		relBounds = GetRelativePrefabExtents(prefabName, spawnLoc, prefabExtents)
    	end
	    i = i+1
    end
    return spawnLoc
end

--Adds spawned objects to a collection
RegisterEventHandler(EventType.CreatedObject, "prefab_object_spawned", 
	function(success, objRef)
		if (success) then
			local prefabObjects = this:GetObjVar("PrefabObjects") or {}
			table.insert(prefabObjects, objRef)
			this:SetObjVar("PrefabObjects", prefabObjects)
		end
	end)

RegisterEventHandler(EventType.Message, "ObjectiveCompleted", 
	function()
		local objectivesCompleted = this:GetObjVar("ObjectivesCompleted") or 0
		objectivesCompleted = objectivesCompleted + 1

		if (objectivesCompleted >= (this:GetObjVar("ObjectiveCount") or 0)) then
			CompleteMission()
		else
			this:SetObjVar("ObjectivesCompleted", objectivesCompleted)
		end
	end)

--Schedules the destruction of the mission when created
RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ()
		local missionData = this:GetObjVar("MissionData")
		if (DateTime.UtcNow > missionData.EndTime) then
			DestroyMissionController()
		end

		this:ScheduleTimerDelay(missionData.EndTime - missionData.StartTime, "DestroyMissionController")
		InitMissionController()
	end)

--If loaded from a backup, verify that the mission hasn't expired
RegisterEventHandler(EventType.LoadedFromBackup, "", 
	function()
		local missionData = this:GetObjVar("MissionData")
		if (DateTime.UtcNow > missionData.EndTime) then
			DestroyMissionController()
		end
	end)

RegisterEventHandler(EventType.Message, "DestroyMissionController", DestroyMissionController)