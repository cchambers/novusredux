MobileEffectLibrary.AttackBuff = 
{
	PersistSession = true,

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.Amount = args.Amount or self.Amount
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "AttackBuff", "Attack", "Sap2", "Attack increased by "..self.Amount)
		end
		SetMobileMod(self.ParentObj, "AttackPlus", "AttackBuff", self.Amount)
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "AttackBuff")
		end
		SetMobileMod(self.ParentObj, "AttackPlus", "AttackBuff", nil)
	end,

	OnStack = function(self,root,target,args)
		-- refresh duration
		root.ParentObj:ScheduleTimerDelay(self.Duration, root.PulseId.."-"..root.CurStateName)
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromMinutes(10),
	Amount = .2,
}