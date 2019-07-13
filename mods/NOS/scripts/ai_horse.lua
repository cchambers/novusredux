-- mobs can't age because the rider wont fit correctly so they do not use default_animal
require 'NOS:base_ai_mob'

-- Combat AI settings
AI.Settings.ChargeSpeed = 5.0
AI.Settings.AggroChanceAnimals = 0 --1 out of this number chance to attack other animals
AI.Settings.FleeUnlessAngry = false
AI.Settings.AggroRange = 5.0 --Range to start aggroing
AI.Settings.CanFlee = true --Determines if this mob should ever run away
AI.Settings.ChaseRange = 10.0 --distance from self to chase target
AI.Settings.CanTaunt = false --Determines if this mob should taunt the target
AI.Settings.CanHowl = false --Determines if this mob should stop and howl
AI.Settings.CanSpeak = false --Determines if this mob speaks
AI.Settings.CanCast = false --Determines if this mob should cast or not
AI.Settings.CanUseCombatAbilities = false
AI.Settings.ChanceToNotAttackOnAlert = 20 --1 out of this number chance to attack when alerted
AI.Settings.FleeDistance = 10.0 --Distance to run away when fleeing
AI.Settings.InjuredPercent = 1.0 --Percentage of health to run away
AI.Settings.FleeSpeed = 5 --speed to run away
AI.Settings.FleeUnlessInCombat = true --if this setting is checked true then it will always flee if in combat.
AI.Settings.FleeChance = 3 --Chance to run away
AI.Settings.Leash = false --Determines if this mob should ever leash
AI.Settings.LeashDistance = 40 --Max distance from spawn this mob should ever go
AI.Settings.CanWander = true --Determines if this mob wanders or not
AI.Settings.WanderChance = 5 -- Chance to wander
AI.Settings.StationedLeash = true --if true, mob will go back to it's spawn position on idle
AI.Settings.CanSeeBehind = true
AI.Settings.ShouldAggro = false

-- external inputs