MobileEffectLibrary.LowVitality = 
{
	PersistDeath = true,

	OnEnterState = function(self,root,target,args)
		if ( not self.ValidateEffect(self) or not self.ParentObj:IsPlayer() ) then
			EndMobileEffect(root)
			return
		end

		if ( self.Amount > 0 ) then
			self.Amount = -self.Amount
		end

		SetMobileMod(self.ParentObj, "MaxHealthTimes", "LowVitality", self.Amount)

		AddBuffIcon(self.ParentObj, "LowVitality", "Low Vitality", "Terrify", "Cannot gain skills or stats\nHealth reduced by "..(-self.Amount*100).."%\n\nVisit an inn's hearth to replenish", true)

		self._Applied = true
	end,

	GetPulseFrequency = function(self,root)
		-- when the debuff is on, it will tick at 10 second intervals so it will 'clear' faster when enough vitality is gained.
		return TimeSpan.FromSeconds(10)
	end,

	AiPulse = function(self,root)
		if not( self.ValidateEffect(self) ) then
			EndMobileEffect(root)
		end
	end,

	OnExitState = function(self,root)
		if ( self._Applied ) then
			SetMobileMod(self.ParentObj, "MaxHealthTimes", "LowVitality", nil)
			RemoveBuffIcon(self.ParentObj, "LowVitality")
		end
	end,

	ValidateEffect = function(self)
		return ( GetCurVitality(self.ParentObj) < ServerSettings.Vitality.Low )
	end,

	Amount = 0.1,

	_Applied = false,
}