MobileEffectLibrary.Hungry = 
{
	-- Hungry is a 'System Debuff' and Debuff = true is what is cleansed and prevented when a player is immune for example
	---Debuff = true,

	OnEnterState = function(self,root,target,args)
		if not( self.ParentObj:IsPlayer() ) then
			EndMobileEffect(root)
			return false
		end

		if ( ServerSettings.Hunger.Vitality.Enabled ) then
			-- cause them to loose vitality four times as slow as a base hearth would regenerate it.
			SetMobileMod(self.ParentObj, "VitalityRegenPlus", "Hungry", -(ServerSettings.Vitality.Hearth.BaseBonus / 4) )
		end

		AddBuffIcon(self.ParentObj, "HungryDebuff", "Hungry", "charge", "Your hunger is causing you to lose vitality.", true)

	end,

	OnExitState = function(self,root)
		if ( ServerSettings.Hunger.Vitality.Enabled ) then
			SetMobileMod(self.ParentObj, "VitalityRegenPlus", "Hungry", nil)
		end
		RemoveBuffIcon(self.ParentObj, "HungryDebuff")
	end,

}