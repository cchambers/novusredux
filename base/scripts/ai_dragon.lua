require 'base_ai_mob'
require 'base_ai_intelligent'
require 'base_ai_casting'

-- set charge speed and attack range in combat ai
AI.Settings.CanFlee = false
AI.Settings.CanUseCombatAbilities = false
AI.Settings.ChaseRange = 25
--Special ability
table.insert(AI.CombatStateTable,{StateName = "SpecialAbility",Type = "rangedattack",Range = 10})
table.insert(AI.CombatStateTable,{StateName = "Lunge",Type = "rangedattack",Range = 10})
table.insert(AI.CombatStateTable,{StateName = "TailWhip",Type = "melee",Range = 5})
table.insert(AI.CombatStateTable,{StateName = "TailStrike",Type = "melee",Range = 5})
table.insert(AI.CombatStateTable,{StateName = "Fly",Type = "melee",Range = 5})

AI.StateMachine.AllStates.DecideCombatState = {
    OnEnterState = function ()
        this:SendMessage("EndFlyMessage")
        this:SetSharedObjectProperty("IsFlying",false)
    end,
}

AI.StateMachine.AllStates.SpecialAbility  = {
        GetPulseFrequencyMS = function() return 5200 end,
        OnEnterState = function()
            --this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"debug_change_to_ability")
            --DebugMessage("Attacking combat ability")
            --FaceTarget()
            --this:StopMoving()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            this:SendMessage("RequestCombatStanceUpdate","Aggressive")            
            --DebugMessage("Firing combat ability")
            this:SendMessage("RequestCombatAbility","DragonFire")
        end,

        AiPulse = function()
            AI.StateMachine.ChangeState("Melee")
        end,
    }

AI.StateMachine.AllStates.TailWhip  = {
        GetPulseFrequencyMS = function() return 3200 end,
        OnEnterState = function()
            --this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"debug_change_to_ability")
            --DebugMessage("Attacking tailwhip")
            --FaceTarget()
            --this:StopMoving()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            this:SendMessage("RequestCombatStanceUpdate","Aggressive")            
            --DebugMessage("Firing combat ability")
            this:SendMessage("RequestCombatAbility","TailWhip")
        end,

        AiPulse = function()
            AI.StateMachine.ChangeState("Melee")
        end,
    }

AI.StateMachine.AllStates.TailStrike  = {
        GetPulseFrequencyMS = function() return 3200 end,
        OnEnterState = function()
            --this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"debug_change_to_ability")
            --DebugMessage("Attacking tailstrike")
            --FaceTarget()
            --this:StopMoving()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            this:SendMessage("RequestCombatStanceUpdate","Aggressive")            
            --DebugMessage("Firing combat ability")
            this:SendMessage("RequestCombatAbility","TailStrike")
        end,

        AiPulse = function()
            AI.StateMachine.ChangeState("Melee")
        end,
    }

AI.StateMachine.AllStates.Lunge  = {
        GetPulseFrequencyMS = function() return 4200 end,
        OnEnterState = function()
            --this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"debug_change_to_ability")
            --DebugMessage("Attacking tailstrike")
            --FaceTarget()
            --this:StopMoving()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            this:SendMessage("RequestCombatStanceUpdate","Aggressive")            
            --DebugMessage("Firing combat ability")
            this:SendMessage("RequestCombatAbility","DragonLunge")
        end,

        AiPulse = function()
            AI.StateMachine.ChangeState("Melee")
        end,
    }

AI.StateMachine.AllStates.Fly  = {
        GetPulseFrequencyMS = function() return 4200 end,
        OnEnterState = function()
            --this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"debug_change_to_ability")
            --DebugMessage("Attacking tailstrike")
            --FaceTarget()
            --this:StopMoving()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            this:SendMessage("RequestCombatStanceUpdate","Defensive")            
            --DebugMessage("Firing combat ability")
            this:SendMessage("RequestCombatAbility","Fly")
            RunToTarget()
        end,

        AiPulse = function()
            AI.StateMachine.ChangeState("Melee")
        end,

        OnExitState = function ()
         this:SetSharedObjectProperty("IsFlying",false)
            this:SendMessage("EndFlyMessage")
        end,
    }
    
RegisterEventHandler(EventType.Arrived,"",function (success)
    if (not success ) then--or IsInCombat(this)) then
        return 
    end
    --DebugMessage(1)
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"NoAttackTimer")
end)
RegisterEventHandler(EventType.StartMoving,"",function (success)
    if (not success ) then--or IsInCombat(this)) then
        return 
    end
    --DebugMessage(0)
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"NoAttackTimer")
end)

--DFB HACK: Collision is wonky with dragon, removing
this:ClearCollisionBounds()
this:SetObjVar("DoNotRestoreCollision",true)

--RegisterEventHandler(EventType.Timer,"debug_change_to_ability",
--    function()
--        AI.StateMachine.ChangeState("DecidingCombat")
--        AI.StateMachine.ChangeState("SpecialAbility")
--    end)

