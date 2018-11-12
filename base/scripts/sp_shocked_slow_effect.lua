SHOCK_SLOW_DURATION = 3500
SHOCKED_SLOW_MODIFIER = .5

function HandleShockedSlowLoaded()
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(SHOCK_SLOW_DURATION), "ShockSlowTimer")
	AddBuffIcon(this,"Shocked","Shocked","Lightning Dagger","Slowed due to electrical attack.",true,SHOCK_SLOW_DURATION/1000)
	--this:SendMessage("AddMoveSpeedEffectMessage", "sp_shocked_slow_effect", "Multiplier", SHOCKED_SLOW_MODIFIER)
end

function EndSlowEffect()
	--this:SendMessage("RemoveMoveSpeedEffectMessage", "sp_shocked_slow_effect")
	this:RemoveTimer("ShockSlowTimer")
	this:DelModule("sp_shocked_slow_effect")
end

RegisterEventHandler(EventType.Message, "ClearMoveSpeedEffects", 
	function()
		EndSlowEffect()
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, "sp_shocked_slow_effect", 
	function ()
		HandleShockedSlowLoaded()
	end)

RegisterEventHandler(EventType.Timer, "ShockSlowTimer", 
	function()
		EndSlowEffect()
	end)

RegisterEventHandler(EventType.Message, "HasDiedMessage", 
	function()
		EndSlowEffect()
	end)

RegisterEventHandler(EventType.Message,"CritEffectsp_shocked_slow_effect", 
	function ()
		HandleShockedSlowLoaded()
	end)
