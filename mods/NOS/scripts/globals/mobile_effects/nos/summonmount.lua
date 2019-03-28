MobileEffectLibrary.SummonMount = 
{
	OnEnterState = function(self,root,target,args)
		local skill = GetSkillLevel(self.ParentObj, "Magery")
		local lore = GetSkillLevel(self.ParentObj, "AnimalLore")
		
		self.Duration = TimeSpan.FromSeconds((skill / 10) * 60)
		self.ParentObj:SetObjVar("SpiritSpoken", 0)

		RegisterEventHandler(EventType.Message, "DamageInflicted", function(damager, damageAmount)
			if ( damageAmount > 0 ) then
				EndMobileEffect(root)
			end
		end)
	end,

	OnExitState = function(self,root)
		-- dismount, destroy mount
		UnregisterEventHandler("", EventType.Message, "DamageInflicted")
		return
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,
	
	Duration = TimeSpan.FromSeconds(60),
}
