RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),function(...)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"TriggerPotion")
	--this:ScheduleTimerDelay(TimeSpan.FromSeconds(DURATION), "SizePotionTimer")
end)

RegisterEventHandler(EventType.Timer,"TriggerPotion",function(...)
	this:PlayEffect("LightningBodyEffect",15)
	this:SystemMessage("You're looking electric!","info")
	this:NpcSpeech("*throws bottle to the ground*")
	EndEffect()
end)

function EndEffect()
	--this:SystemMessage("The shrinking effect has worn off.")
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Message, "HasDiedMessage", 
	function()
		EndEffect()
	end)

RegisterEventHandler(EventType.Timer,"EndEffect",function ( ... )
	EndEffect()
end)