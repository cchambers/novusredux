function HandleInit() 
	this:SendClientMessage("TimeUpdate", {"12:00", GetDaylightDurationSecs(), GetNighttimeDurationSecs()})
	this:SystemMessage("You can now see in the dark.", "info")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "EndNightSight")
end

function EndEffect()
	this:SendClientMessage("TimeUpdate", {GetCurrentTimeOfDay(), GetDaylightDurationSecs(), GetNighttimeDurationSecs()})
	this:SystemMessage("Night Sight has worn off.", "info")
	this:DelModule("sp_nightsight")
end

RegisterEventHandler(
	EventType.Timer,
	"EndNightSight",
	function()
		EndEffect()
	end
)


RegisterEventHandler(
	EventType.Message,
	"EndNightSight",
	function()
		EndEffect()
	end
)

RegisterSingleEventHandler(EventType.ModuleAttached, "sp_nightsight", HandleInit)