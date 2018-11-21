MobileEffectLibrary.Salve = 
{

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.Target = target or self.ParentObj

		self._IsPlayer = self.ParentObj:IsPlayer()

		if ( not IsPoisoned(self.Target) and not HasMobileEffect(self.Target, "Bleed") ) then
			if ( self._IsPlayer ) then
				self.ParentObj:SystemMessage("The patient seems alright.", "info")
			end
			EndMobileEffect(root)
			return false
		end

		if not( ValidateRangeWithError(SkillData.AllSkills.HealingSkill.Options.BandageRange, self.ParentObj, self.Target, "Too far away.") ) then
			EndMobileEffect(root)
			return false
		end

		self._Applied = true

		self.ParentObj:PlayAnimation("kneel")

		if ( self._IsPlayer ) then
			local name = ""
			if ( self.ParentObj ~= self.Target ) then
				name = " to "..self.Target:GetName()
			end
			ProgressBar.Show(
			{
				TargetUser = self.ParentObj,
				Label = "Applying Salve"..name,
				Duration = self.Duration,
				PresetLocation = "AboveHotbar",
				DialogId = "ApplyingSalve",
				CanCancel = true,
				CancelFunc = function()
					EndMobileEffect(root)
				end,
			})
		end

		if ( self.ParentObj ~= self.Target ) then
			RegisterEventHandler(EventType.LeaveView, "OnLeaveSalveRange", function()
				EndMobileEffect(root)
			end)
			AddView("OnLeaveSalveRange", SearchSingleObject(self.Target,SearchMobileInRange(SkillData.AllSkills.HealingSkill.Options.BandageRange)))
		end
	end,

	OnExitState = function(self,root)
		if ( self._Applied ) then
			if( self.ParentObj:HasTimer("ApplyingSalveClose") ) then
				self.ParentObj:FireTimer("ApplyingSalveClose") -- close progress bar
			end
			
			if ( self.ParentObj ~= self.Target ) then
				DelView("OnLeaveSalveRange")
				UnregisterEventHandler("", EventType.LeaveView, "OnLeaveSalveRange")
			end
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		local healingMod = 0.5 + (GetSkillLevel(self.ParentObj, "HealingSkill") / (ServerSettings.Skills.PlayerSkillCap.Single*1.2) )
		if ( Success(healingMod) ) then
			local any = false
			if ( IsPoisoned(self.Target) ) then
				any = true
				self.Target:SendMessage("CurePoison")
				self.Target:NpcSpeech("[0000FF]*cured*[-]", "combat")
			end
			if ( HasMobileEffect(self.Target, "Bleed") ) then
				any = true
				self.Target:SendMessage("EndBleedEffect", self.ParentObj)
			end
			if ( any ) then
				self.Target:PlayEffectWithArgs("PotionHealEffect",0.0,"Color=ff9900")
			end
		else
			-- only tell the target if it's not us.
			if ( self.ParentObj ~= self.Target and self.Target:IsPlayer() ) then
				self.Target:SystemMessage("The salve did nothing.", "info")
			end
			-- always tell ourself the outcome.
			if ( self._IsPlayer ) then
				self.ParentObj:SystemMessage("The salve did nothing.", "info")
			end
		end
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(5),

	_Applied = false,
}