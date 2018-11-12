MobileEffectLibrary.Sunder = 
{
	Debuff = true,

	OnEnterState = function(self,root,opponent,args)
		self.ArmorRemoved = -(args.ArmorRemoved or self.ArmorRemoved)
		self.Duration = args.Duration or self.Duration
		self.MobileModId = uuid() .. "Sunder"

		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "DebuffSunder", "Sunder", "Terrify", "Armor Reduced.", true)
		end
		SetMobileMod(self.ParentObj, "DefensePlus", self.MobileModId, self.ArmorRemoved)
	end,

	OnExitState = function(self,root)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "DebuffSunder")
		end
		SetMobileMod(self.ParentObj, "DefensePlus", self.MobileModId, nil)
	end,

	GetPulseFrequency = function(self,root) 
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	ArmorRemoved = 0,
	Duration = TimeSpan.FromSeconds(1)
}