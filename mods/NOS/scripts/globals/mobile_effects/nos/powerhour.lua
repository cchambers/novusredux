MobileEffectLibrary.PowerHourBuff = {
	OnEnterState = function(self, root, target, args)
		local user = self.ParentObj
		AddBuffIcon(
            user,
            "PowerHourEffect",
            "Power Hour",
            "Ignite",
            "You are gaining skills at an increased rate.",
            false
		)
		
		if (args.Global == true) then
			user:SystemMessage("Global Power Hour triggered! [ff0000]<3[-]", "info")
		end
	end,

	OnExitState = function(self,root)
		local user = self.ParentObj
		if ( user:IsPlayer() ) then
			RemoveBuffIcon(user, "PowerHourEffect")
			user:SystemMessage("Your Power Hour has ended.", "info")
			user:DelObjVar("PowerHourEnds")
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
