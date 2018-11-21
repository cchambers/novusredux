function FindNearbyCultist()
	local nearbyCultists = FindObjects(
			SearchMulti({
				SearchModule("ai_cultist"),
				SearchMobileInRange(35),
				}))
	if (nearbyCultists == nil) then return nil end
	local cultistKeyHolder = #nearbyCultists
	for i,j in pairs(nearbyCultists) do 
		if (i == cultistKeyHolder) then return j end
	end
end

RegisterEventHandler(EventType.Timer,"CreateKey",
	function()
		local keyHolder = FindNearbyCultist()
		if (math.random(1,this:GetObjVar("LockChance") or 30) == 1 ) then
			this:DelObjVar("locked")
			return
		end
		if (keyHolder ~= nil) then
			--find a nearby cultist and give him the key
			this:SetObjVar("OneTimeKey",true)
			this:SetObjVar("keyDestinationContainer",keyHolder)
			this:AddModule("create_key")
			--small chance to stay unlocked
		end
	end)
if( this:GetSharedObjectProperty("IsLocked") ~= nil) then
	this:SetSharedObjectProperty("IsLocked",true)
end
if (initializer ~= nil) then
	this:SetObjVar("LockChance",initializer.LockChance)
	this:SendMessage("Lock")
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(5000),"CreateKey")
end
