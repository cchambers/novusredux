require 'NOS:spawn_controller'
MAX_ROOM_SIZE = 15
SPAWN_TIME = 9

-- overrides spawn controller get spawn location and only spawns within object bounds
function GetRandomSpawnLocation(entry)
    --DebugMessage("GetRandomSpawnLocation "..tostring(entry.Region))
    return GetRandomDungeonSpawnLocation(entry.Region)
end

