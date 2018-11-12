require 'spawn_controller'
MAX_ROOM_SIZE = 15
SPAWN_TIME = 9

function GetRandomLocationInObjectBounds(bounds)
    if(bounds == nil or #bounds == 0) then
        return nil
    end

    local bounds3 = bounds[math.random(#bounds)]
    local curBounds = bounds3:Flatten()

    return Loc(curBounds:GetRandomLocation())
end

-- overrides spawn controller get spawn location and only spawns within object bounds
function GetRandomSpawnLocation(entry)
    --DebugMessage("GetRandomSpawnLocation "..tostring(entry.Region))
    local region = GetRegion(entry.Region)
    if( region == nil ) then
        --LuaDebugCallStack("REGION IS NIL: "..entry.Region)
        return nil
    end

    local searcher = PermanentObjSearchMulti{
            PermanentObjSearchRegion(entry.Region),
            PermanentObjSearchHasObjectBounds(),
            PermanentObjSearchVisualState("Default")
        }

    --local objs1 = FindPermanentObjects(PermanentObjSearchRegion(entry.Region))
    --local objs2 = FindPermanentObjects(PermanentObjSearchHasObjectBounds())
    --local objs3 = FindPermanentObjects(PermanentObjSearchVisualState("Default"))
    --DebugMessage("TEST",tostring(#objs1),tostring(#objs2),tostring(#objs3))

    local objs = FindPermanentObjects(searcher)
    if(#objs == 0) then
        --DebugMessage("ERROR: No dungeon tiles found in region "..tostring(entry.Region))
        return nil
    end

    local curPermObj = objs[math.random(#objs)]
    local curBounds = curPermObj:GetPermanentObjectBounds()
    local spawnLoc = GetRandomLocationInObjectBounds(curBounds)
    local maxTries = 20
    while(maxTries > 0 and (spawnLoc ~= nil and not(spawnLoc:IsValid()) or not(IsPassable(spawnLoc)) or TrapAtLocation(spawnLoc))) do--(spawnLoc,false))) do
        local curPermObj = objs[math.random(#objs)]
        local curBounds = curPermObj:GetPermanentObjectBounds()
        spawnLoc = GetRandomLocationInObjectBounds(curBounds)
        maxTries = maxTries - 1        
    end

    if(maxTries <= 0) then
        --DebugMessage("ERROR: Tried 20 times for a passable location and failed. "..entry.Region)
        return nil
    end

    return spawnLoc,curPermObj
    --return Loc(0,0,0),PermanentObj(0)
end

