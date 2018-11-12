SKILL_TRACKER_SIZE = 34
MAX_SKILLS_CAN_TRACK = 6

function ShowSkillTracker(skillsToTrack)
	--DebugMessage("A")
	skillsToTrack = skillsToTrack or this:GetObjVar("TrackedSkills") or {}
	if(#skillsToTrack > 0) then
		local dynWindow = DynamicWindow("SkillTracker","",180,SKILL_TRACKER_SIZE*#skillsToTrack,-186,230,"Transparent","TopRight")
		local offset = 0

		for i,j in pairs(skillsToTrack) do			
			local displayName = ""
			if(j == "Prestige") then
				displayName = "Training Points"
			else
				displayName = GetSkillDisplayName(j) 
			end

			--DebugMessage(j.." is skill to track")
			--dynWindow:AddImage(0,offset,"SkillTracker_BG",180,38,"Sliced")
			dynWindow:AddLabel(13,6+offset,displayName,220,SKILL_TRACKER_SIZE,16,"",false,true,"SpectralSC-SemiBold")
			if(j == "Prestige") then
				dynWindow:AddLabel(165,6+offset,tostring(GetPrestigePoints(this)),SKILL_TRACKER_SIZE*2,SKILL_TRACKER_SIZE,16,"right",false,true)
			else
				dynWindow:AddLabel(165,6+offset,"[STAT:"..j.."]",SKILL_TRACKER_SIZE*2,SKILL_TRACKER_SIZE,16,"right",false,true)
			end
			dynWindow:AddImage(12,21+offset,"StatBarFrame",156,9,"Sliced")
			dynWindow:AddStatBar(15,24+offset,150,3,j.."XP","5176FF",this);
			offset = SKILL_TRACKER_SIZE + offset
		end
		--DebugMessage("opening window")
		this:OpenDynamicWindow(dynWindow)
		this:SendMessage("RefreshQuestUI")
	else
		this:CloseDynamicWindow("SkillTracker")
	end
end

RegisterEventHandler(EventType.Message,"UpdateSkillTracker",function ( ... )
	ShowSkillTracker()
end)

function AddSkillToTracker(skillName,index)
	--DebugMessage(1)
	if (skillName == nil) then return end
	--DebugMessage(2)
	local skillsToTrack = this:GetObjVar("TrackedSkills") or {}
	if (#skillsToTrack >= MAX_SKILLS_CAN_TRACK) then
		this:SystemMessage("You can only track "..tostring(MAX_SKILLS_CAN_TRACK).. " at a time.")
		return
	end
	if(IsInTableArray (skillsToTrack, skillName)) then return end
	
	if(index) then
		table.insert(skillsToTrack,index,skillName)
	else
		table.insert(skillsToTrack,skillName)
	end
	--DebugMessage("skills to track is "..DumpTable(skillsToTrack))
	if (#skillsToTrack > 0) then
		ShowSkillTracker(skillsToTrack)
	end
	this:SetObjVar("TrackedSkills",skillsToTrack)
end
RegisterEventHandler(EventType.Message,"AddSkillToTracker",function(skillName,index) AddSkillToTracker(skillName,index) end)

function RemoveSkillFromTracker(skillName)
	--DebugMessage(1)
	if (skillName == nil) then return end
	--DebugMessage(2)
	local skillsToTrack = this:GetObjVar("TrackedSkills") or {}
	local index = 0
	for i,j in pairs(skillsToTrack) do
		if (skillName == j) then
			index = i
		end
	end
	--DebugMessage(3)
	skillsToTrack[index] = nil
	local newTable = {}
	for i,j in pairs(skillsToTrack) do
		table.insert(newTable,j)
	end
	--DebugMessage("skills to track is "..DumpTable(skillsToTrack))
	if (#skillsToTrack > 0) then
		ShowSkillTracker(skillsToTrack)
	end
	if (#skillsToTrack == 0) then
		--DebugMessage("Closing skill tracker")
		CloseSkillTracker()
	end
	this:SetObjVar("TrackedSkills",newTable)
	return
end

function HasSkillInTracker(skillName)
	if (skillName == nil) then return false end
	local skillsToTrack = this:GetObjVar("TrackedSkills") or {}
	for i,j in pairs(skillsToTrack) do
		if (j == skillName) then
			return true
		end
	end
	return false
end

function CloseSkillTracker()
	this:CloseDynamicWindow("SkillTracker")
end
