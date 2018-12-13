PrestigeData.Mage = {
	DisplayName = "Mage",
	Description = "A Mage.",
	Abilities = {
		SpellChamber = {
			Rank = 1,
			Action = {
				DisplayName = "Spell Chamber",
				Icon = "Unholy Mastery",				
				Enabled = true
			},
			
			NoResetSwing = true,

			Prerequisites = {
				MagerySkill = 40,
			},

			Tooltip = "When activated, the next spell cast (5 difficulty or less) may be stored and released at will.",

			MobileEffect = "SpellChamber",
			MobileEffectArgs = {
				Duration = TimeSpan.FromMinutes(10),
				MaxDifficulty = 5,
			},
			Cooldown = TimeSpan.FromSeconds(30)
		},
		MageArmor = {
			Rank = 3,
			Action = {
				DisplayName = "Mage Armor",
				Icon = "Arcane Shield2",
				Enabled = true
			},

			NoResetSwing = true,

			Prerequisites = {
				MagerySkill = 80,
			},

			Tooltip = "Prevents interruptions & reflects spell damage back at the attacker to a total of 200 damage. Duration 10 seconds.",

			MobileEffect = "MageArmor",
			MobileEffectArgs = {
				Duration = TimeSpan.FromSeconds(10),
				MaxReflected = 200,
			},
			Cooldown = TimeSpan.FromMinutes(2),
			CastTime = TimeSpan.FromSeconds(1)
		},
		Silence = {
			Rank = 2,
			Action = {
				DisplayName = "Silence",
				Icon = "Shock Wave",				
				Enabled = true
			},

			RequireCombatTarget = true,
			NoResetSwing = true,

			Prerequisites = {
				MagerySkill = 60,
				ChannelingSkill = 60,
			},

			Tooltip = "Silences the target from spellcasting for 3 seconds. If silenced during casting, Silence duration is increased by 2 seconds.",

			TargetMobileEffect = "Silence",
			TargetMobileEffectArgs = {
				Duration = TimeSpan.FromSeconds(3),
			},
			Cooldown = TimeSpan.FromSeconds(30),
			Range = 15
		},
		Stasis = {
			Rank = 2,
			Action = {
				DisplayName = "Ice Barrier",
				Icon = "Ice Barrier",				
				Enabled = true
			},

			Prerequisites = {
				MagerySkill = 60,
			},

			Tooltip = "Summon an ice barrier, becoming immobile and immune to damage. Cannot cast, use abilities or items. Duration 5 seconds.",

			MobileEffect = "Stasis",
			MobileEffectArgs = {
				Duration = TimeSpan.FromSeconds(5),
			},
			Cooldown = TimeSpan.FromMinutes(1)
		},
		Meditation = {
			Rank = 3,
			Action = {
				DisplayName = "Meditation",
				Icon = "Night",
				Enabled = true
			},

			NoResetSwing = true,

			Prerequisites = {
				MagerySkill = 80,
			},

			Tooltip = "Increase mana regeneration significantly for 30 seconds, while standing still.",

			MobileEffect = "Meditation",
			MobileEffectArgs = {
				Duration = TimeSpan.FromSeconds(30),
			},
			Cooldown = TimeSpan.FromMinutes(2)
		},
		Empower = {
			Rank = 1,
			Action = {
				DisplayName = "Empower",
				Icon = "Regrowth",				
				Enabled = true
			},
			
			NoResetSwing = true,
			NoCombat = true,

			Prerequisites = {
				MagerySkill = 40,
			},

			Tooltip = "Your heal spells will do 80% healing to friendly targets within 8 yards of target. Lasts 10 seconds.",

			MobileEffect = "Empower",
			MobileEffectArgs = {
				Duration = TimeSpan.FromSeconds(10),
				Modifier = 0.8,
			},
			Cooldown = TimeSpan.FromSeconds(30),
		}
	},
}