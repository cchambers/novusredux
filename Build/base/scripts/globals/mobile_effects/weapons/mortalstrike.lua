MobileEffectLibrary.MortalStrike = 
{

	OnEnterState = function(self,root,target,args)
		-- set args
		self.AttackModifier = args.AttackModifier or self.AttackModifier

		if ( target and target:IsValid() ) then
			if ( HasMobileEffect(target, "NoMortalStrike") ) then
				DoMobileImmune(target)
			else
				target:SendMessage("StartMobileEffect", "MortalStruck")
			end
		end

		target:PlayEffect("BuffEffect_A")
		self.ParentObj:PlayObjectSound("HumanMaleAttack")

		SetCombatMod(self.ParentObj, "AttackTimes", "MortalStrike", self.AttackModifier)
		self.ParentObj:SendMessage("ExecuteHitAction", target, "RightHand", false)
		SetCombatMod(self.ParentObj, "AttackTimes", "MortalStrike", nil)

		EndMobileEffect(root)
	end,

	GetPulseFrequency = nil,

	Range = 20,

	AttackPlus = 0,
}