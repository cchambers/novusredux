MobileEffectLibrary.Focus = 
{

	OnEnterState = function(self,root,target,args)
		self.PulseFrequency = args.PulseFrequency or self.PulseFrequency
		self.PulseMax = args.PulseMax or self.PulseMax
		self.IsPlayer = self.ParentObj:IsPlayer()
		
		if ( self.ParentObj:IsMoving() ) then
			if ( self.IsPlayer ) then
				self.ParentObj:SystemMessage("Must be still to focus.", "info")
			end
			return EndMobileEffect(root)
		end

		if ( GetCurMana(self.ParentObj) >= GetMaxMana(self.ParentObj) ) then
			if ( self.IsPlayer ) then
				self.ParentObj:SystemMessage("You are at peace.", "info")
			end
			return EndMobileEffect(root)
		end

		RegisterEventHandler(EventType.StartMoving, "", function() self.Interrupted(self, root) end)
		RegisterEventHandler(EventType.Message, "BreakInvisEffect", function(what)
			if ( what ~= "Swing" and what ~= "Pickup" ) then
				self.Interrupted(self, root)
			end
		end)
		self._Registered = true

		self.SkillLevel = GetSkillLevel(self.ParentObj, "ChannelingSkill") or 0

		if ( IsInCombat(self.ParentObj) ) then
			self.ParentObj:SendMessage("EndCombatMessage")
		end

		if ( TryMobileFocus(self.ParentObj, self.SkillLevel, self.IsPlayer) == false ) then
			return EndMobileEffect(root)
		end
			
		self.ParentObj:PlayEffect("GreenParticlesBuffEffect", 0.0)

		if ( self.IsPlayer ) then
			AddBuffIcon(self.ParentObj, "FocusBuff", "Focusing", "Thunder Storm", "Regenerating Mana.", false)
		end

		-- the base_mobilestats checks for the focus mobile effect when determining mana regen
		self.ParentObj:SendMessage("RecalculateStats",{ManaRegen=true})

		self._Applied = true
	end,

	OnExitState = function(self,root)
		if ( self._Registered ) then
			UnregisterEventHandler("", EventType.Message, "BreakInvisEffect")
			UnregisterEventHandler("", EventType.StartMoving, "")
		end

		if ( self._Applied ) then
			if ( self.IsPlayer ) then
				RemoveBuffIcon(self.ParentObj, "FocusBuff")
			end
			self.ParentObj:StopEffect("GreenParticlesBuffEffect")
			self.ParentObj:SendMessage("RecalculateStats",{ManaRegen=true})
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.PulseFrequency
	end,

	AiPulse = function(self,root)
		self.CurrentPulse = self.CurrentPulse + 1
		if ( self.CurrentPulse > self.PulseMax ) then
			EndMobileEffect(root)
		else
			if ( GetCurMana(self.ParentObj) >= GetMaxMana(self.ParentObj) ) then
				return EndMobileEffect(root)
			end
			if ( self.CurrentPulse % 3 == 0 ) then
				CheckSkillChance(self.ParentObj, "ChannelingSkill", self.SkillLevel)
			end
		end
	end,

	Interrupted = function(self, root)
		if ( self.IsPlayer ) then
			self.ParentObj:SystemMessage("Focus interrupted.", "info")
		end
		EndMobileEffect(root)
	end,

	PulseFrequency = TimeSpan.FromSeconds(1),
	PulseMax = 120,
	CurrentPulse = 0,

	_Registered = false,
	_Applied = false
}

function TryMobileFocus(mobileObj, skillLevel, isPlayer)
	if( CheckSkillChance(mobileObj, "ChannelingSkill", skillLevel) ) then
		if ( isPlayer ) then
			mobileObj:SystemMessage("You begin to focus.", "info")
		end
		return true
	else
		if ( isPlayer ) then
			mobileObj:SystemMessage("You fail to focus.", "info")
		end
	end
	return false
end