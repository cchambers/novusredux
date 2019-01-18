EquipmentStats = {
	BaseWeaponClass = {
		Fist = {
			Accuracy = 0,
			Critical = 0,
			Speed = 2.25,
			WeaponSkill = "BrawlingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee"
		},
		Dagger = {
			DisplayName = "Piercing Weapon",
			Accuracy = 0,
			Critical = 0,
			WeaponSkill = "PiercingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee"
		},
		Sword = {
			DisplayName = "Slashing Weapon",
			Accuracy = 0,
			Critical = 0,
			WeaponSkill = "SlashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee"
		},
		Sword2H = {
			DisplayName = "Slashing Weapon",
			Accuracy = 0,
			Critical = 0,
			WeaponSkill = "SlashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
			TwoHandedWeapon = true
		},
		Blunt = {
			DisplayName = "Bashing Weapon",
			Accuracy = 0,
			Critical = 0,
			WeaponSkill = "BashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee"
		},
		Blunt2H = {
			DisplayName = "Bashing Weapon",
			Accuracy = 0,
			Critical = 0,
			WeaponSkill = "BashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
			TwoHandedWeapon = true
		},
		PoleArm = {
			DisplayName = "Lancing Weapon",
			Accuracy = 0,
			Critical = 0,
			WeaponSkill = "LancingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
			TwoHandedWeapon = true
		},
		Bow = {
			DisplayName = "Ranged Weapon",
			Accuracy = 0,
			Critical = 0,
			WeaponSkill = "ArcherySkill",
			WeaponDamageType = "Bow",
			WeaponHitType = "Ranged",
			TwoHandedWeapon = true,
			Range = 14
		},
		Stave = {
			DisplayName = "Bashing Weapon",
			Accuracy = 0,
			Critical = 40,
			WeaponSkill = "BashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee",
			TwoHandedWeapon = true
		},
		Tool = {
			DisplayName = "Tool",
			Accuracy = 0,
			Critical = 0,
			WeaponSkill = "BashingSkill",
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee"
		},
		Magic = {
			DisplayName = "Magic Weapon",
			Accuracy = 0,
			Critical = 0,
			WeaponSkill = "MagerySkill",
			SecondaryWeaponSkill = "InscriptionSkill",
			WeaponSkillGainsDisabled = true,
			WeaponDamageType = "Bashing",
			WeaponHitType = "Melee"
		},
		NoCombat = {
			-- To prevent exceptions since NoCombat was added late
			Accuracy = 0,
			Critical = 0,
			WeaponHitType = "Melee"
		}
	},
	-- DAB COMBAT CHANGES IMPLEMENT MIN SKILL FOR WEAPONS
	BaseWeaponStats = {
		BareHand = {
			WeaponClass = "Fist",
			Attack = 1,
			MinSkill = 0,
			Speed = 2.25,
			Variance = 0.1,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "StunPunch"
		},
		-- Daggers
		Dagger = {
			WeaponClass = "Dagger",
			Attack = 15,
			Variance = 0.05,
			MinSkill = 0,
			Speed = 2.5,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "Bleed"
		},
		Kryss = {
			WeaponClass = "Dagger",
			Variance = 0.05,
			Attack = 10,
			Speed = 2,
			MinSkill = 0,
			PrimaryAbility = "Stab",
			SecondaryAbility = "MortalStrike"
		},
		Poniard = {
			WeaponClass = "Dagger",
			Variance = 0.05,
			Attack = 16,
			Speed = 2.75,
			MinSkill = 0,
			PrimaryAbility = "Stab",
			SecondaryAbility = "Bleed"
		},
		BoneDagger = {
			WeaponClass = "Dagger",
			Variance = 0.05,
			Attack = 12,
			Speed = 2.25,
			MinSkill = 0,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "MortalStrike"
		},
		-- Blunts
		Mace = {
			WeaponClass = "Blunt",
			Variance = 0.05,
			Attack = 15,
			MinSkill = 0,
			Speed = 2.75,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "MortalStrike"
		},
		Hammer = {
			WeaponClass = "Blunt",
			Variance = 0.05,
			Attack = 17,
			MinSkill = 0,
			Speed = 3,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "Stun"
		},
		Maul = {
			WeaponClass = "Blunt",
			Variance = 0.05,
			Attack = 18,
			MinSkill = 0,
			Speed = 3.25,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "Bleed"
		},
		WarMace = {
			WeaponClass = "Blunt",
			Variance = 0.05,
			Attack = 19,
			MinSkill = 0,
			Speed = 3.5,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "FollowThrough"
		},
		-- 2H Blunts
		Quarterstaff = {
			WeaponClass = "Blunt2H",
			Variance = 0.1,
			Attack = 21,
			MinSkill = 0,
			Speed = 3.75,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "Stun",
			TwoHandedWeapon = true
		},
		Warhammer = {
			WeaponClass = "Blunt2H",
			Variance = 0.1,
			Attack = 25,
			MinSkill = 0,
			Speed = 4,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "FollowThrough",
			TwoHandedWeapon = true
		},
		-- Polearms
		Warfork = {
			WeaponClass = "PoleArm",
			Variance = 0.1,
			Attack = 21,
			MinSkill = 0,
			Speed = 3.5,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "Bleed",
			TwoHandedWeapon = true
		},
		Voulge = {
			WeaponClass = "PoleArm",
			Variance = 0.1,
			Attack = 19,
			MinSkill = 0,
			Speed = 3.25,
			PrimaryAbility = "Cleave",
			SecondaryAbility = "Dismount",
			TwoHandedWeapon = true
		},
		Spear = {
			WeaponClass = "PoleArm",
			Variance = 0.1,
			Attack = 18,
			MinSkill = 0,
			Speed = 3,
			PrimaryAbility = "Stab",
			SecondaryAbility = "MortalStrike",
			TwoHandedWeapon = true
		},
		Halberd = {
			WeaponClass = "PoleArm",
			Variance = 0.1,
			Attack = 24,
			MinSkill = 0,
			Speed = 4,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "Concus",
			TwoHandedWeapon = true
		},
		Scythe = {
			WeaponClass = "PoleArm",
			Variance = 0.1,
			Attack = 24,
			MinSkill = 0,
			Speed = 4,
			PrimaryAbility = "Cleave",
			SecondaryAbility = "Bleed",
			TwoHandedWeapon = true
		},
		-- Bows
	
		Shortbow = {
			WeaponClass = "Bow",
			Variance = 0.05,
			Attack = 14,
			MinSkill = 0,
			Speed = 4,
			PrimaryAbility = "Power",
			SecondaryAbility = "DoubleShot",
			TwoHandedWeapon = true,
		},
		Longbow = {
			WeaponClass = "Bow",
			Variance = 0.05,
			Attack = 20,
			MinSkill = 65,
			Speed = 4.2,
			PrimaryAbility = "Power",
			SecondaryAbility = "Bleed",
			TwoHandedWeapon = true,
		},
		Warbow = {
			WeaponClass = "Bow",
			Variance = 0.1,
			Attack = 26,
			MinSkill = 90,
			Speed = 4.5,
			PrimaryAbility = "Power",
			SecondaryAbility = "MortalStrike",
			TwoHandedWeapon = true
		},
		SavageBow = {
			WeaponClass = "Bow",
			Variance = 0.1,
			Attack = 26,
			MinSkill = 90,
			Speed = 4.5,
			PrimaryAbility = "Power",
			SecondaryAbility = "DoubleShot",
			TwoHandedWeapon = true
		},
		BoneBow = {
			WeaponClass = "Bow",
			Variance = 0.1,
			Attack = 26,
			MinSkill = 90,
			Speed = 4.5,
			PrimaryAbility = "Power",
			SecondaryAbility = "DoubleShot",
			TwoHandedWeapon = true
		},
		-- 2H Staffs
		Staff = {
			WeaponClass = "Stave",
			Attack = 1,
			MinSkill = 0,
			Speed = 4,
			PrimaryAbility = "Focus",
			TwoHandedWeapon = true
		},
		-- 1H Swords
		Longsword = {
			WeaponClass = "Sword",
			Variance = 0.05,
			Attack = 15,
			MinSkill = 0,
			Speed = 2.75,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "Bleed"
		},
		Broadsword = {
			WeaponClass = "Sword",
			Variance = 0.05,
			Attack = 19,
			MinSkill = 0,
			Speed = 3.5,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "Concus"
		},
		Saber = {
			WeaponClass = "Sword",
			Variance = 0.05,
			Attack = 18,
			MinSkill = 0,
			Speed = 3.25,
			PrimaryAbility = "Stab",
			SecondaryAbility = "MortalStrike"
		},
		Katana = {
			WeaponClass = "Sword",
			Variance = 0.05,
			Attack = 14,
			MinSkill = 0,
			Speed = 2.5,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "Bleed"
		},
		-- 2H Swords
		LargeAxe = {
			WeaponClass = "Sword2H",
			Variance = 0.1,
			Attack = 20,
			MinSkill = 0,
			Speed = 3.5,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "Concus",
			TwoHandedWeapon = true
		},
		GreatAxe = {
			WeaponClass = "Sword2H",
			Variance = 0.1,
			Attack = 25,
			MinSkill = 0,
			Speed = 4,
			PrimaryAbility = "Overpower",
			SecondaryAbility = "MortalStrike",
			TwoHandedWeapon = true
		},
		-- Tools
		Hatchet = {
			WeaponClass = "Tool",
			Attack = 3,
			MinSkill = 0,
			PrimaryAbility = "Lumberjack",
			TwoHandedWeapon = true,
			Speed = 3
		},
		MiningPick = {
			WeaponClass = "Tool",
			Attack = 3,
			MinSkill = 0,
			PrimaryAbility = "Mine",
			TwoHandedWeapon = true,
			Speed = 3
		},
		FishingRod = {
			WeaponClass = "Tool",
			Attack = 3,
			MinSkill = 0,
			PrimaryAbility = "Fish",
			TwoHandedWeapon = true,
			Speed = 3
		},
		HuntingKnife = {
			WeaponClass = "Tool",
			Attack = 3,
			MinSkill = 0,
			PrimaryAbility = "HuntingKnife",
			Speed = 3
		},
		Crook = {
			WeaponClass = "Tool",
			Attack = 3,
			MinSkill = 0,
			PrimaryAbility = "Tame",
			Speed = 3
		},
		CrookAsh = {
			WeaponClass = "Tool",
			Attack = 3,
			MinSkill = 0,
			PrimaryAbility = "Tame",
			SecondaryAbility = "CrookCalm",
			Speed = 3
		},
		CrookBlight = {
			WeaponClass = "Tool",
			Attack = 3,
			MinSkill = 0,
			PrimaryAbility = "CrookProvoke",
			SecondaryAbility = "CrookCalm",
			Speed = 3
		},
		Shovel = {
			WeaponClass = "Tool",
			Attack = 3,
			MinSkill = 0,
			PrimaryAbility = "Dig",
			Speed = 3
		},
		-- mage weapons
		MagicStaff = {
			WeaponClass = "Magic",
			Attack = 1,
			MinSkill = 0,
			Speed = 3.75,
			TwoHandedWeapon = true
		},
		Spellbook = {
			WeaponClass = "Magic",
			Attack = 1,
			Speed = 3,
			MinSkill = 0
		},
		-- no combat
		Torch = {
			WeaponClass = "NoCombat",
			NoCombat = true,
			Attack = 0, -- to prevent exceptions (should not check these if weaponclass is NoCombat)
			MinSkill = 0, -- to prevent exceptions
			Speed = 0 -- to prevent exceptions
		}
	},
	BaseArmorClass = {
		Cloth = {
			Head = {
				StaRegenModifier = 0,
				ManaRegenModifier = 1
			},
			Chest = {
				StaRegenModifier = 0,
				ManaRegenModifier = 1
			},
			Legs = {
				StaRegenModifier = 0,
				ManaRegenModifier = 1
			}
		},
		
		Light = {
			Head = {
				AgiBonus = -1,
				StaRegenModifier = 0,
				ManaRegenModifier = 0.5
			},
			Chest = {
				AgiBonus = -2,
				StaRegenModifier = 0,
				ManaRegenModifier = 0.5
			},
			Legs = {
				AgiBonus = -2,
				StaRegenModifier = 0,
				ManaRegenModifier = 0.5
			}
		},

		Heavy = {
			Head = {
				AgiBonus = -3,
				StaRegenModifier = 0,
				ManaRegenModifier = -0.50
			},
			Chest = {
				AgiBonus = -6,
				StaRegenModifier = 0,
				ManaRegenModifier = -0.25
			},
			Legs = {
				AgiBonus = -6,
				StaRegenModifier = 0,
				ManaRegenModifier = -0.25
			}
		}
	},
	BaseArmorStats = {
		Natural = {
			--naked
			ArmorClass = "Cloth",
			Head = {
				ArmorRating = 12
			},
			Chest = {
				ArmorRating = 16
			},
			Legs = {
				ArmorRating = 17
			}
		},
		Padded = {
			ArmorClass = "Cloth",
			SoundType = "Leather",
			Head = {
				ArmorRating = 15
			},
			Chest = {
				ArmorRating = 20
			},
			Legs = {
				ArmorRating = 20
			}
		},
		Linen = {
			ArmorClass = "Cloth",
			SoundType = "Leather",
			Head = {
				ArmorRating = 18
			},
			Chest = {
				ArmorRating = 23
			},
			Legs = {
				ArmorRating = 23
			}
		},
		MageRobe = {
			ArmorClass = "Cloth",
			SoundType = "Leather",
			Head = {
				ArmorRating = 0
			},
			Chest = {
				ArmorRating = 26
			},
			Legs = {
				ArmorRating = 0
			}
		},
		Leather = {
			ArmorClass = "Light",
			SoundType = "Leather",
			Head = {
				ArmorRating = 22
			},
			Chest = {
				ArmorRating = 27
			},
			Legs = {
				ArmorRating = 27
			}
		},
		Bone = {
			ArmorClass = "Light",
			SoundType = "Leather",
			Head = {
				ArmorRating = 26
			},
			Chest = {
				ArmorRating = 30
			},
			Legs = {
				ArmorRating = 30
			}
		},
		Hardened = {
			ArmorClass = "Light",
			SoundType = "Leather",
			Head = {
				ArmorRating = 26
			},
			Chest = {
				ArmorRating = 35
			},
			Legs = {
				ArmorRating = 35
			}
		},
		Assassin = {
			ArmorClass = "Light",
			SoundType = "Leather",
			Head = {
				ArmorRating = 21
			},
			Chest = {
				ArmorRating = 30
			},
			Legs = {
				ArmorRating = 30
			}
		},
		Chain = {
			ArmorClass = "Light",
			SoundType = "Plate",
			Head = {
				ArmorRating = 30
			},
			Chest = {
				ArmorRating = 55
			},
			Legs = {
				ArmorRating = 55
			}
		},
		Brigandine = {
			ArmorClass = "Heavy",
			SoundType = "Plate",
			Head = {
				ArmorRating = 50
			},
			Chest = {
				ArmorRating = 60
			},
			Legs = {
				ArmorRating = 60
			}
		},
		Scale = {
			ArmorClass = "Heavy",
			SoundType = "Plate",
			Head = {
				ArmorRating = 40
			},
			Chest = {
				ArmorRating = 55
			},
			Legs = {
				ArmorRating = 55
			}
		},
		Plate = {
			ArmorClass = "Heavy",
			SoundType = "Plate",
			Head = {
				ArmorRating = 50
			},
			Chest = {
				ArmorRating = 60
			},
			Legs = {
				ArmorRating = 60
			}
		},
		FullPlate = {
			ArmorClass = "Heavy",
			SoundType = "Plate",
			Head = {
				ArmorRating = 50
			},
			Chest = {
				ArmorRating = 60
			},
			Legs = {
				ArmorRating = 60
			}
		}
	},
	BaseShieldStats = {
		Buckler = {
			BaseBlockChance = 0,
			ArmorRating = 35,
			MinSkill = 0
		},
		SmallShield = {
			BaseBlockChance = 0,
			ArmorRating = 35,
			MinSkill = 0
		},
		BoneShield = {
			BaseBlockChance = 0,
			ArmorRating = 35,
			MinSkill = 0
		},
		CurvedShield = {
			BaseBlockChance = 0,
			ArmorRating = 35,
			MinSkill = 0
		},
		MarauderShield = {
			BaseBlockChance = 0,
			ArmorRating = 35,
			MinSkill = 0
		},
		LargeShield = {
			BaseBlockChance = 0,
			ArmorRating = 35,
			MinSkill = 0
		},
		DwarvenShield = {
			BaseBlockChance = 0,
			ArmorRating = 35,
			MinSkill = 0
		},
		HeaterShield = {
			BaseBlockChance = 0,
			ArmorRating = 35,
			MinSkill = 0
		},
		Fortress = {
			BaseBlockChance = 0,
			ArmorRating = 35,
			MinSkill = 0
		},
		DragonGuard = {
			BaseBlockChance = 0,
			ArmorRating = 35,
			MinSkill = 0
		},
		Temper = {
			BaseBlockChance = 0,
			ArmorRating = 35,
			MinSkill = 0
		},
		Guardian = {
			BaseBlockChance = 0,
			ArmorRating = 35,
			MinSkill = 0
		},
		KiteShield = {
			BaseBlockChance = 0,
			ArmorRating = 35,
			MinSkill = 0
		}
	}
}

