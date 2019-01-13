MobileEffectLibrary.Paralyze = 
{
	Debuff = true,
	Resistable = true,
	OnEnterState = function(self,root,target,args)
		-- freeze
		-- add 'damage taken' single event to exit
	end,

	OnExitState = function(self,root)
		-- release paralyzation
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(6),

}