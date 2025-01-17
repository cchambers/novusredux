MobileEffectLibrary.Bleed = 
{
	--PersistSession = true, TODO: integrate persistence for pulse effects

	-- defaults to false
	Debuff = true,

	-- Can this be resisted by Willpower?
	Resistable = true,

	OnEnterState = function(self,root,target,args)
		if ( target == nil or not target:IsValid() ) then
			EndMobileEffect(root)
			return false
		end

		-- immunity from bleed effects
		if ( HasMobileEffect(self.ParentObj, "NoBleed") ) then
			DoMobileImmune(self.ParentObj, "bleed")
			EndMobileEffect(root)
			return false
		end

		self.Target = target
		self.PulseFrequency = args.PulseFrequency or self.PulseFrequency
		self.PulseMax = args.PulseMax or self.PulseMax
		self.Damage = math.random((args.DamageMin or 1), (args.DamageMax or 2))
		self.DamagePercent = args.DamagePercent or self.DamagePercent
		self.IsPlayer = IsPlayerCharacter(self.ParentObj)
		if ( self.IsPlayer ) then
			AddBuffIcon(self.ParentObj, "BleedDebuff", "Bleed", "Shred", "You are bleeding.", true)
		end
		self.ParentObj:PlayEffect("BloodDropsEffect")
		self.ParentObj:PlayEffect("StatusEffectBlood")
		self.ParentObj:SystemMessage("You are bleeding!", "info")
		self.ParentObj:PlayObjectSound("event:/animals/worm/worm_pain")

		AdvanceConflictRelation(self.Target, self.ParentObj)
	end,

	OnExitState = function(self,root)
		if ( self.IsPlayer ) then
			RemoveBuffIcon(self.ParentObj, "BleedDebuff")
		end
		self.ParentObj:StopEffect("BloodDropsEffect")
		self.ParentObj:StopEffect("StatusEffectBlood")
		StartMobileEffect(self.ParentObj, "NoBleed")
	end,

	GetPulseFrequency = function(self,root)
		return self.PulseFrequency
	end,

	AiPulse = function(self,root)
		self.CurrentPulse = self.CurrentPulse + 1
		if ( self.CurrentPulse > self.PulseMax ) then
			EndMobileEffect(root)
		else
			-- if this is the last tick, apply whatever percent is left
			if ( self.CurrentPulse == self.PulseMax ) then
				self.DamagePercent = self.RemainingPercent
			end
			self.ParentObj:SendMessage("ProcessTypeDamage", self.Target, self.Damage * self.DamagePercent, "Bleed")
			self.RemainingPercent = self.RemainingPercent - self.DamagePercent
			self.DamagePercent = self.DamagePercent / 2
		end
	end,

	PulseFrequency = TimeSpan.FromSeconds(1),
	PulseMax = 2,
	CurrentPulse = 0,
	Damage = 1,
	DamagePercent = 0.5,
	RemainingPercent = 1
}