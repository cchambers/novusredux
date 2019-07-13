require 'NOS:base_ai_mob'
require 'NOS:incl_regions'
require 'NOS:base_ai_intelligent'

-- set charge speed and attack range in combat ai
AI.Settings.CanFlee = false

AI.Settings.CanUseCombatAbilities = false

AI.Settings.ChaseRange = 20.0
AI.Settings.LeashDistance = 30

if (initializer ~= nil and initializer.Names ~= nil) then
    this:SetName(initializer.Names[math.random(1,#(initializer.Names))])
end

--Special ability
table.insert(AI.CombatStateTable,{StateName = "SpecialAbility",Type = "melee",Range = 0})

AI.StateMachine.AllStates.SpecialAbility  = {
        GetPulseFrequencyMS = function() return 2000 end,
        OnEnterState = function()
            --DebugMessage("Attacking combat ability")
            --FaceTarget()
            --this:StopMoving()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                AI.StateMachine.ChangeState("Idle")
                return
            end

            this:SendMessage("RequestCombatStanceUpdate","Aggressive")            
            --DebugMessage("Firing combat ability")
            this:SendMessage("RequestCombatAbility","MagicBlast")
        end,

        AiPulse = function()
            AI.StateMachine.ChangeState("Melee")
        end,
    }

--RegisterSingleEventHandler(EventType.ModuleAttached, "ai_ogre", 
--	function()
--	end)

