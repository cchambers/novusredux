require 'base_ai_mob'
require 'base_ai_casting'
require 'base_ai_intelligent'
require 'base_ai_conversation'

--npc's should all have this
function IsFriend(target)
    --My only enemy is the enemy
    if (AI.InAggroList(target)) then
        return false
    else
        return true
    end
end

thingsToSay = 
{
	"Move along, we have no business with you.",
	"Sorry, I can't talk to you now.",
	"Haruus is who pays me, speak to him.",
	"I have no quarrel with you.",
	"I'm not supposed to talk to you.",
	"I have nothing to say to you, move along",
	"Move along.",
	"The Bandit Guild forbids me from speaking on duty.",
}

OverrideEventHandler("base_ai_conversation",EventType.Message, "UseObject", 
	function (user,usedType)
    	if(usedType ~= "Interact") then return end
  		this:NpcSpeech(thingsToSay[math.random(1,#thingsToSay)])
	end)

RegisterEventHandler(EventType.Message, "DamageInflicted",
	function (damager)
    if (IsFriend(attacker) and AI.Anger < 100) then return end
		if AI.IsValidTarget(damager) then
		    local nearbyGuards = FindObjects(SearchMulti(
		    {
		        SearchMobileInRange(20), --in 10 units
		        SearchModule("ai_slaver_guard"), --find slaver guards
		    }))
		    for i,j in pairs (nearbyGuards) do
		        j:SendMessage("AttackEnemy",damager) --defend me
		    end
		end
	end)

AI.Settings.Debug = false
AI.Settings.AggroRange = 10.0
AI.Settings.ChaseRange = 15.0
AI.Settings.LeashDistance = 20
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanWander = false
AI.Settings.CanUseCombatAbilities = true
AI.Settings.Leash = true
AI.Settings.StationedLeash = true
AI.Settings.CanCast = true
AI.Settings.ChanceToNotAttackOnAlert = 2
