MobileEffectLibrary.Hibernate = 
{
   OnEnterState = function(self,root,target,args)
        args = args or {}

        self.Duration = args.Duration or self.Duration

        if (self.ParentObj:IsPlayer()) then
            AddBuffIcon(self.ParentObj, "hibernate", "Hibernating", "auraoffire", "Increased armor and health regen.", true)
        end
        self.ParentObj:PlayEffectWithArgs("YellowPortalEffect",self.Duration, "Bone=Ground")
        SetMobileMod(self.ParentObj, "Disable", "Stasis", true)
        SetMobileMod(self.ParentObj, "HealthRegenTimes", "HealthRegen", 150)
        SetMobileMod(self.ParentObj, "DefenseTimes", "DefenseBuff", 5)
        self.ParentObj:NpcSpeech("[009dff]Hibernating[-]", "combat")
    end,


	OnExitState = function(self,root)
        SetMobileMod(self.ParentObj, "Disable", "Stasis", nil)
        SetMobileMod(self.ParentObj, "HealthRegenTimes", "HealthRegen", nil)
        SetMobileMod(self.ParentObj, "DefenseTimes", "DefenseBuff", nil)
        self.ParentObj:StopEffect("YellowPortalEffect")
        RemoveBuffIcon(self.ParentObj, "hibernate")
	end,

	GetPulseFrequency = function(self,root)
		return TimeSpan.FromSeconds(self.Duration)
	end,

	AiPulse = function(self,root)
        EndMobileEffect(root)
	end,

    Duration = 11
}