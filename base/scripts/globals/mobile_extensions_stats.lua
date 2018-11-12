function RecalculateDerivedStat(target,statsToRecalculate)
	--LuaDebugCallStack("RecalculateStats: " .. DumpTable(statsToRecalculate))
	target:SendMessage("RecalculateStats",statsToRecalculate)
end

-- Stat modifiers
-- Args
--     statModName: the name of the stat to modify (right now we old support regen modifiers)
--     statModIdentifier: the identifier of this particular mod (so it can be removed later)
--     statModType: the type of modifier (bonus or multiplier)
--     statModValue: the actual modifier value
-- Available stat modifier names
--     HealthRegenMod
--     ManaRegenMod
--     StaminaRegenMod
--	   VitalityRegenMod
--     HealingMod
--     StrengthMod
--     AgilityMod
--     IntelligenceMod
--     AttackSpeedMod
--     DamageMod

function RequestAddStatMod(target, statModName, statModIdentifier, statModType, statModValue, statModTime)
	LuaDebugCallStack("[DEPRECIATED] AddStatMod has been replaced with SetMobileMod.")
	--target:SendMessage("AddStatMod",statModName,statModIdentifier, statModType,statModValue,statModTime)
end

-- Args
--     statModName: the name of the stat to remove (right now we old support regen modifiers)
--     statModIdentifier: the identifier the mod to remove
function RequestRemoveStatMod(target, statModName, statModIdentifier)
	LuaDebugCallStack("[DEPRECIATED] AddStatMod has been replaced with SetMobileMod.")
	--target:SendMessage("RemoveStatMod",statModName,statModIdentifier)
end

-- Old code.
function HasStatMod(target, statModName, statModIdentifier)
	LuaDebugCallStack("[DEPRECIATED] AddStatMod has been replaced with SetMobileMod.")
	return false
end

function GetStatMod(target, statModName, statModIdentifier)
	LuaDebugCallStack("[DEPRECIATED] AddStatMod has been replaced with SetMobileMod.")
	return nil
end

function GetScriptStatMods(target,statModName)
	LuaDebugCallStack("[DEPRECIATED] AddStatMod has been replaced with SetMobileMod.")
	return 0, 1
end

-- Base stats

function GetBaseStr(target)	
	return target:GetObjVar("AttrStr") or ServerSettings.Stats.IndividualStatMin
end

function GetBaseAgi(target)
	return target:GetObjVar("AttrAgi") or ServerSettings.Stats.IndividualStatMin
end

function GetBaseInt(target)
	return target:GetObjVar("AttrInt") or ServerSettings.Stats.IndividualStatMin
end

function GetBaseCon(target)
	return target:GetObjVar("AttrCon") or ServerSettings.Stats.IndividualStatMin
end

function GetBaseWis(target)
	return target:GetObjVar("AttrWis") or ServerSettings.Stats.IndividualStatMin
end

function GetBaseWill(target)
	return target:GetObjVar("AttrWill") or ServerSettings.Stats.IndividualStatMin
end

function GetStr(target)
	return target:GetStatValue("Str") or ServerSettings.Stats.IndividualStatMin
end

function GetAgi(target)
	return target:GetStatValue("Agi") or ServerSettings.Stats.IndividualStatMin
end

function GetInt(target)
	return target:GetStatValue("Int") or ServerSettings.Stats.IndividualStatMin
end

function GetCon(target)
	return target:GetStatValue("Con") or ServerSettings.Stats.IndividualStatMin
end

function GetWis(target)
	return target:GetStatValue("Wis") or ServerSettings.Stats.IndividualStatMin
end

function GetWill(target)
	return target:GetStatValue("Will") or ServerSettings.Stats.IndividualStatMin
end

-- Helper to let you access stat by string
function GetBaseStatValue(target, statName)
	if(statName == "Strength" or statName == "Str" or statName == "str")  then return GetBaseStr(target) end
	if(statName == "Agility"  or statName == "Agi" or statName == "agi") then return GetBaseAgi(target) end
	if(statName == "Intelligence" or statName == "Int" or statName == "int") then return GetBaseInt(target) end
	if(statName == "Constitution" or statName == "Con" or statName == "con") then return GetBaseCon(target) end
	if(statName == "Wisdom" or statName == "Wis" or statName == "wis") then return GetBaseWis(target) end
	if(statName == "Will" or statName == "will" or statName == "wil") then return GetBaseWill(target) end
	return 0
end

function SetStr(target,newValue)	
	target:SetObjVar("AttrStr",newValue)

	RecalculateDerivedStat(target,{Strength=true})
end

