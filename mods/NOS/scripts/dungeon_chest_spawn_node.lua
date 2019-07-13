local initialized = false

function TryGetSpawnController()
	if (initialized) then
		return
	end

	local controllerTag = this:GetObjVar("ControllerTag")
	if(controllerTag) then
		local controllerObj = FindObjectWithTag(controllerTag)
		if(controllerObj) then
			controllerObj:SendMessage("NodeInit",this)
			initialized = true
			UnregisterEventHandler("",EventType.Timer,"TryGetSpawnController")
			return
		end
	end

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"TryGetSpawnController")
end

RegisterEventHandler(EventType.ModuleAttached,"dungeon_chest_spawn_node",
	function ( ... )
		TryGetSpawnController()
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ( ... )
		TryGetSpawnController()
	end)

RegisterEventHandler(EventType.Timer,"TryGetSpawnController",
	function ( ... )
		TryGetSpawnController()
	end)