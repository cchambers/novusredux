MobileEffectLibrary.PowerHourBuff = {
	OnEnterState = function(self, root, target, args)
		AddBuffIcon(
            self.ParentObj,
            "PowerHourEffect",
            "Power Hour",
            "Ignite",
            "You are gaining skills at an increased rate.",
            false
        )
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "PowerHourEffect")
			self.ParentObj:SystemMessage("Your Power Hour has ended.", "info")
			self.ParentObj:DelObjVar("PowerHourEnds")
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		local ends = self.ParentObj:GetObjVar("PowerHourEnds") or 0
		ends = ends - 1
		if (ends <= 0) then
			EndMobileEffect(root)
		else 
			self.ParentObj:SetObjVar("PowerHourEnds", ends)
		end
	end,

	Duration = TimeSpan.FromMinutes(1)
}
