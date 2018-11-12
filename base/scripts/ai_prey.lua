require 'incl_combatai'
require 'incl_regions'
require 'ai_default_animal'

-- Combat AI settings
AI.Settings.AggroChanceAnimals = 0 --1 out of this number chance to attack other animals
AI.Settings.FleeUnlessAngry = false --only fight if the mob is angry
AI.Settings.AggroRange = 10.0 --Range to start aggroing
AI.Settings.CanFlee = false --Determines if this mob should ever run away
AI.Settings.ChargeSpeed = 3.0 --Speed mob charges at target
AI.Settings.ChaseRange = 15.0 --distance from self to chase target
AI.Settings.CanTaunt = false --Determines if this mob should taunt the target
AI.Settings.CanHowl = false --Determines if this mob should stop and howl
AI.Settings.CanSpeak = false --Determines if this mob speaks
AI.Settings.CanCast = false --Determines if this mob should cast or not
AI.Settings.CanUseCombatAbilities = false
AI.Settings.ChanceToNotAttackOnAlert = 0 --1 out of this number chance to attack when alerted
AI.Settings.FleeDistance = 10.0 --Distance to run away when fleeing
AI.Settings.InjuredPercent = 1.0 --Percentage of health to run away
AI.Settings.FleeSpeed = 1 --speed to run away
AI.Settings.FleeUnlessInCombat = false --if this setting is checked true then it will always flee if in combat.
AI.Settings.FleeChance = 0 --Chance to run away
AI.Settings.Leash = false --Determines if this mob should ever leash
AI.Settings.LeashDistance = 40 --Max distance from spawn this mob should ever go
AI.Settings.CanWander = true --Determines if this mob wanders or not
AI.Settings.WanderChance = 5 -- Chance to wander
AI.Settings.ScaleToAge = false
AI.Settings.StationedLeash = false --if true, mob will go back to it's spawn position on idle
		--Following variables are unused if the previous one is set to true
AI.Settings.ScaleRange = 0 --Maximum range to simulate scale randomization. 
		--Following variables are overridden if RandomizeScale or ScaleToAge is true
AI.Settings.CanSeeBehind = true--DFB TODO: If true, the mob will go into alert even if you sneak up behind them.
AI.Settings.ShouldAggro = false

-- external inputs

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

--Set the target are alerted
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

--Quick and dirty decide combat state function for dumber entities like animals. Overridden for enhanced thinking abilities, 
--or if you want do do more than just melee in combat.
--NOTE: BE CAREFUL WHERE YOU CALL THIS FUNCTION AS CALLING IT ON AN ON ENTER OR EXIT STATE CAN LEAD TO INFINITE LOOPS!!!
function DecideCombatState()  

    if (this:HasObjVar("Invulnerable")) then DecideIdleState() return end

    local frameTime = ObjectFrameTimeMs()
    if(frameTime == lastDecideCall) then
        return
    end

    lastDecideCall = frameTime

    if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end
    if (AI.StateMachine.CurState == "GoHome") then return end
    if not(AI.IsActive()) then return end

    if ((CheckStrongLeash() or CheckLeash()) and AI.StateMachine.AllStates.GoHome:CanGoHome()) then
        AI.StateMachine.ChangeState("GoHome")
        return
    end

    AI.MainTarget = FindAITarget()
    AI.StateMachine.ChangeState("DecidingCombat") 

    if (AI.MainTarget ~= nil) then
        AI.LastKnownTargetPos = AI.MainTarget:GetLoc()
    else
        AI.LastKnownTargetPos = nil
    end

    --Idle if we have no target
    if not AI.IsValidTarget(AI.MainTarget) or IsDead(AI.MainTarget) then 
        this:ClearPathTarget()
        DecideIdleState()
        return     
   	end

    --chase and melee
    local distance = this:DistanceFrom(AI.MainTarget)

    if (distance > AI.GetSetting("AggroRange")) then
        AI.StateMachine.ChangeState("Chase")
    end

    if (distance < AI.GetSetting("AggroRange")) then
       	AI.StateMachine.ChangeState("Melee")
    end

    if (distance > AI.GetSetting("ChaseRange")) then
    	AI.RemoveFromAggroList(AI.MainTarget)

    	 if (not this:HasLineOfSightToObj(AI.MainTarget) and
    	  ((this:GetLoc():Distance(this:GetObjVar("SpawnLocation")) < AI.GetSetting("LeashDistance")) 
    	  	or not AI.GetSetting("StationedLeash"))) then 
                AI.LastKnownTargetPos = AI.MainTarget:GetLoc()
                SetAITarget(nil)
                AI.StateMachine.ChangeState("Pursue") 
            else 
                DecideCombatState()
            end
    end
end 

function SetAITarget(enemyObj)
    AI.MainTarget = enemyObj
    if( enemyObj ~= nil ) then
        AI.LastTargetLocation = enemyObj:GetLoc()
    else
        AI.LastTargetLocation = nil
    end
end

function CheckStopChasing()
    return false
end
