MobileEffectLibrary.ShieldBash = 
{

	OnEnterState = function(self,root,target,args)
		if ( target == nil ) then
			EndMobileEffect(root)
			return
		end
		self.Radius = args.Radius or self.Radius
		self.Duration = args.Duration or TimeSpan.FromSeconds(2)
		self.PlayerDuration = args.PlayerDuration or TimeSpan.FromSeconds(1)

		if ( target:IsPlayer() ) then
			target:SendMessage("StartMobileEffect", "Stun", self.ParentObj, {Duration = self.PlayerDuration})
		else
			target:SendMessage("StartMobileEffect", "Stun", self.ParentObj, {Duration = self.Duration})
		end

        self.ParentObj:PlayEffect("ShoutEffect")
        self.ParentObj:PlayAnimation("shield_bash")
        self.ParentObj:PlayObjectSound("ShieldBash")

		EndMobileEffect(root)
	end,

	GetPulseFrequency = nil,

	Duration,
	PlayerDuration,
}