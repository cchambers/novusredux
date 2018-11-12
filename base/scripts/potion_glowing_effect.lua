RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),function(...)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"TriggerPotion")
	--this:ScheduleTimerDelay(TimeSpan.FromSeconds(DURATION), "SizePotionTimer")
end)

RegisterEventHandler(EventType.Timer,"TriggerPotion",function(...)
	this:PlayEffect("RegenEffect",15)
	this:PlayEffect("StrangerEffect",15)
	this:SystemMessage("You begin to glow!")
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