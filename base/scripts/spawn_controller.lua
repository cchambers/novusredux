require 'incl_regions'
require 'incl_gametime'

Time = 0
NightStart = 18
NightEnd = 6
SPAWN_TIME = 10
mDefaultSpawnDelay = TimeSpan.FromMinutes(4)

spawnQueue = {}

function GetSpawnPulseFrequency()
    local spawnTimer = SPAWN_TIME * (this:GetObjVar("SpawnSpeedMultiplier") or 1)
    return TimeSpan.FromSeconds(spawnTimer)
end

function WithinSpawnTime(entry)
    if (entry.SpawnDuration ~= nil) then
        local testExecutionTime = entry.SpawnTime --get the current time to execute the spawn
        local currentTime = GetGameTimeOfDay()  --get the time of day
        local result = currentTime - testExecutionTime  --get the difference between the two

        testExecutionTime = testExecutionTime - 12
        currentTime = currentTime - 12

        --DebugMessage("result is ".. result .. " testExecutionTime is "..testExecutionTime)
        local duration = entry.SpawnDuration
        local overflow_duration = -12

        --get the amount to loop around the clock
        if (duration + testExecutionTime > 12) then
        overflow_duration = duration + testExecutionTime - 24
         end

        --in case someone decides to make a 25 hour work day (which is legal, but will result in target always doing it)
        if (duration > 24) then
            overflow_duration = 1
        end

        --in case someone tries to give a negative or zero duration (bad)
        if (duration <= 0) then
            overflow_duration = 0  
            DebugMessage("ERROR: [spawn_controller:WithinSpawnTime] in "..this:GetName().." has a negative or zero duration. You can't time travel")
        end

        --Determine if you should execute the state, none of the variable should be over or less than 12
        --DebugMessage("overflow_duration is ".. overflow_duration .. "corrected time is "  .. currentTime)
        local shouldExecute = ((result > 0 and result < duration) or (currentTime < overflow_duration))
        --DebugMessage("shouldExecute is ".. tostring(shouldExecute))

        if ((shouldExecute== true)) then
            return true
        end

        return false
    else
        --set new spawn for a new day
        if (GetGameTimeOfDay() < entry.SpawnTime and entry.LastExecutionTime ~= nil ) then
            entry.LastExecutionTime = nil
        end

        if (GetGameTimeOfDay() >= entry.SpawnTime and (lastExecutionTime ~= nil)) then
            return true
        else
            return false
        end
    end
end

--Remove all units that aren't specifically set to spawn.
function CheckSpawnTimes(info)
    for index,entry in pairs(info) do
        local spawnData = entry.SpawnData
        --DebugMessage("Checking time for spawn data "..entry.TemplateId)
        if (entry.SpawnTime ~= nil and entry.SpawnDuration ~= nil) then
            --DebugMessage("--checking spawn time for "..entry.TemplateId)
            for spawnIndex,subEntry in pairs(spawnData) do
                --DebugMessage("----checking entry ".. spawnIndex .." with template id"..entry.TemplateId)
                --DebugMessage("subEntry is "..tostring(subEntry.ObjRef))
                --DebugMessage("WithinSpawnTime is "..tostring(not WithinSpawnTime(entry)))
                if(subEntry.ObjRef ~= nil) then
                    if not(subEntry.ObjRef:IsValid()) then
                        subEntry.ObjRef = nil
                    elseif(not WithinSpawnTime(entry)) then
                        --DebugMessage("------Removing "..tostring(subEntry.ObjRef))
                        subEntry.ObjRef:SendMessage("SpawnDestroyMessage")
                        subEntry.ObjRef:Destroy()
                        subEntry.ObjRef = nil
                    end
                end
            end
        end
    end
end

function GetRandomSpawnLocation(entry)
    return GetRandomPassableLocation(entry.Region,true)
end

function GetSpawnDelay(spawnInfo)
    if(spawnInfo.DelayMin) then
        return TimeSpan.FromMinutes(spawnInfo.DelayMin)
    end

    return mDefaultSpawnDelay
end

