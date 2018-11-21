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

function GetSpawnDelay()
    local delaySecs = this:GetObjVar("spawnDelay") or DEFAULT_DELAY_SECS
    return TimeSpan.FromSeconds(delaySecs + math.random())
end

function CheckSpawn()
    -- add some randomness so there arent all spawning at the same time
    this:ScheduleTimerDelay(GetSpawnDelay(), "spawnTimer")

    if (this:HasObjVar("Disable")) then return end

    local spawnData = this:GetObjVar("spawnData")    
    local playerAround = not (#FindObjects(SearchPlayerInRange(20)) == 0)
    local spawnCount = this:GetObjVar("spawnCount") or DEFAULT_SPAWN_COUNT
    local templateId = this:GetObjVar("spawnTemplate")


    if( templateId == nil ) then
        --ebugMessage("[$2525]"..tostring(this.Id))
        return
    end
    
    if (spawnData ~= nil) then
        if (this:HasObjVar("NightSpawn")) then
            if (IsDayTime()) then
                if not playerAround then
                    for i=1,#spawnData do
                        if (spawnData[i] ~= nil and spawnData[i]:IsValid()) then
                            spawnData[i]:Destroy()
                        end
                    end
                end
                return
            end
        elseif (this:HasObjVar("DaySpawn")) then
            if (IsNightTime()) then 
                if not playerAround then
                    for i=1,#spawnData do
                        if (spawnData[i] ~= nil and spawnData[i]:IsValid()) then
                            spawnData[i]:Destroy()
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
        this:SetObjVar("spawnData", spawnData)
    elseif #spawnData > spawnCount then
    	for i=spawnCount+1,#spawnData do
            table.remove(spawnData,i)
        end
    end        

    local spawnChance = this:GetObjVar("spawnChance") or DEFAULT_SPAWN_CHANCE

    --DebugMessage("---CheckSpawn SpawnCount: "..spawnCount.." spawnChance: "..tostring(spawnChance))     

    if(spawnChance >= 1 or math.random() < spawnChance) then        
        --DebugMessage("SPAWNING")
        for i=1, spawnCount do
            --DebugMessage("---Checking i="..i)     
            if( (spawnData[i] == nil or not(spawnData[i]:IsValid())) and not mWait ) then
                --DebugMessage("---Create "..templateId)     
            	-- only create one at a time
                mWait = true
            	CreateObj(templateId, this:GetLoc(), "mobSpawned", i)
            	break
            end
        end
    end
end

RegisterEventHandler(EventType.Message,"Activate",function ( ... )
    this:DelObjVar("Disable")
end)
RegisterEventHandler(EventType.Message,"Deactivate",function ( ... )
    this:SetObjVar("Disable",true)
end)
RegisterEventHandler(EventType.Message,"RemoveSpawnedObject",function (targetObj)
    local spawnData = this:GetObjVar("spawnData")
    local newSpawnData = {}
    for i,spawnObj in pairs(spawnData) do
        if(spawnObj ~= targetObj) then
            newSpawnData[i] = spawnObj
        end
    end

    this:SetObjVar("spawnData",newSpawnData)
end)

RegisterSingleEventHandler(EventType.ModuleAttached, "simple_mob_spawner", 
	function()
		CheckSpawn()
	end)

RegisterEventHandler(EventType.CreatedObject, "mobSpawned", 
	function(success, objref, index)
		if( success) then
            mWait = false
			local spawnData = this:GetObjVar("spawnData") 
			spawnData[index] = objref
			this:SetObjVar("spawnData",spawnData)
            objref:SetObjVar("Spawner",this)
            --DebugMessage("Set facing to " .. tostring(this:GetFacing()))
            if(objref:IsMobile()) then
	           objref:SetFacing(this:GetFacing())
            end
		end
	end)

RegisterEventHandler(EventType.Timer, "spawnTimer", 
	function()
		CheckSpawn()
	end)

this:ScheduleTimerDelay(GetSpawnDelay(), "spawnTimer")