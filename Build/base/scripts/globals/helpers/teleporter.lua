function ValidateTeleport(user,targetLoc)
	--DebugMessage("Debuggery Deh Yah")
	if (user:IsInRegion("NoTeleport")) then
		user:SystemMessage("[$1902]","info")
		return false
	end

	if( not(IsPassable(targetLoc)) ) then
		user:SystemMessage("[FA0C0C] You cannot teleport to that location.[-]","info")
		return false
	end
	
	return true
end

function ValidatePortalSpawnLoc (user, destLoc, destRegionAddress)
	local invalidMessage = ""

	--Is destLoc in a dungeon?
	if (IsDungeonMap()) then 
		invalidMessage = "You cannot create a portal in a dungeon"
		return invalidMessage, destLoc
	end

	--Is destLoc in a NoTeleport region?
	if (IsLocInRegion(destLoc, "NoTeleport")) then
		invalidMessage = "Cannot create a portal here."
		return invalidMessage, destLoc
	end

	--[[
	--Is destLoc not in a passable location? Try a nearby location.
	local newDestLoc = destLoc
	if not (IsPassable(destLoc)) then
		newDestLoc = GetNearbyPassableLocFromLoc(destLoc, 1, 2)
	end
	]]--

	--Is destLoc in a housing bound?
	local controller = Plot.GetAtLoc(destLoc)
	if ( controller ~= nil ) then
		invalidMessage = "You cannot create a portal in a house."
		return invalidMessage, destLoc
	end

	--Is destLoc not passable?
	if not (IsPassable(destLoc)) then
		invalidMessage = "Cannot create a portal here."
		return invalidMessage, destLoc
	end

	--Is destLoc near other teleporters? If so, create it nearby.
	local newDestLoc = destLoc
	local nearbyTeleporters = FindObjects(SearchMulti({SearchRange(destLoc, 1), SearchModule("teleporter")}))
	if (nearbyTeleporters ~= nil) then
		for i, j in pairs(nearbyTeleporters) do
			newDestLoc = GetNearbyPassableLocFromLoc(j:GetLoc(), 1, 2)
		end
	end

	
	return invalidMessage, newDestLoc
end

function GetNearbyFollowers(user)
	return FindObjects(SearchMulti
	{
		SearchMobileInRange(10,true),
		SearchLuaFunction(function(targetObj)
			return (targetObj:GetObjVar("controller") == user
					or targetObj:GetObjVar("MySuperior") == user
					or targetObj:GetObjVar("FollowTarget") == user)
		end)
	})
end

function TeleportUser(teleporter,user,targetLoc,destRegionAddress,destFacing, overrideTimeCheck)
	if(user == nil or not(user:IsValid())) then
		return
	end

	overrideTimeCheck = overrideTimeCheck or false
	-- prevent teleport loops from region transfers
	if(skipCheck == false and TimeSinceLogin(user) < TimeSpan.FromSeconds(5)) then
		return
	end

	--Close any interaction user is making with npc
	user:CloseDynamicWindow("Responses")
	user:CloseDynamicWindow("merchant_interact")

	--Close bank when teleporting
	local bankObj = user:GetEquippedObject("Bank")
	if( bankObj ~= nil ) then
		CloseContainerRecursive(user,bankObj)			
	end

	user:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"TeleportDelay")	

	if (teleporter:HasObjVar("TeleporterConsumeItems")) then
		local itemList = teleporter:GetObjVar("TeleporterConsumeItems")
		user:GetEquippedObject("Backpack"):ConsumeItemsInContainer(itemList,true)
	end

	-- if it's not passed in, try to grab it from the teleporter object
	destFacing = destFacing or teleporter:GetObjVar("DestinationFacing") or user:GetFacing()	
	
	if(destRegionAddress ~= nil and destRegionAddress ~= ServerSettings.RegionAddress) then							
		-- pets will be stabled automatically
		-- DAB TODO: Store which pets should be unstabled on the other side
		if(user:TransferRegionRequest(destRegionAddress,targetLoc)) then
			if( destFacing ~= nil ) then
				user:SetFacing(destFacing)
			end
			if not(teleporter:HasObjVar("NoTeleportEffect")) then
				user:PlayEffect("TeleportToEffect")
				user:PlayObjectSound("event:/magic/air/magic_air_teleport")	
			end

			if (teleporter:HasObjVar("CreatePortalOnExit")) then
	    		MessageRemoteClusterController(destRegionAddress,"CreateObject","spawn_portal",targetLoc)
	    	end	

	    	local bindOnTeleport = teleporter:GetObjVar("BindOnTeleport")
			if( bindOnTeleport ) then
				user:SetObjVar("SpawnPosition",{Region=destRegionAddress,Loc=targetLoc})
			end
		end
	else
		local objsToTeleport = {user}
		TableConcat(objsToTeleport,GetNearbyFollowers(user))

		for i, follower in pairs(objsToTeleport) do
			if not(teleporter:HasObjVar("NoTeleportEffect")) then
				follower:PlayEffect("TeleportToEffect")						
				follower:PlayObjectSound("event:/magic/air/magic_air_teleport")
			end
			follower:SetWorldPosition(targetLoc)
			if( destFacing ~= nil ) then
				follower:SetFacing(destFacing)
			end
		end

		if (teleporter:HasObjVar("CreatePortalOnExit")) then
	    	CreateObj("spawn_portal",targetLoc)
	    end

	    local bindOnTeleport = teleporter:GetObjVar("BindOnTeleport")
		if( bindOnTeleport ) then
			user:SendMessage("BindToLocation",targetLoc)
		end		
	end		