function ShouldSpawn(spawnInfo,spawnIndex)  
    local spawnData = spawnInfo.SpawnData
    -- have we ever spawned this mob
    if( not(spawnData) or not(spawnData[spawnIndex]) ) then
        return true
    end

    --DebugMessage("TEST "..spawnIndex,DumpTable(spawnInfo.SpawnData[spawnIndex]))

    local isValid = spawnData[spawnIndex].ObjRef and spawnData[spawnIndex].ObjRef:IsValid()
    local isDead = isValid and spawnData[spawnIndex].ObjRef and IsDead(spawnData[spawnIndex].ObjRef)
    
    --DebugMessageB(this,"ShouldSpawn "..spawnInfo.TemplateId.." isValid: "..tostring(isValid).." isDead: "..tostring(isDead))
    -- the mob is still on the map and hes not a pet, no spawn
    if( isValid and not(isDead) and not(spawnData[spawnIndex].ObjRef:HasObjVar("controller")) ) then
        return false
    end

    -- check if this is the first time hes disappeared
    local spawnDelay = GetSpawnDelay(spawnInfo)

    --DebugMessageB(this,"Checking spawnDelay "..tostring(spawnDelay.TotalSeconds))
    if(spawnDelay.TotalSeconds ~= 0) then
        -- this mob just disappeared or died
        local goneTime = spawnData[spawnIndex].GoneTime
        if( spawnData[spawnIndex].ObjRef and not(goneTime) ) then  
            --DebugMessageB(this,"MOB DEAD OR DESPAWNED")   
            spawnData[spawnIndex].GoneTime = DateTime.UtcNow
            return false
        end

        -- are we waiting on the spawn timer
        if(goneTime and DateTime.UtcNow < (goneTime + spawnDelay)) then
            --DebugMessageB(this,"Waiting on spawn timer")   
            return false
        end
    end

    -- check spawn time (for night spawns etc)
    if (spawnInfo.SpawnTime ~= nil and not(WithinSpawnTime(spawnInfo))) then
        --DebugMessageB(this,"Waiting on spawn time (time of day)")   
        return false
    end

    -- roll to spawn
    local chanceRoll = math.random()*100
    --DebugMessageB(this,"Checking on chanceRoll "..tostring(chanceRoll).." against "..tostring(spawnInfo.Chance))
    if (spawnInfo.Chance ~= nil and chanceRoll > spawnInfo.Chance) then
        -- reset gone time if spawn failed on chance
        if(spawnDelay.TotalSeconds ~= 0) then
            --DebugMessageB(this,"Chance failed, reset gonetime")
            spawnData[spawnIndex].GoneTime = DateTime.UtcNow
        end
        return false
    end
    
    --DebugMessage("Checking GoneTime "..tostring(DateTime.UtcNow).." "..tostring(spawnData[spawnIndex].GoneTime + spawnDelay))
    -- check if the spawn delay has elapsed
    return true
end

function EnqueueSpawn(entry,location,infoIndex,spawnIndex)
    table.insert(spawnQueue,{
                Template = entry.TemplateId,
                Loc = location,
                Region = entry.Region,
                InfoIndex = infoIndex,
                SpawnIndex = spawnIndex
            })
end

--Check to see if we should spawn an entry
function CheckSpawnEntry(index,entry)
    --DebugMessage(2)
    local spawnData = entry.SpawnData
    --DebugTable(entry.SpawnData)
    for spawnIndex,subEntry in pairs(spawnData) do        
        --DebugMessage("CheckSpawn index",tostring(index),tostring(spawnIndex),tostring(shouldSpawn),tostring(entry.TemplateId),tostring(entry.Region),tostring(spawnData[spawnIndex].ObjRef),tostring(spawnData[spawnIndex].ObjRef and spawnData[spawnIndex].ObjRef:IsValid()))
        -- NOTE: If you can res mob corpses this would break!
        if (ShouldSpawn(entry,spawnIndex) and (spawnData[spawnIndex].ObjRef == nil or not(spawnData[spawnIndex].ObjRef:IsValid()) ) ) then
            local spawnLoc = GetRandomSpawnLocation(entry)

            if( spawnLoc ~= nil ) then
                --DebugMessage("--SC QUEUING "..entry.TemplateId)
                EnqueueSpawn(entry,spawnLoc,index,spawnIndex)
                
                -- only spawn one mob per entry per pulse
                return true
                --DebugMessage("Creating object: " .. entry.TemplateId)                
            end
        end
    end 
end

