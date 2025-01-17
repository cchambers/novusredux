require "base_ai_mob"
require "base_ai_casting"
require "base_ai_intelligent"
require "loop_effect"

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

if (initializer ~= nil) then
    if (initializer.PirateNames ~= nil) then
        local name = initializer.PirateNames[math.random(#initializer.PirateNames)]
        local job = initializer.PirateJobs[math.random(#initializer.PirateJobs)]
        this:SetName(name .. " the Spectral Commander")
        CallFunctionDelayed(
            TimeSpan.FromSeconds(0.5),
            function()
                local sHue = 947
                this:SetHue(824)
                local RightHand = this:GetEquippedObject("RightHand")
                if (RightHand ~= nil) then
                    RightHand:SetHue(sHue)
                end
                local LeftHand = this:GetEquippedObject("LeftHand")
                if (LeftHand ~= nil) then
                    LeftHand:SetHue(sHue)
                end
                local Chest = this:GetEquippedObject("Chest")
                if (Chest ~= nil) then
                    Chest:SetHue(sHue)
                end
                local Legs = this:GetEquippedObject("Legs")
                if (Legs ~= nil) then
                    Legs:SetHue(sHue)
                end
                local Head = this:GetEquippedObject("Head")
                if (Head ~= nil) then
                    Head:SetHue(sHue)
                end
            end
        )
    end
end

RegisterEventHandler(
    EventType.Message,
    "DamageInflicted",
    function(damager)
        if AI.IsValidTarget(damager) then
            if (IsFriend(attacker) and AI.Anger < 100) then
                return
            end
            local myTeamType = this:GetObjVar("MobileTeamType")
            local nearbyTeamMembers =
                FindObjects(
                SearchMulti(
                    {
                        SearchMobileInRange(20), --in 10 units
                        SearchObjVar("MobileTeamType", myTeamType) --find others with my team type
                    }
                )
            )
            for i, j in pairs(nearbyTeamMembers) do
                j:SendMessage("AttackEnemy", damager) --defend me
            end
        end
    end
)

RegisterEventHandler(
    EventType.Message,
    "HasDiedMessage",
    function(killer)
        if (math.random(1, 5) == 1) then
            CreateObj("recipe_spectral", this:GetLoc(), "Spectral.CreatedRecipe")
        end
        CallFunctionDelayed(
            TimeSpan.FromSeconds(2),
            function()
                this:Destroy()
            end
        )
    end
)

quotes = {
    "Someone's after me ORE!",
    "ORRRRRRRRRRRRRR'!",
    "Avast ye landlubbers!"
}

AI.StateMachine.AllStates.DecidingCombat = {
    OnEnterState = function()
        if (math.random(1, 10) == 1) then
            this:StopMoving()
            this:PlayAnimation("rend")
            this:NpcSpeech(quotes[math.random(1, #quotes)])
        end
    end
}
