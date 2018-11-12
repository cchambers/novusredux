RegisterEventHandler(EventType.ModuleAttached,"guard_tower_controller",
	function ( ... )
		CreatePrefab("GuardTower",this:GetLoc(), this:GetRotation())
	end)