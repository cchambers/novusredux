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
    local subMapName = mapObj:GetObjVar("MapName") or GetSubregionName()

    
    if (AddWaypoints(user, atlasObj, mapObj)) then
        local subMaps = atlasObj:GetObjVar("SubMaps") or {}
        table.insert(subMaps, subMapName)
        atlasObj:SetObjVar("SubMaps",subMaps)
        mapObj:Destroy()
        local subMapDisplayName = SubregionDisplayNames[subMapName]
        if not(subMapDisplayName) then
            subMapDisplayName = subMapName
        end
        user:SystemMessage("Added a map of "..subMapDisplayName.." to the atlas.")
    end
--[[
    local tooltipString = "Maps included: "
    for i, j in pairs(subMaps) do
        tooltipString = tooltipString.."\n"..j
    end
    SetTooltipEntry(atlasObj, "mapTooltip" ,tooltipString)
]]--
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
    local worldMapName = atlasObj:GetObjVar("WorldMap")
    local subMapName = mapObj:GetObjVar("MapName")

    if (mapObj:GetObjVar("WorldMap") ~= worldMapName) then
        user:SystemMessage("Cannot add waypoints to this atlas.")
        return false
    end

    if not (CanMergeWaypoints(atlasObj, mapObj)) then
        user:SystemMessage("Cannot add more waypoints to atlas.")
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