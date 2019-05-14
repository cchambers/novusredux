
CombatDamageType = {
    MAGIC = {
        Magic = true,
    },
	Frost = {
        Magic = true,
    },
    Fire = {
        Magic = true,
    },
    Energy = {
        Magic = true
    },
    Void = {
        Magic = true
    },
    Bashing = {
        Physical = true,
        Durability = true,
        Blockable = true,
    },
    Slashing = {
        Physical = true,
        Durability = true,
        Blockable = true,
    },
    Piercing = {
        Physical = true,
        Durability = true,
        Blockable = true,
    },
    Bow = {
        Physical = true,
        Durability = true,
        Blockable = true,
    },
	Poison = {
        NoGuards = true, -- this damage type does not call guards
    },
    Bleed = {
        NoGuards = true,
    },
	TrueDamage = {},
}

function CalculateDamageInfo(damageInfo)

    if not( damageInfo.Victim ) then return damageInfo end
    if not( damageInfo.Damage ) then damageInfo.Damage = 1 end
	if not( damageInfo.WeaponType ) then damageInfo.WeaponType = "BareHand" end
	if not( damageInfo.WeaponClass ) then damageInfo.WeaponClass = "Fist" end

	local typeData = CombatDamageType[damageInfo.Type]
	-- not a real combat damage type, stop here.
    if not( typeData ) then return end
    
    -- calculate damage blocked if blockable otherwise set to 0
	damageInfo.Blocked = typeData.Blockable and CalculateBlockDefense(damageInfo) or 0
    
    if ( typeData.Magic ) then

        damageInfo.Damage = (damageInfo.Attacker:GetStatValue("Power") * damageInfo.Damage) / 8

        -- calculate variance if not passed in
        if not( damageInfo.Variance ) then
            if ( damageInfo.Source and damageInfo.VictimIsPlayer ) then
                -- KH TODO: Make this configurable
                damageInfo.Variance = 0.05
            else
                -- DAB COMBAT CHANGES: Make this configurable
                damageInfo.Variance = 0.05
            end
        end

        damageInfo.Damage = randomGaussian(damageInfo.Damage, damageInfo.Damage * damageInfo.Variance)
        local attackerEval = GetSkillLevel(damageInfo.Attacker, "MagicAffinitySkill")
        local shouldResist = CheckSkill(damageInfo.Victim, "MagicResistSkill", attackerEval)
        local resistGainChance = CheckSkill(damageInfo.Victim, "MagicResistSkill")
        local resistLevel = GetSkillLevel(damageInfo.Victim, "MagicResistSkill")
        if (resistLevel < 40) then shouldResist = false end
        -- this:NpcSpeech(tostring(shouldResist))

        -- Boost spell power based on eval
        local damageLevel = (math.floor(attackerEval/35))
        if (damageLevel < 1.01) then damageLevel = 1.01 end
        damageInfo.Damage = damageInfo.Damage * damageLevel
        if (shouldResist) then
            -- successful magic resist, reduce damage by up to 40%
            damageInfo.Victim:NpcSpeechToUser("[1CB1DC]*resist*[-]", damageInfo.Attacker)
            damageInfo.Damage = damageInfo.Damage - DoResist(damageInfo.Victim, resistLevel, damageInfo.Damage)
        end
        -- if ( CheckActiveSpellResist(damageInfo.Victim) ) then
        --     -- successful magic resist, half base damage
        --     damageInfo.Damage = damageInfo.Damage * 0.5
        -- end
    end

    if ( typeData.Physical ) then
        if not( damageInfo.Attack ) then
            if ( damageInfo.Attacker and damageInfo.Attacker:IsValid() ) then
                damageInfo.Attack = damageInfo.Attacker:GetStatValue("Attack")
            else
                LuaDebugCallStack("ERROR: Attempting to calculate physical damage with no attacker")
            end
        end
    
        local defense = 1
        if ( HasMobileEffect(damageInfo.Victim, "Sunder") ) then
            -- end sunder, no armor defense reduction this hit
            damageInfo.Victim:SendMessage("EndSunderEffect")
        else
            defense = math.max(damageInfo.Victim:GetStatValue("Defense") or 0, defense)
        end
    
        damageInfo.Damage = ( damageInfo.Attack * 70 ) / (defense + (damageInfo.Blocked or 0))
    
        -- calculate variance if not passed in
        if not( damageInfo.Variance ) then
            if ( damageInfo.Source and damageInfo.VictimIsPlayer ) then
                damageInfo.Variance = EquipmentStats.BaseWeaponStats[damageInfo.WeaponType] and EquipmentStats.BaseWeaponStats[damageInfo.WeaponType].Variance or 0
            else
                -- DAB COMBAT CHANGES: Make this configurable
                damageInfo.Variance = 0.20
            end
        end
    
        damageInfo.Damage = randomGaussian(damageInfo.Damage, damageInfo.Damage * damageInfo.Variance)
    
        if ( damageInfo.Owner ~= nil ) then
            -- add damage buff to pet attacks
            if ( damageInfo.Owner:IsValid() and damageInfo.Victim:DistanceFrom(damageInfo.Owner) <= ServerSettings.Pets.Command.Distance ) then
                damageInfo.Damage = damageInfo.Damage * (0.5 + (1 * (GetSkillLevel(damageInfo.Owner, "BeastmasterySkill") / ServerSettings.Skills.PlayerSkillCap.Single) ) )
            end
        elseif ( damageInfo.Source ) then
            local executioner = damageInfo.Source:GetObjVar("Executioner")
            if ( executioner ~= nil and executioner == damageInfo.Victim:GetObjVar("MobileKind") ) then
                damageInfo.Damage = damageInfo.Damage * (
                    ServerSettings.Executioner.LevelModifier[
                        damageInfo.Source:GetObjVar("ExecutionerLevel") or 1
                    ] or 1
                )
            end
        end
    end
    
    if ( typeData.Durability ) then ApplyDamageDurability(damageInfo) end
    
    return damageInfo
