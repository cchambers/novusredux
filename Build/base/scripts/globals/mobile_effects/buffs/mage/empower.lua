MobileEffectLibrary.Empower = 
{
	PersistSession = true, -- so the arguments are saved and we can access them when we fire the spell.

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.Modifier = args.Modifier or self.Modifier

		self._IsPlayer = self.ParentObj:IsPlayer()

		if ( self._IsPlayer ) then
			AddBuffIcon(self.ParentObj, "EmpowerBuff", "Empower", "Regrowth", (self.Modifier*100).."% of casted heals will be applied to those nearby.",false,self.Duration.TotalSeconds)
			self.ParentObj:PlayEffectWithArgs("DestructionBlueEffect",20.0,"Bone=Ground")
		end
		self.ParentObj:PlayObjectSound("event:/magic/misc/magic_water_greater_heal")
	end,

	OnExitState = function(self,root)
		if ( self._IsPlayer ) then
			RemoveBuffIcon(self.ParentObj, "EmpowerBuff")
			self.ParentObj:StopEffect("DestructionBlueEffect")
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),
	Modifier = 0.1,
}