function SetAgi(target,newValue)
	target:SetObjVar("AttrAgi",newValue)

	RecalculateDerivedStat(target,{Agility=true})
end

function SetInt(target,newValue)
	target:SetObjVar("AttrInt",newValue)

	RecalculateDerivedStat(target,{Intelligence=true})
end

function SetCon(target,newValue)
	target:SetObjVar("AttrCon",newValue)

	RecalculateDerivedStat(target,{Constitution=true})
end

function SetWis(target,newValue)
	target:SetObjVar("AttrWis",newValue)

	RecalculateDerivedStat(target,{Wisdom=true})
end

function SetWill(target,newValue)
	target:SetObjVar("AttrWill",newValue)

	RecalculateDerivedStat(target,{Will=true})
end

function SetStatByName(target, statName, newVal)	
	if(statName == "Strength" or statName == "Str" or statName == "str") then SetStr(target,newVal) end
	if(statName == "Agility"  or statName == "Agi" or statName == "agi") then SetAgi(target,newVal) end
	if(statName == "Intelligence" or statName == "Int" or statName == "int") then SetInt(target,newVal) end
	if(statName == "Constitution" or statName == "Con" or statName == "con") then SetCon(target,newVal) end
	if(statName == "Wisdom" or statName == "Wis" or statName == "wis") then return SetWis(target,newVal) end
	if(statName == "Will" or statName == "will" or statName == "wil") then return SetWill(target,newVal) end
	--if(target:IsPlayer()) then
		--target:SystemMessage("[F7CC0A]" .. statName .. " changed to " ..tostring(newVal))
	--end
end

function GetTotalStats (target)
	return GetStr(target) + GetAgi(target) + GetInt(target) + GetCon(target) + GetWis(target) + GetWill(target)
end

function GetTotalBaseStats (target)
	return GetBaseStr(target) + GetBaseAgi(target) + GetBaseInt(target) + GetBaseCon(target) + GetBaseWis(target) + GetBaseWill(target)
end

function GetStatCap (target)
	if(target:IsPlayer() or target:HasObjVar("HasSkillCap")) then 
		return ServerSettings.Stats.TotalPlayerStatsCap
	end
	
	return ServerSettings.Stats.TotalNPCStatsCap
end

-- Poolable stats (health, mana, stamina, vitality)

function GetCurHealth(target)	
	return target:GetStatValue("Health")
end

function GetCurStamina(target)
	return target:GetStatValue("Stamina")
end

function GetCurMana(target)
	return target:GetStatValue("Mana")
end

function GetCurVitality(target)
	return target:GetStatValue("Vitality")
end

function SetCurHealth(target,newValue)	
	target:SetStatValue("Health",math.clamp(newValue, 0, GetMaxHealth(target)))
end

function SetCurStamina(target,newValue)
	target:SetStatValue("Stamina",math.clamp(newValue, 0, GetMaxStamina(target)))
	RecalculateDerivedStat(target,{AttackSpeed=true})
	RecalculateDerivedStat(target,{MoveSpeed=true})
end

function SetCurMana(target,newValue)
	target:SetStatValue("Mana",math.clamp(newValue, 0, GetMaxMana(target)))
end

function SetCurVitality(target,newValue)	
	target:SetStatValue("Vitality",newValue)
end

function AdjustCurHealth(target,delta)
	target:SetStatValue("Health",target:GetStatValue("Health") + delta)
end

function AdjustCurStamina(target,delta)
	target:SetStatValue("Stamina",target:GetStatValue("Stamina") + delta)
	RecalculateDerivedStat(target,{AttackSpeed=true})
	RecalculateDerivedStat(target,{MoveSpeed=true})
end

function AdjustCurMana(target,delta)
	target:SetStatValue("Mana",target:GetStatValue("Mana") + delta)
end

function AdjustCurVitality(target,delta)
	target:SetStatValue("Vitality",target:GetStatValue("Vitality") + delta)
end

function GetHealthRegen(target)
	return target:GetStatRegenRate("Health")
end

function GetStaminaRegen(target)
	return target:GetStatRegenRate("Stamina")
end

function GetManaRegen(target)
	return target:GetStatRegenRate("Mana")
end

function GetVitalityRegen(target)
	return target:GetStatRegenRate("Vitality")
end

function GetMaxHealth(target)
	return target:GetStatMaxValue("Health")
end

function GetMaxStamina(target)
	return target:GetStatMaxValue("Stamina")
end

function GetMaxMana(target)
	return target:GetStatMaxValue("Mana")
end

function GetMaxVitality(target)
	return target:GetStatMaxValue("Vitality")
end