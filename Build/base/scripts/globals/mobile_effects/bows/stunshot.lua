

MobileEffectLibrary.StunShot = 
{

	OnEnterState = function(self,root,target,args)
		if ( target == nil ) then
			EndMobileEffect(root)
			return
		end
		self.Duration = args.Duration or self.Duration
		self.PlayerDuration = args.PlayerDuration or self.PlayerDuration
		
		if ( target:IsPlayer() ) then
			target:SendMessage("StartMobileEffect", "Stun", self.ParentObj, {Duration = self.PlayerDuration})
		else
			target:SendMessage("StartMobileEffect", "Stun", self.ParentObj, {Duration = self.Duration})
			target:SendMessage("AddThreat", self.ParentObj, 1)
		end
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),
	PlayerDuration = TimeSpan.FromSeconds(1)
}