
this:ScheduleTimerDelay(TimeSpan.FromSeconds(5), "RemoveTraitorBrand")
mMyTeam = nil

function CleanUp()
	this:DelModule("faction_traitor_brand")
end

RegisterSingleEventHandler(EventType.ModuleAttached, "faction_traitor_brand", 
	function()
		mMyTeam = this:GetObjVar("MobileTeamType")
		this:SetObjVar("MobileTeamType", mMyTeam .. " Traitor")
		--this:AddModule("incl_PvPPlayer")
	    this:SendMessage("UpdateName")
	    this:SystemMessage("[$1809]","event") 
	end)
RegisterEventHandler(EventType.Timer, "RemoveTraitorBrand", 
	function()	
		this:SystemMessage("[F7CC0A] You are no longer in traitor status.[-]", "event")
		this:SetObjVar("MobileTeamType", mMyTeam)
		this:SendMessage("UpdateName")
		CleanUp()
	end)
RegisterEventHandler(EventType.Message, "traitor_duration_update", 
	function(time)		
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(time), "RemoveTraitorBrand")
	end)