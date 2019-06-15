PetCommands = {
	attack = {
		target = true,
		Action = {
			DisplayName = "All Attack",
			--Icon = "",
			Tooltip = "Command all of your active pets to attack the target of your choice.",
			Icon = "pet_attack_target"
		},
	},
	kill = {}, --alias
	autoattack = {}, --used by targeting system
	aggressive = {}, -- sets all/petByName to aggressive stance
	passive = {}, -- sets all/petByName to passive stance
	stay = {
		target = false,
		Action = {
			DisplayName = "All Stay",
			--Icon = "",
			Tooltip = "Command all of your active pets to stop moving and remain where they are.",
			Icon = "stay"
		}
	},
	stop = {
		target = false,
		Action = {
			DisplayName = "All Stop",
			--Icon = "",
			Tooltip = "Command all of your active pets to stop moving and cease all actions.",
			Icon = "heel"
		}
	},
	follow = {
		target = true,
		Action = {
			DisplayName = "All Follow",
			--Icon = "",
			Tooltip = "Command all of your active pets to follow the target of your choice.",
			Icon = "pet_follow"
		}
	},
	go = {
		target = true,
		Action = {
			DisplayName = "All Goto",
			--Icon = "",
			Tooltip = "Have all pets go to targeted location.",
			Icon = "pet_follow"
		}
	},
	release = {
		target = true,
		Action = {
			DisplayName = "All Release",
			--Icon = "",
			Tooltip = "Release a targeted pet.",
			Icon = "release"
		}
	},
	guard = {
		target = true,
		Action = {
			DisplayName = "All Guard",
			Tooltip = "Have a pet guard a target.",
			Icon = "pet_follow"
		},
	},
}