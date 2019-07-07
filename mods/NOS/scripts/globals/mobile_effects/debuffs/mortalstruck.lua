MobileEffectLibrary.MortalStruck = 
{
	Debuff = true,

	-- Can this be resisted by Willpower?
	Resistable = true,

	OnEnterState = function(self,root,target,args)
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "MortalStruck", "Mortal Strike", "Deep Cuts", "Cannot heal with bandages or magic.", true)
		end
		self.ParentObj:PlayEffect("LaughingSkullEffect")
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "MortalStruck")
		end
		StartMobileEffect(self.ParentObj, "NoMortalStrike")
		self.ParentObj:StopEffect("LaughingSkullEffect")
	end,

	GetPulseFrequency = function(self,root)
		return self.PulseFrequency
	end,

	AiPulse = function(self,root)
		self.CurrentPulse = self.CurrentPulse + 1
		if ( self.CurrentPulse > self.PulseMax ) then
			EndMobileEffect(root)
		else
			self.ParentObj:PlayEffect("LaughingSkullEffect")
		end
	end,

	PulseFrequency = TimeSpan.FromSeconds(2),
	PulseMax = 4,
	CurrentPulse = 0,
}