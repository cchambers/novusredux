MobileEffectLibrary.SpellPoison = 
{
	OnEnterState = function(self,root,caster,args)
		-- TARGET REPRESENTS THE PERSON THAT APPLIED THE POISON
		self.Caster = caster

		local magery = GetSkillLevel(self.Caster, "MagerySkill")
		local poisoning = GetSkillLevel(self.Caster, "PoisoningSkill")
		local percent = magery / ServerSettings.Skills.PlayerSkillCap.Single
		local poisonLevel = 1

		if (magery >= 65 and poisoning >= 65) then 
			poisonLevel = 2
		end
		
		if (magery >= 90 and poisoning >= 90) then 
			poisonLevel = 3
		end
		
		if (magery >= 100 and poisoning >= 100) then 
			poisonLevel = 4
		end

		StartMobileEffect(self.ParentObj, "Poison", self.Caster, {
			PoisonLevel = poisonLevel
		})

		EndMobileEffect(root)
		return false
	end,
}