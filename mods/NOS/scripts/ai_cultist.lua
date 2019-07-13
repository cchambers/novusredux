require 'NOS:base_ai_mob'
require 'NOS:base_ai_casting'
require 'NOS:incl_regions'
require 'NOS:base_ai_intelligent'
require 'NOS:base_ai_conversation'
require 'NOS:incl_faction'
require 'NOS:incl_run_path'
--require 'NOS:base_ai_sleeping'

AI.Settings.Debug = false
-- set charge speed and attack range in combat ai

AI.Settings.AggroRange = 10.0
AI.Settings.ChaseRange = 10.0
AI.Settings.LeashDistance = 30
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanWander = false
AI.Settings.CanUseCombatAbilities = true
AI.Settings.CanCast = true
AI.Settings.ChanceToNotAttackOnAlert = 2
AI.Settings.SpeechTable = "Cultist"
AI.Settings.ShouldFlee = true

if (this:GetObjVar("controller") ~= nil) then
    AI.Settings.CanWander = true
end

RegisterEventHandler(EventType.Message, "DamageInflicted", 
	function (damager)    
	    if (damager == nil or not damager:IsValid()) then return end
	    if (IsFriend(damager) and AI.Anger < 100) then return end
	        --but attack anyone that attack's my bretheren
	    local nearbyTeam = FindObjects(SearchMulti(
	    {
	        SearchMobileInRange(AI.GetSetting("ChaseRange")), --in 10 units
	        SearchObjVar("MobileTeamType",this:GetObjVar("MobileTeamType")), --find cultists
	    }))
	    for i,j in pairs (nearbyTeam) do
	        if (not IsInCombat(j) and not j:HasTimer("RecentlyAlerted")) then
	            j:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"RecentlyAlerted")
	            j:SendMessage("AttackEnemy",damager,true) --defend me
	        end
	    end
	end)