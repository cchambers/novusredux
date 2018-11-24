RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),function(...)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"TriggerPotion")
	--this:ScheduleTimerDelay(TimeSpan.FromSeconds(DURATION), "SizePotionTimer")
end)

RegisterEventHandler(EventType.Timer,"TriggerPotion",function(...)
	this:PlayEffect("FireHeadEffect",60)
	this:SystemMessage("Your face is on fire!","info")
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