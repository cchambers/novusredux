MobileEffectLibrary.Revealed = 
{
	OnEnterState = function(self,root,target,args)
        self.ParentObj:SendMessage("BreakInvisEffect")
        self.ParentObj:NpcSpeech("Oh, uh... hi!")
        -- local skillLevel = GetSkillLevel(self.ParentObj,"MagerySkill")
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
	
	Duration = TimeSpan.FromSeconds(10),
}