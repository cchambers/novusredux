MobileEffectLibrary.Slash = 
{

	OnEnterState = function(self,root,target,args)
		-- set args
		self.AttackModifier = args.AttackModifier or self.AttackModifier
		
		if(HasHumanAnimations(self.ParentObj)) then
			self.ParentObj:PlayAnimation("sunder")
			self.ParentObj:PlayObjectSound("HumanMaleAttack")
		else
			-- impale is the "heavy attack for mobs"
			self.ParentObj:PlayAnimation("impale")
		end

		target:PlayEffect("BuffEffect_A")

		SetCombatMod(self.ParentObj, "AttackTimes", "Slash", self.AttackModifier)
		self.ParentObj:SendMessage("ExecuteHitAction", target, "RightHand", false)
		SetCombatMod(self.ParentObj, "AttackTimes", "Slash", nil)

		EndMobileEffect(root)
	end,

	GetPulseFrequency = nil,
	Range = 1,
}