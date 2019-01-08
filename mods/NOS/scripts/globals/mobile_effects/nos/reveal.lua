MobileEffectLibrary.Reveal = 
{
	OnEnterState = function(self,root,target,args)
		local skill = GetSkillLevel(self.ParentObj, "DetectHiddenSkill")
		self.ParentObj:AddModule("sp_reveal_effect",{Skill=skill})
		CheckSkillChance(self.ParentObj, "DetectHiddenSkill")
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
