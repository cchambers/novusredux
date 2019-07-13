function UpdateEquipmentSkillBonuses(target, item)
	local skillBonuses = {}
	for i,equipObj in pairs(target:GetAllEquippedObjects()) do
		if( equipObj:HasObjVar("SkillBonus") ) then
			local skillName = equipObj:GetObjVar("SkillBonusName")
			local skillBonusIndex = equipObj:GetObjVar("SkillBonus") or 0
			if ( skillBonusIndex > 0 and skillBonusIndex <= #MagicItemSkillModifiers ) then
				if ( skillBonuses[skillName] == nil ) then
					skillBonuses[skillName] = MagicItemSkillModifiers[skillBonusIndex]
				else
					skillBonuses[skillName] = skillBonuses[skillName] + MagicItemSkillModifiers[skillBonusIndex]
				end
			end
			if ( skillBonuses[skillName] > MagicItemSkillModifierMax ) then
				skillBonuses[skillName] = MagicItemSkillModifierMax
			end
		end
	end
	local skillDictionary = GetSkillDictionary(target)
	for skill,data in pairs(skillDictionary) do
		skillDictionary[skill].SkillBonus = skillBonuses[skill]
	end
	SetSkillDictionary(target, skillDictionary)
	if ( item ~= nil and item:HasObjVar("SkillBonusName") ) then
		target:SendMessage("UpdateClientSkill", item:GetObjVar("SkillBonusName").."Skill")
	end
	return false
end