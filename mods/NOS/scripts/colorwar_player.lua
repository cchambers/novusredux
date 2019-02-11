function ColorWarTick()
	local points = this:GetObjVar("ColorWarPoints") or 0
	points = points + 1
	this:SetObjVar("ColorWarPoints", points)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(1), "ColorWar.Tick")
end

RegisterSingleEventHandler(
	EventType.ModuleAttached,
	GetCurrentModule(),
	function()
		this:SetObjVar("ColorWarPlayer", true)
		this:SetObjVar("ColorWarPoints", 0)
		this:ScheduleTimerDelay(TimeSpan.FromMinutes(1), "ColorWar.Tick")
	end
)

RegisterEventHandler(EventType.Timer, "ColorWar.Tick", ColorWarTick)
