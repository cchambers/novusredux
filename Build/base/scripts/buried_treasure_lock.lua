-- Locks the chest until all the mobs are defeated

RegisterSingleEventHandler(EventType.ModuleAttached,"buried_treasure_lock",
	function ( ... )
		local mobTables = initializer.MobTables
		local spawnCount = 0 
		local spawnedMobTable = {}
		local failedToSpawn = false
		if(mobTables and #mobTables > 0) then
			local mobSpawns = mobTables[math.random(#mobTables)]
			for i, mobTemplate in pairs(mobSpawns) do
				local spawnLoc = checkSpawnLoc(1)

				if (spawnLoc) then
					local spawnedMob = {}
					table.insert(spawnedMob, mobTemplate)
					table.insert(spawnedMob, spawnLoc)
					table.insert(spawnedMobTable, spawnedMob)
					spawnCount = spawnCount + 1
				else
					failedToSpawn = true
					break
				end
			end
		end

		if (failedToSpawn == true) then
			this:Destroy()
		else
			for key,value in pairs(spawnedMobTable) do
				this:PlayEffect("TeleportFromEffect")
				CreateObj(value[1],value[2],"mob_spawned")
			end

			if(spawnCount == 0) then
				this:DelModule("buried_treasure_lock")
			end

			if(this:DecayScheduled()) then
				this:RemoveDecay()
			end

			this:PlayObjectSound("DoorLock")
			this:SendMessage("Lock")
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"CheckEventComplete")
			this:ScheduleTimerDelay(TimeSpan.FromMinutes(5),"EndEvent")
		end
	end)

function checkSpawnLoc(try)
	if (try > 10) then
		DebugMessage("Failed to spawn mob near buried treasure (Tried 10 times)")
		return nil
	end

	spawnLoc = GetNearbyPassableLoc(this, 360, 2, 5)
	local nearbyHouses = GetNearbyHouses(spawnLoc, 10)
	for key,value in pairs(nearbyHouses) do
		local housePlots = GetHouseControlPlot(value)
		if (housePlots:Contains(spawnLoc)) then
			spawnLoc = checkSpawnLoc(try + 1)
			return spawnLoc
		end
	end

	return spawnLoc
end

RegisterEventHandler(EventType.CreatedObject, "mob_spawned",
	function(success,objRef)
		if(success) then
			AddToListObjVar(this,"TreasureMobs",objRef)
		end
	end)

RegisterEventHandler(EventType.Timer,"CheckEventComplete",
	function()
		local livingMobs = 0
	    local allMobs = this:GetObjVar("TreasureMobs")
		for i,mobRef in pairs(allMobs) do
			if(mobRef and mobRef:IsValid() and not(IsDead(mobRef))) then
				livingMobs = livingMobs + 1
			end
		end

		if(livingMobs > 0) then
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"CheckEventComplete")
		else
			this:PlayEffect("TeleportToEffect")
			this:PlayObjectSound("DoorUnlock")
			this:SendMessage("Unlock")
			Decay(this)
			this:DelModule("buried_treasure_lock")
		end
	end)

RegisterEventHandler(EventType.Timer,"EndEvent",
	function()
		local allMobs = this:GetObjVar("TreasureMobs")
		for i,mobRef in pairs(allMobs) do
			if(mobRef and mobRef:IsValid() and not(IsDead(mobRef))) then				
				mobRef:Destroy()
			end
		end

		this:Destroy()
	end)