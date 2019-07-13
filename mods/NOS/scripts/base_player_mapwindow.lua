mapWindowOpen = false
curMap = nil
disableDynamicMarkers = false


isZoomed = true
CanZoom = (ServerSettings.WorldName == "NewCelador")

waypointIcons = { "marker_circle1", "marker_circle2", "marker_diamond1", "marker_diamond2", "marker_diamond3", "marker_diamond4", "marker_diamond5", "location_corpse", "location_home","pentagram_marker" }

customMapMarkerFunctions = {
	NewCelador = function(mapIcons)
		local catacombsPortal = FindObjectWithTag("CatacombsPortalController")		
		if(catacombsPortal) then
			if(catacombsPortal:HasObjVar("CatacombsPortalActive")) then
				table.insert(mapIcons,{Icon="pentagram_marker", Location=catacombsPortal:GetLoc(), Tooltip="The portal to Catacombs has been opened."})
			end
		end
	end,

	TestMap = function()
		return nil
	end,	
}

function GetCurrentWorldMapName()
	local activeMap = this:GetObjVar("ActiveMap")
	local worldName = nil
	if (activeMap) then
		worldName = activeMap:GetObjVar("WorldMap")
	else
		if (customMapFunctions[ServerSettings.WorldName] ~= nil) then
			worldName = customMapFunctions[ServerSettings.WorldName](this)
		end
	end
	return worldName
end

