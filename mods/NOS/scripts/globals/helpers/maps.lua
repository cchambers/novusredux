-- this function can change the map name based on conditions in the map
-- specifically: the current catacombs map is based on the dungeon configuration
customMapFunctions = {
    Catacombs = function ()
        -- DAB TODO: make it possible to get catacombs map
        return nil
    end,

    NewCelador = function (isZoomed)
        --[[
        if (isZoomed) then
            local subregionName = ServerSettings.SubregionName
            if(subregionName:match("SewerDungeon")) then
                return nil
            elseif(subregionName) then
                return subregionName
            end
        end
        ]]--

        return "NewCelador"
    end,

    Ruin = function(playerObj)
        if(IsImmortal(playerObj)) then
            --return "CatacombsConfig1"
        end
        return nil
    end,

    Deception = function (playerObj)
        if(IsImmortal(playerObj)) then
            --return "CatacombsConfig3"
        end
        return nil
    end,

    Contempt = function(playerObj)
        if(IsImmortal(playerObj)) then
            --return "CatacombsConfig4"
        end
        return nil
    end,

    TestMap = function()
        return nil
    end,

    Corruption = function ()
        return nil
    end,
}

function CanMergeWaypoints(atlasObj, mapObj)
    if (GetWaypointCount(atlasObj) + GetWaypointCount(mapObj) >= GetMaxWaypoints(atlasObj)) then
        return false
    end
    return true
end

--Returns a table of un-nested waypoints
function GetWaypoints(mapObj)
    local worldName = mapObj:GetObjVar("WorldMap")

    local waypoints = mapObj:GetObjVar("UserWaypoints")
    if(waypoints and waypoints[worldName]) then
        waypointTable = {}
        for i, subregionWaypoints in pairs(waypoints[worldName]) do
            for i, subregionWaypoint in pairs(subregionWaypoints) do
                table.insert(waypointTable,subregionWaypoint)
            end
        end
        return waypointTable
    end
    return nil
end

function GetWaypointCount(mapObj)
    if (mapObj == nil) then return 0 end

    local waypointTable = GetWaypoints(mapObj)
    if (waypointTable) then
        return #waypointTable
    end

    return 0
end

function GetMaxWaypoints(mapObj)
    local mapType = mapObj:GetObjVar("ResourceType")

    if (mapType == "MapAtlas") then
        return ServerSettings.Misc.MaxAtlasWaypoints
    end
    return ServerSettings.Misc.MaxMapWaypoints
end

