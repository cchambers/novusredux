require 'incl_celador_locations'
require 'incl_regions'
require 'base_ai_mob'
require 'base_ai_intelligent'
require 'base_ai_conversation' 
--require 'base_ai_sleeping'

table.insert(AI.IdleStateTable,{StateName = "Wander",Type = "nothing"})
table.insert(AI.IdleStateTable, {StateName = "GoLocation",Type = "nothing"})

AI.CustomSpeech.NoJobSpeech = {
    IdleSpeech = { 
        "Lovely weather we are having.", 
        "Have you met Puppy? Isn't he friendly?", 
        "Have you seen the Mayor? I must speak with him!",
        "Welcome adventurer!",
        "Greetings",
        "Have you seen the dead gate?",
        "I hear the dead are stirring in their graves." ,
        "Lovely weather we're having, eh?",
        "I'm so bored. Yourself?",
        "Did you enjoy that meal?",
        "Busy today?",
    }
}

AI.Settings.SpeechTable = "NoJobSpeech"
AI.Settings.FallbackSpeechTable = "Villager"

destination = nil

if (initializer ~= nil) then
    if( initializer.VillagerNames ~= nil ) then    
        local name = initializer.VillagerNames[math.random(#initializer.VillagerNames)]
        local job = initializer.VillagerJobs[math.random(#initializer.VillagerJobs)]
        this:SetName(name.." the "..job)
    end
end

function IsFriend(target)
    --My only enemy is the enemy
    if (AI.InAggroList(target)) then
        return false
    else
        return true
    end
end
     
AI.StateMachine.AllStates.Idle = { 
        GetPulseFrequencyMS = function() return math.random(3000,15000) end,
        AiPulse = function() 
            --aiRoll = math.random(4)
            --if(aiRoll == 1) then
            --    AI.StateMachine.ChangeState("GoLocation")            
            --else
            --    AI.StateMachine.ChangeState("Wander")
            --end
            DecideIdleState()
        end,        
    }

AI.StateMachine.AllStates.GoLocation = {
        OnEnterState = function()
            destination = CeladorLocations[math.random(#CeladorLocations)]
            this:PathTo(destination.Loc,1.0,"GoLocation")
        end,

        OnArrived = function (success)
            if(success) then
                if (AI.StateMachine.CurState ~= "GoLocation") then
                    return 
                end
                if( destination ~= nil ) then 
                    this:SetFacing(destination.Facing)
                    if( destination.Name == "VillageWell" ) then
                        this:PlayAnimation("cast")
                    end
                end
                DecideIdleState()
            end
        end,
    }

AI.StateMachine.AllStates.Wander = {
        OnEnterState = function()
            local wanderRegion = this:GetObjVar("WanderRegion")
            if wanderRegion ~= nil then
                WanderInRegion(wanderRegion,"Wander")
            end
        end,

        OnArrived = function (success)
            if (AI.StateMachine.CurState ~= "Wander") then
                return 
            end
            if( math.random(2) == 1) then
                this:PlayAnimation("fidget")
            end
            DecideIdleState()
        end,
    }



-- external inputs

function HandleModuleLoaded()
  if( initializer.Names ~= nil ) then
    this:SetName(npcNames[math.random(1, #initializer.Names)])  
  end
end

function HandleInteract(user,usedType)
    if(usedType ~= "Interact") then return end
    
    if (IsAsleep(this)) then
        return 
    end
    this:NpcSpeech(GetSpeechTable("IdleSpeech")[math.random(1,#GetSpeechTable("IdleSpeech"))])
    this:StopMoving()
    this:SetFacing(this:GetLoc():YAngleTo(user:GetLoc()))
    AI.StateMachine.ChangeState("Idle")
end

RegisterSingleEventHandler(EventType.ModuleAttached, "ai_npc_nojob", HandleModuleLoaded)
RegisterEventHandler(EventType.Message, "UseObject", HandleInteract)
RegisterEventHandler(EventType.Arrived, "GoLocation",AI.StateMachine.AllStates.GoLocation.OnArrived)
RegisterEventHandler(EventType.Arrived, "Wander", AI.StateMachine.AllStates.Wander.OnArrived)

