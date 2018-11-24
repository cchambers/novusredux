-- NOTE: Since all spawn controllers use the objvar "SpawnInfo" you can not have two different spawn controller modules on the same object

require 'spawn_controller'

local campRegion = GetRegion("DynamicCamp")
local prefabControllerTemplate = GetTemplateData("prefab_camp_controller")

function IsInCampRegion(spawnLoc)
	return (campRegion and campRegion:Contains(spawnLoc))
end

-- override get random location to check for plots
function GetRandomSpawnLocation(entry)
	local region = GetRegion(entry.Region)
	if( region == nil ) then
		--LuaDebugCallStack("REGION IS NIL: "..tostring(regionName))
		return nil
	end

    local prefabExtents = GetPrefabExtents(entry.Prefab)

    -- try to find an area that is in a camp region and all 4 corners are not overlapping another area
    local spawnLoc = GetRandomPassableLocationFromRegion(region,true)
    --DebugMessage("GetRandomSpawnLocation "..tostring(entry.Prefab)..", "..DumpTable(entry))
    local relBounds = GetRelativePrefabExtents(entry.Prefab, spawnLoc, prefabExtents)

    --Check if player is in camp boundary and if a player exists, do not build camp here
    local nearbyPlayer = FindObjects(SearchMulti({SearchRect(relBounds),SearchUser()}),GameObj(0))
    if (#nearbyPlayer ~= 0) then
        return nil
    end

    if((entry.Region == "DynamicCamp" or IsInCampRegion(spawnLoc)) and CheckBounds(relBounds,false)) then
        --Move every mobiles in camp boundary
        MoveMobiles(relBounds, spawnLoc)
    	return spawnLoc
    end
end

-- override enqueue function to use prefab instead of template
function EnqueueSpawn(entry,location,infoIndex,spawnIndex)
    table.insert(spawnQueue,{
            Prefab = entry.Prefab,
            Loc = location,
            Region = entry.Region,
            InfoIndex = infoIndex,
            SpawnIndex = spawnIndex
        })
end

function SpawnQueuePulse()
    if(#spawnQueue > 0) then
        local spawnData = table.remove(spawnQueue)
        --DebugMessage("Dynamic Camp Spawner - CREATING "..spawnData.Prefab.. " at "..tostring(spawnData.Loc))        
        CreateObj("prefab_camp_controller",spawnData.Loc,"controller_spawned",spawnData)
    end
end

RegisterEventHandler(EventType.CreatedObject,"controller_spawned",
    function(success,objRef,callbackData)        
        --spawn the object and save it
        if success then
            local spawnInfo = this:GetObjVar("SpawnInfo")
            spawnInfo[callbackData.InfoIndex].SpawnData[callbackData.SpawnIndex].ObjRef = objRef
            this:SetObjVar("SpawnInfo", spawnInfo)

            objRef:SetObjVar("PrefabName",callbackData.Prefab)
            objRef:SendMessage("Reset")
        end

        if(#spawnQueue > 0) then
            this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(250 + math.random(1,50)),"spawn_queue_timer")
        end
    end)