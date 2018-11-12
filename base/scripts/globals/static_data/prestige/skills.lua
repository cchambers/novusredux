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

			Levels = {
				{					
					Tooltip = "Used to command creatures under your control. If the creature is selected first, the command will only be issued to that creature.",

					MobileEffect = "Command",
					MobileEffectArgs = {						
					},
					Cooldown = TimeSpan.FromSeconds(1)
				},
			}
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

			Levels = {
				{					
					Tooltip = "Used to attempt to hide yourself in the shadows.",

					MobileEffect = "Hide",
					MobileEffectArgs = {						
					},
					Cooldown = TimeSpan.FromSeconds(1)
				},
			}
		},
		Focus = {
			Action = 
			{
	        DisplayName = "Focus",
	        Icon = "Thunder Storm",
	        Enabled = true
	    	},

			MobileEffect = "Focus",
		    Stamina = 0,
		    Instant = true,
		    NoTarget = true,
		    NoCombat = true,

			Levels = {
				{					
					Tooltip = "Enter a trance and quickly regenerate mana.",

					MobileEffect = "Focus",
					MobileEffectArgs = {						
					},
					Cooldown = TimeSpan.FromSeconds(5)
				},
			}
		}

	}
}