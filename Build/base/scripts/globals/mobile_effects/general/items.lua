MobileEffectLibrary.BindPortalStone = 
{
	OnEnterState = function(self,root,target,args)
		if not( self.ParentObj:HasObjVar("SpawnPosition") ) then
			self.ParentObj:SystemMessage("Not yet bound to a location, please visit a hearth to do so.","info")
			EndMobileEffect(root)
			return false
		end

		RegisterSingleEventHandler(EventType.Timer, "BuryingTimer", function()
			self.ParentObj:PlayAnimation("kneel_standup")
			UnregisterEventHandler("", EventType.Message, "DamageInflicted")
			SetMobileMod(self.ParentObj, "Disable", "BuryingMod", nil)
			self.PlaceOnGround(self, root, target)
		end)

		RegisterEventHandler(EventType.Message, "DestroyStone", function(portalSuccess)
			if (target:HasObjVar("IsBuried") and portalSuccess) then
				target:Destroy()
			else
				--InitializeMarkedStone()
				target:DelObjVar("IsBuried")
			end
			EndMobileEffect(root)
		end)

		if(self.DamageInterrupts) then
			RegisterEventHandler(EventType.Message,"DamageInflicted",
			function (damager,damageAmt)
				if(damageAmt > 0) then
					EndMobileEffect(root)
				end
			end)
		end
		
		if (IsDungeonMap()) then 
			self.ParentObj:SystemMessage("You cannot create a portal in a dungeon.","info")
			EndMobileEffect(root)
			return false
		end

		self.ParentObj:PlayAnimation("forage")	
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(self.StoneBuryTime),"BuryingTimer")
		SetMobileMod(self.ParentObj, "Disable", "BuryingMod", true)
		ProgressBar.Show
		{
			Label="Activating",
			Duration=self.StoneBuryTime,
			TargetUser = self.ParentObj,
			PresetLocation="AboveHotbar",
		}
	end,

	PlaceOnGround = function(self, root, target)
		fakeStoneLoc = nil

		RegisterSingleEventHandler(EventType.CreatedObject, "fakeStone",
			function(success, objRef)
				if (success) then
					Decay(objRef, self.StoneBuryTime)
					objRef:SetObjVar("LockedDown", true)
					objRef:DelObjVar("ResourceType")
					objRef:SetName("Teleportation Stone")
					fakeStoneLoc = objRef:GetLoc()
				end
			end)

		RegisterSingleEventHandler(EventType.Timer, "OpenPortal", 
			function()
				local spawnInfo = self.ParentObj:GetObjVar("SpawnPosition")
				if not(spawnInfo) then
					EndMobileEffect(root)
					return
				end

				local destRegionAddress = spawnInfo.Region
				
				if (destRegionAddress ~= GetRegionAddress() and IsClusterRegionOnline(destRegionAddress) == false) then
					self.ParentObj:SystemMessage("Cannot create a portal right now.", "info")
					target:DelObjVar("LockedDown")
					EndMobileEffect(root)
					return
				else
					self.ParentObj:SendMessage("StartMobileEffect", "SummonPortal", target, {IsOneWay=true, SourceSpawnLoc=fakeStoneLoc, DestRegion=destRegionAddress, Destination=spawnInfo.Loc, CallbackMessage="DestroyStone"})
					--InitializeMarkedStone()
				end
				--EndMobileEffect(root)
			end)

		target:SetObjVar("IsBuried", true)
		CreateTempObj("bind_portal_stone", self.ParentObj:GetLoc(), "fakeStone")		

		PlayEffectAtLoc("CastWater2", self.ParentObj:GetLoc(), self.PortalSpawnDelay)
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(self.PortalSpawnDelay), "OpenPortal")
		
	end,


	OnExitState = function(self,root)
		self.ParentObj:PlayAnimation("idle")
		UnregisterEventHandler("", EventType.Message, "DestroyStone")
		UnregisterEventHandler("", EventType.Message, "DamageInflicted")
		self.ParentObj:RemoveTimer("BuryingTimer")
		ProgressBar.Cancel("Activating", self.ParentObj)
		SetMobileMod(self.ParentObj, "Disable", "BuryingMod", nil)
	end,

	DamageInterrupts = true,
	StoneBuryTime = 4,
	PortalSpawnDelay = 3,
}