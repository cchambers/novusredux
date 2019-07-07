RegisterEventHandler(EventType.Message, "EndMission", 
	function(missionId, completed)
		local missionKey = GetMissionKeyFromId(this, missionId)
		if (missionKey	== nil) then return end

		if (completed == true) then
			--Mission completed
			if not(IsDead(this)) then
				this:SystemMessage("Completed Mission", "info")
				this:PlayEffect("HealEffect")

				--Reward
				local amount = math.random(GetMissionTable(missionKey).RewardMin, GetMissionTable(missionKey).RewardMax) or 100
				this:SystemMessage(amount.." coins have been added to your bank for completing the mission.","info")
				CreateStackInBank(this, "coin_purse", amount)

				local playerStats = this:GetObjVar("LifetimePlayerStats")
				local numberMissionCompleted = playerStats.NumberMissionCompleted or 0
				playerStats.NumberMissionCompleted = numberMissionCompleted + 1
				this:SetObjVar("LifetimePlayerStats",playerStats)

				CheckAchievementStatus(this, "Activity", "BountiesNumber", numberMissionCompleted + 1)
			else
				this:SystemMessage("Mission Ended", "info")
			end
		end
		RemoveMission(this, missionId)
		UpdateMissionUi()
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "TaskUI",
	function(user, buttonId, fieldData)
		if (buttonId:match("MissionButton")) then
			local missionID = StringSplit(buttonId,"|")[2]
			if (user:IsValid()) then
				local missions = this:GetObjVar("Missions")
				for i, j in pairs(missions) do
					if (j.ID == missionID) then
						ToggleMissionMapMarker(j)
						UpdateMissionUi()
					end
				end
			end
		elseif (buttonId:match("RemoveMission")) then
			local missionID = StringSplit(buttonId,"|")[2]
			if (user:IsValid()) then
				local missions = this:GetObjVar("Missions")
				for i, j in pairs(missions) do
					if (j.ID == missionID) then

						ClientDialog.Show
						{
							TargetUser = user,
							DialogId = "RemoveMissionDialog"..missionID,
						    TitleStr = "Remove Mission",
						    DescStr = "Are you sure you want to cancel this mission?",
						    Button1Str = "Yes",
						    Button2Str = "No",
						    ResponseObj= this,
						    ResponseFunc= 
						    function(dialogUser, dialogButtonId)
								local dialogButtonId = tonumber(dialogButtonId)
								if (dialogUser == nil) then return end

								if (dialogButtonId == 0) then
									RemoveMission(this, missionID)
									return
								end
								UpdateMissionUi()
							end,
						}
					end
				end
			end
		end
	end)

function ToggleMissionMapMarker(missionData)
	if (customMapFunctions[ServerSettings.WorldName]() == nil) then
		RemoveDynamicMapMarker(this,"Mission|"..missionData.ID)
		return 
	end

	local missionMapMarker = GetMissionMapMarker(this, missionData.ID)
	if (missionMapMarker == nil) then
		local mapMarker = {Icon="marker_mission", Location=missionData.SpawnLoc, Tooltip=GetMissionTable(missionData.Key).Title.."\n"..(GetRegionalName(missionData.SpawnLoc) or ServerSettings.SubregionName), RemoveDistance=5}
		AddDynamicMapMarker(this,mapMarker,"Mission|"..missionData.ID)
		this:SystemMessage(GetMissionTable(missionData.Key).Title.." marker enabled.")
	else
		this:SystemMessage(GetMissionTable(missionData.Key).Title.." marker disabled.")
		RemoveDynamicMapMarker(this,"Mission|"..missionData.ID)
	end
end

--Checks if player is close enough to mission controller to activate it 
RegisterEventHandler(EventType.Timer, "MissionCheck", function()
	CheckForNearbyMissions(this)
	UpdateMissionUi()
	end)
this:ScheduleTimerDelay(TimeSpan.FromSeconds(MISSION_CHECK_TIME), "MissionCheck")

RegisterEventHandler(EventType.CreatedObject, "createdController", 
	function(success, objRef, missionData)
		missionData.ControllerObj = objRef

		local missions = this:GetObjVar("Missions")
		for i, j in pairs(missions) do
			if (j.ID == missionData.ID) then
				j.ControllerObj = objRef
			end
		end
		this:SetObjVar("Missions", missions)
		
		UpdateMissionUi()

		objRef:SetObjVar("MissionData", missionData)
		objRef:SetObjVar("MissionOwner", this)
	end)


--Each mission shows a title, a button to display a waypoint on the minimap, and progress(?)
function UpdateMissionUi()
	--this:CloseDynamicWindow("TaskUI")
	local missions = this:GetObjVar("Missions") or {}
	local missionWindow = DynamicWindow("TaskUI","",200,180,-180,220,"Transparent","TopRight")
	local skillTrackerOffset = #(this:GetObjVar("TrackedSkills") or {}) * SKILL_TRACKER_SIZE + 20
	local missionOffset = skillTrackerOffset

	if (#missions >= 1) then

		--If mission is past deadline, remove it from list
		for i = #missions, 1, -1 do
			if (DateTime.UtcNow > missions[i].EndTime) then
				RemoveMission(this, missions[i].ID)
				UpdateMissionUi()
				return
			end
		end

		--Add mission ui elements
		for i, j in pairs(missions) do
			local missionTitle = GetMissionTable(j.Key).Title

			local buttonState = "disabled"
			if (GetMissionMapMarker(this, j.ID) ~= nil) then
				buttonState = "pressed"
			end

			if (missionTitle ~= nil) then
				local labelText = "[ff6347]"..missionTitle.."\n[-]"..(j.RegionalName or j.Subregion)
				missionWindow:AddImage(0,missionOffset - 4,"TextFieldChatUnsliced",180,60,"Sliced")

				missionWindow:AddLabel(5,0+missionOffset,labelText,0,0,18,"left",false,true)
				missionWindow:AddButton(150,missionOffset,"MissionButton|"..j.ID, "", 24, 24, "", "", false, "Selection2", buttonState)

				missionWindow:AddButton(5,missionOffset,"RemoveMission|"..j.ID, "", 140, 0, "","",false, "Invisible")

				missionWindow:AddLabel(5,35+missionOffset,GetTimerLabelString(DateTime.UtcNow - j.EndTime),0,0,18,"left",false,true)
				missionOffset = ((i) * 60) + skillTrackerOffset
			else

			end
		end
	else
		this:CloseDynamicWindow("TaskUI")
	end
	this:OpenDynamicWindow(missionWindow)
end


--[[
function UpdateMissionData(missionData)
	local missions = this:GetObjVar("Missions") or {}
	for i = #missions, 1, -1 do
		if (missions[i].ID == missionData.ID) then
			missions[i] = missionData
		end
	end

	this:SetObjVar("Missions", missions)
	DebugMessage(DumpTable(missions))
end
]]--