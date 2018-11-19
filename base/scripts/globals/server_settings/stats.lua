ServerSettings.Stats = {
	PlayerBaseHealth = 150,
	NPCBaseHealth = 100,
	IndividualStatMin = 1,
	IndividualPlayerStatCap = 100,
	TotalPlayerStatsCap = 600,
	IndividualNPCStatCap = 1000,
	TotalNPCStatsCap = 10000,
	WalkSpeedModifier = 1.5,
	RunSpeedModifier = 4.5,
	BaseMoveSpeed = 1, -- base speed for movement
	MountMoveSpeed = 1.75, -- speed set to exactly this when mounted
	ApplyOverCapStatPowerReduction = true,
	OverCapPowerFactor = 0.85,

	-- these are stats that can gain with the use of any skill that can gain stats and are not (and never will be) tied to a specific skill
	AllSkillStats = {
		"Constitution",
		"Wisdom",
		"Will"
	},

	ShieldEvasionPenalty = 0,
	WeaponSkillEvasionBonus = 0.2,
	WeaponSkillAccuracyBonus = 0.2,
	BaseHealthRegenRate = 1/12,
	BaseVitalityRegenRate = 0,
	BaseVitality = 100,
	BaseStamina = 0,
	BaseStaminaRegenRate = 0.1,
	BaseManaRegenRate = 0.2,
	DefaultMobAttack = 4,
	DefaultMobPower = 4, -- default magic power
	DefaultMobForce = 4, -- default magic beneficial
	DefaultMobArmorRating = 44,
	DefaultMobWeaponSpeed = 2.5,

	DefaultMobManaRegen = 4.4,
	DefaultMobStamRegen = 2,

	LightArmorCritChanceBonus = 0.2,
	DefaultWeaponRange = 0.7,

	LightArmorEvasionBonus = 0,
	LightArmorAttackSpeedMultiplier = 0,

	HeavyArmorCritChanceReduction = 0.002,
	HeavyArmorDefenseBonus = 0,

	-- how long should a player remain debuffed after removing their heavy armor
	HeavyArmorDebuffDuration = TimeSpan.FromMinutes(1),

	-- when calculating MoveSpeed and given the mobile has any heavy armor (or debuff), 
		-- this number will act in place of their real agi (only for movement speed calculations!)
	HeavyArmorMoveSpeedAgi = 10,

	-- configurable functions

	-- determines hp bonus from con stat
	ConHpBonusFunc = function(con)
		local conHpBonus = 0
		if con > 40 then 
	        conHpBonus = (conHpBonus+350) + ((con-40)*5)
		elseif con > 30 then 
	        conHpBonus = (conHpBonus+250) + ((con-30)*10)
		elseif con > 20 then 
	        conHpBonus = (conHpBonus+100) + ((con-20)*15)
	    elseif con > 10 then 
	        conHpBonus = (con-10)*10   
	    end

		return conHpBonus
	end,

		
	-- determines attack mod bonus from str
	StrModifierFunc = function(str) 
		local strModifier = 0	
	   if( str > 10 ) then
			return strModifier +  ( ( str * 2.5 )  / 100 )
	    end

	    return strModifier
	end,

	IntMod = function(int)
		local base = 1
		if( int > 10 ) then
			return base + ( ( int - 10 ) * 0.00625)
		end
		return base
	end,

	WisMod = function(wis)
		local base = 30
		if( wis > 40 ) then
			return ( base + 28 ) + ( ( wis - 40 ) * 0.2)
		elseif( wis > 30 ) then
			return ( base + 13 ) + ( ( wis - 30 ) * 1.5)
		elseif( wis > 20 ) then
			return ( base + 5 ) + ( ( wis - 20 ) * 0.08)
		elseif( wis > 10 ) then
			return base + ( ( wis - 10 ) * 0.015)
		end
		return base
	end,
}