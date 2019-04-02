MobileEffectLibrary.BeingTaunted = {
	OnEnterState = function(self, root, target)
		self.ParentObj:SendMessage("AttackEnemy",target,true)
	end,
	OnExitState = function(self, root)
		self.ParentObj:SendMessage("EndCombatMessage")
	end,
	GetPulseFrequency = function(self, root)
		return self.Duration
	end,
	AiPulse = function(self, root)
		EndMobileEffect(root)
	end,
	Duration = TimeSpan.FromSeconds(30)
}
