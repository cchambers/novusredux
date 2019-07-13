require 'base_ai_mob'
require 'base_ai_casting'
require 'base_ai_intelligent'
require 'base_ai_conversation'

AI.Settings.Debug = false
AI.Settings.AggroRange = 10.0
AI.Settings.ChaseRange = 15.0
AI.Settings.LeashDistance = 25
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanWander = false
AI.Settings.CanUseCombatAbilities = true
AI.Settings.CanCast = true
AI.Settings.ChanceToNotAttackOnAlert = 2

RegisterEventHandler(EventType.Message, "DamageInflicted",
	function (damager)
		if AI.IsValidTarget(damager) then
            local myTeamType = this:GetObjVar("MobileTeamType")
		    local nearbyTeamMembers = FindObjects(SearchMulti(
		    {
		        SearchMobileInRange(20), --in 10 units
		        SearchObjVar("MobileTeamType",myTeamType), --find others with my team type
		    }))
		    for i,j in pairs (nearbyTeamMembers) do
		        j:SendMessage("AddThreat",damager,2) --defend me
		    end
		end
	end)
