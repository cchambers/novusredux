SkillData = {
	AllSkills= {
		MeleeSkill = {
			DisplayName = "Vigor",
			SkillIcon = "Skill_Endurance",
			PrimaryStat = "Agility",
			Description = "Vigor determines the effectiveness of bandaging and offers a damage bonus with melee and ranged weapons.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.2,
		},
		PiercingSkill = {
			DisplayName = "Piercing",
			PrimaryStat = "Agility",
			Description = "Piercing determines your effeciency when fighting with piercing weapons.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.2,
		},
		SlashingSkill = {
			DisplayName = "Slashing",
			PrimaryStat = "Strength",
			Description = "Slashing determines your effeciency when fighting with slashing weapons.",
			SkillType = "CombatTypeSkill",
			GGainFactor = 0.2,
		},
		LancingSkill = {
			DisplayName = "Lancing",
			PrimaryStat = "Strength",
			Description = "Lancing determines your effeciency when fighting with lancing weapons.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.25,
		},
		BashingSkill = {
			DisplayName = "Bashing",
			PrimaryStat = "Strength",
			Description = "Bashing determines your effeciency when fighting with bashing weapons.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.25,
		},
		HealingSkill = {
			DisplayName = "Healing",
			Description = "Healing determines your ability to heal humans and animals.",
			PrimaryStat = "Agility",
			SkillType = "CombatTypeSkill",
			SkillIcon = "Skill_Regeneration",
			GainFactor = 1,
			Options = {
				SkillRequiredToResurrect = 80,
				HealTimeBaseSelf = 8000,
				HealTimeBaseOther = 8000,
				MinHealTime = 3000,
				InterruptDamagePlayer = 19,
				InterruptDamageNPC = 26,
				BandageRange = 3.25
			}
		},
		-- MAGIC SKILLS
		MagicAffinitySkill = {
			DisplayName = "Magic Affinity",
			PrimaryStat = "Intelligence",
			NoStatGain = true,
			Description = "Magic Affinity determines the power of your offensive spells.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.4,
		},
		ManifestationSkill = {
			DisplayName = "Manifestation",
			PrimaryStat = "Intelligence",
			Description = "Manifestation determines your knowledge of beneficial spells.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.4,
		},
		ChannelingSkill = {
			DisplayName = "Channeling",
			PrimaryStat = "Intelligence",
			Description = "Channeling determines your ability to actively and passively regenerate mana.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.375,
			Abilities = { "Focus" },
		},
		EvocationSkill = {
			DisplayName = "Evocation",
			PrimaryStat = "Intelligence",
			Description = "Evocation determines your knowledge of damage dealing spells.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.4,
		},
		-- END MAGIC SKILLS
		BlockingSkill = {
			DisplayName = "Blocking",
			PrimaryStat = "Strength",
			Description = "Blocking determines your effectiveness using a shield.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.3,
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
			Skip = true,
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
		},
		FishingSkill = {
			DisplayName = "Fishing",
			PrimaryStat = "Intelligence",
			Description = "[$3291]",
			SkillType = "TradeTypeSkill",
			GainFactor = 0.5
		},	
		LumberjackSkill = {
			DisplayName = "Lumberjack",
			PrimaryStat = "Strength",
			Description = "[$3295]",
			SkillType = "TradeTypeSkill",
			GainFactor = 0.275,
			--Skip = true,
		},
		MiningSkill = {
			DisplayName = "Mining",
			PrimaryStat = "Strength",
			Description = "[$3296]",
			SkillType = "TradeTypeSkill",
			GainFactor = 0.275,
			--Skip = true,
		},
		FabricationSkill = {
			DisplayName = "Fabrication",
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
		InscriptionSkill = {
			DisplayName = "Inscription",
			PrimaryStat = "Intelligence",
			Description = "The ability to craft spell scrolls & spellbooks.",
			SkillType = "TradeTypeSkill",
			GainFactor = 0.7,
		},
		BardSkill = {
			DisplayName = "Bard",
			PrimaryStat = "Intelligence",
			Description = "Use music to accomplish more than sound.",
			SkillType = "CombatTypeSkill",
			Skip = true,
			GainFactor = 2.5,
		},
		AnimalTamingSkill = {
			DisplayName = "Animal Taming",
			PrimaryStat = "Intelligence",
			Description = "Animal Taming is your ability to control certain creatures.",
			SkillType = "CombatTypeSkill",
			SkillIcon = "Skill_AnimalKen",
			Abilities = { "Command" },
			GainFactor = 0.2,
		},
		BeastmasterySkill = {
			DisplayName = "Beastmastery",
			PrimaryStat = "Intelligence",
			Description = "Beastmastery is your ability to control beasts. Beasts are powerful creatures that aid in combat, You must master Animal Taming before you can learn to control beasts.",
			SkillType = "CombatTypeSkill",
			SkillIcon = "Skill_BeastMastery",
			GainFactor = 0.2,
		},
		AnimalLoreSkill = {
			DisplayName = "Animal Lore",
			PrimaryStat = "Intelligence",
			Description = "Your knowledge of animals. Determines your ability to control and adds a bonus to healing your pets.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.2,
		},
		ArcherySkill = {
			DisplayName = "Archery",
			PrimaryStat = "Agility",
			Description = "Archery determines your effectiveness with a bow and arrow.",
			SkillType = "CombatTypeSkill",
			GainFactor = 0.3,
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
			GainFactor = 0.3,
		},

		TreasureHuntingSkill = {
			DisplayName = "Treasure Hunting",
			PrimaryStat = "Intelligence",
			Description = "Your ability to decipher treasure maps and locate buried treasure.",
			SkillType = "CombatTypeSkill",
			SkillIcon = "Skill_Inscription",
			GainFactor = 0.7,
		},

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