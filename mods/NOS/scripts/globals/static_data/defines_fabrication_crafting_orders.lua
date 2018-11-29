CraftingOrderDefines.FabricationSkill = 
{
--This is valid
--[[
	CraftingOrderRecipes =
	{
		Weapons = 
		{
			{
				NumItems = 1,
    			LootItems = 
    			{
    				{ Weight = 10, Template = "recipe_greataxe", Unique = true},
    				{ Weight = 10, Template = "recipe_saber", Unique = true},
				},
			},	
		},
	},
]]--

--So is this
	CraftingOrderRecipes =
	{
		{
			NumItems = 1,
			LootItems = 
			{
				{ Weight = 10, Template = "recipe_shorts", Unique = true},
				{ Weight = 10, Template = "recipe_skirts", Unique = true},
				{ Weight = 10, Template = "recipe_apron", Unique = true},
				{ Weight = 10, Template = "recipe_blacksmith", Unique = true},
				{ Weight = 10, Template = "recipe_bandana", Unique = true},
				{ Weight = 10, Template = "recipe_bandithood", Unique = true},
				{ Weight = 10, Template = "recipe_magehat", Unique = true},
				{ Weight = 10, Template = "recipe_linenhelm", Unique = true},
				{ Weight = 10, Template = "recipe_linenlegs", Unique = true},
				{ Weight = 10, Template = "recipe_linenchest", Unique = true},
				{ Weight = 10, Template = "recipe_leatherhelm", Unique = true},
				{ Weight = 10, Template = "recipe_leatherlegs", Unique = true},
				{ Weight = 10, Template = "recipe_leatherchest", Unique = true},
				{ Weight = 10, Template = "recipe_hardenedhood", Unique = true},
				{ Weight = 10, Template = "recipe_hardenedleggings", Unique = true},
				{ Weight = 10, Template = "recipe_hardenedchest", Unique = true},
				{ Weight = 10, Template = "recipe_magerobes", Unique = true},
				{ Weight = 10, Template = "recipe_quiltedcloth", Unique = true},
				{ Weight = 10, Template = "recipe_silkcloth", Unique = true},
				{ Weight = 10, Template = "recipe_saddlebags", Unique = true},
				{ Weight = 10, Template = "recipe_vile_leather", Unique = true},
				{ Weight = 10, Template = "recipe_beast_leather", Unique = true},
			},
		},	
	},

	AmountWeights = 
	{
		{
			Amount = 5,
			Weight = 40,
		},

		{
			Amount = 10,
			Weight = 20,
		},

		{
			Amount = 15,
			Weight = 15,
		},

		{
			Amount = 20,
			Weight = 10,
		},

		{
			Amount = 40,
			Weight = 9,
		},

		{
			Amount = 60,
			Weight = 3,
		},

		{
			Amount = 80,
			Weight = 2,
		},

		{
			Amount = 100,
			Weight = 1,
		},
	},

	MaterialWeights = 
	{
		Default = 5,
		Cloth = 60,
		Quilted = 39,
		Silk = 1,
	},

	CraftingOrders = 
	{
	
	--SMALL ORDERS

	--Clothes

		--5 ShortSleeveShirt
		{
			Recipe = "ShortSleeveShirt",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 LongSleeveShirt
		{
			Recipe = "LongSleeveShirt",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 Shorts
		{
			Recipe = "Shorts",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--5 Skirts
		{
			Recipe = "Skirts",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--5 Apron
		{
			Recipe = "Apron",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},			
				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--5 Blacksmith
		{
			Recipe = "Blacksmith",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 Bandana
		{
			Recipe = "Bandana",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 BanditHood
		{
			Recipe = "BanditHood",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 MageHat
		{
			Recipe = "MageHat",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},
	
	--10s

		--10 ShortSleeveShirt
		{
			Recipe = "ShortSleeveShirt",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LongSleeveShirt
		{
			Recipe = "LongSleeveShirt",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 Shorts
		{
			Recipe = "Shorts",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 Skirts
		{
			Recipe = "Skirts",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 Apron
		{
			Recipe = "Apron",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 Blacksmith
		{
			Recipe = "Blacksmith",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 Bandana
		{
			Recipe = "Bandana",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 BanditHood
		{
			Recipe = "BanditHood",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 MageHat
		{
			Recipe = "MageHat",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--15s

		--15 ShortSleeveShirt
		{
			Recipe = "ShortSleeveShirt",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LongSleeveShirt
		{
			Recipe = "LongSleeveShirt",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 Shorts
		{
			Recipe = "Shorts",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 Skirts
		{
			Recipe = "Skirts",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 Apron
		{
			Recipe = "Apron",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 Blacksmith
		{
			Recipe = "Blacksmith",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 Bandana
		{
			Recipe = "Bandana",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 BanditHood
		{
			Recipe = "BanditHood",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 MageHat
		{
			Recipe = "MageHat",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--20s

		--20 ShortSleeveShirt
		{
			Recipe = "ShortSleeveShirt",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LongSleeveShirt
		{
			Recipe = "LongSleeveShirt",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 Shorts
		{
			Recipe = "Shorts",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 Skirts
		{
			Recipe = "Skirts",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 Apron
		{
			Recipe = "Apron",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 Blacksmith
		{
			Recipe = "Blacksmith",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 Bandana
		{
			Recipe = "Bandana",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 BanditHood
		{
			Recipe = "BanditHood",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 MageHat
		{
			Recipe = "MageHat",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--Armor
		--5 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LinenChest
		{
			Recipe = "LinenChest",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "Leather",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "Leather",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "Leather",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "Leather",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "Leather",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "Leather",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 MageRobes
		{
			Recipe = "MageRobes",
			Material = "Cloth",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--10s
		--10 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LinenChest
		{
			Recipe = "LinenChest",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "Leather",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "Leather",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "Leather",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "Leather",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "Leather",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "Leather",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 MageRobes
		{
			Recipe = "MageRobes",
			Material = "Cloth",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--15s
		--15 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LinenChest
		{
			Recipe = "LinenChest",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "Leather",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "Leather",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "Leather",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "Leather",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "Leather",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "Leather",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_leather", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 MageRobes
		{
			Recipe = "MageRobes",
			Material = "Cloth",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--20s
		--20 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LinenChest
		{
			Recipe = "LinenChest",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "Leather",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "Leather",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "Leather",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "Leather",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "Leather",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "Leather",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 MageRobes
		{
			Recipe = "MageRobes",
			Material = "Cloth",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "QuiltedCloth",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "QuiltedCloth",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "QuiltedCloth",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "QuiltedCloth",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "QuiltedCloth",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LinenChest
		{
			Recipe = "LinenChest",
			Material = "QuiltedCloth",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "BeastLeather",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "BeastLeather",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "BeastLeather",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "BeastLeather",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "BeastLeather",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "BeastLeather",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 MageRobes
		{
			Recipe = "MageRobes",
			Material = "QuiltedCloth",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--10s
		--10 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "QuiltedCloth",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "QuiltedCloth",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "QuiltedCloth",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "QuiltedCloth",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "QuiltedCloth",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LinenChest
		{
			Recipe = "LinenChest",
			Material = "QuiltedCloth",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "BeastLeather",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "BeastLeather",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "BeastLeather",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "BeastLeather",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "BeastLeather",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "BeastLeather",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 MageRobes
		{
			Recipe = "MageRobes",
			Material = "QuiltedCloth",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--15s
		--15 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "QuiltedCloth",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "QuiltedCloth",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "QuiltedCloth",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "QuiltedCloth",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "QuiltedCloth",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LinenChest
		{
			Recipe = "LinenChest",
			Material = "QuiltedCloth",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "BeastLeather",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "BeastLeather",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "Leather",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "BeastLeather",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "BeastLeather",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "BeastLeather",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 MageRobes
		{
			Recipe = "MageRobes",
			Material = "QuiltedCloth",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--20s
		--20 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "QuiltedCloth",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "QuiltedCloth",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "QuiltedCloth",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "QuiltedCloth",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "QuiltedCloth",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LinenChest
		{
			Recipe = "LinenChest",
			Material = "QuiltedCloth",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "BeastLeather",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "BeastLeather",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "BeastLeather",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "BeastLeather",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "BeastLeather",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "BeastLeather",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 MageRobes
		{
			Recipe = "MageRobes",
			Material = "QuiltedCloth",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--5 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "SilkCloth",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "SilkCloth",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "SilkCloth",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "SilkCloth",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "SilkCloth",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LinenChest
		{
			Recipe = "LinenChest",
			Material = "SilkCloth",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "VileLeather",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "VileLeather",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "VileLeather",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "VileLeather",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "VileLeather",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "VileLeather",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 MageRobes
		{
			Recipe = "MageRobes",
			Material = "SilkCloth",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--10s
		--10 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "SilkCloth",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "SilkCloth",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "SilkCloth",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "SilkCloth",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "SilkCloth",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LinenChest
		{
			Recipe = "LinenChest",
			Material = "SilkCloth",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "VileLeather",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "VileLeather",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "VileLeather",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "VileLeather",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "VileLeather",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "VileLeather",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 50, Template = "tool_mining_pick", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 MageRobes
		{
			Recipe = "MageRobes",
			Material = "SilkCloth",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--15s
		--15 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "SilkCloth",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "SilkCloth",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "SilkCloth",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "SilkCloth",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "SilkCloth",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LinenChest
		{
			Recipe = "LinenChest",
			Material = "SilkCloth",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "VileLeather",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "VileLeather",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "Leather",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "VileLeather",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "VileLeather",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "VileLeather",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 MageRobes
		{
			Recipe = "MageRobes",
			Material = "SilkCloth",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--20s
		--20 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "SilkCloth",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "SilkCloth",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "SilkCloth",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "SilkCloth",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "SilkCloth",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LinenChest
		{
			Recipe = "LinenChest",
			Material = "SilkCloth",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "VileLeather",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "VileLeather",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "VileLeather",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "VileLeather",
			Amount = 20,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "VileLeather",
			Amount = 20,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "VileLeather",
			Amount = 20,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 MageRobes
		{
			Recipe = "MageRobes",
			Material = "SilkCloth",
			Amount = 20,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},
	--LARGE ORDERS

	--Clothes

		--40 ShortSleeveShirt
		{
			Recipe = "ShortSleeveShirt",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LongSleeveShirt
		{
			Recipe = "LongSleeveShirt",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 Shorts
		{
			Recipe = "Shorts",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 Skirts
		{
			Recipe = "Skirts",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 Apron
		{
			Recipe = "Apron",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 Blacksmith
		{
			Recipe = "Blacksmith",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 Bandana
		{
			Recipe = "Bandana",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 BanditHood
		{
			Recipe = "BanditHood",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 MageHat
		{
			Recipe = "MageHat",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},
	
	--80s

		--80 ShortSleeveShirt
		{
			Recipe = "ShortSleeveShirt",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LongSleeveShirt
		{
			Recipe = "LongSleeveShirt",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 Shorts
		{
			Recipe = "Shorts",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 Skirts
		{
			Recipe = "Skirts",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 Apron
		{
			Recipe = "Apron",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 Blacksmith
		{
			Recipe = "Blacksmith",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 Bandana
		{
			Recipe = "Bandana",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 BanditHood
		{
			Recipe = "BanditHood",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 MageHat
		{
			Recipe = "MageHat",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--120s

		--120 ShortSleeveShirt
		{
			Recipe = "ShortSleeveShirt",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LongSleeveShirt
		{
			Recipe = "LongSleeveShirt",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 Shorts
		{
			Recipe = "Shorts",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 Skirts
		{
			Recipe = "Skirts",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 Apron
		{
			Recipe = "Apron",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 Blacksmith
		{
			Recipe = "Blacksmith",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 Bandana
		{
			Recipe = "Bandana",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 BanditHood
		{
			Recipe = "BanditHood",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 MageHat
		{
			Recipe = "MageHat",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--150s

		--150 ShortSleeveShirt
		{
			Recipe = "ShortSleeveShirt",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LongSleeveShirt
		{
			Recipe = "LongSleeveShirt",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 Shorts
		{
			Recipe = "Shorts",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 Skirts
		{
			Recipe = "Skirts",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 Apron
		{
			Recipe = "Apron",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 Blacksmith
		{
			Recipe = "Blacksmith",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 Bandana
		{
			Recipe = "Bandana",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 BanditHood
		{
			Recipe = "BanditHood",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 MageHat
		{
			Recipe = "MageHat",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bolt_of_cloth_quilted", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--Armor
		--40 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LinenChest
		{
			Recipe = "LinenChest",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "Leather",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "Leather",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "Leather",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "Leather",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "Leather",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "Leather",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 MageRobes
		{
			Recipe = "MageRobes",
			Material = "Cloth",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--80s
		--80 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_silk_cloth", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LinenChest
		{
			Recipe = "LinenChest",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "Leather",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "Leather",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "Leather",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "Leather",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "Leather",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "Leather",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 MageRobes
		{
			Recipe = "MageRobes",
			Material = "Cloth",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--120s
		--120 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LinenChest
		{
			Recipe = "LinenChest",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "Leather",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "Leather",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "Leather",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "Leather",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "Leather",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "Leather",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 MageRobes
		{
			Recipe = "MageRobes",
			Material = "Cloth",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--150s
		--150 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LinenChest
		{
			Recipe = "LinenChest",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "Leather",
			Amount = 100,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "Leather",
			Amount = 100,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "Leather",
			Amount = 100,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "Leather",
			Amount = 100,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "Leather",
			Amount = 100,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "Leather",
			Amount = 100,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 MageRobes
		{
			Recipe = "MageRobes",
			Material = "Cloth",
			Amount = 100,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "QuiltedCloth",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "QuiltedCloth",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "QuiltedCloth",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "QuiltedCloth",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "QuiltedCloth",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LinenChest
		{
			Recipe = "LinenChest",
			Material = "QuiltedCloth",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "BeastLeather",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "BeastLeather",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "BeastLeather",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "BeastLeather",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "BeastLeather",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "BeastLeather",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 MageRobes
		{
			Recipe = "MageRobes",
			Material = "QuiltedCloth",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--80s
		--80 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "QuiltedCloth",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "QuiltedCloth",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "QuiltedCloth",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_mannequin", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "QuiltedCloth",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "QuiltedCloth",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LinenChest
		{
			Recipe = "LinenChest",
			Material = "QuiltedCloth",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "BeastLeather",
			Amount = 60,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "BeastLeather",
			Amount = 60,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "BeastLeather",
			Amount = 60,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "BeastLeather",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "BeastLeather",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "BeastLeather",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 MageRobes
		{
			Recipe = "MageRobes",
			Material = "QuiltedCloth",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--120s
		--120 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "QuiltedCloth",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "QuiltedCloth",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "QuiltedCloth",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "QuiltedCloth",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "QuiltedCloth",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LinenChest
		{
			Recipe = "LinenChest",
			Material = "QuiltedCloth",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "BeastLeather",
			Amount = 80,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "BeastLeather",
			Amount = 80,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "Leather",
			Amount = 80,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "BeastLeather",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_ice", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "BeastLeather",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_ice", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "BeastLeather",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_ice", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 MageRobes
		{
			Recipe = "MageRobes",
			Material = "QuiltedCloth",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_ice", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--150s
		--150 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "QuiltedCloth",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "QuiltedCloth",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "QuiltedCloth",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "QuiltedCloth",
			Amount = 100,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "QuiltedCloth",
			Amount = 100,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LinenChest
		{
			Recipe = "LinenChest",
			Material = "QuiltedCloth",
			Amount = 100,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "BeastLeather",
			Amount = 100,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_ice", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "BeastLeather",
			Amount = 100,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_ice", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "BeastLeather",
			Amount = 100,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_ice", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "BeastLeather",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_blaze", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "BeastLeather",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_blaze", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "BeastLeather",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_blaze", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 MageRobes
		{
			Recipe = "MageRobes",
			Material = "QuiltedCloth",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_blaze", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--40 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "SilkCloth",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "SilkCloth",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "SilkCloth",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "SilkCloth",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "SilkCloth",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LinenChest
		{
			Recipe = "LinenChest",
			Material = "SilkCloth",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "VileLeather",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "VileLeather",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "VileLeather",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "VileLeather",
			Amount = 40,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "VileLeather",
			Amount = 40,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "VileLeather",
			Amount = 40,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 MageRobes
		{
			Recipe = "MageRobes",
			Material = "SilkCloth",
			Amount = 40,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--80s
		--80 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "SilkCloth",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "SilkCloth",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "SilkCloth",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_fabric_rack", Packed = true, Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "SilkCloth",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "SilkCloth",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LinenChest
		{
			Recipe = "LinenChest",
			Material = "SilkCloth",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "VileLeather",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "VileLeather",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "VileLeather",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "VileLeather",
			Amount = 60,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "VileLeather",
			Amount = 60,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_ice", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "VileLeather",
			Amount = 60,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_ice", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 MageRobes
		{
			Recipe = "MageRobes",
			Material = "SilkCloth",
			Amount = 60,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_ice", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--120s
		--120 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "SilkCloth",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "SilkCloth",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "SilkCloth",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_shade", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "SilkCloth",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "SilkCloth",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LinenChest
		{
			Recipe = "LinenChest",
			Material = "SilkCloth",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "VileLeather",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_ice", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "VileLeather",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_ice", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "Leather",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_ice", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "VileLeather",
			Amount = 80,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_blaze", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "VileLeather",
			Amount = 80,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_blaze", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "VileLeather",
			Amount = 80,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_blaze", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--120 MageRobes
		{
			Recipe = "MageRobes",
			Material = "SilkCloth",
			Amount = 80,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_blaze", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--150s
		--150 PaddedHelm
		{
			Recipe = "PaddedHelm",
			Material = "SilkCloth",
			Amount = 100,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 PaddedLegs
		{
			Recipe = "PaddedLegs",
			Material = "SilkCloth",
			Amount = 100,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 PaddedChest
		{
			Recipe = "PaddedChest",
			Material = "SilkCloth",
			Amount = 100,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_crimson", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LinenHelm
		{
			Recipe = "LinenHelm",
			Material = "SilkCloth",
			Amount = 100,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LinenLegs
		{
			Recipe = "LinenLegs",
			Material = "SilkCloth",
			Amount = 100,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LinenChest
		{
			Recipe = "LinenChest",
			Material = "SilkCloth",
			Amount = 100,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_vile", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LeatherHelm
		{
			Recipe = "LeatherHelm",
			Material = "VileLeather",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_blaze", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LeatherLegs
		{
			Recipe = "LeatherLegs",
			Material = "VileLeather",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_blaze", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 LeatherChest
		{
			Recipe = "LeatherChest",
			Material = "VileLeather",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "clothing_dye_blaze", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 HardenedHood
		{
			Recipe = "HardenedHood",
			Material = "VileLeather",
			Amount = 100,

			RewardCoins = "fourteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "bless_deed", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 HardenedLeggings
		{
			Recipe = "HardenedLeggings",
			Material = "VileLeather",
			Amount = 100,

			RewardCoins = "fourteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "bless_deed", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 HardenedChest
		{
			Recipe = "HardenedChest",
			Material = "VileLeather",
			Amount = 100,

			RewardCoins = "fourteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "bless_deed", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--150 MageRobes
		{
			Recipe = "MageRobes",
			Material = "SilkCloth",
			Amount = 100,

			RewardCoins = "fourteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "bless_deed", Unique = true },
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},
	}
}