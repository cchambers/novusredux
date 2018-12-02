MobileEffectLibrary.PowerHourBuff = {
	OnEnterState = function(self, root, target, args)
		DebugMessage("User has entered powerhour.")
		self.ParentObj:SetObjVar("NextPowerHour", DateTime.UtcNow:Add(TimeSpan.FromHours(24)))
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
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromHours(1)
}
