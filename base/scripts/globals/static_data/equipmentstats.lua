EquipmentStats = {
	BaseWeaponClass = {
		Fist = {
			Accuracy = 0,
			Critical = 0,
			Speed = 2.5,
			Variance = 0.05,
			WeaponSkill = "BashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
		},

		Tool = {
			Accuracy = 0,
			Critical = 0,
			Speed = 2.5,
			Variance = 0,
			WeaponSkill = "PiercingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
		},

		Dagger = {
			Accuracy = 0,
			Critical = 0,
			Variance = 0.05,
			WeaponSkill = "PiercingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
		},

		Sword = {
			Accuracy = 0,
			Critical = 0,
			Variance = 0.10,
			WeaponSkill = "SlashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
		},

		Sword2H = {
			Accuracy = 0,
			Critical = 0,
			Variance = 0.10,
			WeaponSkill = "SlashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
			TwoHandedWeapon = true,
		},

		Blunt = {
			Accuracy = 0,
			Critical = 0,
			Variance = 0.20,
			WeaponSkill = "BashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
		},

		Blunt2H = {
			Accuracy = 0,
			Critical = 0,
			Variance = 0.20,
			WeaponSkill = "BashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
			TwoHandedWeapon = true,
		},

		PoleArm = {
			Accuracy = 0,
			Critical = 0,
			Variance = 0.25,
			WeaponSkill = "LancingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
			TwoHandedWeapon = true,
		},

		Bow = {
			Accuracy = 0,
			Critical = 0,
			Variance = 0.05,
			WeaponSkill = "ArcherySkill",
			WeaponDamageType = "Bow",
			WeaponHitType = "Ranged",
			TwoHandedWeapon = true,
			Range = 14,
		},

		Stave = {
			Accuracy = 0,
			Critical = 40,
			Variance = 0.20,
			WeaponSkill = "BashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
			TwoHandedWeapon = true,
		},

		Offhand = {
			Accuracy = 0,
			Critical = 0,
			Variance = 0.20,
			WeaponSkill = "BashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
		},
		Tool = {
			Accuracy = 0,
			Critical = 0,
			Variance = 0.20,
			WeaponSkill = "BashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
		},
		NoCombat = {
			-- To prevent exceptions since NoCombat was added late
			Accuracy = 0,
			Critical = 0,
			Variance = 0,
			WeaponHitType = "Melee",
		}
	},

	-- DAB COMBAT CHANGES IMPLEMENT MIN SKILL FOR WEAPONS
	BaseWeaponStats = {
		BareHand = {
			WeaponClass = "Fist",
			Attack = 1,
			MinSkill = 0,
			Speed = 2.5,
		},
		-- Daggers
		Dagger = {
			WeaponClass = "Dagger",
			Attack = 18,
			MinSkill = 0,
			Speed = 2.5,
			PrimaryAbility = "Slash",
			SecondaryAbility = "Bleed",
		},
		Kryss = {
			WeaponClass = "Dagger",
			Attack = 13,
			Speed = 2,
			MinSkill = 0,
			PrimaryAbility = "Stab",
			SecondaryAbility = "MortalStrike",
		},
		Poniard = {
			WeaponClass = "Dagger",
			Attack = 21,
			Speed = 2.75,
			MinSkill = 0,
			PrimaryAbility = "Stab",
			SecondaryAbility = "Bleed",
		},
		BoneDagger = {
			WeaponClass = "Dagger",
			Attack = 16,
			Speed = 2.25,
			MinSkill = 0,
			PrimaryAbility = "Slash",
			SecondaryAbility = "MortalStrike",
		},
		-- Blunts
		Mace = {
			WeaponClass = "Blunt",
			Attack = 15,
			MinSkill = 0,
			Speed = 2.75,
			PrimaryAbility = "Bash",
			SecondaryAbility = "MortalStrike",
		},
		Hammer = {
			WeaponClass = "Blunt",
			Attack = 17,
			MinSkill = 0,
			Speed = 3,
			PrimaryAbility = "Bash",
			SecondaryAbility = "Stun",
		},
		Maul = {
			WeaponClass = "Blunt",
			Attack = 19,
			MinSkill = 0,
			Speed = 3.25,
			PrimaryAbility = "Bash",
			SecondaryAbility = "Bleed",
		},
		WarMace = {
			WeaponClass = "Blunt",
			Attack = 21,
			MinSkill = 0,
			Speed = 3.5,
			PrimaryAbility = "Bash",
			SecondaryAbility = "FollowThrough",
		},
		-- 2H Blunts
		Quarterstaff = {
			WeaponClass = "Blunt2H",
			Attack = 27,
			MinSkill = 0,
			Speed = 3.75,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "Stun",
			TwoHandedWeapon = true,
		},
		Warhammer = {
			WeaponClass = "Blunt2H",
			Attack = 29,
			MinSkill = 0,
			Speed = 4,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "FollowThrough",
			TwoHandedWeapon = true,
		},
		-- Polearms
		Warfork = {
			WeaponClass = "PoleArm",
			Attack = 28,
			MinSkill = 0,
			Speed = 3.5,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "Bleed",
			TwoHandedWeapon = true,
		},
		Vouge = {
			WeaponClass = "PoleArm",
			Attack = 26,
			MinSkill = 0,
			Speed = 3.25,
			PrimaryAbility = "Cleave",
			SecondaryAbility = "Dismount",
			TwoHandedWeapon = true,
		},
		Spear = {
			WeaponClass = "PoleArm",
			Attack = 23,
			MinSkill = 0,
			Speed = 3,
			PrimaryAbility = "Stab",
			SecondaryAbility = "MortalStrike",
			TwoHandedWeapon = true,
		},
		Halberd = {
			WeaponClass = "PoleArm",
			Attack = 33,
			MinSkill = 0,
			Speed = 4,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "Concus",
			TwoHandedWeapon = true,
		},
		Scythe = {
			WeaponClass = "PoleArm",
			Attack = 33,
			MinSkill = 0,
			Speed = 4,
			PrimaryAbility = "Cleave",
			SecondaryAbility = "Bleed",
			TwoHandedWeapon = true,
		},
		-- Bows
		Shortbow = {
			WeaponClass = "Bow",
			Attack = 19,
			MinSkill = 0,
			Speed = 3,
			PrimaryAbility = "Power",
			SecondaryAbility = "DoubleShot",
			TwoHandedWeapon = true,
		},
		Longbow = {
			WeaponClass = "Bow",
			Attack = 27,
			MinSkill = 0,
			Speed = 4,
			PrimaryAbility = "Power",
			SecondaryAbility = "Bleed",
			TwoHandedWeapon = true,
		},
		Warbow = {
			WeaponClass = "Bow",
			Attack = 31,
			MinSkill = 0,
			Speed = 4.5,
			PrimaryAbility = "Power",
			SecondaryAbility = "MortalStrike",
			TwoHandedWeapon = true,
		},
		SavageBow = {
			WeaponClass = "Bow",
			Attack = 31,
			MinSkill = 0,
			Speed = 4.5,
			PrimaryAbility = "Power",
			SecondaryAbility = "DoubleShot",
			TwoHandedWeapon = true,
		},
		BoneBow = {
			WeaponClass = "Bow",
			Attack = 31,
			MinSkill = 0,
			Speed = 4.5,
			PrimaryAbility = "Power",
			SecondaryAbility = "DoubleShot",
			TwoHandedWeapon = true,
		},
		-- 2H Staffs
		Staff = {
			WeaponClass = "Stave",
			Attack = 1,
			MinSkill = 0,
			Speed = 4,
			PrimaryAbility = "Focus",
			TwoHandedWeapon = true,
		},

		-- Offhands
		Spellbook = {
			WeaponClass = "Offhand",
			Attack = 1,
			Speed = 3,
			MinSkill = 0,
		},
		-- 1H Swords
		Longsword = {
			WeaponClass = "Sword",
			Attack = 17,
			MinSkill = 0,
			Speed = 2.75,
			PrimaryAbility = "Slash",
			SecondaryAbility = "Bleed",
		},
		Broadsword = {
			WeaponClass = "Sword",
			Attack = 23,
			MinSkill = 0,
			Speed = 3.5,
			PrimaryAbility = "Slash",
			SecondaryAbility = "Concus",
		},
		Saber = {
			WeaponClass = "Sword",
			Attack = 21,
			MinSkill = 0,
			Speed = 3.25,
			PrimaryAbility = "Stab",
			SecondaryAbility = "MortalStrike",
		},
		Katana = {
			WeaponClass = "Sword",
			Attack = 15,
			MinSkill = 0,
			Speed = 2.5,
			PrimaryAbility = "Slash",
			SecondaryAbility = "Bleed",
		},
		-- 2H Swords
		LargeAxe = {
			WeaponClass = "Sword2H",
			Attack = 32,
			MinSkill = 0,
			Speed = 3.5,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "Concus",
			TwoHandedWeapon = true,
		},
		GreatAxe = {
			WeaponClass = "Sword2H",
			Attack = 27,
			MinSkill = 0,
			Speed = 4,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "MortalStrike",
			TwoHandedWeapon = true,
		},
		-- Tools
		Hatchet = {
			WeaponClass = "Tool",
			Attack = 3,
			MinSkill = 0,
			PrimaryAbility = "Lumberjack",
			TwoHandedWeapon = true,
			Speed = 3,
		},
		MiningPick = {
			WeaponClass = "Tool",
			Attack = 3,
			MinSkill = 0,
			PrimaryAbility = "Mine",
			TwoHandedWeapon = true,
			Speed = 3,
		},
		FishingRod = {
			WeaponClass = "Tool",
			Attack = 3,
			MinSkill = 0,
			PrimaryAbility = "Fish",
			TwoHandedWeapon = true,
			Speed = 3,
		},
		HuntingKnife = {
			WeaponClass = "Tool",
			Attack = 3,
			MinSkill = 0,
			PrimaryAbility = "HuntingKnife",
			Speed = 3,
		},
		Crook = {
			WeaponClass = "Tool",
			Attack = 3,
			MinSkill = 0,
			PrimaryAbility = "Tame",
			Speed = 3,
		},
		-- no combat
		Torch = {
			WeaponClass = "NoCombat",
			NoCombat = true,
			Attack = 0, -- to prevent exceptions (should not check these if weaponclass is NoCombat)
			MinSkill = 0, -- to prevent exceptions
			Speed = 0, -- to prevent exceptions
		},
	},

	BaseArmorClass = {
		Cloth = {
			Head = {
				StaRegenModifier = 0,
				ManaRegenModifier = 1,
			},
			Chest = {
				StaRegenModifier = 0,
				ManaRegenModifier = 1,
			},
			Legs = {
				StaRegenModifier = 0,
				ManaRegenModifier = 1,
			},
		},

		Light = {
			Head = {
				StaRegenModifier = 0,
				ManaRegenModifier = 0.5,
			},
			Chest = {
				StaRegenModifier = 0,
				ManaRegenModifier = 0.5,
			},
			Legs = {
				StaRegenModifier = 0,
				ManaRegenModifier = 0.5,
			},
		},

		Heavy = {
			Head = {
				AgiBonus = -3,
				StaRegenModifier = 0,
				ManaRegenModifier = 0.1,
			},
			Chest = {
				AgiBonus = -3,
				StaRegenModifier = 0,
				ManaRegenModifier = 0.1,
			},
			Legs = {
				AgiBonus = -3,
				StaRegenModifier = 0,
				ManaRegenModifier = 0.1,
			},
		},
	},

	BaseArmorStats = {
		Natural = { --naked
			ArmorClass = "Cloth",
			Head = {
				ArmorRating = 13
			},
			Chest = {
				ArmorRating = 17
			},
			Legs = {
				ArmorRating = 10
			}
		},

		Padded = {
			ArmorClass = "Cloth",
			SoundType = "Leather",
			Head = {
				ArmorRating = 20,
			},
			Chest = {
				ArmorRating = 20,
			},
			Legs = {
				ArmorRating = 15,
			}
		},
		Linen = {
			ArmorClass = "Cloth",
			SoundType = "Leather",
			Head = {
				ArmorRating = 20,
			},
			Chest = {
				ArmorRating = 20,
			},
			Legs = {
				ArmorRating = 15,
			}
		},
		MageRobe = {
			ArmorClass = "Cloth",
			SoundType = "Leather",
			Head = {
				ArmorRating = 20,
			},
			Chest = {
				ArmorRating = 20,
			},
			Legs = {
				ArmorRating = 15,
			}
		},

		Leather = {
			ArmorClass = "Light",
			SoundType = "Leather",
			Head = {
				ArmorRating = 22
			},
			Chest = {
				ArmorRating = 22
			},
			Legs = {
				ArmorRating = 18
			}
		},

		Bone = {
			ArmorClass = "Light",
			SoundType = "Leather",
			Head = {
				ArmorRating = 22
			},
			Chest = {
				ArmorRating = 22
			},
			Legs = {
				ArmorRating = 18
			}
		},

		Hardened = {
			ArmorClass = "Light",
			SoundType = "Leather",
			Head = {
				ArmorRating = 22
			},
			Chest = {
				ArmorRating = 22
			},
			Legs = {
				ArmorRating = 18
			}
		},

		Assassin = {
			ArmorClass = "Light",
			SoundType = "Leather",
			Head = {
				ArmorRating = 22
			},
			Chest = {
				ArmorRating = 22
			},
			Legs = {
				ArmorRating = 18
			}
		},

		Brigandine = {
			ArmorClass = "Heavy",
			SoundType = "Plate",
			Head = {
				ArmorRating = 25
			},
			Chest = {
				ArmorRating = 25
			},
			Legs = {
				ArmorRating = 20
			}
		},

		Chain = {
			ArmorClass = "Heavy",
			SoundType = "Plate",
			Head = {
				ArmorRating = 25
			},
			Chest = {
				ArmorRating = 25
			},
			Legs = {
				ArmorRating = 20
			}
		},

		Scale = {
			ArmorClass = "Heavy",
			SoundType = "Plate",
			Head = {
				ArmorRating = 25
			},
			Chest = {
				ArmorRating = 25
			},
			Legs = {
				ArmorRating = 20
			}
		},
		Plate = {
			ArmorClass = "Heavy",
			SoundType = "Plate",
			Head = {
				ArmorRating = 25
			},
			Chest = {
				ArmorRating = 25
			},
			Legs = {
				ArmorRating = 20
			}
		},
		FullPlate = {
			ArmorClass = "Heavy",
			SoundType = "Plate",
			Head = {
				ArmorRating = 25
			},
			Chest = {
				ArmorRating = 25
			},
			Legs = {
				ArmorRating = 20
			}
		},
	},

	BaseShieldStats = {
		Buckler = {
			BaseBlockChance = 20,
			ArmorRating = 70,
			MinSkill = 0,
		},

		SmallShield = {
			BaseBlockChance = 20,
			ArmorRating = 70,
			MinSkill = 0,
		},

		BoneShield = {
			BaseBlockChance = 20,
			ArmorRating = 70,
			MinSkill = 0,
		},
		CurvedShield = {
			BaseBlockChance = 20,
			ArmorRating = 70,
			MinSkill = 0,
		},
		MarauderShield = {
			BaseBlockChance = 20,
			ArmorRating = 70,
			MinSkill = 0,
		},
		LargeShield = {
			BaseBlockChance = 20,
			ArmorRating = 70,
			MinSkill = 0,
		},
		DwarvenShield = {
			BaseBlockChance = 20,
			ArmorRating = 70,
			MinSkill = 0,
		},
		HeaterShield = {
			BaseBlockChance = 20,
			ArmorRating = 70,
			MinSkill = 0,
		},
		Fortress = {
			BaseBlockChance = 20,
			ArmorRating = 70,
			MinSkill = 0,
		},
		DragonGuard = {
			BaseBlockChance = 20,
			ArmorRating = 70,
			MinSkill = 0,
		},
		Temper = {
			BaseBlockChance = 20,
			ArmorRating = 70,
			MinSkill = 0,
		},
		Guardian = {
			BaseBlockChance = 20,
			ArmorRating = 70,
			MinSkill = 0,
		},
		Kite = {
			BaseBlockChance = 20,
			ArmorRating = 70,
			MinSkill = 0,
		},
	}
}