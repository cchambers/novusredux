--Sends a message to the subregion map_marker_controller
RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ()
		InitMapMarkerNode()
	end)

RegisterSingleEventHandler(EventType.LoadedFromBackup,"",
	function ( ... )
		InitMapMarkerNode()
	end)

--Try to send the map marker to the map_marker_controller
RegisterEventHandler(EventType.Timer,"TrySendMapMarker",
	function ()
		if not (GetMapMarkerController():IsValid()) then
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "TrySendMapMarker")
			return
		end
		SendMapMarker()
	end)

function SendMapMarker()
	local markerController = GetMapMarkerController()
	if (markerController ~= nil) then
		markerController:SendMessage("MapMarkerCreated", this)
	end
	UnregisterEventHandler("",EventType.Timer,"TrySendMapMarker")
end

function InitMapMarkerNode()
	local tooltip = this:GetObjVar("Tooltip")
	local icon = this:GetObjVar("Icon")

	--Marker only appears when you enter a region matching this name
	local regionName = this:GetObjVar("RegionName")

	--Will always show up as long as player is in same subregion as marker controller
	local isFamiliar = this:HasObjVar("Familiar")
	local mapMarker = nil

	if (tooltip ~= nil and icon ~= nil) then

		local idHeader = "Static|"
		if (this:GetObjVar("RegionName") ~= nil) then
			idHeader = "Minimap|"
		end

		--Initialize the map marker
		mapMarker = {Icon=icon, Location=this:GetLoc(), Tooltip=tooltip, Id=idHeader..tooltip}



		--If the marker belongs to a town, make it invisible on the map
		if (regionName ~= nil) then
			mapMarker.MapVisibility=false
			mapMarker.RegionName = regionName	
		else
			--When a player approaches the marker and has not discovered the marker, they will discover it.
			AddView("MarkerNodeView", SearchPlayerInRange(30), 4.0)
			RegisterEventHandler(EventType.EnterView,"MarkerNodeView",
			function(playerObj)
				if not(HasDiscoveredStaticMapMarker(playerObj, mapMarker.Id)) then
					DiscoverMarker(playerObj, mapMarker)
				end
			end)
		end

		if (isFamiliar == true) then
			mapMarker.Familiar = true
			mapMarker.MapVisibility = true
		end

		this:SetObjVar("MapMarker", mapMarker)
	end

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "TrySendMapMarker")
end