PrestigeData.Fighter = {
	DisplayName = "Fighter",
	Description = "A Fighter.",
	Abilities = {
		ShieldBash = {
			Rank = 2,
			Action = {
				DisplayName = "Shield Bash",
				Icon = "Block",				
				Enabled = true
			},

			RequireShield = true,
			RequireCombatTarget = true,
			RequireHeavyArmor = true,

			Prerequisites = {
				        BlockingSkill = 60,
				        HeavyArmorSkill = 60,
				    },

				    Tooltip = "Stun the target for 8 seconds. Reduced to 4 second for players.",

					MobileEffect = "ShieldBash",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(8),
						PlayerDuration = TimeSpan.FromSeconds(4),
					},
					Cooldown = TimeSpan.FromSeconds(20),
		},
		--[[Heroism = {
			Action = {
				DisplayName = "Heroism",
				Icon = "Martial Arts 03",				
				Enabled = false
			},
			
			NoResetSwing = true,
			
			Levels = {
				{
					Prerequisites = {
				        { SlashingSkill = 20, BashingSkill = 20, PiercingSkill = 20, ArcherySkill = 20, }
				    },

				    Tooltip = "Taunts monsters in a 15 yard radius, forcing them to attack you. Increases Defense by 15. Duration 4 seconds.",

					MobileEffect = "Heroism",
					MobileEffectArgs = {
						Radius = 15,
						Bonus = 15,
						Duration = TimeSpan.FromSeconds(4)
					},
					Cooldown = TimeSpan.FromSeconds(10)
				},
				{
					Prerequisites = {
				        MeleeSkill = 30,
				        { SlashingSkill = 30, BashingSkill = 30, PiercingSkill = 30, }
				    },

				    Tooltip = "Taunts monsters in a 20 yard radius, forcing them to attack you. Increases Defense by 20. Duration 6 seconds.",

					MobileEffect = "Heroism",
					MobileEffectArgs = {
						Radius = 20,
						Bonus = 20,
						Duration = TimeSpan.FromSeconds(6)
					},
					Cooldown = TimeSpan.FromSeconds(10)
				},
				{
					Prerequisites = {
				        MeleeSkill = 80,
				        { SlashingSkill = 80, 	BashingSkill = 80, 	PiercingSkill = 80, }
				    },

				    Tooltip = "Taunts monsters in a 25 yard radius, forcing them to attack you. Increases Defense by 25. Duration 8 seconds.",

					MobileEffect = "Heroism",
					MobileEffectArgs = {
						Radius = 25,
						Bonus = 25,
						Duration = TimeSpan.FromSeconds(8)
					},
					Cooldown = TimeSpan.FromSeconds(10)
				},
			}
		},]]
		Vanguard = {
			Rank = 3,
			Action = {
				DisplayName = "Vanguard",
				Icon = "Fire Shield",				
				Enabled = true,
			},
			
			NoResetSwing = true,
			RequireHeavyArmor = true,
			RequireShield = true,

			Prerequisites = {
				        HeavyArmorSkill = 80,
				        BlockingSkill = 80,
				    },

				    Tooltip = "Movement speed reduced by 20%. Damage received reduced by 80%. Half all recieve is reflected. Duration 5 seconds.",

					MobileEffect = "Vanguard",
					MobileEffectArgs = {
						RunSpeedModifier = -0.2,
						DamageReturnModifier = -0.5,
						DamageReductionModifier = -0.8,
						Duration = TimeSpan.FromSeconds(5),
					},
					Cooldown = TimeSpan.FromMinutes(2),
		},
		Charge = {
			Rank = 2,
			Action = {
				DisplayName = "Charge",
				Icon = "Summon Bear",				
				Enabled = true,
			},

			RequireCombatTarget = true,

			NoResetSwing = true,

			Prerequisites = {
				        { SlashingSkill = 60, BashingSkill = 60, PiercingSkill = 60, LancingSkill = 60, BrawlingSkill = 60 },
				        MeleeSkill = 60,
				    },

				    Tooltip = "Charge at your target and stun them for 3 second.",

					Range = 10,

					MobileEffect = "Charge",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(3),
					},
					Cooldown = TimeSpan.FromSeconds(20),
		},
		StunStrike = {
			Rank = 1,
			Action = {
				DisplayName = "Stun Strike",
				Icon = "Blink Strike",				
				Enabled = true
			},

			RequireWeaponClass = "PoleArm",

			Prerequisites = {
				        LancingSkill = 40,
					},

					Tooltip = "Stun all enemies 4 yards in front of you for 5 seconds. Stuns players for 3 second.",

					MobileEffect = "StunStrike",
					MobileEffectArgs = {
						Radius = 5,
						Duration = TimeSpan.FromSeconds(5),
						PlayerDuration = TimeSpan.FromSeconds(3),
					},
					Cooldown = TimeSpan.FromSeconds(20),
		},
		Hamstring = {
			Rank = 1,
			Action = {
				DisplayName = "Hamstring",
				Icon = "Weapon Throw",				
				Enabled = true
			},

			RequireCombatTarget = true,
			NoResetSwing = true,
			PreventRanged = true,

			Prerequisites = {
				        MeleeSkill = 40,
					},
					
					Tooltip = "Reduces your targets runspeed by 50% for 6 seconds.",

					TargetMobileEffect = "Hamstring",
					TargetMobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(6),
						Modifier = -0.5,
					},
					Cooldown = TimeSpan.FromSeconds(20),		
		},
		AdrenalineRush = {
			Rank = 3,
			Action = {
				DisplayName = "Adrenaline Rush",
				Icon = "Berserker Rage",				
				Enabled = true
			},

			Instant = true,
		    NoTarget = true,
		    NoCombat = false,	

		    Prerequisites = {
				        MeleeSkill = 80,
				        LightArmorSkill = 80
					},
					
					Tooltip = "Feel a rush of adrenaline and restore stamina rapidly.",

					MobileEffect = "AdrenalineRush",
					MobileEffectArgs = {
						Modifier = 0.15,
					},
					Cooldown = TimeSpan.FromSeconds(120),		
		},
	},
}