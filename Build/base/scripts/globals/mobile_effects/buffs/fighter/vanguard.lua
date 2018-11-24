
MobileEffectLibrary.Vanguard = 
{

	OnEnterState = function(self,root,target,args)
		-- prevent usage if swift justiced.
		if ( HasMobileEffect(self.ParentObj, "SwiftJustice") ) then
			if ( IsPlayerCharacter(self.ParentObj ) ) then
				self.ParentObj:SystemMessage("The Guardian Order prevents that.", "info")
			end
			EndMobileEffect(root)
			return false
		end

		self.Duration = args.Duration or self.Duration
		self.RunSpeedModifier = args.RunSpeedModifier or self.RunSpeedModifier
		self.DamageReturnModifier = args.DamageReturnModifier or self.DamageReturnModifier
		self.DamageReductionModifier = args.DamageReductionModifier or self.DamageReductionModifier

		AddBuffIcon(self.ParentObj, "VanguardBuff", "Vanguard", "Fire Shield", "All damage reduced by 50%, the reduced damage is returned to attacker.", true)
		SetMobileMod(self.ParentObj, "MoveSpeedTimes", "Vanguard", self.RunSpeedModifier)
		SetMobileMod(self.ParentObj, "MagicDamageTakenTimes", "Vanguard", self.DamageReductionModifier)
		SetMobileMod(self.ParentObj, "PhysicalDamageTakenTimes", "Vanguard", self.DamageReductionModifier)

		-- send back 50% damage received to the attacker.
		RegisterEventHandler(EventType.Message, "DamageInflicted", function(damager, damageAmount, damageType, wasCrit, wasBlocked, isReflected)
			if ( damager ~= self.ParentObj and not isReflected and not wasBlocked ) then
				CallFunctionDelayed(TimeSpan.FromMilliseconds(250), function()
					damager:SendMessage("DamageInflicted", self.ParentObj, math.floor( (damageAmount * (1+self.DamageReturnModifier)) + 0.5 ), damageType, wasCrit, false, true)
				end)
			end
		end)


		self.ParentObj:SetSharedObjectProperty("CombatStance","Defensive")
		self.ParentObj:PlayEffect("EnergyShieldEffect")
		self.ParentObj:PlayEffect("VanguardEffect")
		--Play different sound by the gender of a character
		if (IsMale(self.ParentObj)) then
			self.ParentObj:PlayObjectSound("event:/character/combat_abilities/flurry")
		else
			self.ParentObj:PlayObjectSound("event:/character/combat_abilities/female_shout")
		end
	end,

	OnExitState = function(self,root)
		UnregisterEventHandler("", EventType.Message, "DamageInflicted")

		SetMobileMod(self.ParentObj, "MoveSpeedTimes", "Vanguard", nil)
		SetMobileMod(self.ParentObj, "MagicDamageTakenTimes", "Vanguard", nil)
		SetMobileMod(self.ParentObj, "PhysicalDamageTakenTimes", "Vanguard", nil)

		RemoveBuffIcon(self.ParentObj, "VanguardBuff")
		self.ParentObj:SetSharedObjectProperty("CombatStance","Passive")
		
		self.ParentObj:StopEffect("VanguardEffect")
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),
	RunSpeedModifier = -0.5,
	DamageReturnModifier = 0.1,
	DamageReductionModifier = -0.1,
}