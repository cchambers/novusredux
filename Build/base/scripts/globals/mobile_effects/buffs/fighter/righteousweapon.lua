MobileEffectLibrary.RighteousWeapon = 
{

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		-- TODO calculate from karma.
		local damage = 40
		AddBuffIcon(self.ParentObj, "RighteousWeapon", "Righteous Weapon", "Force Push 02", "Weapon damage increased by "..damage..".", true)
		SetMobileMod(self.ParentObj, "AttackPlus", "RighteousWeapon", damage)
	end,

	OnExitState = function(self,root)
		SetMobileMod(self.ParentObj, "AttackPlus", "RighteousWeapon", nil)
		RemoveBuffIcon(self.ParentObj, "RighteousWeapon")
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),
}