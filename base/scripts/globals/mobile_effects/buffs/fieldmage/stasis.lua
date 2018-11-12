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

		self.Duration = args.Duration or self.Duration

		-- disable movement, casting, actions, etc.
		SetMobileMod(self.ParentObj, "Disable", "Stasis", true)

		-- set them as immune for the duration
		StartMobileEffect(self.ParentObj, "Immune", nil, args)

		self.ParentObj:PlayEffectWithArgs("BubbleSparksEffect",20.0,"Bone=Ground")

		self.IsPlayer = IsPlayerCharacter(self.ParentObj)

		if ( self.IsPlayer ) then
			AddBuffIcon(self.ParentObj, "StasisBuff", "Stasis", "Far Sight", "Immune to all damage. Movement speed reduced by 100%. Cannot cast, use abilites or items.", false)
		end
	end,

	OnExitState = function(self,root)

		SetMobileMod(self.ParentObj, "Disable", "Stasis", nil)
		self.ParentObj:StopEffect("BubbleSparksEffect")
		if ( self.IsPlayer ) then
			RemoveBuffIcon(self.ParentObj, "StasisBuff")
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