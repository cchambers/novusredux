
this:ScheduleTimerDelay(TimeSpan.FromSeconds(300), "NoEquipTimer")


function HandleNoEquipRemove()
	this:DelModule("temporary_no_equip_item")
end

RegisterEventHandler(EventType.Timer, "NoEquipTimer" , HandleNoEquipRemove)