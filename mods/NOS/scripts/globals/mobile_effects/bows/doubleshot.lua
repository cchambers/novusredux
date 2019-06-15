MobileEffectLibrary.DoubleShot = 
{

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.Target = target

		if ( self.Target == nil ) then
			EndMobileEffect(root)
			return
		end
	end,

	FireArrow = function(self)
		self.ParentObj:PlayEffect("BuffEffect_H")
		self.ParentObj:SendMessage("ExecuteRangedWeaponAttack", self.Target, "RightHand")
	end,

	OnExitState = function(self,root)
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		-- fire the second arrow
		self.FireArrow(self)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),


	WeaponDamageModifier = 0.5
}