MobileEffectLibrary.Bash = 
{

	OnEnterState = function(self,root,target,args)
		-- set args
		self.AttackModifier = args.AttackModifier or self.AttackModifier

		self.ParentObj:PlayAnimation("pummel")
		target:PlayEffect("BuffEffect_A")
		self.ParentObj:PlayObjectSound("HumanMaleAttack")

		SetCombatMod(self.ParentObj, "AttackTimes", "Bash", self.AttackModifier)
		self.ParentObj:SendMessage("ExecuteHitAction", target, "RightHand", false)
		SetCombatMod(self.ParentObj, "AttackTimes", "Bash", nil)

		EndMobileEffect(root)
	end,

	GetPulseFrequency = nil,
	AttackModifier = 0,
	Range = 1,
}