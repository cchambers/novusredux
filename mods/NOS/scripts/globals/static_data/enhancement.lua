


AllEnhancementData = {
--WEAPON ENHANCEMENTS
	Hone = {
		EnhancementDisplayName = "Hone",
		EnhancementType = "EnhancementModification",
		EnhancementBonuses = {
			BonusFinalDamage = {
				ValuePerInstance = 1,
				ValueCap = 5,
			},
		},
		--EnhancementHandlingScript = "en_hone",
		EnhancementItemClass = { 
			WeaponClass = true,
		},
		EnhancementItemSubClass = { 
			BladedEquipment = true,
		},
		EnhancementDisplayEffect = "[$2688]",
		EnhancementSlotRequiredPerInstance = 1,
		EnhancementMaxInstances = 3,
		SkillRequired = { 
			MetalsmithSkill = 40,
		},
		SkillGainPerInstance = {
			MetalsmithSkill = 5,
		},
		EnhancementSlot = { 
			WeaponHeadSlot = true,
		},
		ResourcesRequired = {
			--WormExtract = 4,
			IronIngots = 4,
		},
		AdditionalBonuses = {
			InstanceMin = {
				[2] = {
					Bonuses = {},
					Multipliers = {
						ModifiedDurabilityLoss = 1.05,
					},
					Scripts = {},
				},
			},

		},
	},

	SpellConduit = {
		EnhancementDisplayName = "Spell Conduit",
		EnhancementType = "EnhancementModification",
		EnhancementBonuses = {
			SpellConduit = {
				ValuePerInstance = 1,
				ValueCap = 1,
			},
		},
		--EnhancementHandlingScript = "en_hone",
		EnhancementItemClass = { 
			WeaponClass = true,
			ShieldClass = true,
		},
		EnhancementDisplayEffect = "[$2689]",
		EnhancementSlotRequiredPerInstance = 1,
		EnhancementMaxInstances = 1,
		SkillRequired = { 
			MetalsmithSkill = 60,
		},
		EnhancementSlot = { 
			WeaponHeadSlot = true,
		},
		ResourcesRequired = {
			--WormExtract = 4,
			IronIngotsGleaming = 6,
		},

	},

	Serration = {
		EnhancementDisplayName = "Serration",
		EnhancementType = "EnhancementModification",
		EnhancementBonuses = {
			BonusBleedDamage = {
				ValuePerInstance = 2,
				ValueCap = 2,
			},
		},
		--EnhancementHandlingScript = "en_hone",
		EnhancementItemClass = { 
			WeaponClass = true,
		},
		EnhancementItemSubClass = { 
			BladedEquipment = true,
		},
		EnhancementItemDamClass = {
			Slashing = true,
		},
		EnhancementDisplayEffect = "[$2690]",
		EnhancementSlotRequiredPerInstance = 1,
		EnhancementMaxInstances = 1,
		SkillRequired = { 
			MetalsmithSkill = 60,
		},
		EnhancementSlot = { 
			WeaponHeadSlot = true,
		},
		ResourcesRequired = {
			--WormExtract = 4,
			CobaltIngots = 4,
		},
		AdditionalBonuses = {
			InstanceMin = {
				[1] = {
					Multipliers = {
						ModifiedDurabilityLoss = 1.1,
					},
				},
			},

		},
	},
	Weight = {
		EnhancementDisplayName = "Weight",
		EnhancementType = "EnhancementModification",
		EnhancementBonuses = {
			BonusPenetration = {
				ValuePerInstance = 1,
				ValueCap = 2,
			},
		},
		--EnhancementHandlingScript = "en_hone",
		EnhancementItemClass = { 
			WeaponClass = true,
		},
	--[[EnhancementItemSubClass = { 
			BladedEquipment = true,
		},]]--
		EnhancementDisplayEffect = "[$2691]",
		EnhancementSlotRequiredPerInstance = 1,
		EnhancementMaxInstances = 3,
		SkillRequired = { 
			MetalsmithSkill = 30,
		},
		SkillGainPerInstance = {
			MetalsmithSkill = 10,
		},
		EnhancementSlot = { 
			WeaponHeadSlot = true,
		},
		ResourcesRequired = {
			--WormExtract = 4,
			IronIngotsGleaming = 3,
		},
		AdditionalBonuses = {
			InstanceMin = {
				[2] = {
					Bonuses = {},
					Multipliers = {
						BonusSpeedOffset = .1,
					},
					Scripts = {},
				},
			},

		},
	},
	--[[

	PoisonVein = {
		EnhancementDisplayName = "Poison Vein",
		EnhancementType = "EnhancementModification",
		EnhancemenScripts = {
			en_poison_vein = true,
		},
		EnhancementItemClass = { WeaponClass = true},
		EnhancementItemSubClass = { BladedEquipment = true},
		EnhancementDescription = "",
		EnhancementDisplayEffect = "[$2692]",
		EnhancementSlotRequiredPerInstance = 1,
		EnhancementMaxInstances = 2,
		SkillRequired = { 
			MetalsmithSkill = 20,
		},
		SkillGainPerInstance = {
			MetalsmithSkill = 10,
		},		
		EnhancementSlot = { WeaponHeadSlot = true},
		ResourcesRequired = {
			CorrosiveAcid = 4,
		},
		AdditionalBonuses = {
			InstanceMin = {
				[2] = {
						Bonuses = {
							BonusPoisonDamage = 1,
						},
				},
			},

		},
	},

]]--
--ARMOR ENHANCEMENTS

	Plating = {
		EnhancementDisplayName = "Armor Plates",
		EnhancementType = "EnhancementModification",
		EnhancementBonuses = {
			BonusAbsorption = 
			{
				ValuePerInstance = 2,
				ValueCap = 8,
			},
			BonusSlashingResistance =
			{
				ValuePerInstance = 1,
				ValueCap = 4,
			},
			BonusSwingSpeedModifier = 
			{
				ValuePerInstance = 2,
				ValueCap = 6,
			},
		},
		EnhancementItemClass = { ArmorClass = true},
		EnhancementDescription = "",
		EnhancementDisplayEffect =  "[$2693]",
		EnhancementSlotRequiredPerInstance = 2,
		EnhancementMaxInstances = 2,
		SkillRequired = { 
			MetalsmithSkill = 80,
		},
		SkillGainPerInstance = {
			MetalsmithSkill = 10,
		},
		EnhancementSlot = { ArmorBodySlot = true},
		ResourcesRequired = {
			CobaltIngotsCrystallized = 6,
		},
		AdditionalBonuses = {
			InstanceMin = {
				[2] = {
						Bonuses = {
							BonusEvasionModifier = -4,
							BonusManaBarrier = 6,
						},
				},
			},

		},
	},
	
	Reinforcement = {
		EnhancementDisplayName = "Reinforcement",
		EnhancementType = "EnhancementModification",
		EnhancementBonuses = {
			BonusAbsorption = 
			{
				ValuePerInstance = 2,
				ValueCap = 8,
			},
			BonusPiercingResist =
			{
				ValuePerInstance = 1,
				ValueCap = 4,
			},
			BonusSwingSpeedModifier = 
			{
				ValuePerInstance = 1,
				ValueCap = 6,
			},
		},
		EnhancementItemClass = { ArmorClass = true},
		EnhancementDescription = "",
		EnhancementDisplayEffect =  "[$2694]",
		EnhancementSlotRequiredPerInstance = 2,
		EnhancementMaxInstances = 2,
		SkillRequired = { 
			MetalsmithSkill = 70,
		},
		SkillGainPerInstance = {
			MetalsmithSkill = 10,
		},
		EnhancementSlot = { WeaponHeadSlot = true},
		ResourcesRequired = {
			IronIngotsGleaming = 8,
		},
		AdditionalBonuses = {
			InstanceMin = {
				[2] = {
						Bonuses = {
							BonusEvasionModifier = -3,
							BonusManaBarrier = 5,
						},
				},
			},

		},
	},
	Padding = {
		EnhancementDisplayName = "Padding",
		EnhancementType = "EnhancementModification",
		EnhancementBonuses = {
			BonusAbsorption = 
			{
				ValuePerInstance = 1,
				ValueCap = 8,
			},
			BonusBashingResist =
			{
				ValuePerInstance = 1,
				ValueCap = 4,
			},
		},
		EnhancementItemClass = { ArmorClass = true},
		EnhancementDescription = "",
		EnhancementDisplayEffect =  "[$2695]",
		EnhancementSlotRequiredPerInstance = 1,
		EnhancementMaxInstances = 2,
		SkillRequired = { 
			FabricationSkill = 60,
		},
		SkillGainPerInstance = {
			FabricationSkill = 10,
		},
		EnhancementSlot = { ArmorBodySlot = true},
		ResourcesRequired = {
			QuiltedFabric = 8,
		},
		AdditionalBonuses = {
			InstanceMin = {
				[2] = {
						Bonuses = {
							BonusEvasionModifier = -2,
							BonusManaBarrier = 1,
						},
				},
			},

		},
	},
	Banding = {
		EnhancementDisplayName = "Banding",
		EnhancementType = "EnhancementModification",
		EnhancementBonuses = {
			BonusAbsorption = 
			{
				ValuePerInstance = 3,
				ValueCap = 8,
			},
			BonusSwingSpeedModifier = 
			{
				ValuePerInstance = .5,
				ValueCap = 6,
			},

		},
		EnhancementItemClass = { ArmorClass = true},
		EnhancementDescription = "",
		EnhancementDisplayEffect =  "[$2696]",
		EnhancementSlotRequiredPerInstance = 2,
		EnhancementMaxInstances = 2,
		SkillRequired = { 
			FabricationSkill = 70,
		},
		SkillGainPerInstance = {
			FabricationSkill = 10,
		},
		EnhancementSlot = { ArmorBodySlot = true},
		ResourcesRequired = {
			BeastLeather = 5,
		},
		AdditionalBonuses = {
			InstanceMin = {
				[2] = {
						Bonuses = {
							BonusEvasionModifier = -1,
							BonusManaBarrier = 2,
						},
				},
			},

		},
	},
}
