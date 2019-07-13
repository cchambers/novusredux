--Maps contain a set of waypoints that are used to generate map markers
RegisterEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
	function()		
		local displayName = ""
		displayName = SubregionDisplayNames[ServerSettings.SubregionName]
		if (displayName == nil) then
			displayName = ServerSettings.SubregionName
		end
		this:SetName("Map of "..displayName)
		this:SetObjVar("MapName", ServerSettings.SubregionName)
		this:SetObjVar("WorldMap", ServerSettings.WorldName)
		SetItemTooltip(this)
		this:DelModule(GetCurrentModule())
end)