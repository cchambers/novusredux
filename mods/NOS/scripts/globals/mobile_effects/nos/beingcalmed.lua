MobileEffectLibrary.BeingCalmed = 
{

	OnEnterState = function(self,root,calmer)
		if ( calmer == nil ) then
			EndMobileEffect(root)
			return false
		end
		
        self.Calmer = calmer
		
		self.parentObject:DelModule("combat")
		self.parentObject:SendMessage("StartMobileEffect", "GodFreeze")
		
        RegisterEventHandler(EventType.Message, "DamageInflicted", function(damager, damageAmount)
            if ( damageAmount > 0 ) then
                self.Target:SendMessage("DamageInflictedWhileBeingCalmed")
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
		self.parentObject:SendMessage("EndGodFreezeEffect")
		self.parentObject:AddModule("combat")
		EndMobileEffect(root)
	end,

	Target = nil,
	Duration = TimeSpan.FromSeconds(30)
}