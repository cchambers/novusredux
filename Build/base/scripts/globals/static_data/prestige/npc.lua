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
			Cooldown = TimeSpan.FromSeconds(1),
		},
		NPCStunShot = {
			Action = {
				DisplayName = "Stun Shot",
				Icon = "Windshot",				
				Enabled = true
			},

			RequireCombatTarget = true,
			-- functions to make the cast look better
			PreCast = PrestigePreCastBow,
			PostCast = PrestigePostCastBow,

			Tooltip = "Hardcore op guard stun shot.",

			MobileEffect = "StunShot",
			MobileEffectArgs = {
				Duration = TimeSpan.FromSeconds(5),
				PlayerDuration = TimeSpan.FromSeconds(5),
			},
			Cooldown = TimeSpan.FromSeconds(5),
			CastTime = TimeSpan.FromSeconds(0.5),
		},
	},
}