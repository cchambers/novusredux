MobileEffectLibrary.BeingCalmed = 
{

	OnEnterState = function(self,root,tamer)
		if ( tamer == nil ) then
			EndMobileEffect(root)
			return false
		end
		
		self.Tamer = tamer

		tamer:SystemMessage(tostring("You begin calming the " .. self.ParentObj:GetName()), "info")
		
		self.isAggressive = self.ParentObj:HasModule("combat")
		
		if (self.isAggressive) then
			self.ParentObj:DelModule("combat")
		end
		self.ParentObj:SendMessage("StartMobileEffect", "GodFreeze")
		
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
		self.ParentObj:SendMessage("EndGodFreezeEffect")
		
		if (self.isAggressive) then
			self.ParentObj:AddModule("combat")
		end
		EndMobileEffect(root)
	end,

	Tamer = nil,
	isAggressive = false,
	Duration = TimeSpan.FromSeconds(10)
}