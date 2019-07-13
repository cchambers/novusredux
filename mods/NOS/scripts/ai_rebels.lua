require 'NOS:base_ai_mob'
require 'NOS:base_ai_casting'
require 'NOS:base_ai_intelligent'

AI.Settings.Debug = false
AI.Settings.AggroRange = 10.0
AI.Settings.ChaseRange = 15.0
AI.Settings.LeashDistance = 20
AI.Settings.StationedLeash = true
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanWander = false
AI.Settings.CanUseCombatAbilities = true
AI.Settings.CanCast = true
AI.Settings.ChanceToNotAttackOnAlert = 2
AI.Settings.SpeechTable = "Rebel"

if (initializer ~= nil) then
    if( initializer.RebelNames ~= nil ) then    
        local name = initializer.RebelNames[math.random(#initializer.RebelNames)]
        local job = initializer.RebelJobs[math.random(#initializer.RebelJobs)]
        this:SetName(name.." the "..job)
    end
end

RegisterEventHandler(EventType.Message, "DamageInflicted",
    function (damager)
        if AI.IsValidTarget(damager) then
        if (IsFriend(attacker) and AI.Anger < 100) then return end
            local myTeamType = this:GetObjVar("MobileTeamType")
            local nearbyTeamMembers = FindObjects(SearchMulti(
            {
                SearchMobileInRange(20), --in 10 units
                SearchObjVar("MobileTeamType",myTeamType), --find others with my team type
            }))
            for i,j in pairs (nearbyTeamMembers) do
                j:SendMessage("AttackEnemy",damager) --defend me
            end
        end
    end)

quotes = {
}

AI.StateMachine.AllStates.DecidingCombat = {
        OnEnterState = function()   
            if (math.random(1,50) == 1) then
                this:StopMoving()
                this:PlayAnimation("rend")
                --this:NpcSpeech(quotes[math.random(1,#quotes)])
            end
        end,
    }
