MobileEffectLibrary.BeingMentored = 
{

	OnEnterState = function(self,root,mentor, args)
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
		self.Mentor:SendMessage("Mentor.End")
		self.ParentObj:SystemMessage("That's all you can learn from your mentor today.", "info")
		self.ParentObj:StopEffect("ObjectGlowEffect")
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
				local skillLevel = GetSkillLevel(self.ParentObj, self.SkillName)
				if (skillLevel >= self.SkillMax) then
					self.ParentObj:SystemMessage("You have learned all you can from "..self.Mentor:GetName() .. " about this.", "info")
					EndMobileEffect(root)
				else
					self.ParentObj:PlayEffectWithArgs("ObjectGlowEffect",0.0,"Color=FFFF00")
					CheckSkillChance(self.ParentObj, self.SkillName)
				end
			end
		end
	end,

	SkillName = nil,
	SkillMax = 40,
	MaxRange = 5,
	OutOfRange = false,
	Warnings = 0,
	Consent = true,
	Mentor = nil,
	Duration = TimeSpan.FromSeconds(2)
}