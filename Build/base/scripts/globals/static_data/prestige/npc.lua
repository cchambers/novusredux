PrestigeData.NPC = {
	DisplayName = "NPC",
	Description = "AN NPC",
	NoUnlock = true,
	Abilities = {
		NPCCharge = {
			Action = {
				DisplayName = "Charge",
				Icon = "Berserker Rage",				
				Enabled = true,
			},

			RequireCombatTarget = true,
			--RequireHeavyArmor = true,

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
					Prerequisites = {},

                    Range = 40,
                    
				    Tooltip = "Hardcore op guard charge.",

					MobileEffect = "Charge",
					MobileEffectArgs = {
						Duration = TimeSpan.FromSeconds(5),
						Instant = true
					},
					Cooldown = TimeSpan.FromSeconds(0.5),
				},
			},
		}
	},
}