MobileEffectLibrary.NoMount = 
{
	OnEnterState = function(self,root,target,args)
		args = args or {}

		self.Opponent = opponent
		self.Duration = args.Duration or self.Duration

		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "Dismounting", "Dismounting", "Summon Black Horse", "You are currently dismounting and must wait before mounting again.", true)			
		end
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "Dismounting")
		end
	end,

	GetPulseFrequency = function(self,root) 
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(4)
}