
this:ScheduleTimerDelay(TimeSpan.FromSeconds(5), "RemoveThiefBrand")
--mMyTeam = nil

function CleanUp()
	this:DelModule("faction_thief_brand")
end

RegisterSingleEventHandler(EventType.ModuleAttached, "faction_thief_brand", 
	function()
		--mMyTeam = this:GetObjVar("MobileTeamType")
		this:SetObjVar("MobileTeamType", "Mercenary Thief")
		--this:AddModule("incl_PvPPlayer")
	    this:SendMessage("UpdateName")
	    this:SystemMessage("[$1808]","event") 
	end)

RegisterEventHandler(EventType.Timer, "RemoveThiefBrand", 
	function()
		this:SystemMessage("[F7CC0A] You are no longer in mercenary status.[-]", "event")
		this:DelObjVar("MobileTeamType")
		this:SendMessage("UpdateName")
		CleanUp()
	end)

RegisterEventHandler(EventType.Message, "faction_thief_duration_update", 
	function(time)		
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(time), "RemoveThiefBrand")
	end)