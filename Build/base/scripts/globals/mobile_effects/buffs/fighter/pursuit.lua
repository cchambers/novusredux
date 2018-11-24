MobileEffectLibrary.Pursuit = 
{

	OnEnterState = function(self,root,target,args)
		self.Modifier = args.Modifier or self.Modifier
		self.PulseFrequency = args.PulseFrequency or self.PulseFrequency
		self.PulseMax = args.PulseMax or self.PulseMax

		ApplyPursuitModifersToTarget(self.ParentObj, self.Modifier)
		AddBuffIcon(self.ParentObj, "PursuitBuff", "Pursuit", "Force Push 02", "Speed and damage periodically increased.", true)
		self.ParentObj:PlayEffect("BuffEffect_E")

		RegisterEventHandler(EventType.Message, "BreakInvisEffect", function(what)
			if ( what == "Swing" ) then
				self.ParentObj:PlayEffect("BuffEffect_A")
				EndMobileEffect(root)
			end
		end)
	end,

	OnExitState = function(self,root)
		UnregisterEventHandler("", EventType.Message, "BreakInvisEffect")
		ApplyPursuitModifersToTarget(self.ParentObj, nil)
		RemoveBuffIcon(self.ParentObj, "PursuitBuff")
		self.ParentObj:StopEffect("GroundBuffObject")
	end,

	GetPulseFrequency = function(self,root) 
		return self.PulseFrequency
	end,

	AiPulse = function(self,root)
		self.CurrentPulse = self.CurrentPulse + 1
		if ( self.CurrentPulse > self.PulseMax ) then
			EndMobileEffect(root)
		else
			ApplyPursuitModifersToTarget(self.ParentObj, ( self.Modifier * ( self.CurrentPulse + 1 ) ))
		end
	end,

	PulseFrequency = TimeSpan.FromSeconds(1),
	PulseMax = 1,
	CurrentPulse = 0,
	Modifier = 0.1
}

function ApplyPursuitModifersToTarget(mobileObj, value)
	-- set movement speed.
	SetMobileMod(mobileObj, "MoveSpeedTimes", "Pursuit", value)
	-- set damage.
	SetMobileMod(mobileObj, "AttackTimes", "Pursuit", value)
end