mapWindowOpen = false
curMap = nil

isZoomed = true
CanZoom = (GetWorldName() == "NewCelador")

waypointIcons = { "marker_circle1", "marker_circle2", "marker_diamond1", "marker_diamond2", "marker_diamond3", "marker_diamond4", "marker_diamond5", "location_corpse", "location_home","pentagram_marker" }

-- this function can change the map name based on conditions in the map
-- specifically: the current catacombs map is based on the dungeon configuration
customMapFunctions = {
	Catacombs = function (isZoomed)
		-- DAB TODO: make it possible to get catacombs map
		return nil
	end,

	NewCelador = function (isZoomed)
		--[[
		if (isZoomed) then
			local subregionName = GetSubregionName()
			if(subregionName:match("SewerDungeon")) then
				return nil
			elseif(subregionName) then
				return subregionName
			end
		end
		]]--

		return "NewCelador"
	end,

	Ruin = function()
		if(IsImmortal(this)) then
			--return "CatacombsConfig1"
		end
		return nil
	end,

	Deception = function ()
		if(IsImmortal(this)) then
			--return "CatacombsConfig3"
		end
		return nil
	end,

	Contempt = function()
		if(IsImmortal(this)) then
			--return "CatacombsConfig4"
		end
		return nil
	end,
}

catacombsPortal = nil
catacombsPortalSearchedFor = false

customMapMarkerFunctions = {
	NewCelador = function(mapIcons)
		if not(catacombsPortalSearchedFor) then
			catacombsPortal = FindObject(SearchTemplate("catacombs_portal_controller"))
			catacombsPortalSearchedFor = true
		end
		
		if(catacombsPortal) then
			if(catacombsPortal:HasObjVar("CatacombsPortalActive")) then
				table.insert(mapIcons,{Icon="pentagram_marker", Location=catacombsPortal:GetLoc(), Tooltip="The portal to Catacombs has been opened."})
			end
		end
	end,	
}

--[[
function GetCurrentMapName()
	local mapName = GetWorldName()
	if(customMapFunctions[mapName] ~= nil) then
		return customMapFunctions[mapName](isZoomed)
	end
end
]]--

function GetCurrentWorldMapName()
	local activeMap = this:GetObjVar("ActiveMap")
	local worldName = nil
	if (activeMap) then
		worldName = activeMap:GetObjVar("WorldMap")
	else
		if (IsImmortal(this)) then
			worldName = GetWorldName()
			if (customMapFunctions[worldName] ~= nil) then
				worldName = customMapFunctions[worldName](isZoomed)
			else
				worldName = nil
			end
		end
	end
	return worldName
end

function GetMapMarkers()
	local mapIcons = {}
	local mapName = GetCurrentWorldMapName()	

	local userHouse = GetUserHouse(this)
	if(userHouse ~= nil and userHouse:IsValid()) then
		table.insert(mapIcons,{Icon="location_home", Location=userHouse:GetLoc(), Tooltip="Home"})
	end

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
						numberOfGroupMembers = numberOfGroupMembers + 1
					end
				end
			end
		end
	end
	
	if (IsDead(this)) then		
		--Add res shrines if you end up dead.		
		local shrines = FindObjectsWithTagInRange("Shrine",this:GetLoc(),400)		
		if (shrines) then
			local closestShrine = nil
			local closestDist = 401

			for i, shrine in pairs(shrines) do
				local dist = this:DistanceFrom(shrine)
				if(not(closestShrine) or dist < closestDist) then
					closestDist = dist
					closestShrine = shrine
				end				
			end

			if(closestShrine) then
				table.insert(mapIcons,{Icon="marker_diamond5", Location=closestShrine:GetLoc(), Tooltip="Resurrection Shrine"})
			end
		end
	end

	local lastDeathRegion = this:GetObjVar("LastDeathRegion")
	--DebugMessage("corpseRegion is "..tostring(this:GetObjVar("corpseRegion")))
	if(lastDeathRegion == GetRegionAddress()) then
		--DebugMessage("corpseObject is "..tostring(this:GetObjVar("CorpseObject")))
		local lastCorpse = this:GetObjVar("CorpseObject")
		if (lastCorpse ~= nil and lastCorpse:IsValid()) then
			local deathLocation = lastCorpse:GetLoc()
			table.insert(mapIcons,{Icon="location_corpse", Location=deathLocation, Tooltip="Corpse"})
		end
	end

	local mapMarkers = this:GetObjVar("MapMarkers")
	--DebugMessage(DumpTable(mapMarkers))	
	if( mapMarkers ~= nil) then
		for i,markerEntry in pairs(mapMarkers) do
			--DebugMessage(mapMarkers.Tooltip)
			local isValidRegion = true
			if(markerEntry.RegionAddress ~= nil and markerEntry.RegionAddress ~= GetRegionAddress()) then
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
						table.insert(mapIcons,{Icon=markerEntry.Icon, Location=loc, Tooltip = markerEntry.Tooltip})

						if(markerEntry.RemoveDistance and this:GetLoc():Distance(loc) < markerEntry.RemoveDistance) then
							table.remove(mapMarkers,i)
							this:SetObjVar("MapMarkers",mapMarkers)
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
			if (IsImmortal(this)) then
				showAllSubmaps = true
			end
		end
	end
	local dynWindow = DynamicWindow("MapWindow",mapName,924,924,-462,-462,"Transparent","Center")	

	local waypoints = this:GetObjVar("LoadedWaypoints")

	local newWaypoints = nil

	if not (waypoints[worldName]) then
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
	
	dynWindow:AddMap(0,0,924,924,mapName,IsImmortal(this),newWaypoints, newSubmaps)


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

	this:OpenDynamicWindow(dynWindow)
	mapWindowOpen = true
	curMap = mapName