ArrowTypes = {
	"Arrows",
	"FeatheredArrows",
	"AshArrows",
	"BlightwoodArrows"
}

ArrowTypeData = {
	Arrows = {
		DamageBonus = 0,
		Name = "Arrows"
	},
	FeatheredArrows = {
		DamageBonus = 1,
		Name = "Feathered Arrows"
	},
	AshArrows = {
		DamageBonus = 3,
		Name = "Ash Arrows"
	},
	BlightwoodArrows = {
		DamageBonus = 5,
		Name = "Blightwood Arrows"
	}
}

JewelryTypes = {
	"RubyFlawed",
	"RubyImperfect",
	"RubyPerfect",
	"SapphireFlawed",
	"SapphireImperfect",
	"SapphirePerfect",
	"TopazFlawed",
	"TopazImperfect",
	"TopazPerfect"
}

JewelryTypeData = {
	RubyFlawed = {
		Con = 1
	},
	RubyImperfect = {
		Con = 3
	},
	RubyPerfect = {
		Con = 5
	},
	SapphireFlawed = {
		Wis = 1
	},
	SapphireImperfect = {
		Wis = 3
	},
	SapphirePerfect = {
		Wis = 5
	},
	TopazFlawed = {
		Will = 1
	},
	TopazImperfect = {
		Will = 3
	},
	TopazPerfect = {
		Will = 5
	}
}

EquipmentStats.BaseWeaponStats.Telecrook = {
    WeaponClass = "Tool",
    Attack = 7,
    MinSkill = 0,
    PrimaryAbility = "TelecrookMove",
    SecondaryAbility = "TelecrookRes",
}