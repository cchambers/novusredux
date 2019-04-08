-- These stats are reset and recalculated on login/logout 
-- start with all stats dirty
statsToRecalculate = {
	HealthRegen = true, 
	ManaRegen = true,
	StaminaRegen = true,
	Strength = true,
	Agility = true,
	Intelligence = true,
	Constitution = true,
	Wisdom = true,
	Will = true,
	Accuracy = true,
	Evasion = true,
	Attack = true,
	Power = true,
	Force = true,
	Defense = true,
	AttackSpeed = true,
	CritChance = true,
	CritChanceReduction = true,
	MoveSpeed = true,
	MountMoveSpeed = true,
}

function GetEquipmentEffects()
	-- KHI loop through all jewelry/armor and
	-- check MATERIAL if armor or weapon or 
	-- if jewelry, item:GetObjVar("Effects") [table] 
	return true
end

if(IsPlayerCharacter(this)) then
	statsToRecalculate.MaxVitality = true
	statsToRecalculate.VitalityRegen = true
end

function RecalculateHealthRegen()
	-- checks to see if disabled before calculating regen
	if(this:HasObjVar("NoRegen") or IsDead(this)) then
		this:SetObjVar("HealthRegen",0)
		this:SetStatRegenRate("Health",0)
	else
		this:SetStatRegenRate("Health", (ServerSettings.Stats.BaseHealthRegenRate + GetMobileMod(MobileMod.HealthRegenPlus)) *GetMobileMod(MobileMod.HealthRegenTimes, 1) )
	end

end

function RecalculateManaRegen()

	local manaRegen = this:GetObjVar("ManaRegen")
	if not( manaRegen ) then
		if ( IsPlayerCharacter(this) ) then
			
			local channeling = GetSkillLevel(this, "ChannelingSkill")
			local skillMod = 1
			if ( channeling >= 100 ) then
				skillMod = skillMod + 0.1
			end

			-- get the lowest armor mana regen mod from equipped armor
			local armorModifier = 1 -- start at the max mod possible
			for i,slot in pairs(ARMORSLOTS) do
				local item = this:GetEquippedObject(slot)
				if ( item ) then
					local classRegen = GetArmorClassManaRegenModifier(item, slot)
					if ( classRegen < armorModifier ) then armorModifier = classRegen end
				end
			end

		
			-- double the modifier for active focusing
			if ( HasMobileEffect(this, "Focus") ) then
				armorModifier = armorModifier * 2
			end
			
			manaRegen = (skillMod * (channeling*4/400+GetInt(this)/400) * armorModifier)

			--[[ TODO: Re-enabled per item mana regen bonus
			for i,slot in pairs(ARMORSLOTS) do
				local item = this:GetEquippedObject(slot)
				if ( item ) then
					manaRegen = manaRegen + GetArmorTypeManaRegenModifier(item, slot)
				end
			end
			]]
		else
			manaRegen = ServerSettings.Stats.DefaultMobManaRegen
		end
	end


	this:SetStatRegenRate("Mana", (ServerSettings.Stats.BaseManaRegenRate + manaRegen + GetMobileMod(MobileMod.ManaRegenPlus)) * GetMobileMod(MobileMod.ManaRegenTimes, 1) )
end

function RecalculateStaminaRegen()

	local staminaRegen = this:GetObjVar("StaminaRegen")
	if not( staminaRegen ) then
		if ( this:IsPlayer() ) then
			staminaRegen = 0
			-- players regenerate stamina dufferently dependant on the armor worn
			for i,slot in pairs(ARMORSLOTS) do
				local item = this:GetEquippedObject(slot)
				if ( item ) then
					staminaRegen = staminaRegen + GetArmorStaRegenModifier(item, slot)
				end
			end
		else
			staminaRegen = ServerSettings.Stats.DefaultMobStamRegen
		end
	end
	
	this:SetStatRegenRate("Stamina", (ServerSettings.Stats.BaseStaminaRegenRate + staminaRegen + GetMobileMod(MobileMod.StaminaRegenPlus)) * GetMobileMod(MobileMod.StaminaRegenTimes, 1) )
