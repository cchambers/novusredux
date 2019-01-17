MobileEffectLibrary.Rune = 
{
	OnEnterState = function(self,root,target,args)
		local useType = args.UseType

		if (useType	=="bury") then

			if (self.ParentObj:HasModule("sitting")) then
				self.ParentObj:SendMessage("StopSitting")
			end

			if (target:HasObjVar("Destination") == false and target:HasObjVar("StaticDestination") == false) then
				self.ParentObj:SystemMessage("Cannot bury an unmarked rune.","info")
				EndMobileEffect(root)
				return false
			end
			if (IsDungeonMap()) then 
				self.ParentObj:SystemMessage("You cannot create a portal in a dungeon.","info")
				EndMobileEffect(root)
				return false
			end

			RegisterSingleEventHandler(EventType.Timer, "BuryingTimer", function()
				self.ParentObj:PlayAnimation("kneel_standup")
				UnregisterEventHandler("", EventType.Message, "DamageInflicted")
				SetMobileMod(self.ParentObj, "Busy", "BuryingMod", nil)
				self.PlaceOnGround(self, root, target)
			end)

			RegisterEventHandler(EventType.Message, "DestroyRune", function(portalSuccess)
				if (target:HasObjVar("IsBuried") and portalSuccess) then
					target:Destroy()
				else
					--InitializeMarkedRune()
					target:DelObjVar("IsBuried")
				end
				EndMobileEffect(root)
			end)

			RegisterEventHandler(EventType.Message, "CancelBury", function (user)
				local isBuried = target:GetObjVar("IsBuried")
				--DebugMessage(tostring(isBuried))

				-- Odd logic I know, but it worked.
				if ( isBuried ~= nil and isBuried == true ) then
				else
					user:SystemMessage("You have stopped burying the rune.","info")
					user:DelObjVar("IsBuryingRune")
					EndMobileEffect(root)
				end
			end)

			if(self.DamageInterrupts) then
				RegisterEventHandler(EventType.Message,"DamageInflicted",
				function (damager,damageAmt)
					if(damageAmt > 0) then
						EndMobileEffect(root)
					end
				end)
			end

			self.ParentObj:SetObjVar("IsBuryingRune", true)
			self.ParentObj:PlayAnimation("forage")	
			self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(self.RuneBuryTime),"BuryingTimer")
			SetMobileMod(self.ParentObj, "Busy", "BuryingMod", true)
			ProgressBar.Show
			{
				Label="Burying",
				Duration=self.RuneBuryTime,
				TargetUser = self.ParentObj,
				PresetLocation="AboveHotbar",
			}

		elseif (useType	 == "rename") then
			RenameRune(self.ParentObj, target)
			EndMobileEffect(root)
			return false
		end
	end,

	PlaceOnGround = function(self, root, target)

		fakeRuneLoc = nil

		RegisterSingleEventHandler(EventType.CreatedObject, "fakeRune",
			function(success, objRef)
				if (success) then
					Decay(objRef, self.RuneBuryTime)
					objRef:SetObjVar("LockedDown", true)
					objRef:DelObjVar("ResourceType")
					self.SetFakeRuneAppearance(objRef)
					objRef:SetName("Teleportation Rune")
					fakeRuneLoc = objRef:GetLoc()
				end
			end)

		RegisterSingleEventHandler(EventType.Timer, "OpenPortal", 
			function()
				local destRegionAddress = target:GetObjVar("RegionAddress")
				if (destRegionAddress == nil) then
					destRegionAddress = GetStaticPortalSpawn(target:GetObjVar("StaticDestination"))
				end
				if (IsClusterRegionOnline(destRegionAddress) == false) then
					self.ParentObj:SystemMessage("Cannot create a portal right now.", "info")
					target:DelObjVar("LockedDown")
					EndMobileEffect(root)
					return
				else
					self.ParentObj:SendMessage("StartMobileEffect", "SummonPortal", target, {SourceSpawnLoc=fakeRuneLoc})
					--InitializeMarkedRune()
				end
				--EndMobileEffect(root)
			end)

		target:SetObjVar("IsBuried", true)
		CreateTempObj("rune_blank", self.ParentObj:GetLoc(), "fakeRune")
		

		PlayEffectAtLoc("CastWater2", self.ParentObj:GetLoc(), self.PortalSpawnDelay)
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(self.PortalSpawnDelay), "OpenPortal")
		
		end,

		SetFakeRuneAppearance = function(target)
			local subregionName = ServerSettings.SubregionName
			if (subregionName == "SouthernHills") then
				target:SetAppearanceFromTemplate("rune_valus")

			elseif (subregionName == "SouthernRim") then
				target:SetAppearanceFromTemplate("rune_pyros")

			elseif (subregionName == "UpperPlains") then
				target:SetAppearanceFromTemplate("rune_eldeirvillage")

			elseif (subregionName == "EasternFrontier") then
				target:SetAppearanceFromTemplate("rune_helm")

			elseif (subregionName == "BarrenLands") then
				target:SetAppearanceFromTemplate("rune_oasis")
			else
				target:SetAppearanceFromTemplate("rune_blackforest")
			end
		end,

	OnExitState = function(self,root)
		self.ParentObj:PlayAnimation("idle")
		UnregisterEventHandler("", EventType.Message, "CancelBury")
		UnregisterEventHandler("", EventType.Message, "DestroyRune")
		UnregisterEventHandler("", EventType.Message, "DamageInflicted")
		self.ParentObj:RemoveTimer("BuryingTimer")
		ProgressBar.Cancel("Burying", self.ParentObj)
		SetMobileMod(self.ParentObj, "Busy", "BuryingMod", nil)
		self.ParentObj:DelObjVar("IsBuryingRune")
	end,

	DamageInterrupts = true,
	RuneBuryTime = 4,
	PortalSpawnDelay = 3,
}