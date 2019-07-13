

-- caching some weapon information to local memory space since this only change when weapons are changed, 
	--- but the data is read from a lot.
_Weapon = {
	LeftHand = {
		Object = nil,
		Class = "Fist",
		Type = "BareHand",
		DamageType = "Bashing",
		SkillName = "BrawlingSkill",
		IsRanged = false,
		ShieldType = nil,
		Range = ServerSettings.Stats.DefaultWeaponRange,
		Speed = 5,
	},
	RightHand = {
		Object = nil,
		Class = "Fist",
		Type = "BareHand",
		DamageType = "Bashing",
		SkillName = "BrawlingSkill",
		IsRanged = false,
		Range = ServerSettings.Stats.DefaultWeaponRange,
		Speed = 5,
	}
}
-- function to update the cached weapon
function UpdateWeaponCache(slot, weaponObj)
	Verbose("Mobile", "UpdateWeaponCache", slot, weaponObj)
	-- when weaponObj is explicity false, we can skip GetEquippedObject
	if ( weaponObj == false ) then
		weaponObj = nil
	else
		weaponObj = weaponObj or this:GetEquippedObject(slot)
	end

	if ( slot == "LeftHand" and weaponObj ) then
		_Weapon.LeftHand = {
			Object = weaponObj,
			ShieldType = GetShieldType(weaponObj)
		}
		-- shields need nothing more
		if ( _Weapon.LeftHand.ShieldType ) then return end
	end

	local weaponType = nil
	if ( IsPlayerCharacter(this) ) then
		weaponType = Weapon.GetType(weaponObj)
	else
		-- mobs are balanced to default to BareHand
		weaponType = this:GetObjVar("AI-WeaponType") or "BareHand"
	end

	-- some 'weapons', torch for example, are non-combat.
	if ( 
		(
			EquipmentStats.BaseWeaponStats[weaponType]
			and
			EquipmentStats.BaseWeaponStats[weaponType].NoCombat == true
		)
		or
		slot == "LeftHand"
	) then
		_Weapon[slot] = { NoCombat = true }
		return
	end

	_Weapon[slot] = {
		Object = weaponObj,
		Type = weaponType,
		Class = Weapon.GetClass(weaponType),
		DamageType = Weapon.GetDamageType(weaponType),
		SkillName = Weapon.GetSkill(weaponType),
		AttackBonus = Weapon.GetAttackBonus(weaponObj),
		AccuracyBonus = Weapon.GetAccuracyBonus(weaponObj),
		IsRanged = Weapon.IsRanged(weaponType),
		Range = this:GetObjVar("WeaponRange") or Weapon.GetRange(weaponType),
		Speed = Weapon.GetSpeed(weaponType)
	}

	--DebugTable(_Weapon[slot])
end