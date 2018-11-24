if(this:GetMobileType() == "Animal") then
    require 'base_mobile'
else
    require 'base_mobile_advanced'
end

require 'base_ai_settings'
require 'base_ai_state_machine'
require 'incl_combatai'
require 'incl_regions'
require 'incl_combat_abilities'
require 'incl_magic_sys'

AI.MainTarget = nil --effectively who I want to attack
AI.PursueLastTarget = nil --target currently I am pursuing
AI.SpellOverride = nil
AI.Anger = 0 --100 is max anger
AI.LastTargetLocation = nil
DECAY_RANGE = 20
DECAY_TIME = 20

MOB_UPDATE_TIME = 2

--State with default priority
AI.CombatStateTable = {
    {StateName = "Melee",Type = "melee",Range = 0},
    {StateName = "AttackAbility",Type = "melee",Range = 0},
    {StateName = "Flee",Type = "flee", Range = AI.GetSetting("AggroRange"),},
    {StateName = "Alert",Type = "wait",Range = AI.GetSetting("ChaseRange")},
    --Hesitate ={Type = "offensivenoncombat",Range = AI.GetSetting("AggroRange")+2,},
    --Howl ={Type = "offensivenoncombat",Range = AI.GetSetting("AggroRange"),},
    {StateName = "Chase",Type = "chase",Range = AI.GetSetting("AggroRange"),},
}

-- AI Sleep Optimization Code

AIViews = {}
ViewsSleeping = true

PursueTry = 0
Pursuing = false
GoingHome = false

function AddAIView(viewName,searcher,delay)
    delay = delay or 0.25
    AIViews[viewName] = { Searcher=searcher, Delay=delay}
    if not(ViewsSleeping) or not(AI.GetSetting("ShouldSleep")) then
        AddView(viewName,searcher,delay)
    end
end

function DelAIView(viewName)
    AIViews[viewName] = nil
    DelView(viewName)
end

RegisterEventHandler(EventType.EnterView,"PlayersInRange",
    function (playerObj)
        if(ViewsSleeping) then
            for viewName,viewInfo in pairs(AIViews) do
                AddView(viewName,viewInfo.Searcher,viewInfo.Delay)
            end

            if(this:HasObjVar("homeGrid") == true and this:HasModule("pet_controller") == false and this:HasModule("spawn_decay") == false) then
                this:AddModule("spawn_decay")
            end

            ViewsSleeping = false
            AI.StateMachine.ChangeState("DecidingCombat")           
            DecideCombatState()
        end
    end)

RegisterEventHandler(EventType.LeaveView,"PlayersInRange",
    function (playerObj)
        if not(ViewsSleeping) and GetViewObjectCount("PlayersInRange") == 0 then
            for viewName,viewInfo in pairs(AIViews) do
                DelView(viewName)
            end
            ViewsSleeping = true
            AI.StateMachine.ChangeState("Disabled")
        end
    end) 

-- 

function SettingsToObjVars()
    for i,value in pairs(AI.Settings) do
        if (not this:HasObjVar(i)) then
            this:SetObjVar("AI-"..i,value)
        end
    end
end

function AI.Init()
    -- DAB NOTE: We are calling SetSetting so it sets the objvar so we can see this externally
    AI.SetSetting("ChargeSpeed",AI.GetSetting("ChargeSpeed"))
    
    local crSet = AI.GetSetting("ChaseRange") or 0
    local bodSz = GetBodySize(this) or 0 
    local chaseViewRange = math.min(crSet + bodSz,30)

    AddAIView("chaseRange",SearchMobileInRange(chaseViewRange,this:HasObjVar("SeeInvis")))
    
    --DFB HACK: Remove the trap view 
    --AddAIView("trapView",SearchObjectInRange(chaseViewRange),0.5)
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

function AI.IsActive()
    return not(AI.StateMachine.CurState == "Disabled" or AI.StateMachine.CurState == "Stabled" or IsDead(this) or this:ContainedBy() or IsAsleep(this) or this:GetObjVar("AI-Disable"))
end

--Used for when casting is enabled through including other files
function CanCast(spellname,target)
    --DebugMessageA(this,"Checking Cast")
    if  (target == nil)  then
        --DebugMessageA(this,"No Target")
        return false
    end  

    local spellRange = GetSpellRange(spellname,this)
    spellRange = spellRange * spellRange
    --DebugMessageA(this,"the spell " .. spellname .. "  has a spell range of " .. tostring(GetSpellRange(spellname,this)) .. "and is being called from  " .. tostring(this:DistanceFrom(target)))
    if (this:DistanceFromSquared(target) > spellRange) then
        --DebugMessageA(this,"Out of range")
        return false
    end

    if not(HasManaForSpell(spellname, this)) then
        --DebugMessageA(this,"Doesnt Has Mana")
        return false
    end

    if not(MeetsSkillRequirements(this,spellname)) then
       --DebugMessageA(this,"Doesnt Has Skill Requirements")
        return false
    end
    --DebugMessageA(this,"Current Mana before cast is " .. this:GetName()  .. ", is " .. tostring(GetCurMana(this)))

    return true
end

DEFAULT_CHASE_DISTANCE = 20
function CheckStopChasing()
     if (this:IsMoving()) then
        local distanceFromTarget = this:DistanceFromSquared(AI.MainTarget)
        if (distanceFromTarget > ((AI.Settings.ChaseRange * AI.Settings.ChaseRange) or (DEFAULT_CHASE_DISTANCE * DEFAULT_CHASE_DISTANCE))) then
            this:ClearPathTarget()
            AI.RemoveFromAggroList(AI.MainTarget)
            SetAITarget(nil)
            DecideIdleState(false)
            return true
        end
    else
        --DebugMessage("Reset on stop moving")
        return false
    end
end

--Function that determine's what team I'm on. Override this for custom behaviour.
function IsFriend(target)
    --DebugMessageA(this,"Checking if friend")
    --Override if this is my "target"
    if (AI.InAggroList(target)) then
        return false
    end

    if (not AI.GetSetting("ShouldAggro")) then
        return true
    end

    --DebugMessageA(this,tostring(target))
    if (target == nil) then
        return true
    end

    local myController = this:GetObjVar("controller")
    local hisController = target:GetObjVar("controller")
    if(myController == target or hisController == this) then
        return true
    end

    local myTeam = this:GetObjVar("MobileTeamType")
    if (myTeam == nil) then --If I have no team, then attack everyone!
        --DebugMessageA(this,"NO TEAM")
        return false
    end


    local otherTeam = target:GetObjVar("MobileTeamType")

    if (this:HasObjVar("NaturalEnemy") ~= nil)  then
        if (this:GetObjVar("NaturalEnemy") == otherTeam and otherTeam ~= nil) then
            AI.AddThreat(damager,4)
            return false
        end
    end

    if (target:GetMobileType() == "Animal" ) then --Animals don't usually attack animals
        if AI.GetSetting("AggroChanceAnimals") == 0 then
            if (not IsInCombat(this)) then
                return false
            else 
                return true
            end
        end
        if (this:DistanceFromSquared(target) < (AI.Settings.AggroRange * AI.Settings.AggroRange) or math.random(AI.GetSetting("AggroChanceAnimals")) == 1) then            
            --AI.AddThreat(damager,-1)--Don't aggro them
            return (myTeam == otherTeam) 
        else
            return true
        end
    end
    if (myTeam == "Villagers" and target:IsPlayer()) then return true end
    if (otherTeam == nil) then
        return false
    end
    --Villagers are a special case.
    return (myTeam == otherTeam) --Return true if they have the same team, false if not.
end

function IsMyTeam(target)
    local myTeam = this:GetObjVar("MobileTeamType")
    local otherTeam = target:GetObjVar("MobileTeamType")
    return (myTeam == otherTeam)
end

function CheckFleeCloaked(enemy)
    if (enemy ~= nil and enemy:IsValid() and enemy:IsMobile() and ((enemy:IsCloaked() and not ShouldSeeCloakedObject(this, enemy)))) then
         --DebugMessage("Firing")
         --perhaps they should do something more interesting
         return true
    end
    return false
end

