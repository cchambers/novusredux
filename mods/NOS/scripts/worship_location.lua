SERMON_TIME = 60*5
TIME_TO_NEXT_SERMON = TimeSpan.FromMinutes(7)

function StartSermon(lengthInSecs)
	--DebugMessage("Starting Sermon")
	this:SetObjVar("ObjectOfWorship",true)
	local nearbyAdherants = FindObjects(SearchModule(this:GetObjVar("WorshiperModule")))
	--ring the church bells
	for i,j in pairs(nearbyAdherants) do
		j:SendMessage("GoPrayMessage",this)
	end
	priestModule = this:GetObjVar("PriestModule")
	local priest = FindObject(SearchModule(priestModule))
	if (priest ~= nil) then
		priest:SendMessage("StartSermon",this)
	end
	--DebugMessage("priest is "..tostring(priest))
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(SERMON_TIME),"EndSermon")

end
RegisterEventHandler(EventType.Timer,"StartSermon",StartSermon)
RegisterEventHandler(EventType.Message,"StartSermon",StartSermon)
this:ScheduleTimerDelay(TIME_TO_NEXT_SERMON,"StartSermon")


RegisterEventHandler(EventType.Timer,"EndSermon",function()
	this:DelObjVar("ObjectOfWorship")
	--DebugMessage("Ending Sermon")
	local nearbyAdherants = FindObjects(SearchModule(this:GetObjVar("WorshiperModule")))
	--ring the church bells
	for i,j in pairs(nearbyAdherants) do
		j:SendMessage("EndPrayMessage",this)
	end
	this:ScheduleTimerDelay(TIME_TO_NEXT_SERMON,"StartSermon")
end)

