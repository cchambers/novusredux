MobileEffectLibrary.Stab = 
{
	OnEnterState = function(self,root,target,args)
		-- set args
		self.AttackModifier = args.AttackModifier or self.AttackModifier
		self.StealthAttackModifier = args.StealthAttackModifier or self.StealthAttackModifier

		self.ParentObj:PlayObjectSound("event:/character/combat_abilities/puncture")
		if ( self.ParentObj:HasObjVar("WasHidden") ) then
			SetCombatMod(self.ParentObj, "AttackTimes", "Stab", self.StealthAttackModifier)
		else
			SetCombatMod(self.ParentObj, "AttackTimes", "Stab", self.AttackModifier)
		end
		self.ParentObj:PlayEffect("BuffEffect_A")
		self.ParentObj:SendMessage("ExecuteHitAction", target, "RightHand", false)
		SetCombatMod(self.ParentObj, "AttackTimes", "Stab", nil)

		EndMobileEffect(root)
	end,

	GetPulseFrequency = nil,
	Range = 1,
	AttackModifier = 0.01,
	StealthAttackModifier = 0.02,
}