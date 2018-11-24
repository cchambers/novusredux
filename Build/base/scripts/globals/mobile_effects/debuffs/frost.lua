MobileEffectLibrary.Frost = 
{

	Debuff = true,

	-- Can this be resisted by Willpower?
	Resistable = true,

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.Modifier = args.Modifier or self.Modifier
		if ( self.Modifier > 0 or self.Modifier < -1 ) then
			self.Modifier = 0
		end
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "Chilled", "Chilled", "Frost Orb", "Movement slowed by "..((-self.Modifier)*100).."%.", true)
		else
			self.ParentObj:SendMessage("AddThreat", target, 1)
		end
		SetMobileMod(self.ParentObj, "MoveSpeedTimes", "Chilled", self.Modifier)
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "Chilled")
		end
		SetMobileMod(self.ParentObj, "MoveSpeedTimes", "Chilled", nil)
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(3),
	Modifier = -0.5
}