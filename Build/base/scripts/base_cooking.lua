
foodBonusTable = {
		["BonusPotency"] = true,
		["BonusDuration"] = true,
		["BonusFillingness"] = true,
		["BonusPreservation"] = true,
		["HealthRegenMod"] = true, 
		["StaminaRegenMod"] = true, 
		["ManaRegenMod"] = true,

}


function GetMaxIngredients(objChef)
	local cookSkill = GetSkillLevel(objChef,SK_COOKING)
	if(cookSkill == nil) then
		objChef:SystemMessage("[$1621]","info")
		return 0
	end
	if(cookSkill == 0) then 
		return 1
	end

	return (cookSkill / 16) + 1

end



