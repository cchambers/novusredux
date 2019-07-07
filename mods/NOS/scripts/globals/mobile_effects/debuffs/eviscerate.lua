--[[
	This effect is fubar since combat changes from Alpha 2 to Alpha 3
]]

MobileEffectLibrary.Eviscerate = 
{

	Debuff = true,

	OnEnterState = function(self,root,target,args)
		self.Target = target -- person applying this, since it's a debuff and should be applied to a target.

		-- args
		self.Duration = args.Duration or self.Duration
		self.WeaponDamageModifier = args.WeaponDamageModifier or self.WeaponDamageModifier

		if not( self.Target ) then
			return EndMobileEffect(root)
		end

		-- get weapon damage of target (mobile applying effect)
		local damageInfo = GetWeaponDamageInfoForMobile(self.Target, false, "RightHand")

		-- up the damage by +35%
		self.Damage = math.round(damageInfo.Damage * self.WeaponDamageModifier)
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "EviscerateDebuff", "Eviscerate", "Force Push 02", "Delayed damage.", true)
		end

		self.ParentObj:PlayEffect("BloodEffect_A")
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "EviscerateDebuff")
		end

		self.ParentObj:PlayEffect("BuffEffect_G")
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		-- apply the weapon damage
		self.ParentObj:SendMessage("ProcessDamage", self.Target, self.Damage, "Physical")
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),
	Target = nil,
	WeaponDamageModifier = 1.05
}