MobileEffectLibrary.SpiritSpeak = 
{
	OnEnterState = function(self,root,target,args)
		local skill = GetSkillLevel(self.ParentObj, "SpiritSpeak")
		CheckSkillChance(self.ParentObj, "SpiritSpeak")
		self.ParentObj:PlayAnimation("roar")
	end,

	OnExitState = function(self,root)
		return
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,
	
	Duration = TimeSpan.FromSeconds(60),
}
