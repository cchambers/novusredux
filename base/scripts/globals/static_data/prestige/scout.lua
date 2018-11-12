PrestigeData.Scout = {
	DisplayName = "Scout",
	Description = "The Scout uses ranged weapons to damage their foes from afar.",
	
	Abilities = {
		--[[
		Snipe = {
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
			Action = {
				DisplayName = "Hunters Mark",
				Icon = "Burning Arrow",				
				Enabled = true
			},

			RequireRanged = true,
			RequireCombatTarget = true,
			NoResetSwing = true,

			Levels = {
				{
					Prerequisites = {
						ArcherySkill = 20,
					},

					Tooltip = "Mark your target, preventing them from hiding/cloaking and increases all bow damage received by 3.33% for 30 seconds.",

					TargetMobileEffect = "HuntersMark",
					TargetMobileEffectArgs = {
						Modifier = 0.033,
					},
					Cooldown = TimeSpan.FromMinutes(2),
				},
				{
					Prerequisites = {
						ArcherySkill = 50,
					},

					Tooltip = "Mark your target, preventing them from hiding/cloaking and increases all bow damage received by 6.66% for 30 seconds.",

					TargetMobileEffect = "HuntersMark",
					TargetMobileEffectArgs = {
						Modifier = 0.066,
					},
					Cooldown = TimeSpan.FromMinutes(2),
				},
				{
					Prerequisites = {
						ArcherySkill = 70,
					},

					Tooltip = "Mark your target, preventing them from hiding/cloaking and increases all bow damage received by 9.99% for 30 seconds.",

					TargetMobileEffect = "HuntersMark",
					TargetMobileEffectArgs = {
						Modifier = 0.099,
					},
					Cooldown = TimeSpan.FromMinutes(2),
				},
			}
		},
		StunShot = {
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

			Levels = {
				{
					Prerequisites = {
						ArcherySkill = 20,
					},

					Tooltip = "Stun your target for 3 seconds, 1 second for players.",

					MobileEffect = "StunShot",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(3),
						PlayerDuration = TimeSpan.FromSeconds(1),
					},
					Cooldown = TimeSpan.FromSeconds(20),
					CastTime = TimeSpan.FromSeconds(2),
				},
				{
					Prerequisites = {
						ArcherySkill = 50,
					},

					Tooltip = "Stun your target for 4 seconds, 2 seconds for players.",

					MobileEffect = "StunShot",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(4),
						PlayerDuration = TimeSpan.FromSeconds(2),
					},
					Cooldown = TimeSpan.FromSeconds(20),
					CastTime = TimeSpan.FromSeconds(2),
				},
				{
					Prerequisites = {
						ArcherySkill = 70,
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
			}
		},
		Wound = {
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

			Levels = {
				{
					Prerequisites = {
						ArcherySkill = 20,
					},

					Tooltip = "Wound your target, slowing them by 40% for 3 seconds. 0.5 second cast time.",

					TargetMobileEffect = "Hamstring",
					TargetMobileEffectArgs = {
						Modifier = -0.4,
						Duration = TimeSpan.FromSeconds(3),
					},

					Cooldown = TimeSpan.FromSeconds(15),
					CastTime = TimeSpan.FromSeconds(0.5),
				},
				{
					Prerequisites = {
						ArcherySkill = 50,
					},

					Tooltip = "Wound your target, slowing them by 50% for 3 seconds. 0.5 second cast time.",

					TargetMobileEffect = "Hamstring",
					TargetMobileEffectArgs = {
						Modifier = -0.5,
						Duration = TimeSpan.FromSeconds(3),
					},

					Cooldown = TimeSpan.FromSeconds(15),
					CastTime = TimeSpan.FromSeconds(0.5),
				},
				{
					Prerequisites = {
						ArcherySkill = 80,
					},

					Tooltip = "Wound your target, slowing them by 70% for 3 seconds. 0.5 second cast time.",

					TargetMobileEffect = "Hamstring",
					TargetMobileEffectArgs = {
						Modifier = -0.7,
						Duration = TimeSpan.FromSeconds(3),
					},

					Cooldown = TimeSpan.FromSeconds(15),
					CastTime = TimeSpan.FromSeconds(0.5),
				},
			}
		},
	},
}