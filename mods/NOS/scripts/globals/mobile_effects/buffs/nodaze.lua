MobileEffectLibrary.NoDaze = 
{

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.Permanent = args.Permanent
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "NoDaze", "Daze Immune", "Force Push 02", "Immune to daze effects.", false)
		end
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "NoDaze")
		end
	end,

	GetPulseFrequency = function(self,root)
		if ( self.Permanent ) then return nil end
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(12),
}