-- Simple barebones to be a timer and handle stacking.

MobileEffectLibrary.Immune = 
{

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration

		-- remove all debuffs when entering
		ClearDebuffs(self.ParentObj)
	end,

	OnExitState = function(self,root)
	end,

	OnStack = function(self,root,target,args)
		local timerId = string.format("%s-%s", root.PulseId, root.CurStateName)
		local duration = args.Duration or TimeSpan.FromSeconds(0.5)
		local timerDelay = self.ParentObj:GetTimerDelay(timerId)
		-- if the new duration is greater than the duration that's remaining
		if ( timerDelay ~= nil and duration.TotalSeconds > timerDelay.TotalSeconds ) then
			-- set timer to the new duration
			root.ParentObj:ScheduleTimerDelay(duration, timerId)
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),
}