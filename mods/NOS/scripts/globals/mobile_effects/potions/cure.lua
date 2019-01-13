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

		self.ParentObj:SendMessage("ReducePoisonEffect", args.PoisonLevelReduction)

		self.ParentObj:SystemMessage("Some toxins have been removed from your system.", "info")

		EndMobileEffect(root)
	end,

	PoisonReductionLevel = 1
}