function GetMapMarkers()
	local mapIcons = {}
	local mapName = GetCurrentWorldMapName()

	if (disableDynamicMarkers) then 
		return mapIcons 
	end

	local plots = Plot.GetPlayerPlots(this)
	for i,plotController in pairs(plots) do	
		if(plotController ~= nil and plotController:IsValid()) then
			table.insert(mapIcons,{Icon="location_home", Location=plotController:GetLoc(), Tooltip="Home"})
			--AddDynamicMapMarker(this, {Icon="location_home", Location=userHouse:GetLoc(), Tooltip="Home"}, "Home")
		end
	end

	--Markers for group members
	local groupId = GetGroupId(this)
	local numberOfGroupMembers = 0
	if ( groupId ~= nil ) then
		local members = GetGroupVar(groupId, "Members")
		if ( members ~= nil ) then
			local loc = this:GetLoc()
			local range = ServerSettings.Group.MinimapRange
			for i=1,#members do
				local member = members[i]
				if ( member ~= this and member:IsValid() ) then
					local mloc = member:GetLoc()
					if ( loc:Distance(mloc) <= range ) then
						local name = StripColorFromString(member:GetName())
						table.insert(mapIcons,{Icon="marker_diamond2",Tooltip=name,Location=mloc,MapVisibility=false})
						--AddDynamicMapMarker(this, {Icon="marker_diamond2",Tooltip=name,Location=mloc}, name, "Group")
						numberOfGroupMembers = numberOfGroupMembers + 1
					end
				end
			end
		end
	end
	
	--Marker for resurrection shrines
	local karmaLevel = GetKarmaLevel(GetKarma(this))
	if (IsDead(this)) then
		local shrines = nil

		if (karmaLevel.Name == "Outcast") then
			shrines = FindObjectsWithTag("Shrine_Red")
		else
			shrines = FindObjectsWithTag("Shrine")
		end

		if (shrines) then
			local closestShrine = nil
			local closestDist = 99999

			for i, shrine in pairs(shrines) do
				local dist = this:DistanceFrom(shrine)
				if(not(closestShrine) or dist < closestDist) then
					closestDist = dist
					closestShrine = shrine
				end				
			end

			if(closestShrine) then
				table.insert(mapIcons,{Icon="marker_diamond5", Location=closestShrine:GetLoc(), Tooltip="Resurrection Shrine"})
				--AddDynamicMapMarker(this, {Icon="marker_diamond5", Location=closestShrine:GetLoc(), Tooltip="Resurrection Shrine"}, "Shrine")
			end
		end
	end

	--Marker for your corpse
	local corpse = this:GetObjVar("CorpseObject")
	if ( corpse ~= nil and corpse:IsValid() ) then
		local deathLocation = corpse:GetLoc()
		table.insert(mapIcons,{Icon="location_corpse", Location=deathLocation, Tooltip="Corpse"})
		--AddDynamicMapMarker(this, {Icon="location_corpse", Location=deathLocation, Tooltip="Corpse"}, "Corpse")
	end

	if (GetMapMarkerController() ~= nil) then
		for markerIndex, marker in pairs(GetControllerFamiliarMarkers()) do
			if not (marker.RegionName) then
				table.insert(mapIcons, marker)
			end
		end
	end

	--Dynamic map markers (from AddDynamicMapMarker)
	local mapMarkers = this:GetObjVar("MapMarkers")
	--DebugMessage(DumpTable(mapMarkers))	
	if( mapMarkers ~= nil) then
		for i,markerEntry in pairs(mapMarkers) do
			--DebugMessage(mapMarkers.Tooltip)
			local isValidRegion = true
			if(markerEntry.RegionAddress ~= nil and markerEntry.RegionAddress ~= ServerSettings.RegionAddress) then
				isValidRegion = false
			end
			--DebugMessage("isValidRegion is "..tostring(isValidRegion))
			if(isValidRegion) then
				--DebugMessage("Location is ")
				if(markerEntry.ObjTemplate ~= nil and markerEntry.ObjTemplate ~= "") then
					-- DAB DEBUG: NEED TO OPTIMIZE THIS
					local matchingObjs
					if(markerEntry.Region ~= nil) then
						matchingObjs = FindObjects(SearchMulti{SearchTemplate(markerEntry.ObjTemplate),SearchRegion(markerEntry.Region)})
					else
						matchingObjs = FindObjects(SearchTemplate(markerEntry.ObjTemplate))
					end

					for i,matchingObj in pairs(matchingObjs) do 
						table.insert(mapIcons,{Icon=markerEntry.Icon, Location=matchingObj:GetLoc(), Tooltip = markerEntry.Tooltip})
					end
				else
					--DebugMessage(markerEntry.Loc)
					local loc = markerEntry.Location
					--DebugMessage("loc is "..tostring(loc))
					if(markerEntry.Obj ~= nil and markerEntry.Obj:IsValid()) then
						loc = markerEntry.Obj:GetLoc()
					end
					if(loc ~= nil) then						
						table.insert(mapIcons,{Icon=markerEntry.Icon, Location=loc, Tooltip = markerEntry.Tooltip, MapVisibility = markerEntry.MapVisibility})

						if(markerEntry.RemoveDistance and this:GetLoc():Distance(loc) < markerEntry.RemoveDistance) then
							table.remove(mapMarkers,i)
							--this:SetObjVar("MapMarkers",mapMarkers)
						end
					end
				end				
			end
		end
	end

	if(customMapMarkerFunctions[mapName] ~= nil) then
		customMapMarkerFunctions[mapName](mapIcons)
	end	
	return mapIcons, numberOfGroupMembers
end

function UpdateUserWaypoint(waypointId,waypointInfo)
	local worldName = GetCurrentWorldMapName()
	local activeMap = this:GetObjVar("ActiveMap")
	local subregionName = worldName

	--[[
	if (activeMap ~= nil) then
		subregionName = activeMap:GetObjVar("MapName")
	end
	]]--
	if (waypointId ~= nil) then
		subregionName = waypointId.SubregionName
	else
		if (activeMap ~= nil) then
			subregionName = curMap or worldName
		else
			subregionName = GetCurrentWorldMapName()
		end
	end

	local waypoints = this:GetObjVar("LoadedWaypoints")

	-- get world table
	if not(waypoints[worldName]) then
		waypoints[worldName] = {}
	end	
	local waypointTable = waypoints[worldName]

	-- get subregion table (if necesary)
	--if(subregionName and subregionName ~= worldName) then
	if not(waypoints[worldName][subregionName]) then
		waypoints[worldName][subregionName] = {}
	end

	waypointTable = waypoints[worldName][subregionName]

	-- update waypoint
	if not(waypointId) then
		if(not(IsImmortal(this)) and GetWaypointCount(activeMap) >= GetMaxWaypoints(activeMap)) then
			this:SystemMessage("You have reached the maximum limit of waypoints for this map. ("..GetMaxWaypoints(activeMap)..")")
			return
		end
		table.insert(waypointTable,waypointInfo)
	elseif not(waypointInfo) then
		table.remove(waypointTable,waypointId.MarkerIndex)
	else
		waypointTable[waypointId.MarkerIndex] = waypointInfo
	end

	if (activeMap ~= nil) then
		this:SendMessage("UpdateWaypoints", waypoints)
	end
	this:SetObjVar("LoadedWaypoints",waypoints)
