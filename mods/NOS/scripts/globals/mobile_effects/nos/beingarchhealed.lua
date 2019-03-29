MobileEffectLibrary.BeingArchHealed = 
{
	OnEnterState = function(self,root,caster,args)
		self.Caster = caster
	end,
	OnExitState = function(self,root)
		return
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		if(GetCurHealth(self.ParentObj) < GetMaxHealth(self.ParentObj)) then
			local healAmount = math.random(self.MinHeal, self.MaxHeal)
			self.ParentObj:SendMessage("HealRequest", healAmount, self.Caster)
			self.ParentObj:PlayEffect("GreenParticlesBuffEffect", 1)
			self.Tick = self.Tick + 1
			if (self.Tick == self.Ticks) then
				EndMobileEffect(root)
				return
			end
		else 
			EndMobileEffect(root)
			return
		end
	end,
	MinHeal = 60,
	MaxHeal = 120,
	Ticks = 4,
	Tick = 0,
	Duration = TimeSpan.FromSeconds(1),
}

