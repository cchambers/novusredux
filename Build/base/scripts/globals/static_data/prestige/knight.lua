PrestigeData.Knight = {
	DisplayName = "Knight",
	Description = "A Knight.",
	Abilities = {
		ShieldBash = {
			Action = {
				DisplayName = "Shield Bash",
				Icon = "Block",				
				Enabled = true
			},

			RequireShield = true,
			RequireCombatTarget = true,

			Levels = {
				{	
					Prerequisites = {
				        BlockingSkill = 20,
				        HeavyArmorSkill = 20,
				    },

				    Tooltip = "Stun the target for 2 seconds. Reduced to 1 second for players.",

					MobileEffect = "ShieldBash",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(2),
						PlayerDuration = TimeSpan.FromSeconds(1)
					},
					Cooldown = TimeSpan.FromSeconds(15),
				},
				{	
					Prerequisites = {
				        BlockingSkill = 50,
				        HeavyArmorSkill = 50,
				    },

				    Tooltip = "Stun the target for 4 seconds. Reduced to 2 second for players.",

					MobileEffect = "ShieldBash",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(4),
						PlayerDuration = TimeSpan.FromSeconds(2)
					},
					Cooldown = TimeSpan.FromSeconds(15),
				},
				{	
					Prerequisites = {
				        BlockingSkill = 80,
				        HeavyArmorSkill = 80,
				    },

				    Tooltip = "Stun the target for 6 seconds. Reduced to 3 second for players.",

					MobileEffect = "ShieldBash",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(6),
						PlayerDuration = TimeSpan.FromSeconds(3)
					},
					Cooldown = TimeSpan.FromSeconds(15),
				},
			}
		},
		Heroism = {
			Action = {
				DisplayName = "Heroism",
				Icon = "Martial Arts 03",				
				Enabled = true
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
		},
		Vanguard = {
			Action = {
				DisplayName = "Vanguard",
				Icon = "Fire Shield",				
				Enabled = true,
				RequireShield = true
			},
			
			NoResetSwing = true,

			Levels = {
				{
					Prerequisites = {
				        HeavyArmorSkill = 20,
				   
				    },

				    Tooltip = "Movement speed is reduced by 30%, damage received is reduced by 60% and returning it to the attacker. Duration 3 seconds.",

					MobileEffect = "Vanguard",
					MobileEffectArgs = {
						RunSpeedModifier = -0.3,
						DamageReturnModifier = -0.6,
						DamageReductionModifier = -0.6,
						Duration = TimeSpan.FromSeconds(3)
					},
					Cooldown = TimeSpan.FromSeconds(30),
				},
				{
					Prerequisites = {
				        HeavyArmorSkill = 50,
				    },

				    Tooltip = "Movement speed is reduced by 25%, damage received is reduced by 70% and returning it to the attacker. Duration 4 seconds.",

					MobileEffect = "Vanguard",
					MobileEffectArgs = {
						RunSpeedModifier = -0.25,
						DamageReturnModifier = -0.7,
						DamageReductionModifier = -0.7,
						Duration = TimeSpan.FromSeconds(4)
					},
					Cooldown = TimeSpan.FromSeconds(30),
				},
				{
					Prerequisites = {
				        HeavyArmorSkill = 80,
				    },

				    Tooltip = "Movement speed is reduced by 20%, damage received is reduced by 80% and returning it to the attacker. Duration 5 seconds.",

					MobileEffect = "Vanguard",
					MobileEffectArgs = {
						RunSpeedModifier = -0.2,
						DamageReturnModifier = -0.8,
						DamageReductionModifier = -0.8,
						Duration = TimeSpan.FromSeconds(5)
					},
					Cooldown = TimeSpan.FromSeconds(30),
				},
			}
		},
		Charge = {
			Action = {
				DisplayName = "Charge",
				Icon = "Berserker Rage",				
				Enabled = true,
			},

			RequireCombatTarget = true,
			RequireHeavyArmor = true,

			Levels = {
				{
					Prerequisites = {
						HeavyArmorSkill = 20,
				        { SlashingSkill = 20, BashingSkill = 20, PiercingSkill = 20, }
				    },

				    Tooltip = "Charge at your target and stun them for 1 seconds.",

					Range = 10,

					MobileEffect = "Charge",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(1)
					},
					Cooldown = TimeSpan.FromSeconds(20),
				},
				{
					Prerequisites = {
						HeavyArmorSkill = 20,
				        { SlashingSkill = 50, BashingSkill = 50, PiercingSkill = 50, }
				    },

				    Tooltip = "Charge at your target and stun them for 2 seconds.",

					Range = 10,

					MobileEffect = "Charge",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(2)
					},
					Cooldown = TimeSpan.FromSeconds(20),
				},
				{
					Prerequisites = {
						HeavyArmorSkill = 20,
				        { SlashingSkill = 80, BashingSkill = 80, PiercingSkill = 80, }
				    },

				    Tooltip = "Charge at your target and stun them for 3 second.",

					Range = 10,

					MobileEffect = "Charge",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(3)
					},
					Cooldown = TimeSpan.FromSeconds(20),
				},
			},
		}
		--[[RighteousWeapon = {
			Action = {
				DisplayName = "Righteous Weapon",
				IconText = "RiWe",
				Tooltip = "Imbues the Knight's weapon with a righteous aura, dealing increased damage based upon the wielders karma.",
				Enabled = true
			},
			Level = 4,
			MobileEffect = "RighteousWeapon",
			MobileEffectArgs = {
				Duration = TimeSpan.FromSeconds(2)
			},
			Cooldown = TimeSpan.FromSeconds(10)
		},
		HealCubic = {
			Action = {
				DisplayName = "Heal Cubic",
				IconText = "HeCu",
				Tooltip = "Summon a cubic of Health, curing/healing you for 10-20 health every 3-6 seconds. Duration 20 Minutes.",
				Enabled = true
			},
			Level = 5,
			MobileEffect = "Cubic",
			MobileEffectArgs = {
				Radius = 5,
				MinHealAmount = 10,
				MaxHealAmount = 20,
				PulseFrequency = TimeSpan.FromSeconds(3),
				PulseMax = 100
			},
			Cooldown = TimeSpan.FromSeconds(10)
		},]]
	},
}