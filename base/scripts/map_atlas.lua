--[[
AddUseCase(this,"Open Map",true,"UseObject")
AddUseCase(this, "Rename Map", false, "UseObject")
AddUseCase(this, "Add Map", false, "UseObject")
AddUseCase(this, "Merge Waypoints", false, "UseObject")
SetDefaultInteraction(this,"Open Map")

--Maps contain a set of waypoints that are used to generate map markers

RegisterEventHandler(EventType.Message,"UseObject",function (user,useType)
    --if (not useType == "Open Map") then return end
	if (useType == "Open Map") then
		local mapName = this:GetObjVar("WorldMap")
		local waypoints = this:GetObjVar("UserWaypoints")
		local subMaps = this:GetObjVar("SubMaps")
		if (waypoints == nil) then 
			waypoints = {} 
		end
		user:SendMessage("OpenMapWindow", mapName, this, true, true, subMaps)

	elseif (useType == "Rename Map") then
		RenameMap(user, this)

	elseif(useType == "Merge Waypoints") then
		user:RequestClientTargetGameObj(this, "MergeWaypointsResponse")

	elseif(useType == "Add Map") then
		user:RequestClientTargetGameObj(this, "AddMapResponse")
	end
end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "AddMapResponse", function(clientTarget,user)
	if (clientTarget == nil) then EndMobileEffect(root) end

	if (clientTarget:HasObjVar("MapName")) then
		--self.AddMapDialog(self, root, target, clientTarget)
		AddSubMap(user, this, clientTarget)
	end
end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "MergeWaypointsResponse", function(clientTarget,user)
	if (clientTarget == nil) then EndMobileEffect(root) end

	if (clientTarget:HasObjVar("UserWaypoints")) then
		AddWaypoints(user, this, clientTarget)
	end
end)

RegisterEventHandler(EventType.Message, "UpdateWaypoints",
	function (waypoints)
		this:SetObjVar("UserWaypoints", waypoints)
		UpdateMapTooltip(this)
	end)
]]--
RegisterEventHandler(EventType.Message,"HandleDrop", 
	function(user, droppedItem)
		if (droppedItem:GetObjVar("ResourceType") == "Map") then
			AddSubMap(user, this, droppedItem)
		end
	end)