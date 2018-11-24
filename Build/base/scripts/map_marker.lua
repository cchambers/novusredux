--Adds a view that sends a message to nearby players and adds a map marker
RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ()
		AddView("NearbyPlayers", SearchPlayerInRange(30), 3)
	end)

RegisterEventHandler(EventType.EnterView,"NearbyPlayers",
function(playerObj)
	local tooltipName = this:GetObjVar("TooltipName")
	if (tooltipName ~= nil) then
		playerObj:SendMessage("DiscoveredLocation", tooltipName)
	end
end)