MobileEffectLibrary.NoSunder = 
{

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "NoSunder", "Sunder Immune", "Force Push 02", "Sunder cannot be applied.")
		end
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "NoSunder")
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(12),
}