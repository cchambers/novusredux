PrestigeData.Fieldmage = {
	DisplayName = "Field Mage",
	Description = "A Field Mage.",
	
	Abilities = {
		Stasis = {
			Action = {
				DisplayName = "Stasis",
				Icon = "Far Sight",				
				Enabled = true
			},

			Levels = {
				{				
					Prerequisites = {
						ManifestationSkill = 20,
						ChannelingSkill = 20,
					},

					Tooltip = "Enter a stasis field, becoming immobile and immune to damage. Cannot cast, use abilities or items. Duration 4 seconds.",

					MobileEffect = "Stasis",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(4),
					},
					Cooldown = TimeSpan.FromSeconds(60)
				},
				{
					Prerequisites = {
						ManifestationSkill = 30,
						ChannelingSkill = 30,
					},

					Tooltip = "Enter a stasis field, becoming immobile and immune to damage. Cannot cast, use abilities or items. Duration 6 seconds.",

					MobileEffect = "Stasis",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(6),
					},
					Cooldown = TimeSpan.FromSeconds(60)
				},
				{
					Prerequisites = {
						ManifestationSkill = 80,
						ChannelingSkill = 80,
					},

					Tooltip = "Enter a stasis field, becoming immobile and immune to damage. Cannot cast, use abilities or items. Duration 8 seconds.",

					MobileEffect = "Stasis",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(8),
					},
					Cooldown = TimeSpan.FromSeconds(60)
				}
			}
			
		},
		Silence = {
			Action = {
				DisplayName = "Silence",
				Icon = "Shock Wave",				
				Enabled = true
			},

			RequireCombatTarget = true,
			NoResetSwing = true,

			Levels = {
				{
					Prerequisites = {
						ManifestationSkill = 20,
						ChannelingSkill = 20,
					},

					Tooltip = "Silences the target from spellcasting for 1 seconds. If silenced during casting, Silence duration is increased by 2 seconds.",

					TargetMobileEffect = "Silence",
					TargetMobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(1)
					},
					Cooldown = TimeSpan.FromSeconds(20),					
					Range = 15
				},
				{
					Prerequisites = {
						ManifestationSkill = 30,
						ChannelingSkill = 30,
					},

					Tooltip = "Silences the target from spellcasting for 2 seconds. If silenced during casting, Silence duration is increased by 2 seconds.",

					TargetMobileEffect = "Silence",
					TargetMobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(2)
					},
					Cooldown = TimeSpan.FromSeconds(20),
					Range = 15
				},
				{
					Prerequisites = {
						ManifestationSkill = 80,
						ChannelingSkill = 80,
					},

					Tooltip = "Silences the target from spellcasting for 3 seconds. If silenced during casting, Silence duration is increased by 2 seconds.",

					TargetMobileEffect = "Silence",
					TargetMobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(3)
					},
					Cooldown = TimeSpan.FromSeconds(20),
					Range = 15
				},
			}	
		},
		Empower = {
			Action = {
				DisplayName = "Empower",
				Icon = "Spectral Ball",				
				Enabled = true
			},
			
			NoResetSwing = true,
			NoCombat = true,

			Levels = {
				{
					Prerequisites = {
						ChannelingSkill = 20,
						MagicAffinitySkill = 20,
					},

					Tooltip = "Your heal spells will do 40% healing to friendly mobiles within 8 yards of target. Lasts 10 seconds.",

					MobileEffect = "Empower",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(10),
						Modifier = 0.4,
					},
					Cooldown = TimeSpan.FromMinutes(1),
				},
				{
					Prerequisites = {
						ChannelingSkill = 40,
						MagicAffinitySkill = 40,
					},

					Tooltip = "Your heal spells will do 60% healing to friendly mobiles within 8 yards of target. Lasts 10 seconds.",

					MobileEffect = "Empower",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(10),
						Modifier = 0.6,
					},
					Cooldown = TimeSpan.FromMinutes(1),
				},
				{
					Prerequisites = {
						ChannelingSkill = 60,
						MagicAffinitySkill = 60,
					},

					Tooltip = "Your heal spells will do 80% healing to friendly mobiles within 8 yards of target. Lasts 10 seconds.",

					MobileEffect = "Empower",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(10),
						Modifier = 0.8,
					},
					Cooldown = TimeSpan.FromMinutes(1),
				},
			}
		}
	},
}