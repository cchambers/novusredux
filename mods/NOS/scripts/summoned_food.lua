RegisterEventHandler(
    EventType.ModuleAttached,
    "summoned_food",
    function()
        local oldName = this:GetName()
        this:SetName("Summoned " .. oldName)
        this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(15000), "decayFood")
    end
)

RegisterEventHandler(
    EventType.Timer,
    "decayFood",
    function()
        PlayEffectAtLoc("TeleportFromEffect", this:GetLoc())
        this:Destroy()
    end
)
