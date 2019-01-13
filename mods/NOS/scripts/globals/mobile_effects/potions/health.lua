MobileEffectLibrary.PotionNOSHealth = 
{

	OnEnterState = function(self,root,target,args)
		self.Percentage = args.Percentage or self.Percentage

		self.Amount = GetMaxHealth(self.ParentObj) * (self.Percentage * 0.01)
		if ( self.ParentObj:HasTimer("RecentPotion") ) then
			self.ParentObj:SystemMessage("Cannot use again yet.", "info")
			EndMobileEffect(root)
			return false
		end
		
		if ( GetCurHealth(self.ParentObj) >= GetMaxHealth(self.ParentObj) ) then
			self.ParentObj:SystemMessage("You seem fine.", "info")
			EndMobileEffect(root)
			return false
		end
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromMinutes(1), "RecentPotion")

		self.ParentObj:PlayEffect("HealEffect")

		self.ParentObj:SendMessage("HealRequest", self.Amount, target, true)

		EndMobileEffect(root)
	end,

	Percentage = 1,
	Amount = 1
}