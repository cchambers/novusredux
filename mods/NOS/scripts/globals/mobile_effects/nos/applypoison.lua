MobileEffectLibrary.ApplyPoison = 
{
	--PersistSession = true, TODO: integrate persistence for pulse effects

	Debuff = true,

	-- Can this be resisted by Willpower?
	Resistable = true,

	OnEnterState = function(self,root,target,args)
		EndMobileEffect(root)
	end,

	OnExitState = function(self,root)
	end,

	GetPulseFrequency = function(self,root)
		return self.PulseFrequency
	end,

	AiPulse = function(self,root)
	
	end,

	PulseFrequency = TimeSpan.FromSeconds(6),
	PulseMax = 8,
}