--TODO Define Damage for shields

function GetEquipmentClass(equipObj)
	if(equipObj == nil) then return nil end
	local wepType = GetWeaponType(equipObj)
	if (wepType ~= nil) then return "WeaponClass" end
	local armType = GetArmorType(equipObj)
	if(armType ~= nil) then return "ArmorClass" end
	local shType = GetShieldType(equipObj)
	if(shType ~= nil) then return "ShieldClass" end
	--BBHack
	if(equipObj:HasModule("tool_base")) then return "ToolClass" end
	if(equipObj:HasModule("harvest_tool_base")) then return "HarvestToolClass" end
	
	return nil
end

-- This is the number of enhancement slots on the item (armor, weapon or shield)
function GetBaseNumSlots(equipObj)
	return 1
end

--[ Weapon Helpers ]--

-- returns "BareHand" by default
function GetWeaponType(weapon)
	return Weapon.GetType(weapon)
end

function GetWeaponClass(weapon)
	return Weapon.GetClass(Weapon.GetType(weapon))
end

function GetPrimaryWeapon(weaponHolder)
	return Weapon.GetPrimary(weaponHolder)
end

function GetPrimaryWeaponType(weaponHolder)
	return Weapon.GetType(Weapon.GetPrimary(weaponHolder))
end

function GetPrimaryWeaponSkill(mobileObj)
	return Weapon.GetSkill(Weapon.GetType(Weapon.GetPrimary(mobileObj)))
end

function IsTwoHandedWeapon(object)
	return Weapon.IsTwoHanded(Weapon.GetType(object))
end

function IsRangedWeapon(object)
	return Weapon.IsRanged(Weapon.GetType(object))
end

function GetWeaponDamageType(object)
	return Weapon.GetDamageType(Weapon.GetType(object))
end

function GetArmorStaRegenModifier(object, slot)
	local armorClass = GetArmorClass(object)
	if ( armorClass and EquipmentStats.BaseArmorClass[armorClass] ~= nil and EquipmentStats.BaseArmorClass[armorClass][slot] ~= nil ) then
		return EquipmentStats.BaseArmorClass[armorClass][slot].StaRegenModifier or 0
	end
	return 0
end

function GetArmorClassManaRegenModifier(object, slot)
	local armorClass = GetArmorClass(object)
	if ( armorClass and EquipmentStats.BaseArmorClass[armorClass] ~= nil and EquipmentStats.BaseArmorClass[armorClass][slot] ~= nil ) then
		return EquipmentStats.BaseArmorClass[armorClass][slot].ManaRegenModifier or 0
	end
	return 0
end

function GetArmorTypeManaRegenModifier(object, slot)
	local armorType = GetArmorType(object)
	if ( armorType and EquipmentStats.BaseArmorStats[armorType] ~= nil and EquipmentStats.BaseArmorStats[armorType][slot] ~= nil ) then
		return EquipmentStats.BaseArmorStats[armorType][slot].ManaRegenModifier or 0
	end
	return 0
end

-- This can avoid the extra get objvar call
function GetArmorClassFromType(armorType)
	if( armorType ~= nil and EquipmentStats.BaseArmorStats[armorType] ~= nil ) then
		return EquipmentStats.BaseArmorStats[armorType].ArmorClass
	end

	return "Cloth"
end

function GetArmorClass(object)
	return GetArmorClassFromType(GetArmorType(object))
end

function GetArmorType(object)
	if(object) then
		local armorType = object:GetObjVar("ArmorType") or "Natural"
		--DebugMessage(tostring("KHI ".. armorType))
		if not(EquipmentStats.BaseArmorStats[armorType]) then
			LuaDebugCallStack("Invalid armor type: "..tostring(armorType)..", Template: "..object:GetCreationTemplateId())
		else
			return armorType
		end
	end

	return "Natural"
end

-- we dont have unique sounds for every type of armor yet so use this
function GetArmorSoundType(armorClass)
	if ( EquipmentStats.BaseArmorStats[armorClass] ~= nil and EquipmentStats.BaseArmorStats[armorClass].SoundType ~= nil ) then
		return EquipmentStats.BaseArmorStats[armorClass].SoundType
	end
    return "Leather"
end

function GetArmorBaseStat(object,statName)
	local baseStat = GetArmorBaseStatInternal(object,statName)
	if( baseStat ~= nil ) then
		return baseStat
	end

	return 0
end

function GetArmorBonusStat(object,statName)
	local bonusStat = GetEquipmentBonusStatInternal(object,statName)
	if( bonusStat ~= nil ) then
		return bonusStat
	end

	return 0
end

