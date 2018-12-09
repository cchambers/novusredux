MIN_ARMOR = 0
EXPIRE_SECONDS = 180


function CleanUp()
	this:RemoveTimer("ExpireReflectiveArmor")
	this:DelObjVar("ReflectiveArmor")
	--set a timeout till it can be cast again
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(30), "ReflectiveArmorTimer")
	this:DelModule("sp_reflective_armor")
end

RegisterSingleEventHandler(EventType.ModuleAttached, "sp_reflective_armor",
	function()
		-- TODO Calculate reflective armor, off of skill probably.
		local inscriptionSkill = GetSkillLevel(this,"InscriptionSkill") or 0
		local manifestationSkill = GetSkillLevel(this,"MagerySkill") or 0
		local meditationSkill = GetSkillLevel(this,"MagicAffinitySkill") or 0
		local absorbed =  math.floor((manifestationSkill + meditationSkill + inscriptionSkill) / 3)
		if absorbed > 75 then
			absorbed = 75
		end
		--[[
		this:NpcSpeech("inscriptionSkill" .. inscriptionSkill)
		this:NpcSpeech("manifestationSkill" .. manifestationSkill)
		this:NpcSpeech("meditationSkill" .. meditationSkill)
		this:NpcSpeech("absorbed" .. absorbed)
		]]

		this:SetObjVar("ReflectiveArmor", absorbed)

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(EXPIRE_SECONDS), "ExpireReflectiveArmor")
	end)

RegisterSingleEventHandler(EventType.Timer, "ExpireReflectiveArmor", 
	function()
		CleanUp()
	end)


RegisterSingleEventHandler(EventType.Message, "RemoveReflectiveArmor", 
	function()
		CleanUp()
	end)