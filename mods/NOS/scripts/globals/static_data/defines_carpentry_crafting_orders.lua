CraftingOrderDefines.WoodsmithSkill = 
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
				{ Weight = 10, Template = "recipe_longbow", Unique = true},
				{ Weight = 10, Template = "recipe_warbow", Unique = true},
				{ Weight = 10, Template = "recipe_stoolwooden", Unique = true},
				{ Weight = 10, Template = "recipe_chairfancy", Unique = true},
				{ Weight = 10, Template = "recipe_benchfancy", Unique = true},
				{ Weight = 10, Template = "recipe_smallfence", Unique = true},
				{ Weight = 10, Template = "recipe_fencedoor", Unique = true},
				{ Weight = 10, Template = "recipe_barrel", Unique = true},
				{ Weight = 10, Template = "recipe_lockbox", Unique = true},
				{ Weight = 10, Template = "recipe_shelf", Unique = true},
				{ Weight = 10, Template = "recipe_largewoodentable", Unique = true},
				{ Weight = 10, Template = "recipe_roundtable", Unique = true},
				{ Weight = 10, Template = "recipe_inntable", Unique = true},
				{ Weight = 10, Template = "recipe_dresser", Unique = true},
				{ Weight = 10, Template = "recipe_tablewoodenlarge", Unique = true},
				{ Weight = 10, Template = "recipe_deskfancy", Unique = true},
				{ Weight = 10, Template = "recipe_bedsmall", Unique = true},
				{ Weight = 10, Template = "recipe_bedmedium", Unique = true},
				{ Weight = 10, Template = "recipe_bedlarge", Unique = true},
				{ Weight = 10, Template = "recipe_anvil", Unique = true},
				{ Weight = 10, Template = "recipe_forge", Unique = true},
				{ Weight = 10, Template = "recipe_alchemytable", Unique = true},
				{ Weight = 10, Template = "recipe_inscriptiontable", Unique = true},
				{ Weight = 10, Template = "recipe_woodsmithtable", Unique = true},
				{ Weight = 10, Template = "recipe_loom", Unique = true},
				{ Weight = 10, Template = "recipe_stove", Unique = true},
				{ Weight = 10, Template = "recipe_fireplacestone", Unique = true},
				{ Weight = 10, Template = "recipe_buckler", Unique = true},
				{ Weight = 10, Template = "recipe_kiteshield", Unique = true},
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
		Default = 60,
		Boards = 60,
		Ash = 39,
		Blightwood = 1,
	},

	CraftingOrders = 
	{
	
	--SMALL ORDERS


	--Small Furniture & Tools

	--5s

		--5 Torch
		{
			Recipe = "Torch",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 Crook
		{
			Recipe = "Crook",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--5 FishingRod
		{
			Recipe = "FishingRod",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--5 StoolWooden
		{
			Recipe = "StoolWooden",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 ChairWooden
		{
			Recipe = "ChairWooden",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 ChairFancy
		{
			Recipe = "ChairFancy",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 BenchFancy
		{
			Recipe = "BenchFancy",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 SmallFence
		{
			Recipe = "SmallFence",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 FenceDoor
		{
			Recipe = "FenceDoor",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 Barrel
		{
			Recipe = "Barrel",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 Chest
		{
			Recipe = "Chest",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 Crate
		{
			Recipe = "Crate",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 Lockbox
		{
			Recipe = "Lockbox",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 Shelf
		{
			Recipe = "Shelf",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 TableWooden
		{
			Recipe = "TableWooden",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 TableWoodenLarge
		{
			Recipe = "TableWoodenLarge",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 TableRound
		{
			Recipe = "TableRound",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 TableInn
		{
			Recipe = "TableInn",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 Dresser
		{
			Recipe = "Dresser",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 BookshelfWooden
		{
			Recipe = "BookshelfWooden",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--5 DeskFancy
		{
			Recipe = "DeskFancy",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--10s

		--10 Torch
		{
			Recipe = "Torch",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 Crook
		{
			Recipe = "Crook",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--10 FishingRod
		{
			Recipe = "FishingRod",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--10 StoolWooden
		{
			Recipe = "StoolWooden",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 ChairWooden
		{
			Recipe = "ChairWooden",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 ChairFancy
		{
			Recipe = "ChairFancy",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 BenchFancy
		{
			Recipe = "BenchFancy",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 SmallFence
		{
			Recipe = "SmallFence",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 FenceDoor
		{
			Recipe = "FenceDoor",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 Barrel
		{
			Recipe = "Barrel",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 Chest
		{
			Recipe = "Chest",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 Crate
		{
			Recipe = "Crate",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 Lockbox
		{
			Recipe = "Lockbox",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 Shelf
		{
			Recipe = "Shelf",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 TableWooden
		{
			Recipe = "TableWooden",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 TableWoodenLarge
		{
			Recipe = "TableWoodenLarge",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 TableRound
		{
			Recipe = "TableRound",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 TableInn
		{
			Recipe = "TableInn",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 Dresser
		{
			Recipe = "Dresser",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 BookshelfWooden
		{
			Recipe = "BookshelfWooden",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--10 DeskFancy
		{
			Recipe = "DeskFancy",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--15s

		--15 Torch
		{
			Recipe = "Torch",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 Crook
		{
			Recipe = "Crook",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--15 FishingRod
		{
			Recipe = "FishingRod",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--15 StoolWooden
		{
			Recipe = "StoolWooden",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 ChairWooden
		{
			Recipe = "ChairWooden",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 ChairFancy
		{
			Recipe = "ChairFancy",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 BenchFancy
		{
			Recipe = "BenchFancy",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 SmallFence
		{
			Recipe = "SmallFence",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 FenceDoor
		{
			Recipe = "FenceDoor",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 Barrel
		{
			Recipe = "Barrel",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 Chest
		{
			Recipe = "Chest",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 Crate
		{
			Recipe = "Crate",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 Lockbox
		{
			Recipe = "Lockbox",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 Shelf
		{
			Recipe = "Shelf",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 TableWooden
		{
			Recipe = "TableWooden",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 TableWoodenLarge
		{
			Recipe = "TableWoodenLarge",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 TableRound
		{
			Recipe = "TableRound",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 TableInn
		{
			Recipe = "TableInn",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 Dresser
		{
			Recipe = "Dresser",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 BookshelfWooden
		{
			Recipe = "BookshelfWooden",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--15 DeskFancy
		{
			Recipe = "DeskFancy",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--20s

		--20 Torch
		{
			Recipe = "Torch",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 Crook
		{
			Recipe = "Crook",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--20 FishingRod
		{
			Recipe = "FishingRod",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--20 StoolWooden
		{
			Recipe = "StoolWooden",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 ChairWooden
		{
			Recipe = "ChairWooden",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 ChairFancy
		{
			Recipe = "ChairFancy",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 BenchFancy
		{
			Recipe = "BenchFancy",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 SmallFence
		{
			Recipe = "SmallFence",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 FenceDoor
		{
			Recipe = "FenceDoor",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 Barrel
		{
			Recipe = "Barrel",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 Chest
		{
			Recipe = "Chest",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 Crate
		{
			Recipe = "Crate",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 Lockbox
		{
			Recipe = "Lockbox",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 Shelf
		{
			Recipe = "Shelf",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 TableWooden
		{
			Recipe = "TableWooden",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 TableWoodenLarge
		{
			Recipe = "TableWoodenLarge",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 TableRound
		{
			Recipe = "TableRound",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 TableInn
		{
			Recipe = "TableInn",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 Dresser
		{
			Recipe = "Dresser",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 BookshelfWooden
		{
			Recipe = "BookshelfWooden",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--20 DeskFancy
		{
			Recipe = "DeskFancy",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMin = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},


	--Large Furniture & Tools

	--40s

		--40 Torch
		{
			Recipe = "Torch",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 Crook
		{
			Recipe = "Crook",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--40 FishingRod
		{
			Recipe = "FishingRod",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--40 StoolWooden
		{
			Recipe = "StoolWooden",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 ChairWooden
		{
			Recipe = "ChairWooden",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 ChairFancy
		{
			Recipe = "ChairFancy",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 BenchFancy
		{
			Recipe = "BenchFancy",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 SmallFence
		{
			Recipe = "SmallFence",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 FenceDoor
		{
			Recipe = "FenceDoor",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 Barrel
		{
			Recipe = "Barrel",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 Chest
		{
			Recipe = "Chest",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 Crate
		{
			Recipe = "Crate",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 Lockbox
		{
			Recipe = "Lockbox",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 Shelf
		{
			Recipe = "Shelf",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 TableWooden
		{
			Recipe = "TableWooden",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 TableWoodenLarge
		{
			Recipe = "TableWoodenLarge",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 TableRound
		{
			Recipe = "TableRound",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 TableInn
		{
			Recipe = "TableInn",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 Dresser
		{
			Recipe = "Dresser",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 BookshelfWooden
		{
			Recipe = "BookshelfWooden",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--40 DeskFancy
		{
			Recipe = "DeskFancy",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--60s

		--60 Torch
		{
			Recipe = "Torch",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 Crook
		{
			Recipe = "Crook",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--60 FishingRod
		{
			Recipe = "FishingRod",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--60 StoolWooden
		{
			Recipe = "StoolWooden",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 ChairWooden
		{
			Recipe = "ChairWooden",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 ChairFancy
		{
			Recipe = "ChairFancy",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 BenchFancy
		{
			Recipe = "BenchFancy",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 SmallFence
		{
			Recipe = "SmallFence",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 FenceDoor
		{
			Recipe = "FenceDoor",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 Barrel
		{
			Recipe = "Barrel",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 Chest
		{
			Recipe = "Chest",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 Crate
		{
			Recipe = "Crate",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 Lockbox
		{
			Recipe = "Lockbox",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 Shelf
		{
			Recipe = "Shelf",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 TableWooden
		{
			Recipe = "TableWooden",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 TableWoodenLarge
		{
			Recipe = "TableWoodenLarge",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 TableRound
		{
			Recipe = "TableRound",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 TableInn
		{
			Recipe = "TableInn",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 Dresser
		{
			Recipe = "Dresser",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 BookshelfWooden
		{
			Recipe = "BookshelfWooden",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--60 DeskFancy
		{
			Recipe = "DeskFancy",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--80s

		--80 Torch
		{
			Recipe = "Torch",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 Crook
		{
			Recipe = "Crook",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--80 FishingRod
		{
			Recipe = "FishingRod",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--80 StoolWooden
		{
			Recipe = "StoolWooden",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 ChairWooden
		{
			Recipe = "ChairWooden",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 ChairFancy
		{
			Recipe = "ChairFancy",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 BenchFancy
		{
			Recipe = "BenchFancy",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 SmallFence
		{
			Recipe = "SmallFence",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 FenceDoor
		{
			Recipe = "FenceDoor",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 Barrel
		{
			Recipe = "Barrel",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 Chest
		{
			Recipe = "Chest",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 Crate
		{
			Recipe = "Crate",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 Lockbox
		{
			Recipe = "Lockbox",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 Shelf
		{
			Recipe = "Shelf",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 TableWooden
		{
			Recipe = "TableWooden",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 TableWoodenLarge
		{
			Recipe = "TableWoodenLarge",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 TableRound
		{
			Recipe = "TableRound",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 TableInn
		{
			Recipe = "TableInn",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 Dresser
		{
			Recipe = "Dresser",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 BookshelfWooden
		{
			Recipe = "BookshelfWooden",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--80 DeskFancy
		{
			Recipe = "DeskFancy",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--100s

		--100 Torch
		{
			Recipe = "Torch",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 Crook
		{
			Recipe = "Crook",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--100 FishingRod
		{
			Recipe = "FishingRod",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,		
			},
		},

		--100 StoolWooden
		{
			Recipe = "StoolWooden",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 ChairWooden
		{
			Recipe = "ChairWooden",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 ChairFancy
		{
			Recipe = "ChairFancy",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 BenchFancy
		{
			Recipe = "BenchFancy",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 SmallFence
		{
			Recipe = "SmallFence",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 FenceDoor
		{
			Recipe = "FenceDoor",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 Barrel
		{
			Recipe = "Barrel",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 Chest
		{
			Recipe = "Chest",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 Crate
		{
			Recipe = "Crate",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 Lockbox
		{
			Recipe = "Lockbox",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 Shelf
		{
			Recipe = "Shelf",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 TableWooden
		{
			Recipe = "TableWooden",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 TableWoodenLarge
		{
			Recipe = "TableWoodenLarge",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 TableRound
		{
			Recipe = "TableRound",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 TableInn
		{
			Recipe = "TableInn",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 Dresser
		{
			Recipe = "Dresser",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 BookshelfWooden
		{
			Recipe = "BookshelfWooden",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

		--100 DeskFancy
		{
			Recipe = "DeskFancy",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},
				--Reward 2
				CraftingOrderRecipes,	
			},
		},

	--Small Weapons

	--Arrows

		--5 Arrow
		{
			Recipe = "Arrow",
			Amount = 5,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 Arrow
		{
			Recipe = "Arrow",
			Amount = 10,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 Arrow
		{
			Recipe = "Arrow",
			Amount = 15,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 Arrow
		{
			Recipe = "Arrow",
			Amount = 20,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--Arrows Ash

		--5 Arrow
		{
			Recipe = "Arrow",
			Material = "AshBoards",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 Arrow
		{
			Recipe = "Arrow",
			Material = "AshBoards",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 Arrow
		{
			Recipe = "Arrow",
			Material = "AshBoards",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 Arrow
		{
			Recipe = "Arrow",
			Material = "AshBoards",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--Arrows Blight

		--5 Arrow
		{
			Recipe = "Arrow",
			Material = "BlightwoodBoards",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 Arrow
		{
			Recipe = "Arrow",
			Material = "BlightwoodBoards",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 Arrow
		{
			Recipe = "Arrow",
			Material = "BlightwoodBoards",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 Arrow
		{
			Recipe = "Arrow",
			Material = "BlightwoodBoards",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--Shields

	--SmallShield

		--5 SmallShield
		{
			Recipe = "SmallShield",
			Material = "Boards",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 SmallShield
		{
			Recipe = "SmallShield",
			Material = "Boards",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 SmallShield
		{
			Recipe = "SmallShield",
			Material = "Boards",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 SmallShield
		{
			Recipe = "SmallShield",
			Material = "Boards",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--SmallShield Ash

		--5 SmallShield
		{
			Recipe = "SmallShield",
			Material = "AshBoards",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 SmallShield
		{
			Recipe = "SmallShield",
			Material = "AshBoards",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 SmallShield
		{
			Recipe = "SmallShield",
			Material = "AshBoards",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 SmallShield
		{
			Recipe = "SmallShield",
			Material = "AshBoards",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--SmallShield Blight

		--5 SmallShield
		{
			Recipe = "SmallShield",
			Material = "BlightwoodBoards",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 SmallShield
		{
			Recipe = "SmallShield",
			Material = "BlightwoodBoards",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 SmallShield
		{
			Recipe = "SmallShield",
			Material = "BlightwoodBoards",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 SmallShield
		{
			Recipe = "SmallShield",
			Material = "BlightwoodBoards",
			Amount = 20,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--Buckler

		--5 Buckler
		{
			Recipe = "Buckler",
			Material = "Boards",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 Buckler
		{
			Recipe = "Buckler",
			Material = "Boards",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 Buckler
		{
			Recipe = "Buckler",
			Material = "Boards",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 Buckler
		{
			Recipe = "Buckler",
			Material = "Boards",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--Buckler Ash

		--5 Buckler
		{
			Recipe = "Buckler",
			Material = "AshBoards",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 Buckler
		{
			Recipe = "Buckler",
			Material = "AshBoards",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 Buckler
		{
			Recipe = "Buckler",
			Material = "AshBoards",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 Buckler
		{
			Recipe = "Buckler",
			Material = "AshBoards",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--Buckler Blight

		--5 Buckler
		{
			Recipe = "Buckler",
			Material = "BlightwoodBoards",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 Buckler
		{
			Recipe = "Buckler",
			Material = "BlightwoodBoards",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 Buckler
		{
			Recipe = "Buckler",
			Material = "BlightwoodBoards",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 Buckler
		{
			Recipe = "Buckler",
			Material = "BlightwoodBoards",
			Amount = 20,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},






	--KiteShield

		--5 KiteShield
		{
			Recipe = "KiteShield",
			Material = "Boards",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 KiteShield
		{
			Recipe = "KiteShield",
			Material = "Boards",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 KiteShield
		{
			Recipe = "KiteShield",
			Material = "Boards",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 KiteShield
		{
			Recipe = "KiteShield",
			Material = "Boards",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--KiteShield Ash

		--5 KiteShield
		{
			Recipe = "KiteShield",
			Material = "AshBoards",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 KiteShield
		{
			Recipe = "KiteShield",
			Material = "AshBoards",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 KiteShield
		{
			Recipe = "KiteShield",
			Material = "AshBoards",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 KiteShield
		{
			Recipe = "KiteShield",
			Material = "AshBoards",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--KiteShield Blight

		--5 KiteShield
		{
			Recipe = "KiteShield",
			Material = "BlightwoodBoards",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 KiteShield
		{
			Recipe = "KiteShield",
			Material = "BlightwoodBoards",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 KiteShield
		{
			Recipe = "KiteShield",
			Material = "BlightwoodBoards",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 KiteShield
		{
			Recipe = "KiteShield",
			Material = "BlightwoodBoards",
			Amount = 20,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},





	--Bow

	--ShortBow

		--5 ShortBow
		{
			Recipe = "ShortBow",
			Material = "Boards",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 ShortBow
		{
			Recipe = "ShortBow",
			Material = "Boards",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 ShortBow
		{
			Recipe = "ShortBow",
			Material = "Boards",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 5, StackCountMax = 10 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 ShortBow
		{
			Recipe = "ShortBow",
			Material = "Boards",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 5, StackCountMax = 10 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--ShortBow Ash

		--5 ShortBow
		{
			Recipe = "ShortBow",
			Material = "AshBoards",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 ShortBow
		{
			Recipe = "ShortBow",
			Material = "AshBoards",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 ShortBow
		{
			Recipe = "ShortBow",
			Material = "AshBoards",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 ShortBow
		{
			Recipe = "ShortBow",
			Material = "AshBoards",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--ShortBow Blight

		--5 ShortBow
		{
			Recipe = "ShortBow",
			Material = "BlightwoodBoards",
			Amount = 5,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 ShortBow
		{
			Recipe = "ShortBow",
			Material = "BlightwoodBoards",
			Amount = 10,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 ShortBow
		{
			Recipe = "ShortBow",
			Material = "BlightwoodBoards",
			Amount = 15,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 ShortBow
		{
			Recipe = "ShortBow",
			Material = "BlightwoodBoards",
			Amount = 20,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_library_table", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--LongBow

		--5 LongBow
		{
			Recipe = "LongBow",
			Material = "Boards",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 LongBow
		{
			Recipe = "LongBow",
			Material = "Boards",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 LongBow
		{
			Recipe = "LongBow",
			Material = "Boards",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 5, StackCountMax = 10 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 LongBow
		{
			Recipe = "LongBow",
			Material = "Boards",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 5, StackCountMax = 10 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--LongBow Ash

		--5 LongBow
		{
			Recipe = "LongBow",
			Material = "AshBoards",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 LongBow
		{
			Recipe = "LongBow",
			Material = "AshBoards",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 LongBow
		{
			Recipe = "LongBow",
			Material = "AshBoards",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 LongBow
		{
			Recipe = "LongBow",
			Material = "AshBoards",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--LongBow Blight

		--5 LongBow
		{
			Recipe = "LongBow",
			Material = "BlightwoodBoards",
			Amount = 5,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 LongBow
		{
			Recipe = "LongBow",
			Material = "BlightwoodBoards",
			Amount = 10,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 LongBow
		{
			Recipe = "LongBow",
			Material = "BlightwoodBoards",
			Amount = 15,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 LongBow
		{
			Recipe = "LongBow",
			Material = "BlightwoodBoards",
			Amount = 20,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_library_table", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--WarBow

		--5 WarBow
		{
			Recipe = "WarBow",
			Material = "Boards",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 WarBow
		{
			Recipe = "WarBow",
			Material = "Boards",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_boards_ash", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 WarBow
		{
			Recipe = "WarBow",
			Material = "Boards",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 5, StackCountMax = 10 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 WarBow
		{
			Recipe = "WarBow",
			Material = "Boards",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 5, StackCountMax = 10 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--WarBow Ash

		--5 WarBow
		{
			Recipe = "WarBow",
			Material = "AshBoards",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 WarBow
		{
			Recipe = "WarBow",
			Material = "AshBoards",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 WarBow
		{
			Recipe = "WarBow",
			Material = "AshBoards",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 WarBow
		{
			Recipe = "WarBow",
			Material = "AshBoards",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--WarBow Blight

		--5 WarBow
		{
			Recipe = "WarBow",
			Material = "BlightwoodBoards",
			Amount = 5,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 WarBow
		{
			Recipe = "WarBow",
			Material = "BlightwoodBoards",
			Amount = 10,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 WarBow
		{
			Recipe = "WarBow",
			Material = "BlightwoodBoards",
			Amount = 15,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 WarBow
		{
			Recipe = "WarBow",
			Material = "BlightwoodBoards",
			Amount = 20,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_library_table", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},




	--Large Weapons

	--Arrows

		--40 Arrow
		{
			Recipe = "Arrow",
			Amount = 40,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 5, StackCountMax = 10 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 Arrow
		{
			Recipe = "Arrow",
			Amount = 60,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 5, StackCountMax = 10 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 Arrow
		{
			Recipe = "Arrow",
			Amount = 80,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 Arrow
		{
			Recipe = "Arrow",
			Amount = 100,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--Arrows Ash

		--40 Arrow
		{
			Recipe = "Arrow",
			Material = "AshBoards",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 Arrow
		{
			Recipe = "Arrow",
			Material = "AshBoards",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 Arrow
		{
			Recipe = "Arrow",
			Material = "AshBoards",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 Arrow
		{
			Recipe = "Arrow",
			Material = "AshBoards",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--Arrows Blight

		--40 Arrow
		{
			Recipe = "Arrow",
			Material = "BlightwoodBoards",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 Arrow
		{
			Recipe = "Arrow",
			Material = "BlightwoodBoards",
			Amount = 60,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_library_table", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 Arrow
		{
			Recipe = "Arrow",
			Material = "BlightwoodBoards",
			Amount = 80,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_tool_board_oak", Unique = true },
	    				{ Weight = 10, Template = "arena_dummy", Unique = true },
					},
				},
				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--100 Arrow
		{
			Recipe = "Arrow",
			Material = "BlightwoodBoards",
			Amount = 100,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "cellar_chest_tall", Packed = true, Unique = true},
					},
				},

				--Reward 3
				CraftingOrderRecipes,
			},
		},

	--Shields

	--SmallShield

		--40 SmallShield
		{
			Recipe = "SmallShield",
			Material = "Boards",
			Amount = 40,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 SmallShield
		{
			Recipe = "SmallShield",
			Material = "Boards",
			Amount = 60,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 SmallShield
		{
			Recipe = "SmallShield",
			Material = "Boards",
			Amount = 80,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 SmallShield
		{
			Recipe = "SmallShield",
			Material = "Boards",
			Amount = 100,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--SmallShield Ash

		--40 SmallShield
		{
			Recipe = "SmallShield",
			Material = "AshBoards",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 SmallShield
		{
			Recipe = "SmallShield",
			Material = "AshBoards",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 SmallShield
		{
			Recipe = "SmallShield",
			Material = "AshBoards",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 SmallShield
		{
			Recipe = "SmallShield",
			Material = "AshBoards",
			Amount = 100,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--SmallShield Blight

		--40 SmallShield
		{
			Recipe = "SmallShield",
			Material = "BlightwoodBoards",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_library_table", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 SmallShield
		{
			Recipe = "SmallShield",
			Material = "BlightwoodBoards",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_tool_board_oak", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "arena_dummy", Packed = true, Unique = true},
					},
				},

				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--80 SmallShield
		{
			Recipe = "SmallShield",
			Material = "BlightwoodBoards",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "cellar_chest_tall", Packed = true, Unique = true},
					},
				},

				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--100 SmallShield
		{
			Recipe = "SmallShield",
			Material = "BlightwoodBoards",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_tent_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "furniture_globe", Packed = true, Unique = true},
					},
				},

				--Reward 3
				CraftingOrderRecipes,
			},
		},

	--Buckler

		--40 Buckler
		{
			Recipe = "Buckler",
			Material = "Boards",
			Amount = 40,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 Buckler
		{
			Recipe = "Buckler",
			Material = "Boards",
			Amount = 60,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 Buckler
		{
			Recipe = "Buckler",
			Material = "Boards",
			Amount = 80,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 Buckler
		{
			Recipe = "Buckler",
			Material = "Boards",
			Amount = 100,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--Buckler Ash

		--40 Buckler
		{
			Recipe = "Buckler",
			Material = "AshBoards",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 Buckler
		{
			Recipe = "Buckler",
			Material = "AshBoards",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 Buckler
		{
			Recipe = "Buckler",
			Material = "AshBoards",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 Buckler
		{
			Recipe = "Buckler",
			Material = "AshBoards",
			Amount = 100,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--Buckler Blight

		--40 Buckler
		{
			Recipe = "Buckler",
			Material = "BlightwoodBoards",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_library_table", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 Buckler
		{
			Recipe = "Buckler",
			Material = "BlightwoodBoards",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_tool_board_oak", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "arena_dummy", Packed = true, Unique = true},
					},
				},

				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--80 Buckler
		{
			Recipe = "Buckler",
			Material = "BlightwoodBoards",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "cellar_chest_tall", Packed = true, Unique = true},
					},
				},


				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--100 Buckler
		{
			Recipe = "Buckler",
			Material = "BlightwoodBoards",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_tent_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "furniture_globe", Packed = true, Unique = true},
					},
				},

				--Reward 3
				CraftingOrderRecipes,
			},
		},

	--KiteShield

		--40 KiteShield
		{
			Recipe = "KiteShield",
			Material = "Boards",
			Amount = 40,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 KiteShield
		{
			Recipe = "KiteShield",
			Material = "Boards",
			Amount = 60,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "resource_blightwood_boards", Unique = true, StackCountMin = 10, StackCountMax = 20 },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 KiteShield
		{
			Recipe = "KiteShield",
			Material = "Boards",
			Amount = 80,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 KiteShield
		{
			Recipe = "KiteShield",
			Material = "Boards",
			Amount = 100,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--KiteShield Ash

		--40 KiteShield
		{
			Recipe = "KiteShield",
			Material = "AshBoards",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 KiteShield
		{
			Recipe = "KiteShield",
			Material = "AshBoards",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 KiteShield
		{
			Recipe = "KiteShield",
			Material = "AshBoards",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 KiteShield
		{
			Recipe = "KiteShield",
			Material = "AshBoards",
			Amount = 100,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--KiteShield Blight

		--40 KiteShield
		{
			Recipe = "KiteShield",
			Material = "BlightwoodBoards",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_library_table", Packed = true, Unique = true},
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 KiteShield
		{
			Recipe = "KiteShield",
			Material = "BlightwoodBoards",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_tool_board_oak", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "arena_dummy", Packed = true, Unique = true},
					},
				},

				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--80 KiteShield
		{
			Recipe = "KiteShield",
			Material = "BlightwoodBoards",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "cellar_chest_tall", Packed = true, Unique = true},
					},
				},

				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--100 KiteShield
		{
			Recipe = "KiteShield",
			Material = "BlightwoodBoards",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_tent_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "furniture_globe", Packed = true, Unique = true},
					},
				},


				--Reward 3
				CraftingOrderRecipes,
			},
		},

	





	--Bow

	--ShortBow

		--40 ShortBow
		{
			Recipe = "ShortBow",
			Material = "Boards",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 ShortBow
		{
			Recipe = "ShortBow",
			Material = "Boards",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ShortBow
		{
			Recipe = "ShortBow",
			Material = "Boards",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 ShortBow
		{
			Recipe = "ShortBow",
			Material = "Boards",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--ShortBow Ash

		--40 ShortBow
		{
			Recipe = "ShortBow",
			Material = "AshBoards",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 ShortBow
		{
			Recipe = "ShortBow",
			Material = "AshBoards",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ShortBow
		{
			Recipe = "ShortBow",
			Material = "AshBoards",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_library_table", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 ShortBow
		{
			Recipe = "ShortBow",
			Material = "AshBoards",
			Amount = 100,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_library_table", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--ShortBow Blight

		--40 ShortBow
		{
			Recipe = "ShortBow",
			Material = "BlightwoodBoards",
			Amount = 40,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_tool_board_oak", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "arena_dummy", Packed = true, Unique = true},
					},
				},


				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--60 ShortBow
		{
			Recipe = "ShortBow",
			Material = "BlightwoodBoards",
			Amount = 60,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "cellar_chest_tall", Packed = true, Unique = true},
					},
				},


				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--80 ShortBow
		{
			Recipe = "ShortBow",
			Material = "BlightwoodBoards",
			Amount = 80,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_tent_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "furniture_globe", Packed = true, Unique = true},
					},
				},

				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--100 ShortBow
		{
			Recipe = "ShortBow",
			Material = "BlightwoodBoards",
			Amount = 100,

			RewardCoins = "fourteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_square_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "furniture_stone_table", Packed = true, Unique = true},
					},
				},

				--Reward 3
				CraftingOrderRecipes,
			},
		},



	--LongBow

		--40 LongBow
		{
			Recipe = "LongBow",
			Material = "Boards",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 LongBow
		{
			Recipe = "LongBow",
			Material = "Boards",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 LongBow
		{
			Recipe = "LongBow",
			Material = "Boards",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 LongBow
		{
			Recipe = "LongBow",
			Material = "Boards",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--LongBow Ash

		--40 LongBow
		{
			Recipe = "LongBow",
			Material = "AshBoards",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 LongBow
		{
			Recipe = "LongBow",
			Material = "AshBoards",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 LongBow
		{
			Recipe = "LongBow",
			Material = "AshBoards",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_library_table", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 LongBow
		{
			Recipe = "LongBow",
			Material = "AshBoards",
			Amount = 100,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_library_table", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--LongBow Blight

		--40 LongBow
		{
			Recipe = "LongBow",
			Material = "BlightwoodBoards",
			Amount = 40,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_tool_board_oak", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "arena_dummy", Packed = true, Unique = true},
					},
				},

				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--60 LongBow
		{
			Recipe = "LongBow",
			Material = "BlightwoodBoards",
			Amount = 60,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "cellar_chest_tall", Packed = true, Unique = true},
					},
				},


				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--80 LongBow
		{
			Recipe = "LongBow",
			Material = "BlightwoodBoards",
			Amount = 80,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_tent_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "furniture_globe", Packed = true, Unique = true},
					},
				},

				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--100 LongBow
		{
			Recipe = "LongBow",
			Material = "BlightwoodBoards",
			Amount = 100,

			RewardCoins = "fourteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_square_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "furniture_stone_table", Packed = true, Unique = true},
					},
				},


				--Reward 3
				CraftingOrderRecipes,
			},
		},



	--WarBow

		--40 WarBow
		{
			Recipe = "WarBow",
			Material = "Boards",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 WarBow
		{
			Recipe = "WarBow",
			Material = "Boards",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_weapon_rack", unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 WarBow
		{
			Recipe = "WarBow",
			Material = "Boards",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 WarBow
		{
			Recipe = "WarBow",
			Material = "Boards",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_ornate_drawer", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--WarBow Ash

		--40 WarBow
		{
			Recipe = "WarBow",
			Material = "AshBoards",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--60 WarBow
		{
			Recipe = "WarBow",
			Material = "AshBoards",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_table_cloth", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 WarBow
		{
			Recipe = "WarBow",
			Material = "AshBoards",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_library_table", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 WarBow
		{
			Recipe = "WarBow",
			Material = "AshBoards",
			Amount = 100,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "furniture_library_table", Unique = true },
					},
				},

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--WarBow Blight

		--40 WarBow
		{
			Recipe = "WarBow",
			Material = "BlightwoodBoards",
			Amount = 40,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_tool_board_oak", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "arena_dummy", Packed = true, Unique = true},
					},
				},


				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--60 WarBow
		{
			Recipe = "WarBow",
			Material = "BlightwoodBoards",
			Amount = 60,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "cellar_chest_tall", Packed = true, Unique = true},
					},
				},
				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--80 WarBow
		{
			Recipe = "WarBow",
			Material = "BlightwoodBoards",
			Amount = 80,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_tent_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "furniture_globe", Packed = true, Unique = true},
					},
				},

				--Reward 3
				CraftingOrderRecipes,
			},
		},

		--100 WarBow
		{
			Recipe = "WarBow",
			Material = "BlightwoodBoards",
			Amount = 100,

			RewardCoins = "fourteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 90, Template = "furniture_square_market_stall", Packed = true, Unique = true},
	    				{ Weight = 10, Template = "furniture_stone_table", Packed = true, Unique = true},
					},
				},

				--Reward 3
				CraftingOrderRecipes,
			},
		},
	}
}