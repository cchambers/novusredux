MobileEffectLibrary.Charge = 
{

	OnEnterState = function(self,root,target,args)
		if ( target == nil ) then
			EndMobileEffect(root)
			return false
		end
		-- stun duration
		self.Duration = args.Duration or self.Duration

		SetMobileMod(self.ParentObj, "Freeze", "Charge", true)

		local delay = TimeSpan.FromSeconds(0.5)

		if ( args.Instant == true ) then
			delay = TimeSpan.FromMilliseconds(1)
		else
			-- do a shout animation here
			self.ParentObj:PlayAnimation("roar")
		end

		CallFunctionDelayed(delay, function()
			SetMobileMod(self.ParentObj, "Freeze", "Charge", nil)
			local targetLoc = target:GetLoc()
			self.ParentObj:PathTo(targetLoc:Project(targetLoc:YAngleTo(self.ParentObj:GetLoc()), GetBodySize(target)), 14, "",IsPlayerCharacter(self.ParentObj), true)
			target:SendMessage("StartMobileEffect", "Stun", self.ParentObj, {Duration=self.Duration})
			EndMobileEffect(root)
		end)
	end,

	OnExitState = function(self,root)
		self.ParentObj:ClearPathTarget()
	end,

	GetPulseFrequency = function(self,root)
		return TimeSpan.FromSeconds(2.5)
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = nil,
}