require 'base_ai_state_machine'
require 'incl_regions'
require 'incl_ai_patrolling'

this:SetObjVar("stopChance", 0)

if (AI.IdleStateTable ~= nil) then
    for i,j in pairs(AI.IdleStateTable) do 
        if (j[2] == "ReturnToPath") then
            table.remove(AI.IdleStateTable,i)
        end
    end
end

function GetNextLoc(path,curPathIndex)
    local deviation = Loc(math.random()*2-1,0,math.random()*2-1)
    currentDestination = path[curPathIndex]:Add(deviation)
    return currentDestination
end

function DoPatrol()    
    local path = GetPath(this:GetObjVar("MyPath"))
    if (path == nil) then
        AI.StateMachine.ChangeState("Idle")
        return
    end
    
    local curPathIndex = this:GetObjVar("curPathIndex")    
    local pathLoc = GetNextLoc(path,curPathIndex)
    if(this:GetLoc():Distance(pathLoc) > MAX_PATHTO_DIST) then
        AI.StateMachine.ChangeState("ReturnToPath")
    else            
        curPathIndex = (curPathIndex % #path) + 1
        this:SetObjVar("curPathIndex", curPathIndex)
        this:PathTo(pathLoc,3.0,"patrol")
    end
end

function OnPatrolArrived(arriveSuccess)
    
    if (GetObjVar("curPathIndex") == #GetPath(this:GetObjVar("MyPath"))) then
        this:DelObjVar("MyPath")
        AI.StateMachine.ChangeState("Idle")
        return
    end

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

RegisterEventHandler(EventType.Message,"FollowPath",
    function(pathName)
        this:SetObjVar("MyPath",pathName)
        AI.StateMachine.ChangeState("ReturnToPath")
    end)