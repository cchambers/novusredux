PrestigeData.Gladiator = {
	DisplayName = "Gladiator",
	Description = "A Gladiator.",
	Abilities = {
		--[[
		Pursuit = {
			Action = {
				DisplayName = "Pursuit",
				Icon = "Berserker Rage",				
				Enabled = true
			},
			Levels = {
				{
					Prerequisites = {
				        MeleeSkill = 20,
				        SlashingSkill = 20,
						BashingSkill = 20,
						PiercingSkill = 20,
					},

					Tooltip = "Pursuit temporarily raises your runspeed by 10% ever second for 4 seconds. Hitting your target during pursuits effect causes a weapon damage bonus equal to speed bonus.",

					MobileEffect = "Pursuit",
					MobileEffectArgs = {
						Modifier = 0.10,
						PulseFrequency = TimeSpan.FromSeconds(1),
						PulseMax = 4
					},
					Cooldown = TimeSpan.FromSeconds(20)
				},
				{
					Prerequisites = {
				        MeleeSkill = 30,
				        SlashingSkill = 30,
						BashingSkill = 30,
						PiercingSkill = 30,
					},

					Tooltip = "Pursuit temporarily raises your runspeed by 15% ever second for 4 seconds. Hitting your target during pursuits effect causes a weapon damage bonus equal to speed bonus.",

					MobileEffect = "Pursuit",
					MobileEffectArgs = {
						Modifier = 0.15,
						PulseFrequency = TimeSpan.FromSeconds(1),
						PulseMax = 4
					},
					Cooldown = TimeSpan.FromSeconds(20)
				},
				{
					Prerequisites = {
				        MeleeSkill = 80,
				        SlashingSkill = 80,
						BashingSkill = 80,
						PiercingSkill = 80,
					},

					Tooltip = "Pursuit temporarily raises your runspeed by 20% ever second for 4 seconds. Hitting your target during pursuits effect causes a weapon damage bonus equal to speed bonus.",

					MobileEffect = "Pursuit",
					MobileEffectArgs = {
						Modifier = 0.20,
						PulseFrequency = TimeSpan.FromSeconds(1),
						PulseMax = 4
					},
					Cooldown = TimeSpan.FromSeconds(20)
				},
			}
		},
		]]
		StunStrike = {
			Action = {
				DisplayName = "Stun Strike",
				Icon = "Fatal Strike",				
				Enabled = true
			},

			RequireWeaponClass = "PoleArm",

			Levels = {
				{
					Prerequisites = {
				        LancingSkill = 20,
					},

					Tooltip = "Stun all enemies 5 yards in front of you for 2 seconds. Stuns players for 1 second.",

					MobileEffect = "StunStrike",
					MobileEffectArgs = {
						Radius = 5,
						Duration = TimeSpan.FromSeconds(2),
						PlayerDuration = TimeSpan.FromSeconds(1)
					},
					Cooldown = TimeSpan.FromSeconds(20)
				},
				{
					Prerequisites = {
				        LancingSkill = 50,
					},

					Tooltip = "Stun all enemies 5 yards in front of you for 3 seconds. Stuns players for 2 second.",

					MobileEffect = "StunStrike",
					MobileEffectArgs = {
						Radius = 5,
						Duration = TimeSpan.FromSeconds(3),
						PlayerDuration = TimeSpan.FromSeconds(2)
					},
					Cooldown = TimeSpan.FromSeconds(20)
				},
				{
					Prerequisites = {
				        LancingSkill = 80,
					},

					Tooltip = "Stun all enemies 4 yards in front of you for 5 seconds. Stuns players for 3 second.",

					MobileEffect = "StunStrike",
					MobileEffectArgs = {
						Radius = 5,
						Duration = TimeSpan.FromSeconds(5),
						PlayerDuration = TimeSpan.FromSeconds(3)
					},
					Cooldown = TimeSpan.FromSeconds(20)
				},
			}
		},
		Hamstring = {
			Action = {
				DisplayName = "Hamstring",
				Icon = "Fatal Strike",				
				Enabled = true
			},

			RequireCombatTarget = true,
			NoResetSwing = true,
			PreventRanged = true,

			Levels = {
				{
					Prerequisites = {
				        MeleeSkill = 20,
				        { SlashingSkill = 20, BashingSkill = 20, PiercingSkill = 20, }
					},

					Tooltip = "Reduces your targets runspeed by 50% for 2 seconds.",

					TargetMobileEffect = "Hamstring",
					TargetMobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(2),
						Modifier = -0.5
					},
					Cooldown = TimeSpan.FromSeconds(20),
				},
				{
					Prerequisites = {
				        MeleeSkill = 50,
				        { SlashingSkill = 50, BashingSkill = 50, PiercingSkill = 50, }
					},
					
					Tooltip = "Reduces your targets runspeed by 50% for 4 seconds.",

					TargetMobileEffect = "Hamstring",
					TargetMobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(4),
						Modifier = -0.5
					},
					Cooldown = TimeSpan.FromSeconds(20),
				},
				{
					Prerequisites = {
				        MeleeSkill = 80,
				        { SlashingSkill = 80, BashingSkill = 80, PiercingSkill = 80, }
					},
					
					Tooltip = "Reduces your targets runspeed by 50% for 6 seconds.",

					TargetMobileEffect = "Hamstring",
					TargetMobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(6),
						Modifier = -0.5
					},
					Cooldown = TimeSpan.FromSeconds(20),
				},
			}			
		},
		Cleave = {
			Action = {
				DisplayName = "Cleave",
				Icon = "Cleave",				
				Enabled = true
			},

			RequireWeaponClass = "PoleArm",
			
			Levels = {
				{
					Prerequisites = {
				        MeleeSkill = 20,
				        LancingSkill = 20
					},

					Tooltip = "Damage all targets within 2 yards in front of you.",

					MobileEffect = "Cleave",
					MobileEffectArgs = {
						Range = 2
					},
					Cooldown = TimeSpan.FromSeconds(6),
					CastTime = TimeSpan.FromSeconds(0.5),
				},
				{
					Prerequisites = {
				        MeleeSkill = 50,
				        LancingSkill = 50
					},
					
					Tooltip = "Damage all targets within 3 yards in front of you.",

					MobileEffect = "Cleave",
					MobileEffectArgs = {
						Range = 3
					},
					Cooldown = TimeSpan.FromSeconds(8),
					CastTime = TimeSpan.FromSeconds(0.5),
				},
				{
					Prerequisites = {
				        MeleeSkill = 80,
				        LancingSkill = 80
					},
					
					Tooltip = "Damage all targets within 5 yards in front of you.",

					MobileEffect = "Cleave",
					MobileEffectArgs = {
						Range = 5
					},
					Cooldown = TimeSpan.FromSeconds(8),
					CastTime = TimeSpan.FromSeconds(0.5),
				},
			}			
		},
	},
}