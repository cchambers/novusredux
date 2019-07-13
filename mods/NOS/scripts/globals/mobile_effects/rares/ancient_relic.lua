MobileEffectLibrary.AncientRelic = 
{
	OnEnterState = function(self,root,target,args)
		if ( target ) then
			if ( self.ParentObj:HasTimer("AncientRelicCooldown") ) then
				self.ParentObj:SystemMessage("Please wait to use again.", "info")
			else
				self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "AncientRelicCooldown")
				target:PlayObjectSound("event:/magic/air/magic_air_cast_air",false,0.5)
				target:PlayObjectSound("event:/animals/worm/worm_death",false)
			end
		end
		EndMobileEffect(root)
	end,
}