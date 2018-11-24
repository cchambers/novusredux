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

			Range = 40,
			
			Tooltip = "Hardcore op guard charge.",

			MobileEffect = "Charge",
			MobileEffectArgs = {
				Duration = TimeSpan.FromSeconds(5),
				Instant = true
			},
			Cooldown = TimeSpan.FromSeconds(0.5),
		}
	},
}