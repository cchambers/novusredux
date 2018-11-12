MobileEffectLibrary.Bleed = 
{
	--PersistSession = true, TODO: integrate persistence for pulse effects

	-- defaults to false
	Debuff = true,

	-- Can this be resisted by Willpower?
	Resistable = true,

	OnEnterState = function(self,root,target,args)
		if ( target == nil or not target:IsValid() ) then
			return EndMobileEffect(root)
		end

		-- immunity from bleed effects
		if ( HasMobileEffect(target, "NoBleed") ) then
			DoMobileImmune(target)
			return EndMobileEffect(root)
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
		self.ParentObj:SystemMessage("You are bleeding!", "info")
		--self.ParentObj:PlayObjectSound("WormPain")

		AdvanceConflictRelation(self.Target, self.ParentObj)
	end,

	OnExitState = function(self,root)
		if ( self.IsPlayer ) then
			RemoveBuffIcon(self.ParentObj, "BleedDebuff")
		end
		self.ParentObj:StopEffect("BloodDropsEffect")
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
			-- TODO: Implement proper damage types and change this to Bleed type!
			self.ParentObj:SendMessage("ProcessTypeDamage", self.Target, self.Damage * self.DamagePercent, false, "Poison")
			self.RemainingPercent = self.RemainingPercent - self.DamagePercent
			self.DamagePercent = self.DamagePercent / 2
			CheckSpellCastInterrupt(self.ParentObj)
		end
	end,

	PulseFrequency = TimeSpan.FromSeconds(1),
	PulseMax = 2,
	CurrentPulse = 0,
	Damage = 1,
	DamagePercent = 0.5,
	RemainingPercent = 1
}