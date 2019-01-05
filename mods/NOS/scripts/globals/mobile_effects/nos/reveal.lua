MobileEffectLibrary.Reveal = 
{
	OnEnterState = function(self,root,target,args)
		self.ParentObj:AddModule("sp_reveal_effect")
		self.ParentObj:PlayAnimation("roar")
	end,

	OnExitState = function(self,root)
		self.ParentObj:DelModule("sp_reveal_effect")
		return
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
        	EndMobileEffect(root)
	end,
	
	Duration = TimeSpan.FromSeconds(2),
}
