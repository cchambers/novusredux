DEFAULT_DECAYTIME = 15

function ScheduleDecay(decayTime)
	if(decayTime == nil) then
		decayTime = this:GetObjVar("DecayTime")		
	end

	if( decayTime == nil ) then
		decayTime = DEFAULT_DECAYTIME
	end

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(decayTime), "decay")
end

RegisterSingleEventHandler(EventType.ModuleAttached, "spawn_portal", 
	function()
		PlayEffectAtLoc("TeleportFromEffect",this:GetLoc())
		ScheduleDecay()
	end)

RegisterEventHandler(EventType.Message, "UpdateDecay", 
	function(decayTime)
		ScheduleDecay(decayTime)
	end)

RegisterEventHandler(EventType.Message, "DestroyPortal", 
	function(decayTime)
		this:FireTimer("decay")
	end)


RegisterEventHandler(EventType.Timer, "decay", 
	function()
		PlayEffectAtLoc("TeleportFromEffect",this:GetLoc())
		this:Destroy()
	end)