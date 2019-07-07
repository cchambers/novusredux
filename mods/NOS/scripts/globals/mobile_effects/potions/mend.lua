MobileEffectLibrary.PotionMend = 
{

	OnEnterState = function(self,root,target,args)
	
		if ( self.ParentObj:HasTimer("RecentPotion") ) then
			self.ParentObj:SystemMessage("Cannot use again yet.", "info")
			EndMobileEffect(root)
			return false
		end
		
		if not( HasAnyMobileEffect(self.ParentObj, {"MortalStruck", "Bleed"}) ) then
			self.ParentObj:SystemMessage("You are not wounded.", "info")
			EndMobileEffect(root)
			return false
		end
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromMinutes(1), "RecentPotion")

		self.ParentObj:PlayEffect("HealEffect")

		self.ParentObj:SendMessage("EndMortalStruckEffect")
		self.ParentObj:SendMessage("EndBleedEffect")

		self.ParentObj:SystemMessage("Your wounds have been mended.", "info")

		EndMobileEffect(root)
	end,

}