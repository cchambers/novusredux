MobileEffectLibrary.NoMortalStrike = 
{

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "NoMortalStrike", "Mortal Strike Immune", "Force Push 02", "Cannot be mortal striked.")
		end
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "NoMortalStrike")
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