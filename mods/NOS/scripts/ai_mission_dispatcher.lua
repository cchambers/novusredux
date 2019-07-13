require 'NOS:base_ai_npc'

AI.Settings.EnableMissions = true

DEFAULT_AVAILABLE_MISSIONS = 3
MAX_MISSIONS = 3

mCurLoc = nil
mSelectedMissions = {}
--Prevents user from accepting same mission multiple times
mHasPickedMission = false

AI.TooColdMessages = 
{
	"This outta be a cakewalk for you.",
	"This one shouldn't give you much trouble. I'd like to see you try and mess this one up."

}

AI.TooHotMessages = 
{
	"Take this one with caution friend, we've lost a lot of good mercs to this one.",
	"I'm not so sure you're up to this task, but we're running low on bodies to throw at this one.",
	"This one? Hey, it's your funeral pal."
}

AI.JustRightMessages =
{
	"I think this one will suit you.",
	""
}

function IntroDialog(user)

    Dialog.OpenGreetingDialog(user)
end

function Dialog.OpenGreetingDialog(user)
  	Dialog.OpenListMissionsDialog(user)
end

function Dialog.OpenListMissionsDialog(user)

	mHasPickedMission = false

	local missionKeys = PickMissions(user)
	mSelectedMissions[user] = {}
	for i, j in pairs(missionKeys) do
		local loc = PickMissionSpawnLoc(j)
		if(loc) then
			mSelectedMissions[user][i] = {Key = j, Loc = loc}
		end
	end
	text = "Looking for some work? I take mercenary jobs from all over and offer them to freelancers like yourself."

    response = {}
    local responseIndex = 1

    local userMissions = user:GetObjVar("Missions") or {}
	if (#userMissions >= MAX_MISSIONS) then
		text = "I'm not going to give you any more leads until you tie up your loose ends. Go complete the jobs, and I'll have something when you come back."

		response[responseIndex] = {}
	    response[responseIndex].text = "Okay"
	    response[responseIndex].handle = ""
    	responseIndex = responseIndex + 1
	else

		if (mSelectedMissions[user] ~= nil) then
		    for i, j in pairs(mSelectedMissions[user]) do
		    	local missionTable = GetMissionTable(mSelectedMissions[user][i].Key)
		    	local descriptionText = missionTable.Title
		    	response[responseIndex] = {}
			    response[responseIndex].text = tostring(descriptionText).." at "..GetRegionalName(mSelectedMissions[user][i].Loc) or ServerSettings.SubregionName or ServerSettings.WorldName
			    response[responseIndex].handle = tostring("MissionKey|"..i)
		    	responseIndex = responseIndex + 1
		    end
		else
    		text = "I don't have any missions for you pal. Sorry."
		end

	    responseIndex = responseIndex + 1
	    response[responseIndex] = {}
	    response[responseIndex].text = "Goodbye."
	    response[responseIndex].handle = ""
	end

    NPCInteractionLongButton(text,this,user,"Responses",response)
    GetAttention(user)
end

function OpenMissionDetailsDialog(user, selectedMissionIndex)
	local missionTable = GetMissionTable(mSelectedMissions[user][selectedMissionIndex].Key)
	local descriptionText = missionTable.Description
	local difficultyText = GetDifficultyDescription(user, missionTable.Difficulty)
	local directionDescription = GetDirectionDescription(mSelectedMissions[user][selectedMissionIndex].Loc) or ""
	text = difficultyText.." "..descriptionText.." "..directionDescription

	response = {}

	response[1] = {}
	response[1].text = "Accept"
	response[1].handle = "Accept|"..selectedMissionIndex

	response[2] = {}
	response[2].text = "Decline"
	response[2].handle = "ListMissions"

	NPCInteractionLongButton(text,this,user,"Responses",response)
    GetAttention(user)
end

OverrideEventHandler("NOS:base_ai_npc", EventType.DynamicWindowResponse,"Responses", 
	function (user,buttonId)
		if ( Dialog["Open"..buttonId.."Dialog"] ~= nil) then 
        	Dialog["Open"..buttonId.."Dialog"](user)
		elseif (buttonId:match("MissionKey")) then
			local args = StringSplit(buttonId, "|")
			local missionIndex = args[2]
			if (user:IsValid()) then
				OpenMissionDetailsDialog(user, tonumber(missionIndex))
			end
		elseif(buttonId:match("Accept")) then
			--local missionId = uuid()
			local args = StringSplit(buttonId, "|")
			local missionIndex = tonumber(args[2])
			--local missionData = {ID = missionId, Key = missionKey}
			--local spawnLoc = PickMissionSpawnLoc(MissionData.Missions[missionKey].PrefabName)
			local missions = user:GetObjVar("Missions") or {}
			if (#missions < MAX_MISSIONS and not mHasPickedMission) then
				AddMission(user, mSelectedMissions[user][missionIndex].Key, mSelectedMissions[user][missionIndex].Loc)
				mHasPickedMission = false
			end
			user:CloseDynamicWindow("Responses")
		elseif(buttonId == "") then
			user:CloseDynamicWindow("Responses")
		end
		--user:CloseDynamicWindow("Responses")
	end)


function PickMissions(user)
	local missionKeys = {}
	local availableMissions = {}
	local missionTable = GetSubregionMissions()

	local userDifficulty = GetUserDifficulty(user)
	--Get universal missions
	for i, j in pairs(MissionData.Missions.AllSubregions) do
		if (userDifficulty >= j.Difficulty) then
			table.insert(missionKeys, i)
		end
	end

	local tableCount = 0
	for i, j in pairs(missionTable) do
		tableCount = tableCount + 1
	end

	if (missionTable ~= nil or tableCount > 0) then
		--Get subregion specific missions
		for i, j in pairs(missionTable) do
			if (userDifficulty >= j.Difficulty) then
				table.insert(missionKeys, i)
			end
		end
	end

	for i = DEFAULT_AVAILABLE_MISSIONS, 1, -1 do
		local key = missionKeys[math.random(1, #missionKeys)]
		availableMissions[i] = key
	end
	return availableMissions
end

function GetUserDifficulty(user)
	local weaponSkill, weaponLevel = GetHighestWeaponSkill(user)
	local mageryLevel = GetSkillLevel(user, "MagerySkill")
	local beastmasteryLevel = GetSkillLevel(user, "BeastmasterySkill")

	local score = 1
	if (weaponLevel > mageryLevel) then
		score = (weaponLevel + GetSkillLevel(user, "MeleeSkill"))/2
	elseif (beastmasteryLevel > mageryLevel) then
		score = (beastmasteryLevel + GetSkillLevel(user, "AnimalLoreSkill"))/2
	else
		score = (mageryLevel + GetSkillLevel(user, "MagicAffinitySkill"))/2
	end

	local difficulty = math.ceil(score * GetMaxDifficulty()/ServerSettings.Skills.PlayerSkillCap.Single)

	if (difficulty <= 0) then
		difficulty = 1
	end

	return difficulty
end

function GetMaxDifficulty()
	local currDifficulty = 1
	for i, j in pairs(GetSubregionMissions()) do
		if (j.Difficulty >= currDifficulty) then
			currDifficulty = j.Difficulty
		end
	end

	for i, j in pairs(MissionData.Missions.AllSubregions) do
		if (j.Difficulty >= currDifficulty) then
			currDifficulty = j.Difficulty
		end
	end

	return currDifficulty
end

function GetDifficultyDescription(user, missionDifficulty)
	local userDifficulty = GetUserDifficulty(user)
	
	--TooCold
	if (userDifficulty > missionDifficulty) then
		return AI.TooColdMessages[math.random(1, #AI.TooColdMessages)]
	--TooHot
	elseif(userDifficulty < missionDifficulty) then
		return AI.TooHotMessages[math.random(1, #AI.TooHotMessages)]
	--JustRight
	elseif(userDifficulty == missionDifficulty) then
		return AI.JustRightMessages[math.random(1, #AI.JustRightMessages)]
	end
end

function GetDirectionDescription(spawnLoc)

	local destRegionalName = GetRegionalName(spawnLoc) or ServerSettings.SubregionName or ServerSettings.WorldName

	local angleTo = this:GetLoc():YAngleTo(spawnLoc)

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

		if (destRegionalName == nil) then
			return "Head "..direction
		end

	return "Head "..direction.." towards "..destRegionalName.."."

end

function PickMissionSpawnLoc(missionKey)

	local spawnLoc = nil
	local missionTable = GetMissionTable(missionKey)
	if (missionTable["Poi"] ~= nil) then
		if (PointsOfInterest[missionTable.Poi] ~= nil) then
			if (ServerSettings.WorldName == "NewCelador") then
				spawnLoc = PointsOfInterest[missionTable.Poi]
			end
		end
	end

	if (spawnLoc == nil) then
		spawnLoc = GetRandomMissionSpawnLoc(missionTable.PrefabName)
	end

	return spawnLoc
end

campRegion = GetRegion("DynamicCamp")
function IsInCampRegion(spawnLoc)	
	return campRegion and campRegion:Contains(spawnLoc)
end

function GetRandomMissionSpawnLoc(prefabName)
    local prefabExtents = GetPrefabExtents(prefabName)

    local spawnLoc = GetRandomPassableLocationFromRegion(campRegion,false, {"NoHousing"})
    local relBounds = GetRelativePrefabExtents(prefabName, spawnLoc, prefabExtents)

    local i = 0
    while (i < 20) do
		if(CheckBounds(relBounds,false)) then
	        --Move every mobiles in camp boundary
	        MoveMobiles(relBounds, spawnLoc)
	    	return spawnLoc
	    end
	    spawnLoc = GetRandomPassableLocationFromRegion(campRegion,false, {"NoHousing"})
	    i = i+1
    end
    return spawnLoc
end

RegisterEventHandler(EventType.LoadedFromBackup,"",function()
	mSelectedMissions = {}
end)