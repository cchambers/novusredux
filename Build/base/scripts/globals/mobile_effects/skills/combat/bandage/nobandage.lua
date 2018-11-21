MobileEffectLibrary.NoBandage = 
{

	-- Options flag for this effect to not be removed on death
	PersistDeath = true,

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "NoBandage", "Recently Bandaged", "force_peace", "Cannot be bandaged.", true)
		end
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "NoBandage")
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(13),
}