end

function RecalculateVitalityRegen()
	if ( this:HasObjVar("NoRegen") or IsDead(this) ) then
		this:SetObjVar("VitalityRegen",0)
		this:SetStatRegenRate("Vitality",0)
	else
		this:SetStatRegenRate("Vitality", (ServerSettings.Stats.BaseVitalityRegenRate + GetMobileMod(MobileMod.VitalityRegenPlus)) *GetMobileMod(MobileMod.VitalityRegenTimes, 1))
	end
end

function RecalculateMaxHealth()
	local isPlayer = IsPlayerCharacter(this)
	local baseHealth = this:GetObjVar("BaseHealth")
	if(baseHealth == nil) then
		if(isPlayer) then
			baseHealth = ServerSettings.Stats.PlayerBaseHealth
		else
			baseHealth = ServerSettings.Stats.NPCBaseHealth
		end
	end
	
	local conPlus = 0
	if (isPlayer) then
		conPlus = ServerSettings.Stats.ConHpBonusFunc(GetCon(this))
	end

	local maxHealth = (baseHealth + conPlus + GetMobileMod(MobileMod.MaxHealthPlus)) * GetMobileMod(MobileMod.MaxHealthTimes, 1)
	--this:NpcSpeech("MaxHP: "..tostring(maxHealth).." : ("..tostring(baseHealth).."*"..tostring(GetMobileMod(MobileMod.MaxHealthTimes, 1))..")")
	this:SetStatMaxValue("Health", math.floor(maxHealth))
end

function RecalculateMaxMana()
	this:SetStatMaxValue("Mana", math.floor(((GetInt(this)*2.5) + GetMobileMod(MobileMod.MaxManaPlus)) *GetMobileMod(MobileMod.MaxManaTimes, 1)) )
end

function RecalculateMaxStamina()
	this:SetStatMaxValue("Stamina", math.floor(((ServerSettings.Stats.BaseStamina + (GetAgi(this)  * 2) + GetMobileMod(MobileMod.MaxStaminaPlus)) *GetMobileMod(MobileMod.MaxStaminaTimes, 1)) ) )
end

function RecalculateMaxVitality()
	this:SetStatMaxValue("Vitality", math.floor((ServerSettings.Stats.BaseVitality + GetMobileMod(MobileMod.MaxVitalityPlus)) *GetMobileMod(MobileMod.MaxVitalityTimes, 1)) )
end

function RecalculateDerivedStr()
	this:SetStatValue("Str", math.floor(( GetBaseStr(this) + GetMobileMod(MobileMod.StrengthPlus) ) *GetMobileMod(MobileMod.StrengthTimes, 1)) )

	RecalculateAttack()
	RecalculateMaxWeight()

end

function RecalculateDerivedAgi()

	local agi = GetBaseAgi(this)
	local armorType = nil
	local armorClass = nil
	local agiBonus = 0

	if ( IsPlayerCharacter(this) ) then
		local skillDictionary = GetSkillDictionary(this)
		for i,slot in pairs(ARMORSLOTS) do
			local item = this:GetEquippedObject(slot)
			if ( item ) then								
				agiBonus = agiBonus + GetArmorAgiBonus(slot,item)
			else
				armorType = "Natural"
				armorClass = "Cloth"
			end
		end
	end

	agi = math.clamp(agi + agiBonus, ServerSettings.Stats.IndividualStatMin, ServerSettings.Stats.IndividualPlayerStatCap)

	this:SetStatValue("Agi", math.floor(( agi + GetMobileMod(MobileMod.AgilityPlus) ) *GetMobileMod(MobileMod.AgilityTimes, 1)) )

	RecalculateMaxStamina()
	RecalculateMoveSpeed()
	RecalculateAttackSpeed()

end

function RecalculateDerivedInt()
	this:SetStatValue("Int", math.floor(( GetBaseInt(this) + GetMobileMod(MobileMod.IntelligencePlus) ) *GetMobileMod(MobileMod.IntelligenceTimes, 1)) )

	RecalculateMaxMana()
	RecalculatePower()
	RecalculateForce()

