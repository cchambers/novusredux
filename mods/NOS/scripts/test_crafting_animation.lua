function HandleCraftingAnim()
	this:PlayAnimation("attack")	

	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(500),"playCraftingSound")
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(2000),"playCraftingAnim")
end

function HandleCraftingSound()
	this:PlayObjectSound("SwordImpactChainmail")
end

this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(2000),"playCraftingAnim")

RegisterEventHandler(EventType.Timer, "playCraftingAnim", HandleCraftingAnim)
RegisterEventHandler(EventType.Timer, "playCraftingSound", HandleCraftingSound)