MobileEffectLibrary.StunStrike = 
{

	OnEnterState = function(self,root,target,args)
		self.Radius = args.Radius or self.Radius
		self.Duration = args.Duration or TimeSpan.FromSeconds(2)
		self.PlayerDuration = args.PlayerDuration or TimeSpan.FromSeconds(1)

		local nearbyMobiles = FindObjects(SearchMobileInRange(self.Radius,true))
        for i,mobile in pairs (nearbyMobiles) do
        	if ( ValidCombatTarget(self.ParentObj, mobile, true) and InFrontOf(self.ParentObj, mobile) ) then
        		if ( IsPlayerCharacter(mobile) ) then
        			mobile:SendMessage("StartMobileEffect", "Stun", self.ParentObj, {Duration = self.PlayerDuration})
        		else
        			mobile:SendMessage("StartMobileEffect", "Stun", self.ParentObj, {Duration = self.Duration})
        		end
        	end
        end

        self.ParentObj:PlayEffect("ShoutEffect")
        self.ParentObj:PlayAnimation("shield_bash")
        self.ParentObj:PlayObjectSound("ShieldBash")

		EndMobileEffect(root)
	end,

	GetPulseFrequency = nil,

	Duration,
	PlayerDuration,
	Radius = 1,
	Args = {},
}