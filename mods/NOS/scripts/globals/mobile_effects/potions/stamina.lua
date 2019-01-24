MobileEffectLibrary.PotionNOSStamina = 
{
	OnEnterState = function(self,root,target,args)
		self.Percentage = args.Percentage or self.Percentage

		self.Amount = GetMaxStamina(self.ParentObj) * (self.Percentage * 0.01)
		if ( self.ParentObj:HasTimer("RecentPotion") ) then
			self.ParentObj:SystemMessage("Cannot use again yet.", "info")
			EndMobileEffect(root)
			return false
		end
		
		if ( GetCurStamina(self.ParentObj) >= GetMaxStamina(self.ParentObj) ) then
			self.ParentObj:SystemMessage("You seem fine.", "info")
			EndMobileEffect(root)
			return false
		end
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromMinutes(1), "RecentPotion")

		self.ParentObj:PlayEffect("HeadFlareEffect")--TODO: Change effect.

		AdjustCurStamina(self.ParentObj, self.Amount)

		EndMobileEffect(root)
	end,

	Percentage = 1,
	Amount = 1
}