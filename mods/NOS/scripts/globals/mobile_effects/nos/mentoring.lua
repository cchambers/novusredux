MobileEffectLibrary.Mentoring = 
{
	OnEnterState = function(self,root,student)
		if ( student == nil ) then
			EndMobileEffect(root)
			return false
		end
		self.Student = student
		self.ParentObj:PlayAnimation("fidget")
	end,

	OnExitState = function(self,root)
		self.ParentObj:SystemMessage("Mentoring has ended")
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Mentor = nil,
	Duration = TimeSpan.FromSeconds(30)
}