require 'incl_humanloot'
require 'incl_combatai'
require 'base_ai_mob'

currentDestinaion = nil
AI.Settings.Debug = false

AI.Settings.AlertRange = 10.0

function IsFriend(target)
    --Override if this is my "target"
    if (AI.InAggroList(target)) then
        return false
    end

    if (target == nil) then
        DebugMessage("[ai_aggressive_patrol|IsFriend] ERROR: target is nil")
        return true
    end


    local myTeam = this:GetObjVar("MobileTeamType")
    if (myTeam == nil) then --If I have no team, then attack everyone!
        DebugMessageA(this,"NO TEAM")
        return false
    end


    local otherTeam = target:GetObjVar("MobileTeamType")

    if (this:HasObjVar("NaturalEnemy") ~= nil)  then
        if (this:GetObjVar("NaturalEnemy") == otherTeam and otherTeam ~= nil) then
            return false
        end
    end

    if (target:GetMobileType() == "Animal" ) then --Animals don't usually attack animals
        if (this:DistanceFrom(target) < AI.Settings.AggroRange or math.random(AI.GetSetting("AggroChanceAnimals")) == 1) then            
            --AI.AddThreat(damager,-1)--Don't aggro them
            return (myTeam == otherTeam) 
        else
            return true
        end
    end
    if (otherTeam == nil) then
        return false
    end

    return (myTeam == otherTeam) --Return true if they have the same team, false if not.
end

function GetNextLoc(path,curPathIndex)
    local deviation = Loc(math.random()*2-1,0,math.random()*2-1)
    currentDestination = path[curPathIndex]:Add(deviation)
    return currentDestination
end

function DoPatrol()    
    local path = GetPath(this:GetObjVar("PatrolPath"))

    local stopChance = this:GetObjVar("stopChance") or 0
    local shouldWait = math.random(0, 100)
    if( shouldWait <= stopChance ) then
        local stopDelay = this:GetObjVar("stopDelay")
        this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(stopDelay), "patrolPause")
    else
        local curPathIndex = this:GetObjVar("curPathIndex")
        curPathIndex = (curPathIndex % #path) + 1
        this:SetObjVar("curPathIndex", curPathIndex)
        this:PathTo(GetNextLoc(path,curPathIndex),3.0,"patrol")
    end  
end

function GetNearestPathNode(path)
    local closestNode = nil
    local closestDistance = 0

    for index,loc in pairs(path) do
        local dist = this:GetLoc():Distance(loc)
        if(closestNode == nil or dist < closestDistance) then
            closestNode = index
            closestDistance = dist
        end
    end

    return closestNode
end

local base_AIInit = AI.Init
function AI.Init()
   base_AIInit()

   AddAIView("alert", SearchMobileInRange(AI.GetSetting("AlertRange")))
   AddAIView("chase", SearchMobileInRange(AI.GetSetting("ChaseRange")))
end

AI.StateMachine.AllStates.Idle = {
        OnEnterState = function()
            --DebugMessage(this:GetName().." is Start")            
            AI.StateMachine.ChangeState("ReturnToPath")            
        end
    }

AI.StateMachine.AllStates.GoHome = {
    OnEnterState = function()
            --DebugMessage(this:GetName().." is Start")            
            AI.StateMachine.ChangeState("ReturnToPath")            
        end,

    -- Return to path handles this
    CanGoHome = function() return true end
}
AI.StateMachine.AllStates.ReturnToPath = {
        OnEnterState = function()
            local path = GetPath(this:GetObjVar("PatrolPath"))

            --DebugMessage(this:GetName().." is Return to Path")
            local pathIndex = GetNearestPathNode(path)
            if( pathIndex == nil ) then
                return
            end
            if( this:GetLoc():Distance(path[pathIndex]) < 1 ) then
                AI.StateMachine.ChangeState("Patrol")
                return
            end
            this:SetObjVar("curPathIndex", pathIndex)
            this:PathTo(path[pathIndex],3.0,"returnToPath") 
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

AI.StateMachine.AllStates.Patrol = {
        OnEnterState = function()
            --DebugMessage(this:GetName().." is patroling")
            DoPatrol()
        end,
    }

function OnReturnToPathArrived(arriveSuccess)
    if(arriveSuccess) then
       -- --DebugMessage("Patrol")
        AI.StateMachine.ChangeState("Patrol")
    end
end

function OnPatrolArrived(arriveSuccess)

    if( AI.StateMachine.CurState ~= "Patrol" ) then
        -- ignore this message if we are no longer patrolling
        return
    end

    -- TODO: Handle the case where he fails to path properly
    -- for now we just move on to the next point in the patrol
    if not(arriveSuccess) then
    end

    DoPatrol()
end

function OnPatrolPause()
    DoPatrol()
end

function DecideIdleState()
    
    if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end
    if not(AI.IsActive()) then return end
    
    if (IsInCombat(this)) then
        this:SendMessage("EndCombatMessage")
    end

    AI.StateMachine.ChangeState("Idle")
end

if(initializer ~= nil) then
    this:SetObjVar("curPathIndex", 1)
    this:SetObjVar("stopChance", 0)
    this:SetObjVar("stopDelay", 3000)
    this:SetObjVar("isRunning", 0)      
end

RegisterEventHandler(EventType.Arrived, "returnToPath", OnReturnToPathArrived)
RegisterEventHandler(EventType.Arrived, "patrol", OnPatrolArrived)
RegisterEventHandler(EventType.Timer, "patrolPause", OnPatrolPause)