end

function RecalculateDerivedCon()
	local conBonus = 0
	for i=1,#JEWELRYSLOTS do
		local item = this:GetEquippedObject(JEWELRYSLOTS[i])
		if ( item ) then
			local jewelryType = item:GetObjVar("JewelryType")
			if ( jewelryType ) then
				local jewelryData = JewelryTypeData[jewelryType]
				if ( jewelryData and jewelryData.Con ) then
					conBonus = conBonus + jewelryData.Con
				end
			end
		end
	end
	this:SetStatValue("Con", math.floor(( GetBaseCon(this) + conBonus + GetMobileMod(MobileMod.ConstitutionPlus) ) *GetMobileMod(MobileMod.ConstitutionTimes, 1)))
	RecalculateMaxHealth()
end

--This works as a type of magic resistance.
function RecalculateDerivedWis()
	local wisBonus = 0
	for i=1,#JEWELRYSLOTS do
		local item = this:GetEquippedObject(JEWELRYSLOTS[i])
		if ( item ) then
			local jewelryType = item:GetObjVar("JewelryType")
			if ( jewelryType ) then
				local jewelryData = JewelryTypeData[jewelryType]
				if ( jewelryData and jewelryData.Wis ) then
					wisBonus = wisBonus + jewelryData.Wis
				end
			end
		end
	end
	this:SetStatValue("Wis", math.floor((GetBaseWis(this) + wisBonus + GetMobileMod(MobileMod.WisdomPlus)) *GetMobileMod(MobileMod.WisdomTimes, 1)))
end

--This works as a type of crowd control resistance.
function RecalculateDerivedWill()
	local wilBonus = 0
	for i=1,#JEWELRYSLOTS do
		local item = this:GetEquippedObject(JEWELRYSLOTS[i])
		if ( item ) then
			local jewelryType = item:GetObjVar("JewelryType")
			if ( jewelryType ) then
				local jewelryData = JewelryTypeData[jewelryType]
				if ( jewelryData and jewelryData.Will ) then
					wilBonus = wilBonus + jewelryData.Will
				end
			end
		end
	end
	
	this:SetStatValue("Will", math.floor((GetBaseWill(this) + wilBonus + GetMobileMod(MobileMod.WillPlus)) *GetMobileMod(MobileMod.WillTimes, 1)))
end

function RecalculateAccuracy()
	local isPlayer = IsPlayerCharacter(this)

	local weaponAccuracy = EquipmentStats.BaseWeaponClass[_Weapon.RightHand.Class].Accuracy
	local weaponAccuracyBonus = 0
	if ( _Weapon and _Weapon.RightHand.Object ~= nil ) then
		weaponAccuracyBonus = _Weapon.RightHand.Object:GetObjVar("AccuracyBonus") or 0
	end

	local skillAccuracyBonus = GetSkillLevel(this,EquipmentStats.BaseWeaponClass[_Weapon.RightHand.Class].WeaponSkill) + 50
	if(EquipmentStats.BaseWeaponClass[_Weapon.RightHand.Class].SecondaryWeaponSkill) then
		local secondaryAccuracyBonus = GetSkillLevel(this,EquipmentStats.BaseWeaponClass[_Weapon.RightHand.Class].SecondaryWeaponSkill, skillDictionary) + 50
		skillAccuracyBonus = math.max(skillAccuracyBonus,secondaryAccuracyBonus)
	end

	local accuracy = (weaponAccuracy + weaponAccuracyBonus + skillAccuracyBonus + GetMobileMod(MobileMod.AccuracyPlus)) *GetMobileMod(MobileMod.AccuracyTimes, 1)

	this:SetStatValue("Accuracy", math.floor(accuracy))
end