end

--Takes a table of nested waypoints and returns an un-nested table of waypoints.
function BreakWaypointTable(waypoints, mapName)
	local worldName = GetCurrentWorldMapName()

	local waypointTable = {}

	for i, j in pairs(waypoints) do
		if (j.Location) then
			table.insert(waypointTable, j)
		end
	end

	if (mapName == worldName) then
		for i, subregionWaypoints in pairs(waypoints[worldName]) do
			if (subregionWaypoints.Location ~= nil) then
				table.insert(waypointTable, subregionWaypoints)
			end
			for i, subregionWaypoint in pairs(subregionWaypoints) do
				table.insert(waypointTable,subregionWaypoint)
			end
		end
	else
		if (waypoints[worldName][mapName] ~= nil) then
			for i, subregionWaypoint in pairs(waypoints[worldName][mapName]) do
				table.insert(waypointTable, subregionWaypoint)
			end
		end
	end
	return waypointTable
end

function ShowMapWindow(mapName, showAllSubmaps)

	mapName = mapName or curMap
	local worldName = GetCurrentWorldMapName()
	local activeMap = this:GetObjVar("ActiveMap")
	local subMaps = nil

	CanZoom = true
	isZoomed = true

	if (activeMap ~= nil) then
		if (activeMap:GetObjVar("MapName") == mapName or mapName == worldName) then
			CanZoom = false
			isZoomed = false
			subMaps = activeMap:GetObjVar("SubMaps")
		end
	else
		if (mapName == worldName) then
			CanZoom = false
			isZoomed = false
			subMaps = this:GetObjVar("SubMaps")
			if (IsImmortal(this)) then
				showAllSubmaps = true
			end
		end
	end
	local dynWindow = DynamicWindow("MapWindow",mapName,924,924,-462,-462,"Transparent","Center")	

	local waypoints = this:GetObjVar("LoadedWaypoints") or {}

	local newWaypoints = nil

	if (waypoints[worldName] == nil) then
		waypoints[worldName] = {}
	end

	--Set id for nested markers
	for i, subregionMarkers in pairs(waypoints[worldName]) do
		if (subregionMarkers.Location) then
			subregionMarkers.Id = "Marker|"..i.."|"..worldName
		else
			for k, waypoint in pairs(subregionMarkers) do
				waypoint.Id = "Marker|"..k.."|"..i
			end
		end
	end

	newWaypoints = BreakWaypointTable(waypoints, mapName)

	local newSubmaps = subMaps
	if (showAllSubmaps == true) then
		newSubmaps = {"UpperPlains", "EasternFrontier", "SouthernHills", "SouthernRim", "BlackForest", "BarrenLands"}
	end

	dynWindow:AddButton(920,22,"CloseMapButton","",46,28,"","",false, "ScrollClose")
	
	--Only show player GPS on world map, or current subregion map
	local showPlayer = true
	if not (ServerSettings.SubregionName == mapName or worldName == mapName) then
		showPlayer = false
	end
	dynWindow:AddMap(0,0,924,924,mapName,showPlayer,(activeMap == nil),newWaypoints, newSubmaps)

	if(CanZoom) then
		local disabledState = ""
		if not(isZoomed) then
			disabledState = "disabled"
		end
		dynWindow:AddButton(442,875,"ZoomOut","",24,24,"","",false,"Minus",disabledState)

		disabledState = ""
		if (isZoomed) then
			disabledState = "disabled"
		end
		--dynWindow:AddButton(468,875,"ZoomIn","",24,24,"","",false,"Plus",disabledState)
	end

	if(IsImmortal(this)) then
		local buttonState = "disabled"
		if (disableDynamicMarkers) then
			buttonState = "pressed"
		end

		dynWindow:AddLabel(794,770,"Disable dynamic markers.",0,0,18,"left",false,true)
		dynWindow:AddButton(770,770,"ToggleDynamicMarkers", "", 24, 24, "", "", false, "Selection2", buttonState)
	end
	
	this:OpenDynamicWindow(dynWindow)
	this:PlayObjectSound("event:/ui/map_open", false, 0, false, false)
	mapWindowOpen = true
	curMap = mapName
