MobileEffectLibrary.PotionNOSCure = 
{
	OnEnterState = function(self,root,target,args)
		
		self.PoisonReductionLevel = args.PoisonLevelReduction or self.PoisonReductionLevel

		if ( self.ParentObj:HasTimer("RecentPotion") ) then
			self.ParentObj:SystemMessage("Cannot use again yet.", "info")
			EndMobileEffect(root)
			return false
		end
		
		if not( IsPoisoned(self.ParentObj) ) then
			self.ParentObj:SystemMessage("You are not poisoned.", "info")
			EndMobileEffect(root)
			return false
		end
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromMinutes(1), "RecentPotion")

		self.ParentObj:PlayEffect("HealEffect")
		local poisonLevel = self.ParentObj:GetObjVar("PoisonLevel") or 1
		if (args.PoisonLevelReduction >= poisonLevel) then
			self.ParentObj:SendMessage("EndPoisonEffect")
			self.ParentObj:SystemMessage("You are cured!", "info")
		else
			self.ParentObj:SendMessage("ReducePoisonEffect", args.PoisonLevelReduction)
			self.ParentObj:SystemMessage("Some toxins have been removed from your system.", "info")
		end
		EndMobileEffect(root)
	end,

	PoisonReductionLevel = 1
}