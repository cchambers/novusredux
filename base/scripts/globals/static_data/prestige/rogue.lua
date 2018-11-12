PrestigeData.Rogue = {
	DisplayName = "Rogue",
	Description = "A Rogue.",
	
	Abilities = {
		Dart = {
			Action = {
				DisplayName = "Dart",
				Icon = "Blazing Speed",
				Enabled = true
			},

			NoCombat = true, -- don't need to force them into combat mode for this
			NoResetSwing = true,

			Levels = {
				{
					Prerequisites = {
						LightArmorSkill = 20,
					},

					Tooltip = "Increase movement speed by 10% for 5 seconds.",

					MobileEffect = "Dart",
					MobileEffectArgs = {
						Modifier = 0.1,
						Duration = TimeSpan.FromSeconds(5)
					},
					Cooldown = TimeSpan.FromSeconds(30)
				},
				{				
					Prerequisites = {
						LightArmorSkill = 50,
					},

					Tooltip = "Increase movement speed by 20% for 5 seconds.",

					MobileEffect = "Dart",
					MobileEffectArgs = {
						Modifier = 0.2,
						Duration = TimeSpan.FromSeconds(5)
					},
					Cooldown = TimeSpan.FromSeconds(30)
				},
				{				
					Prerequisites = {
						LightArmorSkill = 80,
					},

					Tooltip = "Increase movement speed by 30% for 5 seconds.",

					MobileEffect = "Dart",
					MobileEffectArgs = {
						Modifier = 0.3,
						Duration = TimeSpan.FromSeconds(5)
					},
					Cooldown = TimeSpan.FromSeconds(30)
				},
			}
		},
		Evasion = {
			Action = {
				DisplayName = "Evasion",
				Icon = "Quick Shot",
				Enabled = true
			},

			NoCombat = true, -- don't need to force them into combat mode for this
			NoResetSwing = true,

			Levels = {
				{
					Prerequisites = {
						LightArmorSkill = 20,
					},

					Tooltip = "Increase evasion by 2 for 5 seconds.",

					MobileEffect = "Evasion",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(5),
						Amount = 2
					},
					Cooldown = TimeSpan.FromSeconds(30)
				},
				{
					Prerequisites = {
						LightArmorSkill = 50,
					},

					Tooltip = "Increase evasion by 5 for 6 seconds.",

					MobileEffect = "Evasion",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(6),
						Amount = 5
					},
					Cooldown = TimeSpan.FromSeconds(30)
				},
				{
					Prerequisites = {
						LightArmorSkill = 80,
					},

					Tooltip = "Increase evasion by 10 for 7 seconds.",

					MobileEffect = "Evasion",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(7),
						Amount = 10
					},
					Cooldown = TimeSpan.FromSeconds(30)
				},
			}
		},
		--[[
		Backstab = {
			Action = {
				DisplayName = "Backstab",
				Icon = "Fan of Daggers",
				Enabled = false
			},

			RequireCombatTarget = true,
			RequireBehindTarget = true,
			RequireWeaponClass = "Dagger",

			Levels = {
				{
					Prerequisites = {
						PiercingSkill = 20,
					},

					Tooltip = "Instant weapon swing with 50 extra attack, must be behind target and wielding a dagger.",

					MobileEffect = "Backstab",
					MobileEffectArgs = {
						AttackPlus = 50,
					},
					Cooldown = TimeSpan.FromSeconds(20)
				},
				{
					Prerequisites = {
						PiercingSkill = 50,
					},

					Tooltip = "Instant weapon swing with 70 extra attack, must be behind target and wielding a dagger.",

					MobileEffect = "Backstab",
					MobileEffectArgs = {
						AttackPlus = 70,
					},
					Cooldown = TimeSpan.FromSeconds(20)
				},
				{
					Prerequisites = {
						PiercingSkill = 80,
					},

					Tooltip = "Instant weapon swing with 90 extra attack, must be behind target and wielding a dagger.",

					MobileEffect = "Backstab",
					MobileEffectArgs = {
						AttackPlus = 90,
					},
					Cooldown = TimeSpan.FromSeconds(20)
				},
			}
		},
		]]
		Vanish = {
			Action = {
				DisplayName = "Vanish",
				Icon = "Phantom",
				Enabled = true
			},

			Levels = {
				{
					Prerequisites = {
						HidingSkill = 20,
						StealthSkill = 20,
					},

					Tooltip = "Instantly hide. Removes all player debuffs.",

					MobileEffect = "Vanish",
					Cooldown = TimeSpan.FromMinutes(6)
				},
				{
					Prerequisites = {
						HidingSkill = 50,
						StealthSkill = 50,
					},

					Tooltip = "Instantly hide. Removes all player debuffs.",

					MobileEffect = "Vanish",
					Cooldown = TimeSpan.FromMinutes(4)
				},
				{
					Prerequisites = {
						HidingSkill = 80,
						StealthSkill = 80,
					},

					Tooltip = "Instantly hide. Removes all player debuffs.",

					MobileEffect = "Vanish",
					Cooldown = TimeSpan.FromMinutes(2)
				},
			}
		}
	},
}