RES_PERCENTAGE = 0.6
MAX_MINIONS = ServerSettings.Combat.MaxMinions
SKILL_PER_IMP = 15
IMPS_LIFETIME = 90
--DebugMessage(1)

function HandleLoaded(location)
	--DFB TODO: THIS SHOULD BE MORE SOPHISTICATED
	local myResSource = this
	local currentMinions = FindObjects(SearchObjVar("controller",myResSource))
	--DebugMessage("followers = "..#currentFollowers)
	if (#currentMinions >= MAX_MINIONS) then
		myResSource:SystemMessage("[D70000]You have too many minions in play![-]","info")
		EndEffect()
		return
	end
	
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.5), "SpawnTimer", location)
	PlayEffectAtLoc("VoidTeleportToEffect",location,4)
end

function EndEffect()
	this:DelModule("sp_spawn_imp")
end

RegisterEventHandler(EventType.Timer, "EndResEffect", 
	function ()
		EndEffect()
	end)
RegisterEventHandler(EventType.Message, "SpawnimpSpellTargetResult", 
	function (location)
		--DebugMessage(2)
		HandleLoaded(location)
	end)


RegisterEventHandler(EventType.Timer, "SpawnTimer", 
	function (location)
		--DebugMessage("Creating skelton")
		CreateObj("imp_minion",location,"CreateImp")
		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1500), "EndResEffect")
	end)

RegisterEventHandler(EventType.CreatedObject,"CreateImp",
function (success,objRef)
	local myResSource = this
	if myResSource == nil or not(myResSource:IsValid()) then
		DebugMessage("[sp_spawn_imp] ERROR: Could not find assigned spell source")
		EndEffect()
		return
	end
    if (not myResSource:HasTimer("FollowerSkillGain")) then
        myResSource:SendMessage("RequestSkillGainCheck", "NecromancySkill")
    end
    myResSource:ScheduleTimerDelay(TimeSpan.FromSeconds(45),"FollowerSkillGain")
    objRef:AddModule("slay_decay")
    objRef:SetObjVar("SlayDecayTime",IMPS_LIFETIME)
    objRef:SetObjVar("Summon", true)
	objRef:SetObjVar("ControllingSkill","NecromancySkill")
	myResSource:SendMessage("AddFollowerMessage", {["pet"] = objRef})
	
	objRef:SendMessage("ReassignSuperior",myResSource)
	EndEffect()
end)