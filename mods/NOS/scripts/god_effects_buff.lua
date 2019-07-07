RegisterEventHandler(EventType.ModuleAttached,"god_effects_buff",function()
	if (this:IsPlayer() and not IsImmortal(this)) then return end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"redo_god_effects")
    SetMobileMod(this, "AttackSpeedTimes", "GodBuffs", 0.3)
    SetMobileMod(this, "AttackTimes", "GodBuffs", 25)
	this:SetColor("0xFFFFFF00")
	this:PlayEffectWithArgs("ObjectGlowEffect",3.0,"Color=0xFFFFFF00")
end)

RegisterEventHandler(EventType.Timer,"redo_god_effects",function()
	this:PlayEffectWithArgs("ObjectGlowEffect",3.0,"Color=0xFFFFFF00")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"redo_god_effects")
end)
