MobileEffectLibrary.Dart = 
{

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.Modifier = args.Modifier or self.Modifier

		AddBuffIcon(self.ParentObj, "DartBuff", "Dart", "Blazing Speed", "Speed increased by "..(self.Modifier*100).."%.", false)

		self.ParentObj:PlayEffect("BuffEffect_E")
		self.ParentObj:PlayEffectWithArgs("DustTrailEffect",10.0,"Bone=Ground")
		self.ParentObj:PlayObjectSound("event:/character/combat_abilities/adrenaline_rush")

	    SetMobileMod(self.ParentObj, "MoveSpeedTimes", "Dart", self.Modifier)

		RegisterEventHandler(EventType.Message, "BreakInvisEffect", function(what)
			if ( what == "Swing" ) then
				self.ParentObj:PlayEffect("BuffEffect_A")
				EndMobileEffect(root)
			end
		end)
	end,

	OnExitState = function(self,root)
		UnregisterEventHandler("", EventType.Message, "BreakInvisEffect")
	    SetMobileMod(self.ParentObj, "MoveSpeedTimes", "Dart", nil)
		RemoveBuffIcon(self.ParentObj, "DartBuff")
		self.ParentObj:StopEffect("GroundBuffObject")
		self.ParentObj:StopEffect("DustTrailEffect")
	end,

	GetPulseFrequency = function(self,root) 
		return self.Duration
	end,

	AiPulse = function(self,root)
        EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),
	Modifier = 0.05,
}