RegisterEventHandler(
    EventType.ModuleAttached,
    GetCurrentModule(),
    function()
        local hour = 10
        local when = DateTime.UtcNow

        this:SendMessage("StartMobileEffect", "PowerHourBuff")
        this:SetObjVar("LastPowerHour", when)
        AddBuffIcon(
            this,
            "PowerHourEffect",
            "Power Hour",
            "Ignite",
            "You are gaining skills at an increased rate.",
            false
        )
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(hour), "PowerHourTimer")
    end
)

RegisterEventHandler(
    EventType.Timer,
    "PowerHourTimer",
    function()
        RemoveBuffIcon(this, "PowerHourEffect")
        this:SystemMessage("[ff0000]Attention:[-] Your Power Hour has ended!")
        this:DelModule("powerhour")
    end
)
