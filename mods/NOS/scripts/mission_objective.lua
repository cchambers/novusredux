--Module attached by the mission controller to an object
--It's sole purpose is to send ObjectiveCompleted events to it's mission controller
function RegisterMissionHandler()
	local MissionType = GetMissionTable(this:GetObjVar("MissionKey")).MissionType
	if (MissionType == "Boss") then
		--Register mob death event
		RegisterEventHandler(EventType.Message, "HasDiedMessage",
		function(killer)
			local missionSource = this:GetObjVar("MissionSource")
			missionSource:SendMessage("ObjectiveCompleted")
			return
		end)
		return

	elseif (MissionType == "Lair") then
		--Register destroyable_object destruction event
		RegisterEventHandler(EventType.Message, "ObjectDestroyed", 
		function()
			local missionSource = this:GetObjVar("MissionSource")
			missionSource:SendMessage("ObjectiveCompleted")
			return
		end)
		return
	end
	DebugMessage("FAILED TO REGISTER MISSON OBJECTIVE OF TYPE: "..MissionType)
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(), RegisterMissionHandler)
RegisterEventHandler(EventType.LoadedFromBackup, "", RegisterMissionHandler)