end

function HasMap(mapName)
	if(IsImmortal(this)) then
		return true
	end
	return true
end

function CloseMap()
	this:CloseDynamicWindow("MapWindow")
	this:PlayObjectSound("event:/ui/map_close", false, 0, false, false)
	mapWindowOpen = false
	--this:DelObjVar("UserWaypoints")
	this:DelObjVar("ActiveMap")
	this:DelObjVar("CanAddMarkers")
	this:DelObjVar("LoadedWaypoints")
end

curWaypointId = nil
curWaypointIcon = 1
curWaypointLoc = nil
function OpenEditWaypointWindow(name,loc)	
	loc = loc or curWaypointLoc

	local newWindow = DynamicWindow("EditWaypoint","Edit Waypoint",370,220)

	newWindow:AddLabel(20,8,"Name (limit 20 characters)",0,0,18)
	newWindow:AddTextField(10,30,328,20,"entry",name)
    newWindow:AddButton(264, 130, "Save", "Save")  

    local curX = 0
    local curY = 0
    for i,iconName in pairs(waypointIcons) do
    	local state = ""
    	if(curWaypointIcon == i) then
    		state = "pressed"
    	end
    	newWindow:AddButton(curX+15,curY+60,"WaypointIcon|"..i,"",40,40	,"","",false,"",state)
    	newWindow:AddImage(curX+17,curY+62,iconName,34,34)
    	curX = curX + 40
    	if(i == 8) then
    		curX = 0
    		curY = curY + 40
    	end
    end

    curWaypointLoc = loc
    this:OpenDynamicWindow(newWindow)    
end

