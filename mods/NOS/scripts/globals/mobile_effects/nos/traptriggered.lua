MobileEffectLibrary.TrapTriggered = 
{
	OnEnterState = function(self,root,trap)
		self.Level = trap:GetObjVar("Trapped") or 1
		self.Trap = trap
		
		self.ParentObj:SystemMessage("Oh no! That was [ff0000]trapped[-]!")
		local damage = math.random(30, 100) * self.Level
		self.ParentObj:PlayEffect("FireballExplosionEffect")
		self.ParentObj:SendMessage("ProcessMagicDamage", self.Target, damage)
	end,

	Traps = {
		Explosion
	},

	OnExitState = function(self,root)
		self.Trap:DelObjVar("Trapped")
		return
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,
	
	Target = nil,
	Trap = nil,
	Level = 1,
	Duration = TimeSpan.FromSeconds(1),
}
