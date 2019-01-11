MobileEffectLibrary.PotionStamina = 
{

	OnEnterState = function(self,root,target,args)
		self.Amount = args.Amount or self.Amount
		if ( self.ParentObj:HasTimer("RecentPotion") ) then
			self.ParentObj:SystemMessage("Cannot use again yet.", "info")
			EndMobileEffect(root)
			return false
		end
		
		if ( GetCurStamina(self.ParentObj) >= GetMaxStamina(self.ParentObj) ) then
			self.ParentObj:SystemMessage("You seem rested.", "info")
			EndMobileEffect(root)
			return false
		end
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromMinutes(1), "RecentPotion")

		self.ParentObj:PlayEffect("HeadFlareEffect")

		AdjustCurStamina(self.ParentObj, self.Amount)

		EndMobileEffect(root)
	end,

	Amount = 1,
}