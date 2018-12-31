this:ScheduleTimerDelay(TimeSpan.FromSeconds(60), "StillNightTime")

RegisterEventHandler(EventType.Timer, "StillNightTime", function () 
    if (IsNightTime() and not(IsPet(this))) then
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(60), "StillNightTime")
    elseif (IsPet(this)) then
        this:DelModule("ai_lunar")
    else
        this:Destroy()
    end
end)