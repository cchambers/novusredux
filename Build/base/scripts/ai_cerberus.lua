require 'base_ai_mob'
require 'base_ai_intelligent'

AI.Settings.AggroRange = 20.0

-- set charge speed and attack range in combat ai
AI.Settings.CanFlee = false
AI.Settings.CanUseCombatAbilities = false

--Special ability
table.insert(AI.CombatStateTable,{StateName = "SpecialAbility",Type = "melee",Range = 0})
table.insert(AI.CombatStateTable,{StateName = "PoisonBreath",Type = "melee",Range = 0})

AI.StateMachine.AllStates.SpecialAbility  = {
        GetPulseFrequencyMS = function() return 6000 end,
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
            this:SendMessage("RequestCombatAbility","ChargeAtFoe")
        end,
        OnExitState = function()
            this:DelObjVar("AI-Disable")
        end,
        AiPulse = function()
            DecideCombatState()
        end,
    }

RegisterEventHandler(EventType.Message,"ForceCharge",function ( ... )
    AI.StateMachine.ChangeState("SpecialAbility")
end)

AI.StateMachine.AllStates.PoisonBreath  = {
        GetPulseFrequencyMS = function() return 4000 end,
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
            this:SendMessage("RequestCombatAbility","PoisonBreath")
        end,
        OnExitState = function()
            this:DelObjVar("AI-Disable")
        end,
        AiPulse = function()
            DecideCombatState()
        end,
    }

--DFB HACK: It looks like ass when he moves and bites so this freezes him when swinging
--[[RegisterEventHandler(EventType.Timer,"swingTimer",function ( ... )
    SetMobileModExpire(this, "Freeze", "Hack1", true, TimeSpan.FromSeconds(0.7))
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"DecideCombatStateOverride")
end)
RegisterEventHandler(EventType.EnterView, "MobsInRange",function ( ... )
    if (AI.StateMachine.CurState ~= "SpecialAbility" and AI.StateMachine.CurState ~= "PoisonBreath" and not this:HasTimer("swingTimer") )then
        SetMobileModExpire(this, "Freeze", "Hack2", true, TimeSpan.FromSeconds(0.7))
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"DecideCombatStateOverride")
    end
end)--]]

RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
        if (IsGuard(killer)) then return end
        --If I'm a boss demon
        --DebugMessage(1)
        --advance the quest
        local nearbyCombatants = FindPlayersInGameRegion("CerberusRoom")
        --DebugMessage(DumpTable(nearbyCombatants))
        for i,j in pairs(nearbyCombatants) do
            j:SendMessage("AdvanceQuest","SlayVoidGuardianQuest","TalkToPriest","SlayCerberus")
        end
    end)

RegisterEventHandler(EventType.CreatedObject,"created_chest",function (success,objRef)
    if (success) then
		Decay(objRef, 800)
        objRef:SetFacing(270)
    end
end)

RegisterEventHandler(EventType.Timer,"DecideCombatStateOverride",function ( ... )
    DecideCombatState()
end)

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

RegisterSingleEventHandler(EventType.ModuleAttached, "ai_cerberus", 
	function()
        local nearbyCombatants = FindPlayersInGameRegion("CerberusRoom")

        for i,j in pairs(nearbyCombatants) do
            j:SendMessage("AdvanceQuest","SlayVoidGuardianQuest","SlayCerberus","Investigate")
        end
        if (#nearbyCombatants > 0) then 
            this:SendMessage("AttackEnemy",nearbyCombatants[math.random(1,#nearbyCombatants)])
        end
	end)

--RegisterEventHandler(EventType.Timer,"debug_change_to_ability",
--    function()
--        AI.StateMachine.ChangeState("DecidingCombat")
--        AI.StateMachine.ChangeState("SpecialAbility")
--    end)

this:DelObjVar("AI-Disable")

