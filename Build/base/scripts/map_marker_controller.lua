--Contains a list of static map markers that can be discovered by the player

this:SetObjectTag("MapMarkerController")
this:DelObjVar("StaticMapMarkers")

--Markers that will be seen from anywhere in the subregion

RegisterEventHandler(EventType.Message, "MapMarkerCreated",
	function(markerObj)
		local staticMapMarkers = this:GetObjVar("StaticMapMarkers") or {}
		local marker = markerObj:GetObjVar("MapMarker")
		staticMapMarkers[marker.Id] = marker
		this:SetObjVar("StaticMapMarkers", staticMapMarkers)

		--Markers with TownName are placed into a special table that get's used when a player enters a town's region
		--Town markers only show on the minimap, and cannot be discovered
		if (marker.RegionName ~= nil) then
			local regionName = marker.RegionName
			local regionMarkers = this:GetObjVar("RegionMarkers") or {}
			if (regionMarkers[regionName] == nil) then regionMarkers[regionName] = {} end

			local markerExists = false
			for i, j in pairs(regionMarkers[regionName]) do
				if (j.Id == marker.Id) then
					regionMarkers[regionName][i] = marker
					markerExists = true
				end
			end

			if not (markerExists) then
				table.insert(regionMarkers[regionName], marker)
			end

			this:SetObjVar("RegionMarkers", regionMarkers)
		end
		
		if (marker.Familiar ~= nil) then
			local familiarMarkers = this:GetObjVar("FamiliarMarkers") or {}

			local markerExists = false
			for i, j in pairs(familiarMarkers) do
				if (j.Id == marker.Id) then
					familiarMarkers[i] = marker
					markerExists = true
				end
			end

			if not (markerExists) then
				table.insert(familiarMarkers, marker)
			end

			this:SetObjVar("FamiliarMarkers", familiarMarkers)
		end
	end)