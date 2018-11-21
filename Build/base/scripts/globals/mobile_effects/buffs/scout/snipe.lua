

MobileEffectLibrary.Snipe = 
{

	OnEnterState = function(self,root,target,args)
		if not( target ) then
			EndMobileEffect(root)
			return false
		end

		self.AttackPlus = args.AttackPlus or self.AttackPlus

		-- apply the plus attack for the single hit (Combat mod so we don't have to recalc stats for one shot)
		SetCombatMod(self.ParentObj, "AttackPlus", "Snipe", self.AttackPlus)
		-- fire the arrow (at least attempt)
		self.ParentObj:SendMessage("ExecuteRangedWeaponAttack", target, "RightHand", true, false)
		-- set back to normal
		SetCombatMod(self.ParentObj, "AttackPlus", "Snipe", nil)
			
		EndMobileEffect(root)
		return false
	end,

	AttackPlus = 1,
}