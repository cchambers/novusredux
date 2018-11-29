--[[
    Simple Mob Spawner - Tracks and spawns one or more of the same mob at a specific location

    Relevant ObjVars:
        spawnTemplate - template of mob to spawn
        spawnDelay - delay in seconds between respawn attempts
        spawnChacne - chance (0-1) of mob spawning on attempt
        spawnCount - how many of this mob should be spawned (default 1)
--]]



require 'incl_gametime'

-- the delay between spawn attempts, can be overridden by adding "spawnDelay" objvar
DEFAULT_DELAY_SECS = 180
-- the delay between spawn amounts, can be overridden by adding "spawnCount" objvar
DEFAULT_SPAWN_COUNT = 1
DEFAULT_SPAWN_CHANCE = 1
DEFAULT_PULSE_FREQ_SECS = 10

function GetSpawnPulse()
    local delaySecs = this:GetObjVar("spawnPulseSecs") or DEFAULT_PULSE_FREQ_SECS
    return TimeSpan.FromSeconds(delaySecs + math.random())
end

function GetSpawnDelay()
    local delaySecs = this:GetObjVar("spawnDelay") or DEFAULT_DELAY_SECS
    return TimeSpan.FromSeconds(delaySecs + math.random())
end

function GetSpawnLoc()
    local spawnRegion = this:GetObjVar("spawnRegion")
    if(spawnRegion) then
        return GetRandomPassableLocation(spawnRegion,true)
    end

    local spawnRadius = this:GetObjVar("spawnRadius")
    if(spawnRadius) then
        return GetRandomPassableLocationInRadius(this:GetLoc(),spawnRadius,true)
    end

    return this:GetLoc()
end

function ShouldSpawn(spawnData, spawnIndex)
    local isValid = spawnData[spawnIndex].ObjRef and spawnData[spawnIndex].ObjRef:IsValid()
    local isDead = isValid and spawnData[spawnIndex].ObjRef and spawnData[spawnIndex].ObjRef:IsMobile() and IsDead(spawnData[spawnIndex].ObjRef)

    -- the mob is still on the map and hes not a pet, no spawn
    if( isValid and not(isDead) and not(IsPet(spawnData[spawnIndex].ObjRef)) ) then
        return false
    end
    
    local spawnDelay = GetSpawnDelay(spawnInfo)
    DebugMessageB(this,"Checking spawnDelay "..tostring(spawnDelay.TotalSeconds))
    if(spawnDelay.TotalSeconds ~= 0) then
        -- this mob just disappeared or died
        local goneTime = spawnData[spawnIndex].GoneTime
        if( spawnData[spawnIndex].ObjRef and not(goneTime) ) then  
            DebugMessageB(this,"MOB DEAD OR DESPAWNED")   
            spawnData[spawnIndex].GoneTime = DateTime.UtcNow
            return false
        end

        -- are we waiting on the spawn timer
        if(goneTime and DateTime.UtcNow < (goneTime + spawnDelay)) then
            DebugMessageB(this,"Waiting on spawn timer")   
            return false
        end
    end

    -- roll to spawn
    local spawnChance = this:GetObjVar("spawnChance") or DEFAULT_SPAWN_CHANCE
    if(spawnChance < 1 and math.random() > spawnChance) then   
        spawnData[spawnIndex].GoneTime = DateTime.UtcNow
        return false
    end

    return true
end

