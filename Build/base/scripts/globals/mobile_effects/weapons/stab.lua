MobileEffectLibrary.Stab = 
{

	OnEnterState = function(self,root,target,args)
		-- set args
		self.AttackModifier = args.AttackModifier or self.AttackModifier
		self.HitChanceFront = args.HitChanceFront or self.HitChanceFront
		self.HitChanceBack = args.HitChanceBack or self.HitChanceBack
		
		self.ParentObj:PlayAnimation("impale")
		self.ParentObj:PlayObjectSound("HumanMaleAttack")

		self._HitChance = self.HitChanceFront
		if ( IsBehind(self.ParentObj, target, 60) ) then
			self._HitChance = self.HitChanceBack
		end

		if ( Success(self._HitChance) ) then
			self.ParentObj:PlayObjectSound("Stab")
			SetCombatMod(self.ParentObj, "AttackTimes", "Stab", self.AttackModifier)
			target:PlayEffect("BuffEffect_A")
			self.ParentObj:SendMessage("ExecuteHitAction", target, "RightHand", false)
			SetCombatMod(self.ParentObj, "AttackTimes", "Stab", nil)
		else
			self.ParentObj:SendMessage("ExecuteMissAction", target, "RightHand")
		end

		EndMobileEffect(root)
	end,

	GetPulseFrequency = nil,
	Range = 1,
	AttackModifier = 0.01,
	HitChanceFront = 0.4,
	HitChanceBack = 0.6,
	_HitChance = nil,
}