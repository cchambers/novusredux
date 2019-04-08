MobileEffectLibrary.BeingTaunted = {
	OnEnterState = function(self, root, caster)
		self.ParentObj:NpcSpeechToUser("*notices you*", caster)
		self.ParentObj:SendMessage("AttackEnemy",caster,true)
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
