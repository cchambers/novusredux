function regen() 
    this:SetStatValue("Health", GetMaxHealth(this))
    this:SetStatValue("Mana", 250)
    this:SetStatValue("Stamina", 250)
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "Immortal.Regen")
end

RegisterEventHandler(EventType.Timer, "Immortal.Regen", regen)

regen()