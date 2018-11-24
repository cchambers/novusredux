SHRINK_SIZE = 0.5
DURATION = 60*5

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),function(...)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"TriggerSizePotion")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(DURATION), "SizePotionTimer")
end)

RegisterEventHandler(EventType.Timer,"TriggerSizePotion",function(...)
	this:SetScale(SHRINK_SIZE*this:GetScale())
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(DURATION),"RestorePotionScale")
	this:SystemMessage("You turn into half your size!","info")
end)

function EndEffect()
	this:SystemMessage("The shrinking effect has worn off.","info")
	this:SetScale((1/SHRINK_SIZE)*this:GetScale())
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Message, "HasDiedMessage", 
	function()
		EndEffect()
	end)

RegisterEventHandler(EventType.Timer,"RestorePotionScale",function ( ... )
	EndEffect()
end)