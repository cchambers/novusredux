--[[PrestigeData.Crafter = {
	DisplayName = "Crafter",
	Description = "A Crafter.",
	
	Abilities = {
		Scavenge = {
			Action = {
				DisplayName = "Scavenge",
				Icon = "Berserker Rage",
				Enabled = true
			},

			RequireCombatTarget = true,
			Range = 20,

			Levels = {
				{
					Prerequisites = {
						MiningSkill = 20,
					},

					Tooltip = "Mark your target to be scavenged when they die.",

					TargetMobileEffect = "Scavengable",
					TargetMobileEffectArgs = {
						Duration = TimeSpan.FromMinutes(5)
					},
					Cooldown = TimeSpan.FromSeconds(10)
				},
				{
					Prerequisites = {
						MiningSkill = 20,
					},

					Tooltip = "Mark your target to be scavenged when they die.",

					TargetMobileEffect = "Scavengable",
					TargetMobileEffectArgs = {
						Duration = TimeSpan.FromMinutes(5)
					},
					Cooldown = TimeSpan.FromSeconds(10)
				},
				{
					Prerequisites = {
						MiningSkill = 20,
					},

					Tooltip = "Mark your target to be scavenged when they die.",

					TargetMobileEffect = "Scavengable",
					TargetMobileEffectArgs = {
						Duration = TimeSpan.FromMinutes(5)
					},
					Cooldown = TimeSpan.FromSeconds(10)
				},
			}
		},
	},
}]]