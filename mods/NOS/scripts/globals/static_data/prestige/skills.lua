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
		Reveal = {
			Action = {
				DisplayName = "Reveal",
				Icon = "track",	
				Enabled = true
			},

			NoResetSwing = true,
			NoCombat = true,
			Instant = true,
			
			Tooltip = "Attempt to reveal hidden things.",

			MobileEffect = "Reveal",
			--MobileEffectArgs = {},
			Cooldown = TimeSpan.FromSeconds(30)
		},
		
		Identify = {
			Action = {
				DisplayName = "Identify",
				Icon = "god button",	
				Enabled = true
			},

			NoResetSwing = true,
			NoCombat = true,
			Instant = true,
			QueueTarget = "Obj",
			Tooltip = "Attempt to learn more about things.",

			MobileEffect = "Identify",
			Cooldown = TimeSpan.FromSeconds(3)
		},
		
		ApplyPoison = {
			Action = {
				DisplayName = "Apply Poison",
				Icon = "track",	
				Enabled = true
			},
			NoResetSwing = true,
			NoCombat = true,
			Instant = true,
			Tooltip = "Attempt to poison an item of food or edged weapon.",
			MobileEffect = "ApplyPoison",
			--MobileEffectArgs = {},
			Cooldown = TimeSpan.FromSeconds(30)
		},
		SpeakWithDead = {
			Action = {
				DisplayName = "Seance",
				Icon = "Phantom",	
				Enabled = true
			},

			NoResetSwing = true,
			NoCombat = true,
			Instant = true,
			
			Tooltip = "Attempt to speak with the dead.",

			MobileEffect = "SpiritSpeak",
			Cooldown = TimeSpan.FromSeconds(60)
		},
		Focus = {
			Action = {
				DisplayName = "Focus",
				Icon = "Thunder Storm",
				Enabled = true
			},
		    Stamina = 0,
		    Instant = true,
		    NoTarget = true,
		    NoCombat = true,
		
			Tooltip = "Enter a trance and quickly regenerate mana.",

			MobileEffect = "Focus",
			--MobileEffectArgs = {},
			Cooldown = TimeSpan.FromSeconds(5)
		},

		Mentor = {
			Action = {
				DisplayName = "Mentor",
				Icon = "transference",
				Enabled = true
	    	},

		    Instant = true,
		    NoCombat = true,
		
			Tooltip = "Each one, teach one.",

			MobileEffect = "Mentor",
			--MobileEffectArgs = {},
			Cooldown = TimeSpan.FromSeconds(30)
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