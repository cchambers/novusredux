MobileEffectLibrary.Evasion = 
{

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.Amount = args.Amount or self.Amount

		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "EvasionBuff", "Evasion", "Quick Shot", "Evasion increased by "..self.Amount, false)
		end

		SetMobileMod(self.ParentObj, "EvasionPlus", "EvasionEffect", self.Amount)

		self.ParentObj:PlayObjectSound("event:/character/combat_abilities/evasion")
	end,

	OnExitState = function(self,root)
		SetMobileMod(self.ParentObj, "EvasionPlus", "EvasionEffect", nil)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "EvasionBuff")
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),
	Amount = 5,
}