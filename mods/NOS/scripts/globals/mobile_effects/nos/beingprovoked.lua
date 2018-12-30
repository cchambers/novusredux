MobileEffectLibrary.BeingProvoked = 
{

	OnEnterState = function(self,root,tamer)
		if ( tamer == nil ) then
			EndMobileEffect(root)
			return false
		end
		
		self.Tamer = tamer
		tamer:SystemMessage(tostring("You begin provoking the " .. self.ParentObj:GetName()), "info")
  
	end,

	OnExitState = function(self,root)
		self.Tamer:SystemMessage(tostring("Provocation has ended.", "info"))
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Tamer = nil,
	Duration = TimeSpan.FromSeconds(10)
}