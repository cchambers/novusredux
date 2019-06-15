this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"CheckBoss")

RegisterEventHandler(EventType.Timer,"CheckBoss",function ()
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"CheckBoss")
	local bossObject = this:GetObjVar("BossTemplate")
	local boss = FindObject(SearchTemplate(bossObject,30))
	if (boss ~= nil and not IsDead(boss) and not this:HasObjVar("locked")) then
		this:SendMessage("CloseDoor")
		this:SendMessage("Lock")
		--DebugMessage("Locking")
	elseif (((boss == nil) or (IsDead(boss))) and this:HasObjVar("locked")) then
		this:SendMessage("Unlock")
		--DebugMessage("Unlocking")
	end
end)