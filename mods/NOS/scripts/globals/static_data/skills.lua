SkillData = {
	AllSkills= {
		MeleeSkill = {
			DisplayName = "Anatomy",
			SkillIcon = "Skill_Endurance",
			PrimaryStat = "Agility",
			Description = "Anatomy determines the effectiveness of bandaging and offers a damage bonus with melee and ranged weapons.",
			SkillType = "CombatTypeSkill",
			IsWeaponSkill = true,
			GainFactor = 0.2,
		},
		PiercingSkill = {
			DisplayName = "Piercing",
			PrimaryStat = "Strength",
			Description = "Piercing determines your effeciency when fighting with piercing weapons.",
			SkillType = "CombatTypeSkill",
			IsWeaponSkill = true,
			GainFactor = 0.2,
		},
		SlashingSkill = {
			DisplayName = "Slashing",
			PrimaryStat = "Strength",
			Description = "Slashing determines your effeciency when fighting with slashing weapons.",
			SkillType = "CombatTypeSkill",
			IsWeaponSkill = true,
			GainFactor = 0.2,
		},
		LancingSkill = {
			DisplayName = "Lancing",
			PrimaryStat = "Strength",
			Description = "Lancing determines your effeciency when fighting with lancing weapons.",
			SkillType = "CombatTypeSkill",
			IsWeaponSkill = true,
			GainFactor = 0.2,
		},
		BashingSkill = {
			DisplayName = "Bashing",
			PrimaryStat = "Strength",
			Description = "Bashing determines your effeciency when fighting with bashing weapons.",
			SkillType = "CombatTypeSkill",
			IsWeaponSkill = true,
			GainFactor = 0.2,
		},
		BrawlingSkill = {
			DisplayName = "Wrestling",
			PrimaryStat = "Strength",
			Description = "Wrestling determines your effeciency with your fists.",
			SkillType = "CombatTypeSkill",
			IsWeaponSkill = true,
			GainFactor = 0.2,
		},
		HealingSkill = {
			DisplayName = "Healing",
			Description = "Healing determines your ability to heal humans and animals.",
			PrimaryStat = "Agility",
			SkillType = "CombatTypeSkill",
			SkillIcon = "Skill_Regeneration",
			GainFactor = 1,
			Options = {
				SkillRequiredToResurrect = 85,
				HealTimeBaseSelf = 8000,
				HealTimeBaseOther = 8000,
				MinHealTime = 3000,
				InterruptDamagePlayer = 19,
				InterruptDamageNPC = 26,
				BandageRange = 5
			}
		},
		-- MAGIC SKILLS
		MagicAffinitySkill = {
			DisplayName = "Evaluate Intelligence",
			PrimaryStat = "Intelligence",
			NoStatGain = true,
			Description = "Evaluate Intelligence determines the power of your offensive spells.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.4,
		},

		MagerySkill = {
			DisplayName = "Magery",
			PrimaryStat = "Intelligence",
			Description = "Magery determines your knowledge of magics.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.4,
		},

		ManifestationSkill = {
			DisplayName = "Manifestation",
			PrimaryStat = "Intelligence",
			Description = "Magery determines your knowledge of beneficial spells.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.4,
			Skip = true
		},
		ChannelingSkill = {
			DisplayName = "Meditation",
			PrimaryStat = "Intelligence",
			Description = "Meditation determines your ability to actively and passively regenerate mana.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.375,
			Abilities = { "Focus" },
		},
		ParryingSkill = {
			DisplayName = "Parrying",
			PrimaryStat = "Strength",
			Description = "Not used.",
			SkillType = "Not",
			GainFactor = 0.1,
			Skip = true
		},
		EvocationSkill = {
			DisplayName = "Evocation",
			PrimaryStat = "Intelligence",
			Description = "Magery determines your knowledge of damage dealing spells.",
			SkillType = "Not",
			GainFactor = 0.4,
			Skip = true,
		},
		MagicResistSkill = {
			DisplayName = "Magic Resistance",
			PrimaryStat = "Wisdom",
			Description = "Magic Resistance determines your chance resist offensive magical spells.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.35
		},
		SpiritSpeak = {
			DisplayName = "Spirit Speak",
			PrimaryStat = "Wisdom",
			Description = "Gives you the ability to speak with the dead.",
			SkillType = "TradeTypeSkill",
			Abilities = { "SpeakWithDead" },
			GainFactor = 0.5
		},
		-- END MAGIC SKILLS
		BlockingSkill = {
			DisplayName = "Blocking",
			PrimaryStat = "Agility",
			Description = "Blocking determines your effectiveness using a shield.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.3,
			-- Abilities = { "Taunt" },
		},
		MetalsmithSkill = {
			DisplayName = "Blacksmithing",
			Description = "Blacksmithing is the capacity to be able to work metal and allows creation of metal items.",
			PrimaryStat = "Strength",
			SkillType = "TradeTypeSkill",
			GainFactor = 0.7,
			Practice = {
				ResourceType = "IronIngots",
				ConsumeAmount = 5,
				Seconds = 3
			}
		},
		TinkeringSkill = {
			DisplayName = "Tinkering",
			Description = "Tinkering is the ability to craft tools and other fine items.",
			PrimaryStat = "Strength",
			SkillType = "TradeTypeSkill",
			GainFactor = 0.5
		},
		WoodsmithSkill = {
			DisplayName = "Carpentry",
			Description = "Carpentry is the capacity to work wood and allows creation of wooden items.",
			PrimaryStat = "Agility",
			Description = "[$3280]",
			SkillType = "TradeTypeSkill",
			GainFactor = 0.7,
			Practice = {
				ResourceType = "Boards",
				ConsumeAmount = 5,
				Seconds = 3
			}
		},
		AlchemySkill = {
			DisplayName = "Alchemy",
			PrimaryStat = "Intelligence",
			Description = "[$3287]",
			SkillType = "TradeTypeSkill",
			GainFactor = 0.7,
			Skip = false,
		},
		MarksmanshipSkill = {
			DisplayName = "Marksmanship",
			PrimaryStat = "Strength",
			Description = "Accuracy with projectile weapons",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.35,
		},
		NecromancySkill = {
			DisplayName = "Necromancy",
			PrimaryStat = "Intelligence",
			Description = "[$3289]",
			SkillType = "CombatTypeSkill",
			Skip = true,
		},
		CookingSkill = {
			DisplayName = "Cooking",
			PrimaryStat = "Intelligence",
			Description = "[$3290]",
			SkillType = "TradeTypeSkill",
			AllowCampfireGains = true,
		},
		FishingSkill = {
			DisplayName = "Fishing",
			PrimaryStat = "Intelligence",
			Description = "[$3291]",
			SkillType = "TradeTypeSkill",
			GainFactor = 0.5,
		},	
		LumberjackSkill = {
			DisplayName = "Lumberjack",
			PrimaryStat = "Strength",
			Description = "[$3295]",
			SkillType = "TradeTypeSkill",
			GainFactor = 0.2,
			--Skip = true,
		},
		MiningSkill = {
			DisplayName = "Mining",
			PrimaryStat = "Strength",
			Description = "[$3296]",
			SkillType = "TradeTypeSkill",
			GainFactor = 0.2,
			--Skip = true,
		},
		FabricationSkill = {
			DisplayName = "Tailoring",
			PrimaryStat = "Intelligence",
			Description = "[$3297]",
			SkillType = "TradeTypeSkill",
			GainFactor = 0.7,
			Practice = {
				ResourceType = "Fabric",
				ConsumeAmount = 5,
				Seconds = 3
			}
		},
		MusicianshipSkill = {
			DisplayName = "Musicianship",
			PrimaryStat = "Intelligence",
			Description = "The ability to play a musical instrument well.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.3,
			Skip = true
		},
		BardSkill = {
			DisplayName = "Bard",
			PrimaryStat = "Intelligence",
			Description = "Use music to accomplish more than sound.",
			SkillType = "CombatTypeSkill",
			Skip = true,
			GainFactor = 2.5,
		},
		InscriptionSkill = {
			DisplayName = "Inscription",
			PrimaryStat = "Intelligence",
			Description = "The ability to craft spell scrolls & spellbooks.",
			SkillType = "TradeTypeSkill",
			GainFactor = 0.7,
		},
		AnimalTamingSkill = {
			DisplayName = "Animal Taming",
			PrimaryStat = "Intelligence",
			Description = "Animal Taming is your ability to control certain creatures.",
			SkillType = "CombatTypeSkill",
			SkillIcon = "Skill_AnimalKen",
			Abilities = { "Command" },
			GainFactor = 0.5,
		},
		BeastmasterySkill = {
			DisplayName = "Beastmastery",
			PrimaryStat = "Intelligence",
			Description = "Beastmastery is how well you can control your pets.  Both in how many you can control at once, and how effective they are in battle.",
			SkillType = "CombatTypeSkill",
			SkillIcon = "Skill_BeastMastery",
			GainFactor = 0.5,
		},
		AnimalLoreSkill = {
			DisplayName = "Animal Lore",
			PrimaryStat = "Intelligence",
			Description = "Your knowledge of animals. Determines your ability to control and adds a bonus to healing your pets.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.5,
		},
		ArcherySkill = {
			DisplayName = "Archery",
			PrimaryStat = "Strength",
			Description = "Archery determines your effectiveness with a bow and arrow.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.8,
		},
		DetectHiddenSkill = {
			DisplayName = "Detect Hidden",
			SkillIcon = "Skill_Rogue",
			PrimaryStat = "Wisdom",
			Description = "Look around.",
			SkillType = "CombatTypeSkill",
			Abilities = { "Reveal" },
			GainFactor = 0.7,
		},
		PoisoningSkill = {
			DisplayName = "Poisoning",
			SkillIcon = "Poison",
			PrimaryStat = "Intelligence",
			Description = "Poison a bladed weapon.",
			SkillType = "TradeTypeSkill",
			GainFactor = 0.7
		},
		HidingSkill = {
			DisplayName = "Hiding",
			SkillIcon = "Skill_Rogue",
			PrimaryStat = "Agility",
			Description = "Hiding determines how well you can conceal yourself from the sight of others.",
			SkillType = "CombatTypeSkill",
			Abilities = { "Hide" },
			GainFactor = 0.7,
		},
		StealthSkill = {
			DisplayName = "Stealth",
			SkillIcon = "Skill_Rogue",
			PrimaryStat = "Agility",
			Description = "Stealth determines how effective you are at remaining concealed whilst moving. Start stop movement will reveal you quickly.",
			SkillType = "CombatTypeSkill",			
			GainFactor = 0.7,
		},
		LightArmorSkill = {
			DisplayName = "Light Armor",
			SkillIcon = "Skill_LightArmorProficiency",
			PrimaryStat = "Agility",
			Description = "Increases your Defense in Light Armor.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.3,
		},
		HeavyArmorSkill = {
			DisplayName = "Heavy Armor",
			PrimaryStat = "Agility",
			Description = "Increases your Defense in Heavy Armor.",
			SkillType = "CombatTypeSkill",
			SkillIcon = "Skill_Knight",
			GainFactor = 0.3
		},
		ArmsLoreSkill = {
			DisplayName = "Arms Lore",
			PrimaryStat = "Agility",
			Description = "Increases your effectiveness at using and crafting armor and weaponry.",
			SkillType = "TradeTypeSkill",
			SkillIcon = "Skill_Knight",
			GainFactor = 0.4,
			Abilities = { "Identify" },
		},
		TreasureHuntingSkill = {
			DisplayName = "Treasure Hunting",
			PrimaryStat = "Intelligence",
			Description = "Your ability to decipher treasure maps and locate buried treasure.",
			SkillType = "CombatTypeSkill",
			SkillIcon = "Skill_Inscription",
			GainFactor = 0.7,
		},
		LockpickingSkill = {
			DisplayName = "Lockpicking",
			PrimaryStat = "Agility",
			Description = "Your effectiveness using lockpicking tools to open locked chests.",
			SkillType = "TradeTypeSkill",
			SkillIcon = "Skill_Inscription",
			GainFactor = 0.5,
		},
		HarvestingSkill = {
			DisplayName = "Harvesting",
			PrimaryStat = "Wisdom",
			Description = "Your experience improves your abilities when harvesting.",
			SkillType = "TradeTypeSkill",
			SkillIcon = "Skill_Inscription",
			GainFactor = 0.4,
		},
		MentoringSkill = {
			DisplayName = "Mentoring",
			PrimaryStat = "Wisdom",
			Description = "Teach others the ways of the world.",
			SkillType = "TradeTypeSkill",
			SkillIcon = "Skill_Inscription",
			GainFactor = 0.3,
			Abilities = { "Mentor" },
		},
		--[[StealingSkill = {
			DisplayName = "Stealing",
			PrimaryStat = "Agility",
			Description = "Your effectiveness at taking what does not belong to you without being seen.",
			SkillType = "TradeTypeSkill",
			SkillIcon = "Skill_Rogue",
			GainFactor = 0.5,
			Abilities = { "Steal" },
		},]]

		--[[
		ForensicEvaluationSkill = {
			DisplayName = "Forensic Evaluation",
			PrimaryStat = "Intelligence",
			Description = "Use clues to determine the perpetrator of a crime.",
			SkillType = "TradeTypeSkill",
			GainFactor = 1,
		}]]
	},
}