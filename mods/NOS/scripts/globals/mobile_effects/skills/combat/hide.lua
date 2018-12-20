MobileEffectLibrary.Hide = 
{

	OnEnterState = function(self,root,target,args)
		if ( IsDead(self.ParentObj) ) then return EndMobileEffect(root) end
		-- cpu is more valuable than memory, so let's cache this here.
		self.IsPlayer = self.ParentObj:IsPlayer()

		if(self.IsPlayer) then
			local chest = self.ParentObj:GetEquippedObject("Chest");
            local legs = self.ParentObj:GetEquippedObject("Legs");
            local head = self.ParentObj:GetEquippedObject("Head");
    
			if (chest ~= nil) then
                if (GetArmorSoundType(GetArmorType(chest)) == "Plate") then 
                    self.ParentObj:SystemMessage("You cannot hide in metal armor.", "info")
                    return EndMobileEffect(root)
                end
            end
    
			if (legs ~= nil) then
                if (GetArmorSoundType(GetArmorType(legs)) == "Plate") then 
                    self.ParentObj:SystemMessage("You cannot hide in metal armor.", "info")
                    return EndMobileEffect(root)
                end
            end
    
			if (head ~= nil) then
                if (GetArmorSoundType(GetArmorType(head)) == "Plate") then 
                    self.ParentObj:SystemMessage("You cannot hide in metal armor.", "info")
                    return EndMobileEffect(root)
                end
            end
		end

		if ( args.Force ~= true ) then
			if ( IsMobileDisabled(self.ParentObj) ) then
				if ( self.IsPlayer ) then
					self.ParentObj:SystemMessage("Cannot hide right now.", "info")
				end
				EndMobileEffect(root)
				return
			end
			if ( HasMobileEffect(self.ParentObj, "HuntersMark") ) then
				if ( self.IsPlayer ) then
					self.ParentObj:SystemMessage("You are revealed and cannot hide right now.", "info")
				end
				EndMobileEffect(root)
				return
			end
			if ( self.IsPlayer ) then
				local nearbyMobs = FindObjects(SearchMobileInRange(ServerSettings.Combat.NoHideRange))
				for i=1,#nearbyMobs do
					local mob = nearbyMobs[i]
					if not((ShareGroup(self.ParentObj,mob) or IsController(self.ParentObj,mob))) and mob:HasLineOfSightToObj(self.ParentObj,ServerSettings.Combat.LOSEyeLevel) then
						self.ParentObj:SystemMessage("Cannot hide with others nearby.", "info")
						EndMobileEffect(root)
						return
					end
				end
			end
		end

		-- prevent hiding right away after hide breaks.
		if ( self.IsPlayer and self.ParentObj:HasTimer("HideCooldownTimer") ) then
			if ( args.Force == true ) then
				-- clear the cooldown and progress bars if they exist on a forced hide.
				self.ParentObj:RemoveTimer("HideCooldownTimer")
				ProgressBar.Cancel("Cannot Hide", self.ParentObj)
			else
				self.ParentObj:SystemMessage("Too soon to hide.", "info")
				return EndMobileEffect(root)
			end
		end

		if ( args.Force ~= true and not CheckSkillChance(self.ParentObj, "HidingSkill", math.clamp(GetSkillLevel(self.ParentObj, "HidingSkill"), self.MinChance, self.MaxChance )) ) then
			-- failed to hide.
			if ( self.IsPlayer ) then
				self.ParentObj:SystemMessage("Failed to hide.", "info")
			end
			EndMobileEffect(root)
			return
		end

		local mountObj = GetMount(self.ParentObj)
		if ( mountObj ) then DismountMobile(self.ParentObj, mountObj) end
	
		-- disallow combat
		self.ParentObj:SendMessage("EndCombatMessage")
		self.ParentObj:SetSharedObjectProperty("IsSneaking", true)
		-- make them walk slower
		SetMobileMod(self.ParentObj, "MoveSpeedTimes", "Sneak", -0.50) -- 50% slower

		if ( self.IsPlayer ) then
			self.ParentObj:SystemMessage("You are hidden.", "info")
		end

		self.ParentObj:StopMoving()

		local nearbyAttackers = FindObjects(SearchMulti(
		{
			SearchMobileInRange(30),
			SearchObjVar("CurrentTarget", self.ParentObj),
		}))
		for i=1,#nearbyAttackers do nearbyAttackers[i]:SendMessage("ClearTarget") end

		-- this is so EndEffect knows to remove the meat and potatoes of the effect when it's over.
		self.Hidden = true

		-- stack an invis effect on them (this is the actual disappearing act)
		self.ParentObj:SendMessage("AddInvisEffect", "Hiding")

		-- update the client to make us look sneaky and toggle the button appropriate.
		self.ParentObj:SetSharedObjectProperty("IsSneaking", true)

		if ( self.IsPlayer ) then
			AddBuffIcon(self.ParentObj, "HidingBuff", "Hidden", "stealth", "You are hidden from sight.", true)
		end

		-- Set stat values for number of steps you can take
		self.ParentObj:SetStatValue("Stealth", self.MaxStealthTimer)
		self.ParentObj:SetStatMaxValue("Stealth", self.MaxStealthTimer)

		-- Open dynamic window to show stealth value
		local stealthBarWindow = DynamicWindow("StealthBarWindow","",10,100,-65,-50,"Transparent","Center")
		stealthBarWindow:AddImage(0,3,"StaminaBar_Frame",0,50,"Sliced")
		stealthBarWindow:AddStatBar(
			5,
			48,			
			36,
			5,
			"Stealth",		
			"00ff00",
			self.ParentObj,
			true)
		self.ParentObj:OpenDynamicWindow(stealthBarWindow)

		-- Register handlers for the events we need to know about while hidden.

		RegisterEventHandler(EventType.Message, "BreakInvisEffect", function(what)
			-- allow combat mode while hidden
			if ( what ~= "Combat" ) then
				EndMobileEffect(root)
			end
		end)

		RegisterEventHandler(EventType.StartMoving, "", function()
			self.Moving = true
			-- everytime a walk is started, a second will be removed. This penalizes start stop stealthing.
			self.ParentObj:FireTimer("StealthWalkTimer")
		end)

		RegisterEventHandler(EventType.StopMoving, "", function()
			self.HandleStopped(self)
		end)

		-- handle time passing as we're moving while hidden
		RegisterEventHandler(EventType.Timer, "StealthWalkTimer", function()
			if not ( self.Moving ) then return end

			local chance = math.clamp(GetSkillLevel(self.ParentObj, "StealthSkill"), self.MinChance, self.MaxChance)
			if ( chance == 100 or CheckSkillChance(self.ParentObj, "StealthSkill", chance) ) then
				local curStealth = self.ParentObj:GetStatValue("Stealth")
				
				--self.ParentObj:NpcSpeech("! "..curStealth.." : "..self.CurStealthTime.." !")
				-- if walked in stealth for too long without stopping to replenish or walked for too long since we've been hidden.
				if ( curStealth <= 0 or self.CurStealthTime <= 0 ) then
					--self.ParentObj:NpcSpeech("I've walked too far!")
					EndMobileEffect(root)
					return
				end

				self.ParentObj:SetStatValue("Stealth", curStealth - 1)
				self.CurStealthTime = self.CurStealthTime - 1

				--self.ParentObj:NpcSpeech("I'm Sneaky..")
				-- check again in a second.
				self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(self.StealthTimerDepleteSeconds), "StealthWalkTimer")
			else
				--self.ParentObj:NpcSpeech("I failed to sneek")
				-- failed to sneak, break stealth.
				EndMobileEffect(root)
			end
		end)

		-- handle time passing as we're standing still hidden ( to refill the Stealth stat )
		RegisterEventHandler(EventType.Timer, "StealthStandTimer", function()
			-- fill it back up to the max.
			local curStealth = self.ParentObj:GetStatValue("Stealth")
			if ( not(self.ParentObj:IsMoving()) and curStealth < self.MaxStealthTimer )  then
				self.ParentObj:SetStatValue("Stealth", curStealth + 1)
				self.StandTimer(self)
			end
			--self.ParentObj:NpcSpeech("Standing still: "..curStealth)
		end)

		-- allow players to see people they are within 1 unit of
		AddView("VisibleRange",SearchPlayerInRange(1,true))
		RegisterEventHandler(EventType.EnterView, "VisibleRange", function(targetObj)
				local canSeeList = self.ParentObj:GetObjVar("CanSeeMeList") or {}
				canSeeList[targetObj] = "Hide"
				self.ParentObj:SetObjVar("CanSeeMeList",canSeeList)
				-- force an update for me on the user that just entered range
				self.ParentObj:ForceObjectUpdate(targetObj)
			end)

		RegisterEventHandler(EventType.LeaveView, "VisibleRange", function(targetObj)
				local canSeeList = self.ParentObj:GetObjVar("CanSeeMeList")
				if(canSeeList) then
					canSeeList[targetObj] = nil
					self.ParentObj:SetObjVar("CanSeeMeList",canSeeList)
					-- force an update for me on the user that just left range
					self.ParentObj:ForceObjectUpdate(targetObj)
				end
			end)
	end,

	HandleStopped = function(self)
		if ( self.Moving ) then
			--self.ParentObj:NpcSpeech("Stopped!")
			self.Moving = false
			-- (won't have the timer on start, ie FireTimer)
			if ( self.ParentObj:HasTimer("StealthWalkTimer") ) then
				-- stopped moving so stop the walk timer 
				self.ParentObj:RemoveTimer("StealthWalkTimer")
			end
			--  start the stand timer
			self.StandTimer(self)
		end
	end,

	StandTimer = function(self)
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(self.StealthTimerRegenSeconds), "StealthStandTimer")
	end,

	OnExitState = function(self,root)
		-- cool down happens in a success or failure situation for players
		if ( self.IsPlayer and not self.ParentObj:HasTimer("HideCooldownTimer") ) then
			self.ParentObj:ScheduleTimerDelay(self.CooldownDuration, "HideCooldownTimer")
			ProgressBar.Show(
			{
				TargetUser = self.ParentObj,
				Label = "Cannot Hide",
				Duration = self.CooldownDuration,
				PresetLocation = "AboveHotbar",
				DialogId = "HideCooldownBar",
				CanCancel = false
			})
		end
		-- nothing more was applied unless we actually hid.
		if ( self.Hidden ) then
			self.ParentObj:SystemMessage("You have been revealed.", "info")

			-- Do everything we did in OnEnterState, but the opposite:
			self.ParentObj:SetSharedObjectProperty("IsSneaking", false)
			SetMobileMod(self.ParentObj, "MoveSpeedTimes", "Sneak", nil)
			self.ParentObj:SendMessage("RemoveInvisEffect", "Hiding")
			if ( self.IsPlayer ) then
				RemoveBuffIcon(self.ParentObj, "HidingBuff")
			end
			UnregisterEventHandler("", EventType.Message, "BreakInvisEffect")
			UnregisterEventHandler("", EventType.StartMoving, "")
			UnregisterEventHandler("", EventType.StopMoving, "")
			UnregisterEventHandler("", EventType.Timer, "StealthWalkTimer")
			UnregisterEventHandler("", EventType.Timer, "StealthStandTimer")
			UnregisterEventHandler("", EventType.EnterView, "VisibleRange")
			UnregisterEventHandler("", EventType.LeaveView, "VisibleRange")

			self.ParentObj:CloseDynamicWindow("StealthBarWindow")

			local canSeeMeList = self.ParentObj:GetObjVar("CanSeeMeList")
			if(canSeeMeList) then
				for canSeeObj,arg in pairs(canSeeMeList) do
					if(arg == "Hide") then
						canSeeMeList[targetObj] = nil
					end
				end
				self.ParentObj:SetObjVar("CanSeeMeList",canSeeMeList)
			end
		end
	end,

	IsPlayer = false,
	Hidden = false,
	Moving = false,
	-- minimum and maximum chance to pull off a hide / stealth (in percent)
	MinChance = 10,
	MaxChance = 100,
	MaxStealthTimer = 10, -- the maximum CurStealthTimer can ever be.
	CurStealthTime = 20, --MaxStealth * 2, -- maximum seconds they can move stealthed (given all stealth checks succeed) for one successful hide. ( this prevents traversing the map completely hidden )
	StealthTimerDepleteSeconds = 2, -- speed in seconds the stealth timer ticks (while moving stealthed)
	StealthTimerRegenSeconds = 1, -- speed in seconds the stand timer ticks (while standing still stealthed)
	CooldownDuration = TimeSpan.FromSeconds(9)

}