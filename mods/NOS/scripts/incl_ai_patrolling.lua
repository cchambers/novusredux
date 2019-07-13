require 'NOS:base_ai_state_machine'
require 'NOS:incl_regions'

if(initializer ~= nil) then
    this:SetObjVar("curPathIndex", 1)
    this:SetObjVar("stopChance", 5)
    this:SetObjVar("stopDelay", 3000)
    this:SetObjVar("isRunning", 0)      
end
if (AI.IdleStateTable ~= nil) then
end

function GetNextLoc(path,curPathIndex)
    local deviation = Loc(math.random()*2-1,0,math.random()*2-1)
    currentDestination = path[curPathIndex]:Add(deviation)
    return currentDestination
end

function DoPatrol()    
    if AI.GetSetting("ShouldPatrol") == false then
        return
    end
    local path = GetPath(this:GetObjVar("MyPath"))

    local stopChance = this:GetObjVar("stopChance") or 0
    local shouldWait = math.random(0, 100)
    if( shouldWait <= stopChance ) then
        local stopDelay = this:GetObjVar("stopDelay")
        this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(stopDelay), "patrolPause")
    else
        local curPathIndex = this:GetObjVar("curPathIndex")
        local pathLoc = GetNextLoc(path,curPathIndex)
        if(this:GetLoc():Distance(pathLoc) > MAX_PATHTO_DIST) then
            AI.StateMachine.ChangeState("ReturnToPath")
        else            
            curPathIndex = (curPathIndex % #path) + 1
            this:SetObjVar("curPathIndex", curPathIndex)
            this:PathTo(pathLoc,AI.GetSetting("PatrolSpeed"),"patrol")
        end
    end  
end

function GetNearestPathNode(path)
    if(path == nil) then return nil end
    
    local closestNode = nil
    local closestDistance = 0

    for index,loc in pairs(path) do
        local dist = this:GetLoc():Distance(loc)
        if(closestNode == nil or dist < closestDistance) then
            closestNode = index
            closestDistance = dist
        end
    end

    return closestNode, closestDistance
end

AI.StateMachine.AllStates.ReturnToPath = {
        GetPulseFrequencyMS = function() return 3000 end,

        OnEnterState = function(self)
            mConverseSettingGoHome = AI.GetSetting("CanConverse")
            AI.SetSetting("CanConverse",false)
            DebugMessageA(this,"Yes")
            self:AiPulse()
        end,

        OnExitState = function()
            --reset it when exiting
            AI.SetSetting("CanConverse",mConverseSettingGoHome)
            mConverseSettingGoHome = nil
        end,

        AiPulse = function()
            DebugMessageA(this,"Entering state")
            if (not this:IsMoving()) then
                DebugMessageA(this,"ReturnAttempts is "..tostring(AI.StateMachine.AllStates.ReturnToPath.ReturnAttempts))
                if(AI.StateMachine.AllStates.ReturnToPath.ReturnAttempts > 10) then
                    -- we are lost just stay put
                    DebugMessageA(this,"Changing to stationed")
                    AI.StateMachine.ChangeState("Idle")
                    if (not this:HasObjVar("DoesNotNeedPath")) then
                        --DebugMessage("[incl_ai_patrolling] ERROR: "..this:GetName().." failed to return to path!")
                        if (not this:DecayScheduled()) then
                            Decay(this)
                        end
                    end
                    return
                end

                --DebugMessage(this:GetName().." is Return to Path")
                local path = GetPath(this:GetObjVar("MyPath"))
                --DebugMessage("the path is "..tostring(path))
                local pathIndex, pathDist = GetNearestPathNode(path)
                if( pathIndex == nil ) then
                    DebugMessageA(this,"[ai_cultist_guard::ReturnToPath] No valid path node location")
                    AI.StateMachine.ChangeState("Idle") 
                    if (not this:HasObjVar("DoesNotNeedPath")) then
                        --DebugMessage("[incl_ai_patrolling] ERROR: "..this:GetName().." has no path variable!")
                         if (not this:DecayScheduled()) then
                            Decay(this)
                        end
                    end
                    return
                end

                local pathLoc = path[pathIndex]
                
                -- we made it back to our path lets resume patrol
                if( this:GetLoc():Distance(pathLoc) < 1 ) then
                    this:SetObjVar("curPathIndex", pathIndex)
                    AI.StateMachine.AllStates.ReturnToPath.ReturnAttempts = 0
                    AI.StateMachine.ChangeState("Patrol")
                    return
                end
                
                if(pathDist > MAX_PATHTO_DIST) then
                    DebugMessageA(this,"Wandering back to path")
                    WanderTowards(pathLoc,40,AI.GetSetting("PatrolSpeed"),"returnToPath")
                else                
                    DebugMessageA(this,"Returning to path")
                    this:SetObjVar("curPathIndex", pathIndex)
                    this:PathTo(pathLoc,AI.GetSetting("PatrolSpeed"),"returnToPath") 
                end
            end
        end,

        ReturnAttempts = 0,
    }

AI.StateMachine.AllStates.Patrol = {

        OnEnterState = function(self)
            mConverseSettingGoHome = AI.GetSetting("CanConverse")
            AI.SetSetting("CanConverse",false)
            DoPatrol()
        end,

        OnExitState = function()
            --reset it when exiting
            AI.SetSetting("CanConverse",mConverseSettingGoHome)
            mConverseSettingGoHome = nil
        end,
    }


AI.StateMachine.AllStates.Wander = {
        GetPulseFrequencyMS = function() return math.random(1700,2400) end,
        
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
            --if( math.random(2) == 1) then
            --    this:PlayAnimation("fidget")
            --end         
            if (GetPath(this:GetObjVar("MyPath")) ~= nil) then
                AI.StateMachine.ChangeState("ReturnToPath")   
            end
        end,

        AiPulse = function()  
            DecideIdleState()
        end,
    }

function OnReturnToPathArrived(arriveSuccess)
    if (not arriveSuccess) then
        DebugMessageA(this,"adding return attempt")
        AI.StateMachine.AllStates.ReturnToPath.ReturnAttempts = AI.StateMachine.AllStates.ReturnToPath.ReturnAttempts + 1
    else 
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

RegisterEventHandler(EventType.Arrived, "returnToPath", OnReturnToPathArrived)
RegisterEventHandler(EventType.Arrived, "patrol", OnPatrolArrived)
RegisterEventHandler(EventType.Timer, "patrolPause", OnPatrolPause)
RegisterEventHandler(EventType.Arrived, "Wander", AI.StateMachine.AllStates.Wander.OnArrived)