function ShouldFlee()
    if(this:HasTimer("Fear")) then return true end
    if (AI.Anger < 15 and AI.GetSetting("FleeUnlessAngry") and AI.MainTarget ~= nil and this:DistanceFrom(AI.MainTarget) < AI.GetSetting("ChaseRange")/2) then
        --DebugMessage("Run run run")
        return true
    end
    if (AI.GetSetting("FleeUnlessInCombat") and AI.MainTarget ~= nil) then
        local distance = this:DistanceFrom(AI.MainTarget)
        if (distance < AI.GetSetting("AggroRange")) then
            if (not IsInCombat(this)) then
                --DebugMessage("AGGROO STUFF")
                return true
            end
        end
    end
    --DebugMessage("WHY IS THIS RETURNING TRUE")
    local fleeChance = AI.GetSetting("FleeChance")
    if(fleeChance > 0) then
        return (AI.GetSetting("CanFlee") and (math.random(1,fleeChance) == 1 and (GetCurHealth(this) < GetMaxHealth(this)*AI.GetSetting("InjuredPercent"))))
    end

    return false
end

function GetNearbyEnemies()
    --DebugMessage("GETVIEWOBJECTS")
    local enemyObjects = GetViewObjects("chaseRange")
    local actualEnemies = {}
    if (enemyObjects ~= nil) then
        for i,enemyObj in pairs(enemyObjects) do
            if(enemyObj:IsMobile() and AI.IsValidTarget(enemyObj) and not IsFriend(enemyObj) and this:HasLineOfSightToObj(enemyObj, ServerSettings.Combat.LOSEyeLevel)) then
                table.insert(actualEnemies,enemyObj)
            end
        end
    end
    return actualEnemies
end

function GetNearbyDeadMobiles()
    --DebugMessageA(this,"GETVIEWOBJECTS")

    local Objects = FindObjects(SearchMobileInRange(AI.GetSetting("ChaseRange"),this:HasObjVar("SeeInvis")))--GetViewObjects("chaseRange")
    --DebugMessage(DumpTable(Objects))
    local nearbyMobiles = {}
    if(Objects) then
        for i,theObj in pairs(Objects) do
            if (theObj ~=  nil and theObj:IsMobile()) then
                if ( (IsDead(theObj) and this:HasLineOfSightToObj(theobj, ServerSettings.Combat.LOSEyeLevel))) then
                    table.insert(nearbyMobiles,theObj)
                end
            end
        end
    end
    return nearbyMobiles
end

function GetNearbyMobiles()
    --DebugMessageA(this,"GETVIEWOBJECTS")
    local Objects = GetViewObjects("chaseRange")
    local nearbyMobiles = {}
    if(Objects) then
        for i,theObj in pairs(Objects) do
            if (theObj ~=  nil and theObj:IsMobile()) then
                if ( not(IsDead(theObj))) then
                    table.insert(nearbyMobiles,theObj)
                end
            end
        end
    end
    return nearbyMobiles
end
function GetNearbyFriends(range)
    --DebugMessageA(this,"GETVIEWOBJECTS")
    if (range == nil) then range = AI.GetSetting("ChaseRange") end
    local Objects = GetViewObjects("chaseRange")    
    local friends = {}

    if(Objects) then
        --DebugMessage("Objects = ",#Objects)        
        if (IsTableEmpty(Objects)) then return friends end
        for i,theObj in pairs(Objects) do
            if (theObj ~= nil and theObj:IsMobile() and AI.IsValidTarget(theObj) and this:DistanceFromSquared(theObj) < (range * range) ) then
                if (IsFriend(theObj) and not(IsDead(theObj))) then
                    table.insert(friends,theObj)
                end
            end
        end
    end

    return friends
end

function GetNearbyAllies(range,deadToo)
    if (deadToo == nil) then deadToo = false end

    local friends = {}
    local myTeam = this:GetObjVar("MobileTeamType")
    if (range == nil) then range = AI.GetSetting("ChaseRange") end
    if (myTeam == nil) then 
        return GetNearbyFriends() 
    end

    local Objects = FindObjects(SearchMobileInRange(AI.GetSetting("ChaseRange"),this:HasObjVar("SeeInvis")))--GetViewObjects("chaseRange")
    local checkLOS = AI.GetSetting("CheckLOS")
    --DebugMessage()
    if (IsTableEmpty(Objects)) then return friends end
    --DebugMessage("Yep")
   --DebugMessage("Objects = "..DumpTable(Objects))
    for i,theObj in pairs(Objects) do
        if (theObj ~=  nil and theObj:IsMobile() and this:DistanceFromSquared(theObj) < (range*range)) then
            if(checkLOS == false or this:HasLineOfSightToObj(theobj, ServerSettings.Combat.LOSEyeLevel)) then
                theirTeam = theObj:GetObjVar("MobileTeamType")
            --DebugMessage(tostring(theirTeam).." is their team")
            --DebugMessage(tostring(myTeam).." is my team")
            --DebugMessage("theirTeam == myTeam is "..tostring(theirTeam == myTeam),"and deadToo or not IsDead is "..tostring((deadToo or not (IsDead(theObj)))))
                if ( theirTeam == myTeam and (deadToo or not(IsDead(theObj)))) then
                    table.insert(friends,theObj)
                end
            end
        end
    end
    return friends
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
        AI.PursueLastTarget = nil
        return AggroTarget
    end
    
    --DebugMessage("Doing something really expensive")

    --Otherwise we have nothing thats aggro, return a nearby enemy
    local enemyObjects = GetNearbyEnemies()
    for i,enemyObj in pairs(enemyObjects) do
        SetAITarget(enemyObj)
        AI.PursueLastTarget = nil
        return enemyObj
    end

    --othewise return nil
    --DebugMessage("No Alert Target")
    return nil
end

--check to see if there's something in the way.
RegisterEventHandler(EventType.Arrived,"",function (success)
    if (not success ) then--or IsInCombat(this)) then
        return
    end
    --DebugMessage("checking path to target")
    if (AI.MainTarget ~= nil) then
        CheckPathLocation(AI.MainTarget:GetLoc())
    end
end)

TRAP_DAMAGE_DIST = 3
function IsDamageableLoc(targetLoc,targMob,checkNearMe) 
    if (targMob:HasObjVar("ImmuneToTraps")) then return end
    if (this:HasTimer("SpellPrimeTimer")) then return end
    if (AI.StateMachine.CurState == "GoHome") then return end
    if (checkNearMe == nil) then checkNearMe = true end
    local traps = FindObjects(SearchHasObjVar("IsTrap",targMob:GetLoc():Distance(targetLoc) + TRAP_DAMAGE_DIST))
    local dangerousObjects = FindObjects(SearchHasObjVar("Dangerous",targMob:GetLoc():Distance(targetLoc) + TRAP_DAMAGE_DIST))
    local trapLength = #traps
    for index,obj in pairs(dangerousObjects) do
        traps[index+trapLength] = obj
    end
    --LuaDebugCallStack("Distance is "..targMob:GetLoc():Distance(targetLoc) + TRAP_DAMAGE_DIST)
    --DebugMessage(DumpTable(traps))
    for i,j in pairs(traps) do
        --DebugMessage("CHECKTRAP: ",difference,(this:GetLoc():Distance(targetLoc) > j:GetLoc():Distance(targetLoc)),(j:GetSharedObjectProperty("IsTriggered") or j:HasObjVar("TrapKey") or j:HasObjVar("Dangerous")),targMob:HasObjVar("ImmuneToTraps"))
        --essentially this checks if there's a trap between me and them, and if so, return true
        local angleToMe = this:GetLoc():YAngleTo(j:GetLoc()) --angle from me to the trap
        local angleToTarget = this:GetLoc():YAngleTo(targetLoc) --angle from the target to me
        local difference = math.abs(angleToMe - angleToTarget)
        if(difference > 180) then
            difference = 360 - difference
        end
        --if there's a trap between me and them, and it's closer than them, then stop
        if (    ((difference < 25 and (this:GetLoc():Distance(targetLoc) > j:GetLoc():Distance(targetLoc))) or (this:DistanceFromSquared(j) < (TRAP_DAMAGE_DIST * TRAP_DAMAGE_DIST) and checkNearMe)) 
                and (j:GetSharedObjectProperty("IsTriggered") or j:HasObjVar("TrapKey") or j:HasObjVar("Dangerous")) 
                ) then 
            --DebugMessage("Returned true")
            return true
        end
    end
    return false
