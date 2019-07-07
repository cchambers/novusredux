MobileEffectLibrary.Rage = 
{
	OnEnterState = function(self,root,target,args)

		if (self.ParentObj:IsPlayer()) then
            AddBuffIcon(self.ParentObj, "rage", "Enraged", "charge", "Increased attack and speed.", true)
        end

        self.ParentObj:NpcSpeech("[FF0000]*enraged*[-]", "combat")

		self.Duration = args.Duration or self.Duration
		self.ParentObj:PlayEffectWithArgs("BuffEffect_G",self.Duration, "Bone=Ground")
		self.ParentObj:PlayEffect("RedShadowFogEffect",self.Duration)

		SetMobileMod(self.ParentObj, "MoveSpeedPlus", "MoveSpeed", 0.2)
		SetMobileMod(self.ParentObj, "AttackTimes", "AttackTimes", 0.1)
	end,

	OnExitState = function(self,root)
		SetMobileMod(self.ParentObj, "MoveSpeedPlus", "MoveSpeed", nil)
		SetMobileMod(self.ParentObj, "AttackTimes", "AttackTimes", nil)
		RemoveBuffIcon(self.ParentObj, "rage")
	end,

	GetPulseFrequency = function(self,root)
		return TimeSpan.FromSeconds(self.Duration)
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = 12,
}