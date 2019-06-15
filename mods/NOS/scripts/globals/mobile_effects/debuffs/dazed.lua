--[[
	This will slow mounted movement speed.
	(Currently not used 4/11/2019)
]]

MobileEffectLibrary.Dazed = 
{

	Debuff = true,
	
	OnEnterState = function(self,root)
		args = args or {}
		self.Duration = args.Duration or self.Duration or 3
		self.Modifier = args.Modifier or self.Modifier
		if ( self.Modifier > 0 or self.Modifier < -1 ) then
			self.Modifier = 0
		end
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "Dazed", "Dazed", "Force Push 02", "Mount Movement slowed by "..((-self.Modifier)*100).."%.", true)
		end
		SetMobileMod(self.ParentObj, "MountMoveSpeedTimes", "Dazed", self.Modifier)
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "Dazed")
		end
		SetMobileMod(self.ParentObj, "MountMoveSpeedTimes", "Dazed", nil)
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