function CanAddSubMap (user, atlasObj, mapObj)
    local subMapName = mapObj:GetObjVar("MapName")
    local subMaps = atlasObj:GetObjVar("SubMaps") or {}
    local invalidMessage = ""
    for i, j in pairs(subMaps) do 
        if (subMapName == j) then
            invalidMessage = "Atlas already contains map."
        end
    end

    local mapWaypoints = mapObj:GetObjVar("UserWaypoints")
    local atlasWaypoints = atlasObj:GetObjVar("UserWaypoints")

    if (atlasWaypoints == nil) then 
        atlasWaypoints = {} 
    end

    if (mapWaypoints ~= nil) then
        if (#mapWaypoints + #atlasWaypoints > 10) then
            invalidMessage = "Not enough empty waypoints available to merge."
        end
    end

    if (invalidMessage ~= "") then
        user:SystemMessage(invalidMessage, "info")
        return false
    end
    return true
end

function AddSubMap(user, atlasObj, mapObj)
    if not (CanAddSubMap(user, atlasObj, mapObj)) then return end
    local subMapName = mapObj:GetObjVar("MapName") or ServerSettings.SubregionName

    
    if (AddWaypoints(user, atlasObj, mapObj)) then
        local subMaps = atlasObj:GetObjVar("SubMaps") or {}
        table.insert(subMaps, subMapName)
        atlasObj:SetObjVar("SubMaps",subMaps)
        mapObj:Destroy()
        local subMapDisplayName = SubregionDisplayNames[subMapName]
        if not(subMapDisplayName) then
            subMapDisplayName = subMapName
        end
        user:SystemMessage("Added a map of "..subMapDisplayName.." to the atlas.","info")
    end
end

function AddSubMapByName(targetObj, subMapName)
    local worldName = ServerSettings.WorldName
    if (customMapFunctions[worldName]() == nil) then return end
    if (subMapName == worldName) then return end

    local subMaps = targetObj:GetObjVar("SubMaps") or {}
    local newSubMaps = {}
    local hasSubMap = false
    for i, j in pairs(subMaps) do
        if (j ~= subMapName) then
            table.insert(newSubMaps, j)
        end
    end
    table.insert(newSubMaps, subMapName)
    targetObj:SetObjVar("SubMaps", newSubMaps)
end

function DoesWaypointExist(atlasObj, waypoint)
    local waypointTable = GetWaypoints(atlasObj)
    if (waypointTable == nil) then return false end
    for i, j in pairs(waypointTable) do
        if (j.Location == waypoint.Location and j.Tooltip == waypoint.Tooltip) then return true end
    end
    return false
end

function AddWaypoints(user, atlasObj, mapObj)
    local mapWaypoints = mapObj:GetObjVar("UserWaypoints")
    local atlasWaypoints = atlasObj:GetObjVar("UserWaypoints")
    local worldMapName = atlasObj:GetObjVar("WorldMap") or ServerSettings.WorldName
    local subMapName = mapObj:GetObjVar("MapName")

    if (mapObj:GetObjVar("WorldMap") ~= worldMapName) then
        user:SystemMessage("Cannot add waypoints to this atlas.","info")
        return false
    end

    if not (CanMergeWaypoints(atlasObj, mapObj)) then
        user:SystemMessage("Cannot add more waypoints to atlas.","info")
        return false
    end

    if (mapWaypoints == nil) then return true end
    if (subMapName == nil ) then return true end

    if (atlasWaypoints == nil) then
        atlasWaypoints = {}
    end

    -- get world table
    local worldName = worldMapName
    if not(atlasWaypoints[worldName]) then
        atlasWaypoints[worldName] = {}
    end

    -- get subregion table (if necesary)
    if(subMapName and subMapName ~= "") then
        if not(atlasWaypoints[worldName][subMapName]) then
            atlasWaypoints[worldName][subMapName] = {}
        end
        for i, j in pairs(mapWaypoints[worldName][subMapName]) do
            if not (DoesWaypointExist(atlasObj, j)) then
                if (subMapName ~= worldName) then
                    table.insert(atlasWaypoints[worldName][subMapName], j)
                else
                    table.insert(atlasWaypoints[worldName], j)
                end
            end
        end
    end
    atlasObj:SetObjVar("UserWaypoints", atlasWaypoints)
    UpdateMapTooltip(atlasObj)
    return true
end


function RenameMap(user,mapObj)
    local mapType = mapObj:GetObjVar("ResourceType")
    local prefixString = "Map - "
    if (mapType == "MapAtlas") then
        prefixString = "Atlas - "
    end

    TextFieldDialog.Show
    {
        TargetUser = user,
        ResponseObj = user,
        DialogId = "RenameMap",
        Title = "Name Map",
        Description = "Maximum 20 characters",
        ResponseFunc = function(user,newName)
            if( not(newName) or newName == "") then return false end
            if (HasBadWords(newName)) then return false end
            if (#newName <= 20) then
                mapObj:SetName(prefixString..newName)
            end
        end
    }
end

function RenameRune(user, runeObj)
    TextFieldDialog.Show
    {
        TargetUser = user,
        ResponseObj = user,
        DialogId = "RenameRune",
        Title = "Name Rune",
        Description = "Maximum 20 characters",
        ResponseFunc = function(user,newName)
            if( not(newName) or newName == "") then return false end
            if (HasBadWords(newName)) then return false end
            if (#newName <= 20) then
                runeObj:SetName(newName)
            end
        end
    }
end

function UpdateMapTooltip(mapObj)
    SetTooltipEntry(mapObj, "waypointCount", "Waypoints: "..GetWaypointCount(mapObj).."/"..GetMaxWaypoints(mapObj))
end

--Get the un-nested MapMarker table for the current subregion
function GetSubregionMapMarkers(user, subregion)
    local mapMarkers = user:GetObjVar("DiscoveredMarkers") or {}
    local worldName = ServerSettings.WorldName

    if (mapMarkers[worldName] == nil) then
        mapMarkers[worldName] = {}
    end
    if (mapMarkers[worldName][subregion] == nil) then
        mapMarkers[worldName][subregion] = {}
        user:SetObjVar("DiscoveredMarkers", mapMarkers)
    end
    return mapMarkers[worldName][subregion]
end

--Inserts starting map markers into a nested marker table
function AddStartingMapMarkers(markers)
    local newTable = markers

    for worldKey, subRegTable in pairs(StartingMapMarkers) do
        if (newTable[worldKey] == nil) then
            newTable[worldKey] = {}
        end
        for subRegKey, markerTable in pairs(subRegTable) do
            if (newTable[worldKey][subRegKey] == nil) then
                newTable[worldKey][subRegKey] = {}
            end
            if (subRegKey ~= ServerSettings.SubregionName) then
                for markerIndex, marker in pairs(markerTable) do
                    table.insert(newTable[worldKey][subRegKey], marker)      
                end
            end
        end
    end
    return newTable
end

--Adds a dynamic map marker that shows up on the minimap
function AddDynamicMapMarker(user,mapMarker,id)
    if (user == nil or (not user:IsValid()) or (not user:IsPlayer())) then return end
    if (id == nil) then DebugMessage("Map marker requires id.") return end
    if (customMapFunctions[ServerSettings.WorldName] == nil) then return end

    local mapMarkers = user:GetObjVar("MapMarkers") or {}
    local newMarkers = {}

    for index, marker in pairs(mapMarkers) do
        if (marker.Id ~= id) then
            table.insert(newMarkers, marker)
        end
    end
    mapMarker["Id"] = id
    table.insert(newMarkers, mapMarker)
    user:SetObjVar("MapMarkers", newMarkers)
end

--Rebuilds the MapMarker table excluding matching id
function RemoveDynamicMapMarker(user,id)
    local mapMarkers = user:GetObjVar("MapMarkers") or {}
    local newMarkers = {}

    for index, marker in pairs(mapMarkers) do
        if (marker.Id ~= id) then
            table.insert(newMarkers, marker)
        end
    end

    user:SetObjVar("MapMarkers", newMarkers)
end

--Grabs the first instance of map_marker_controller
local mapMarkerController = nil
function GetMapMarkerController()
    if (mapMarkerController == nil or mapMarkerController:IsValid() == false) then
        mapMarkerController = FindObjectWithTag("MapMarkerController")
    end
    return mapMarkerController
end

function GetControllerMapMarkers()
    local controller = GetMapMarkerController()
    if (controller ~= nil) then
        return controller:GetObjVar("StaticMapMarkers") 
    end
    return {}
end

--Get's a map marker of a matching Id from the map_marker_controller
function GetControllerMapMarker(markerId)
    local mapMarkers = GetControllerMapMarkers()
    for markerIndex, marker in pairs(mapMarkers) do
        if (marker.Id == markerId) then
            return marker
        end
    end
end

function GetControllerRegionMarkers(regionName)
    local mapMarkers = GetControllerMapMarkers()
    local regionMarkers = GetMapMarkerController():GetObjVar("RegionMarkers")

    for curRegionName, markerIdTable in pairs(regionMarkers) do
        if (regionName == curRegionName) then
            return markerIdTable
        end
    end
end

function GetControllerFamiliarMarkers()
    return GetMapMarkerController():GetObjVar("FamiliarMarkers") or {}
end

function GetControllerRegions()
    local mapMarkers = GetControllerMapMarkers()
    local regionMarkers = GetMapMarkerController():GetObjVar("RegionMarkers") or {}

    local regionNames = {}
    for regionName, markerIdTable in pairs(regionMarkers) do
        table.insert(regionNames, regionName)
    end
    return regionNames
end

--If this marker exists in the map_marker_controller
function IsDiscoverableMarker(markerId)
    local controllerMarkers = GetControllerMapMarkers()
    for index, id in pairs(controllerMarkers) do
        if (markerId == id) then
            return true
        end
    end
    return false
end

--Adds a marker to the list of discovered markers, and notifies the player they discovered a marker.
function DiscoverMarker(user, markerData)
    if (IsDead(user)) then return end
    if (IsDiscoverableMarker(markerId)) then return end

    local newMarkers = {}

    local markers = GetSubregionMapMarkers(user, ServerSettings.SubregionName)
    for markerKey, marker in pairs(markers) do
        if (marker ~= markerData.Id) then
            newMarkers[marker.Id] = marker
            --table.insert(newMarkers, marker)
        end
    end

    newMarkers[markerData.Id] = markerData
    --table.insert(newMarkers, markerData)
    local discoveredMarkers = user:GetObjVar("DiscoveredMarkers") or {}
    discoveredMarkers[ServerSettings.WorldName][ServerSettings.SubregionName] = newMarkers
    user:SetObjVar("DiscoveredMarkers", discoveredMarkers)

    local displayName = markerData.Tooltip or markerData.Id

    user:SystemMessage("You have discovered "..displayName, "info")
    user:PlayEffect("HealEffect")
    user:PlayObjectSound("event:/ui/quest_complete",false)
end

--Checks if a static map marker has already been discovered
function HasDiscoveredStaticMapMarker(user,id)
    if (user == nil or (not user:IsValid()) or (not user:IsPlayer())) then return nil end
    local mapMarkers = user:GetObjVar("DiscoveredMarkers") or {}

    local worldName = ServerSettings.WorldName
    local subregionName = ServerSettings.SubregionName

    if (mapMarkers[worldName] == nil) then return false end
    if (mapMarkers[worldName][subregionName] == nil) then return false end
    if (mapMarkers[worldName][subregionName][id] == nil) then return false end

    return true
end

--Checks if a dynamic map marker has been added to a player
function HasDynamicMapMarker(user,id)
    if (user == nil or (not user:IsValid()) or (not user:IsPlayer())) then return nil end
    local mapMarkers = user:GetObjVar("MapMarkers") or {}

    for markerIndex, marker in pairs(mapMarkers) do
        if (marker.Id == id) then
            return true
        end
    end

    return false
end

--Returns a nested list of valid map markers.
function GetDiscoveredMapMarkers(user)
    local controllerMarkers = GetControllerMapMarkers()
    local discoveredMarkers = user:GetObjVar("DiscoveredMarkers") or {}

    local validMarkers = {}

    local worldName = ServerSettings.WorldName
    local subregionName = ServerSettings.SubregionName

    for worldKey, subRegTable in pairs(discoveredMarkers) do
        validMarkers[worldKey] = {}
        for subRegKey, markerTable in pairs(subRegTable) do
            validMarkers[worldKey][subRegKey] = {}

            --For the current subregion, verify markers with map_marker_controller
            if (worldKey == worldName and subRegKey == subregionName) then
                for markerKey, marker in pairs(markerTable) do
                    if (controllerMarkers[markerKey] ~= nil) then
                        if (controllerMarkers[markerKey].RegionName == nil) then
                            validMarkers[worldKey][subRegKey][markerKey] = controllerMarkers[markerKey]
                        end
                    end
                end
            --Otherwise, assume marker is valid and add it
            else
                for markerKey, marker in pairs(markerTable) do
                    validMarkers[worldKey][subRegKey][marker.Id] = marker
                end
            end
        end
    end
    return validMarkers
end

--If marker doesn't exist in current map_marker_controller, remove it from the list
function CleanUpDiscoveredMapMarkers(user)
    if (customMapFunctions[worldName] == nil or customMapFunctions[worldName]() == nil) then return end

    local worldName = ServerSettings.WorldName
    local subregionName = ServerSettings.SubregionName
    if (discoveredMarkers[worldName] ==nil) then discoveredMarkers[worldName] = {} end
    if (discoveredMarkers[worldName][subregionName] == nil) then discoveredMarkers[worldName][subregionName] = {} end

    local controllerMarkers = GetControllerMapMarkers()
    local discoveredMarkers = user:GetObjVar("DiscoveredMarkers") or {}
    local newMarkers = {}

    for markerKey, marker in pairs(discoveredMarkers[worldName][subregionName]) do
        if (controllerMarkers[markerKey] == nil) then
            discoveredMarkers[markerKey] = nil
        end
    end
    user:SetObjVar("DiscoveredMarkers", discoveredMarkers)
end

--Used for /createMapMarker
function CreateMapMarker(loc, tooltip, icon)
    if (loc == nil or tooltip == nil) then return end

    if (icon == nil or icon == "") then
        icon = "marker_circle1"
    end

    RegisterSingleEventHandler(EventType.CreatedObject, "mapMarkerCreated", 
    function(success, objRef)
        local mapMarker = {Icon=icon, Location=loc, Tooltip=tooltip, Id = "Static|"..tooltip}
        objRef:SetObjVar("MapMarker", mapMarker)
    end)

    CreateObj("map_marker_node", loc, "mapMarkerCreated")
end

--Requests map markers from the cluster controller in each active subregion
function RequestAllMapMarkers(user)
    user:DelObjVar("GodMarkers")
    for regionName, regionInfo in pairs(GetClusterRegions()) do
        if (regionName ~= ServerSettings.RegionAddress) then
            MessageRemoteClusterController(regionName, "MapMarkerRequest", user)
        else
            local mapMarkers = GetControllerMapMarkers()
            if (mapMarkers ~= nil) then
                ClusterControllerMapMarkerResponse(user, ServerSettings.WorldName, ServerSettings.SubregionName, mapMarkers)
            end
        end
    end
end

--The response to RequestAllMapMarkers, sent from the cluster controller
function ClusterControllerMapMarkerResponse(user, worldName, subregionName, mapMarkers)
    local discoveredMarkers = user:GetObjVar("GodMarkers") or {}

    for markerIndex, marker in pairs(mapMarkers) do

        local canAdd = true
        if (marker.RegionName ~= nil or marker.Familiar ~= nil) then
            canAdd = false
        end

        if (canAdd) then
            if (discoveredMarkers[worldName] == nil) then
                discoveredMarkers[worldName] = {}
            end
            if (discoveredMarkers[worldName][subregionName] == nil) then
                discoveredMarkers[worldName][subregionName] = {}
            end
            table.insert(discoveredMarkers[worldName][subregionName], marker)   
        end
    end

    user:SetObjVar("GodMarkers", discoveredMarkers)
end