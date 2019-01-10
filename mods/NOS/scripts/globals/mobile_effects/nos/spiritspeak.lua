MobileEffectLibrary.SpiritSpeak = 
{
	OnEnterState = function(self,root,target,args)
		local skill = GetSkillLevel(self.ParentObj, "SpiritSpeak")
		self.Duration = TimeSpan.FromSeconds((skill / 10) * 60)
		local gain = CheckSkillChance(self.ParentObj, "SpiritSpeak")
		self.ParentObj:SystemMessage("You may now temporarily speak with the dead.")
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