function RecalculateEvasion()
	local evasionPlusMod = GetMobileMod(MobileMod.EvasionPlus)
	local evasionTimesMod = GetMobileMod(MobileMod.EvasionTimes, 1)
	local isPlayer = IsPlayerCharacter(this)

	-- We dont call the GetArmorProficiencyType helper function to avoid iterating through the armor twice
	local evasionArmorBonus = 0
	local canGetLightArmorBonus = isPlayer
	for i,slot in pairs(ARMORSLOTS) do
		local armorClass = nil

		local item = this:GetEquippedObject(slot)		
		if(item) then
			evasionArmorBonus = evasionArmorBonus + (item:GetObjVar("EvasionBonus") or 0)
			if(canGetLightArmorBonus) then
				armorClass = GetArmorClass(item)
			end
		end

		if(armorClass ~= "Light") then
			canGetLightArmorBonus = false
		end
	end

	local skillDictionary = GetSkillDictionary(this)

	local lightArmorEvasionBonus = 0
	if(isPlayer and canGetLightArmorBonus) then
		lightArmorEvasionBonus = GetSkillLevel(this,"LightArmorSkill", skillDictionary) * ServerSettings.Stats.LightArmorEvasionBonus
	end

	local skillEvasionBonus = GetSkillLevel(this,EquipmentStats.BaseWeaponClass[_Weapon.RightHand.Class].WeaponSkill, skillDictionary) + 50
	if(EquipmentStats.BaseWeaponClass[_Weapon.RightHand.Class].SecondaryWeaponSkill) then
		local secondaryEvasionBonus = GetSkillLevel(this,EquipmentStats.BaseWeaponClass[_Weapon.RightHand.Class].SecondaryWeaponSkill, skillDictionary) + 50
		skillEvasionBonus = math.max(skillEvasionBonus,secondaryEvasionBonus)
	end

	local shieldEvasionPenalty = 0
	local thisShieldClass = nil
	if(_Weapon and _Weapon.LeftHand.Object) then
		thisShieldClass = GetShieldType(_Weapon.LeftHand.Object)
	end

	if(thisShieldClass ~= nil) then
		shieldEvasionPenalty = ServerSettings.Stats.ShieldEvasionPenalty
	end

    local evasion = (evasionArmorBonus+skillEvasionBonus-shieldEvasionPenalty+lightArmorEvasionBonus+evasionPlusMod) *evasionTimesMod
   	
   	this:SetStatValue("Evasion",math.floor(evasion))
end

function RecalculateMaxWeight()
	if (IsPlayerCharacter(this)) then
		local backpack = this:GetEquippedObject("Backpack")
		if (backpack ~= nil) then
			backpack:SetSharedObjectProperty("MaxWeight",GetContainerMaxWeight(backpack))
		end
	end
end

function RecalculateAttack()
	local isPlayer = IsPlayerCharacter(this)

	local attack = this:GetObjVar("Attack")
	local attackModifier = 0
	if not(attack) then
		if(isPlayer) then
			attack = EquipmentStats.BaseWeaponStats[_Weapon.RightHand.Type].Attack or 0
			attackModifier = ( _Weapon.RightHand.AttackBonus or 0 ) / 100
			if not (_Weapon and _Weapon.RightHand.Object) then
				attack = 10 + ( (GetSkillLevel(this, "BrawlingSkill") or 0) / 100 ) * 6
			end
		else
			attack = ServerSettings.Stats.DefaultMobAttack
		end
	end

	--this:NpcSpeech("attack: "..attack)

	if ( isPlayer ) then
		local strModifier = ServerSettings.Stats.StrModifierFunc(GetStr(this))

		local skillBonus = ( (GetSkillLevel(this, "MeleeSkill") or 0) ) / 80

		attack = attack * (strModifier + skillBonus + attackModifier)
		--this:NpcSpeech("strModifier: "..strModifier)
		--this:NpcSpeech("skillBonus: "..skillBonus)
	end
	--this:NpcSpeech("scaled Attack: "..attack)
	--this:NpcSpeech("attackModifier: "..attackModifier)
	--this:NpcSpeech("GetMobileMod(MobileMod.AttackPlus): "..GetMobileMod(MobileMod.AttackPlus))
	--this:NpcSpeech("GetMobileMod(MobileMod.AttackTimes, 1): "..GetMobileMod(MobileMod.AttackTimes, 1))

	this:SetStatValue("Attack",math.floor((attack + GetMobileMod(MobileMod.AttackPlus)) * GetMobileMod(MobileMod.AttackTimes, 1)))

