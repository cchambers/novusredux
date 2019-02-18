MobileEffectLibrary.BeingMentored = 
{

	OnEnterState = function(self,root,mentor, args)
		self.ParentObj:NpcSpeech("TEACH ME SOME " .. args.SkillName)
		if ( mentor == nil ) then
			EndMobileEffect(root)
			return false
		end
		self.SkillName = args.SkillName
		self.Mentor = mentor

		-- Prompt for consent...
		self.Mentor:SystemMessage(tostring("You begin teaching " .. self.ParentObj:GetName()) .. "...", "info")
	end,

	OnExitState = function(self,root)
		self.Mentor:SystemMessage(tostring("Mentoring has ended.", "info"))
		self.ParentObj:SystemMessage("That's all you can learn from your mentor today.", "info")
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		if (self.Consent) then 
			-- check range from mentor
			local mentorLoc = self.Mentor:GetLoc()
			local myLoc = self.ParentObj:GetLoc()
			local distance = mentorLoc:Distance(myLoc)
			if (distance > self.MaxRange) then
				self.OutOfRange = true
			else 
				self.OutOfRange = false
			end
			if (self.OutOfRange) then 
				if (self.Warnings > 2) then
					EndMobileEffect(root)
					return
				else
					self.ParentObj:SystemMessage("You are too far away from your mentor.", "info")
					self.Warnings = self.Warnings + 1
				end
			else
				-- CHECK SKILL CHANCE
			end
		end
	end,

	SkillName = nil,
	OutOfRange = false,
	Warnings = 0,
	Consent = false,
	Mentor = nil,
	Duration = TimeSpan.FromMinutes(5)
}