end

function ApplyDamageDurability(damageInfo)
    if not( damageInfo.Victim ) then return end

    -- jewelry always has a chance to be damaged.
    if ( Success(ServerSettings.Durability.Chance.OnJewelryHit) ) then
        local item = damageInfo.Victim:GetEquippedObject(JEWELRYSLOTS[math.random(1,#JEWELRYSLOTS)])
        if ( item ) then
            AdjustDurability(item, -1)
        end
    end

    -- all but true damage/poison will also hurt the equipment.
    damageInfo.Slot = damageInfo.Slot or GetHitLocation()
    local hitItem = damageInfo.Victim:GetEquippedObject(damageInfo.Slot)
    local soundType = "Leather"
    if ( hitItem ~= nil ) then
        local hitArmorType = GetArmorType(hitItem)
        soundType = GetArmorSoundType(hitArmorType)	

        if ( damageInfo.VictimIsPlayer ) then
            -- damage equipment that was hit
            if ( Success(ServerSettings.Durability.Chance.OnEquipmentHit) ) then
                AdjustDurability(hitItem, -1)
            end

            -- perform proficiency check
            local armorClass = GetArmorClassFromType(hitArmorType)
            if ( (armorClass == "Light" or armorClass == "Heavy") and ValidCombatGainTarget(damageInfo.Attacker, damageInfo.Victim) ) then
                CheckSkill(damageInfo.Victim, string.format("%sArmorSkill", armorClass), GetSkillLevel(damageInfo.Attacker, EquipmentStats.BaseWeaponClass[damageInfo.WeaponClass].WeaponSkill))					
            end
        end
    end

    PlayWeaponSound(damageInfo.Attacker, "Impact" .. soundType, damageInfo.Source)
end

function CalculateBlockDefense(damageInfo)
	Verbose("Combat", "CalculateBlockDefense", damageInfo)
	local shield = damageInfo.Victim:GetEquippedObject("LeftHand")
	if not( shield ) then return 0 end
	local shieldType = GetShieldType(shield)
	if ( shieldType and EquipmentStats.BaseShieldStats[shieldType] ) then
		-- skill gain dependant on the attacker's weapon skill level
		CheckSkill(damageInfo.Victim, "BlockingSkill", GetSkillLevel(damageInfo.Attacker,EquipmentStats.BaseWeaponClass[damageInfo.WeaponClass].WeaponSkill))
		if ( Success(GetSkillLevel(damageInfo.Victim, "BlockingSkill")/335) ) then
			damageInfo.Victim:PlayAnimation("block")
			if ( Success(ServerSettings.Durability.Chance.OnEquipmentHit) ) then
				AdjustDurability(shield, -1)
			end
			return math.max(0, (EquipmentStats.BaseShieldStats[shieldType].ArmorRating or 0) + GetMagicItemArmorBonus(damageInfo.WeaponClass))
		end
    end
    return 0
end
