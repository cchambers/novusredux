function UpdateStatsWindow()
	local ds_width = 300
	local ds_height = 300
	local NOSCNX = DynamicWindow("NOSCNX" .. this.Id, "Server Stats", 300, 60, 0, -15, "Transparent", "BottomLeft")
	local online = GlobalVarRead("User.Online")
	local total = 0
	for user,y in pairs(online) do
		total = total + 1
	end

	if (total < 2) then total = 2 end

	NOSCNX:AddLabel(15, 0, tostring(total .. " PLAYERS CONNECTED // JOIN US AT NOS.GG/DISCORD"), 600, 20, 16, "left", false, true, "SpectralSC-SemiBold")
	this:OpenDynamicWindow(NOSCNX)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"Hud.UpdateStats")
end

RegisterEventHandler(EventType.Timer, "Hud.UpdateStats", function() 
	UpdateStatsWindow()
end)
RegisterSingleEventHandler(EventType.ModuleAttached, "hud_tracker", UpdateStatsWindow)