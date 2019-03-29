MobileEffectLibrary.Paralyze = 
{
	OnEnterState = function(self,root,target,args)
		-- disable movement, casting, actions, etc.
		local caster = target
		local casterEval = GetSkillLevel(caster, "MagicAffinitySkill")
		local targetResist = GetSkillLevel(self.ParentObj, "MagicResistSkill")

		if (casterEval == 0) then casterEval = 1 end
		if (targetResist == 0) then targetResist = 1 end

		local length = (casterEval/10) - (targetResist/10)

		if (length <= 0) then
			caster:SystemMessage("Target resist is too strong.","info")
			EndMobileEffect(root)
			return
		end

		if (not(self.ParentObj:IsPlayer())) then
			length = length * 3
		else
			self.ParentObj:SystemMessage("You have been paralyzed!", "info")
		end

		self.Duration = TimeSpan.FromSeconds(length)
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