end

function OpenTwoWayPortal(sourceLoc,destLoc,portalDuration, summoner)
	local portalId = uuid()

	PlayEffectAtLoc("TeleportFromEffect",sourceLoc)
	CreateObj("portal",sourceLoc,"source_portal_created",portalDuration,portalId, destLoc)
	RegisterSingleEventHandler(EventType.CreatedObject,"source_portal_created",
		function(success, objRef)
			if(success) then
				if (summoner ~= nil) then
					objRef:SetObjVar("Summoner", summoner)
				end
				objRef:SetObjVar("PortalName", PortalDisplayName(destLoc, false))
				objRef:SetObjVar("Destination", destLoc)
				Decay(objRef, portalDuration)
				if(portalId ~= nil) then
					objRef:SetObjVar("Type",portalId)
				end
			end
		end)

	PlayEffectAtLoc("TeleportFromEffect",destLoc)
	CreateObj("portal",destLoc,"dest_portal_created",portalDuration,portalId, sourceLoc)	
	RegisterSingleEventHandler(EventType.CreatedObject,"dest_portal_created",
		function(success, objRef)
			if(success) then
				if (summoner ~= nil) then
					objRef:SetObjVar("Summoner", summoner)
				end
				objRef:SetObjVar("PortalName", PortalDisplayName(sourceLoc, false))
				objRef:SetObjVar("Destination", sourceLoc)
				Decay(objRef, portalDuration)

				if(portalId ~= nil) then
					objRef:SetObjVar("Type",portalId)
				end
			end
		end)
end

-- DAB TODO: Validate destination location by creating a nodraw object at destination first
function OpenRemoteTwoWayPortal(sourceLoc,destLoc,destRegionAddress,portalDuration, destRegionalName, summoner)
	if(not(destRegionAddress) or destRegionAddress == ServerSettings.RegionAddress) then
		OpenTwoWayPortal(sourceLoc,destLoc,portalDuration, summoner)
		return
	end

	portalDuration = portalDuration or 25

	local portalId = uuid()	

	-- create local source portal
	PlayEffectAtLoc("TeleportFromEffect",sourceLoc)
	CreateObj("portal",sourceLoc,portalId, destLoc)
	RegisterSingleEventHandler(EventType.CreatedObject,portalId,
		function(success,objRef)
			if(success) then
				if (summoner ~= nil) then
					objRef:SetObjVar("Summoner", summoner)
				end
				objRef:SetObjVar("Destination",destLoc)
				objRef:SetObjVar("PortalName", PortalDisplayName(destLoc, false, destRegionalName))
				objRef:SetObjVar("RegionAddress",destRegionAddress)
				Decay(objRef, portalDuration)
			end
		end)

	-- create remote dest portal
	local targetModules = {"decay"}
	local targetObjVars = { Destination=sourceLoc, RegionAddress=ServerSettings.RegionAddress, DecayTime = portalDuration, PortalName = PortalDisplayName(sourceLoc, false), Summoner = summoner}
	MessageRemoteClusterController(destRegionAddress,"CreateObject","portal",destLoc,targetModules,targetObjVars)
