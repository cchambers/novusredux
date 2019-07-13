MobileEffectLibrary.Power = 
{

	OnEnterState = function(self,root,target,args)
		-- set args
		self.AttackModifier = args.AttackModifier or self.AttackModifier

		self.ParentObj:PlayEffectWithArgs("BuffEffect_M",0.0,"Bone=Ground")

		SetCombatMod(self.ParentObj, "AttackTimes", "Power", self.AttackModifier)
		self.ParentObj:SendMessage("ExecuteHitAction", target, "RightHand", false)
		SetCombatMod(self.ParentObj, "AttackTimes", "Power", nil)

		EndMobileEffect(root)
	end,

	GetPulseFrequency = nil,
	Range = 20,
}