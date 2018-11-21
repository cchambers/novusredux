

RegisterEventHandler(EventType.ModuleAttached,"statue_effect",
	function()
		AddView("NearbyPlayerStatueEffect", SearchPlayerInRange(5))
	end	)

RegisterEventHandler(EventType.EnterView,"NearbyPlayerStatueEffect",
	function()
		local sound = this:GetObjVar("Sound") or "DemonIdle1"
		this:PlayObjectSound(sound)
	end )