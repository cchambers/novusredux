
Weapon = {}

Weapon.GetPrimary = function(mobileObj)
	if ( mobileObj ~= nil ) then
		return mobileObj:GetEquippedObject("RightHand")
	end
	return nil
end

Weapon.GetType = function(weaponObj)
	if ( weaponObj ~= nil ) then		
		local weaponType = weaponObj:GetObjVar("WeaponType") or "BareHand"
		if not( EquipmentStats.BaseWeaponStats[weaponType] ) then
			LuaDebugCallStack("Invalid weapon type: "..tostring(weaponType)..", Template: "..weaponObj:GetCreationTemplateId())
		else
			return weaponType
		end
	end
	return "BareHand"
end

Weapon.GetClass = function(weaponType)
	weaponType = weaponType or "BareHand"
	local ES = EquipmentStats
	if ( ES.BaseWeaponStats[weaponType] ) then
		return ES.BaseWeaponStats[weaponType].WeaponClass
	end
	return "Fist"
end

Weapon.GetSpeed = function(weaponType)
	weaponType = weaponType or "BareHand"
	local ES = EquipmentStats
	if ( ES.BaseWeaponStats[weaponType] ) then
		return ES.BaseWeaponStats[weaponType].Speed
	end
	return 5
end

Weapon.GetSkill = function(weaponType)
	local ES = EquipmentStats
	if ( weaponType and ES.BaseWeaponStats[weaponType] 
		and ES.BaseWeaponStats[weaponType].WeaponClass 
		and ES.BaseWeaponClass[ES.BaseWeaponStats[weaponType].WeaponClass]
		and ES.BaseWeaponClass[ES.BaseWeaponStats[weaponType].WeaponClass].WeaponSkill ) then
		return ES.BaseWeaponClass[ES.BaseWeaponStats[weaponType].WeaponClass].WeaponSkill
	end
	return "BashingSkill"
end

Weapon.GetDamageType = function(weaponType)
	local ES = EquipmentStats
	if ( weaponType and ES.BaseWeaponStats[weaponType] 
		and ES.BaseWeaponStats[weaponType].WeaponClass 
		and ES.BaseWeaponClass[ES.BaseWeaponStats[weaponType].WeaponClass]
		and ES.BaseWeaponClass[ES.BaseWeaponStats[weaponType].WeaponClass].WeaponDamageType ) then
		return ES.BaseWeaponClass[ES.BaseWeaponStats[weaponType].WeaponClass].WeaponDamageType
	end
	return "Bashing"
end

Weapon.GetRange = function(weaponType)
	local ES = EquipmentStats
	if ( weaponType and ES.BaseWeaponStats[weaponType] 
		and ES.BaseWeaponStats[weaponType].WeaponClass 
		and ES.BaseWeaponClass[ES.BaseWeaponStats[weaponType].WeaponClass]
		and ES.BaseWeaponClass[ES.BaseWeaponStats[weaponType].WeaponClass].Range ) then
		return ES.BaseWeaponClass[ES.BaseWeaponStats[weaponType].WeaponClass].Range
	end
	return ServerSettings.Stats.DefaultWeaponRange
end

Weapon.IsRanged = function(weaponType)
	return ( weaponType and EquipmentStats.BaseWeaponStats[weaponType] and (
		EquipmentStats.BaseWeaponStats[weaponType].WeaponClass == "Bow"
		--or EquipmentStats.BaseWeaponStats[weaponType].WeaponClass == "Bow" -- as an example to check for a secondary Class
	))
end

Weapon.IsTwoHanded = function(weaponType)
	return ( weaponType and EquipmentStats.BaseWeaponStats[weaponType].TwoHandedWeapon )
end

Weapon.GetAttackBonus = function(weaponObj)
	if ( weaponObj == nil ) then return 0 end
	return weaponObj:GetObjVar("AttackBonus") or 0
end