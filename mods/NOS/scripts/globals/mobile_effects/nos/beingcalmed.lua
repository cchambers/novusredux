MobileEffectLibrary.BeingCalmed = 
{

	OnEnterState = function(self,root,calmer)
		if ( calmer == nil ) then
			EndMobileEffect(root)
			return false
		end
		
		self.Calmer = calmer

		calmer:SystemMessage(tostring("You begin calming the " .. self.ParentObject:GetName()))
		
		self.isAggressive = self.ParentObject:HasModule("combat")
		
		if (self.isAggressive) then
			self.ParentObject:DelModule("combat")
		end
		self.ParentObject:SendMessage("StartMobileEffect", "GodFreeze")
		
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
		self.ParentObject:SendMessage("EndGodFreezeEffect")
		
		if (self.isAggressive) then
			self.ParentObject:AddModule("combat")
		end
		EndMobileEffect(root)
	end,

	Target = nil,
	isAggressive = false,
	Duration = TimeSpan.FromSeconds(30)
}