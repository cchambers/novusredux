--Adds a mission, starts the timer, and updates the UI
DEFAULT_MISSION_DURATION = 2400

--How often the player checks if it's current missions are still valid
MISSION_CHECK_TIME = 1

--Minimum distance before mission spawns
MISSION_SPAWN_DISTANCE = 40

function GetMissionTable(missionKey)
	local missionTable = nil

	missionTable = GetSubregionMissions()[missionKey]
	if (missionTable == nil) then
		for i, j in pairs(MissionData.Missions.AllSubregions) do
			if (tostring(i) == missionKey) then
				missionTable = j
			end
		end
	end

	return missionTable
end

function GetSubregionMissions()
	return MissionData.Missions[ServerSettings.SubregionName] or MissionData.Missions.AllSubregions
end

function RemoveMissionTimers(user)
	local missions = user:GetObjVar("Missions")
	if (missions == nil) then return end

	for i, j in pairs(missions) do
		local handler = "MissionTimer|"..j.ID
		if not (user:HasTimer(handler)) then
			user:RemoveTimer(handler)
		end
	end
end

function RemoveMission(user, missionId)
	local missions = user:GetObjVar("Missions")
	local missionTable = nil
	local index = nil
	for i = #missions, 1, -1 do
		if (missions[i].ID == missionId) then
			missionTable = missions[i]
			index = i
		end
	end

	if (missionTable ~= nil) then
		if (missionTable.ControllerObj ~= nil) then
			missionTable.ControllerObj:SendMessage("DestroyMissionController")
		end
	end

	if (index ~= nil) then 
		table.remove(missions, index)
		user:SetObjVar("Missions", missions)
	end
	RemoveDynamicMapMarker(user,"Mission|"..missionId)
end

function GetMissionKeyFromId(user, Id)
	local missions = user:GetObjVar("Missions")
	for i, j in pairs(missions) do
		if (j.ID == Id) then
			return j.Key
		end
	end
	return nil
end

--Ends mission after time
function ScheduleMissionTimers(user)
	local missions = user:GetObjVar("Missions")
	if (missions == nil) then return end

	for i, j in pairs(missions) do
		local handler = "MissionTimer|"..j.ID
		if not (user:HasTimer(handler)) then
			RegisterSingleEventHandler(EventType.Timer, handler, 
				function()
					user:SendMessage("EndMission", j)
				end)
			user:ScheduleTimerDelay(j.EndTime - j.StartTime, handler)
		end
	end
end

function GetMissionMapMarker(user, missionID)
	local mapMarkers = user:GetObjVar("MapMarkers")
	if (mapMarkers ~= nil) then
		for i, j in pairs(mapMarkers) do
			if (tostring(j.Id):match("Mission")) then
				local markerMissionID = StringSplit(tostring(j.Id), "|")[2]
				if (markerMissionID == missionID) then
					return j
				end
			end
		end
	end
	return nil
end

function AddMission(user, missionKey, spawnLoc)
	local missionTable = GetMissionTable(missionKey)
	if (missionTable == nil) then return end

	local missionData = {}
	missionData.ID = uuid()
	missionData.Key = missionKey
	missionData.Completed = false
	missionData.StartTime = DateTime.UtcNow
	missionData.EndTime = DateTime.UtcNow + TimeSpan.FromSeconds(DEFAULT_MISSION_DURATION)
	missionData.SpawnLoc = spawnLoc or user:GetLoc()
	missionData.RegionalName = GetRegionalName(spawnLoc)
	missionData.Subregion = ServerSettings.SubregionName or ServerSettings.WorldName
	--missionData.SpawnLoc = PickMissionSpawnLoc(missionData)
	missionData.ControllerObj = nil

	local mapMarker = {Icon="marker_mission", Location=missionData.SpawnLoc, Tooltip=GetMissionTable(missionData.Key).Title.."\n"..(missionData.RegionalName or missionKey.Subregion), RemoveDistance=5}
	AddDynamicMapMarker(user,mapMarker,"Mission|"..missionData.ID)

	local missions = user:GetObjVar("Missions") or {}
	table.insert(missions, missionData)
	user:SetObjVar("Missions", missions)

	CheckForNearbyMissions(user)
end

function CheckForNearbyMissions(user)
	local missions = user:GetObjVar("Missions")
	if (missions == nil) then return end

	if (#missions > 0) then
		user:ScheduleTimerDelay(TimeSpan.FromSeconds(MISSION_CHECK_TIME), "MissionCheck")	
	end

	for i, j in pairs(missions) do
		if (j.Subregion == ServerSettings.SubregionName or ServerSettings.WorldName) then
			if (j.ControllerObj ~= nil) then return end
			local distance = j.SpawnLoc:Distance(user:GetLoc())
			if (distance <= MISSION_SPAWN_DISTANCE) then
				CreateObj("mission_controller", j.SpawnLoc, "createdController", j)
			end
		end
	end
end