RegisterEventHandler(EventType.DynamicWindowResponse,"EditWaypoint",
	function (user,buttonId,fieldData)
		if(buttonId == "Save") then
			local waypointName = fieldData.entry
			if (string.len(waypointName) <= 1) then
		 		this:SystemMessage("The waypoint name must be longer than 1 character.","info")
		 		OpenEditWaypointWindow(fieldData.entry)
		 		return
		 	end

			if (string.len(waypointName) > 20) then
		 		this:SystemMessage("The waypoint name must be less than 20 characters.","info")
		 		OpenEditWaypointWindow(fieldData.entry)
		 		return
		 	end

		 	if(#waypointName:gsub("[%a%d ]","") ~= 0) then
			    this:SystemMessage("The waypoint can only contain alphanumeric characters and spaces.","info")
			    OpenEditWaypointWindow(fieldData.entry)
		 		return
			end
			UpdateUserWaypoint(curWaypointId,{Tooltip=waypointName,Location=curWaypointLoc,Icon=waypointIcons[curWaypointIcon]})			
			ShowMapWindow()
		else
			local result = StringSplit(buttonId,"|")
			local action = result[1]
			local arg = result[2]
			if(action == "WaypointIcon") then
				curWaypointIcon = tonumber(arg)
				OpenEditWaypointWindow(fieldData.entry)
			end
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse,"MapWindow",
	function (user,buttonId,fieldData)
		
		if(buttonId == "MapClick") then
			local args = StringSplit(fieldData.Location,",")
			local clickLoc = Loc(tonumber(args[1]),0,tonumber(args[2]))

			local options = {}
			if (this:GetObjVar("CanAddMarkers") == true) then
				table.insert(options,"Add Waypoint")
			end
			if(IsImmortal(this)) then
				table.insert(options,"Goto")
				table.insert(options,"Portal")
			end

			this:OpenCustomContextMenu("MapClickOptions","Action",options)
   			RegisterSingleEventHandler(EventType.ContextMenuResponse,"MapClickOptions",
   				function(user,optionStr)
   					if(optionStr == "Add Waypoint") then
   						curWaypointId = nil
   						OpenEditWaypointWindow("New Waypoint",clickLoc)
   					elseif(IsImmortal(this)) then
					   	if ( optionStr == "Goto" ) then
							this:SetWorldPosition(clickLoc)
						elseif ( optionStr == "Portal" ) then
							OpenTwoWayPortal(this:GetLoc(), clickLoc)
						end
					end
   				end)	
		elseif(buttonId == "ZoomOut" and CanZoom) then
			isZoomed = false
			local mapName = GetCurrentWorldMapName()
			ShowMapWindow(mapName)
		elseif(buttonId == "ZoomIn" and CanZoom) then
			isZoomed = true
			local mapName = GetCurrentMapName()
			ShowMapWindow(mapName)
		elseif(buttonId == "CloseMapButton") then
			CloseMap()
		elseif(buttonId == "ToggleDynamicMarkers") then
			disableDynamicMarkers = not disableDynamicMarkers
		else
			local result = StringSplit(buttonId,"|")
			local action = result[1]
			if(action == "Marker") then
				local argIndex = result[2]
				local argName = result[3]
				local options = {"Edit Waypoint", "Remove Waypoint"}
				if(IsImmortal(this)) then
					table.insert(options,"Goto")
					table.insert(options,"Portal")
				end

				local mapIcons = this:GetObjVar("LoadedWaypoints")
				local mapIconId = {MarkerIndex = tonumber(argIndex), SubregionName = argName}

				local icon = mapIcons[GetCurrentWorldMapName()][mapIconId.SubregionName][mapIconId.MarkerIndex]
				if(icon) then
					this:OpenCustomContextMenu("MarkerClickOptions","Action",options)
					RegisterSingleEventHandler(EventType.ContextMenuResponse,"MarkerClickOptions",
		   				function(user,optionStr)
		   					if(optionStr == "Edit Waypoint") then
								curWaypointId = mapIconId
		   						OpenEditWaypointWindow(icon.Tooltip,icon.Location)
		   					elseif(optionStr == "Remove Waypoint") then
		   						curWaypointId = mapIconId
		   						UpdateUserWaypoint(curWaypointId,nil)
		   						ShowMapWindow()
							elseif ( IsImmortal(this) ) then
								if ( optionStr == "Goto" ) then
									this:SetWorldPosition(icon.Location)
								elseif ( optionStr == "Portal" ) then
									OpenTwoWayPortal(this:GetLoc(), icon.Location)
								end
							end
		   			end)
				end	
			end

			if (action == "SubMapButton") then
				local argSubregion = result[2]
				ShowMapWindow(argSubregion)
			end
		end

		if(not(buttonId) or buttonId == "") then
			mapWindowOpen = false
		end
	end)

--Fired when a map or atlas is used
RegisterEventHandler(EventType.Message,"OpenMapWindow",
	function (mapName, mapObj, canZoom, canAddMarkers, subMaps)
		if (mapWindowOpen == true) then
			CloseMap() 
		end

		if (mapObj:GetObjVar("UserWaypoints") == nil) then
			this:SetObjVar("LoadedWaypoints", {})
		else
			this:SetObjVar("LoadedWaypoints", mapObj:GetObjVar("UserWaypoints"))
		end

		curMap = mapName
		this:SetObjVar("ActiveMap", mapObj)
		this:SetObjVar("CanAddMarkers", canAddMarkers)
		if(mapName == nil) then 
			mapName = GetCurrentWorldMapName()
		end

		ShowMapWindow(mapName)
	end)

--Opening takes you to a world map populated with static map markers
RegisterEventHandler(EventType.ClientUserCommand,"map",
	function ()
		
		if (mapWindowOpen == true) then
			CloseMap()
			if (mapObj == this:GetObjVar("ActiveMap")) then return end
		end

		local mapName = ServerSettings.SubregionName

		if(mapName == nil or not(HasMap(mapName)) or IsDungeonMap()) then
			this:SystemMessage("You don't have a map of this area.","info")
		elseif(mapWindowOpen) then
			CloseMap()
		else
			curMap = mapName
			CanZoom = true

			local markerTable = {}
			if (IsImmortal(this)) then
				markerTable = this:GetObjVar("GodMarkers") or {}
				--markerTable = GetDiscoveredMapMarkers(this)
			else
				markerTable = GetDiscoveredMapMarkers(this) or {}
			end

			markerTable = AddStartingMapMarkers(markerTable)

			if (IsImmortal(this)) then
				this:SetObjVar("LoadedWaypoints", markerTable)
			else
				this:SetObjVar("LoadedWaypoints", markerTable)
			end
			this:SetObjVar("CanAddMarkers", false)
			ShowMapWindow(mapName, false)
		end
	end)

RegisterEventHandler(EventType.Timer,"UpdateMapMarkers",
	function ()
		local icons, numberOfGroupMembersNearby = GetMapMarkers()
		
		this:SendClientMessage("UpdateMapMarkers",icons)
		
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"UpdateMapMarkers")
	end)

