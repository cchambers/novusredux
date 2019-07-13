require 'NOS:ai_follower'
require 'NOS:incl_faction'

AI.KilledMonsterMessages = {
  "Death to you!",
  "Go back to the shadow!",
  "You have become lost to the Way!",
  "Leave this place for the Great Beyond!",
  "I fear you not, creature!",
  "DIE!",
  "You are nothing to me!",
  "The Wayun shalt be triumphant!",  
  "The Wayun will TRIUMPH.",
  "The Wayun curse you.",
  "THIS TEMPLE IS OURS!",
  "May your soul rest finally.",
}

AI.Settings.CanWander = false

RegisterEventHandler(EventType.Message, "VictimKilled", function (victim)
    if( victim ~= nil ) then
        if (victim:GetMobileType() == "Monster") then
            this:NpcSpeech(AI.KilledMonsterMessages[math.random(1,#AI.KilledMonsterMessages)])
        end
    end
end)

function DialogSlave(user)
	if not (this:IsInRegion("ZealotEncampment") or this:IsInRegion("FollowerHubRegion")) then
		response = {}

		text = "[$1605]"

		response[1] = {}
		response[1].text = "I can show you. Follow me."
		response[1].handle = "Follow" 

		response[3] = {}
		response[3].text = "Bye."
		response[3].handle = "" 

		NPCInteraction(text,this,user,"Interact",response)
	else
		this:NpcSpeech("I give thanks to you, brother.")
	end
end

RegisterEventHandler(EventType.DynamicWindowResponse, "Interact",
	function (user,buttonId)
		if (buttonId == "Follow") then
			this:NpcSpeech("I will follow you.")
			this:SetObjVar("controller",user)
			AI.StateMachine.ChangeState("Follow")
		end
	end)

RegisterEventHandler(EventType.Message, "ChangeOwnerMessage",
function(newOwner)
		this:SetObjVar("controller",newOwner)
		local controller = this:GetObjVar("controller")
		if (controller ~= nil and controller:IsValid() and not IsDead(controller)) then
			this:PathToTarget(controller,1.0,4.0)
		else
			AI.StateMachine.ChangeState("Idle")
			return
		end
		AI.StateMachine.ChangeState("Follow")
end)

OverrideEventHandler("NOS:base_ai_conversation",EventType.Message, "UseObject", 
	function (user,usedType)
    	if(usedType ~= "Interact") then return end
		--DebugMessage("user is "..tostring(user))
		if (user ~= this:GetObjVar("controller")) then
			--user:SendMessage("ShowMobWindowMessage",this)
		--else
			DialogSlave(user)
		end
		AI.StateMachine.ChangeState("Follow")
		return
	end)

RegisterEventHandler(EventType.Timer,"FinishQuestCheck",
function ( ... )
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"FinishQuestCheck")
	local controller = this:GetObjVar("controller")
	if (this:IsInRegion("ZealotEncampment") or this:IsInRegion("FollowerHubRegion")) and controller ~= nil then
		--local controller = this:GetObjVar("controller")
		--controller:SendMessage("AdvanceQuest","SaveGuardQuest","TalkToInaius")
	    local nearbyCombatants = FindObjects(SearchMulti(
	        {
	            SearchPlayerInRange(15,true), --in 20 units
	        }))
		for i,j in pairs(nearbyCombatants) do
			controller:SendMessage("AdvanceQuest","SaveGuardQuest","TalkToInaius")
		end
		this:DelObjVar("controller")
		Decay(this)
	end
end)

RegisterEventHandler(EventType.EnterView,"chaseRange",
function(mob)
	if (mob:IsPlayer() and not this:HasObjVar("controller") and not IsDead(this)) then
		this:NpcSpeech("Brother, I have been lost!") 
		if (GetPlayerQuestState(mob,"SaveGuardQuest") == nil) then
			--mob:SendMessage("StartQuest","SaveGuardQuest","BringWarriorBack")
		else
			--mob:SendMessage("AdvanceQuest","SaveGuardQuest","BringWarriorBack")
		end
	end
end)

this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"FinishQuestCheck")