end

function CheckPathLocation(targetLoc)
    --DFB HACK: Disable trap avoidance
    --do return false end
    --DebugMessage("CHECK")
    if (this:HasObjVar("controller") and this:GetObjVar("controller"):IsMobile()) then return end
    if (IsDamageableLoc(targetLoc,this,false)) then
        --DebugMessage("Stop moving 6")
        this:StopMoving()
        --DebugMessage("Stopped moving")
        --DecideCombatState()
        return true
    end
    return false
end

function RunToTarget()
    local target = AI.MainTarget 
    --Don't move onto traps
    --if (CheckPathLocation(target:GetLoc())) then
        --DebugMessage("Found trap near them.")
    --    return
   -- end
    if (not AI.IsValidTarget(target) ) then
        --DebugMessage("Setting target to "..tostring(AI.MainTarget) .." in run to target")
        AI.MainTarget = nil
        if (not IsDead(target) and (target:IsCloaked() and not ShouldSeeCloakedObject(this, target))) then
            AI.StateMachine.ChangeState("WhereDidHeGo")
        else
            AI.StateMachine.ChangeState("Idle")
        end
        this:ClearPathTarget()
        return
    end
    if( target ~= nil ) then
        --DebugMessageA(this,"[RunToTarget] pathing to new target")
        -- enter combat mode
        -- NOTE: 0.5 is a magic offset to fix issues with mobs being just out of range to attack
        local pathDistance = GetCombatRange(this, target, _Weapon.RightHand.Range) - 0.5
        if ( pathDistance >= AI.GetSetting("AggroRange") ) then
            pathDistance = AI.GetSetting("AggroRange") - 2
        end
       -- DebugMessage("Getting here.")
        --DebugMessageA(this,"pathDistance = " .. pathDistance)
        
        local chargeSpeed = AI.GetSetting("ChargeSpeed")

        -- update run speed based on HP.
        if ( AI.Settings.RealChargeSpeed == nil and not(IsPet(this)) and GetCurHealth(this) < ( GetMaxHealth(this) * 0.5 ) ) then -- less than half health
            AI.Settings.RealChargeSpeed = chargeSpeed
            chargeSpeed = chargeSpeed * 0.5 -- cut run speed in half
            AI.SetSetting("ChargeSpeed", chargeSpeed)
            AI.SetSetting("FleeSpeed", chargeSpeed)
        else
            if ( AI.Settings.RealChargeSpeed ~= nil ) then -- above 50% hp and RealChargeSpeed is set, use it up put us back to normal.
                chargeSpeed = AI.Settings.RealChargeSpeed
                AI.Settings.RealChargeSpeed = nil
                AI.SetSetting("ChargeSpeed", chargeSpeed)
                AI.SetSetting("FleeSpeed", chargeSpeed)
            end
        end

        -- AoE Wall of Fire problem here, commenting out the next line causes the same problems (always) as when they are in wall of fire.
        this:PathToTarget(target,pathDistance,chargeSpeed)
    else
        --DebugMessageA(this,"[RunToTarget] clearing path target")
        this:ClearPathTarget()
    end    
end

