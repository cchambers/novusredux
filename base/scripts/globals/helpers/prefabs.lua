function GetNearbyCamps(targetLoc,range)
	range = range or 30
	return FindObjects(SearchMulti({SearchRange(targetLoc, range),SearchModule("prefab_camp_controller")}),GameObj(0))
end

function GetRelativePrefabExtents(prefab, location, extents)
    extents = extents or GetPrefabExtents(prefab)
    --DebugMessage(DumpTable(bounds))
    if(extents == nil) then return nil end

    --DebugMessage(extents:Add(location):Flatten())
    return extents:Add(location):Flatten()
end

-- Checks to see if the specified bounds overlap trees, houses, or camps
function CheckBounds(relativeBounds,allowStumps)
	local boundsCenter = Loc(relativeBounds.Center)
	local nearbyHouses = GetNearbyHouses(boundsCenter,100)
	for i,houseControlObj in pairs(nearbyHouses) do
		local otherBounds = GetHouseControlPlot(houseControlObj)
		if(otherBounds ~= nil) then
			if(otherBounds:Intersects(relativeBounds)) then
				return false,"House"
			end
		end
	end

	local nearbyPrefabs = GetNearbyCamps(boundsCenter,100)
	for i,nearbyPrefab in pairs(nearbyPrefabs) do
		local prefabName = nearbyPrefab:GetObjVar("PrefabName")
		if(prefabName) then
			local otherBounds = GetRelativePrefabExtents(prefabName,nearbyPrefab:GetLoc())
			if(otherBounds ~= nil) then
				if(otherBounds:Intersects(relativeBounds)) then
					return false,"Camp"
				end
			end
		end
	end

	local searcher = PermanentObjSearchRect(relativeBounds)
	local anyPermanent = FindPermanentObjects(searcher)

	for i,objRef in pairs(anyPermanent) do
		if not(objRef:GetSharedObjectProperty("ResourceSourceId") == "Tree") then
			return false,"Permanent object"
		else
			if (not(allowStumps) or objRef:GetVisualState() == "Default") then
				return false,"Tree"
			end
		end
	end

	local noHousingRegion = GetRegion("NoHousing")
	if(noHousingRegion ~= nil and noHousingRegion:Intersects(relativeBounds)) then
		return false
	end

	local waterRegion = GetRegion("Water")
	if(waterRegion ~= nil and waterRegion:Intersects(relativeBounds)) then
		return false
	end

	return true
end