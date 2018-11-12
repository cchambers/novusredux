require 'base_ai_mob'
require 'base_ai_intelligent'

-- set charge speed and attack range in combat ai
AI.Settings.CanFlee = false
AI.Settings.CanUseCombatAbilities = false

--Special ability
table.insert(AI.CombatStateTable,{StateName = "SpecialAbility",Type = "rangedattack",Range = 10})
table.insert(AI.CombatStateTable,{StateName = "Lunge",Type = "rangedattack",Range = 10})
table.insert(AI.CombatStateTable,{StateName = "TailWhip",Type = "melee",Range = 5})
table.insert(AI.CombatStateTable,{StateName = "TailStrike",Type = "melee",Range = 5})
table.insert(AI.CombatStateTable,{StateName = "Fly",Type = "melee",Range = 5})

--[[RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
    if (IsGuard(killer)) then return end
    local nearbyCombatants = FindObjects(SearchMulti(
        {
            SearchPlayerInRange(20,true), --in 20 units
        }))
        --they took part in killing the demon, they deserve credit
        for i,j in pairs(nearbyCombatants) do
            local roll = math.random(1,20)
            if roll == 1 then 
                CreateObjInBackpack(j,"prestige_scroll_knight")
                j:SystemMessage("You have gained a Prestige Scroll!")
            elseif(roll == 2) then
                CreateObjInBackpack(j,"prestige_scroll_sorcerer")
                j:SystemMessage("You have gained a Prestige Scroll!")
            end
        end
    end)]]

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

RegisterEventHandler(EventType.Message,"PathBehindDoor",
    function ( ... )
        this:PathTo(this:GetObjVar("SpawnLocation"),2.0,"PathHomeToDoor")
    end)

RegisterEventHandler(EventType.Arrived,"PathHomeToDoor",function ( ... )
    if (IsDead(this)) then return end
    local resetDoor = FindObjects(SearchObjVar("TrapKey","TriggerCerberus"))
    for i,j in pairs(resetDoor) do 
        j:SendMessage("CloseDoor")
    end
    this:Destroy()
end)
--RegisterSingleEventHandler(EventType.ModuleAttached, "ai_ogre", 
--  function()
--  end)

