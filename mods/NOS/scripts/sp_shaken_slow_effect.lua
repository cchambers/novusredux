SHAKEN_SLOW_DURATION = 2200
SHAKEN_SLOW_MODIFIER = .8

function HandleShakenSlowLoaded()
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(SHAKEN_SLOW_DURATION), "ShakenSlowTimer")
	AddBuffIcon(this,"Shaken","Shaken","shockwave","Slowed due to being shaken.",true,SHAKEN_SLOW_DURATION/1000)
	--this:SendMessage("AddMoveSpeedEffectMessage", "sp_shaken_slow_effect", "Multiplier", SHAKEN_SLOW_MODIFIER)
end

function EndSlowEffect()
	--this:SendMessage("RemoveMoveSpeedEffectMessage", "sp_shaken_slow_effect")
	this:RemoveTimer("ShakenSlowTimer")
	this:FireTimer("ShakenRemoveTimer")
	end

RegisterEventHandler(EventType.Timer, "ShakenRemoveTimer",
	function()
			this:DelModule("sp_shaken_slow_effect")
		end)
RegisterEventHandler(EventType.Message, "ClearMoveSpeedEffects", 
	function()
		EndSlowEffect()
	end)

RegisterEventHandler(EventType.Timer, "ShakenSlowTimer", 
	function()
		EndSlowEffect()
	end)

RegisterEventHandler(EventType.Message, "HasDiedMessage", 
	function()
		EndSlowEffect()
	end)

RegisterEventHandler(EventType.Message,"CritEffectsp_shaken_slow_effect", 
	function ()
		if(not this:HasTimer("ShakenSlowTimer") and not this:HasTimer("ShakenRemoveTimer")) then
			HandleShakenSlowLoaded()
		end
	end)
