--DEVELOPER NOTE: Is there more we could put in here?
lootTemplates = { "potion_health" }

RegisterSingleEventHandler(EventType.ModuleAttached, "autofill_random_loot", 
	function()
		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1000), "loot_timer")
	end)

RegisterEventHandler(EventType.Timer, "loot_timer", 
	function()
		local contObjects = this:GetContainedObjects()
		local maxItems = this:GetObjVar("MaxItems") or GetCapacity(this)

		if( #contObjects < maxItems ) then
			local numTemplates = this:GetObjVar("NumTemplates")
			local lootTemplate = this:GetObjVar("Template"..math.random(1, numTemplates))

			local dropPos = GetRandomDropPosition(this)
			CreateObjInContainer(lootTemplate, this, dropPos, "item_created")
		end

		if( #contObjects + 1 < maxItems ) then
			local spawnDelaySecs = this:GetObjVar("SpawnDelaySecs")
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(spawnDelaySecs), "loot_timer")
		end
	end)

RegisterEventHandler(EventType.CreatedObject,"item_created",
	function(success,objRef)
		if (this:HasObjVar("EverythingIsWorthless")) then
			objRef:SetObjVar("Worthless",true)
		end
	end)

RegisterEventHandler(EventType.ContainerItemRemoved, "", 
	function()
		local spawnDelaySecs = this:GetObjVar("SpawnDelaySecs")
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(spawnDelaySecs), "loot_timer")
	end)