MobileEffectLibrary.Paralyze = 
{
	OnEnterState = function(self,root,target,args)
		-- disable movement, casting, actions, etc.
		local caster = target
		local casterEval = GetSkillLevel(caster, "MagicAffinitySkill")
		local targetResist = GetSkillLevel(self.ParentObj, "MagicAffinitySkill")


		self.Duration = TimeSpan.FromSeconds((casterEval/10) - (targetResist/10))

		if (self.Duration <= 0) then
			EndMobileEffect(root)
			return
		end

		if (not(self.ParentObj:IsPlayer()) then
			self.Duration = self.Duration * 3
		else
			self.ParentObj:SystemMessage("You have been paralyzed!", "info")
		end
		self.ParentObj:NpcSpeech("*paralyzed*")
		SetMobileMod(self.ParentObj, "Disable", "Paralyze", true)

		RegisterEventHandler(EventType.Message,"DamageInflicted",
		function (damager,damageAmt)
			if(damageAmt > 0) then
				EndMobileEffect(root)
			end
		end)
	end,

	OnExitState = function(self,root)
		SetMobileMod(self.ParentObj, "Disable", "Paralyze", nil)
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(5),
}