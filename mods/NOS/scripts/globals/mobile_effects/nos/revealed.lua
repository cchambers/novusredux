MobileEffectLibrary.Revealed = 
{
	OnEnterState = function(self,root,target,args)
        self.ParentObj:SendMessage("BreakInvisEffect")
		-- self.ParentObj:PlayAnimation("dance_gangamstyle")
        self.ParentObj:NpcSpeech("*gasp*")
        AddBuffIcon(this,"RevealedSpell","Weaken","Thunder Strike 04", "You have been revealed!")
        -- local skillLevel = GetSkillLevel(self.ParentObj,"MagerySkill")
	end,

	OnExitState = function(self,root)
	    RemoveBuffIcon(this,"RevealedSpell")
    --self.ParentObj:PlayAnimation("kneel_standup")
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
        EndMobileEffect(root)
	end,
	
	Duration = TimeSpan.FromSeconds(10),
}
