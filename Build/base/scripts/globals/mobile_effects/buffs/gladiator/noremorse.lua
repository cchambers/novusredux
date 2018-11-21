MobileEffectLibrary.NoRemorse = 
{
	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		AddBuffIcon(self.ParentObj, "NoRemorse", "No Remorse", "Force Push 02", "Delivering a finishing blow resets all cooldowns.", true)
		RegisterSingleEventHandler(EventType.Message, "VictimKilled", function(victim, damage)
			-- clear all cooldowns
			for i=1,3 do
				local class, abilityName = GetSlottedPrestigeAbility(self.ParentObj,i)
				ResetPrestigeCooldown(self.ParentObj, class, abilityName)
			end
		end)
	end,

	OnExitState = function(self,root)
		RemoveBuffIcon(self.ParentObj, "NoRemorse")
		UnregisterEventHandler("", EventType.Message, "VictimKilled")
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),
}