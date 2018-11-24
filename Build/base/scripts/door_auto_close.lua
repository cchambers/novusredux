

RegisterEventHandler(EventType.Timer, "AutoClose", function()
    Door.Close(this)
    this:DelModule("door_auto_close")
end)

RegisterEventHandler(EventType.Message, "AutoClose", function()
    this:ScheduleTimerDelay(Door.AutoCloseDelay, "AutoClose")
end)