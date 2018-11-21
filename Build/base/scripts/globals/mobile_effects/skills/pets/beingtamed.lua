MobileEffectLibrary.BeingTamed = 
{

	OnEnterState = function(self,root,target,args)
		if ( target == nil ) then
			EndMobileEffect(root)
			return false
		end
		
        self.Target = target
        
        RegisterEventHandler(EventType.Message, "DamageInflicted", function(damager, damageAmount)
            if ( damageAmount > 0 ) then
                self.Target:SendMessage("DamageInflictedWhileBeingTamed")
            end
		end)
	end,

	OnExitState = function(self,root)
		UnregisterEventHandler("", EventType.Message, "DamageInflicted")
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Target = nil,
	Duration = TimeSpan.FromSeconds(30)
}