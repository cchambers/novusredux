MobileEffectLibrary.SummonPortal = 
{
	OnEnterState = function(self,root,target,args)
		self.SourceSpawnLoc = args.SourceSpawnLoc or self.ParentObj:GetLoc() or self.SourceSpawnLoc
		self.CallbackMessage = args.CallbackMessage or "DestroyRune"

		local destination = args.Destination or target:GetObjVar("Destination")
		local destRegionAddress = args.DestRegion or target:GetObjVar("RegionAddress")		
		local resourceType = target:GetObjVar("ResourceType")

		--DebugMessage("BLAH "..tostring(target)..tostring(target:TopmostContainer()).. tostring(self.ParentObj))
		if((target:TopmostContainer() ~= self.ParentObj or IsInBank(target))) then
			self.ParentObj:SystemMessage("That must be in your backpack to use it.","info")
			EndMobileEffect(root)
			return
		end

		if (IsDungeonMap()) then
		 	self.ParentObj:SystemMessage("Cannot create portal inside of a dungeon.", "info")
		 	EndMobileEffect(root)
		 	return
		end

		if (destination == nil and resourceType == nil) then
			self.ParentObj:SystemMessage("Rune must be marked before opening a portal.", "info")
			EndMobileEffect(root)
			return
		end

		-- if ( GetKarmaLevel(GetKarma(self.ParentObj)).GuardHostilePlayer ) then
		-- 	self.ParentObj:SystemMessage("You must attone for your negative actions before the gods will allow you to do this.","info")
		-- 	EndMobileEffect(root)
		-- 	return
		-- end

		local portalSourceSpawnLoc =self.SourceSpawnLoc

		-- used to validate location in another subregion.
		RegisterEventHandler(EventType.Message, "PortalLocValidated", function (InvalidMessage, NewDestLoc, RegionalName)
			if (InvalidMessage == "") then
				self.PortalSuccess = true
				local dest = destination

				if (NewDestLoc ~= nil) then
					dest = NewDestLoc
				end
				self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"TeleportDelay")
				if (args.IsOneWay or IsOneWay(self.ParentObj:GetLoc())) then
					OpenRemoteOneWayPortal(portalSourceSpawnLoc,dest,destRegionAddress,20, RegionalName, self.ParentObj)
				else
					OpenRemoteTwoWayPortal(portalSourceSpawnLoc,dest,destRegionAddress,20, RegionalName, self.ParentObj)
				end
				self.ParentObj:RemoveTimer("NoValidation")
			
			elseif (InvalidMessage ~= "") then
				self.ParentObj:SystemMessage(InvalidMessage, "info")
			else
			end

			EndMobileEffect(root)
		end)

		-- handle recall runes for teleport towers
		local staticDest = target:GetObjVar("StaticDestination")
		if (staticDest ~= nil) then
			destRegionAddress, destination = GetStaticPortalSpawn(staticDest)
		end

		-- if the desination subregion is offline, don't create portal
		if (destRegionAddress ~= ServerSettings.RegionAddress and IsClusterRegionOnline(destRegionAddress) == false) then
			self.ParentObj:SystemMessage("Cannot create a portal right now.", "info")
			EndMobileEffect(root)
			return
		end

		--handle user made runes
		if (destination ~= nil) then
			--Skip cluster controller validation if player is in same subregion as destination
			if(not(destRegionAddress) or destRegionAddress == ServerSettings.RegionAddress) then
				local invalidMessage, newDestLoc = ValidatePortalSpawnLoc(self.ParentObj, destination, target:GetObjVar("RegionAddress"))
				self.ParentObj:SendMessage("PortalLocValidated", invalidMessage, newDestLoc)
			else
				MessageRemoteClusterController(destRegionAddress,"ValidatePortalLoc",self.ParentObj, destination)
			end
		end
		
		-- if cluster controller fails to respond, kill the spell
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "NoValidation")
		RegisterEventHandler(EventType.Timer, "NoValidation", function()
			if not (self.PortalSuccess) then
				self.ParentObj:SystemMessage("Portal creation failed.", "info")
			end
			EndMobileEffect(root)
		end)
	end,

	OnExitState = function(self,root)
		UnregisterEventHandler("", EventType.Message, "PortalLocValidated")
		UnregisterEventHandler("", EventType.Message, "NoValidation")

		self.ParentObj:SendMessage(self.CallbackMessage, self.PortalSuccess)
	end,

	PortalSuccess = false,
	CallbackMessage = "DestroyRune",
}