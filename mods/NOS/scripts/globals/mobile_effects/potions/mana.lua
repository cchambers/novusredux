MobileEffectLibrary.PotionNOSMana = 
{

	OnEnterState = function(self,root,target,args)
		self.Amount = args.Amount or self.Amount
		if ( self.ParentObj:HasTimer("RecentPotion") ) then
			self.ParentObj:SystemMessage("Cannot use again yet.", "info")
			EndMobileEffect(root)
			return false
		end
		
		if ( GetCurMana(self.ParentObj) >= GetMaxMana(self.ParentObj) ) then
			self.ParentObj:SystemMessage("You seem fine.", "info")
			EndMobileEffect(root)
			return false
		end
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromMinutes(1), "RecentPotion")

		self.ParentObj:PlayEffect("HeadFlareEffect")--TODO: Change effect.

		AdjustCurMana(self.ParentObj, self.Amount)

		EndMobileEffect(root)
	end,

	Amount = 1,
}