MANA_DRAIN_DURATION = 1000
DRAIN_AMOUNT = math.random(3,10)

function HandleLoaded()
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(MANA_DRAIN_DURATION), "DrainTimer")
	this:SystemMessage("[D70000]You lost "..DRAIN_AMOUNT.." mana","info")
	AdjustCurMana(this,-DRAIN_AMOUNT)
	this:DelModule("sp_mana_drain_effect")
end
HandleLoaded()