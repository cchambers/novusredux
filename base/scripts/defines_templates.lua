TemplateDefines = {
	-- DAB COMBAT CHANGES: UPDATE OR REMOVE THESE DEFINES

	LootTable = 
	{
		-- All new players will get this gear
		NewbiePlayer = 
		{
		    -- Starting items
			NumCoins = 50,
			NumItems = 5,
	    	LootItems = {
    			{ Template = "torch", Unique = true },
    			{ Template = "tool_hunting_knife", Unique = true },
    			{ Template = "item_bread", Unique = true },
    			{ Template = "world_map", Unique = true},
    		},
		},

		Humanoid = 
		{
			NumItemsMin = 0,
			NumItemsMax = 3,
	    	LootItems = {
    			{ Weight = 10, Template = "torch", Unique = true },
    			{ Weight = 10, Template = "tool_hunting_knife", Unique = true },
    			{ Weight = 25, Template = "item_apple", Unique = true },
    			{ Weight = 25, Template = "item_bread", Unique = true },
    			{ Weight = 25, Template = "item_ale", Unique = true },
    			{ Weight = 5, Template = "potion_lmana", Unique = true },
    			{ Weight = 5, Template = "potion_lstamina", Unique = true },
    			{ Weight = 5, Template = "potion_lheal", Unique = true },
    			{ Weight = 5, Template = "potion_cure", Unique = true },
    			{ Weight = 10, Template = "clothing_bandana_helm", Unique = true },
    			{ Weight = 10, Template = "clothing_tattered_legs", Unique = true },
    			{ Weight = 10, Template = "clothing_tattered_shirt_chest", Unique = true },
    			{ Weight = 10, Template = "tool_cookingpot", Unique = true },
    			{ Weight = 10, Template = "tool_hatchet", Unique = true },
    			{ Weight = 10, Template = "tool_mining_pick", Unique = true },
    			{ Weight = 10, Template = "tool_fishing_rod", Unique = true },
    		},
		},

		PotionsPoor = 
		{
			NumItems = 1,
	    	LootItems = {
    			{ Chance = 1, Template = "potion_lmana", Unique = true },
    			{ Chance = 1, Template = "potion_lstamina", Unique = true },
    			{ Chance = 1, Template = "potion_lheal", Unique = true },
    			{ Chance = 1, Template = "potion_cure", Unique = true },
    		},
		},

		Potions = 
		{
			NumItems = 1,
	    	LootItems = {
    			{ Chance = 5, Template = "potion_mana", Unique = true },
    			{ Chance = 5, Template = "potion_stamina", Unique = true },
    			{ Chance = 5, Template = "potion_heal", Unique = true },
    			{ Chance = 5, Template = "potion_cure", Unique = true },
    		},
		},

		PotionsRich = 
		{
			NumItems = 1,
	    	LootItems = {
    			{ Chance = 10, Template = "potion_mana", Unique = true },
    			{ Chance = 10, Template = "potion_stamina", Unique = true },
    			{ Chance = 10, Template = "potion_heal", Unique = true },
    			{ Chance = 10, Template = "potion_cure", Unique = true },
    		},
		},

		Poor = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
				{ Chance = 1, Template = "random_executioner_weapon_0_60", Unique = true},
			},
		},

		Average = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
				{ Chance = 1, Template = "random_executioner_weapon_20_80", Unique = true},
			},
		},

		Rich = 
		{
			NumItems = 1,		

			LootItems = 
			{ 
				{ Chance = 2, Template = "random_executioner_weapon_20_80", Unique = true},
			},
		},

		FilthyRich = 
		{
			NumItems = 1,

			LootItems = 
			{ 
				{ Chance = 2, Template = "random_executioner_weapon_50_100", Unique = true},
			},
		},

		Boss = 
		{
			NumItems = 5,
					
			LootItems = 
			{ 
				{ Weight = 1, Template = "random_executioner_weapon_80_100", Unique = true},
			},
		},

		DeathBoss = 
		{
			NumItems = 3,
					
			LootItems = 
			{ 
				{ Weight = 1, Template = "random_executioner_weapon_80_100", Unique = true},
			},
		},

		DeathBossGear = 
		{
			NumItems = 1,
					
			LootItems = 
			{ 
				{ Weight = 1, Template = "robe_necromancer_tunic", Unique = true},
				{ Weight = 1, Template = "robe_necromancer_leggings", Unique = true},
				{ Weight = 1, Template = "robe_necromancer_helm", Unique = true},
				{ Weight = 1, Template = "weapon_dark_bow", Unique = true},
				{ Weight = 1, Template = "weapon_shadowblade", Unique = true},
				{ Weight = 1, Template = "weapon_death_scythe", Unique = true},
				{ Weight = 1, Template = "weapon_silver_longsword", Unique = true},
				{ Weight = 1, Template = "weapon_dark_maul", Unique = true},
				{ Weight = 1, Template = "packed_throne_reaper", Unique = true},
				{ Weight = 1, Template = "packed_teleporter", Unique = true},
				{ Weight = 1, Template = "item_statue_death", Unique = true},
			},
		},

		SpiderPoor = 
		{
			NumItems = 1,
	    	LootItems = {
    			{ Chance = 1, Template = "animalparts_spider_silk", Unique = true },
    		},
		},

		Spider = 
		{
			NumItems = 1,
	    	LootItems = {
    			{ Chance = 10, Template = "animalparts_spider_silk", Unique = true, StackCountMin = 1, StackCountMax = 2 },
    		},
		},

		SpiderRich = 
		{
			NumItems = 1,
	    	LootItems = {
    			{ Chance = 10, Template = "animalparts_spider_silk", Unique = true, StackCountMin = 1, StackCountMax = 3 },
    		},
		},


		SkeletonPoor = 
		{
			NumItemsMin = 0,
			NumItemsMax = 1,
	    	LootItems = {
	    		{ Weight = 25, Template = "animalparts_bone_cursed", Unique = true },
    			{ Weight = 25, Template = "animalparts_human_skull", Unique = true },
    			{ Weight = 25, Template = "animalparts_blood", Unique = true },
    		},
		},

		Skeleton = 
		{
			NumItemsMin = 0,
			NumItemsMax = 2,
	    	LootItems = {
	    		{ Weight = 5, Template = "animalparts_bone_cursed", Unique = true },
    			{ Weight = 25, Template = "animalparts_human_skull", Unique = true },
    			{ Weight = 25, Template = "animalparts_blood", Unique = true },
    		},
		},

		SkeletonRich = 
		{
			NumItemsMin = 1,
			NumItemsMax = 2,
	    	LootItems = {
	    		{ Weight = 5, Template = "animalparts_bone_cursed", Unique = true },
    			{ Weight = 25, Template = "animalparts_human_skull", Unique = true },
    			{ Weight = 25, Template = "animalparts_blood", Unique = true },
    		},
		},

		SpectralPoor = 
		{
			NumItemsMin = 0,
			NumItemsMax = 1,
	    	LootItems = {
	    		{ Weight = 10, Template = "animalparts_bone_spectral", Unique = true },
	    		{ Weight = 25, Template = "animalparts_human_skull", Unique = true },
    		},
		},

		Spectral = 
		{
			NumItemsMin = 0,
			NumItemsMax = 2,
	    	LootItems = {
	    		{ Weight = 10, Template = "animalparts_bone_spectral", Unique = true },
	    		{ Weight = 25, Template = "animalparts_human_skull", Unique = true },
    		},
		},

		SpectralRich = 
		{
			NumItemsMin = 1,
			NumItemsMax = 2,
	    	LootItems = {
	    		{ Weight = 10, Template = "animalparts_bone_spectral", Unique = true },
	    		{ Weight = 25, Template = "animalparts_human_skull", Unique = true },
    		},
		},

		MiasmaPoor = 
		{
			NumItemsMin = 0,
			NumItemsMax = 1,
	    	LootItems = {
	    		{ Weight = 10, Template = "animalparts_miasma", Unique = true },
	    		{ Weight = 25, Template = "animalparts_human_skull", Unique = true },
    		},
		},

		Miasma = 
		{
			NumItemsMin = 0,
			NumItemsMax = 2,
	    	LootItems = {
	    		{ Chance = 20, Template = "animalparts_miasma", Unique = true },
    		},
		},

		MiasmaRich = 
		{
			NumItemsMin = 1,
			NumItemsMax = 2,
	    	LootItems = {
	    		{ Chance = 20, Template = "animalparts_miasma", Unique = true },
    		},
		},

		DMiasmaPoor = 
		{
			NumItemsMin = 0,
			NumItemsMax = 1,
	    	LootItems = {
	    		{ Weight = 10, Template = "animalparts_miasma_deathly", Unique = true },
	    		{ Weight = 25, Template = "animalparts_human_skull", Unique = true },
    		},
		},

		DMiasma = 
		{
			NumItemsMin = 0,
			NumItemsMax = 2,
	    	LootItems = {
	    		{ Chance = 5, Template = "animalparts_miasma_deathly", Unique = true },
	    		{ Weight = 25, Template = "animalparts_human_skull", Unique = true },
    		},
		},

		DMiasmaRich = 
		{
			NumItemsMin = 1,
			NumItemsMax = 2,
	    	LootItems = {
	    		{ Chance = 5, Template = "animalparts_miasma_deathly", Unique = true },
	    		{ Weight = 25, Template = "animalparts_human_skull", Unique = true },
    		},
		},

		ZombiePoor = 
		{
			NumItems = 1,
	    	LootItems = {
	    		{ Weight = 10, Template = "animalparts_bone_marrow", Unique = true },
    			{ Weight = 25, Template = "animalparts_human_skull", Unique = true },
    		},
		},

		Zombie = 
		{
			NumItems = 1,
	    	LootItems = {
	    		{ Weight = 10, Template = "animalparts_bone_marrow", Unique = true },
    			{ Weight = 25, Template = "animalparts_human_skull", Unique = true },
    		},
		},

		ZombieRich = 
		{
			NumItems = 1,
	    	LootItems = {
	    		{ Weight = 10, Template = "animalparts_bone_marrow", Unique = true },
    			{ Weight = 25, Template = "animalparts_human_skull", Unique = true },
    		},
		},

		ScrollsLow = 
		{
			NumItemsMin = 0,
			NumItemsMax = 1,	

			LootItems = 
			{ 
				{ Chance = 20, Template = "lscroll_heal", Unique = true },
				{ Chance = 20, Template = "lscroll_cure", Unique = true },
				{ Chance = 20, Template = "lscroll_poison", Unique = true },
				{ Chance = 20, Template = "lscroll_ruin", Unique = true },
				{ Chance = 20, Template = "lscroll_defence", Unique = true },
			},
		},		
		ScrollsMed = 
		{
			NumItemsMin = 0,
			NumItemsMax = 2,

			LootItems = 
			{ 
				{ Chance = 20, Template = "lscroll_heal", Unique = true },
				{ Chance = 20, Template = "lscroll_cure", Unique = true },
				{ Chance = 20, Template = "lscroll_poison", Unique = true },
				{ Chance = 20, Template = "lscroll_ruin", Unique = true },
				{ Chance = 20, Template = "lscroll_defence", Unique = true },
				{ Chance = 10, Template = "lscroll_greater_heal", Unique = true },
				{ Chance = 10, Template = "lscroll_lightning", Unique = true },
				{ Chance = 10, Template = "lscroll_bombardment", Unique = true },
				{ Chance = 10, Template = "lscroll_electricbolt", Unique = true },
				{ Chance = 10, Template = "lscroll_attack", Unique = true },
				{ Chance = 10, Template = "lscroll_mark", Unique = true },
			},
		},
		ScrollsHigh = 
		{
			NumItemsMin = 0,
			NumItemsMax = 2,	

			LootItems = 
			{ 
				{ Chance = 20, Template = "lscroll_greater_heal", Unique = true },
				{ Chance = 20, Template = "lscroll_lightning", Unique = true },
				{ Chance = 20, Template = "lscroll_bombardment", Unique = true },
				{ Chance = 20, Template = "lscroll_electricbolt", Unique = true },
				{ Chance = 20, Template = "lscroll_attack", Unique = true },
				{ Chance = 20, Template = "lscroll_mark", Unique = true },
				{ Chance = 10, Template = "lscroll_resurrect", Unique = true },
				{ Chance = 10, Template = "lscroll_earthquake", Unique = true },
				{ Chance = 10, Template = "lscroll_meteor", Unique = true },
				{ Chance = 10, Template = "lscroll_portal", Unique = true },

			},
		},
		Apprentice = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
				{ Chance = 0.5, Template = "weapon_saber", Unique = true },
				{ Chance = 0.5, Template = "weapon_kryss", Unique = true },
				{ Chance = 0.5, Template = "weapon_greataxe", Unique = true },
				{ Chance = 0.5, Template = "weapon_mace", Unique = true },
				{ Chance = 0.5, Template = "weapon_vouge", Unique = true },
				{ Chance = 0.5, Template = "weapon_shortbow", Unique = true },
				{ Chance = 0.5, Template = "shield_buckler", Unique = true },
				{ Chance = 0.5, Template = "armor_brigandine_helm", Unique = true },
				{ Chance = 0.5, Template = "armor_brigandine_tunic", Unique = true },
				{ Chance = 0.5, Template = "armor_brigandine_leggings", Unique = true },
				{ Chance = 0.5, Template = "robe_padded_helm", Unique = true },
				{ Chance = 0.5, Template = "robe_padded_tunic", Unique = true },
				{ Chance = 0.5, Template = "robe_padded_leggings", Unique = true },
				{ Chance = 0.5, Template = "robe_padded_leggings", Unique = true },
				{ Chance = 0.5, Template = "robe_padded_helm", Unique = true },
				{ Chance = 0.5, Template = "robe_padded_tunic", Unique = true },
				{ Chance = 5, Template = "potion_heal", Unique = true },
			},
		},
		RookieGearLow = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
			},
		},
		RookieGearHigh = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
			},
		},
		JourneymanGearLow = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
			},
		},
		JourneymanGearHigh = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
			},
		},
		ExpertGearLow = 
		{
			NumItems = 1,	

			LootItems = 
			{
			},
		},
		ExpertGearHigh = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
			},
		},
		MasterGearLow = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
			},
		},
		MasterGearHigh = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
			},
		},

		DeathResources = 
		{
			NumItemsMin = 3,
			NumItemsMax = 5,

	    	LootItems = {
	    		{ Weight = 10, Template = "animalparts_miasma_deathly", StackCountMin = 5, StackCountMax = 10, Unique = true },
	    		{ Weight = 10, Template = "animalparts_miasma_deathly", StackCountMin = 5, StackCountMax = 10, Unique = true },
	    		{ Weight = 10, Template = "animalparts_miasma_deathly", StackCountMin = 5, StackCountMax = 10, Unique = true },
	    		{ Weight = 10, Template = "animalparts_miasma_deathly", StackCountMin = 5, StackCountMax = 10, Unique = true },
	    		{ Weight = 10, Template = "animalparts_miasma_deathly", StackCountMin = 5, StackCountMax = 10, Unique = true },
    		},
		},

		ClothScrapsLow = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
				{ Chance = 50, Template = "resource_clothscraps", Unique = true, StackCountMin = 1, StackCountMax = 2, },
			},
		},
		ClothScrapsHigh = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
				{ Chance = 50, Template = "resource_clothscraps", Unique = true, StackCountMin = 3, StackCountMax = 5, },
			},
		},
		IronLow = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
				{ Chance = 20, Template = "resource_iron", Unique = true, StackCountMin = 1, StackCountMax = 2, },
			},
		},
		IronHigh = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
				{ Chance = 20, Template = "resource_iron", Unique = true, StackCountMin = 2, StackCountMax = 4, },
			},
		},

		MapsLow = 
		{
			NumItems = 1,	

			LootItems = 
			{
				{ Chance = 2, Template = "treasure_map"},
				{ Chance = 1, Template = "treasure_map_1"},
			},
		},

		Maps = 
		{
			NumItems = 1,	

			LootItems = 
			{
				{ Chance = 2, Template = "treasure_map"},
				{ Chance = 2, Template = "treasure_map_1"},
				{ Chance = 2, Template = "treasure_map_2"},
				{ Chance = 1, Template = "treasure_map_3"},
			},
		},

		MapsHigh = 
		{
			NumItems = 1,	

			LootItems = 
			{
				{ Chance = 2, Template = "treasure_map"},
				{ Chance = 2, Template = "treasure_map_1"},
				{ Chance = 2, Template = "treasure_map_2"},
				{ Chance = 2, Template = "treasure_map_3"},
				{ Chance = 1, Template = "treasure_map_4"},
			},
		},

		MapsBoss = 
		{
			NumItems = 5,	

			LootItems = 
			{
				{ Weight = 10, Template = "treasure_map"},
				{ Weight = 10, Template = "treasure_map_1"},
				{ Weight = 20, Template = "treasure_map_2"},
				{ Weight = 20, Template = "treasure_map_3"},
				{ Weight = 40, Template = "treasure_map_4"},
			},
		},

		ScrollsBoss = 
		{
			NumItems = 1,	

			LootItems = 
			{
				{ Chance = 2, Template = "lscroll_electricbolt", Unique = true },
				{ Chance = 2, Template = "lscroll_walloffire", Unique = true },
				{ Chance = 2, Template = "lscroll_teleport", Unique = true },
				{ Chance = 2, Template = "lscroll_resurrect", Unique = true },
				{ Chance = 2, Template = "lscroll_cloak", Unique = true },
				{ Chance = 2, Template = "lscroll_attack", Unique = true },
				{ Chance = 1, Template = "lscroll_bombardment", Unique = true },
				{ Chance = 1, Template = "lscroll_meteor", Unique = true },
				{ Chance = 1, Template = "lscroll_earthquake", Unique = true },
				{ Chance = 1, Template = "lscroll_portal", Unique = true },
				{ Chance = 2, Template = "lscroll_mark", Unique = true },
			},
		},
		CultistLootEasy = 
		{
			NumItemsMin = 0,
			NumItemsMax = 1,
			LootItems =
			{ 
				{ Weight = 20, Template = "tool_hunting_knife", Unique = true },
				{ Weight = 20, Template = "potion_lheal" },
				{ Weight = 5, Template  = "cultist_note_a" },
				{ Weight = 5, Template  = "cultist_note_b" },
				{ Weight = 5, Template  = "cultist_note_c" },
				{ Weight = 5, Template  = "cultist_note_d" },
				{ Weight = 5, Template  = "cultist_note_e" },
				{ Weight = 5, Template  = "cultist_note_f" },
				{ Weight = 5, Template  = "ancient_map" },
				{ Weight = 1, Template  = "cultist_scripture_a" },
				{ Weight = 1, Template  = "cultist_scripture_b" },
				{ Weight = 1, Template  = "cultist_scripture_c" },
				{ Weight = 1, Template  = "cultist_scripture_d" },
			},
		},
		CultistLootMedium = 
		{
			NumItemsMin = 1,
			NumItemsMax = 2,
			LootItems =
			{ 
				{ Weight = 20, Template = "tool_hunting_knife", Unique = true },
				{ Weight = 20, Template = "potion_lheal" },
				{ Weight = 5, Template  = "cultist_note_a" },
				{ Weight = 5, Template  = "cultist_note_b" },
				{ Weight = 5, Template  = "cultist_note_c" },
				{ Weight = 5, Template  = "cultist_note_d" },
				{ Weight = 5, Template  = "cultist_note_e" },
				{ Weight = 5, Template  = "cultist_note_f" },
				{ Weight = 5, Template  = "ancient_map" },
				{ Weight = 1, Template  = "cultist_scripture_a" },
				{ Weight = 1, Template  = "cultist_scripture_b" },
				{ Weight = 1, Template  = "cultist_scripture_c" },
				{ Weight = 1, Template  = "cultist_scripture_d" },
				{ Weight = 1, Template  = "cultist_scripture_e" },
				{ Weight = 1, Template  = "cultist_scripture_f" },
				{ Weight = 1, Template  = "cultist_scripture_g" },
				{ Weight = 1, Template  = "cultist_scripture_h" },
			},
		},
		CultistLootHard = 
		{
			NumItemsMin = 1,
			NumItemsMax = 3,
			LootItems =
			{ 
				{ Weight = 20, Template = "tool_hunting_knife", Unique = true },
				{ Weight = 20, Template = "potion_lheal" },
				{ Weight = 5, Template  = "cultist_note_a" },
				{ Weight = 5, Template  = "cultist_note_b" },
				{ Weight = 5, Template  = "cultist_note_c" },
				{ Weight = 5, Template  = "cultist_note_d" },
				{ Weight = 5, Template  = "cultist_note_e" },
				{ Weight = 5, Template  = "cultist_note_f" },
				{ Weight = 5, Template  = "ancient_map" },
				{ Weight = 3, Template  = "cultist_scripture_a" },
				{ Weight = 3, Template  = "cultist_scripture_b" },
				{ Weight = 3, Template  = "cultist_scripture_c" },
				{ Weight = 3, Template  = "cultist_scripture_d" },
				{ Weight = 3, Template  = "cultist_scripture_e" },
				{ Weight = 3, Template  = "cultist_scripture_f" },
				{ Weight = 3, Template  = "cultist_scripture_g" },
				{ Weight = 3, Template  = "cultist_scripture_h" },
				{ Weight = 3, Template  = "cultist_scripture_i" },
				{ Weight = 3, Template  = "cultist_scripture_j" },
			},
		},
		MagePoor = 
		{
			NumItemsMin = 1,
			NumItemsMax = 2,	

			LootItems = 
			{ 
				{ Weight = 25, Template = "ingredient_moss", Unique = true, StackCountMin = 1, StackCountMax = 3,},
				{ Weight = 25, Template = "ingredient_lemongrass", Unique = true, StackCountMin = 1, StackCountMax = 3,},
				{ Weight = 25, Template = "ingredient_mushroom", Unique = true, StackCountMin = 1, StackCountMax = 3,},
				{ Weight = 25, Template = "ingredient_ginsengroot", Unique = true, StackCountMin = 1, StackCountMax = 3,},
			},
		},
		MageRich = 
		{
			NumItemsMin = 2,
			NumItemsMax = 3,	

			LootItems = 
			{ 
				{ Weight = 25, Template = "ingredient_moss", Unique = true, StackCountMin = 2, StackCountMax = 5,},
				{ Weight = 25, Template = "ingredient_lemongrass", Unique = true, StackCountMin = 2, StackCountMax = 5,},
				{ Weight = 25, Template = "ingredient_mushroom", Unique = true, StackCountMin = 2, StackCountMax = 5,},
				{ Weight = 25, Template = "ingredient_ginsengroot", Unique = true, StackCountMin = 2, StackCountMax = 5,},
			},
		},
		ArcherPoor = 
		{
			NumItems = 2,	

			LootItems = 
			{ 
				{ Chance = 50, Template = "arrow", Unique = true, StackCountMin = 1, StackCountMax = 10,},
				{ Chance = 2, Template = "weapon_shortbow", Unique = true },
				{ Chance = 2, Template = "weapon_longbow", Unique = true },
			},
		},
		ArcherRich = 
		{
			NumItems = 2,	

			LootItems = 
			{ 
				{ Weight = 50, Template = "arrow", Unique = true, StackCountMin = 10, StackCountMax = 30,},
				{ Chance = 2, Template = "weapon_shortbow", Unique = true },
				{ Chance = 2, Template = "weapon_longbow", Unique = true },
			},
		},
		MageBoss = 
		{
			NumItems = 3,	

			LootItems = 
			{ 
				{ Weight = 25, Template = "ingredient_moss", Unique = true, StackCountMin = 50, StackCountMax = 100,},
				{ Weight = 25, Template = "ingredient_lemongrass", Unique = true, StackCountMin = 50, StackCountMax = 100,},
				{ Weight = 25, Template = "ingredient_mushroom", Unique = true, StackCountMin = 50, StackCountMax = 100,},
				{ Weight = 25, Template = "ingredient_ginsengroot", Unique = true, StackCountMin = 50, StackCountMax = 100,},
			},
		},
		WarriorPoor = 
		{
			NumItems = 2,	

			LootItems = 
			{ 
				{ Chance = 50, Template = "bandage", Unique = true, StackCountMin = 1, StackCountMax = 2, },
				{ Chance = 2, Template = "weapon_dagger", Unique = true },
				{ Chance = 2, Template = "weapon_longsword", Unique = true },
				{ Chance = 2, Template = "weapon_mace", Unique = true },
				{ Chance = 2, Template = "shield_buckler", Unique = true },
				{ Chance = 2, Template = "armor_chain_helm", Unique = true },
				{ Chance = 2, Template = "armor_chain_tunic", Unique = true },
				{ Chance = 2, Template = "armor_chain_leggings", Unique = true },
				{ Chance = 1, Template = "armor_scale_helm", Unique = true },
				{ Chance = 1, Template = "armor_scale_tunic", Unique = true },
				{ Chance = 1, Template = "armor_scale_leggings", Unique = true },
				{ Chance = 0.1, Template = "armor_fullplate_helm", Unique = true },
				{ Chance = 0.1, Template = "armor_fullplate_tunic", Unique = true },
				{ Chance = 0.1, Template = "armor_fullplate_leggings", Unique = true },
			},
		},
		WarriorRich = 
		{
			NumItems = 2,	

			LootItems = 
			{ 
				{ Chance = 50, Template = "bandage", Unique = true, StackCountMin = 1, StackCountMax = 5,},
				{ Chance = 0.5, Template = "weapon_dagger", Unique = true },
				{ Chance = 0.5, Template = "weapon_longsword", Unique = true },
				{ Chance = 0.5, Template = "weapon_mace", Unique = true },
				{ Chance = 0.5, Template = "weapon_shortbow", Unique = true },
				{ Chance = 0.5, Template = "shield_buckler", Unique = true },
				{ Chance = 0.5, Template = "armor_chain_helm", Unique = true },
				{ Chance = 0.5, Template = "armor_chain_tunic", Unique = true },
				{ Chance = 0.5, Template = "armor_chain_leggings", Unique = true },
				{ Chance = 0.3, Template = "armor_scale_helm", Unique = true },
				{ Chance = 0.3, Template = "armor_scale_tunic", Unique = true },
				{ Chance = 0.3, Template = "armor_scale_leggings", Unique = true },
				{ Chance = 0.1, Template = "armor_fullplate_helm", Unique = true },
				{ Chance = 0.1, Template = "armor_fullplate_tunic", Unique = true },
				{ Chance = 0.1, Template = "armor_fullplate_leggings", Unique = true },
			},
		},
		Prestige = 
		{
			NumItems = 1,	
			LootItems = 
			{ 
				{ Chance = 0.5, Template = "prestige_fieldmage_stasis_1", Unique = true },
				{ Chance = 0.5, Template = "prestige_fieldmage_silence_1", Unique = true },
				{ Chance = 0.5, Template = "prestige_fieldmage_empower_1", Unique = true },

				{ Chance = 0.5, Template = "prestige_knight_shieldbash_1", Unique = true },
				{ Chance = 0.5, Template = "prestige_knight_vanguard_1", Unique = true },
				{ Chance = 0.5, Template = "prestige_knight_charge_1", Unique = true },
				
				{ Chance = 0.5, Template = "prestige_scout_stunshot_1", Unique = true },
				{ Chance = 0.5, Template = "prestige_scout_wound_1", Unique = true },
				{ Chance = 0.5, Template = "prestige_scout_huntersmark_1", Unique = true },
				
				{ Chance = 0.5, Template = "prestige_rogue_dart_1", Unique = true },
				{ Chance = 0.5, Template = "prestige_rogue_evasion_1", Unique = true },
				{ Chance = 0.5, Template = "prestige_rogue_vanish_1", Unique = true },

				{ Chance = 0.5, Template = "prestige_sorcerer_spellshield_1", Unique = true },
				{ Chance = 0.5, Template = "prestige_sorcerer_spellchamber_1", Unique = true },
				{ Chance = 0.5, Template = "prestige_sorcerer_destruction_1", Unique = true },

				{ Chance = 0.5, Template = "prestige_gladiator_stunstrike_1", Unique = true },
				{ Chance = 0.5, Template = "prestige_gladiator_hamstring_1", Unique = true },
				{ Chance = 0.5, Template = "prestige_gladiator_cleave_1", Unique = true },
			},
		},
		Poor = 
		{
			NumCoinsMin = 1,
			NumCoinsMax = 25,
		},

		ContemptMob =
		{
			NumItems = 1,	
			LootItems = 
			{ 
				{ Chance = 1, Template = "contempt_skull", Unique = true },
			}
		},
		ContemptBoss =
		{
			NumItems = 1,	
			LootItems = 
			{ 
				{ Weight = 1, Template = "contempt_skull", Unique = true },
			}
		},
		RuinMob =
		{
			NumItems = 1,	
			LootItems = 
			{ 
				{ Chance = 1, Template = "ruin_skull", Unique = true },
			}
		},
		DeceptionMob =
		{
			NumItems = 1,	
			LootItems = 
			{ 
				{ Chance = 1, Template = "deception_skull", Unique = true },
			}
		},
		AwakeningDragon =
		{
			NumItems = 1,	
			LootItems = 
			{ 
				{ Weight = 1, Template = "prestige_rogue_dart_3", Unique = true },
				{ Weight = 1, Template = "prestige_rogue_evasion_3", Unique = true },
				{ Weight = 1, Template = "prestige_knight_charge_3", Unique = true },
				{ Weight = 1, Template = "prestige_knight_heroism_3", Unique = true },
				{ Weight = 1, Template = "prestige_knight_vanguard_3", Unique = true },
				{ Weight = 1, Template = "prestige_knight_shieldbash_3", Unique = true },
				{ Weight = 1, Template = "prestige_scout_stunshot_3", Unique = true },
				{ Weight = 1, Template = "prestige_scout_wound_3", Unique = true },
				{ Weight = 1, Template = "prestige_gladiator_stunstrike_3", Unique = true },
				{ Weight = 1, Template = "prestige_gladiator_hamstring_3", Unique = true },
				{ Weight = 1, Template = "prestige_gladiator_cleave_3", Unique = true },
				{ Weight = 1, Template = "prestige_fieldmage_stasis_3", Unique = true },
				{ Weight = 1, Template = "prestige_fieldmage_silence_3", Unique = true },
				{ Weight = 1, Template = "prestige_fieldmage_empower_3", Unique = true },
				{ Weight = 1, Template = "prestige_sorcerer_destruction_3", Unique = true },
				{ Weight = 1, Template = "prestige_sorcerer_spellchamber_3", Unique = true },
				{ Weight = 1, Template = "prestige_sorcerer_spellshield_3", Unique = true },
				{ Weight = 1, Template = "prestige_scout_huntersmark_3", Unique = true },
				{ Weight = 1, Template = "prestige_rogue_vanish_3", Unique = true },
				{ Weight = 1, Template = "prestige_rogue_evasion_2", Unique = true },
				{ Weight = 1, Template = "prestige_knight_charge_2", Unique = true },
				{ Weight = 1, Template = "prestige_knight_heroism_2", Unique = true },
				{ Weight = 1, Template = "prestige_knight_vanguard_2", Unique = true },
				{ Weight = 1, Template = "prestige_knight_shieldbash_2", Unique = true },
				{ Weight = 1, Template = "prestige_scout_stunshot_2", Unique = true },
				{ Weight = 1, Template = "prestige_scout_wound_2", Unique = true },
				{ Weight = 1, Template = "prestige_gladiator_stunstrike_2", Unique = true },
				{ Weight = 1, Template = "prestige_gladiator_hamstring_2", Unique = true },
				{ Weight = 1, Template = "prestige_gladiator_cleave_2", Unique = true },
				{ Weight = 1, Template = "prestige_fieldmage_stasis_2", Unique = true },
				{ Weight = 1, Template = "prestige_fieldmage_silence_2", Unique = true },
				{ Weight = 1, Template = "prestige_fieldmage_empower_2", Unique = true },
				{ Weight = 1, Template = "prestige_sorcerer_destruction_2", Unique = true },
				{ Weight = 1, Template = "prestige_sorcerer_spellchamber_2", Unique = true },
				{ Weight = 1, Template = "prestige_sorcerer_spellshield_2", Unique = true },
				{ Weight = 1, Template = "prestige_scout_huntersmark_2", Unique = true },
				{ Weight = 1, Template = "prestige_rogue_vanish_2", Unique = true },
				{ Weight = 1, Template = "prestige_rogue_dart_2", Unique = true },
			}
		},
	},

	GridSpawns = 
	{
		UpperPlains = {
			Easy = { 
				{ Count = 25, TemplateId =  "wolf" }, 
				{ Count = 25, TemplateId =  "black_bear" }, 
				{ Count = 30, TemplateId =  "hind" }, 
				{ Count = 20, TemplateId = "chicken" }, 
				{ Count = 10, TemplateId = "bay_horse" }, 
			},
			Medium = {
				{ Count = 20, TemplateId =  "wolf" }, 
				{ Count = 15, TemplateId =  "black_bear" }, 
				{ Count = 20, TemplateId =  "hind" }, 
				{ Count = 15, TemplateId = "fox" },
				{ Count = 10, TemplateId = "bay_horse" }, 
				{ Count = 20, TemplateId = "brown_bear" }, 
				{ Count = 15, TemplateId = "wolf_grey" }, 				
			},
			Hard = {
				{ Count = 5, TemplateId =  "wolf" }, 
				{ Count = 5, TemplateId =  "black_bear" }, 
				{ Count = 5, TemplateId =  "hind" }, 
				{ Count = 10, TemplateId = "chicken" }, 
				{ Count = 10, TemplateId = "bay_horse" }, 
				{ Count = 10, TemplateId = "brown_bear" }, 
				{ Count = 25, TemplateId = "wolf_grey" },
				{ Count = 20, TemplateId = "grizzly_bear" },
				{ Count = 20, TemplateId = "great_hart" },				
			},
		},
		SouthernHills = {
			Easy = { 
				{ Count = 25, TemplateId =  "coyote" }, 
				{ Count = 25, TemplateId =  "black_bear" }, 
				{ Count = 30, TemplateId =  "hind" }, 
				{ Count = 20, TemplateId = "turkey" }, 
				{ Count = 10, TemplateId = "chestnut_horse" }, 

			},
			Medium = {
				{ Count = 20, TemplateId =  "coyote" }, 
				{ Count = 15, TemplateId =  "black_bear" }, 
				{ Count = 20, TemplateId =  "hind" }, 
				{ Count = 10, TemplateId = "turkey" }, 
				{ Count = 10, TemplateId = "chestnut_horse" }, 
				{ Count = 20, TemplateId = "brown_bear" }, 
				{ Count = 15, TemplateId = "wolf_black" }, 
			},
			Hard = {
				{ Count = 5, TemplateId =  "coyote" }, 
				{ Count = 5, TemplateId =  "black_bear" }, 
				{ Count = 5, TemplateId =  "hind" }, 
				{ Count = 10, TemplateId = "turkey" }, 
				{ Count = 10, TemplateId = "chestnut_horse" }, 
				{ Count = 10, TemplateId = "brown_bear" }, 
				{ Count = 25, TemplateId = "wolf_black" },
				{ Count = 20, TemplateId = "grizzly_bear" },
				{ Count = 20, TemplateId = "great_hart" },
			},
		},
		BarrenLands = {
			Easy = { 
				{ Count = 30, TemplateId =  "snake_sand" }, 
				{ Count = 30, TemplateId =  "beetle" }, 
				{ Count = 5, TemplateId =  "wolf_desert" },
			},
		},
		BlackForest = {
			Easy = { 
				{ Count = 30, TemplateId =  "bat" }, 
				{ Count = 30, TemplateId =  "spider" }, 
				{ Count = 5, TemplateId =  "spider_large" },
			},
		},
	},

	MaleHeads =
	{
	{"head_male02",182},
	{"head_male02",176},
	{"head_male02",807},
	{"head_male02",172},
	{"head_male02",809},
	{"head_male02",810},
	{"head_male02",811},
	{"head_male02",817},

	{"head_male03",182},
	{"head_male03",176},
	{"head_male03",807},
	{"head_male03",172},
	{"head_male03",809},
	{"head_male03",810},
	{"head_male03",811},
	{"head_male03",817},

	{"head_male04",182},
	{"head_male04",176},
	{"head_male04",807},
	{"head_male04",172},
	{"head_male04",809},
	{"head_male04",810},
	{"head_male04",811},
	{"head_male04",817},

	{"head_male05",182},
	{"head_male05",176},
	{"head_male05",807},
	{"head_male05",172},
	{"head_male05",809},
	{"head_male05",810},
	{"head_male05",811},
	{"head_male05",817},
	},

	FemaleHeads =
	{
	{"head_female01",182},
	{"head_female01",176},
	{"head_female01",807},
	{"head_female01",172},
	{"head_female01",809},
	{"head_female01",810},
	{"head_female01",811},
	{"head_female01",817},

	{"head_female02",182},
	{"head_female02",176},
	{"head_female02",807},
	{"head_female02",172},
	{"head_female02",809},
	{"head_female02",810},
	{"head_female02",811},
	{"head_female02",817},

	{"head_female03",182},
	{"head_female03",176},
	{"head_female03",807},
	{"head_female03",172},
	{"head_female03",809},
	{"head_female03",810},
	{"head_female03",811},
	{"head_female03",817},

	{"head_female04",182},
	{"head_female04",176},
	{"head_female04",807},
	{"head_female04",172},
	{"head_female04",809},
	{"head_female04",810},
	{"head_female04",811},
	{"head_female04",817},

	{"head_female05",182},
	{"head_female05",176},
	{"head_female05",807},
	{"head_female05",172},
	{"head_female05",809},
	{"head_female05",810},
	{"head_female05",811},
	{"head_female05",817},
	},

	MaleFacialHair = {
		{"",4},
		{"facial_hair_beard_thin",8},
		{"facial_hair_beard",182},
		{"facial_hair_beard_long",176},
		{"facial_hair_beard_longer",807},
		{"facial_hair_beard_chops",172},
		{"facial_hair_beard_chops2",809},
		{"facial_hair_beard_goatee3",810},
		{"facial_hair_beard_goatee2",811},
		{"facial_hair_beard_goatee",817},
		{"facial_hair_beard_mustache",182},
		{"facial_hair_beard_mustache_long",176},
		{"facial_hair_beard_mustache2",807},
	},

	MaleWaywardHeads = {{"head_male04","FF9933"} },
	FemaleWaywardHeads = { {"head_female04","FF9933"}, },

	FoundersDancersMaleHeads = { "head_male02","head_male03","head_male04","head_male05","head_male02","head_male03","head_male04","head_male05","head_male02","head_male03","head_male04","head_male05",
	{"head_male02"},{"head_male03"},{"head_male04"},{"head_male05",},},

	FoundersDancersFemaleHeads = { "head_female01","head_female02","head_female03","head_female04","head_female05","head_female06", "head_female01","head_female02","head_female03","head_female04","head_female05","head_female06",
	{"head_female01"},{"head_female02"},{"head_female03",},{"head_female04"},{"head_female05"},{"head_female01",},},

	MaleWaywardHair = {
		{"hair_male_messy","0xFF191919"},
		{"hair_male_buzzcut","0xFF191919"},
		{"","0xFF191919"},
		{"","0xFF191919"},
	},
	FemaleWaywardHair = {
		{"hair_female_shaggy","0xFF191919"},
	},

	MaleHairSlave = 
	{
	{"hair_male_buzzcut",4},
	{"hair_male_buzzcut",8},
	{"hair_male_buzzcut",768},
	{"hair_male_buzzcut",770},
	{"hair_male_buzzcut",772},
	{"hair_male_buzzcut",781},
	{"hair_male_buzzcut",793},
	{"hair_male_buzzcut",788},
	{"hair_male_buzzcut",789},
	{"hair_male_buzzcut",792},

	{"hair_male",4},
	{"hair_male",8},
	{"hair_male",768},
	{"hair_male",770},
	{"hair_male",772},
	{"hair_male",781},
	{"hair_male",793},
	{"hair_male",788},
	{"hair_male",789},
	{"hair_male",792},

	{"",4},
	{"",8},
	{"",768},
	{"",770},
	{"",772},
	{"",781},
	{"",793},
	{"",788},
	{"",789},
	{"",792},
	},

	MaleHairBeggar = 
	{
	{"hair_male_messy",4},
	{"hair_male_messy",8},
	{"hair_male_messy",768},
	{"hair_male_messy",770},
	{"hair_male_messy",772},
	{"hair_male_messy",781},
	{"hair_male_messy",793},
	{"hair_male_messy",788},
	{"hair_male_messy",789},
	{"hair_male_messy",792},

	{"hair_male",4},
	{"hair_male",8},
	{"hair_male",768},
	{"hair_male",770},
	{"hair_male",772},
	{"hair_male",781},
	{"hair_male",793},
	{"hair_male",788},
	{"hair_male",789},
	{"hair_male",792},

	{"hair_male_windswept",4},
	{"hair_male_windswept",8},
	{"hair_male_windswept",768},
	{"hair_male_windswept",770},
	{"hair_male_windswept",772},
	{"hair_male_windswept",781},
	{"hair_male_windswept",793},
	{"hair_male_windswept",788},
	{"hair_male_windswept",789},
	{"hair_male_windswept",792},
	
	{"",4},
	{"",8},
	{"",768},
	{"",770},
	{"",772},
	{"",781},
	{"",793},
	{"",788},
	{"",789},
	{"",792},
	},

	MaleHairVillage = 
	{
	{"hair_male",4},
	{"hair_male",8},
	{"hair_male",768},
	{"hair_male",770},
	{"hair_male",772},
	{"hair_male",781},
	{"hair_male",793},
	{"hair_male",788},
	{"hair_male",789},
	{"hair_male",792},

	{"hair_male_bangs",4},
	{"hair_male_bangs",8},
	{"hair_male_bangs",768},
	{"hair_male_bangs",770},
	{"hair_male_bangs",772},
	{"hair_male_bangs",781},
	{"hair_male_bangs",793},
	{"hair_male_bangs",788},
	{"hair_male_bangs",789},
	{"hair_male_bangs",792},

	{"hair_male_buzzcut",4},
	{"hair_male_buzzcut",8},
	{"hair_male_buzzcut",768},
	{"hair_male_buzzcut",770},
	{"hair_male_buzzcut",772},
	{"hair_male_buzzcut",781},
	{"hair_male_buzzcut",793},
	{"hair_male_buzzcut",788},
	{"hair_male_buzzcut",789},
	{"hair_male_buzzcut",792},

	{"hair_male_messy",4},
	{"hair_male_messy",8},
	{"hair_male_messy",768},
	{"hair_male_messy",770},
	{"hair_male_messy",772},
	{"hair_male_messy",781},
	{"hair_male_messy",793},
	{"hair_male_messy",788},
	{"hair_male_messy",789},
	{"hair_male_messy",792},

	{"hair_male_nobleman",4},
	{"hair_male_nobleman",8},
	{"hair_male_nobleman",768},
	{"hair_male_nobleman",770},
	{"hair_male_nobleman",772},
	{"hair_male_nobleman",781},
	{"hair_male_nobleman",793},
	{"hair_male_nobleman",788},
	{"hair_male_nobleman",789},
	{"hair_male_nobleman",792},

	{"hair_male_rougish",4},
	{"hair_male_rougish",8},
	{"hair_male_rougish",768},
	{"hair_male_rougish",770},
	{"hair_male_rougish",772},
	{"hair_male_rougish",781},
	{"hair_male_rougish",793},
	{"hair_male_rougish",788},
	{"hair_male_rougish",789},
	{"hair_male_rougish",792},

	{"hair_male_sideundercut",4},
	{"hair_male_sideundercut",8},
	{"hair_male_sideundercut",768},
	{"hair_male_sideundercut",770},
	{"hair_male_sideundercut",772},
	{"hair_male_sideundercut",781},
	{"hair_male_sideundercut",793},
	{"hair_male_sideundercut",788},
	{"hair_male_sideundercut",789},
	{"hair_male_sideundercut",792},

	{"hair_male_undercut",4},
	{"hair_male_undercut",8},
	{"hair_male_undercut",768},
	{"hair_male_undercut",770},
	{"hair_male_undercut",772},
	{"hair_male_undercut",781},
	{"hair_male_undercut",793},
	{"hair_male_undercut",788},
	{"hair_male_undercut",789},
	{"hair_male_undercut",792},

	{"hair_male_windswept",4},
	{"hair_male_windswept",8},
	{"hair_male_windswept",768},
	{"hair_male_windswept",770},
	{"hair_male_windswept",772},
	{"hair_male_windswept",781},
	{"hair_male_windswept",793},
	{"hair_male_windswept",788},
	{"hair_male_windswept",789},
	{"hair_male_windswept",792},

	{"",4},
	{"",8},
	{"",768},
	{"",770},
	{"",772},
	{"",781},
	{"",793},
	{"",788},
	{"",789},
	{"",792},
	
	},	

	FemaleHairSlave = 
	{
	{"hair_female_shaggy",4},
	{"hair_female_shaggy",8},
	{"hair_female_shaggy",768},
	{"hair_female_shaggy",770},
	{"hair_female_shaggy",772},
	{"hair_female_shaggy",781},
	{"hair_female_shaggy",793},
	{"hair_female_shaggy",788},
	{"hair_female_shaggy",789},
	{"hair_female_shaggy",792},

	{"hair_female_buzzcut",4},
	{"hair_female_buzzcut",8},
	{"hair_female_buzzcut",768},
	{"hair_female_buzzcut",770},
	{"hair_female_buzzcut",772},
	{"hair_female_buzzcut",781},
	{"hair_female_buzzcut",793},
	{"hair_female_buzzcut",788},
	{"hair_female_buzzcut",789},
	{"hair_female_buzzcut",792},

	{"hair_cultist_female",4},
	{"hair_cultist_female",8},
	{"hair_cultist_female",768},
	{"hair_cultist_female",770},
	{"hair_cultist_female",772},
	{"hair_cultist_female",781},
	{"hair_cultist_female",793},
	{"hair_cultist_female",788},
	{"hair_cultist_female",789},
	{"hair_cultist_female",792},
	},

	FemaleHairBeggar = 
	{
	{"hair_female_shaggy",4},
	{"hair_female_shaggy",8},
	{"hair_female_shaggy",768},
	{"hair_female_shaggy",770},
	{"hair_female_shaggy",772},
	{"hair_female_shaggy",781},
	{"hair_female_shaggy",793},
	{"hair_female_shaggy",788},
	{"hair_female_shaggy",789},
	{"hair_female_shaggy",792},

	{"hair_female",4},
	{"hair_female",8},
	{"hair_female",768},
	{"hair_female",770},
	{"hair_female",772},
	{"hair_female",781},
	{"hair_female",793},
	{"hair_female",788},
	{"hair_female",789},
	{"hair_female",792},

	{"hair_female_pigtails",4},
	{"hair_female_pigtails",8},
	{"hair_female_pigtails",768},
	{"hair_female_pigtails",770},
	{"hair_female_pigtails",772},
	{"hair_female_pigtails",781},
	{"hair_female_pigtails",793},
	{"hair_female_pigtails",788},
	{"hair_female_pigtails",789},
	{"hair_female_pigtails",792},
	
	{"hair_female_bun",4},
	{"hair_female_bun",8},
	{"hair_female_bun",768},
	{"hair_female_bun",770},
	{"hair_female_bun",772},
	{"hair_female_bun",781},
	{"hair_female_bun",793},
	{"hair_female_bun",788},
	{"hair_female_bun",789},
	{"hair_female_bun",792},
	},

	FemaleHairVillage = 
	{
	{"hair_female",4},
	{"hair_female",8},
	{"hair_female",768},
	{"hair_female",770},
	{"hair_female",772},
	{"hair_female",781},
	{"hair_female",793},
	{"hair_female",788},
	{"hair_female",789},
	{"hair_female",792},

	{"hair_female_pigtails",4},
	{"hair_female_pigtails",8},
	{"hair_female_pigtails",768},
	{"hair_female_pigtails",770},
	{"hair_female_pigtails",772},
	{"hair_female_pigtails",781},
	{"hair_female_pigtails",793},
	{"hair_female_pigtails",788},
	{"hair_female_pigtails",789},
	{"hair_female_pigtails",792},

	{"hair_female_bob",4},
	{"hair_female_bob",8},
	{"hair_female_bob",768},
	{"hair_female_bob",770},
	{"hair_female_bob",772},
	{"hair_female_bob",781},
	{"hair_female_bob",793},
	{"hair_female_bob",788},
	{"hair_female_bob",789},
	{"hair_female_bob",792},

	{"hair_female_bun",4},
	{"hair_female_bun",8},
	{"hair_female_bun",768},
	{"hair_female_bun",770},
	{"hair_female_bun",772},
	{"hair_female_bun",781},
	{"hair_female_bun",793},
	{"hair_female_bun",788},
	{"hair_female_bun",789},
	{"hair_female_bun",792},

	{"hair_female_ponytail",4},
	{"hair_female_ponytail",8},
	{"hair_female_ponytail",768},
	{"hair_female_ponytail",770},
	{"hair_female_ponytail",772},
	{"hair_female_ponytail",781},
	{"hair_female_ponytail",793},
	{"hair_female_ponytail",788},
	{"hair_female_ponytail",789},
	{"hair_female_ponytail",792},

	{"hair_female_shaggy",4},
	{"hair_female_shaggy",8},
	{"hair_female_shaggy",768},
	{"hair_female_shaggy",770},
	{"hair_female_shaggy",772},
	{"hair_female_shaggy",781},
	{"hair_female_shaggy",793},
	{"hair_female_shaggy",788},
	{"hair_female_shaggy",789},
	{"hair_female_shaggy",792},
	},	

	FemaleHairFounders = 
	{
	{"hair_female",4},
	{"hair_female",8},
	{"hair_female",768},
	{"hair_female",770},
	{"hair_female",772},
	{"hair_female",781},
	{"hair_female",793},
	{"hair_female",788},
	{"hair_female",789},
	{"hair_female",792},

	{"hair_female_pigtails",4},
	{"hair_female_pigtails",8},
	{"hair_female_pigtails",768},
	{"hair_female_pigtails",770},
	{"hair_female_pigtails",772},
	{"hair_female_pigtails",781},
	{"hair_female_pigtails",793},
	{"hair_female_pigtails",788},
	{"hair_female_pigtails",789},
	{"hair_female_pigtails",792},

	{"hair_female_bob",4},
	{"hair_female_bob",8},
	{"hair_female_bob",768},
	{"hair_female_bob",770},
	{"hair_female_bob",772},
	{"hair_female_bob",781},
	{"hair_female_bob",793},
	{"hair_female_bob",788},
	{"hair_female_bob",789},
	{"hair_female_bob",792},

	{"hair_female_bun",4},
	{"hair_female_bun",8},
	{"hair_female_bun",768},
	{"hair_female_bun",770},
	{"hair_female_bun",772},
	{"hair_female_bun",781},
	{"hair_female_bun",793},
	{"hair_female_bun",788},
	{"hair_female_bun",789},
	{"hair_female_bun",792},

	{"hair_female_ponytail",4},
	{"hair_female_ponytail",8},
	{"hair_female_ponytail",768},
	{"hair_female_ponytail",770},
	{"hair_female_ponytail",772},
	{"hair_female_ponytail",781},
	{"hair_female_ponytail",793},
	{"hair_female_ponytail",788},
	{"hair_female_ponytail",789},
	{"hair_female_ponytail",792},

	{"hair_female_shaggy",4},
	{"hair_female_shaggy",8},
	{"hair_female_shaggy",768},
	{"hair_female_shaggy",770},
	{"hair_female_shaggy",772},
	{"hair_female_shaggy",781},
	{"hair_female_shaggy",793},
	{"hair_female_shaggy",788},
	{"hair_female_shaggy",789},
	{"hair_female_shaggy",792},
	},	

	MaleHairFounders = 
	{
	{"hair_male",4},
	{"hair_male",8},
	{"hair_male",768},
	{"hair_male",770},
	{"hair_male",772},
	{"hair_male",781},
	{"hair_male",793},
	{"hair_male",788},
	{"hair_male",789},
	{"hair_male",792},

	{"hair_male_bangs",4},
	{"hair_male_bangs",8},
	{"hair_male_bangs",768},
	{"hair_male_bangs",770},
	{"hair_male_bangs",772},
	{"hair_male_bangs",781},
	{"hair_male_bangs",793},
	{"hair_male_bangs",788},
	{"hair_male_bangs",789},
	{"hair_male_bangs",792},

	{"hair_male_buzzcut",4},
	{"hair_male_buzzcut",8},
	{"hair_male_buzzcut",768},
	{"hair_male_buzzcut",770},
	{"hair_male_buzzcut",772},
	{"hair_male_buzzcut",781},
	{"hair_male_buzzcut",793},
	{"hair_male_buzzcut",788},
	{"hair_male_buzzcut",789},
	{"hair_male_buzzcut",792},

	{"hair_male_messy",4},
	{"hair_male_messy",8},
	{"hair_male_messy",768},
	{"hair_male_messy",770},
	{"hair_male_messy",772},
	{"hair_male_messy",781},
	{"hair_male_messy",793},
	{"hair_male_messy",788},
	{"hair_male_messy",789},
	{"hair_male_messy",792},

	{"hair_male_nobleman",4},
	{"hair_male_nobleman",8},
	{"hair_male_nobleman",768},
	{"hair_male_nobleman",770},
	{"hair_male_nobleman",772},
	{"hair_male_nobleman",781},
	{"hair_male_nobleman",793},
	{"hair_male_nobleman",788},
	{"hair_male_nobleman",789},
	{"hair_male_nobleman",792},

	{"hair_male_rougish",4},
	{"hair_male_rougish",8},
	{"hair_male_rougish",768},
	{"hair_male_rougish",770},
	{"hair_male_rougish",772},
	{"hair_male_rougish",781},
	{"hair_male_rougish",793},
	{"hair_male_rougish",788},
	{"hair_male_rougish",789},
	{"hair_male_rougish",792},

	{"hair_male_sideundercut",4},
	{"hair_male_sideundercut",8},
	{"hair_male_sideundercut",768},
	{"hair_male_sideundercut",770},
	{"hair_male_sideundercut",772},
	{"hair_male_sideundercut",781},
	{"hair_male_sideundercut",793},
	{"hair_male_sideundercut",788},
	{"hair_male_sideundercut",789},
	{"hair_male_sideundercut",792},

	{"hair_male_undercut",4},
	{"hair_male_undercut",8},
	{"hair_male_undercut",768},
	{"hair_male_undercut",770},
	{"hair_male_undercut",772},
	{"hair_male_undercut",781},
	{"hair_male_undercut",793},
	{"hair_male_undercut",788},
	{"hair_male_undercut",789},
	{"hair_male_undercut",792},

	{"hair_male_windswept",4},
	{"hair_male_windswept",8},
	{"hair_male_windswept",768},
	{"hair_male_windswept",770},
	{"hair_male_windswept",772},
	{"hair_male_windswept",781},
	{"hair_male_windswept",793},
	{"hair_male_windswept",788},
	{"hair_male_windswept",789},
	{"hair_male_windswept",792},

	{"",4},
	{"",8},
	{"",768},
	{"",770},
	{"",772},
	{"",781},
	{"",793},
	{"",788},
	{"",789},
	{"",792},
	
	},	
	FoundersChests =  { {"founders_chest_base","0xFFFFFF00"},
						{"founders_chest_base","0xFFFF00FF"},
						{"founders_chest_base","0xFF00FFFF"},
						{"founders_chest_base","0xFFFF0000"},
						{"founders_chest_base","0xFF00FF00"},
						{"founders_chest_base","0xFF0000FF"}, 
						{"founders_chest2_base","0xFFFFFF00"},
						{"founders_chest2_base","0xFFFF00FF"},
						{"founders_chest2_base","0xFF00FFFF"},
						{"founders_chest2_base","0xFFFF0000"},
						{"founders_chest2_base","0xFF00FF00"},
						{"founders_chest2_base","0xFF0000FF"},
					    {"founders_chest3_base","0xFFFFFF00"},
					    {"founders_chest3_base","0xFFFF00FF"},
					    {"founders_chest3_base","0xFF00FFFF"},
					    {"founders_chest3_base","0xFFFF0000"},
					    {"founders_chest3_base","0xFF00FF00"},
					    {"founders_chest3_base","0xFF0000FF"},},

	FoundersLegs =  { 	{"founders_legs_base","0xFFFFFF00"},
						{"founders_legs_base","0xFFFF00FF"},
						{"founders_legs_base","0xFF00FFFF"},
						{"founders_legs_base","0xFFFF0000"},
						{"founders_legs_base","0xFF00FF00"},
						{"founders_legs_base","0xFF0000FF"},
						{"founders_legs2_base","0xFFFFFF00"},
						{"founders_legs2_base","0xFFFF00FF"},
						{"founders_legs2_base","0xFF00FFFF"},
						{"founders_legs2_base","0xFFFF0000"},
						{"founders_legs2_base","0xFF00FF00"},
						{"founders_legs2_base","0xFF0000FF"},
					    {"founders_legs3_base","0xFFFFFF00"},
					    {"founders_legs3_base","0xFFFF00FF"},
					    {"founders_legs3_base","0xFF00FFFF"},
					    {"founders_legs3_base","0xFFFF0000"},
					    {"founders_legs3_base","0xFF00FF00"},
					    {"founders_legs3_base","0xFF0000FF"}, },

	ShortNames = {"Uadi","Thraz","Inall","Veat","Honst","Noom","Otasa",
					"Enysa","Urody","Irv","Blard","Eelde","Torn",
					"Amora","Hourd","Kalrr","Etr","Kas","Oldk","Igary",
					"Cric","Schir","Morgh","Eato","Garlt","Yero","Itb",
					"Essr","Oesta","Ieta","Eono","Irl","Troum","Drack",
					"Elmrr","Kals","Drald","Onyu","Dral","Urake","Ymose",
					"Ghaf","Enc","Oeme","Yalei","Oaleo","Utia","Roip",
					"Ingsh","Oesty","Nos","Chroh","Endd","Emss","Yacky",
					"Dret","Lerd","Vof","Itai","Aentha","Morz","Irany",
					"Tiash","Abele","Epolo","Kon","Skelnd","Onale","Lak",
					"Neyl","Iusta","Than","Uomu","Neiy","Athnn","Enll",
					"Risck","Yskeli","Ashp","Utury","Tinq","Yquay","Deys",
					"Orada","Yessi","Eaugho","Taih","Voel","Mort","Veur",
					"Yhata","Ihiny","Alee","Ieno","Itr","Therr","Ytaio",
					"Queck","Nysz","Denn","Belf","Alend","Overy","Rich",
					"Ryng","Swaeck","Abelo","Iemi","Yomi","Etaie","Quel",
					"Soirt","Yuski","Chriat","Oosa","Cerph","Orilo"},

	MinerNames = {"Uadi the Miner","Thraz the Miner","Inall the Miner","Veat the Miner","Honst the Miner","Noom the Miner","Otasa the Miner",
					"Enysa the Miner","Urody the Miner","Irv the Miner","Blard the Miner","Eelde the Miner","Torn the Miner",
					"Amora the Miner","Hourd the Miner","Kalrr the Miner","Etr the Miner","Kas the Miner","Oldk the Miner","Igary the Miner",
					"Cric the Miner","Schir the Miner","Morgh the Miner","Eato the Miner","Garlt the Miner","Yero the Miner","Itb the Miner",
					"Essr the Miner","Oesta the Miner","Ieta the Miner","Eono the Miner","Irl the Miner","Troum the Miner","Drack the Miner",
					"Elmrr the Miner","Kals the Miner","Drald the Miner","Onyu the Miner","Dral the Miner","Urake the Miner","Ymose the Miner",
					"Ghaf the Miner","Enc the Miner","Oeme the Miner","Yalei the Miner","Oaleo the Miner","Utia the Miner","Roip the Miner",
					"Ingsh the Miner","Oesty the Miner","Nos the Miner","Chroh the Miner","Endd the Miner","Emss the Miner","Yacky the Miner",
					"Dret the Miner","Lerd the Miner","Vof the Miner","Itai the Miner","Aentha the Miner","Morz the Miner","Irany the Miner",
					"Tiash the Miner","Abele the Miner","Epolo the Miner","Kon the Miner","Skelnd the Miner","Onale the Miner","Lak the Miner",
					"Neyl the Miner","Iusta the Miner","Than the Miner","Uomu the Miner","Neiy the Miner","Athnn the Miner","Enll the Miner",
					"Risck the Miner","Yskeli the Miner","Ashp the Miner","Utury the Miner","Tinq the Miner","Yquay the Miner","Deys the Miner",
					"Orada the Miner","Yessi the Miner","Eaugho the Miner","Taih the Miner","Voel the Miner","Mort the Miner","Veur the Miner",
					"Yhata the Miner","Ihiny the Miner","Alee the Miner","Ieno the Miner","Itr the Miner","Therr the Miner","Ytaio the Miner",
					"Queck the Miner","Nysz the Miner","Denn the Miner","Belf the Miner","Alend the Miner","Overy the Miner","Rich the Miner",
					"Ryng the Miner","Swaeck the Miner","Abelo the Miner","Iemi the Miner","Yomi the Miner","Etaie the Miner","Quel the Miner",
					"Soirt the Miner","Yuski the Miner","Chriat the Miner","Oosa the Miner","Cerph the Miner","Orilo the Miner"},

	MaleNpcNames = {"Abaet","Abarden","Acamen","Achard","Adeen","Aerden","Aghon","Agnar","Ahburn","Ahdun","Airen","Airis","Aldaren","Alderman","Alkirk","Allso","Amitel","Anfar","Anumil","Asden","Asen","Aslan","Atgur","Atlin","Auden","Ault","Aysen","Bacohl","Badeek","Balati","Baradeer","Basden","Bayde","Bedic","Beeron","Beson","Besur","Bewul","Biedgar","Biston","Bithon","Boaldelr","Bolrock","Breanon","Bredere","Bredock","Breen","Bristan","Buchmeid","Busma","Buthomar","Caelholdt","Cainon","Camchak","Camilde","Casden","Cayold","Celorn","Celthric","Cerdern","Cespar","Cevelt","Chamon","Chidak","Cibrock","Ciroc","Codern","Connell","Cordale","Cosdeer","Cuparun","Cydare","Cylmar","Cyton","Daburn","Daermod","Dakamon","Dakkone","Dalmarn","Dapvhir","Darkkon","Darko","Darmor","Darpick","Dask","Deathmar","Derik","Derrin","Dessfar","Dinfar","Doceon","Dochrohan","Dorn","Dosoman","Drakone","Drandon","Dritz","Drophar","Dryn","Duba","Duran","Durmark","Dyfar","Dyten","Eard","Eckard","Efar","Egmardern","Ekgamut","Eli","Elson","Elthin","Endor","Enidin","Enro","Erikarn","Eritai","Escariet","Etar","Etburn","Ethen","Etmere","Eythil","Faoturk","Faowind","Fenrirr","Fetmar","Ficadon","Fickfylo","Firedorn","Firiro","Folmard","Fraderk","Fydar","Fyn","Gafolern","Gai","Galiron","Gametris","Gemardt","Gemedern","Gerirr","Geth","Gibolock","Gibolt","Gom","Gosford","Gothikar","Gresforn","Gryn","Gundir","Guthale","Gybol","Gyin","Halmar","Harrenhal","Hectar","Hecton","Hermenze","Hermuck","Hildale","Hildar","Hydale","Hyten","Iarmod","Idon","Ieserk","Ikar","Illilorn","Illium","Ipedorn","Irefist","Isen","Isil","Jackson","Jalil","Janus","Jayco","Jesco","Jespar","Jex","Jib","Jin","Juktar","Jun","Justal","Kafar","Kaldar","Keran","Kesad","Kethren","Kib","Kiden","Kilbas","Kildarien","Kimdar","Kip","Kirder","Kolmorn","Kyrad","Lackus","Lacspor","Lafornon","Lahorn","Ledale","Leit","Lephidiles","Lerin","Letor","Lidorn","Liphanes","Loban","Ludokrin","Luphildern","Lurd","Macon","Madarlon","Marderdeen","Mardin","Markdoon","Marklin","Mathar","Medarin","Mellamo","Meowol","Meridan","Merkesh","Mes'ard","Mesophan","Mezo","Michael","Mickal","Migorn","Miphates","Mi'talrythin","Modric","Modum","Mufar","Mujarin","Mythik","Mythil","Nadeer","Nalfar","Naphates","Neowyld","Nikpal","Nikrolin","Niro","Noford","Nuthor","Nuwolf","Nythil","O’tho","Ocarin","Occhi","Odaren","Ohethlic","Okar","Omarn","Orin","Othelen","Oxbaren","Padan","Palid","Peitar","Pelphides","Pendus","Perder","Phairdon","Phemedes","Phoenix","Picon","Picumar","Pildoor","Ponith","Poran","Prothalon","Puthor","Qeisan","Qidan","Quid","Quiss","Qysan","Radag'mal","Randar","Rayth","Reaper","Reth","Rethik","Rhithin","Rhysling","Rikar","Rismak","Ritic","Rogeir","Rogoth","Rophan","Rydan","Ryfar","Ryodan","Rysdan","Rythern","Sabal","Sadareen","Samon","Samot","Scoth","Scythe","Sed","Sedar","Senthyril","Serin","Seryth","Sesmidat","Setlo","Shade","Shane","Shard","Shillen","Silco","Sil'forrin","Silpal","Soderman","Sothale","Stenwulf","Steven","Suth","Sutlin","Syth","Sythril","Talberon","Telpur","Temilfist","Tempist","Tespar","Tessino","Thiltran","Tholan","Tibolt","Ticharol","Tithan","Tobale","Tol’","Tolle","Tolsar","Tothale","Tousba","Tuk","Tuscanar","Tyden","Uerthe","Ugmar","Undin","Updar","Vaccon","Vacone","Valynard","Vectomon","Vespar","Vethelot","Vider","Vigoth","Vildar","Vinald","Virde","Voltain","Voudim","Vythethi","Wak’dern","Walkar","Wekmar","Werymn","William","Willican","Wiltmar","Wishane","Wrathran","Wraythe","Wyder","Wyeth","Xander","Xavier","Xex","Xithyl","Y’reth","Yabaro","Yesirn","Yssik","Zak","Zakarn","Zeke","Zerin","Zidar","Zigmal","Zilocke","Zio","Zotar","Zutar","Zyten"},
	FemaleNpcNames = {"Acele","Acholate","Ada","Adiannon","Adorra","Ahanna","Akara","Akassa","Akia","Amaerilde","Amara","Amarisa","Amarizi","Ana","Andonna","Ani","Annalyn","Archane","Ariannona","Arina","Arryn","Asada","Awnia","Ayne","Basete","Bathelie","Bethe","Brana","Brianan","Bridonna","Brynhilde","Calene","Calina","Celestine","Celoa","Cephenrene","Chani","Chivahle","Chrystyne","Corda","Cyelena","Dalavesta","Desini","Dylena","Ebatryne","Ecematare","Efari","Enaldie","Enoka","Enoona","Errinaya","Fayne","Frederika","Frida","Gene","Gessane","Gronalyn","Gvene","Gwethana","Halete","Helenia","Hildandi","Hyza","Idona","Ikini","Ilene","Illia","Iona","Jessika","Jezzine","Justalyne","Kassina","Kilayox","Kilia","Kilyne","Kressara","Laela","Laenaya","Lelani","Lenala","Linovahle","Linyah","Lloyanda","Lolinda","Lyna","Lynessa","Mehande","Melisande","Midiga","Mirayam","Mylene","Nachaloa","Naria","Narisa","Nelenna","Niraya","Nymira","Ochala","Olivia","Onathe","Ondola","Orwyne","Parthinia","Pascheine","Pela","Peri’el","Pharysene","Philadona","Prisane","Prysala","Pythe","Q’ara","Q’pala","Quasee","Rhyanon","Rivatha","Ryiah","Sanala","Sathe","Senira","Sennetta","Sepherene","Serane","Sevestra","Sidara","Sidathe","Sina","Sunete","Synestra","Sythini","Szene","Tabika","Tabithi","Tajule","Tamare","Teresse","Tolida","Tonica","Treka","Tressa","Trinsa","Tryane","Tybressa","Tycane","Tysinni","Undaria","Uneste","Urda","Usara","Useli","Ussesa","Venessa","Veseere","Voladea","Vysarane","Vythica","Wanera","Welisarne","Wellisa","Wesolyne","Wyeta","Yilvoxe","Ysane","Yve","Yviene","Yvonnette","Yysara","Zana","Zathe","Zecele","Zenobia","Zephale","Zephere","Zerma","Zestia","Zilka","Zoura","Zrye","Zyneste","Zynoa"},
	MalePlayerNames = {"Austin","Dan","Supreem","DukeGorilla","TonyTheHutt","Drayak","Zarcul","Troop LoD","dbltnk LoD","Ezekiel","Jairone","Obs LoD","BannerKC LOD","veeego","BlackLung LoD","Harry LoD","Dung Fist","Shibby","Rumble","Darknight","Foghladha","AlexSage","Tombles","Netnet","bensku","Gundehar","ColdMarrow","Auren Stark","Balkazarno","Rainman LoD","Lavos","Grimskab","Nexid","Mark Trail","IceCrow","Austin","Toad","Ursoc","Sarl","Freerk","TheFreshness","SkullLoD","SteelReign","Wayist","Freq","Bhais","sklurb","Jitsu","Laufer LoD","Tabarnak LoD","Starfire3D","Oliver","Theos","Nitroman","Kal","robl","Gunga Din","Conbro","Dargron","Mystikal","FLIPSKU","Zeph","Min","Sir Bob","Helis","Deathreign","TonyTheHutt","Fror","Harald Blackfist","Noobzilla","Corvyn","Crucible","Howler","BaGz","RaVaGe","tryerino","splixx","Dargron2","Zerdoza","mindseye","Sekkerhund","Soth","Gone","Schwarze Schaf","Mengbilar","Alpha","Lavender","Zerdozer","Slaughterjoe","Codex","Ravenclaw","Papi","Zaxion","Liberty","Raith","Dax","Chargul","Amero","Grim","Macros","Deimos","Majister","Vanak","Alien","Rada Lorkaaz","Tony","Yorlik","Brage","adbos","Zerojr","Behanglul","Lagardere","Poukah","Otto Sandrock","TEEM","SatelliteMind","Idontknow","Jazard","Myrkrid Ashen","Ursoc","Ugliness","Amishphenom","Ragestar","Ainz","Brave SirRobin","hierba","Lore","Ranghar","Indeed","Rinnsu","Hawkfire","Dago","Shadowpain","Shadowhunt","Hugo","Rorick","Gurney","Odin","Knuddenstore","Runesabre","Tabulazero","Hawkfyre II","Cassyr Dubois","Lufari","Photosozo","Finvega","Caerbanog","Fletch","Asmorex","Coins","Schattig","Tofu","JooGar","Caerbanog VanRurik","Zabalus","Abimor","Cookie","CookieTM","Kaid","Raja","Dunkelzwerg","Aokis","Verdorben","Xerxes ","Hilip","Chester","Kerbox","Hexplate","Ness199X","SquashSash","squid","Newbatonium","Slik","Magnus","deatrider","Enarial","Betarays","Yoofaloof","blasteron","Turk Shakespeare","Tintagil","Node","Jtoriko","Fortisq","aada","Lordy","HKPackee","Sunkara","Eden","Mayushi","Phearnun","Drexy","Solaris","Cammoo","Supercub013","Hessian","Rooster Castille","Misneach","Samuel","ReigekiKai","Kush Monstar","Certhas","Matt","Drydenn","Arconious","Nazrudin","Tharalik","Gnerix","Asmodai","Velit","Belador","Maganis","NiTe","aumua","Kourgath","Calheb","Deege","Raldor Santoro","Taelyn","Tokee","Exiled","Huart","Apronks","Icky","Lenart","Bidimus","Ekul","Auxilium","Dwyane Wade","Stucky","Sparda","Merif","Highfather","Kysper","migdr","Lester","Alipheese","TheChester","Nazrudin","Padag","Jasc Onine","Rapolda","Girion Telchar","Dirlettia","Parallaxe","Ecksesive","Sunroc","Trok","Cear Dragon","Gand","vidocq","Siodacain","Genoce","Koen","Arkii","Auzze","DocSteal","Eidenuul","Kintaro","Rylok","Splinter","Gnar","Tynian","Lauro","Drake","Sheltem","Trabbie","Ajax","Brauhm","Voldemort","Abaddon","Tarvok","Sebi Vayah","Whiskeypops","Graycloud","Nalahir","Raven","Kaelem","Colge","Tetravus","Miaobao","Gaston","Gondalf" },
	FemalePlayerNames = {"Kerrigan","Adida","Karma LoD","Danue Sunrider","verve","Achira","Adaline","Amarlia","Amoren","Meldor","Elinari","Selrina","Isha","Prana","Emy","Dixen","squid friend","Jebra","Anzha","Humblemisty","Cyliena","Hermannie","Sea","Ceres","viv","Sanja","Kanyin","Kitty","Eiahn","Miroquin","Tala","Swizzle","Culaan","Marean Lumia","Heather","Celinda Sheridan","JolaughnLLTS","Avanah","Netherwynn","Sylanavan","Aurelia","catsparkle","Felina Covenant","NickyB","Ahina","SilverSong","Sumsare","Hussy","Ali","Seylara Vigdisdottir","Brigitte"},
}