MobileEffectLibrary.Backstab = 
{

	OnEnterState = function(self,root,target,args)
		if not( target ) then
			EndMobileEffect(root)
			return false
		end

		-- set args
		self.AttackPlus = args.AttackPlus or self.AttackPlus
		
		self.ParentObj:PlayAnimation("attack_jump")
		self.ParentObj:PlayEffect("BuffEffect_K")
		self.ParentObj:PlayObjectSound("Stab")

		if ( self._HitChance >= 1 or Success(self._HitChance) ) then
			SetCombatMod(self.ParentObj, "AttackPlus", "Backstab", self.AttackPlus)
			self.ParentObj:SendMessage("ExecuteHitAction", target, "RightHand", false)
			SetCombatMod(self.ParentObj, "AttackPlus", "Backstab", nil)
		end

		EndMobileEffect(root)
		return false
	end,

	AttackPlus = 5,
	_HitChance = 1, --here to configure if it ends up OP
}