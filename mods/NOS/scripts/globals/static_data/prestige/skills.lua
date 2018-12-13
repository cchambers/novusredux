PrestigeData.Skills = {
	NoUnlock = true,

	Abilities = {
		Command = {
			Action = {
				DisplayName = "Command",
				Icon = "Summon Wolf",	
				Enabled = true
			},

			NoResetSwing = true,
			NoCombat = true,
			Instant = true,

			Tooltip = "Command creatures under your control. If the creature is selected first, the command will only be issued to that creature.",

			MobileEffect = "Command",
			--MobileEffectArgs = {},
			Cooldown = TimeSpan.FromSeconds(1)
		},
		Hide = {
			Action = {
				DisplayName = "Hide",
				Icon = "stealth",	
				Enabled = true
			},

			NoResetSwing = true,
			NoCombat = true,
			Instant = true,
			
			Tooltip = "Attempt to hide yourself in the shadows.",

			MobileEffect = "Hide",
			--MobileEffectArgs = {},
			Cooldown = TimeSpan.FromSeconds(1)
		},
		Focus = {
			Action = {
				DisplayName = "Focus",
				Icon = "Thunder Storm",
				Enabled = true
	    	},

			MobileEffect = "Focus",
		    Stamina = 0,
		    Instant = true,
		    NoTarget = true,
		    NoCombat = true,
		
			Tooltip = "Enter a trance and quickly regenerate mana.",

			MobileEffect = "Focus",
			--MobileEffectArgs = {},
			Cooldown = TimeSpan.FromSeconds(5)
		},

		Steal = {
			Action = {
				DisplayName = "Steal",
				Icon = "steal",	
				Enabled = true
			},

			NoResetSwing = true,
			NoCombat = true,
			Instant = true,

			Tooltip = "Attempt to take something that does not belong to you.",

			MobileEffect = "Steal",
			--MobileEffectArgs = {},
			Cooldown = TimeSpan.FromSeconds(10)
		},

	}
}