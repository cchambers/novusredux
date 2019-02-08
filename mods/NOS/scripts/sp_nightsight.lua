require 'incl_gametime'

function HandleInit() 
	this:SendClientMessage("TimeUpdate", {5000, 10000, 0})
	this:SystemMessage("The sun rises... but only for you.", "info")
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(10), "EndNightSight")
end

function EndEffect()
	this:SendClientMessage("TimeUpdate", {GetCurrentTimeOfDay(), GetDaylightDurationSecs(), GetNighttimeDurationSecs()})
	this:SystemMessage("Night Sight has worn off.", "info")
	this:DelModule("sp_nightsight")
end

RegisterEventHandler(
	EventType.Timer,
	"EndNightSight",
	EndEffect
)


RegisterSingleEventHandler(EventType.ModuleAttached, "sp_nightsight", HandleInit)