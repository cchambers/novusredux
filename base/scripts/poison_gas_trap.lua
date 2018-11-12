RegisterEventHandler(EventType.Timer,"SpikeTic",function()
	local objects = FindObjects(SearchMulti({SearchRegion("RoomA16",true),SearchMobile()}))
	for i,obj in pairs(objects) do
		if (not obj:HasObjVar("ImmuneToTraps")) then
			obj:SendMessage("ProcessTrueDamage", this, 10)
		end
	end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"SpikeTic")
end)

RegisterEventHandler(EventType.Message,"Activate",
	function()
		this:Destroy()
	end)

this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"StartEffect")
RegisterEventHandler(EventType.Timer,"StartEffect",
	function()
		PlayEffectAtLoc("PoisonCloudEffect",this:GetLoc(),4.2)
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(4),"StartEffect")
	end)

this:FireTimer("SpikeTic",0)