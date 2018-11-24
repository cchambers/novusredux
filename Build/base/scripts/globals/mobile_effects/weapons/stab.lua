MobileEffectLibrary.Stab = 
{
	OnEnterState = function(self,root,target,args)
		-- set args
		self.AttackModifier = args.AttackModifier or self.AttackModifier
		self.StealthAttackModifier = args.StealthAttackModifier or self.StealthAttackModifier

		-- cache cloaked
		local wasHidden = self.ParentObj:IsCloaked()
		-- break cloak
		self.ParentObj:SendMessage("BreakInvisEffect", "Action")

		self.ParentObj:PlayObjectSound("Stab")
		if ( wasHidden ) then
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