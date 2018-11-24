MobileEffectLibrary.Silence = 
{
	Debuff = true,

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration

		-- play the effects on the one that is silenced
		self.ParentObj:PlayEffectWithArgs("LaughingSkullEffect",20.0,"Bone=Ground")
		self.ParentObj:PlayObjectSound("event:/character/combat_abilities/adrenaline_rush")

		-- play the effects on the one that did the silencing
		target:PlayEffect("GrimAuraEffect")
		target:PlayAnimation("spell_fire")

		-- if they were casting when mobile effect was applied to them
		if ( self.ParentObj:HasTimer("SpellPrimeTimer") ) then
			-- cancel the spell casting
			self.ParentObj:SendMessage("CancelSpellCast")
			-- double the duration of silence
			self.Duration = self.Duration:Add(self.Duration)
		end

		self.IsPlayer = IsPlayerCharacter(self.ParentObj)

		if ( self.IsPlayer ) then
			AddBuffIcon(self.ParentObj, "SilenceDebuff", "Silenced", "Shock Wave", "Cannot cast spells.", true)
		end
	end,

	OnExitState = function(self,root)

		self.ParentObj:StopEffect("LaughingSkullEffect")

		if ( self.IsPlayer ) then
			RemoveBuffIcon(self.ParentObj, "SilenceDebuff")
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),
	IsPlayer = false,
}