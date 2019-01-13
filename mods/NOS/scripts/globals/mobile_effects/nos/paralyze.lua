MobileEffectLibrary.Paralyze = 
{
	OnEnterState = function(self,root,target,args)
		-- disable movement, casting, actions, etc.
		self.ParentObj:SystemMessage("You have been paralyzed!")
		self.ParentObj:NpcSpeech("*paralyzed*")
		SetMobileMod(self.ParentObj, "Disable", "Paralyze", true)
		ProgressBar.Show{
            Label="Paralyzed",
            Duration=self.Duration,
            TargetUser=self.ParentObj
        }
	end,

	OnExitState = function(self,root)
		SetMobileMod(self.ParentObj, "Disable", "Paralyze", nil)
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(5),
}