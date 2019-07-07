MobileEffectLibrary.AdrenalineRush = 
{
	OnEnterState = function(self,root,target,args)
		-- this argument is not optional!
		self.ParentObj:PlayEffect("BuffEffect_G")
		
		self.Duration = args.Duration or self.Duration
		SetMobileMod(self.ParentObj, "StaminaRegenPlus", "AdrenalineRush", 6)

		AddBuffIcon(self.ParentObj, "AdrenalineRush", "Adrenaline Rush", "Berserker Rage", "Increased Stamina Regeneration.", false)

		self.ParentObj:PlayObjectSound("event:/character/combat_abilities/adrenaline_rush")
	end,

	OnExitState = function(self,root)
		RemoveBuffIcon(self.ParentObj, "AdrenalineRush")
		SetMobileMod(self.ParentObj, "StaminaRegenPlus", "AdrenalineRush", nil)
		--self.ParentObj:PlayAnimation("kneel_standup")
	end,

	GetPulseFrequency = function(self,root)
		return TimeSpan.FromSeconds(10)
	end,

	AiPulse = function(self,root)
			EndMobileEffect(root)
	end,
	

	ReplenishSec = 0,	
	Duration = TimeSpan.FromSeconds(10),
}
