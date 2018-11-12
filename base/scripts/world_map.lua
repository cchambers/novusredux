--Maps contain a set of waypoints that are used to generate map markers
RegisterEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
	function()		
		local displayName = ""
		displayName = SubregionDisplayNames[GetSubregionName()]
		if (displayName == nil) then
			displayName = GetSubregionName()
		end
		this:SetName("Map of "..displayName)
		this:SetObjVar("MapName", GetSubregionName())
		this:SetObjVar("WorldMap", GetWorldName())
		SetItemTooltip(this)
		this:DelModule(GetCurrentModule())
end)