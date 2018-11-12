DURATION = 60*5
GROWTH_SCALE = 1.5

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),function(...)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(DURATION), "SizePotionTimer")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"TriggerSizePotion")
end)

RegisterEventHandler(EventType.Timer,"TriggerSizePotion",function(...)
	this:SetScale(GROWTH_SCALE*this:GetScale())
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(DURATION),"RestorePotionScale")
	this:SystemMessage("You turn into twice your size!")
end)

function EndEffect()
	this:SystemMessage("The growing effect has worn off.")
	this:SetScale((1/GROWTH_SCALE)*this:GetScale())
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Message, "HasDiedMessage", 
	function()
		EndEffect()
	end)

RegisterEventHandler(EventType.Timer,"RestorePotionScale",function()
	EndEffect()
end)