require 'base_ai_mob'
require 'base_ai_casting'
require 'base_ai_intelligent'

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
AI.Settings.SpeechTable = "Pirate"

if (initializer ~= nil) then
    if( initializer.PirateNames ~= nil ) then    
        local name = initializer.PirateNames[math.random(#initializer.PirateNames)]
        local job = initializer.PirateJobs[math.random(#initializer.PirateJobs)]
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
    "Why are pirates pirates? cuz they arrrrrr",
    "Shiver me timbers!",
    "Avast ye landlubbers!",
}

AI.StateMachine.AllStates.DecidingCombat = {
        OnEnterState = function()   
            if (math.random(1,50) == 1) then
                this:StopMoving()
                this:PlayAnimation("rend")
                this:NpcSpeech(quotes[math.random(1,#quotes)])
            end
        end,
    }

RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
        if (IsGuard(killer)) then return end

        CreateObj("treasurechest_pirate_captain",this:GetLoc(),"created_chest")

    end)

RegisterEventHandler(EventType.CreatedObject,"created_chest",function (success,objRef)
    if (success) then
        Decay(objRef, 800)
        objRef:SetFacing(270)
    end
end)