end

function OpenOneWayPortal(sourceLoc,destLoc,portalDuration,summoner)
	local portalId = uuid()

	--Source portal
	PlayEffectAtLoc("TeleportFromEffect",sourceLoc)
	CreateObj("portal_red",sourceLoc,"source_portal_created",portalDuration,portalId, destLoc)
	RegisterSingleEventHandler(EventType.CreatedObject,"source_portal_created",
		function(success,objRef)
			if (summoner ~= nil) then
				objRef:SetObjVar("Summoner", summoner)
			end
			objRef:SetObjVar("Destination",destLoc)
			objRef:SetObjVar("PortalName", PortalDisplayName(destLoc, false))
			Decay(objRef, portalDuration)
		end)

	--Destination portal
	--Players cannot return though destination portal
	PlayEffectAtLoc("TeleportFromEffect",sourceLoc)
	CreateObj("portal_red",destLoc,"dest_portal_created",portalDuration,portalId)
	RegisterSingleEventHandler(EventType.CreatedObject,"dest_portal_created",
		function(success,objRef)
			if (summoner ~= nil) then
				objRef:SetObjVar("Summoner", summoner)
			end
			objRef:SetObjVar("PortalName", PortalDisplayName(sourceLoc, true))
			Decay(objRef, portalDuration)
		end)
end

function OpenRemoteOneWayPortal(sourceLoc,destLoc,destRegionAddress,portalDuration, destRegionalName, summoner)
	if(not(destRegionAddress) or destRegionAddress == ServerSettings.RegionAddress) then
		OpenOneWayPortal(sourceLoc,destLoc,portalDuration, summoner)
		return
	end

	PlayEffectAtLoc("TeleportFromEffect",sourceLoc)
	CreateObj("portal_red",sourceLoc,"transfer_portal_created")	
	RegisterSingleEventHandler(EventType.CreatedObject,"transfer_portal_created",
		function (success,objRef)
			if(success) then
				if (summoner ~= nil) then
					objRef:SetObjVar("Summoner", summoner)
				end
				objRef:SetObjVar("Destination",destLoc)
				objRef:SetObjVar("PortalName", PortalDisplayName(destLoc, false, destRegionalName))
				objRef:SetObjVar("RegionAddress",destRegionAddress)
				Decay(objRef, portalDuration)
			end
		end)
	-- create remote dest portal
	local targetModules = {"decay"}
	local targetObjVars = {RegionAddress = ServerSettings.RegionAddress, DecayTime = portalDuration, PortalName = PortalDisplayName(sourceLoc, true), Summoner = summoner}
	MessageRemoteClusterController(destRegionAddress,"CreateObject","portal_red",destLoc,targetModules,targetObjVars)
end

function IsOneWay(destination)
	local destSubregions = GetRegionsAtLoc(destination, "Subregion-")
	for i, subregion in pairs(ServerSettings.Teleport.NoEntryUserPortal) do
		for j, dest in pairs(destSubregions) do
			if (subregion == dest) then
				return true
			end
		end
	end
	return false
end

function PortalDisplayName(destLoc, isOneWay, regionalName)
	local name = "Portal "
	if (destLoc ~= nil) then

		if not (isOneWay) then
			name = name.."to "
		else
			name = name.."from "
		end

		if (regionalName ~= nil) then
			name = name..regionalName.." "
		else
			name = name..GetRegionalName(destLoc).." "
		end
	end
	return name
end

function GetStaticPortalSpawn(staticDest)
	if ( ServerSettings.Teleport.Destination[staticDest] ) then
		local clusterRegions = GetClusterRegions()
		local destInfo = ServerSettings.Teleport.Destination[staticDest]
		for i, region in pairs(clusterRegions) do
			--DebugMessage(region.SubregionName.." "..destInfo.Subregion)
			if (region.SubregionName == destInfo.Subregion) then
				return i, destInfo.Destination
				--destRegionAddress = i
				--destination = destInfo.Destination
			end
		end	
	end
end