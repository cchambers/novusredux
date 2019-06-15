MobileEffectLibrary.DevilHand = 
{
	OnEnterState = function(self,root,target,args)

		self.Target = target

		if not( self.Target ) then
			EndMobileEffect(root)
			return false
		end

		-- freeze target
        SetMobileMod(self.Target, "Freeze", "DevilHand", true)

		-- play effect at target location
		PlayEffectAtLoc("DevilHandEffect", self.Target:GetLoc())
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		-- damage player
		self.Target:SendMessage("ProcessMagicDamage", self.ParentObj, math.random(self.MinDamage, self.MaxDamage))

		-- unfreeze player
		SetMobileMod(self.Target, "Freeze", "DevilHand", nil)
		
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1.5),
	MinDamage = 150,
	MaxDamage = 200,
}