--Returns a location to run to
function FindSafestAngle()
    local count = 0
    local total = 0
    local enemyObjects = GetNearbyEnemies()
    if (AI.FleeTarget ~= nil) then
        --DebugMessage(1)
        total = this:GetLoc():YAngleTo(AI.FleeTarget:GetLoc())
        count = 1
        --DebugMessage(total)
    elseif (enemyObjects ~= nil and #enemyObjects ~= 0) then
        --DebugMessage(2)
        for i,enemyObj in pairs(enemyObjects) do
            count = count + 1
            total = total + this:GetLoc():YAngleTo(enemyObj:GetLoc())
        end
    else
        total = math.random(1,360)
        count = 1
    end

    --DebugMessageA(this,"[FindSafestAngle] Count is " .. count)

    if count > 0 then
        return 180 + (total / count)
    end
    return 0
end

function SetAITarget(enemyObj)
    --LuaDebugCallStack(tostring(enemyObj).." Is target")
    AI.MainTarget = enemyObj
    this:SetObjVar("AI-MainTarget",AI.MainTarget)
    --DebugMessageA(this,"Setting from set ai target")
    if( enemyObj ~= nil ) then
        AI.LastTargetLocation = enemyObj:GetLoc()
        
        AddAIView("TargetView",SearchSingleObject(enemyObj,SearchMobileInRange(AI.Settings.ChaseRange,this:HasObjVar("SeeInvis"),false,false)))
    else
        AI.LastTargetLocation = nil
        DelAIView("TargetView")
    end
end

function AlertToTarget(enemy)
    --DebugMessageA(this,"Attacking object "..tostring(enemy))
    --DebugMessage("Alerting")
    if (not AI.IsValidTarget(enemy)) then return end
    --DebugMessage("Continuing to alert")
    AI.MainTarget = enemy
    --LuaDebugCallStack(tostring(enemyObj).." Is target from alert")
    this:SetObjVar("AI-MainTarget",AI.MainTarget)
    --DebugMessageA(this,"Setting from set ai target")
    AI.StateMachine.ChangeState("Alert")      
end

function AttackEnemy(enemy,force)    
    --DebugMessageA(this,"Attacking object "..tostring(enemy))
    --DebugMessage("Should be attacking")
    --if (not AI.IsValidTarget(enemy)) then

    if (not AI.IsValidTarget(enemy)) then
        return
    end
    --end

    SetAITarget(enemy)
    --DebugMessageA(this,"attacking enemy")
    --DebugMessage(0)
    if(IsFriend(enemy) and not force) then
       --DebugMessage(1)
        return
    end
    --DebugMessage(2)
    --DebugMessage("Yep it's getting to here.")
    --AI.AddThreat(enemy,2)
    AI.AddToAggroList(enemy,2)
    
    DecideCombatState()
end
function CheckStrongLeash(location)
    local checkLocation = location or this:GetLoc()
    
    if (AI.GetSetting("StationedLeash")) then
        local leashDistance = AI.GetSetting("LeashDistance") or 10
        if (checkLocation:DistanceSquared(this:GetObjVar("SpawnLocation")) > (leashDistance * leashDistance)) then
            --DebugMessageA(this,"Not at stationed location, returning home - " .. tostring(this:GetLoc():Distance(this:GetObjVar("SpawnLocation"))).." is the distance to spawn")
            return true
        end

        local aggroListEmpty = true

        for key,value in pairs(aggroList) do
            if (key ~= AI.PursueLastTarget) then
                aggroListEmpty = false
            end
        end

        --DebugMessage("CHECK 2: ",#aggroList == 0, this:GetLoc():Distance(this:GetObjVar("SpawnLocation")) > 1)
        if (aggroListEmpty and (checkLocation:DistanceSquared(this:GetObjVar("SpawnLocation")) > (3*3)) and #GetNearbyEnemies() == 0 and AI.PursueLastTarget == nil) then
            return true
        end
    end
    return false
end

--returns if leashing
function CheckLeash(location, targetExist)
    local target = AI.MainTarget
    if (AI.GetSetting("Leash") == false) then
        return false
    else
        local targetExist = targetExist or false
        local checkLocation = location or this:GetLoc()
        local leashDistance = AI.GetSetting("LeashDistance") or 10
        --DebugMessageA(this,this:GetName() .. "has leash distance of "..tostring(leashDistance))
        if( leashDistance ~= nil ) then
            leashDistance = math.max(0.5,leashDistance)
        end

        if (leashDistance ~= nil and checkLocation:DistanceSquared(this:GetObjVar("SpawnLocation")) > (leashDistance * leashDistance)) then
            --DebugMessageA(this,"Outside of leashing distance" .. tostring(this:GetLoc():Distance(this:GetObjVar("SpawnLocation"))).." is the distance to spawn and the leash distance is " ..tostring(leashdistance))
            return true
        elseif ((target == nil and not targetExist) and  checkLocation:Distance(this:GetObjVar("SpawnLocation")) > 0.5) then
            --DebugMessageA(this,"Target is nil and spawn location is farther away")
            return true
        end
    end
    --DebugMessageA(this,"Is leashing, within leashing distance, within chase distance")
    return false
end

--------------------------------------------------------------------------------------------------------------------------
--this is here so DecideIdleState is not a nil function, it gets overridden everywhere else.
function DecideIdleState()
    if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end
    if not(AI.IsActive()) then return end    
    --DebugMessage("Resetting chase time B")
    if (IsInCombat(this)) then
        this:SendMessage("EndCombatMessage")
    end
    --if this mob should go back to it's spawn position then do so now
    if ((CheckStrongLeash() or CheckLeash()) and AI.StateMachine.AllStates.GoHome.CanGoHome()) then
        AI.StateMachine.ChangeState("GoHome")
    elseif math.random(AI.GetSetting("WanderChance")) <= 1 and AI.GetSetting("CanWander") == true then 
        AI.StateMachine.ChangeState("Wander")
    elseif (AI.StateMachine.CurState ~= "Idle") then
        AI.StateMachine.ChangeState("Idle")
    end
end

function GetSafeLocation(startingLocation)
    local MAX_SAFE_TRIES = 20
    local MAX_DISTANCE = AI.GetSetting("ChaseRange")
    local myLoc = this:GetLoc()
    local testloc = myLoc:Project(math.random(0,360), math.random(MAX_DISTANCE/2,MAX_DISTANCE))
    local tries = 0
    while tries < MAX_SAFE_TRIES do
        if (not IsDamageableLoc(this:GetLoc(),this,true) and IsPassable(testloc)) then
            return testloc
        else
            local testloc = myLoc:Project(math.random(0,360), math.random(MAX_DISTANCE/2,MAX_DISTANCE))
        end
        tries = tries + 1
    end
    return testloc
end

lastDecideCall = nil

--Quick and dirty decide combat state function for dumber entities like animals. Overridden for enhanced thinking abilities, 
--or if you want do do more than just melee in combat.
--NOTE: BE CAREFUL WHERE YOU CALL THIS FUNCTION AS CALLING IT ON AN ON ENTER OR EXIT STATE CAN LEAD TO INFINITE LOOPS!!!
function DecideCombatState()  

    if (this:HasObjVar("Invulnerable")) then DecideIdleState() return end

    local frameTime = ObjectFrameTimeMs()
    if(frameTime == lastDecideCall) then
        --DebugMessage("SAME FRAME")
        return
    --elseif(lastDecideCall ~= nil and frameTime - lastDecideCall < 1000) then
    --    LuaDebugCallStack("Calling DecideCombatState more than once in one second")
    end
    lastDecideCall = frameTime

    --DebugMessage("Got here.")
    if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end
    if (this:HasTimer ("SpellPrimeTimer")) then return end
    if (AI.StateMachine.CurState == "GoHome") then return end
    if not(AI.IsActive()) then return end
    --DebugMessageA(this,"Try me")

    if ((CheckStrongLeash() or CheckLeash()) and AI.StateMachine.AllStates.GoHome:CanGoHome()) then
        AI.StateMachine.ChangeState("GoHome")
        return
    end

    --DebugMessageA(this,"anger is "..tostring(AI.Anger))
    AI.MainTarget = FindAITarget()
    local shouldFlee = ShouldFlee()
    --DebugMessage("ShouldFlee is "..tostring(shouldFlee))
    if (AI.StateMachine.CurState == "Flee" and shouldFlee) then return end
    if (not shouldFlee) then
        AI.StateMachine.ChangeState("DecidingCombat") 
    end
   --DebugMessage("Setting target to "..tostring(AI.MainTarget) .." in decide idle state")

    if (AI.MainTarget ~= nil) then
        AI.LastKnownTargetPos = AI.MainTarget:GetLoc()
    else
        AI.LastKnownTargetPos = nil
    end

    --Idle if we have no target
    if not AI.IsValidTarget(AI.MainTarget) then 
        this:ClearPathTarget()
        DecideIdleState()
        return     
    elseif (shouldFlee) then
        AI.StateMachine.ChangeState("Flee")
        return
    end

    --Talk if we talk
    if (math.random(1,10) == 1 and AI.GetSetting("CanConverse") and CombatTalk ~= nil) then
        CombatTalk()
    end 

    --Quick and dirty checking
    local distance = this:DistanceFromSquared(AI.MainTarget)
    local distanceToCheck = (AI.GetSetting("AggroRange") * AI.GetSetting("AggroRange"))
    if (distance > distanceToCheck and not AI.GetSetting("NoMelee")) then
        if (not AI.GetSetting("FleeUnlessAngry")) then
            AI.StateMachine.ChangeState("Chase")
        else
            this:ClearPathTarget()
            DecideIdleState()
        end
    elseif (distance < distanceToCheck) then
        local canTryAbility = (AI.GetSetting("CanUseCombatAbilities") ~= false and (this:HasObjVar("CombatAbilities") or this:HasObjVar("WeaponAbilities")) )
        
        if (AI.GetSetting("CanCast") == true or AI.GetSetting("NoMelee")) then

            local shouldCast = math.random(1,3)

            if (shouldCast == 1 or not AI.GetSetting("NoMelee")) then
                local CastTable = {}
                -- setup CastTable to hold the spells this AI can cast
                if (AI.Spells ~= nil) then
                    for spellName,data in pairs(AI.Spells) do
                        if(CanCast(spellName, AI.MainTarget) and AI.StateMachine.AllStates["Cast"..spellName] ~= nil) then
                            table.insert(CastTable, spellName)
                        end
                    end
                end

                -- continue casting if we have at least one castable spell and there's no cooldown
                if #CastTable > 0 and not this:HasTimer("CastCooldownTimer") then
                    -- Pick a random one of these spells
                    local spell = math.random(1, #CastTable)
                    -- Change state to that spell
                    AI.StateMachine.ChangeState("Cast"..CastTable[spell])
                else
                    local ability = math.random(1,3) 
                    if (ability == 1 and canTryAbility) then
                        AI.StateMachine.ChangeState("AttackAbility")
                    else
                        AI.StateMachine.ChangeState("Melee")
                    end
                end
            elseif (shouldCast == 2) then
                if (canTryAbility) then
                    AI.StateMachine.ChangeState("AttackAbility")
                else
                    AI.StateMachine.ChangeState("Melee")
                end
            else
                AI.StateMachine.ChangeState("Melee")
            end
        else
            if (canTryAbility and math.random(1,4) == 1) then
                AI.StateMachine.ChangeState("AttackAbility")
            else
                AI.StateMachine.ChangeState("Melee")
            end
        end
    end
    --DebugMessageA(this,"State is " .. AI.StateMachine.CurState)
end 
---------------------------------------------------------------------------------------------------------------------------

function HandleMobEnterView(mobileObj,ignoreVision,forceAttack)
    --DebugMessage("---------------------------")
    --DebugMessage(mobileObj:GetName().." entered view ")
    if (ignoreVision == nil) then ignoreVision = false end
    if not(AI.IsActive()) then return end
    if (this:HasTimer ("SpellPrimeTimer")) then return end
    if (not AI.IsValidTarget(mobileObj)) then 
        return 
    end    
    --[[if (not ignoreVision) then
    --If I'm outside of aggro range
        if (not this:HasLineOfSightToObj(mobileObj,ServerSettings.Combat.LOSEyeLevel) and this:DistanceFrom(mobileObj) > AI.GetSetting("AggroRange")) then
            return
        end
        --DFB TODO: If the mob isn't facing you then don't target them unless you can see them
        --if(not AI.GetSetting("CanSeeBehind"))  then
         ----   if (GetFacingZone(target,this) >= 3) then
        --        return
        --    end
        --end
    end--]]
    --DebugMessageA(this,mobileObj:GetName() .." entered range")
    --DebugMessageA(this,"Main target is "..tostring(AI.MainTarget).." and not IsFriend is "..tostring(mobileObj))
    local isFriend = false
    if not(forceAttack) then
        isFriend = IsFriend(mobileObj)
    end
    --DebugMessageA(this,"IsFriend is "..tostring(isFriend))
    --DebugMessageA(this,"MainTarget is "..tostring(AI.MainTarget).." mobileObj is "..tostring(mobileObj))
    if (not isFriend) then
        AI.AddToAggroList(mobileObj,2)
       --DebugMessage(4)
        if (AI.StateMachine.CurState ~= "GoHome") then
            if (forceAttack) then
                AttackEnemy(mobileObj,true)  
            else
                --DebugMessage("entering alert")
                AI.StateMachine.ChangeState("Alert")   
            end         
            --DebugMessageA(this,"ChangingToAlert")
        end
    end
end

function FaceTarget()
    FaceObject(this,AI.MainTarget)
end

--Essential states of any mob 
AI.StateMachine.AllStates = { 
    Disabled = {
        OnEnterState = function()
            PursueTry = 0
            AI.PursueLastTarget = nil
            this:ClearPathTarget()
            this:SendMessage("EndCombatMessage")
            SetAITarget(nil)
        end,
    },

    DecidingIdle = {
        OnEnterState = function()
        end,
    },

    Idle = {   
        GetPulseFrequencyMS = function() return 5000 end,

        OnEnterState = function()
        --LuaDebugCallStack("Entered idle")
            local homeFacing = this:GetObjVar("SpawnFacing")
            if( homeFacing ~= nil ) then
                --DebugMessage("Setting facing to "..tostring(homeFacing))
                this:SetFacing(homeFacing)
            end
            
            --this:NpcSpeech("[f70a79]*Idle!*[-]")
            --DebugMessageA(this,"Idle pulse")
        end,

        AiPulse = function ()
            AI.MainTarget = FindAITarget()
            if (AI.MainTarget == nil) then
                DecideIdleState()
            else
                DecideCombatState()
                return
            end
            --Reduce anger in idle
            AI.Anger = AI.Anger - 1
            if (AI.Anger < 0)  then
                AI.Anger = 0
            end
            -- body
        end
    },

    GoToLocation = {
        OnEnterState = function()
            --DebugMessage("AI.Destination is "..tostring(AI.Destination))
            if CheckPathLocation(AI.Destination) then DecideIdleState() return end
            --DebugMessage("Reached pathing")
            this:PathTo(AI.Destination,AI.GetSetting("ChargeSpeed"),"GoToLocation")
        end,

        GetPulseFrequencyMS = function() return 500 end,

        AiPulse = function ()
        --DebugMessage("AI.Destination is "..tostring(AI.Destination))
            if CheckPathLocation(AI.Destination) then DecideIdleState() return end
            this:PathTo(AI.Destination,AI.GetSetting("ChargeSpeed"),"GoToLocation")
        end,

        OnExitState = function()
            AI.Destination = nil
        end,
    },

    Pursue = {
        GetPulseFrequencyMS = function() return 1000 end,
        OnEnterState = function(self)
            if (GetSpeechTable ~= nil) then
                if (AI.GetSetting("CanConverse") and GetSpeechTable("TargetPursueSpeech") ~= nil and math.random(1,10) == 1) then
                    this:NpcSpeech(GetSpeechTable("TargetPursueSpeech")[math.random(1,#GetSpeechTable("TargetPursueSpeech"))])
                end
            end
            mConverseSettingGoHome = AI.GetSetting("CanConverse")
            AI.SetSetting("CanConverse",false)
            if (AI.LastKnownTargetPos ~= nil) then
                if ((CheckStrongLeash(AI.LastKnownTargetPos) or CheckLeash(AI.LastKnownTargetPos, true)) and AI.StateMachine.AllStates.GoHome.CanGoHome()) then
                    AI.StateMachine.ChangeState("WhereDidHeGo")
                    return
                end
                Pursuing = true
                this:PathTo(AI.LastKnownTargetPos,AI.GetSetting("ChargeSpeed"),"Pursue", true)
            else
                AI.StateMachine.ChangeState("WhereDidHeGo")
            end
        end,

        AiPulse= function ()
            if (PursueTry >= 5) then
                AI.StateMachine.ChangeState("WhereDidHeGo")
            elseif (Pursuing == false) then
                if (AI.LastKnownTargetPos ~= nil) then
                    if ((CheckStrongLeash(AI.LastKnownTargetPos) or CheckLeash(AI.LastKnownTargetPos, true)) and AI.StateMachine.AllStates.GoHome.CanGoHome()) then
                        AI.StateMachine.ChangeState("WhereDidHeGo")
                        return
                    end
                    Pursuing = true
                    this:PathTo(AI.LastKnownTargetPos,AI.GetSetting("ChargeSpeed"),"Pursue", true)
                else
                    AI.StateMachine.ChangeState("WhereDidHeGo")
                end
            end
        end,

        HandleFail = function(self)
            AI.StateMachine.ChangeState("WhereDidHeGo")
        end,

        OnExitState = function ( ... )
            AI.SetSetting("CanConverse",mConverseSettingGoHome)
            mConverseSettingGoHome = nil
        end,
    },
    GoHome = {
        GetPulseFrequencyMS = function() return 5000 end,
        OnEnterState = function()
            --DebugMessageA(this,"Entering state")
            GoingHome = false
            if(GetCurHealth(this) < GetMaxHealth(this)) then
                this:SendMessage("StartMobileEffect", "HealOverTime", this, { RegenMultiplier = 200.0, DamageInterrupts = true, PlayEffect = false, Duration = TimeSpan.FromSeconds(5) })
            end
            AI.StateMachine.AllStates.GoHome.DoGoHome()
        end,

        AiPulse = function ()
            GoHomeState.DoGoHome(state)
        end,

        DoGoHome = function()
            SetAITarget(nil)
            if (this:HasObjVar("MyPath") and AI.StateMachine.AllStates.ReturnToPath ~= nil) then    
                AI.StateMachine.ChangeState("ReturnToPath")         
                return   
            end
            --LuaDebugCallStack(this:GetName().." is trying to go home")
            if(GoHomeState:CanGoHome()) then
                --DebugMessage("And he is succeeding in going home.")
                --set this so that they won't get stuck having a conversation.
                mConverseSettingGoHome = AI.GetSetting("CanConverse")
                AI.SetSetting("CanConverse",false)
                --DebugMessageA(this,"Going home")

                local spawnLoc = this:GetObjVar("SpawnLocation")
                local distance = this:GetLoc():Distance(spawnLoc)
                --DebugMessageA(this,"spawnLoc is "..tostring(spawnLoc))
                if(distance > 2) then
                    if(distance > MAX_PATHTO_DIST) then
                        --DebugMessageA(this,"Attempting to wander home")
                        WanderTowards(spawnLoc,40,3.0,"GoHome")
                    elseif not(GoingHome) then
                        --DebugMessageA(this,"Attempting to path home")
                        GoingHome = true
                        this:PathTo(spawnLoc,3.0,"GoHome", true)
                    end
                else
                    AI.StateMachine.ChangeState("Idle")
                end
            else
                AI.StateMachine.ChangeState("Idle")
            end
        end,
        OnExitState = function()
            --reset it when exiting
            GoingHome = false
            AI.SetSetting("CanConverse",mConverseSettingGoHome)
            mConverseSettingGoHome = nil
        end,

        CanGoHome = function()
            return GoHomeState.ReturnAttempts < 10 
        end,

        HandleFail = function()
            GoHomeState.ReturnAttempts = GoHomeState.ReturnAttempts + 1
            --DebugMessageA(this,"attempting to go home number "..tostring(GoHomeState.ReturnAttempts))
            if(GoHomeState.ReturnAttempts >= 10 and not(this:DecayScheduled())) then
                Decay(this)
            end
            AI.StateMachine.ChangeState("Idle")
        end,

        ArriveSuccess = function(GoHomeState)
            GoHomeState.ReturnAttempts = 0
        end,

        ReturnAttempts = 0
    },
    Alert = {
        OnEnterState = function() 
            this:PlayAnimation("alarmed")
            --DebugMessage(DumpTable(aggroList))
            --DebugMessageA(this,"Entered alert")
            alertTarget = FindAITarget()
            if( alertTarget == nil ) then
               --DebugMessageA(this,"Changing to idle from alert")
               --DebugMessage(2)
                DecideIdleState()
            else
                FaceObject(this,alertTarget)
                --DebugMessage("Stop moving 1")
                this:StopMoving()
                -- force a pulse
                --DebugMessageA(this,"Alert Pulse")
                --AI.StateMachine.AllStates.Alert.AiPulse()
            end
            ----AI.StateMachine.--DebugMessage("ENTER ALERT")
        end,

        GetPulseFrequencyMS = function() return math.random(700,1200) end,

        AiPulse = function()    
            --AI.StateMachine.--DebugMessage("Alert pulse")
            --this:NpcSpeech("[f70a79]*Alert!*[-]")
            alertTarget = FindAITarget()
            if( alertTarget == nil ) then
               --DebugMessageA(this,"Changing to idle from alert")
               --DebugMessage(1)
                DecideIdleState()
            else
                FaceObject(this,alertTarget)
                --DebugMessage("Stop moving 2")
                this:StopMoving()
                --We found a new mobile, handle it
                local chanceToAttack = AI.GetSetting("ChanceToNotAttackOnAlert") or 1
                if ((chanceToAttack >= 1 and math.random(1, chanceToAttack ) == 1)  or alertTarget:DistanceFromSquared(this) < (AI.GetSetting("AggroRange") * AI.GetSetting("AggroRange"))) then
                    if (not IsFriend(alertTarget)) then
                        AttackEnemy(alertTarget)
                    else --not a threat, go to idle
                        --DebugMessage(3)
                        DecideIdleState()
                    end
                end
            end
        end,
    },

    WhereDidHeGo = {   
        GetPulseFrequencyMS = function() return math.random(2800,4500) end,

        OnEnterState = function()
                --DebugMessage("Stop moving 3")
            this:StopMoving()
            AI.MainTarget = nil
            --DebugMessage("Setting target to "..tostring(AI.MainTarget) .." in where did he go")

                --DebugMessage("Setting facing to "..tostring(homeFacing))
            if (IsHuman(this) and GetSpeechTable ~= nil) then
                if (AI.GetSetting("CanConverse") and GetSpeechTable("TargetDissapearedSpeech") ~= nil and math.random(1,10) == 1) then
                    this:NpcSpeech(GetSpeechTable("TargetDissapearedSpeech")[math.random(1,#GetSpeechTable("TargetDissapearedSpeech"))])
                end
                --this:PlayAnimation("fidget")
            end
            
            --this:NpcSpeech("[f70a79]*Idle!*[-]")
            --DebugMessageA(this,"enter WhereDidHeGo")
        end,

        AiPulse = function ()
            --If there is no target nearby after losing a target, enter idle
            AI.MainTarget = FindAITarget()
            PursueTry = 0
            AI.PursueLastTarget = nil
            if (AI.MainTarget == nil) then
                DecideIdleState()
            else
                DecideCombatState()
            end
        end
    },

    Wander = {
        GetPulseFrequencyMS = function() return 5000 end,

        OnEnterState = function()
           --DebugMessage("Wander start")
            local homeRegion = this:GetObjVar("homeRegion")
            WanderInRegion(homeRegion,"Wander")
        end,

        AiPulse = function()
            --CheckViewMobs()
           --DebugMessage("Wander pulse")
            --this:NpcSpeech("[f70a79]*Wander!*[-]")
            local homeRegion = this:GetObjVar("homeRegion")
            --DebugMessageA(this,"Changing state in wander.") 
            AI.MainTarget = FindAITarget()
            if (AI.MainTarget ~= nil) then
                DecideCombatState()
            elseif math.random(AI.GetSetting("WanderChance")) <= 1 then 
                AI.StateMachine.ChangeState("Idle")
            else
                WanderInRegion(homeRegion,"Wander")
            end
        end
    },

    -- Investigate= {
    --     GetPulseFrequencyMS = function() return 2000 end,

    --     OnEnterState = function()
    --         this:PathToTarget(FindAITarget(),aggroRange+3,1.0)
    --     end,

    --     AiPulse = function()
    --         if(AI.GetSetting("CanConverse") and math.random(1,4) == 1) then
    --             InvestigateSpeech()
    --         end
    --     end,
    -- },

    DecidingCombat = {
        OnEnterState = function()
        end,
    },

    AttackSpecial = {
        GetPulseFrequencyMS = function() return 1000 end,

        OnEnterState = function()
        end,

        AiPulse = function()
            DecideCombatState()
        end,
    },
    AttackAbility = {
        GetPulseFrequencyMS = function() return 200 end,
        OnEnterState = function()
            --DebugMessageA(this,"Attacking combat ability")
            --FaceTarget()
            --this:StopMoving()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                DecideIdleState()
                return
            end

            local combatAbilities = this:GetObjVar("CombatAbilities")
            local weaponAbilites = this:GetObjVar("WeaponAbilities")

            if ( combatAbilities == nil and weaponAbilites == nil ) then
                --DebugMessageA(this,"Can't perform!")
                AI.StateMachine.ChangeState("Melee")
                return
            end

            -- prevent a combat ability and weapon ability at the same time.
            local rnd = 0
            if ( combatAbilities ~= nil and weaponAbilites ~= nil ) then
                rnd = math.rnd(1, 2)
            end

            if ( combatAbilities ~= nil and (rnd == 0 or rand == 1) ) then
                local abilityName = combatAbilities[math.random(1, #combatAbilities)][1]
                PerformPrestigeAbility(this, AI.MainTarget, GetPrestigeAbilityClass(abilityName), abilityName)
            end
            
            if ( weaponAbilites ~= nil and (rnd == 0 or rand == 2) ) then
                local rand = math.random(1, (CountTable(weaponAbilites) or 1))
                local i = 1
                for k,v in pairs(weaponAbilites) do
                    if ( rand == i ) then
                        QueueWeaponAbility(this, (string.lower(k)=="primary"))
                        return
                    end
                    i = i + 1
                end
            end
        end,

        AiPulse = function()
            AI.StateMachine.ChangeState("Melee")
        end,
    },
    -- CastHeal = {
    --     GetPulseFrequencyMS = function() return 1000 end,

    --     OnEnterState = function()
    --         if (not CanCast("Heal",AI.MainTarget)) then
    --             --DecideCombatState()
    --             AI.StateMachine.ChangeState("Chase")
    --             return
    --         end
    --         --DebugMessage("Attempting Cast Heal")
    --         this:StopMoving()    
    --         this:SendMessage("CastSpellMessage","Heal",this,GetHealTarget())
    --     end,

    --     AiPulse = function()
    --     end,
    -- },


    Chase = {
        GetPulseFrequencyMS = function() return 2000 end,

        OnEnterState = function()
            --DebugMessageA(this,"target is "..tostring(AI.MainTarget))
            RunToTarget()
        end,

        AiPulse  = function()
            --Check if they are in certain distance from target and if they are too far away from their spawn location
            if (CheckStopChasing()) then 
                DecideIdleState()
                return 
            end
            if ((CheckStrongLeash() or CheckLeash()) and AI.StateMachine.AllStates.GoHome:CanGoHome()) then 
                DecideIdleState()
                return 
            end
            DecideCombatState()
        end
    },

    FleeToSafeLocation = {
       GetPulseFrequencyMS = function() return 1000 end,

       OnEnterState = function()
       --DebugMessage("Entered flee to safe location")
           AI.StateMachine.AllStates.FleeToSafeLocation.DoFlee()
       end,

       AiPulse = function()
           AI.StateMachine.AllStates.FleeToSafeLocation.DoFlee()
           DecideCombatState()
       end,

       DoFlee = function()
           if (FleeTalk ~= nil) then
               FleeTalk()
           end
           AI.MainTarget = nil
           --LuaDebugCallStack("Fleeing")
           local fleeDest = GetSafeLocation(this:GetLoc())
           local fleeSpeed = AI.GetSetting("FleeSpeed")
           this:PathTo(fleeDest,fleeSpeed,"Flee")
       end,
    },

    Flee = {
       GetPulseFrequencyMS = function() return 1000 end,

       OnEnterState = function()
           --this:ScheduleTimerDelay(TimeSpan.FromSeconds(AI.GetSetting("FleeTime") or 3),"Fear")
           AI.StateMachine.AllStates.Flee.DoFlee()
       end,

       AiPulse = function()
           AI.StateMachine.AllStates.Flee.DoFlee()
           DecideCombatState()
       end,

       OnExitState = function()
           --DebugMessage("Clearing")
           AI.FleeTarget = nil
       end,

       DoFlee = function()
           if (FleeTalk ~= nil) then

               FleeTalk()
           end
           --LuaDebugCallStack("Fleeing")
           this:SendMessage("EndCombatMessage")
           AI.ClearAggroList()
           --SetAITarget(nil)
           AI.FleeTarget = AI.MainTarget
           local fleeAngle = FindSafestAngle()
           --DebugMessage("FleeAngle is "..fleeAngle)
           local fleeDest = this:GetLoc():Project(fleeAngle, AI.GetSetting("FleeDistance"))
           local fleeSpeed = AI.GetSetting("FleeSpeed")
           this:PathTo(fleeDest,fleeSpeed,"Flee")
       end,
    },

    Dead = {
        OnEnterState = function()   
           --DebugMessageA(this,"Dead start")       
        end,
        OnExitState = function()
            --this:NpcSpeech("[f70a79]*Dead!*[-]")
            --DebugMessageA(this,"RIIISE FROM THE GRAVE")
        end,
    },

    Melee = {
        OnEnterState = function()
            if( not(AI.IsValidTarget(AI.MainTarget)) ) then
                --DebugMessageA(this,"[Attack:OnEnterState] No valid combat target found. Returning to Idle")
                DecideIdleState()
                return
            end

            FaceTarget()
            RunToTarget()
            --DebugMessageA(this,"attack start")

            AI.SetMeleeTarget(AI.MainTarget)
        end,

        OnExitState = function()
            --DebugMessageA(this,"attack exit")
            --if (AI.MainTarget == nil) then
             --   AI.ClearMeleeTarget()
            --end
        end,

        GetPulseFrequencyMS = function() return 3000 end,

        AiPulse = function()  
            if (CheckStopChasing()) then 
                DecideIdleState()
                return 
            end
            if ((CheckStrongLeash() or CheckLeash()) and AI.StateMachine.AllStates.GoHome:CanGoHome()) then 
                DecideIdleState()
                return 
            end

            DecideCombatState()
            --DebugMessageA(this,"Combat target is " .. tostring (AI.MainTarget))
            --this:NpcSpeech("[f70a79]*Attacking!*[-]")
            AI.Anger = AI.Anger + 1
        end,
    },
}
GoHomeState = AI.StateMachine.AllStates.GoHome
--handles when died
RegisterEventHandler(EventType.Message,"HasDiedMessage",
    function ()
        SetAITarget(nil)
        AI.ClearAggroList()
        AI.StateMachine.ChangeState("Dead")
    end)

RegisterEventHandler(EventType.Message,"EndCombatMessage",function ()
    AI.ClearMeleeTarget()
end)

--On the target coming into range
RegisterEventHandler(EventType.EnterView, "chaseRange", 
    function (objRef)
        HandleMobEnterView(objRef,false)
    end)

RegisterEventHandler(EventType.EnterView,"trapView",function(objRef)
    --DebugMessage("Checking for "..this:GetName())
    if (this:HasObjVar("controller")) then return end
    if objRef:HasObjVar("IsTrap") then
             --DebugMessage("Trap Detected")
             --if it's triggered, or it's a triggerable trap, then stop moving if it's close
             --local activated = ((objRef:GetSharedObjectProperty("IsTriggered") or j:HasObjVar("TrapKey")) and not targMob:HasObjVar("ImmuneToTraps"))
             --if (activated) then
        if (AI.Anger < 20 ) then
                 --DebugMessage("Stopped")
                --DebugMessage("Stop moving 4")
            this:StopMoving()
        end
    end
end)

--On the target becoming visible
RegisterEventHandler(EventType.Message, "WasRevealed", 
    function (mobileObj)
        if (mobileObj == nil or not mobileObj:IsValid()) then return end
        if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end
        if (this:HasTimer ("SpellPrimeTimer")) then return end
        if (AI.StateMachine.CurState == "GoHome") then return end
        if not(AI.IsActive()) then return end

        if (not AI.IsValidTarget(mobileObj)) then 
            return 
        end
        
        if (this:DistanceFromSquared(MobileObj) > (AI.GetSetting("ChaseRange") * AI.GetSetting("ChangeRange"))) then
            return 
        end

        if (not this:HasLineOfSightToObj(mobileObj,ServerSettings.Combat.LOSEyeLevel)) then
            return
        end

        --DebugMessageA(this,mobileObj:GetName() .." entered range")

        if (AI.MainTarget == nil and not IsFriend(mobileObj)) then
            AI.StateMachine.ChangeState("Alert")            
            --DebugMessageA(this,"ChangingToAlert")
        end
    end)

--On the target leaving range
RegisterEventHandler(EventType.LeaveView, "chaseRange", 
    function (mobileObj)
        if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end
        if (this:HasTimer ("SpellPrimeTimer")) then return end
        if (AI.StateMachine.CurState == "GoHome") then return end
        if not(AI.IsActive()) then return end
        AI.RemoveFromAggroList(mobileObj)

        --DebugMessageA(this,"LEAVE RANGE")
        if(mobileObj == AI.MainTarget) then
            if (not IsDead(mobileObj) and (mobileObj:IsCloaked() and not ShouldSeeCloakedObject(this, mobileObj))) then
                SetAITarget(nil)
                AI.StateMachine.ChangeState("WhereDidHeGo")
                --DebugMessageA(this,mobileObj:GetName() .." can't see the target anymore")
                return
            elseif (AI.MainTarget ~= nil and 
                    AI.IsValidTarget(mobileObj) and
                    AI.MainTarget == mobileObj and
                    not this:HasLineOfSightToObj(AI.MainTarget,ServerSettings.Combat.LOSEyeLevel) and not IsFriend(mobileObj) and ((this:GetLoc():Distance(this:GetObjVar("SpawnLocation")) < AI.GetSetting("LeashDistance"))  or not AI.GetSetting("StationedLeash"))
                     ) then --(FindAITarget() == nil and not IsFriend(mobileObj) and AI.IsValidTarget(mobileObj) and IsInCombat(this) and AI.StateMachine.CurState ~= "Alert" and AI.MainTarget ~= nil) then
               --DebugMessage("No target")
                AI.LastKnownTargetPos = AI.MainTarget:GetLoc()
                AI.PursueLastTarget = AI.MainTarget
                SetAITarget(nil)
                PursueTry = 0
                AI.StateMachine.ChangeState("Pursue") 
            else 
                --DebugMessage("Still finding a target")
                DecideCombatState()
            end
        end

        --DebugMessageA(this,mobileObj:GetName() .." left range")
    end)

RegisterEventHandler(EventType.LeaveView,"TargetView",function (mobileObj)
    SetAITarget(nil)
    AI.RemoveFromAggroList(mobileObj)
    --DebugMessage(1)
    if ((mobileObj == nil or not mobileObj:IsValid()) or ((not IsDead(mobileObj)) and (mobileObj:IsCloaked() and not ShouldSeeCloakedObject(this, mobileObj)))) then
        AI.StateMachine.ChangeState("WhereDidHeGo")
        if (mobileObj ~= nil) then
            --DebugMessageA(this,mobileObj:GetName() .." can't see the target anymore")
        end
        return
    end
    DecideCombatState()
end)

--Removes from the aggro list if dead.
RegisterEventHandler(EventType.Message, "VictimKilled", function (victim)
    AI.RemoveFromAggroList(victim)
end)

--NOTE: Don't call this when you leave the Melee state as it can throw it in a loop.
RegisterEventHandler(EventType.Message, "ClearTarget",
    function()
        --DebugMessageA(this,"Clearing target")

        AI.ClearAggroList()
        SetAITarget(nil)
        DecideCombatState()        
    end)

--Whenever I'
--Handles what to do on resurrection
RegisterEventHandler(EventType.Message, "OnResurrect", 
    function ()
        --Make em sit and think about it for a minute
        AI.StateMachine.ChangeState("Idle")
        AI.Anger = AI.Anger + 3
    end)

RegisterEventHandler(EventType.Arrived,"Flee",
    function (success)
        DecideIdleState()
    end)

RegisterEventHandler(EventType.Arrived,"GoHome",
    function (success)    
        --DebugMessageA(this,"GoHome Path success is "..tostring(success))
        --DebugMessageA(this,"CurrentState is "..tostring(AI.StateMachine.CurState))
        GoingHome = false
        if (AI.StateMachine.CurState == "GoHome") then
            --DFB HACK: This is bad, and stupid.        
            -- leash failed
            if (not success and AI.MainTarget == nil) then--and #nearbyPlayers == 0) then
                -- keep track of how many times it fails, if we hit 10 then add the decay module
                if(AI.StateMachine.AllStates.GoHome.HandleFail) then AI.StateMachine.AllStates.GoHome:HandleFail() end
            elseif(success) then
                --DebugMessageA(this,"Idle from go home")
                if(AI.StateMachine.AllStates.GoHome.ArriveSuccess) then AI.StateMachine.AllStates.GoHome:ArriveSuccess() end
                AI.Anger = AI.Anger - 5

                --Upon arrival, if state is still GoHome decide whether this mob should go idle or combat
                AI.MainTarget = FindAITarget()
                if (AI.MainTarget == nil) then
                    DecideIdleState()
                else
                    DecideCombatState()
                end
            end
        end
    end)

DOOR_OPEN_DIST = 4
RegisterEventHandler(EventType.Arrived,"Pursue",
    function (success)    
        --DebugMessageA(this,"Pursue Path success is "..tostring(success))
        if (AI.StateMachine.CurState == "Pursue") then
            if (AI.MainTarget == nil) then--and #nearbyPlayers == 0) then
                --if a door is in the way, open it.
                if (AI.GetSetting("CanOpenDoors")) then
                    local nearbyDoors = FindObjects(SearchModule("door",DOOR_OPEN_DIST))
                    --DebugMessage("SETTING")
                    if (#nearbyDoors > 0 and not nearbyDoors[1]:HasObjVar("locked")) then
                        --DebugMessage("DOOR OPENED")
                        --DebugMessage("Stop moving 5")
                        this:StopMoving()
                        this:PlayAnimation("cast_lightning")
                        nearbyDoors[1]:SendMessage("OpenDoor")
                    end
                end

                local lastTarget = AI.PursueLastTarget
                AI.MainTarget = FindAITarget()
                if (AI.MainTarget ~= nil and this:HasLineOfSightToObj(AI.MainTarget,ServerSettings.Combat.LOSEyeLevel)) then
                    DecideCombatState()
                    return
                end

                if (AI.PursueLastTarget == nil) then
                    AI.PursueLastTarget = lastTarget
                end

                if (PursueTry < 5 and AI.PursueLastTarget ~= nil) then
                    PursueTry = PursueTry + 1
                    AI.LastKnownTargetPos = AI.PursueLastTarget:GetLoc()
                    SetAITarget(nil)
                else
                    AI.StateMachine.ChangeState("WhereDidHeGo")
                end
            else
                DecideCombatState()
            end
        end
        Pursuing = false
    end)

--attack enemies remotely
RegisterEventHandler(EventType.Message,"AlertEnemy",
    function(target)
        AlertToTarget(target)
    end)

--attack enemies remotely
RegisterEventHandler(EventType.Message,"AttackEnemy",
    function(target,force)
        AttackEnemy(target,force)
    end)

--attack enemies remotely
RegisterEventHandler(EventType.Message,"AddThreat",
    function(target,amount)
        HandleMobEnterView(target,true,true)
        AI.AddThreat(target,amount)
    end)

RegisterEventHandler(EventType.Message,"AttackedBySpell",function (attacker,spellName)
    if not(AI.InAggroList(attacker)) then
        HandleMobEnterView(attacker,false,true)
    end
end)

--fear them remotely!
RegisterEventHandler(EventType.Message,"ForceFlee",
    function(target)
        AI.StateMachine.ChangeState("Flee")
    end)

RegisterEventHandler(EventType.Message,"ForceChangeState",
    function(nextState)
        AI.StateMachine.ChangeState(nextState)
    end)

BaseMobileHandleSwungOn = HandleSwungOn
function HandleSwungOn(attacker)
    BaseMobileHandleSwungOn(attacker)
    -- advance aggro and anger
    HandleAggroAnger(attacker, 1)
end

--When I get hit.
BaseMobileHandleApplyDamage = HandleApplyDamage
function HandleApplyDamage(damager, damageAmount, damageType, isCrit, wasBlocked, isReflected, damageSource)

        -- handle normal stuffs
        local newHealth = BaseMobileHandleApplyDamage(damager, damageAmount, damageType, isCrit, wasBlocked, isReflected, damageSource)

        -- early exit on a death
        if (newHealth == nil or newHealth <= 0 ) then return 0 end

        -- DAB NOTE: Make sure chase range encompasses this mob
        if(damager) then            
            local chaseRange = AI.GetSetting("ChaseRange")
            if(chaseRange < 20) then
                local damagerDist = math.min(this:DistanceFrom(damager),20)
                if(chaseRange < damagerDist) then
                    AI.SetSetting("ChaseRange",damagerDist)
                end
            end
        end

        if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return newHealth end     
        if (this:HasTimer ("SpellPrimeTimer")) then return newHealth end
        if not(AI.IsActive()) then return newHealth end
        if (AI.StateMachine.CurState == "GoHome") then return newHealth end
        if (this:HasObjVar("Invulnerable")) then return newHealth end
        --Check to see if it's an inanimate object or a trap that's hurting me, if so flee
        if (damageAmount > 8) then
            if (CheckFleeCloaked(damager)) then 
                 AI.StateMachine.ChangeState("FleeToSafeLocation") 
                 return newHealth
             end
            if (IsDamageableLoc(this:GetLoc(),this,true)) then
                AI.StateMachine.ChangeState("FleeToSafeLocation") 
                return newHealth
            end
        end

        HandleAggroAnger(damager, 3)

        return newHealth
end

function HandleAggroAnger(damager, threat)

    local hasAggro = AI.InAggroList(damager)
    if (this:GetObjVar("MobileTeamType") ~= damager:GetObjVar("MobileTeamType")) then
        AI.AddThreat(damager, threat)
    end
    if (IsFriend(damager) and (IsInCombat(this)) and AI.Anger < 145) then return end
    AI.Anger = AI.Anger + 5
    if not(hasAggro) then
        HandleMobEnterView(damager,true,true)
    else
        if (AI.StateMachine.CurState ~= "GoHome") then
            if (forceAttack) then
                AttackEnemy(mobileObj,true)  
            else
                AI.StateMachine.ChangeState("Alert")   
            end         
        end
    end
end

RegisterEventHandler(EventType.Message, "PathToLocation", 
    function (location)
        AI.StateMachine.ChangeState("GoToLocation")
        AI.Destination = location
    end)

--RegisterEventHandler(EventType.Arrived,"GoToLocation",function (success)
    --if (not success) then
        --DebugMessage("Pathing fucking sucks")
    --end
--end)

RegisterEventHandler(EventType.Message, "DisableAI", 
    function ()
        AI.StateMachine.ChangeState("Disabled")
    end)

RegisterEventHandler(EventType.Message, "EnableAI", 
    function ()
        if(AI.StateMachine.CurState == "Disabled") then
            local newState = AI.StateMachine.LastState or AI.InitialState or "Idle"
            AI.StateMachine.ChangeState(newState)            
        end
    end)

function OnCreate()
    if (not this:HasObjVar("SpawnLocation")) then
        this:SetObjVar("SpawnLocation",this:GetLoc())
    end
    if (not this:HasObjVar("SpawnFacing")) then
        this:SetObjVar("SpawnFacing",this:GetFacing())
    end
end

RegisterSingleEventHandler(EventType.ModuleAttached,GetCurrentModule(),
    function ( ... )
        OnCreate()
        AI.Init()
    end)

RegisterSingleEventHandler(EventType.LoadedFromBackup,"",
    function ( ... )
        AI.Init()
    end)