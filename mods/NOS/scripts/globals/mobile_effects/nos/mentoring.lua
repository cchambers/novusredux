MobileEffectLibrary.Mentoring = 
{
	OnEnterState = function(self,root,student)
		if ( student == nil ) then
			EndMobileEffect(root)
			return false
		end
		self.Student = student
		self.ParentObj:PlayAnimation("fidget")
		self.ParentObj:PlayEffectWithArgs("ObjectGlowEffect",0.0,"Color=BADA55")
		RegisterSingleEventHandler(EventType.Message, "Mentor.End",
		function ()
			EndMobileEffect(root)
		end)

		RegisterEventHandler(EventType.Message, "Mentor.GainChance",
		function ()
			CheckSkillChance(self.ParentObj, "MentoringSkill")
			local anims = self.Anims
			self.ParentObj:PlayAnimation(anims[math.random(1,#anims)])
			CallFunctionDelayed(TimeSpan.FromSeconds(2),function ( ... )
				self.ParentObj:PlayAnimation("idle")
			end)
		end)
	end,

	OnExitState = function(self,root)
		self.Student:SendMessage("Mentor.End")
		self.ParentObj:SystemMessage("Mentoring has ended", "info")
		self.ParentObj:StopEffect("ObjectGlowEffect")
		return
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Anims = {
		"cast",
		"fidget",
		"alarmed",
		"transaction",
		"forage"
	},
	Student = nil,
	Duration = TimeSpan.FromMinutes(5)
}