end

-- power is magic cast damage modifier
function RecalculatePower()
	local power = this:GetObjVar("Power") -- for mobs or overrides on players
	local powerBonus = 0
	local isPlayer = IsPlayerCharacter(this)
	if not( power ) then
		if ( isPlayer ) then
			power = EquipmentStats.BaseWeaponStats[_Weapon.RightHand.Type].Power or 0
			--powerBonus = GetMagicItemDamageBonus(_Weapon.RightHand.Object)
		else
			power = ServerSettings.Stats.DefaultMobPower
		end
	end

	if ( isPlayer ) then
		local affinityBonus = (GetSkillLevel(this, "MagicAffinitySkill") or 0) / 5
		if affinityBonus < 1 then
			affinityBonus = 1
		end
		--local inscriptionBonus = (GetSkillLevel(this, "InscriptionSkill") or 0) / 20
		power = ( power + powerBonus + affinityBonus ) * ServerSettings.Stats.IntMod(GetInt(this))
	end

	--this:NpcSpeech("power: "..power)
	--this:NpcSpeech("powerBonus: "..powerBonus)
	--this:NpcSpeech("channelingBonus: "..channelingBonus)
	--this:NpcSpeech("intmod: "..ServerSettings.Stats.IntMod(GetInt(this)))

	this:SetStatValue("Power", math.floor((power + GetMobileMod(MobileMod.PowerPlus)) * GetMobileMod(MobileMod.PowerTimes, 1)))

end

-- force is magic cast beneficial plus
function RecalculateForce()
	local force = this:GetObjVar("Force") -- for mobs or overrides on players
	local forceBonus = 0
	local isPlayer = IsPlayerCharacter(this)
	if not( force ) then
		if ( isPlayer ) then
			force = EquipmentStats.BaseWeaponStats[_Weapon.RightHand.Type].Force or 0
			--forceBonus = GetMagicItemDamageBonus(_Weapon.RightHand.Object) --TODO for when we implement weapon bonuses
		else
			force = ServerSettings.Stats.DefaultMobForce
		end
	end

	if ( isPlayer ) then
		force = ( force + forceBonus) * ServerSettings.Stats.IntMod(GetInt(this))
	end

	this:SetStatValue("Force", math.floor((force + GetMobileMod(MobileMod.ForcePlus)) * GetMobileMod(MobileMod.ForceTimes, 1)))
end

function RecalculateDefense()
	local isPlayer = IsPlayerCharacter(this)

	local thisArmorRating = 0
	local thisArmorBonus = 0
	local armorType = nil
	local armorClass = nil

	if ( isPlayer ) then
		local skillDictionary = GetSkillDictionary(this)
		for i,slot in pairs(ARMORSLOTS) do
			local item = this:GetEquippedObject(slot)
			if ( item ) then
				armorType = GetArmorType(item)
				armorClass = GetArmorClassFromType(armorType)
				thisArmorBonus = thisArmorBonus + ( item:GetObjVar("ArmorBonus") or 0 )
			else
				armorType = "Natural"
				armorClass = "Cloth"
			end

			local armorRating = EquipmentStats.BaseArmorStats[armorType][slot].ArmorRating
			if ( armorClass == "Heavy" or armorClass == "Light" ) then
				local skill = "HeavyArmorSkill"
				if ( armorClass == "Light" ) then skill = "LightArmorSkill" end
				armorRating = (EquipmentStats.BaseArmorStats.Natural[slot].ArmorRating + (((armorRating) - EquipmentStats.BaseArmorStats.Natural[slot].ArmorRating) / 2 ) -- difference between the rating and lowest possible rating
					+
					(((armorRating) - EquipmentStats.BaseArmorStats.Natural[slot].ArmorRating) / 2 ) * (GetSkillLevelFromDictionary(skill, skillDictionary) / ServerSettings.Skills.PlayerSkillCap.Single) -- percent of skill maxed
				)
			end

			thisArmorRating = thisArmorRating + armorRating
		DebugMessage(tostring("><><>< " .. thisArmorRating))
		end		
	else
		thisArmorRating = this:GetObjVar("Armor") or ServerSettings.Stats.DefaultMobArmorRating
	end
 
	local defense = thisArmorRating + thisArmorBonus
	defense = math.floor( (defense + GetMobileMod(MobileMod.DefensePlus)) * GetMobileMod(MobileMod.DefenseTimes, 1) )
	DebugMessage("TEST")
	DebugMessage(tostring(defense))
	this:SetStatValue("Defense", math.max(defense, 1))
