MobileEffectLibrary.Dig = {
	ValidateUse = function(self, root, args)
		--Check if we are already digging or location is too far away
		if (self.ParentObj:HasTimer("ShovelDigClose")) then
			--or if we are too far away from dig target location
			self.ParentObj:SystemMessage("Already digging.", "info")
			return false
		elseif
			(self.ParentObj:GetLoc():DistanceSquared(args.TargetLoc) >= (OBJECT_INTERACTION_RANGE * OBJECT_INTERACTION_RANGE))
		 then
			self.ParentObj:SystemMessage("That location is too far away.", "info")
			return false
		end

		return true
	end,
	OnEnterState = function(self, root, target, args)
		if (self:ValidateUse(root, args)) then
			if (args.Duratoin ~= nil) then
				self.PulseFrequency = TimeSpan.FromSeconds(args.Duration)
			end

			self.TargetLoc = args.TargetLoc

			--Dismount mobile if it is mounting
			DismountMobile(self.ParentObj)

			--If this mobile is moving, stop moving before doing anything
			if (self.ParentObj:IsMoving()) then
				self.ParentObj:StopMoving()
			end

			self.ShovelEquipped = self.ParentObj:GetEquippedObject("RightHand")

			--Do whatever mobile should do and effects should play when digging
			self.ParentObj:SetFacing(self.ParentObj:GetLoc():YAngleTo(args.TargetLoc))
			self.ParentObj:PlayAnimation("dig")
			PlayEffectAtLoc("DigDirtParticle", args.TargetLoc)
			self.ShovelEquipped:PlayObjectSound("event:/character/skills/gathering_skills/digging/digging", false, 0.2)

			--EventHandler to detect moving. This allows us to cancel digging if a mobile moves
			RegisterEventHandler(
				EventType.StartMoving,
				"",
				function()
					EndMobileEffect(root)
				end
			)

			--EventHandler to detect unequipping shovel used to digging.
			RegisterEventHandler(
				EventType.ItemUnequipped,
				"",
				function(item)
					if (item == nil) then
						return
					end

					if (item == self.ShovelEquipped) then
						EndMobileEffect(root)
					end
				end
			)

			self.StartProgressBar(self, root)
		else
			EndMobileEffect(root)
			return false
		end
	end,
	StartProgressBar = function(self, root)
		ProgressBar.Show(
			{
				TargetUser = self.ParentObj,
				Label = "Digging",
				Duration = self.PulseFrequency,
				PresetLocation = "AboveHotbar",
				DialogId = "ShovelDig",
				CanCancel = true,
				CancelFunc = function()
					EndMobileEffect(root)
				end
			}
		)
	end,
	OnExitState = function(self, root)
		if (self.ParentObj) then
			if (self.ParentObj:HasTimer("ShovelDigClose")) then
				self.ParentObj:FireTimer("ShovelDigClose") -- close progress bar
			end

			--Unregistering event handlers
			UnregisterEventHandler("", EventType.StartMoving, "")
			UnregisterEventHandler("", EventType.ItemUnequipped, "")
			self.ParentObj:PlayAnimation("idle")
		end
	end,
	--Dig complete and end mobile effect
	AiPulse = function(self, root)
		self.OnDigTimer(self, root)
		EndMobileEffect(root)
	end,
	GetPulseFrequency = function(self, root)
		return self.PulseFrequency
	end,
	--On dig complete
	OnDigTimer = function(self, root)
		local targetLoc = self.TargetLoc
		local shovelUser = self.ParentObj
		local shovelEquipped = self.ShovelEquipped

		--Change durability on success
		if (Success(ServerSettings.Durability.Chance.OnToolUse)) then
			AdjustDurability(shovelEquipped, -1)
		end

		local backpackObj = shovelUser:GetEquippedObject("Backpack")
		if (backpackObj == nil) then
			return
		end

		local packObjects = backpackObj:GetContainedObjects()
		for index, packObj in pairs(packObjects) do
			if (packObj:HasModule("treasure_map")) then
				local mapLocation = packObj:GetObjVar("MapLocation")
				local accuracyDist = packObj:GetObjVar("Accuracy") or 5
				if (mapLocation ~= nil and mapLocation:Distance(targetLoc) < accuracyDist) then
					local dugLocations = packObj:GetObjVar("DugLocations") or {}
					if (self.IsTMapLocationAlreadyDug(self, dugLocations)) then
						shovelUser:SystemMessage("That location has already been excavated.", "info")
						return
					else
						CreateTempObj("shovel_dirt", targetLoc)

						local difficulty = packObj:GetObjVar("Difficulty") or 0
						if not (packObj:HasObjVar("Precise") or CheckSkill(shovelUser, "TreasureHuntingSkill", difficulty)) then
							shovelUser:SystemMessage("Failed to uncover any treasure. Keep digging!", "info")
						elseif (mapLocation:Distance(targetLoc) < 3) then
							packObj:SendMessage("FoundTreasure", shovelUser)
							return
						else
							shovelUser:SystemMessage("The treasure is not buried here.", "info")
							table.insert(dugLocations, targetLoc)
							packObj:SetObjVar("DugLocations", dugLocations)
						end
					end
					return
				end
			end
		end

		local digSites =
			FindObjects(
			SearchMulti(
				{
					SearchRange(shovelUser:GetLoc(), 4), --in 2 units
					SearchModule("diggable_object") --find diggable objects
				}
			)
		)

		--if you dig near a groundskeeper he'll attack you
		local gravekeeper =
			FindObject(
			SearchMulti(
				{
					SearchRange(shovelUser:GetLoc(), 13), --in 13 units
					SearchModule("npc_groundskeeper") --find groundskeeper
				}
			)
		)
		if (gravekeeper ~= nil) then
			gravekeeper:SendMessage("AttackEnemy", shovelUser)
			gravekeeper:NpcSpeech("QUIT ROBBIN' ME GRAVES!!!")
			shovelUser:SetObjVar("WilliesOpinion", "ScrewYou")
		end

		--dig up a buried item in the digsite.
		for index, digSite in pairs(digSites) do
			if (digSite:HasModule("diggable_object")) then
				digSite:SendMessage("DigItem", shovelUser, targetLoc)
				return
			end
		end
		local region = GetRegionsAtLoc(shovelUser:GetLoc())
		local beach = false

		for i, j in pairs(region) do
			local str = string.lower(j)
			if
				(string.match(str, "beach") or string.match(str, "sand") or string.match(str, "desert") or string.match(str, "helm"))
			 then
				beach = true
				break
			end
		end

		if (beach) then
			local loc = shovelUser:GetLoc()
			local template = "resource_sand"
			local stackCount = 1
			local backpackObj = shovelUser:GetEquippedObject("Backpack")
			local harvestingSkill = GetSkillLevel(shovelUser, "HarvestingSkill")
			if ( harvestingSkill > 50 ) then
				stackCount = math.random(2,3)
			end
			local canCreate, reason = CanCreateItemInContainer(template, backpackObj, stackCount)

			if (not canCreate) then
				if (reason == "full") then
					this:SystemMessage("[FA0C0C]Your backpack is full![-]", "info")
				elseif (reason == "overweight") then
					this:SystemMessage("[FA0C0C]That would make you overweight![-", "info")
				end
				EndMobileEffect(root)
				return false
			end
			if (backpackObj ~= nil) then
				-- try to add to the stack in the players pack
				if not (TryAddToStack("Sand", backpackObj, stackCount)) then
					-- no stack in players pack so create an object in the pack
					CreateObjInBackpack(shovelUser, template, "Sand.Created", stackCount)
				end
				shovelUser:SystemMessage("You collect some sand.", "info")
			end
		else
			shovelUser:SystemMessage("You find nothing of interest there.", "info")
		end
	end,
	IsTMapLocationAlreadyDug = function(self, dugLocations)
		for i, dugLoc in pairs(dugLocations) do
			if (self.TargetLoc:DistanceSquared(dugLoc) < 2 * 2) then
				return true
			end
		end
		return false
	end,
	--Digging duration
	PulseFrequency = TimeSpan.FromSeconds(5),
	ShovelEquipped = nil,
	TargetLoc = nil
}