end

function HasMap(mapName)
	if(IsImmortal(this)) then
		return true
	end

	if not(ServerSettings.Misc.MustLearnMaps) then
		return true
	end

	local availableMaps = this:GetObjVar("AvailableMaps") or {}
	return availableMaps[mapName] ~= nil
end

function CloseMap()
	this:CloseDynamicWindow("MapWindow")
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
		else
			local result = StringSplit(buttonId,"|")
			--[[
			if (result[1] == "SubMapButton") then
				isZoomed = true
				ShowMapWindow(result[2])
			end
			]]--
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
				
				--[[
				local icon = nil
				if (mapIconId.SubregionName ~= GetWorldName()) then
					icon = mapIcons[GetWorldName()][mapIconId.SubregionName][mapIconId.MarkerIndex]
				else
					icon = mapIcons[GetWorldName()][mapIconId.MarkerIndex]
				end
				]]--

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
		--this:SystemMessage("You don't have a map of this area.")
	end)

--Only usable by gods
--Opening takes you to a world map populated with default map markers in addition to custom markers placed by the player
RegisterEventHandler(EventType.ClientUserCommand,"map",
	function ()
		if not (IsImmortal(this)) then return end
		if (mapWindowOpen == true) then
			CloseMap()
			if (mapObj == this:GetObjVar("ActiveMap")) then return end
		end

		--local mapName = GetCurrentMapName()
		local mapName = GetCurrentWorldMapName()
		if(not(mapName) or not(HasMap(mapName))) then
			this:SystemMessage("You don't have a map of this area.")
		elseif(mapWindowOpen) then
			CloseMap()
		else
			--[[
			local userWaypoints = this:GetObjVar("UserWaypoints")
			if (userWaypoints == nil) then
				userWaypoints = DefaultMapMarkers
			end
			]]--

			--[[for i, marker in pairs(userWaypoints) do
				table.insert(mapMarkers, marker)
			end]]--
			curMap = mapName
			CanZoom = true
			this:SetObjVar("LoadedWaypoints",DefaultMapMarkers)
			this:SetObjVar("CanAddMarkers", true)
			ShowMapWindow(mapName, true)
		end
	end)

RegisterEventHandler(EventType.Timer,"UpdateMapMarkers",
	function ()
		local icons, numberOfGroupMembersNearby = GetMapMarkers()
		
		this:SendClientMessage("UpdateMapMarkers",icons)
		
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(4 + (numberOfGroupMembersNearby/5) + math.random()),"UpdateMapMarkers")
	end)

this:ScheduleTimerDelay(TimeSpan.FromSeconds(1+math.random()),"UpdateMapMarkers")

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
end)