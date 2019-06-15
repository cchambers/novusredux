MobileEffectLibrary.Meditation = 
{
	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		
		RegisterEventHandler(EventType.Message, "BreakInvisEffect", function (what)
			if ( what ~= "Pickup" ) then
				EndMobileEffect(root)
			end
		end)
		RegisterEventHandler(EventType.StartMoving,"", function () EndMobileEffect(root) end)
		self.ParentObj:StopMoving()
		if ( IsInCombat(self.ParentObj) ) then
			self.ParentObj:SendMessage("EndCombatMessage")
		end

		--Sound effect
		self.ParentObj:PlayObjectSound("event:/magic/misc/magic_water_greater_heal")

		local skillLevel = GetSkillLevel(self.ParentObj,"ManifestationSkill")
		SetMobileMod(self.ParentObj, "ManaRegenPlus", "Meditation", math.floor(skillLevel / 10) / 2)
		self.ParentObj:PlayEffect("StrangerEffect", 0.0)
		AddBuffIcon(self.ParentObj, "Meditation", "Meditation", "Night", "Increased Mana Regeneration.", false)

	end,

	OnExitState = function(self,root)
		RemoveBuffIcon(self.ParentObj, "Meditation")
		self.ParentObj:StopEffect("StrangerEffect")
		SetMobileMod(self.ParentObj, "ManaRegenPlus", "Meditation", nil)
		UnregisterEventHandler("",EventType.Message,"BreakInvisEffect")
		UnregisterEventHandler("",EventType.StartMoving, "")
	end,

	GetPulseFrequency = function(self,root)
		return TimeSpan.FromSeconds(30)
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,
	
	Duration = TimeSpan.FromSeconds(30),
}
