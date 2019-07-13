require 'NOS:ai_cultist'
require 'NOS:incl_run_path'

currentDestinaion = nil
STOP_CHANCE = 0

AI.Settings.Debug = false

AI.Settings.AggroRange = 10.0
AI.Settings.ChaseRange = 10.0
AI.Settings.Leash =  true
AI.Settings.StationedLeash = true
AI.Settings.LeashDistance = 30
AI.Settings.CanWander = false
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanUseCombatAbilities = true
AI.Settings.CanCast = true
AI.Settings.CanFlee = false

function OnHomeArrived(arriveSuccess)
    if(arriveSuccess) then
        --DebugMessage("Stationed")
        AI.StateMachine.ChangeState("Stationed")
    else
        AI.StateMachine.ChangeState("Idle")
    end
end

AI.StateMachine.AllStates.Idle = {
        GetPulseFrequencyMS = function() return 5000 end,
        
        OnEnterState = function()
            --DebugMessage(this:GetName().." is Start")
            if( AI.GetSetting("ShouldPatrol") == true ) then
                --DebugMessage(this:GetName().." is ReturnToPath")   
                AI.StateMachine.ChangeState("ReturnToPath")
            end
        end,

        AiPulse = function ()
            DecideIdleState()
            --Reduce anger in idle
            AI.Anger = AI.Anger - 1
            if (AI.Anger < 0)  then
                AI.Anger = 0
            end
            -- body
        end,
    }

AI.StateMachine.AllStates.ReturnHome = {   
        OnEnterState = function()
            --DebugMessage(this:GetName().." is Return home")
            local homeLoc = this:GetObjVar("homeLoc")
            if( homeLoc == nil ) then
                --DebugMessage("[ai_cultist_guard::ReturnToPath] No valid home location")
                homeLoc = this:GetObjVar("SpawnLocation")
            end
            if( this:GetLoc():Distance(homeLoc) < 1 ) then
                AI.StateMachine.ChangeState("Stationed")
                return
            end
            this:PathTo(homeLoc,1.0,"returnHome") 
        end,
    }

AI.StateMachine.AllStates.Stationed = {   
        OnEnterState = function()
            local homeFacing = this:GetObjVar("homeFacing")
            if( homeFacing ~= nil and this:GetFacing() ~= homeFacing ) then
                this:SetFacing(homeFacing)
            end
        end,
    }

function HandleModuleLoaded()
    --DebugMessage("GUARD LOADED")

    if (AI.GetSetting("ShouldPatrol") == true) then        
        this:SetObjVar("curPathIndex", 1)
        this:SetObjVar("stopChance", 0)
        this:SetObjVar("stopDelay", 3000)
        this:SetObjVar("isRunning", 0)  
        this:SetObjVar("AI-Leash",false)  
        this:SetObjVar("AI-StationedLeash",false)  
    else
        this:SetObjVar("homeLoc",this:GetLoc())
        this:SetObjVar("homeFacing",this:GetFacing())
    end
end

this:SetObjVar("MyPath","CultistGuardPath")
AI.InitialState = "Idle"

RegisterSingleEventHandler(EventType.ModuleAttached, "ai_cultist_guard", HandleModuleLoaded)
RegisterEventHandler(EventType.Arrived, "returnHome", OnHomeArrived)