--Check o see if we should spawn
function CheckSpawn(info)
    --spawned determines if we should set the obj var
    --DebugMessage("CheckSpawn "..tostring(data)..", "..tostring(templateId))
    if(#spawnQueue == 0) then
        for index,entry in pairs(info) do
            --check each entry in spawn data
            --DebugMessage("CheckSpawnEntry",tostring(entry.TemplateId),tostring(entry.Region),tostring(index))
            CheckSpawnEntry(index,entry)
        end

        --DebugMessage("--------------------- SPAWN PULSE ("..tostring(#spawnQueue)..") --")
        if(#spawnQueue > 0) then
            -- NOTE: this needs to happen on the next frame so the SetObjVar in HandleSpawn does not overwrite the changes in the created handler
            this:FireTimerAsync("spawn_queue_timer")
        end
    else
        --DebugMessage("WARNING: Skipping spawn pulse because there are still spawns in the queue ("..tostring(#spawnQueue)..") --")
        this:ScheduleTimerDelay(GetSpawnPulseFrequency(), "spawn_timer")
    end    
end

--Handle a spawn request.
function HandleSpawn()    
    this:ScheduleTimerDelay(GetSpawnPulseFrequency(), "spawn_timer")

    if(this:GetObjVar("Active") ~= false) then
        local spawnInfo = this:GetObjVar("SpawnInfo") or {}
        --Create the spawn data 
        --DebugTable(spawnInfo)
        CheckSpawn(spawnInfo)
        --check if we should remove night only mobs and if so then do so    
        CheckSpawnTimes(spawnInfo)

        this:SetObjVar("SpawnInfo",spawnInfo)
    end
end

function SpawnQueuePulse()
    if(#spawnQueue > 0) then
        local spawnData = table.remove(spawnQueue)
        --DebugMessage("--SC CREATING "..spawnData.Template.. " : "..tostring(spawnData.Loc))
        CreateObj(spawnData.Template, spawnData.Loc, "created", spawnData)
    end
end

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function()  
        if(initializer.SpawnInfo ~= nil) then
            for i,j in pairs(initializer.SpawnInfo) do --for each entry in spawnInfo
                j.SpawnData = {} --create a new table of spawn data
                for n=1,j.Count do --for each entity to spawn in Count
                    j.SpawnData[n] = {} --create a new entry                    
                end
            end
            local spawnInfo = initializer.SpawnInfo
            --Saves spawn info to a list of dicts as an obj var
            this:SetObjVar("SpawnInfo",spawnInfo)
        end
        this:ScheduleTimerDelay(GetSpawnPulseFrequency(), "spawn_timer")
    end)

RegisterSingleEventHandler(EventType.LoadedFromBackup, "", 
    function ()
        this:ScheduleTimerDelay(GetSpawnPulseFrequency(), "spawn_timer")
    end)

RegisterEventHandler(EventType.Timer, "spawn_timer", 
    function ()
        --DebugMessage("HandleSpawn "..this:GetCreationTemplateId())
        HandleSpawn()
    end)

RegisterEventHandler(EventType.Timer, "spawn_queue_timer",
    function ( ... )
        SpawnQueuePulse()        
    end)

RegisterEventHandler(EventType.CreatedObject, "created", 
    function(success,objRef,callbackData)
        --spawn the object and save it
        if success then
            local spawnInfo = this:GetObjVar("SpawnInfo")
            local region = callbackData.Region
            objRef:AddModule("spawn_decay")
            --DebugMessage("--SC CREATED ",tostring(callbackData.InfoIndex),tostring(callbackData.SpawnIndex),tostring(objRef))
            spawnInfo[callbackData.InfoIndex].SpawnData[callbackData.SpawnIndex].ObjRef = objRef
            --DebugTable(spawnInfo[callbackData[2]].SpawnData)
            --DebugMessage("Spawn Data controller")
            --DebugTable(spawnInfo[callbackData[2]].SpawnData[callbackData[3]])
           --DebugMessage("Set spawn info")
            this:SetObjVar("SpawnInfo", spawnInfo)
            objRef:SetObjVar("homeRegion", region)
            objRef:SetObjVar("Spawner",this)     
            objRef:SetFacing(math.random(1,360))       
        end

        if(#spawnQueue > 0) then
            this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(250 + math.random(1,50)),"spawn_queue_timer")
        else
            --DebugMessage("---- SPAWN DONE")
        end
    end)

RegisterEventHandler(EventType.Message,"SetActive",
    function (isActive)
        this:SetObjVar("Active",isActive)
    end)