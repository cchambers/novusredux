TemplateDefines = {
	-- DAB COMBAT CHANGES: UPDATE OR REMOVE THESE DEFINES

	LootTable = 
	{
		Humanoid = 
		{
			NumItemsMin = 0,
			NumItemsMax = 2,
	    	LootItems = {
    			{ Chance = 5, Template = "torch", Unique = true },
    			{ Chance = 5, Template = "tool_hunting_knife", Unique = true },
    			{ Chance = 2, Template = "item_apple", Unique = true },
    			{ Chance = 2, Template = "item_bread", Unique = true },
    			{ Chance = 1, Template = "item_ale", Unique = true },
    			{ Chance = 5, Template = "potion_lmana", Unique = true },
    			{ Chance = 5, Template = "potion_lstamina", Unique = true },
    			{ Chance = 5, Template = "potion_lheal", Unique = true },
    			{ Chance = 25, Template = "potion_cure", Unique = true },
    			{ Chance = 5, Template = "tool_cookingpot", Unique = true },
    			{ Chance = 5, Template = "tool_hatchet", Unique = true },
    			{ Chance = 5, Template = "tool_mining_pick", Unique = true },
    			{ Chance = 5, Template = "tool_fishing_rod", Unique = true },
    		},
		},

		PotionsPoor = 
		{
			NumItems = 1,
	    	LootItems = {
    			{ Chance = 2, Template = "potion_lmana", Unique = true },
    			{ Chance = 2, Template = "potion_lstamina", Unique = true },
    			{ Chance = 2, Template = "potion_lheal", Unique = true },
    			{ Chance = 2, Template = "potion_cure", Unique = true },
    		},
		},

		Potions = 
		{
			NumItems = 1,
	    	LootItems = {
    			{ Chance = 2, Template = "potion_mana", Unique = true },
    			{ Chance = 2, Template = "potion_stamina", Unique = true },
    			{ Chance = 2, Template = "potion_heal", Unique = true },
    			{ Chance = 2, Template = "potion_cure", Unique = true },
    		},
		},

		PotionsRich = 
		{
			NumItems = 1,
	    	LootItems = {
    			{ Chance = 3, Template = "potion_mana", Unique = true },
    			{ Chance = 3, Template = "potion_stamina", Unique = true },
    			{ Chance = 3, Template = "potion_heal", Unique = true },
    			{ Chance = 3, Template = "potion_cure", Unique = true },
    		},
		},

		Poor = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
				{ Chance = 5, Template = "necklace_ruby_flawed", Unique = true },
    			{ Chance = 5, Template = "necklace_sapphire_flawed", Unique = true },
    			{ Chance = 5, Template = "necklace_topaz_flawed", Unique = true },
    			{ Chance = 5, Template = "ring_sapphire_flawed", Unique = true },
    			{ Chance = 5, Template = "ring_ruby_flawed", Unique = true },
    			{ Chance = 5, Template = "ring_topaz_flawed", Unique = true },
			},
		},

		Average = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
				{ Chance = 25, Template = "random_executioner_weapon_0_60", Unique = true},

				{ Chance = 5, Template = "necklace_ruby_flawed", Unique = true },
    			{ Chance = 5, Template = "necklace_sapphire_flawed", Unique = true },
    			{ Chance = 5, Template = "necklace_topaz_flawed", Unique = true },
    			{ Chance = 5, Template = "ring_sapphire_flawed", Unique = true },
    			{ Chance = 5, Template = "ring_ruby_flawed", Unique = true },
    			{ Chance = 5, Template = "ring_topaz_flawed", Unique = true },

    			{ Chance = 25, Template = "necklace_ruby_imperfect", Unique = true },
    			{ Chance = 25, Template = "necklace_sapphire_imperfect", Unique = true },
    			{ Chance = 25, Template = "necklace_topaz_imperfect", Unique = true },
    			{ Chance = 25, Template = "ring_sapphire_imperfect", Unique = true },
    			{ Chance = 25, Template = "ring_ruby_imperfect", Unique = true },
    			{ Chance = 25, Template = "ring_topaz_imperfect", Unique = true },
			},
		},

		Rich = 
		{
			NumItems = 1,		

			LootItems = 
			{ 

				{ Chance = 25, Template = "random_executioner_weapon_20_80", Unique = true},

				{ Chance = 25, Template = "necklace_ruby_flawed", Unique = true },
    			{ Chance = 25, Template = "necklace_sapphire_flawed", Unique = true },
    			{ Chance = 25, Template = "necklace_topaz_flawed", Unique = true },
    			{ Chance = 25, Template = "ring_sapphire_flawed", Unique = true },
    			{ Chance = 25, Template = "ring_ruby_flawed", Unique = true },
    			{ Chance = 25, Template = "ring_topaz_flawed", Unique = true },

    			{ Chance = 5, Template = "necklace_ruby_imperfect", Unique = true },
    			{ Chance = 5, Template = "necklace_sapphire_imperfect", Unique = true },
    			{ Chance = 5, Template = "necklace_topaz_imperfect", Unique = true },
    			{ Chance = 5, Template = "ring_sapphire_imperfect", Unique = true },
    			{ Chance = 5, Template = "ring_ruby_imperfect", Unique = true },
    			{ Chance = 5, Template = "ring_topaz_imperfect", Unique = true },
			},
		},

		FilthyRich = 
		{
			NumItems = 1,

			LootItems = 
			{ 
				{ Chance = 25, Template = "random_executioner_weapon_50_100", Unique = true},
				
				{ Chance = 25, Template = "necklace_ruby_flawed", Unique = true },
    			{ Chance = 25, Template = "necklace_sapphire_flawed", Unique = true },
    			{ Chance = 25, Template = "necklace_topaz_flawed", Unique = true },
    			{ Chance = 25, Template = "ring_sapphire_flawed", Unique = true },
    			{ Chance = 25, Template = "ring_ruby_flawed", Unique = true },
    			{ Chance = 25, Template = "ring_topaz_flawed", Unique = true },

    			{ Chance = 5, Template = "necklace_ruby_imperfect", Unique = true },
    			{ Chance = 5, Template = "necklace_sapphire_imperfect", Unique = true },
    			{ Chance = 5, Template = "necklace_topaz_imperfect", Unique = true },
    			{ Chance = 5, Template = "ring_sapphire_imperfect", Unique = true },
    			{ Chance = 5, Template = "ring_ruby_imperfect", Unique = true },
    			{ Chance = 5, Template = "ring_topaz_imperfect", Unique = true },

    			{ Chance = 15, Template = "necklace_ruby_perfect", Unique = true },
    			{ Chance = 15, Template = "necklace_sapphire_perfect", Unique = true },
    			{ Chance = 15, Template = "necklace_topaz_perfect", Unique = true },
    			{ Chance = 15, Template = "ring_sapphire_perfect", Unique = true },
    			{ Chance = 15, Template = "ring_ruby_perfect", Unique = true },
    			{ Chance = 15, Template = "ring_topaz_perfect", Unique = true },
			},
		},

		Boss = 
		{
			NumItems = 5,
					
			LootItems = 
			{ 
				{ Chance = 50, Template = "random_executioner_weapon_80_100", Unique = true},

				{ Chance = 25, Template = "necklace_ruby_flawed", Unique = true },
    			{ Chance = 25, Template = "necklace_sapphire_flawed", Unique = true },
    			{ Chance = 25, Template = "necklace_topaz_flawed", Unique = true },
    			{ Chance = 25, Template = "ring_sapphire_flawed", Unique = true },
    			{ Chance = 25, Template = "ring_ruby_flawed", Unique = true },
    			{ Chance = 25, Template = "ring_topaz_flawed", Unique = true },

    			{ Chance = 25, Template = "necklace_ruby_imperfect", Unique = true },
    			{ Chance = 25, Template = "necklace_sapphire_imperfect", Unique = true },
    			{ Chance = 25, Template = "necklace_topaz_imperfect", Unique = true },
    			{ Chance = 25, Template = "ring_sapphire_imperfect", Unique = true },
    			{ Chance = 25, Template = "ring_ruby_imperfect", Unique = true },
    			{ Chance = 25, Template = "ring_topaz_imperfect", Unique = true },

    			{ Chance = 25, Template = "necklace_ruby_perfect", Unique = true },
    			{ Chance = 25, Template = "necklace_sapphire_perfect", Unique = true },
    			{ Chance = 25, Template = "necklace_topaz_perfect", Unique = true },
    			{ Chance = 25, Template = "ring_sapphire_perfect", Unique = true },
    			{ Chance = 25, Template = "ring_ruby_perfect", Unique = true },
    			{ Chance = 25, Template = "ring_topaz_perfect", Unique = true },
			},
		},

		DeathBoss = 
		{
			NumItems = 3,
					
			LootItems = 
			{ 
				{ Chance = 50, Template = "random_executioner_weapon_80_100", Unique = true},

				{ Chance = 25, Template = "necklace_ruby_flawed", Unique = true },
    			{ Chance = 25, Template = "necklace_sapphire_flawed", Unique = true },
    			{ Chance = 25, Template = "necklace_topaz_flawed", Unique = true },
    			{ Chance = 25, Template = "ring_sapphire_flawed", Unique = true },
    			{ Chance = 25, Template = "ring_ruby_flawed", Unique = true },
    			{ Chance = 25, Template = "ring_topaz_flawed", Unique = true },

    			{ Chance = 25, Template = "necklace_ruby_imperfect", Unique = true },
    			{ Chance = 25, Template = "necklace_sapphire_imperfect", Unique = true },
    			{ Chance = 25, Template = "necklace_topaz_imperfect", Unique = true },
    			{ Chance = 25, Template = "ring_sapphire_imperfect", Unique = true },
    			{ Chance = 25, Template = "ring_ruby_imperfect", Unique = true },
    			{ Chance = 25, Template = "ring_topaz_imperfect", Unique = true },

    			{ Chance = 25, Template = "necklace_ruby_perfect", Unique = true },
    			{ Chance = 25, Template = "necklace_sapphire_perfect", Unique = true },
    			{ Chance = 25, Template = "necklace_topaz_perfect", Unique = true },
    			{ Chance = 25, Template = "ring_sapphire_perfect", Unique = true },
    			{ Chance = 25, Template = "ring_ruby_perfect", Unique = true },
    			{ Chance = 25, Template = "ring_topaz_perfect", Unique = true },
			},
		},

		DeathBossGear = 
		{
			NumItems = 1,
					
			LootItems = 
			{ 
				{ Chance = 50, Template = "robe_necromancer_tunic", Unique = true},
				{ Chance = 50, Template = "robe_necromancer_leggings", Unique = true},
				{ Chance = 50, Template = "robe_necromancer_helm", Unique = true},
				{ Chance = 50, Template = "weapon_dark_bow", Unique = true},
				{ Chance = 50, Template = "weapon_shadowblade", Unique = true},
				{ Chance = 50, Template = "weapon_death_scythe", Unique = true},
				{ Chance = 50, Template = "weapon_silver_longsword", Unique = true},
				{ Chance = 50, Template = "weapon_dark_maul", Unique = true},
				{ Chance = 50, Template = "furniture_throne_reaper", Packed = true, Unique = true},
				{ Chance = 50, Template = "furniture_teleporter_catacombs", Packed = true,  Unique = true},
				{ Chance = 50, Template = "item_statue_death", Unique = true},
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
    			{ Chance = 25, Template = "animalparts_spider_silk", Unique = true, StackCountMin = 1, StackCountMax = 3 },
    		},
		},

		JeweleryPoor = 
		{
			NumItems = 1,
	    	LootItems = {
	    		{ Chance = 2, Template = "necklace_ruby_flawed", Unique = true },
    			{ Chance = 2, Template = "necklace_sapphire_flawed", Unique = true },
    			{ Chance = 2, Template = "necklace_topaz_flawed", Unique = true },
    			{ Chance = 2, Template = "ring_sapphire_flawed", Unique = true },
    			{ Chance = 2, Template = "ring_ruby_flawed", Unique = true },
    			{ Chance = 2, Template = "ring_topaz_flawed", Unique = true },
    		},
		},

		Jewelery = 
		{
			NumItems = 1,
	    	LootItems = {
	    		{ Chance = 2, Template = "necklace_ruby_flawed", Unique = true },
    			{ Chance = 2, Template = "necklace_sapphire_flawed", Unique = true },
    			{ Chance = 2, Template = "necklace_topaz_flawed", Unique = true },
    			{ Chance = 2, Template = "ring_sapphire_flawed", Unique = true },
    			{ Chance = 2, Template = "ring_ruby_flawed", Unique = true },
    			{ Chance = 2, Template = "ring_topaz_flawed", Unique = true },

    			{ Chance = 1, Template = "necklace_ruby_imperfect", Unique = true },
    			{ Chance = 1, Template = "necklace_sapphire_imperfect", Unique = true },
    			{ Chance = 1, Template = "necklace_topaz_imperfect", Unique = true },
    			{ Chance = 1, Template = "ring_sapphire_imperfect", Unique = true },
    			{ Chance = 1, Template = "ring_ruby_imperfect", Unique = true },
    			{ Chance = 1, Template = "ring_topaz_imperfect", Unique = true },
    		},
		},

		JeweleryRich = 
		{
			NumItems = 1,
	    	LootItems = {
	    		{ Chance = 5, Template = "necklace_ruby_flawed", Unique = true },
    			{ Chance = 5, Template = "necklace_sapphire_flawed", Unique = true },
    			{ Chance = 5, Template = "necklace_topaz_flawed", Unique = true },
    			{ Chance = 5, Template = "ring_sapphire_flawed", Unique = true },
    			{ Chance = 5, Template = "ring_ruby_flawed", Unique = true },
    			{ Chance = 5, Template = "ring_topaz_flawed", Unique = true },

    			{ Chance = 2, Template = "necklace_ruby_imperfect", Unique = true },
    			{ Chance = 2, Template = "necklace_sapphire_imperfect", Unique = true },
    			{ Chance = 2, Template = "necklace_topaz_imperfect", Unique = true },
    			{ Chance = 2, Template = "ring_sapphire_imperfect", Unique = true },
    			{ Chance = 2, Template = "ring_ruby_imperfect", Unique = true },
    			{ Chance = 2, Template = "ring_topaz_imperfect", Unique = true },

    			{ Chance = 1, Template = "necklace_ruby_perfect", Unique = true },
    			{ Chance = 1, Template = "necklace_sapphire_perfect", Unique = true },
    			{ Chance = 1, Template = "necklace_topaz_perfect", Unique = true },
    			{ Chance = 1, Template = "ring_sapphire_perfect", Unique = true },
    			{ Chance = 1, Template = "ring_ruby_perfect", Unique = true },
    			{ Chance = 1, Template = "ring_topaz_perfect", Unique = true },
    		},
		},

		Bones = 
		{
			NumItems = 1,		

			LootItems = 
			{ 
				{ Chance = 20, Template = "animalparts_bone", Unique = true, StackCountMin = 1, StackCountMax = 3  },
			},
		},

		BonesCursed = 
		{
			NumItems = 1,		

			LootItems = 
			{ 
				{ Chance = 20, Template = "animalparts_bone_cursed", Unique = true, StackCountMin = 1, StackCountMax = 3  },
			},
		},

		BonesEthereal = 
		{
			NumItems = 1,		

			LootItems = 
			{ 
				{ Chance = 20, Template = "animalparts_bone_ethereal", Unique = true, StackCountMin = 1, StackCountMax = 3  },
			},
		},

		FrayedScrolls = 
		{
			NumItems = 1,		

			LootItems = 
			{ 
				{ Chance = 20, Template = "ingredient_frayed_scroll", Unique = true, StackCountMin = 1, StackCountMax = 3  },
			},
		},	

		FineScrolls = 
		{
			NumItems = 1,		

			LootItems = 
			{ 
				{ Chance = 20, Template = "ingredient_fine_scroll", Unique = true, StackCountMin = 1, StackCountMax = 3  },
			},
		},	

		AncientScrolls = 
		{
			NumItems = 1,		

			LootItems = 
			{ 
				{ Chance = 20, Template = "ingredient_ancient_scroll", Unique = true, StackCountMin = 1, StackCountMax = 3  },
			},
		},	

		DecrepidEye = 
		{
			NumItems = 1,		

			LootItems = 
			{ 
				{ Chance = 20, Template = "animalparts_eye_decrepid", StackCountMin = 1, StackCountMax = 3  },
			},
		},	

		SicklyEye = 
		{
			NumItems = 1,		

			LootItems = 
			{ 
				{ Chance = 20, Template = "animalparts_eye_sickly", StackCountMin = 1, StackCountMax = 3  },
			},
		},	

		Eye = 
		{
			NumItems = 1,		

			LootItems = 
			{ 
				{ Chance = 20, Template = "animalparts_eye", StackCountMin = 1, StackCountMax = 3  },
			},
		},	

		Blood = 
		{
			NumItems = 1,		

			LootItems = 
			{ 
				{ Chance = 20, Template = "animalparts_blood", StackCountMin = 1, StackCountMax = 3  },
			},
		},	

		BeastBlood = 
		{
			NumItems = 1,		

			LootItems = 
			{ 
				{ Chance = 20, Template = "animalparts_blood_beast", StackCountMin = 1, StackCountMax = 3  },
			},
		},	

		VileBlood = 
		{
			NumItems = 1,		

			LootItems = 
			{ 
				{ Chance = 20, Template = "animalparts_blood_vile", StackCountMin = 1, StackCountMax = 3  },
			},
		},	

		ScrollsLow = 
		{
			NumItems = 1,		

			LootItems = 
			{ 
				{ Chance = 5, Template = "lscroll_heal", Unique = true },
				{ Chance = 5, Template = "lscroll_refresh", Unique = true },
				{ Chance = 5, Template = "lscroll_infuse", Unique = true },
				{ Chance = 5, Template = "lscroll_cure", Unique = true },
				{ Chance = 5, Template = "lscroll_poison", Unique = true },
				{ Chance = 5, Template = "lscroll_ruin", Unique = true },
				{ Chance = 5, Template = "lscroll_mana_missile", Unique = true },
			},
		},		
		ScrollsMed = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
				{ Chance = 15, Template = "lscroll_heal", Unique = true },
				{ Chance = 15, Template = "lscroll_refresh", Unique = true },
				{ Chance = 15, Template = "lscroll_infuse", Unique = true },
				{ Chance = 15, Template = "lscroll_cure", Unique = true },
				{ Chance = 15, Template = "lscroll_poison", Unique = true },
				{ Chance = 15, Template = "lscroll_ruin", Unique = true },
				{ Chance = 15, Template = "lscroll_greater_heal", Unique = true },
				{ Chance = 15, Template = "lscroll_lightning", Unique = true },
				{ Chance = 15, Template = "lscroll_bombardment", Unique = true },
				{ Chance = 15, Template = "lscroll_electricbolt", Unique = true },
				{ Chance = 15, Template = "lscroll_mark", Unique = true },
				{ Chance = 15, Template = "lscroll_frost", Unique = true },
			},
		},
		ScrollsHigh = 
		{
			NumItems = 1,	

			LootItems = 
			{ 
				{ Chance = 1, Template = "lscroll_greater_heal", Unique = true },
				{ Chance = 1, Template = "lscroll_lightning", Unique = true },
				{ Chance = 1, Template = "lscroll_bombardment", Unique = true },
				{ Chance = 1, Template = "lscroll_electricbolt", Unique = true },
				{ Chance = 1, Template = "lscroll_mark", Unique = true },
				{ Chance = 1, Template = "lscroll_frost", Unique = true },
				{ Chance = 1, Template = "lscroll_resurrect", Unique = true },
				{ Chance = 1, Template = "lscroll_earthquake", Unique = true },
				{ Chance = 1, Template = "lscroll_meteor", Unique = true },
				{ Chance = 1, Template = "lscroll_portal", Unique = true },

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
				{ Chance = 7.5, Template = "treasure_map"},
				{ Chance = 2.5, Template = "treasure_map_1"},
				{ Chance = 0.5, Template = "treasure_map_2"},
			},
		},

		Maps = 
		{
			NumItems = 1,	

			LootItems = 
			{
				{ Chance = 10, Template = "treasure_map"},
				{ Chance = 5, Template = "treasure_map_1"},
				{ Chance = 3.5, Template = "treasure_map_2"},
				{ Chance = 1.5, Template = "treasure_map_3"},
			},
		},

		MapsHigh = 
		{
			NumItems = 1,	

			LootItems = 
			{
				{ Chance = 2, Template = "treasure_map"},
				{ Chance = 1, Template = "treasure_map_1"},
				{ Chance = 0.5, Template = "treasure_map_2"},
				{ Chance = 0.35, Template = "treasure_map_3"},
				{ Chance = 0.15, Template = "treasure_map_4"},
			},
		},

		MapsBoss = 
		{
			NumItems = 5,	

			LootItems = 
			{
				{ Chance = 10, Template = "treasure_map"},
				{ Chance = 10, Template = "treasure_map_1"},
				{ Chance = 20, Template = "treasure_map_2"},
				{ Chance = 20, Template = "treasure_map_3"},
				{ Chance = 40, Template = "treasure_map_4"},
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
				{ Chance = 1, Template = "lscroll_bombardment", Unique = true },
				{ Chance = 1, Template = "lscroll_meteor", Unique = true },
				{ Chance = 1, Template = "lscroll_earthquake", Unique = true },
				{ Chance = 1, Template = "lscroll_portal", Unique = true },
				{ Chance = 2, Template = "lscroll_mark", Unique = true },
			},
		},
		MagePoor = 
		{
			NumItemsMin = 1,
			NumItemsMax = 2,	

			LootItems = 
			{ 
				{ Chance = 25, Template = "ingredient_ginsengroot", Unique = true, StackCountMin = 1, StackCountMax = 3,},
				{ Chance = 25, Template = "ingredient_mandrakeroot", Unique = true, StackCountMin = 1, StackCountMax = 3,},
				{ Chance = 25, Template = "ingredient_blackpearl", Unique = true, StackCountMin = 1, StackCountMax = 3,},
				{ Chance = 25, Template = "ingredient_spidersilk", Unique = true, StackCountMin = 1, StackCountMax = 3,},
				{ Chance = 25, Template = "ingredient_bloodmoss", Unique = true, StackCountMin = 1, StackCountMax = 3,},
				{ Chance = 25, Template = "ingredient_sulfurousash", Unique = true, StackCountMin = 1, StackCountMax = 3,},
				{ Chance = 25, Template = "ingredient_nightshade", Unique = true, StackCountMin = 1, StackCountMax = 3,},
				{ Chance = 25, Template = "ingredient_garlic", Unique = true, StackCountMin = 1, StackCountMax = 3,},
			},
		},
		MageRich = 
		{
			NumItemsMin = 2,
			NumItemsMax = 3,	

			LootItems = 
			{ 
				{ Chance = 25, Template = "ingredient_ginsengroot", Unique = true, StackCountMin = 2, StackCountMax = 5,},
				{ Chance = 25, Template = "ingredient_mandrakeroot", Unique = true, StackCountMin = 2, StackCountMax = 5,},
				{ Chance = 25, Template = "ingredient_blackpearl", Unique = true, StackCountMin = 2, StackCountMax = 5,},
				{ Chance = 25, Template = "ingredient_spidersilk", Unique = true, StackCountMin = 2, StackCountMax = 5,},
				{ Chance = 25, Template = "ingredient_bloodmoss", Unique = true, StackCountMin = 2, StackCountMax = 5,},
				{ Chance = 25, Template = "ingredient_sulfurousash", Unique = true, StackCountMin = 2, StackCountMax = 5,},
				{ Chance = 25, Template = "ingredient_nightshade", Unique = true, StackCountMin = 2, StackCountMax = 5,},
				{ Chance = 25, Template = "ingredient_garlic", Unique = true, StackCountMin = 2, StackCountMax = 5,},
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
				{ Chance = 50, Template = "arrow", Unique = true, StackCountMin = 10, StackCountMax = 30,},
				{ Chance = 2, Template = "weapon_shortbow", Unique = true },
				{ Chance = 2, Template = "weapon_longbow", Unique = true },
			},
		},
		MageBoss = 
		{
			NumItems = 3,	

			LootItems = 
			{   
				{ Chance = 25, Template = "ingredient_ginsengroot", Unique = true, StackCountMin = 50, StackCountMax = 100,},
				{ Chance = 25, Template = "ingredient_mandrakeroot", Unique = true, StackCountMin = 50, StackCountMax = 100,},
				{ Chance = 25, Template = "ingredient_blackpearl", Unique = true, StackCountMin = 50, StackCountMax = 100,},
				{ Chance = 25, Template = "ingredient_spidersilk", Unique = true, StackCountMin = 50, StackCountMax = 100,},
				{ Chance = 25, Template = "ingredient_bloodmoss", Unique = true, StackCountMin = 50, StackCountMax = 100,},
				{ Chance = 25, Template = "ingredient_sulfurousash", Unique = true, StackCountMin = 50, StackCountMax = 100,},
				{ Chance = 25, Template = "ingredient_nightshade", Unique = true, StackCountMin = 50, StackCountMax = 100,},
				{ Chance = 25, Template = "ingredient_garlic", Unique = true, StackCountMin = 50, StackCountMax = 100,},
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
				{ Chance = 1, Template = "armor_fullplate_helm", Unique = true },
				{ Chance = 1, Template = "armor_fullplate_tunic", Unique = true },
				{ Chance = 1, Template = "armor_fullplate_leggings", Unique = true },
			},
		},
		WarriorRich = 
		{
			NumItems = 2,	

			LootItems = 
			{ 
				{ Chance = 50, Template = "bandage", Unique = true, StackCountMin = 1, StackCountMax = 5,},
				{ Chance = 5, Template = "weapon_dagger", Unique = true },
				{ Chance = 5, Template = "weapon_longsword", Unique = true },
				{ Chance = 5, Template = "weapon_mace", Unique = true },
				{ Chance = 5, Template = "weapon_shortbow", Unique = true },
				{ Chance = 5, Template = "shield_buckler", Unique = true },
				{ Chance = 5, Template = "armor_chain_helm", Unique = true },
				{ Chance = 5, Template = "armor_chain_tunic", Unique = true },
				{ Chance = 5, Template = "armor_chain_leggings", Unique = true },
				{ Chance = 3, Template = "armor_scale_helm", Unique = true },
				{ Chance = 3, Template = "armor_scale_tunic", Unique = true },
				{ Chance = 3, Template = "armor_scale_leggings", Unique = true },
				{ Chance = 1, Template = "armor_fullplate_helm", Unique = true },
				{ Chance = 1, Template = "armor_fullplate_tunic", Unique = true },
				{ Chance = 1, Template = "armor_fullplate_leggings", Unique = true },
			},
		},
		PrestigeLow = 
		{
			NumItems = 1,	
			LootItems = 
			{ 
				{ Chance = 1, Template = "prestige_dart", Unique = true },
				{ Chance = 1, Template = "prestige_spellchamber", Unique = true },
				{ Chance = 1, Template = "prestige_empower", Unique = true },
				{ Chance = 1, Template = "prestige_stunstrike", Unique = true },
				{ Chance = 1, Template = "prestige_hamstring", Unique = true },
			},
		},
		Prestige = 
		{
			NumItems = 1,	
			LootItems = 
			{ 
				{ Chance = 2, Template = "prestige_stasis", Unique = true },
				{ Chance = 2, Template = "prestige_charge", Unique = true },
				{ Chance = 2, Template = "prestige_wound", Unique = true },
				{ Chance = 2, Template = "prestige_evasion", Unique = true },
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
				{ Chance = 40, Template = "contempt_skull", Unique = true },
			}
		},
		ContemptMobLow =
		{
			NumItems = 1,	
			LootItems = 
			{ 
				{ Chance = 15, Template = "contempt_skull", Unique = true },
			}
		},
		RuinMob =
		{
			NumItems = 1,	
			LootItems = 
			{ 
				{ Chance = 40, Template = "ruin_skull", Unique = true },
			}
		},
		RuinMobLow =
		{
			NumItems = 1,	
			LootItems = 
			{ 
				{ Chance = 15, Template = "ruin_skull", Unique = true },
			}
		},
		DeceptionMob =
		{
			NumItems = 1,	
			LootItems = 
			{ 
				{ Chance = 40, Template = "deception_skull", Unique = true },
			}
		},
		DeceptionMobLow =
		{
			NumItems = 1,	
			LootItems = 
			{ 
				{ Chance = 15, Template = "deception_skull", Unique = true },
			}
		},
		AwakeningDragon =
		{
			NumItems = 1,	
			LootItems = 
			{ 
				{ Chance = 5, Template = "prestige_vanguard", Unique = true },
				{ Chance = 5, Template = "prestige_shieldbash", Unique = true },
				{ Chance = 5, Template = "prestige_stunshot", Unique = true },
				{ Chance = 5, Template = "prestige_adrenaline_rush", Unique = true },
				{ Chance = 5, Template = "prestige_silence", Unique = true },
				{ Chance = 5, Template = "prestige_magearmor", Unique = true },
				{ Chance = 5, Template = "prestige_huntersmark", Unique = true },
				{ Chance = 5, Template = "prestige_vanish", Unique = true },
				{ Chance = 5, Template = "prestige_meditate", Unique = true },

				{ Chance = 2, Template = "prestige_stasis", Unique = true },
				{ Chance = 2, Template = "prestige_empower", Unique = true },
				{ Chance = 2, Template = "prestige_charge", Unique = true },
				{ Chance = 2, Template = "prestige_wound", Unique = true },
				{ Chance = 2, Template = "prestige_dart", Unique = true },
				{ Chance = 2, Template = "prestige_evasion", Unique = true },
				{ Chance = 2, Template = "prestige_spellchamber", Unique = true },
				{ Chance = 2, Template = "prestige_stunstrike", Unique = true },
				{ Chance = 2, Template = "prestige_hamstring", Unique = true },
			}
		},
		CultistKing =
		{
			NumItems = 1,	
			LootItems = 
			{ 
				{ Chance = 10, Template = "armor_cultist_king_helm", Unique = true },
				{ Chance = 10, Template = "armor_cultist_king_chest", Unique = true },
				{ Chance = 10, Template = "armor_cultist_king_leggings", Unique = true },
			}
		},
	},

	GridSpawns = 
	{
		UpperPlains = {
			Easy = { 
				{ Count = 10, TemplateId = "wolf" },
				{ Count = 10, TemplateId = "black_bear" },
				{ Count = 30, TemplateId = "hind" },
				{ Count = 20, TemplateId = "chicken" },
				{ Count = 4, TemplateId = "horse" },
				{ Count = 5, TemplateId = "bay_horse" },
				{ Count = 1, TemplateId = "black_horse" },

				{ Count = 20, TemplateId = "plant_moss"},
				{ Count = 20, TemplateId = "plant_ginseng"},
				{ Count = 20, TemplateId = "plant_lemon_grass" },
				{ Count = 20, TemplateId = "plant_mushrooms"},
				{ Count = 20, TemplateId = "plant_cotton"},
				{ Count = 10, TemplateId = "plant_giant_mushrooms"},
				{ Count = 20, TemplateId = "plant_kindling"},

				{ Count = 10, TemplateId = "plant_bloodmoss"},
				{ Count = 10, TemplateId = "plant_garlic"},
				{ Count = 10, TemplateId = "plant_mandrake"},
				{ Count = 10, TemplateId = "plant_nightshade"},

				{ Count = 20, TemplateId = "rat_giant"},
			},
			Medium = {
				{ Count = 10, TemplateId = "wolf" },
				{ Count = 15, TemplateId = "black_bear" },
				{ Count = 20, TemplateId = "hind" },
				{ Count = 15, TemplateId = "fox" },
				{ Count = 3, TemplateId = "horse" },
				{ Count = 6, TemplateId = "bay_horse" },
				{ Count = 1, TemplateId = "black_horse" },
				{ Count = 20, TemplateId = "brown_bear" },
				{ Count = 10, TemplateId = "wolf_grey" },

				{ Count = 20, TemplateId = "plant_moss"},
				{ Count = 20, TemplateId = "plant_ginseng"},
				{ Count = 20, TemplateId = "plant_lemon_grass" },
				{ Count = 20, TemplateId = "plant_mushrooms"},
				{ Count = 30, TemplateId = "plant_cotton"},
				{ Count = 10, TemplateId = "plant_giant_mushrooms"},
				{ Count = 20, TemplateId = "plant_kindling"},

				{ Count = 10, TemplateId = "plant_garlic"},
				{ Count = 10, TemplateId = "plant_mandrake"},
				{ Count = 10, TemplateId = "plant_nightshade"},

				{ Count = 10, TemplateId = "bandit"},
				{ Count = 5, TemplateId = "bandit_female"},
			},
			Hard = {
				{ Count = 2, TemplateId = "wolf" },
				{ Count = 2, TemplateId = "black_bear" },
				{ Count = 5, TemplateId = "hind" },
				{ Count = 10, TemplateId = "chicken" },
				{ Count = 3, TemplateId = "horse" },
				{ Count = 5, TemplateId = "bay_horse" },
				{ Count = 2, TemplateId = "black_horse" },
				{ Count = 10, TemplateId = "brown_bear" },
				{ Count = 10, TemplateId = "wolf_grey" },
				{ Count = 10, TemplateId = "grizzly_bear" },
				{ Count = 20, TemplateId = "great_hart" },

				{ Count = 10, TemplateId = "troll"},
				{ Count = 10, TemplateId = "spider_large"},

				{ Count = 20, TemplateId = "plant_moss"},
				{ Count = 20, TemplateId = "plant_ginseng"},
				{ Count = 20, TemplateId = "plant_lemon_grass" },
				{ Count = 20, TemplateId = "plant_mushrooms"},
				{ Count = 30, TemplateId = "plant_cotton"},
				{ Count = 10, TemplateId = "plant_giant_mushrooms"},
				{ Count = 20, TemplateId = "plant_kindling"},

				{ Count = 10, TemplateId = "plant_garlic"},
				{ Count = 10, TemplateId = "plant_mandrake"},
				{ Count = 10, TemplateId = "plant_nightshade"},
			},
		},
		SouthernHills = {
			Easy = { 
				{ Count = 25, TemplateId = "coyote" },
				{ Count = 25, TemplateId = "black_bear" },
				{ Count = 30, TemplateId = "hind" },
				{ Count = 20, TemplateId = "turkey" },
				{ Count = 4, TemplateId = "horse" },
				{ Count = 5, TemplateId = "chestnut_horse" },
				{ Count = 1, TemplateId = "black_horse" },

				{ Count = 20, TemplateId = "plant_moss"},
				{ Count = 20, TemplateId = "plant_ginseng"},
				{ Count = 20, TemplateId = "plant_lemon_grass" },
				{ Count = 20, TemplateId = "plant_mushrooms"},
				{ Count = 30, TemplateId = "plant_cotton"},
				{ Count = 10, TemplateId = "plant_giant_mushrooms"},
				{ Count = 20, TemplateId = "plant_kindling"},

				{ Count = 10, TemplateId = "plant_garlic"},
				{ Count = 10, TemplateId = "plant_mandrake"},
				{ Count = 10, TemplateId = "plant_nightshade"},

				{ Count = 20, TemplateId = "rat_giant"},

			},
			Medium = {
				{ Count = 20, TemplateId = "coyote" },
				{ Count = 15, TemplateId = "black_bear" },
				{ Count = 20, TemplateId = "hind" },
				{ Count = 10, TemplateId = "turkey" },
				{ Count = 3, TemplateId = "horse" },
				{ Count = 5, TemplateId = "chestnut_horse" },
				{ Count = 2, TemplateId = "black_horse" },
				{ Count = 20, TemplateId = "brown_bear" },
				{ Count = 15, TemplateId = "wolf_black" },

				{ Count = 20, TemplateId = "plant_moss"},
				{ Count = 20, TemplateId = "plant_ginseng"},
				{ Count = 20, TemplateId = "plant_lemon_grass" },
				{ Count = 20, TemplateId = "plant_mushrooms"},
				{ Count = 30, TemplateId = "plant_cotton"},
				{ Count = 10, TemplateId = "plant_giant_mushrooms"},
				{ Count = 20, TemplateId = "plant_kindling"},

				{ Count = 10, TemplateId = "plant_garlic"},
				{ Count = 10, TemplateId = "plant_mandrake"},
				{ Count = 10, TemplateId = "plant_nightshade"},

				{ Count = 10, TemplateId = "bandit"},
				{ Count = 5, TemplateId = "bandit_female"},
			},
			Hard = {
				{ Count = 5, TemplateId = "coyote" },
				{ Count = 5, TemplateId = "black_bear" },
				{ Count = 5, TemplateId = "hind" },
				{ Count = 10, TemplateId = "turkey" },
				{ Count = 3, TemplateId = "horse" },
				{ Count = 4, TemplateId = "chestnut_horse" },
				{ Count = 3, TemplateId = "black_horse" },
				{ Count = 10, TemplateId = "brown_bear" },
				{ Count = 25, TemplateId = "wolf_black" },
				{ Count = 20, TemplateId = "grizzly_bear" },
				{ Count = 20, TemplateId = "great_hart" },

				{ Count = 20, TemplateId = "plant_moss"},
				{ Count = 20, TemplateId = "plant_ginseng"},
				{ Count = 20, TemplateId = "plant_lemon_grass" },
				{ Count = 20, TemplateId = "plant_mushrooms"},
				{ Count = 30, TemplateId = "plant_cotton"},
				{ Count = 10, TemplateId = "plant_giant_mushrooms"},
				{ Count = 20, TemplateId = "plant_kindling"},

				{ Count = 10, TemplateId = "plant_garlic"},
				{ Count = 10, TemplateId = "plant_mandrake"},
				{ Count = 10, TemplateId = "plant_nightshade"},

				{ Count = 10, TemplateId = "troll"},
				{ Count = 10, TemplateId = "spider_large"},
			},
		},
		BarrenLands = {
			Easy = { 
				{ Count = 30, TemplateId = "snake_sand" },
				{ Count = 30, TemplateId = "beetle" },
				{ Count = 5, TemplateId = "wolf_desert" },
				{ Count = 3, TemplateId = "desert_horse" },
				{ Count = 1, TemplateId = "cultist_horse" },

				{ Count = 30, TemplateId = "plant_cactus"},
				{ Count = 30, TemplateId = "plant_giant_mushrooms"},
				{ Count = 20, TemplateId = "plant_kindling"},

				{ Count = 10, TemplateId = "plant_sulfurousash"},

				{ Count = 10, TemplateId = "scorpion"},
				{ Count = 10, TemplateId = "beetle_giant"},
			},
		},
		BlackForest = {
			Easy = { 
				{ Count = 30, TemplateId = "bat" },
				{ Count = 30, TemplateId = "spider" },
				{ Count = 5, TemplateId = "spider_large" },
				{ Count = 1, TemplateId = "black_horse" },

				{ Count = 30, TemplateId = "plant_mushrooms"},
				{ Count = 30, TemplateId = "plant_giant_mushrooms"},
				{ Count = 20, TemplateId = "plant_kindling"},

				{ Count = 30, TemplateId = "plant_nightshade"},
				{ Count = 20, TemplateId = "plant_bloodmoss"},

				{ Count = 10, TemplateId = "spider_large"},
				{ Count = 10, TemplateId = "ent"},
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