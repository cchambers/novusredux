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

if (initializer ~= nil) then
    if( initializer.VillagerNames ~= nil ) then    
        local name = initializer.VillagerNames[math.random(#initializer.VillagerNames)]
        this:SetName(name)
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


AI.StateMachine.AllStates.DecidingCombat = {
        OnEnterState = function()   
            if (math.random(1,50) == 1) then
                this:StopMoving()
                this:PlayAnimation("rend")
            end
        end,
    }
--Don't give them the devil horns helm
RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
    	--this:GetEquippedObject("Head"):Destroy()
    	--this:DelObjVar("noloot")
    end)
