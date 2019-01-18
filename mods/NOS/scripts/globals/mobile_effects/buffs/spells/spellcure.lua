MobileEffectLibrary.SpellNOSCure = 
{

	OnEnterState = function(self,root,target,args)
		-- TARGET REPRESENTS THE PERSON THAT APPLIED THE POISON
		self.Target = target
		
		local magery = GetSkillLevel(self.Target, "MagerySkill")
		local poisoning = GetSkillLevel(self.Target, "PoisoningSkill")
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
		self.ParentObj:SendMessage("ReducePoisonEffect", poisonLevel)
		EndMobileEffect(root)
	end,

	OnExitState = function(self,root)
	
	end,
}