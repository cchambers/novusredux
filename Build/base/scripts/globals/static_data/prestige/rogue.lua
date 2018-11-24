PrestigeData.Rogue = {
	DisplayName = "Rogue",
	Description = "A Rogue.",
	
	Abilities = {
		Dart = {
			Rank = 1,
			Action = {
				DisplayName = "Dart",
				Icon = "Blazing Speed",
				Enabled = true
			},

			NoCombat = true, -- don't need to force them into combat mode for this
			NoResetSwing = true,
			RequireLightArmor = true,

			Prerequisites = {
						LightArmorSkill = 40,
					},

					Tooltip = "Increase movement speed by 30% for 5 seconds.",

					MobileEffect = "Dart",
					MobileEffectArgs = {
						Modifier = 0.3,
						Duration = TimeSpan.FromSeconds(5),
					},
					Cooldown = TimeSpan.FromSeconds(30)
		},
		Evasion = {
			Rank = 2,
			Action = {
				DisplayName = "Evasion",
				Icon = "Quick Shot",
				Enabled = true
			},

			NoCombat = true, -- don't need to force them into combat mode for this
			NoResetSwing = true,
			RequireLightArmor = true,

			Prerequisites = {
						LightArmorSkill = 60,
					},

					Tooltip = "Increase evasion by 10 for 7 seconds.",

					MobileEffect = "Evasion",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(7),
						Amount = 250,
					},
					Cooldown = TimeSpan.FromSeconds(30)
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
			Rank = 3,
			Action = {
				DisplayName = "Vanish",
				Icon = "Phantom",
				Enabled = true
			},

			Prerequisites = {
						HidingSkill = 80,
						StealthSkill = 80,
					},

					Tooltip = "Instantly hide. Removes all player debuffs.",

					MobileEffect = "Vanish",
					Cooldown = TimeSpan.FromMinutes(1)
		},
		--[[Snipe = {
			Action = {
				DisplayName = "Snipe",
				Icon = "Burning Arrow",				
				Enabled = false
			},

			RequireRanged = true,
			RequireCombatTarget = true,
			-- functions to make the cast look better
			PreCast = PrestigePreCastBow,
			PostCast = PrestigePostCastBow,

			Levels = {
				{
					Prerequisites = {
						ArcherySkill = 20,
					},

					Tooltip = "100% chance to hit, attack increased by 80 for the shot. 4 second cast.",

					MobileEffect = "Snipe",
					MobileEffectArgs = {
						AttackPlus = 80,
					},
					Cooldown = TimeSpan.FromSeconds(10),
					CastTime = TimeSpan.FromSeconds(4),
				},
				{
					Prerequisites = {
						ArcherySkill = 50,
					},

					Tooltip = "100% chance to hit, attack increased by 120 for the shot. 3.5 second cast.",

					MobileEffect = "Snipe",
					MobileEffectArgs = {
						AttackPlus = 100,
					},
					Cooldown = TimeSpan.FromSeconds(10),
					CastTime = TimeSpan.FromSeconds(3.5),
				},
				{
					Prerequisites = {
						ArcherySkill = 70,
					},

					Tooltip = "100% chance to hit, attack increased by 160 for the shot. 3 second cast.",

					MobileEffect = "Snipe",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(3),
						AttackPlus = 120,
					},
					Cooldown = TimeSpan.FromSeconds(10),
					CastTime = TimeSpan.FromSeconds(3),
				},
			}
		},]]
		HuntersMark = {
			Rank = 3,
			Action = {
				DisplayName = "Hunters Mark",
				Icon = "Burning Arrow",				
				Enabled = true
			},

			RequireRanged = true,
			RequireCombatTarget = true,
			NoResetSwing = true,

			Prerequisites = {
						ArcherySkill = 80,
					},

					Tooltip = "Mark your target, preventing them from hiding/cloaking and increases all bow damage received by 9.99% for 30 seconds.",

					TargetMobileEffect = "HuntersMark",
					TargetMobileEffectArgs = {
						Modifier = 0.099,
					},
					Cooldown = TimeSpan.FromMinutes(2),
					CastTime = TimeSpan.FromSeconds(1),
		},
		StunShot = {
			Rank = 2,
			Action = {
				DisplayName = "Stun Shot",
				Icon = "Windshot",				
				Enabled = true
			},

			RequireRanged = true,
			RequireCombatTarget = true,
			-- functions to make the cast look better
			PreCast = PrestigePreCastBow,
			PostCast = PrestigePostCastBow,

			Prerequisites = {
						ArcherySkill = 80,
						MeleeSkill = 80,
					},

					Tooltip = "Stun your target for 5 seconds, 3 seconds for players.",

					MobileEffect = "StunShot",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(5),
						PlayerDuration = TimeSpan.FromSeconds(3),
					},
					Cooldown = TimeSpan.FromSeconds(20),
					CastTime = TimeSpan.FromSeconds(2),
		},
		Wound = {
			Rank = 1,
			Action = {
				DisplayName = "Wound",
				Icon = "Poison Arrow",				
				Enabled = true
			},

			RequireRanged = true,
			RequireCombatTarget = true,
			-- functions to make the cast look better
			PreCast = PrestigePreCastBow,
			PostCast = PrestigePostCastBow,

			Prerequisites = {
						ArcherySkill = 40,
					},

					Tooltip = "Wound your target, slowing them by 70% for 3 seconds. 0.5 second cast time.",

					TargetMobileEffect = "Hamstring",
					TargetMobileEffectArgs = {
						Modifier = -0.7,
						Duration = TimeSpan.FromSeconds(3),
					},

					Cooldown = TimeSpan.FromSeconds(15),
					CastTime = TimeSpan.FromSeconds(1),
		},
	},
}