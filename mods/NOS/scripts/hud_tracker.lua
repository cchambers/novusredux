function UpdateStatsWindow()
	local ds_width = 300
	local ds_height = 300
	local NOSCNX = DynamicWindow("NOSCNX" .. this.Id, "Server Stats", 300, 60, 0, -15, "Transparent", "BottomLeft")
	local online = GlobalVarRead("User.Online")
	local total = 0
	if (online ~= nil) then
		for user,y in pairs(online) do
			total = total + 1
		end
	end

	if (total < 2) then total = 2 end

	NOSCNX:AddLabel(18, 0, tostring("[bada55]" .. total .. "[-] players connected // join global chat at: [bada55]nos.gg/discord[-]"), 600, 20, 18, "left", false, true, "SpectralSC-SemiBold")
	this:OpenDynamicWindow(NOSCNX)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"Hud.UpdateStats")
end

RegisterEventHandler(EventType.Timer, "Hud.UpdateStats", function() 
	UpdateStatsWindow()
end)
RegisterSingleEventHandler(EventType.ModuleAttached, "hud_tracker", UpdateStatsWindow)