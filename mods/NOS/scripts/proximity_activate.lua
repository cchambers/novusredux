AddView("FireInProximity",SearchMobileInRange(this:GetObjVar("Range")))

RegisterEventHandler(EventType.EnterView,"FireInProximity",
	function (mob)
	    if (this:HasTimer("ResetTimer") or this:HasObjVar("Disabled")) then return end
	    local traps = FindObjects(SearchObjVar("TrapKey",this:GetObjVar("TrapKey")),GameObj(0))
	    for i,trap in pairs(traps) do
	    	trap:SendMessage("Activate")
	    end
	    --DebugMessage(1)
	    this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("ResetTime")),"ResetTimer")
	end)