-- you can pass either the base or bonus stat name in here
function GetArmorCombinedStat(object,statName)
	local strippedName = string.gsub(statName, "Base", "")
	strippedName = string.gsub(strippedName, "Bonus", "")
	
	return GetArmorBaseStat(object,"Base"..strippedName) + GetArmorBonusStat(object, "Bonus"..strippedName)
end

--[ Shield Helpers ]--

-- returns nil if not shield
function GetShieldType(object)
	if(object == nil) then return nil end
	return object:GetObjVar("ShieldType")
end

function GetShieldBaseStat(object,statName)
	local baseStat = GetShieldBaseStatInternal(object,statName)
	if( baseStat ~= nil ) then		
		return baseStat
	end

	return 0
end

function GetShieldBonusStat(object,statName)
	local bonusStat = GetEquipmentBonusStatInternal(object,statName)
	if( bonusStat ~= nil ) then
		return bonusStat
	end

	return 0
end

-- you can pass either the base or bonus stat name in here
function GetShieldCombinedStat(object,statName)
	local strippedName = string.gsub(statName, "Base", "")
	strippedName = string.gsub(strippedName, "Bonus", "")
	
	return GetShieldBaseStat(object,"Base"..strippedName) + 
				GetShieldBonusStat(object, "Bonus"..strippedName)
end

--[ Shi
--[ Internal Functions ]--

function GetArmorBaseStatInternal(object,statName)
	armorClass = GetArmorClass(object)

	if( armorClass ~= nil and EquipmentStats.BaseArmorStats[armorClass] ~= nil ) then
		return EquipmentStats.BaseArmorStats[armorClass][statName]
	end
end

function GetShieldBaseStatInternal(object,statName)
	shieldClass = GetShieldType(object)

	if( shieldClass ~= nil and EquipmentStats.BaseShieldStats[shieldClass] ~= nil ) then
		return EquipmentStats.BaseShieldStats[shieldClass][statName]
	end
end

function GetEquipmentBonusStatInternal(object,statName)
	if(object == nil) then return nil end
	bonusStat = object:GetObjVar(statName)
	if( bonusStat ~= nil ) then
		return bonusStat
	end

	return 0
end

function SetEquipmentBonusStat(object, statName, value)
	object:SetObjVar(statName, value)
	
end

function AlterEquipmentBonusStat(object, statName, value)
	--DebugMessage("AlterStat: " .. tostring(statName).. " on " .. object:GetName() .. " by " ..tostring(value))
	bonusStat = object:GetObjVar(statName)
	if( bonusStat == nil ) then
		bonusStat = 0
	end

	bonusStat = bonusStat + value
	object:SetObjVar(statName, bonusStat)	
end

function GetBaseArmorSlotsStats(wearer, statName)
	local baseStat = 0
	local totalStat = 0
	local armorObj = nil
	local baseStatMod = 1
	for  i=1 , 3 do
		armorObj = wearer:GetEquippedObject(ARMORSLOTS[i])
		if not(armorObj == nil) then
			baseStat = GetArmorBaseStat(armorObj, statName)
			if((ARMORSLOTS[i] == "Chest") and ((statName == "BaseEvasionModifier") or (statName == "BaseSwingModifier") or (statName == "BaseStaminaModifier"))) then
					baseStatMod = 2
			end
			baseStat = baseStat * baseStatMod
			baseStatMod = 1
			totalStat = totalStat + baseStat
		end	
	end

	return(totalStat)
end

function GetBonusArmorSlotsStats(wearer, statName)
	local totalStat = 0
	local armorObj = nil
	local bonusStatMod = 1
	local bonusStat = 0
	for  i=1 , 3 do
		armorObj = wearer:GetEquippedObject(ARMORSLOTS[i])
		if not(armorObj == nil) then
			bonusStat = GetArmorBonusStat(armorObj, statName)
			--DebugMessage(armorObj:GetName() .. " ".. statName .. " : " .. tostring(bonusStat))
			totalStat = totalStat + bonusStat
		end	
	end

	return(totalStat)
end

function GetModifierString(desc,baseValue,bonusValue, reverseStat)
	--LuaDebugCallStack("Where")
	if (bonusValue == nil) then bonusValue = 1 end
	local combinedValue = baseValue + bonusValue
	local modStr = "" 

	if( combinedValue == 0 ) then
		return ""
	elseif( combinedValue > 0 ) then
		modStr = "+" .. tostring(combinedValue) .. " " .. desc
	else
		modStr = tostring(combinedValue) .. " " .. desc
	end
	if(reverseStat == true) then bonusValue = -bonusValue end
	return ColorizeStatString(modStr,bonusValue) .. "\n"
end