end

function RecalculateAttackSpeed()
	local isPlayer = IsPlayerCharacter(this)

	local speed = this:GetObjVar("AttackSpeed")
	local speedMod = 0
	local attackSpeedPlusMod = GetMobileMod(MobileMod.AttackSpeedPlus)
	local attackSpeedTimesMod = GetMobileMod(MobileMod.AttackSpeedTimes, 1)
	local bowSpeedModifier = nil
	if not(speed) then
		if(isPlayer) then
			speed = _Weapon.RightHand.Speed or 5
			speedMod = GetMagicItemSpeedModifier(_Weapon.RightHand.Object)
		else
			-- DAB COMBAT CHANGES: MAKE THIS CONFIGURABLE
			speed = ServerSettings.Stats.DefaultMobWeaponSpeed
    	end
    end

	local lightArmorAttackSpeedMultiplier = 1
	if(isPlayer) then
		if(GetArmorProficiencyType(this) == "Light") then
			lightArmorAttackSpeedMultiplier = 1 + (GetSkillLevel(this,"LightArmorSkill") * ServerSettings.Stats.LightArmorAttackSpeedMultiplier)
		end
	end

	local baseAttackSpeed = ((speed * 4) - math.floor(GetMaxStamina(this)/30)) * (100/(100 + speedMod))
	
	local attacksPerSecond = 1.25
	
	-- weapons with a bow speed modifier have a different speed calculation
	--if(bowSpeedModifier) then
	--	attacksPerSecond = (baseAttackSpeed/1000) * (1500/bowSpeedModifier)
	--else
		attacksPerSecond = (baseAttackSpeed/4) - attackSpeedPlusMod
	--end

	--local attackSpeedSecs = attacksPerSecond

	this:SetStatValue("AttackSpeed",math.round(attacksPerSecond,2))
end

function RecalculateCritChance()
	local critChancePlusMod = GetMobileMod(MobileMod.CritChancePlus)
	local critChanceTimesMod = GetMobileMod(MobileMod.CritChanceTimes, 1)
	local isPlayer = IsPlayerCharacter(this)

	local lightArmorCritChanceBonus = 0
	if(isPlayer) then
		if(GetArmorProficiencyType(this) == "Light") then
			lightArmorCritChanceBonus = GetSkillLevel(this,"LightArmorSkill") * ServerSettings.Stats.LightArmorCritChanceBonus
		end
	end
	--local agiModifier = ServerSettings.Stats.AgiModifierFunc(GetAgi(this))

	local magicItemCritChanceBonus = 0
	if(_Weapon and _Weapon.RightHand.Object) then
		magicItemCritChanceBonus = GetMagicItemCritChanceBonus(_Weapon.RightHand.Object)
	end

	--local critChance = ((agiModifier * EquipmentStats.BaseWeaponClass[_Weapon.RightHand.Class].Critical / 10) + magicItemCritChanceBonus + lightArmorCritChanceBonus + critChancePlusMod)* critChanceTimesMod
	local critChance = 0

	this:SetStatValue("CritChance",math.round(critChance,1))
end