this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"UpdateMapMarkers")

--When initialized, adds views for each town's region to add and remove town minimap markers
if (GetMapMarkerController() ~= nil) then
	for index, regionName in pairs(GetControllerRegions()) do
		AddView(regionName.."View",SearchSingleObject(this,SearchRegion(regionName)),4.0)

	    RegisterEventHandler(EventType.EnterView,regionName.."View",function ( ... )
	        local regionMarkers = GetControllerRegionMarkers(regionName)
	        if (regionMarkers ~= nil) then
	        	for markerId, marker in pairs(regionMarkers) do
	        		if (marker.Familiar) then
        				RemoveDynamicMapMarker(this,"Minimap|"..marker.Tooltip)
	        		else
	        			AddDynamicMapMarker(this,marker,"Minimap|"..marker.Tooltip)
	        		end
	        	end
	        end
	    end)

	    RegisterEventHandler(EventType.LeaveView,regionName.."View",function ( ... )
	        local regionMarkers = GetControllerRegionMarkers(regionName)
	        if (regionMarkers ~= nil) then
	        	for markerId, marker in pairs(regionMarkers) do
	        		if (marker.Familiar) then
	        			AddDynamicMapMarker(this,marker,"Minimap|"..marker.Tooltip)
	        		else
	        			RemoveDynamicMapMarker(this,"Minimap|"..marker.Tooltip)
	        		end
	        	end
	        end
	    end)
	end
end

RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
        CloseMap()
    end)

RegisterEventHandler(EventType.Message, "CloseMap",
    function()
        CloseMap()
    end)

RegisterEventHandler(EventType.UserLogout,"",function ( ... )
	CloseMap()

	--Removes town map markers. 
	--Resolves having leftover town markers when transferring subregions
	local mapMarkers = this:GetObjVar("MapMarkers")
	if (mapMarkers == nil) then return end
	for markerIndex, marker in pairs(mapMarkers) do
		if (marker.RegionName ~= nil) then
			RemoveDynamicMapMarker(this,"Minimap|"..marker.Tooltip)
		end
	end
end)

RegisterEventHandler(EventType.Message, "LoggedIn", function()
	if (IsImmortal(this)) then
		RequestAllMapMarkers(this)
	end
	CleanUpDiscoveredMapMarkers(this)
end)

if (IsImmortal(this)) then
	--Adds map markers from outside subregion to player
	RegisterEventHandler(EventType.Message, "ClusterControllerMapMarkerResponse", 
		function(worldName, subregionName, mapMarkers)
			ClusterControllerMapMarkerResponse(this, worldName, subregionName, mapMarkers)
		end)
end