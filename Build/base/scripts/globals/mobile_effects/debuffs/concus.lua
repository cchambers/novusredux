MobileEffectLibrary.Concus = 
{
	Debuff = true,

	OnEnterState = function(self,root,opponent,args)				
		self.Opponent = opponent
		self.Duration = args.Duration or self.Duration
		self.Modifier = args.Modifier or self.Modifier

		SetMobileMod(self.ParentObj, "IntelligenceTimes", "Concused", self.Modifier)
		self.ParentObj:NpcSpeech("[FF0000]*concused*[-]", "combat")
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "DebuffConcused", "Concused", "Terrify", "Intelligence Reduced by "..-(self.Modifier*100).."%", true)
		end

		self.ParentObj:PlayEffect("BuffEffect_I")
	end,

	OnExitState = function(self,root)
		SetMobileMod(self.ParentObj, "IntelligenceTimes", "Concused", nil)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "DebuffConcused")
		end
		self.ParentObj:StopEffect("BuffEffect_I")
	end,

	GetPulseFrequency = function(self,root) 
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Opponent,
	Duration = TimeSpan.FromSeconds(1),
	Modifier = -0.2
}