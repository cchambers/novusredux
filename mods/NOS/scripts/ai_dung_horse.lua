require 'incl_combatai'
require 'incl_regions'
require 'ai_default_animal'

-- Combat AI settings
AI.Settings.AggroChanceAnimals = 0 --1 out of this number chance to attack other animals

-- external inputs

this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(5000), "dungTimer");
	
RegisterEventHandler(EventType.Timer, "dungTimer", function()

    if (AI.IsActive()) then
        CreateObj("jail_dung", this:GetLoc());
        this:PlayObjectSound("WormDeath");
    end
    this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(30000), "dungTimer");
end)

function AI.Init()
    -- DAB NOTE: We are calling SetSetting so it sets the objvar so we can see this externally
    AI.SetSetting("ChargeSpeed",AI.GetSetting("ChargeSpeed"))
    
    this:SetObjVar("SpawnPosition",this:GetLoc())
    if (initializer ~= nil) then
        if( initializer.Names ~= nil ) then
            local newName = initializer.Names[math.random(#initializer.Names)]
            this:SetName(newName)
        end        
    end
    local initialState = AI.InitialState
    local shouldSleep = AI.GetSetting("ShouldSleep")

    if (initialState == nil)then
        if (shouldSleep) then
            initialState = "Disabled"
        else
            initialState = "Idle"
        end
    end

    AI.StateMachine.Init(initialState)

    if (shouldSleep)then
        AddView("PlayersInRange",SearchPlayerInRange(30,true),0.5)
    end
    ViewsSleeping = shouldSleep
end

function GetNearbyEnemies()
    local actualEnemies = {}
    return actualEnemies
end

function IsFriend(target)
    if (AI.InAggroList(target)) then
        return false
    end

  	return true
end

function FindAITarget()    
    --DebugMessage("Quick return")
    if (AI.MainTarget == this) then AI.MainTarget = nil end

    --DebugMessage("Doing something expensive")
    --Search for aggro targets next
    local AggroTarget = AI.GetNewTarget(AI.GetSetting("ChaseRange"))
    if (AggroTarget ~= nil and AggroTarget ~= this) then
        SetAITarget(AggroTarget)
        return AggroTarget
    end
   
    return nil
end