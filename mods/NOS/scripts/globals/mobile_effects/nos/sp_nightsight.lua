require 'incl_gametime'

this:SystemMessage("Okay")
function HandleModuleLoaded() 
	this:SendClientMessage("TimeUpdate", {"12:00", GetDaylightDurationSecs(), GetNighttimeDurationSecs()})
	this:SystemMessage("You can now see in the dark.", "info")
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

this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "EndNightSight")

RegisterSingleEventHandler(EventType.ModuleAttached, "sp_nightsight", HandleModuleLoaded)