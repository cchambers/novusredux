PrestigeData.Sorcerer = {
	DisplayName = "Sorcerer",
	Description = "A Sorcerer.",
	Abilities = {
		SpellChamber = {
			Action = {
				DisplayName = "SpellChamber",
				Icon = "Unholy Mastery",				
				Enabled = true
			},
			
			NoResetSwing = true,
			
			Levels = {
				{
					Prerequisites = {
						ChannelingSkill = 20,
						EvocationSkill = 20,
					},

					Tooltip = "When activated, the next spell cast (2 difficulty or less) may be stored and released at will.",

					MobileEffect = "SpellChamber",
					MobileEffectArgs = {
						Duration = TimeSpan.FromMinutes(10),
						MaxDifficulty = 2,
					},
					Cooldown = TimeSpan.FromMinutes(2)
				},
				{
					Prerequisites = {
						ChannelingSkill = 30,
						EvocationSkill = 30,
					},

					Tooltip = "When activated, the next spell cast (4 difficulty or less) may be stored and released at will.",

					MobileEffect = "SpellChamber",
					MobileEffectArgs = {
						Duration = TimeSpan.FromMinutes(10),
						MaxDifficulty = 4,
					},
					Cooldown = TimeSpan.FromMinutes(2)
				},
				{
					Prerequisites = {
						ChannelingSkill = 80,
						EvocationSkill = 80,
					},

					Tooltip = "When activated, the next spell cast (6 difficulty or less) may be stored and released at will.",

					MobileEffect = "SpellChamber",
					MobileEffectArgs = {
						Duration = TimeSpan.FromMinutes(10),
						MaxDifficulty = 6,
					},
					Cooldown = TimeSpan.FromMinutes(2)
				},
			},
		},
		Destruction = {
			Action = {
				DisplayName = "Destruction",
				Icon = "Unholy Blast",				
				Enabled = true
			},

			NoResetSwing = true,

			Levels = {
				{
					Prerequisites = {
						ChannelingSkill = 20,
						EvocationSkill = 20,
					},

					Tooltip = "Your direct hit spells will do 40% damage to enemies within 8 yards of target. Lasts 10 seconds.",

					MobileEffect = "Destruction",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(10),
						Modifier = 0.4,
					},
					Cooldown = TimeSpan.FromMinutes(3)
				},
				{
					Prerequisites = {
						ChannelingSkill = 30,
						EvocationSkill = 30,
					},
					
					Tooltip = "Your direct hit spells will do 60% damage to enemies within 8 yards of target. Lasts 10 seconds.",

					MobileEffect = "Destruction",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(10),
						Modifier = 0.6,
					},
					Cooldown = TimeSpan.FromMinutes(3)
				},
				{
					Prerequisites = {
						ChannelingSkill = 80,
						EvocationSkill = 80,
					},
					
					Tooltip = "Your direct hit spells will do 80% damage to enemies within 8 yards of target. Lasts 10 seconds.",

					MobileEffect = "Destruction",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(10),
						Modifier = 0.8,
					},
					Cooldown = TimeSpan.FromMinutes(3)
				},
			},
		},
		Spellshield = {
			Action = {
				DisplayName = "Spellshield",
				Icon = "Spell Shield",
				Enabled = true
			},

			NoResetSwing = true,
			
			Levels = {
				{
					Prerequisites = {
						ManifestationSkill = 20,
						ChannelingSkill = 20,
					},

					Tooltip = "Reflects spell damage back at the attacker to a total of 50 damage. Duration 7 seconds.",

					MobileEffect = "Spellshield",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(7),
						MaxReflected = 50
					},
					Cooldown = TimeSpan.FromMinutes(5)
				},
				{
					Prerequisites = {
						ManifestationSkill = 30,
						ChannelingSkill = 30,
					},

					Tooltip = "Reflects spell damage back at the attacker to a total of 150 damage. Duration 7 seconds.",

					MobileEffect = "Spellshield",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(7),
						MaxReflected = 150
					},
					Cooldown = TimeSpan.FromMinutes(5)
				},
				{
					Prerequisites = {
						ManifestationSkill = 80,
						ChannelingSkill = 80,
					},

					Tooltip = "Reflects spell damage back at the attacker to a total of 250 damage. Duration 7 seconds.",

					MobileEffect = "Spellshield",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(7),
						MaxReflected = 250
					},
					Cooldown = TimeSpan.FromMinutes(5)
				}
			}
		},
	},
}