function CheckSpawn()
    -- add some randomness so there arent all spawning at the same time
    this:ScheduleTimerDelay(GetSpawnPulse(), "spawnTimer")

    if (this:HasObjVar("Disable")) then return end

    local spawnData = this:GetObjVar("spawnData")        
    local spawnCount = this:GetObjVar("spawnCount") or DEFAULT_SPAWN_COUNT

    local templateId = nil
    local spawnTable = this:GetObjVar("spawnTable")
    if(spawnTable) then
        local totalWeight = 0
        for i,spawnEntry in pairs(spawnTable) do
            totalWeight = totalWeight + (spawnEntry.Weight or 1)
        end

        local weightRoll = math.random() * totalWeight
        totalWeight = 0
        for i,spawnEntry in pairs(spawnTable) do
            if( weightRoll <= totalWeight + spawnEntry.Weight ) then
                templateId = spawnEntry.Template
                break
            end
            totalWeight = totalWeight + (spawnEntry.Weight or 1)
        end        
    end

    if not(templateId) then
        templateId = this:GetObjVar("spawnTemplate")
    end

    if( templateId == nil ) then
        DebugMessage("ERROR: Simple mob spawner picked invalid template: "..tostring(this.Id))
        return
    end
    
    if (spawnData ~= nil) then
        if (this:HasObjVar("NightSpawn")) then
            if (IsDayTime()) then
                local playerAround = not (#FindObjects(SearchPlayerInRange(20)) == 0)
                if not playerAround then
                    for i=1,#spawnData do
                        if (spawnData[i].ObjRef ~= nil and spawnData[i].ObjRef:IsValid()) then
                            spawnData[i].ObjRef:Destroy()
                            spawnData[i].GoneTime = DateTime.UtcNow
                        end
                    end
                end
                return
            end
        elseif (this:HasObjVar("DaySpawn")) then
            if (IsNightTime()) then 
                local playerAround = not (#FindObjects(SearchPlayerInRange(20)) == 0)
                if not playerAround then
                    for i=1,#spawnData do
                        if (spawnData[i].ObjRef ~= nil and spawnData[i].ObjRef:IsValid()) then
                            spawnData[i].ObjRef:Destroy()
                            spawnData[i].GoneTime = DateTime.UtcNow
                        end
                    end
                end
                return
            end
        end
    end
    -- NOTE: If spawn count is made smaller, we are not destroying the extra mobs 
    if spawnData == nil then
        spawnData = {}
    elseif #spawnData > spawnCount then
    	for i=spawnCount+1,#spawnData do
            table.remove(spawnData,i)
        end
    end        

    --DebugMessage("---CheckSpawn SpawnCount: "..spawnCount.." spawnChance: "..tostring(spawnChance))     

        --DebugMessage("SPAWNING")
        for i=1, spawnCount do
            --DebugMessage("---Checking i="..i)     
        if(spawnData[i] == nil) then spawnData[i] = {} end
        if( ShouldSpawn(spawnData, i) ) then   
                --DebugMessage("---Create "..templateId)     
                local spawnLoc = GetSpawnLoc()
            	CreateObj(templateId, spawnLoc, "mobSpawned", i)
            -- DAB NOTE: SHOULD WE ONLY SPAWN ONE PER PULSE? AND SHOULD WE ONLY ROLL ONCE?
            	break
            end
        end

    this:SetObjVar("spawnData", spawnData)
    end

RegisterEventHandler(EventType.Message,"Activate",function ( ... )
    this:DelObjVar("Disable")
end)
RegisterEventHandler(EventType.Message,"Deactivate",function ( ... )
    this:SetObjVar("Disable",true)
end)
RegisterEventHandler(EventType.Message,"RemoveSpawnedObject",function (targetObj)
    local spawnData = this:GetObjVar("spawnData")

    for i,spawnInfo in pairs(spawnData) do
        if(spawnInfo.ObjRef == targetObj) then
            spawnInfo.ObjRef = nil
            spawnInfo.GoneTime = DateTime.UtcNow
        end
    end
    this:SetObjVar("spawnData",spawnData)
end)

RegisterSingleEventHandler(EventType.ModuleAttached, "simple_mob_spawner", 
	function()
        if(initializer and initializer.SpawnTable) then
            this:SetObjVar("spawnTable",initializer.SpawnTable)
        end
        if(initializer and initializer.SpawnObjVars) then
            this:SetObjVar("spawnObjVars",initializer.SpawnObjVars)
        end
		CheckSpawn()
	end)

RegisterEventHandler(EventType.CreatedObject, "mobSpawned", 
	function(success, objref, index)
		if( success) then
			local spawnData = this:GetObjVar("spawnData") 
            if(spawnData[index]) then
    			spawnData[index].ObjRef = objref
                spawnData[index].GoneTime = nil
            else
                spawnData[index] = { ObjRef = objref }
            end            
			this:SetObjVar("spawnData",spawnData)
            objref:SetObjVar("Spawner",this)
            --DebugMessage("Set facing to " .. tostring(this:GetFacing()))
            if(objref:IsMobile()) then
                if(this:HasObjVar("spawnRadius")) then
                    objref:SetFacing(math.random() * 360)
                else
    	            objref:SetFacing(this:GetFacing())
                end
            end

            local spawnObjVars = this:GetObjVar("spawnObjVars")
            if(spawnObjVars) then
                for varName,varData in pairs(spawnObjVars) do
                    objref:SetObjVar(varName,varData)
                end
            end
		end
	end)

RegisterEventHandler(EventType.Timer, "spawnTimer", 
	function()
		CheckSpawn()
	end)

this:ScheduleTimerDelay(GetSpawnPulse(), "spawnTimer")