MobileEffectLibrary.Stasis = 
{

	OnEnterState = function(self,root,target,args)
		-- prevent usage if swift justiced.
		if ( HasMobileEffect(self.ParentObj, "SwiftJustice") ) then
			if ( IsPlayerCharacter(self.ParentObj ) ) then
				self.ParentObj:SystemMessage("The Guardian Order prevents that.", "info")
			end
			EndMobileEffect(root)
			return false
		end
		self._Applied = true

		self.Duration = args.Duration or self.Duration

		-- disable movement, casting, actions, etc.
		SetMobileMod(self.ParentObj, "Disable", "Stasis", true)

		-- set them as immune for the duration
		StartMobileEffect(self.ParentObj, "Immune", nil, {
			Duration = self.Duration
		})

		self.ParentObj:PlayEffectWithArgs("IceCrystalFrozenEffect",self.Duration.TotalSeconds+1.5,"Bone=Ground")

		self.IsPlayer = IsPlayerCharacter(self.ParentObj)

		if ( self.IsPlayer ) then
			AddBuffIcon(self.ParentObj, "StasisBuff", "Ice Barrier", "Ice Barrier", "Immune to all damage. Movement speed reduced by 100%. Cannot cast, use abilites or items.", false)
		end
	end,

	OnExitState = function(self,root)
		if ( self._Applied ) then
			SetMobileMod(self.ParentObj, "Disable", "Stasis", nil)
			if ( self.IsPlayer ) then
				RemoveBuffIcon(self.ParentObj, "StasisBuff")
			end
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),
}