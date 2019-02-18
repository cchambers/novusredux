MobileEffectLibrary.Mentoring = 
{
	OnEnterState = function(self,root,student)
		if ( student == nil ) then
			EndMobileEffect(root)
			return false
		end
		self.Student = student
		self.ParentObj:PlayAnimation("fidget")
		RegisterSingleEventHandler(EventType.Message, "Mentor.End",
		function ()
			EndMobileEffect(root)
		end)
	end,

	OnExitState = function(self,root)
		self.ParentObj:SystemMessage("Mentoring has ended", "info")
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Mentor = nil,
	Duration = TimeSpan.FromMinutes(5)
}