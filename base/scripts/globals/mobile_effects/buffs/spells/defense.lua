MobileEffectLibrary.DefenseBuff = 
{
	PersistSession = true,

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.Amount = args.Amount or self.Amount
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "DefenseBuff", "Defense", "Deflect", "Defense increased by "..self.Amount)
		end
		SetMobileMod(self.ParentObj, "DefensePlus", "DefenseBuff", self.Amount)
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "DefenseBuff")
		end
		SetMobileMod(self.ParentObj, "DefensePlus", "DefenseBuff", nil)
	end,

	OnStack = function(self,root,target,args)
		-- refresh duration
		self.ParentObj:ScheduleTimerDelay(self.GetPulseFrequency(self,root), self.PulseId.."-"..self.CurStateName)
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