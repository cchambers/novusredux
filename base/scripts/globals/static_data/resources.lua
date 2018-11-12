ResourceData = {
	ResourceSourceInfo = 
	{		
		Tree = 
		{
			ResourceType = "Wood",
			ToolType = "Axe",		
			SkillRequired = "LumberjackSkill",
			DepletedState = "Stump",			

			RareResources = {
				Ash = {					
					VisualState = "HighQuality",
					MinSkill = 35,
				},
				Blightwood = {					
					VisualState = "HighQuality",
					MinSkill = 75,
				},
			}
		},

		BlackForestTree = 
		{
			ResourceType = "Wood",
			ToolType = "Axe",		
			SkillRequired = "LumberjackSkill",
			DepletedState = "Stump",			

			RareResources = {
				Ash = {					
					VisualState = "HighQuality",
					MinSkill = 35,
				},
				Blightwood = {					
					VisualState = "HighQuality",
					MinSkill = 75,
				},
			}
		},

		Rock = 
		{ 
			ResourceType = "Stone",
			ToolType = "Pick",		
			SkillRequired = "MiningSkill",
			DepletedState = "Depleted",

			RareResources = {
				IronOre = {					
					VisualState = "IronVein",
					MinSkill = 0,
				},
				BronzeOre = {
					VisualState = "BronzeVein",
					MinSkill = 20,
				},
				CopperOre = {
					VisualState = "CopperVein",
					MinSkill = 40,
				},
				SteelOre = {
					VisualState = "SteelVein",
					MinSkill = 60,
				},
				ObsidianOre = {
					VisualState = "ObsidianVein",
					MinSkill = 80,
				},
			}
		},

		Ginseng = 
		{
			SourceTemplate = "plant_ginseng",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
			ResourceType = "Ginseng",
		},

		LemonGrass = 
		{
			SourceTemplate = "plant_lemon_grass",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
			ResourceType = "LemonGrass",
		},

		Cotton = 
		{
			SourceTemplate = "plant_cotton",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
			ResourceType = "Cotton",
		},

		Kindling = 
		{
			SourceTemplate = "plant_kindling",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
			ResourceType = "Kindling",
		},

		Mushrooms = 
		{
			SourceTemplate = "plant_mushrooms",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
			ResourceType = "Mushrooms",
		},

		GiantMushrooms = {
			SourceTemplate = "plant_giant_mushrooms",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
			HarvestBonusFactor = 1.0,
			ResourceType = "GiantMushrooms",
		},

		MushroomsPoison = 
		{
			SourceTemplate = "plant_mushrooms_poison",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
			ResourceType = "MushroomsPoison",
		},

		MushroomsPoisonNoxious = 
		{
			SourceTemplate = "ingredient_mushroom_poison_noxious",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
			ResourceType = "MushroomsPoisonNoxious",
		},

		HumanSkull = 
		{
			SourceTemplate = "item_human_skull",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
			ResourceType = "HumanSkull",
		},

		Bones = 
		{
			SourceTemplate = "item_bones",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
			ResourceType = "Bones",
		},

		Cactus = 
		{
			SourceTemplate = "plant_cactus",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
			ResourceType = "Cactus",
		},

		SacredCactus = 
		{
			SourceTemplate = "plant_sacred_cactus",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
			ResourceType = "SacredCactus",
		},

		Moss = 
		{
			SourceTemplate = "plant_moss",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
			ResourceType = "Moss",
		},

		HalloweenJackOLantern = 
		{
			SourceTemplate = "halloween_jack_o_lantern",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
		},

		HalloweenJackOLanternHappy = 
		{
			SourceTemplate = "halloween_jack_o_lantern_happy",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
		},

		HalloweenJackOLanternSad = 
		{
			SourceTemplate = "halloween_jack_o_lantern_sad",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
		},

		HalloweenJackOLanternSurprised = 
		{
			SourceTemplate = "halloween_jack_o_lantern_surprised",
			ToolType = "BareHands",
			DestroyWhenDepleted = true,
		},
	},

	ResourceInfo = {
		-- raw world resources
		Wood = {
			HarvestBonusSkill = "LumberjackSkill",
			
			Template = "resource_wood",
			SalvageValue = 1,
			Difficulty = {
				Min = 0,
				Max = 100
			}
		},
		Blightwood = {
			HarvestBonusSkill = "LumberjackSkill",
			Template = "resource_blightwood",
			SalvageValue = 1,
			SkillGainDifficultyMultiplier = 2,
			Difficulty = {
				Min = 75,
				Max = 125
			}
		},
		Ash = {
			HarvestBonusSkill = "LumberjackSkill",
			DisplayName = "Ash",
			Template = "resource_ash",
			SalvageValue = 1,
			SkillGainDifficultyMultiplier = 2,	
			Difficulty = {
				Min = 35,
				Max = 85
			}
		},

		Stone = {
			HarvestBonusSkill = "MiningSkill",
			Template = "resource_stone",
			SalvageValue = 0.3,
			Difficulty = {
				Min = 0,
				Max = 50
			}
		},
		Sand = {
			HarvestBonusSkill = "MiningSkill",
			Template = "resource_sand",
			SalvageValue = 0.3,
		},
		IronOre = {
			HarvestBonusSkill = "MiningSkill",
			Template = "resource_iron_ore",
			DisplayName = "Iron Ore",
			SalvageValue = 1,
			SalvageResource = "MetalScraps",

			Difficulty = {
				Min = 0,
				Max = 100
			}
		},
		CopperOre = {
			HarvestBonusSkill = "MiningSkill",
			Template = "resource_copper_ore",
			DisplayName = "Copper Ore",
			SkillGainDifficultyMultiplier = 2,

			Difficulty = {
				Min = 25,
				Max = 125
			}
		},
		SteelOre = {
			HarvestBonusSkill = "MiningSkill",
			Template = "resource_steel_ore",
			DisplayName = "Steel Ore",
			SkillGainDifficultyMultiplier = 2,

			Difficulty = {
				Min = 40,
				Max = 140,
			}
		},
		BronzeOre = {
			HarvestBonusSkill = "MiningSkill",
			Template = "resource_bronze_ore",
			DisplayName = "Bronze Ore",

			Difficulty = {
				Min = 10,
				Max = 110
			}
		},
		ObsidianOre = {
			HarvestBonusSkill = "MiningSkill",
			Template = "resource_obsidian_ore",
			DisplayName = "Obsidian Ore",
			SkillGainDifficultyMultiplier = 2,

			Difficulty = {
				Min = 55,
				Max = 155
			}
		},
		LeatherScraps = {
			Template = "resource_leatherscraps",
			DisplayName = "Leather Scraps",
		},
		BruteLeatherScraps = {
			Template = "resource_brute_leatherscraps",
			DisplayName = "Brute Leather Scraps",
		},
		BeastLeatherScraps = {
			Template = "resource_beast_leatherscraps",
			DisplayName = "Beast Leather Scraps",
		},
		FabledBeastLeatherScraps = {
			Template = "resource_fabled_beast_leatherscraps",
			DisplayName = "Fabled Beast Leather Scraps",
		},
		ClothScraps = {
			Template = "resource_clothscraps",
			DisplayName = "Cloth Scraps",
		},
		QuiltedClothScraps = {
			Template = "resource_clothscraps_quilted",
			DisplayName = "Quilted Cloth Scraps",
		},
		SilkScraps = {
			Template = "resource_silkscraps",
			DisplayName = "Silk Scraps",
		},
		RoyalSilkScraps = {
			Template = "resource_silkscraps_royal",
			DisplayName = "Silk Scraps",
		},
		Miasma = {
			Template = "animalparts_miasma",
			DisplayName = "Miasma",
		},
		MiasmaDeathly = {
			Template = "animalparts_miasma_deathly",
			DisplayName = "Deathly Miasma",
		},
		Kindling = {
			Template = "resource_kindling",
			DisplayName = "Kindling",
		},
		Cotton = {
			Template = "resource_cotton",
			DisplayName = "Cotton",
			AlternateHarvestResources = {
				{
					ResourceType = "CottonFluffy",
					SkillThreshold = 40,
					SkillThresholdMax = 80,
					MaxUpgradeChance = 5,
				},				
			},
		},
		CottonFluffy = {
			Template = "resource_cotton_fluffy",
			DisplayName = "Fluffy Cotton",
			SkillGainDifficultyMultiplier = 10,
		},

		-- intermediate world resources
		Iron = {
			Template = "resource_iron",
			DisplayName = "Iron",
			CraftedItemPrefix = "Iron",
			SalvageValue = 7,
			SalvageResource = "MetalScraps",
		},
		Copper = {
			Template = "resource_copper",
			DisplayName = "Copper",
			CraftedItemPrefix = "Copper",
		},
		Steel = {
			Template = "resource_steel",
			DisplayName = "Steel",
			CraftedItemPrefix = "Steel",
			SalvageValue = 7,
			SalvageResource = "MetalScrapsSteel",
			SkillGainDifficultyMultiplier = 2,
		},
		Bronze = {
			Template = "resource_bronze",
			DisplayName = "Bronze",
			CraftedItemPrefix = "Bronze",
		},
		CobaltCrystallized = {
			Template = "resource_cobalt_crystallized",
			DisplayName = "Crystallized Cobalt",
			CraftedItemPrefix = "Crystallized Cobalt",
			SalvageValue = 7,
			SalvageResource = "CobaltScrapsCrystallized",
			SkillGainDifficultyMultiplier = 10,
		},
		Obsidian = {
			Template = "resource_obsidian",
			DisplayName = "Obsidian",
			CraftedItemPrefix = "Obsidian",
		},
		Leather = {
			Template = "resource_leather",
			DisplayName = "Leather",
			SkillGainDifficultyMultiplier = 10,
		},
		BeastLeather = {
			Template = "resource_beast_leather",
			DisplayName = "Beast Leather",
			CraftedItemPrefix = "Beast",
			SkillGainDifficultyMultiplier = 5,
		},
		VileLeather = {
			Template = "resource_vile_leather",
			DisplayName = "Vile Leather",
			CraftedItemPrefix = "Vile",
			SkillGainDifficultyMultiplier = 10,
		},
		Boards = {
			DisplayName = "Wooden Boards",
			Template = "resource_boards",
			CraftedItemPrefix = "Wooden",
		},
		AshBoards = {
			DisplayName = "Ash Boards",
			Template = "resource_boards_ash",
			CraftedItemPrefix = "Ash",
			SalvageValue = 2,
			SalvageResource = "Wood",
			SkillGainDifficultyMultiplier = 2,
		},
		BlightwoodBoards = {
			DisplayName = "Blightwood Boards",
			Template = "resource_blightwood_boards",
			CraftedItemPrefix = "Blightwood",
			SalvageValue = 2,
			SalvageResource = "Blightwood",
			SkillGainDifficultyMultiplier = 5,
		},
		Cloth = {
			DisplayName = "Cloth",
			Template = "resource_bolt_of_cloth",
			CraftedItemPrefix = "Cloth",
		},
		QuiltedCloth = {
			DisplayName = "Quilted Cloth",
			CraftedItemPrefix = "Quilted",
			Template = "resource_bolt_of_cloth_quilted",			
		},
		SilkCloth = {
			DisplayName = "Silk Cloth",
			CraftedItemPrefix = "Silk",
			Template = "resource_silk_cloth",
		},
		WildSilkCloth = {
			DisplayName = "Wild Silk Cloth",
			CraftedItemPrefix = "Wild Silk",
			Template = "resource_wild_silk_cloth",
		},

		-- GEMS --

		Diamond = {
			Template = "diamond_gem",
			DisplayName = "Diamond",
		},

		Emerald = {
			Template = "emerald_gem",
			DisplayName = "Emerald",
		},

		Ruby = {
			Template = "ruby_gem",
			DisplayName = "Ruby",
		},

		Sapphire = {
			Template = "sapphire_gem",
			DisplayName = "Sapphire",
		},

		Topaz = {
			Template = "topaz_gem",
			DisplayName = "Topaz",
		},
		
		-- Recipes --

		RecipeSilkCloth = {
			Template = "recipe_silkcloth",
			DisplayName = "Recipe: Silk Cloth",
		},
		RecipeQuiltedCloth = {
			Template = "recipe_quiltedcloth",
			DisplayName = "Recipe: Quilted Cloth",
		},
		RecipeVileLeather = {
			Template = "recipe_vile_leather",
			DisplayName = "Recipe: Vile Leather",
		},
		RecipeBeastLeather = {
			Template = "recipe_beast_leather",
			DisplayName = "Recipe: Beast Leather",
		},
		RecipeBronze = {
			Template = "recipe_bronze",
			DisplayName = "Recipe: Bronze",
		},
		RecipeCopper = {
			Template = "recipe_copper",
			DisplayName = "Recipe: Copper",
		},
		RecipeSteel = {
			Template = "recipe_steel",
			DisplayName = "Recipe: Steel",
		},
		RecipeObsidian = {
			Template = "recipe_obsidian",
			DisplayName = "Recipe: Obsidian",
		},
		RecipeChainHelm = {
			Template = "recipe_chain_helm",
			DisplayName = "Recipe: Chain Helm",
		},
		RecipeChainLeggings = {
			Template = "recipe_chain_leggings",
			DisplayName = "Recipe: Chain Leggings",
		},
		RecipeChainTunic = {
			Template = "recipe_chain_tunic",
			DisplayName = "Recipe: Chain Tunic",
		},

		RecipeGladius = {
			Template = "recipe_gladius",
			DisplayName = "Recipe: Gladius",
		},
		RecipeGreatAxe = {
			Template = "recipe_greataxe",
			DisplayName = "Recipe: Great Axe",
		},
		RecipeLongbow = {
			Template = "recipe_longbow",
			DisplayName = "Recipe: Longbow",
		},
		RecipeRapier = {
			Template = "recipe_rapier",
			DisplayName = "Recipe: Rapier",
		},
		RecipeSledgehammer = {
			Template = "recipe_sledgehammer",
			DisplayName = "Recipe: Sledgehammer",
		},
		RecipeSpikedClub = {
			Template = "recipe_spikedclub",
			DisplayName = "Recipe: Spiked Club",
		},
		RecipeAxe = {
			Template = "recipe_axe",
			DisplayName = "Recipe: Axe",
		},
		RecipeAxeOfTheSun = {
			Template = "recipe_axeofthesun",
			DisplayName = "Recipe: Axe of the Sun",
		},
		RecipeBattleAxe = {
			Template = "recipe_battleaxe",
			DisplayName = "Recipe: Battle Axe",
		},
		RecipeBenediction = {
			Template = "recipe_benediction",
			DisplayName = "Recipe: Benediction",
		},
		RecipeBoneBow = {
			Template = "recipe_bonebow",
			DisplayName = "Recipe: Bone Bow",
		},
		RecipeBoneHelm = {
			Template = "recipe_bonehelm",
			DisplayName = "Recipe: Bone Helm",
		},
		RecipeBoneLeggings = {
			Template = "recipe_boneleggings",
			DisplayName = "Recipe: Bone Leggings",
		},
		RecipeBoneShield = {
			Template = "recipe_boneshield",
			DisplayName = "Recipe: Bone Shield",
		},
		RecipeBoneTunic = {
			Template = "recipe_bonetunic",
			DisplayName = "Recipe: Bone Tunic",
		},
		RecipeBroadsword = {
			Template = "recipe_broadsword",
			DisplayName = "Recipe: Broadsword",
		},
		RecipeCeleste = {
			Template = "recipe_celeste",
			DisplayName = "Recipe: Celeste",
		},
		RecipeCleaver = {
			Template = "recipe_cleaver",
			DisplayName = "Recipe: Cleaver",
		},
		RecipeCrusader = {
			Template = "recipe_crusader",
			DisplayName = "Recipe: Crusader",
		},
		RecipeLichBlade = {
			Template = "recipe_lichblade",
			DisplayName = "Recipe: Lich Blade",
		},
		RecipeCurvedShield = {
			Template = "recipe_curvedshield",
			DisplayName = "Recipe: Curved Shield",
		},
		RecipeDagger = {
			Template = "recipe_dagger",
			DisplayName = "Recipe: Dagger",
		},
		RecipeDarksword = {
			Template = "recipe_darksword",
			DisplayName = "Recipe: Darksword",
		},
		RecipeDarkwoodStaff = {
			Template = "recipe_darkwoodstaff",
			DisplayName = "Recipe: Darkwood Staff",
		},
		RecipeTribalStaff = {
			Template = "recipe_tribalstaff",
			DisplayName = "Recipe: Tribal Staff",
		},
		RecipeDemonsFang = {
			Template = "recipe_demonsfang",
			DisplayName = "Recipe: Demon's Fang",
		},
		RecipeDestruction = {
			Template = "recipe_destruction",
			DisplayName = "Recipe: Destruction",
		},
		RecipeDragonGuard = {
			Template = "recipe_dragonguard",
			DisplayName = "Recipe: Dragon Guard",
		},
		RecipeDragonHelm = {
			Template = "recipe_dragonhelm",
			DisplayName = "Recipe: Dragon Helm",
		},
		RecipeDragonLeggings = {
			Template = "recipe_dragonleggings",
			DisplayName = "Recipe: Dragon Leggings",
		},
		RecipeDragonTunic = {
			Template = "recipe_dragontunic",
			DisplayName = "Recipe: Dragon Tunic",
		},
		RecipeDwarvenHammer = {
			Template = "recipe_dwarvenhammer",
			DisplayName = "Recipe: Dwarven Hammer",
		},
		RecipeDwarvenMace = {
			Template = "recipe_dwarvenmace",
			DisplayName = "Recipe: Dwarven Mace",
		},
		RecipeDwarvenShield = {
			Template = "recipe_dwarvenshield",
			DisplayName = "Recipe: Dwarven Shield",
		},
		RecipeEldeirBow = {
			Template = "recipe_eldeirbow",
			DisplayName = "Recipe: Eldeir Bow",
		},
		RecipeElvenSword = {
			Template = "recipe_elvensword",
			DisplayName = "Recipe: Elven Sword",
		},
		RecipeFalchion = {
			Template = "recipe_falchion",
			DisplayName = "Recipe: Falchion",
		},
		RecipeStaveOfTheFallen = {
			Template = "recipe_fallen",
			DisplayName = "Recipe: Stave of the Fallen",
		},
		RecipeFlangedMace = {
			Template = "recipe_flangedmace",
			DisplayName = "Recipe: Flanged Mace",
		},
		RecipeFortress = {
			Template = "recipe_fortress",
			DisplayName = "Recipe: Fortress",
		},
		RecipeFullPlateHelm = {
			Template = "recipe_fullplatehelm",
			DisplayName = "Recipe: Full Plate Helm",
		},
		RecipeFullPlateLeggings = {
			Template = "recipe_fullplateleggings",
			DisplayName = "Recipe: Full Plate Leggings",
		},
		RecipeFullPlateTunic = {
			Template = "recipe_fullplatetunic",
			DisplayName = "Recipe: Full Plate Tunic",
		},
		RecipeGiantsBone = {
			Template = "recipe_giantsbone",
			DisplayName = "Recipe: Giant's Bone",
		},
		RecipeGladius = {
			Template = "recipe_gladius",
			DisplayName = "Recipe: Gladius",
		},
		RecipeGouge = {
			Template = "recipe_gouge",
			DisplayName = "Recipe: Gouge",
		},
		RecipeGreatAxe = {
			Template = "recipe_greataxe",
			DisplayName = "Recipe: Great Axe",
		},
		RecipeGreatHammer = {
			Template = "recipe_greathammer",
			DisplayName = "Recipe: Great Hammer",
		},
		RecipeAvenger = {
			Template = "recipe_avenger",
			DisplayName = "Recipe: Avenger",
		},
		RecipeHammerOfTheAncients = {
			Template = "recipe_hammeroftheancients",
			DisplayName = "Recipe: Hammer of the Ancients",
		},
		RecipeHalberd = {
			Template = "recipe_halberd",
			DisplayName = "Recipe: Halberd",
		},
		RecipeHandOfTethys = {
			Template = "recipe_handoftethys",
			DisplayName = "Recipe: Hand of Tethys",
		},
		RecipeHardenedHelm = {
			Template = "recipe_hardenedhelm",
			DisplayName = "Recipe: Hardened Leather Helm",
		},
		RecipeHardenedLeggings = {
			Template = "recipe_hardenedleggings",
			DisplayName = "Recipe: Hardened Leather Leggings",
		},
		RecipeHardenedTunic = {
			Template = "recipe_hardenedtunic",
			DisplayName = "Recipe: Hardened Leather Tunic",
		},
		RecipeHeaterShield = {
			Template = "recipe_heatershield",
			DisplayName = "Recipe: Heater Shield",
		},
		RecipeIronHammer = {
			Template = "recipe_ironhammer",
			DisplayName = "Recipe: Iron Hammer",
		},
		RecipeIronStaff = {
			Template = "recipe_ironstaff",
			DisplayName = "Recipe: Iron Staff",
		},
		RecipeJambiya = {
			Template = "recipe_jambiya",
			DisplayName = "Recipe: Jambiya",
		},
		RecipeJourneymanStaff = {
			Template = "recipe_journeymanstaff",
			DisplayName = "Recipe: Journeyman Staff",
		},
		RecipeJustice = {
			Template = "recipe_justice",
			DisplayName = "Recipe: Justice",
		},
		RecipeKatana = {
			Template = "recipe_katana",
			DisplayName = "Recipe: Katana",
		},
		RecipeKnightSword = {
			Template = "recipe_knightsword",
			DisplayName = "Recipe: Knight Sword",
		},
		RecipeKryss = {
			Template = "recipe_kryss",
			DisplayName = "Recipe: Kryss",
		},
		RecipeLargeShield = {
			Template = "recipe_largeshield",
			DisplayName = "Recipe: Large Shield",
		},
		RecipeLeatherHelm = {
			Template = "recipe_leatherhelm",
			DisplayName = "Recipe: Leather Helm",
		},
		RecipeLeatherLeggings = {
			Template = "recipe_leatherleggings",
			DisplayName = "Recipe: Leather Leggings",
		},
		RecipeLeatherTunic = {
			Template = "recipe_leathertunic",
			DisplayName = "Recipe: Leather Tunic",
		},
		RecipeMace = {
			Template = "recipe_mace",
			DisplayName = "Recipe: Mace",
		},
		RecipeMagesStave = {
			Template = "recipe_magestave",
			DisplayName = "Recipe: Mage's Stave",
		},
		RecipeMarauderShield = {
			Template = "recipe_maraudershield",
			DisplayName = "Recipe: Marauder Shield",
		},
		RecipeMithrilBlade = {
			Template = "recipe_mithril",
			DisplayName = "Recipe: Mithril Blade",
		},
		RecipeMorningStar = {
			Template = "recipe_morningstar",
			DisplayName = "Recipe: Morning Star",
		},
		RecipeOrnateBlade = {
			Template = "recipe_ornate",
			DisplayName = "Recipe: Ornate Blade",
		},
		RecipeOrnateAxe = {
			Template = "recipe_ornateaxe",
			DisplayName = "Recipe: Ornate Axe",
		},
		RecipePeacekeeper = {
			Template = "recipe_peacekeeper",
			DisplayName = "Recipe: Peacekeeper",
		},
		RecipePlateHelm = {
			Template = "recipe_platehelm",
			DisplayName = "Recipe: Plate Helm",
		},
		RecipePlateTunic = {
			Template = "recipe_platetunic",
			DisplayName = "Recipe: Plate Tunic",
		},
		RecipePlateLeggings = {
			Template = "recipe_plateleggings",
			DisplayName = "Recipe: Plate Leggings",
		},
		RecipeKnowledgeHelm = {
			Template = "recipe_knowledgehelm",
			DisplayName = "Recipe: Knowledge Helm",
		},
		RecipeKnowledgeTunic = {
			Template = "recipe_knowledgetunic",
			DisplayName = "Recipe: Knowledge Tunic",
		},
		RecipeKnowledgeLeggings = {
			Template = "recipe_knowledgeleggings",
			DisplayName = "Recipe: Knowledge Leggings",
		},
		RecipePriestsScepter = {
			Template = "recipe_priestsscepter",
			DisplayName = "Recipe: Priest's Scepter",
		},

		RecipeGuardianShield = {
			Template = "recipe_guardianshield",
			DisplayName = "Recipe: Guardian",
		},
		RecipeTemper = {
			Template = "recipe_tempershield",
			DisplayName = "Recipe: Temper",
		},
		RecipeRedemption = {
			Template = "recipe_redemption",
			DisplayName = "Recipe: Redemption",
		},
		RecipeRitualHelm = {
			Template = "recipe_ritualhelm",
			DisplayName = "Recipe: Ritual Helm",
		},
		RecipeRitualTunic = {
			Template = "recipe_ritualtunic",
			DisplayName = "Recipe: Ritual Tunic",
		},
		RecipeRitualLeggings = {
			Template = "recipe_ritualleggings",
			DisplayName = "Recipe: Ritual Leggings",
		},
		RecipePlantHelm = {
			Template = "recipe_planthelm",
			DisplayName = "Recipe: Ritual Helm",
		},
		RecipePlantTunic = {
			Template = "recipe_planttunic",
			DisplayName = "Recipe: Ritual Tunic",
		},
		RecipePlantLeggings = {
			Template = "recipe_plantleggings",
			DisplayName = "Recipe: Ritual Leggings",
		},
		RecipeEldeirBow = {
			Template = "recipe_eldeirbow",
			DisplayName = "Recipe: Eldeir Bow",
		},
		RecipeRunedHalberd = {
			Template = "recipe_runedhalberd",
			DisplayName = "Recipe: Runed Halberd",
		},
		RecipeSavageBow = {
			Template = "recipe_savagebow",
			DisplayName = "Recipe: Savage Bow",
		},
		RecipeScaleHelm = {
			Template = "recipe_scalehelm",
			DisplayName = "Recipe: Scale Helm",
		},
		RecipeScaleTunic = {
			Template = "recipe_scaletunic",
			DisplayName = "Recipe: Scale Tunic",
		},
		RecipeScaleLeggings = {
			Template = "recipe_scaleleggings",
			DisplayName = "Recipe: Scale Leggings",
		},
		RecipeScimitar = {
			Template = "recipe_scimitar",
			DisplayName = "Recipe: Scimitar",
		},
		RecipeShiv = {
			Template = "recipe_shiv",
			DisplayName = "Recipe: Shiv",
		},
		RecipeSilence = {
			Template = "recipe_silence",
			DisplayName = "Recipe: Silence",
		},
		RecipeSmasher = {
			Template = "recipe_smasher",
			DisplayName = "Recipe: Smasher",
		},
		RecipeSpear = {
			Template = "recipe_spear",
			DisplayName = "Recipe: Spear",
		},
		RecipeSpikedHammer = {
			Template = "recipe_spikedhammer",
			DisplayName = "Recipe: Spiked Hammer",
		},
		RecipeStaffOfTheDead = {
			Template = "recipe_staffofthedead",
			DisplayName = "Recipe: Staff of the Dead",
		},
		RecipeStaffOfTheMagi = {
			Template = "recipe_staffofthemagi",
			DisplayName = "Recipe: Staff of the Magi",
		},
		RecipeStaffOfTheSun = {
			Template = "recipe_staffofthesun",
			DisplayName = "Recipe: Staff of the Sun",
		},
		RecipeLongSword = {
			Template = "recipe_longsword",
			DisplayName = "Recipe: Long Sword",
		},
		RecipeTribalSpear = {
			Template = "recipe_tribalspear",
			DisplayName = "Recipe: Tribal Spear",
		},
		RecipeUndeath = {
			Template = "recipe_undeath",
			DisplayName = "Recipe: Undeath",
		},
		RecipeVictory = {
			Template = "recipe_victory",
			DisplayName = "Recipe: Victory",
		},
		RecipeVouge = {
			Template = "recipe_vouge",
			DisplayName = "Recipe: Vouge",
		},
		RecipeWarAxe = {
			Template = "recipe_waraxe",
			DisplayName = "Recipe: War Axe",
		},
		RecipeWarSpear = {
			Template = "recipe_warspear",
			DisplayName = "Recipe: War Spear",
		},
		RecipeWhiteStaff = {
			Template = "recipe_whitestaff",
			DisplayName = "Recipe: White Staff",
		},
		RecipeShorts = {
			Template = "recipe_shorts",
			DisplayName = "Recipe: Shorts",
		},
		RecipeSkirts = {
			Template = "recipe_skirts",
			DisplayName = "Recipe: Skirts",
		},
		RecipeApron = {
			Template = "recipe_apron",
			DisplayName = "Recipe: Apron",
		},
		RecipeBlacksmith = {
			Template = "recipe_blacksmith",
			DisplayName = "Recipe: Blacksmith",
		},
		RecipeBandana = {
			Template = "recipe_bandana",
			DisplayName = "Recipe: Bandana",
		},
		RecipeBanditHood = {
			Template = "recipe_bandithood",
			DisplayName = "Recipe: Bandit Hood",
		},
		RecipeMageHat = {
			Template = "recipe_magehat",
			DisplayName = "Recipe: Mage Hat",
		},
		RecipeLinenHelm = {
			Template = "recipe_linenhelm",
			DisplayName = "Recipe: Linen Helm",
		},
		RecipeLinenLegs = {
			Template = "recipe_linenlegs",
			DisplayName = "Recipe: Linen Legs",
		},
		RecipeLinenChest = {
			Template = "recipe_linenchest",
			DisplayName = "Recipe: Linen Chest",
		},
		RecipeLeatherLegs = {
			Template = "recipe_leatherlegs",
			DisplayName = "Recipe: Leather Legs",
		},
		RecipeLeatherChest = {
			Template = "recipe_leatherchest",
			DisplayName = "Recipe: Leather Chest",
		},
		RecipeHardenedHood = {
			Template = "recipe_hardenedhood",
			DisplayName = "Recipe: Hardened Hood",
		},
		RecipeHardenedChest = {
			Template = "recipe_hardenedchest",
			DisplayName = "Recipe: Hardened Chest",
		},
		RecipeMageRobes = {
			Template = "recipe_magerobes",
			DisplayName = "Recipe: Mage Robes",
		},
		RecipeSaddlebags = {
			Template = "recipe_saddlebags",
			DisplayName = "Recipe: Leather Saddlebags",
		},
		-- FOOD RESOURCES --

		KhoToken = {		
			Template = "kho_token",
		},
		Wine = {
			Template = "ingredient_wine",
			AlternateHarvestResources = {
				{
					ResourceType = "OliveOil",
					SkillThreshold = 80,
					SkillThresholdMax = 100,
					MaxUpgradeChance = 30,
				},
			},
		},

		Ginseng = {
			Template = "ingredient_ginsengroot",
			AlternateHarvestResources = {
				{
					ResourceType = "AncientGinseng",
					SkillThreshold = 40,
					SkillThresholdMax = 80,
					MaxUpgradeChance = 30,
				},
			},
		},
		Moss = {
			Template = "ingredient_moss",
		},
		AncientGinseng = {
			Template = "ingredient_ancient_ginsengroot",
		},
		LemonGrass = {
			Template = "ingredient_lemongrass",
			AlternateHarvestResources = {
				{
					ResourceType = "ingredient_lemongrass_spirited",
					SkillThreshold = 20,
					SkillThresholdMax = 40,
					MaxUpgradeChance = 30,
				},
			},
		}, 
		LemonGrassSpirited = {
			Template = "ingredient_lemongrass_spirited",
		},

		MushroomsPoison = {
			Template = "ingredient_mushroom_poison",
			AlternateHarvestResources = {
				{
					ResourceType = "MushroomsPoisonNoxious",
					SkillThreshold = 80,
					SkillThresholdMax = 100,
					MaxUpgradeChance = 30,
				},
			},
		},

		MushroomsPoisonNoxious = {
			Template = "ingredient_mushroom_poison_noxious",
		},

		Mushrooms = {
			Template = "ingredient_mushroom",
			AlternateHarvestResources = {
				{
					ResourceType = "FragrantMushrooms",
					SkillThreshold = 20,
					SkillThresholdMax = 60,
					MaxUpgradeChance = 30,
				},
			},	
		},		

		GiantMushrooms = {
			Template = "ingredient_giant_mushrooms",
		},

		Cactus = {
			Template = "ingredient_cactus",
			AlternateHarvestResources = {
				{
					ResourceType = "SacredCactus",
					SkillThreshold = 40,
					SkillThresholdMax = 80,
					MaxUpgradeChance = 30,
				},
			},
		},

		SacredCactus = {
			Template = "ingredient_sacred_cactus",
		},
		FragrantMushrooms = {
			Template = "ingredient_mushroom_fragrant",
		},
		OliveOil = {
			Template = "ingredient_olive_oil",
		},
		Apple = {
			Template = "item_apple",
		},
		Pumpkin = {
			Template = "resource_pumpkin",
		},
		FruitCatacombs = {
			Template = "fruit_catacombs",
		},
		FruitCatacombsNectar = {
			Template = "fruit_catacombs_nectar",
		},
		PlantFabric = {
			Template = "resource_plant_fabric",
		},
		Bread = {
			Template = "item_bread",
		},
		Broccoli = {
			Template = "ingredient_broccoli",
		},
		Cabbage = {
			Template = "ingredient_cabbage",
		},
		Cucumber = {
			Template = "ingredient_cucumber",
		},
		GreenPepper = {
			Template = "ingredient_green_pepper",
		},
		Onion = {
			Template = "ingredient_onion",
		},
		Potato = {
			Template = "ingredient_potato",
		},
		Tomato = {
			Template = "ingredient_tomato",
		},
		Beer = { --BEEEEEEERRR
			Template = "item_beer",
		},
		Mead = { --BEEEEEEERRR
			Template = "item_mead",
		},
		FishFilletBarrel = { --BEEEEEEERRR
			Template = "animalparts_barrel_fish_fillet",
		},
		FishFilletTero = { --BEEEEEEERRR
			Template = "animalparts_tero_fish_fillet",
		},
		FishFilletSpottedTero = { --BEEEEEEERRR
			Template = "animalparts_spotted_tero_fish_fillet",
		},
		FishFilletFourEyedSalar = { --BEEEEEEERRR
			Template = "animalparts_foureyed_salar_fish_fillet",
		},
		FishFilletRazor = { --BEEEEEEERRR
			Template = "animalparts_razor_fish_fillet",
		},
		FishFilletGoldenAether = { --BEEEEEEERRR
			Template = "animalparts_golden_aether_fish_fillet",
		},

		-- ANIMAL PARTS ---
		AnimalMeat = {
			Template = "animalparts_meat",
		},
		FishFilet = {
			Template = "animalparts_meat",
		},
		BearClaw = {
			Template = "animalparts_bear_claw",
		},
		FishScale = {
			Template = "animalparts_fish_scale",
		},
		LeatherHide = {
			Template = "animalparts_leather_hide",
		},
		BruteLeatherHide = {
			Template = "animalparts_brute_leather_hide",
		},
		BeastLeatherHide = {
			Template = "animalparts_beast_leather_hide",
		},
		VileLeatherHide = {
			Template = "animalparts_vile_leather_hide",
		},
		HumanFlesh = {
			Template = "animalparts_human_flesh",
		},
		VampireBlood = 
		{
			Template = "animalparts_vampire_blood",
		},
		WereBatBlood = 
		{
			Template = "animalparts_werebat_blood",
		},
		HumanMeat = {
		},
		OgreTooth = {
			Template = "animalparts_ogre_tooth",
		},
		HumanSkull = {
			Template = "animalparts_human_skull",
		},
		RabbitFoot = {
			Template = "animalparts_rabbit_foot",
		},
		RatEar = {
			Template = "animalparts_rat_ear",
		},
		BatEar = {
			Template = "animalparts_bat_ear",
		},
		SnakeSkin = {
			Template = "animalparts_snake_skin",
			DisplayName = "Snake Skin",
		},
		ViperSkin = {
			Template = "animalparts_viper_skin",
		},
		SpiderEye = {
			Template = "animalparts_spider_eye",
		},
		Silk = {
			Template = "animalparts_spider_silk",
			DisplayName = "Spider Silk",
		},
		SpiderSilkGolden = {
			Template = "animalparts_spider_silk_golden",
			DisplayName = "Golden Spider Silk",
		},
		CochinealExtract = {
			Template = "animalparts_beetle_extract",
		},
		WormExtract = {
			Template = "animalparts_worm_extract",
		},
		Feather = {
			Template = "animalparts_feather",
		},
		WolfFang = {
			Template = "animalparts_wolf_fang",
		},
		AncientBearClaw = {
			Template = "animalparts_ancient_bear_claw",
		},
		AncientBearFang = {
			Template = "animalparts_ancient_bear_fang",
		},
		DireWolfFang = {
			Template = "animalparts_dire_wolf_fang",
		},
		GossamerSilk = {
			Template = "animalparts_gloss_silk",
		},
		BeetleExtract = {
			Template = "animalparts_beetle_extract",
		},
		PlagueRatEar = {
			Template = "animalparts_plague_rat_ear",
		},
		PurpleSpiderEye = {
			Template = "animalparts_purple_spider_eye",
		},
		Blood = {
			Template = "animalparts_beast",
		},
		BoneMarrow = {
			Template = "animalparts_bone_marrow",
		},
		BeastEye = {
			Template = "animalparts_beast_eye",
		},
		ToxicSaliva = {
			Template = "animalparts_toxic_saliva",
		},		

		-- MISC RESOURCES --
		Crystal = {
			Template = "resource_crystal",
		},
		Essence = {
			Template = "resource_essence",
		},

		Bones = {
			CraftedItemPrefix = {Stout="Fibrous"},
			Template = "animalparts_bone",
		},
		CursedBones = {
			DisplayName = "Cursed Bones",
			CraftedItemPrefix = "Cursed",
			Template = "animalparts_bone_cursed",
		},
		ToxicBones = {
			DisplayName = "Toxic Bones",
			CraftedItemPrefix = "Toxic",
			Template = "animalparts_bone_cursed",
		},
		SpectralBones = {
			DisplayName = "Spectral Bones",
			CraftedItemPrefix = "Spectral",
			Template = "animalparts_bone_cursed",
		},
		ArcaneScroll = {
			Template = "ingredient_arcane_scroll",
		},
		BlankScroll = {
			Template = "resource_blankscroll",
			DisplayName = "Blank Scroll",
		}
	}
}