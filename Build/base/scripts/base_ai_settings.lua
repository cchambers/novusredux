AI = {

	-- These settings can be overridden

	Settings = {
		Age = 10, --Approximate age of the mob in years. Scale is set to a a tenth of this value		
		AggroChanceAnimals = 12, --1 out of this number chance to attack other animals
		AggroRange = 5.0, --Range to start aggroing
		CanFlee = true, --Determines if this mob should ever run away
		FleeUnlessAngry = false, --only fight if the mob is angry
		ChargeSpeed = 4.5, --Speed mob charges at target
		ChaseRange = 10.0, --distance from self to chase target. Crucial, determines the distance at which a mob "Sees" the enemy also
		CanTaunt = false, --Determines if this mob should taunt the target
		CanHowl = false, --Determines if this mob should stop and howl
		CanConverse = false, --Determines if this mob speaks
		CanCast = false, --Determines if this mob should cast or not
		CanUseCombatAbilities = true,
		ChanceToNotAttackOnAlert = 3, --1 out of this number chance to attack when alerted
		Debug = false, --Turn debug messages on or off
		FleeDistance = 25.0, --Distance to run away when fleeing
		InjuredPercent = 0.2, --Percentage of health to run away
		FleeSpeed = 3.7, --speed to run awayw
		FleeIfCornered = false, --if this setting is checked true then it will always flee if in combat.
		FleeChance = 5, --Chance to run away
		Leash = false, --Determines if this mob should ever leash
		LeashDistance = 40, --Max distance from spawn this mob should ever go
		CanWander = true, --Determines if this mob wanders or not
		WanderChance = 5, -- Chance to wander
		ScaleToAge = true,
        StationedLeash = false, --if true, mob will go back to it's spawn position whenever it gets out of range
		AgeScaleModifier = .1, --Determines if this mob should be scaled to age
		AgeHealthModifier = .125,
		NoMelee = false, --if true this mob only casts spells
		PatrolSpeed = 3.0,
		CheckLOS = true,
		MaxChaseTime = 2,
		FleeTime = 3, --Time I should flee
		ShouldPatrol = true, --determines if this mob should patrol
		StartConversations = true, --determines if this mob should start conversations or speak anything other then combat speech
		--Following variables are unused if the previous one is set to true
		ScaleRange = 4, --Maximum range to simulate scale randomization. 
		--Following variables are overridden if RandomizeScale or ScaleToAge is true
		AgeCheckFrequencySecs = 60*10, -- How often should the mobs age change
		MaxAge = 18, --Maximum age before mob starts to die of old age.
		MaxAgeScale = 1.2, --Maximum scale that a mob can age.
		AgeIncrement = 0.4, -- The amount a mob ages every time its checked
		CanSeeBehind = false,--DFB TODO: If true, the mob will go into alert even if you sneak up behind them.
		CanOpenDoors = false,--Determines if the AI can open doors.
		CanUseTeleporters = false,--Determines if this mob should go through teleporters
		ShouldAggro = true,
		ShouldSleep = true --Should this mob go to sleep when no players are around
	},

	---------------	

	GetSetting = function(settingName)
		local setting = this:GetObjVar("AI-"..settingName)
		if (setting == nil) then
    		return AI.Settings[settingName]
    	else
    		return setting
    	end
	end,

	SetSetting = function(settingName,value)
    	this:SetObjVar("AI-"..settingName,value)
    end,

}