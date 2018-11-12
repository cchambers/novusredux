--[[
    Used as an effect to regenerate a player's vitality
]]

MobileEffectLibrary.VitalityHearth = 
{

	OnEnterState = function(self,root,target,args)
		if ( target == nil or not self.ParentObj:IsPlayer() ) then
			EndMobileEffect(root)
			return
		end

		-- target refers to the hearth obj that is causing the effect
		self.Target = target

		-- so the current buff can be changed at will from outside the effect
		-- TODO let bards effect the bonus
		RegisterEventHandler(EventType.Message, "AlterVitalityHearth", function(bonus)
			self._Bonus = bonus
			self.UpdateVitalityRegenBonus(self)
		end)
		AddBuffIcon(self.ParentObj, "VitalityRegen", "Vitality", "Fire Spark", "Your vitality is regenerating.", false)

		self.UpdateVitalityRegenBonus(self)
	end,

	OnExitState = function(self,root)
		SetMobileMod(self.ParentObj, "VitalityRegenPlus", "Hearth", nil)
		RemoveBuffIcon(self.ParentObj, "VitalityRegen")
		UnregisterEventHandler("", EventType.Message, "AlterVitalityHearth")
	end,

	GetPulseFrequency = function(self,root)
		return self._PulseFrequency
	end,

	AiPulse = function(self,root)
		if not( self.ValidateEffect(self) ) then
			EndMobileEffect(root)
		elseif self.VitalityMax == false and (GetCurVitality(self.ParentObj) >= GetMaxVitality(self.ParentObj)) then
			self.VitalityMax = true
			self.ParentObj:SystemMessage("You are well rested.","info")
		elseif (GetCurVitality(self.ParentObj) < GetMaxVitality(self.ParentObj)) then
			self.VitalityMax = false
		end
	end,

	ValidateEffect = function(self)
		return ( 
			self.Target ~= nil 
			and self.Target:IsValid() 
			and self.Target:DistanceFrom(self.ParentObj) <= ServerSettings.Vitality.Hearth.MaxRange
		)
	end,

	UpdateVitalityRegenBonus = function(self)
		SetMobileMod(self.ParentObj, "VitalityRegenPlus", "Hearth", self._Bonus)
	end,

	VitalityMax = false,
	Target = nil,
	_PulseFrequency = ServerSettings.Vitality.Hearth.PulseFrequency, --used as a way to verify the effect is still valid
	_Bonus = ServerSettings.Vitality.Hearth.BaseBonus,
}