function RecalculateCritChanceReduction()
	local isPlayer = IsPlayerCharacter(this)

	local critChanceReduction = 0	
	if(isPlayer) then
		local armorProfType = GetArmorProficiencyType(this)		
		if(armorProfType == "Heavy") then
			critChanceReduction = GetSkillLevel(this,"HeavyArmorSkill") * ServerSettings.Stats.HeavyArmorCritChanceReduction
		end
	end

	this:SetStatValue("CritChanceReduction",critChanceReduction)
end

function RecalculateMoveSpeed()

    if ( IsMounted(this) ) then
    	local mountSpeed = ServerSettings.Stats.MountMoveSpeed or ServerSettings.Stats.BaseMoveSpeed
    	local mountSpeedMod = ( ( mountSpeed + GetMobileMod(MobileMod.MountMoveSpeedPlus) ) ) * GetMobileMod(MobileMod.MountMoveSpeedTimes, 1)
    	mountSpeedMod = math.max(0.1,mountSpeedMod)

      	this:SetBaseMoveSpeed( mountSpeedMod )
    else
		if not( IsPlayerCharacter(this) ) then
			return
		end

		-- determine if player is wearing any heavy armor
		local anyHeavy = (
			HasMobileEffect(this, "HeavyArmorDebuff")
			or IsWearingHeavyArmor(this, _Weapon.LeftHand.ShieldType ~= nil) -- wearing any heavy armor?
		)

		local agi = ServerSettings.Stats.HeavyArmorMoveSpeedAgi
		if not( anyHeavy ) then
			-- when not wearing any heavy armor, we use their real agi to calculate the speed boost.
			agi = GetAgi(this)
		end
		
		local stamMod = 1 + ((GetCurStamina(this)-20)*0.0025)

		local speedMod = ( ( ServerSettings.Stats.BaseMoveSpeed + GetMobileMod(MobileMod.MoveSpeedPlus) ) ) * GetMobileMod(MobileMod.MoveSpeedTimes, 1)
		speedMod = math.max(0.1,speedMod)

    	--this:SetBaseMoveSpeed( ( ( ServerSettings.Stats.BaseMoveSpeed + GetMobileMod(MobileMod.MoveSpeedPlus) ) * stamMod ) * GetMobileMod(MobileMod.MoveSpeedTimes, 1) )
    	this:SetBaseMoveSpeed( speedMod )
	end

end

recalcFuncs = 
{
	{Name="Strength", Func=RecalculateDerivedStr},
	{Name="Intelligence", Func=RecalculateDerivedInt},
	{Name="Agility", Func=RecalculateDerivedAgi},
	{Name="Constitution", Func=RecalculateDerivedCon},
	{Name="Wisdom", Func=RecalculateDerivedWis},
	{Name="Will", Func=RecalculateDerivedWill},
	{Name="HealthRegen", Func=RecalculateHealthRegen},
	{Name="ManaRegen", Func=RecalculateManaRegen},
	{Name="StaminaRegen", Func=RecalculateStaminaRegen},
	{Name="VitalityRegen", Func=RecalculateVitalityRegen},
	{Name="Accuracy", Func=RecalculateAccuracy},
	{Name="Evasion", Func=RecalculateEvasion},
	{Name="Attack", Func=RecalculateAttack},
	{Name="Power", Func=RecalculatePower},
	{Name="Force", Func=RecalculateForce},
	{Name="Defense", Func=RecalculateDefense},
	{Name="AttackSpeed", Func=RecalculateAttackSpeed},
	{Name="CritChance", Func=RecalculateCritChance},
	{Name="CritChanceReduction", Func=RecalculateCritChanceReduction},
	{Name="MoveSpeed", Func=RecalculateMoveSpeed},
	{Name="MountMoveSpeed", Func=RecalculateMoveSpeed},
	{Name="MaxHealth", Func=RecalculateMaxHealth},
	{Name="MaxVitality", Func=RecalculateMaxVitality},
	{Name="MaxWeight", Func=RecauclateMaxWeight},
}

