MobileEffectLibrary.Murderer = {
	OnEnterState = function(self, root, target, args)
		AddBuffIcon(
            self.ParentObj,
            "MurdererEffect",
            "[FF0000]Murderer[-]",
            "rend",
            "You are a known murderer.",
            false
		)
		
		local murders = self.ParentObj:GetObjVar("Murders")
		local tick = self.ParentObj:GetObjVar("MurderTick")
		if (not(tick) and murders) then -- murders not set up
			self.ParentObj:SetObjVar("MurderTick", effectEnds)
		end

		if (murders) then self.RedCheck(self.ParentObj,murders) end
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "MurdererEffect")
			self.ParentObj:SystemMessage("You are no longer [obviously] a [FF0000]murderer[-]!", "info")
			self.ParentObj:DelObjVar("Murders")
			self.ParentObj:DelObjVar("MurderTick")
			self.ParentObj:DelObjVar("IsRed")
			self.ParentObj:SendMessage("UpdateName")
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		local tick = self.ParentObj:GetObjVar("MurderTick")

		if (tick) then
			tick = tick - 1
		else 
			tick =  self.Decay
		end

		if (tick < 0) then
			local murders = self.ParentObj:GetObjVar("Murders")
			murders = murders - 1
			self.ParentObj:SetObjVar("Murders", murders)
			self.ParentObj:SystemMessage("A [FF0000]murder[-] count has decayed.", "info")
			if (not(murders) or murders <= 0) then -- all murders have decayed
				EndMobileEffect(root)
			else 
				self.ParentObj:SetObjVar("MurderTick", self.Decay)
			end

			self.RedCheck(self.ParentObj, murders)
		else 
			self.ParentObj:SetObjVar("MurderTick", tick)
		end
	end,

	RedCheck = function (who, murders) 
		if (murders > 4 and not(who:GetObjVar("IsRed"))) then
			who:SetObjVar("IsRed", true)
			who:SendMessage("UpdateName")
		end

		local karma = who:GetObjVar("Karma")
		if (karma > -5000) then
			who:SetObjVar("Karma", -5000)
		end
	end,

	Duration = TimeSpan.FromMinutes(1),
	Decay = 8 * 60
}
