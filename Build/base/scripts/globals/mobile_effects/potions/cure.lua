MobileEffectLibrary.PotionCure = 
{

	OnEnterState = function(self,root,target,args)
	
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

		self.ParentObj:SendMessage("EndPoisonEffect")

		self.ParentObj:SystemMessage("You have been cured.", "info")

		EndMobileEffect(root)
	end,

}