-- this is the delayed function intended to reduced duplicate calls to recalc functions
function DoRecalculateStats()
	-- these functions must be called in order
	-- as some derived stats depend on others
	for key,value in pairs(recalcFuncs) do
		if( statsToRecalculate[value.Name] == true ) then			
			value.Func()
		end
	end

	--this:SendMessage("UpdateCharacterWindow")

	statsToRecalculate = {}
end

-- this is the message handler that marks derived stats as dirty to be recalculated
function MarkStatsDirty(recalculateStatsDict)
	for key, value in pairs(recalculateStatsDict) do		
		statsToRecalculate[key] = true
	end

	-- schedule client update
	-- 100ms buffer to reduce spam
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(100),"DoRecalculateStats")
end

-- Recalculate on load
this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(100),"DoRecalculateStats")

RegisterEventHandler(EventType.Timer, "DoRecalculateStats", DoRecalculateStats)
RegisterEventHandler(EventType.Message, "RecalculateStats", MarkStatsDirty)

-- This is to be included by mobiles for the ability to add and remove stat modifiers

-- this defines the derived stats that need to be recalculated when this skill changes
skillGainEffects = {
	MagicAffinitySkill = { ManaRegen = true, Power = true },
	LightArmorSkill = { Defense = true, },
	HeavyArmorSkill = { Defense = true, Agility = true, },
	SlashingSkill = { Evasion = true, Accuracy = true },
	PiercingSkill = { Evasion = true, Accuracy = true },
	BashingSkill = { Evasion = true, Accuracy = true },
	BrawlingSkill = { Evasion = true, Accuracy = true },
	ArcherySkill = { Evasion = true, Accuracy = true },
	LancingSkill = { Evasion = true, Accuracy = true },
	ChannelingSkill = { Power = true },
	RestorationSkill = { Force = true },
}

-- Args
--     statModName: the name of the stat to modify (right now we old support regen modifiers)
--     statModIdentifier: the identifier of this particular mod (so it can be removed later)
--     statModType: the type of modifier (bonus or multiplier)
--     statModValue: the actual modifier value
function HandleAddStatMod(statModName,statModIdentifier,statModType,statModValue,statModTime)
	LuaDebugCallStack("[DEPRECIATED] AddStatMod has been replaced with SetMobileMod.")
end

-- Args
--     statModName: the name of the stat to remove (right now we old support regen modifiers)
--     statModIdentifier: the identifier the mod to remove
function HandleRemoveStatMod(statModName, statModIdentifier)
	LuaDebugCallStack("[DEPRECIATED] AddStatMod has been replaced with SetMobileMod.")
end

function StatsHandleEquipmentChanged(item)
	local itemSlot = GetEquipSlot(item)

	local dirtyTable = {}

	if( itemSlot == "RightHand" ) then
		dirtyTable = {Accuracy=true,Evasion=true,Attack=true,AttackSpeed=true,Force=true,Power=true}
	elseif( itemSlot == "LeftHand" and GetShieldType(item) ) then
		dirtyTable.Evasion = true
	elseif( IsArmorSlot(itemSlot) ) then
		dirtyTable = {Agility=true, Defense=true, ManaRegen=true, StaminaRegen=true}
		-- this would be better to figure out a client side handle for the (+/-#) next to stats in paperdoll.
		if ( GetArmorClass(item) == "Heavy" ) then
			CallFunctionDelayed(TimeSpan.FromMilliseconds(250), function()
				this:SendMessage("UpdateCharacterWindow")
			end)
		end
	elseif (IsJewelrySlot(itemSlot)) then
			dirtyTable = {Will=true, Constitution=true, Wisdom=true}
	end

	MarkStatsDirty(dirtyTable)
end

function StatsHandleSkillChanged(skillName)
	if(skillGainEffects[skillName]) then
		MarkStatsDirty(skillGainEffects[skillName])
	end
end

RegisterEventHandler(EventType.Message, "AddStatMod", HandleAddStatMod)
RegisterEventHandler(EventType.Message, "RemoveStatMod", HandleRemoveStatMod)

RegisterEventHandler(EventType.Message, "OnSkillLevelChanged", StatsHandleSkillChanged)