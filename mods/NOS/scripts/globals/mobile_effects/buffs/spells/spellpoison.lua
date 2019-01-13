MobileEffectLibrary.SpellPoison = 
{
	OnEnterState = function(self,root,target,args)
		-- TARGET REPRESENTS THE PERSON THAT APPLIED THE POISON
		self.Target = target

		local magery = GetSkillLevel(self.Target, "MagerySkill")
		local percent = magery / ServerSettings.Skills.PlayerSkillCap.Single

		StartMobileEffect(self.ParentObj, "Poison", self.Target, {
			MinDamage = math.max(1, 1 * percent),
			MaxDamage = math.max(1, 3 * percent),
			PulseMax = math.max(1, 6),
		})

		EndMobileEffect(root)
		return false
	end,
}