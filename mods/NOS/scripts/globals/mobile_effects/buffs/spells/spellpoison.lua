MobileEffectLibrary.SpellPoison = 
{
	OnEnterState = function(self,root,target,args)
		-- TARGET REPRESENTS THE PERSON THAT APPLIED THE POISON
		self.Target = target

		local magery = GetSkillLevel(self.Target, "MagerySkill")
		local percent = magery / ServerSettings.Skills.PlayerSkillCap.Single
		local poisonLevel = 1

		if (magery >= 65) then 
			poisonLevel = 2
		end
		
		if (magery >= 90) then 
			poisonLevel = 3
		end
		
		if (magery >= 100) then 
			poisonLevel = 4
		end

		StartMobileEffect(self.ParentObj, "Poison", self.Target, {
			PoisonLevel = poisonLevel
		})

		EndMobileEffect(root)
		return false
	end,
}