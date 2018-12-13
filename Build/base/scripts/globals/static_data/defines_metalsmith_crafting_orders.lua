CraftingOrderDefines.MetalsmithSkill = 
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
				{ Weight = 10, Template = "recipe_kryss", Unique = true},
				{ Weight = 10, Template = "recipe_poniard", Unique = true},
				{ Weight = 10, Template = "recipe_bonedagger", Unique = true},
				{ Weight = 10, Template = "recipe_broadsword", Unique = true},
				{ Weight = 10, Template = "recipe_saber", Unique = true},
				{ Weight = 10, Template = "recipe_katana", Unique = true},
				{ Weight = 10, Template = "recipe_hammer", Unique = true},
				{ Weight = 10, Template = "recipe_greataxe", Unique = true},
				{ Weight = 10, Template = "recipe_maul", Unique = true},
				{ Weight = 10, Template = "recipe_largeaxe", Unique = true},
				{ Weight = 10, Template = "recipe_warmace", Unique = true},
				{ Weight = 10, Template = "recipe_voulge", Unique = true},
				{ Weight = 10, Template = "recipe_spear", Unique = true},
				{ Weight = 10, Template = "recipe_scalehelm", Unique = true},
				{ Weight = 10, Template = "recipe_warhammer", Unique = true},
				{ Weight = 10, Template = "recipe_halberd", Unique = true},
				{ Weight = 10, Template = "recipe_scalelegs", Unique = true},
				{ Weight = 10, Template = "recipe_scaletunic", Unique = true},
				{ Weight = 10, Template = "recipe_fullplatehelm", Unique = true},
				{ Weight = 10, Template = "recipe_fullplatelegs", Unique = true},
				{ Weight = 10, Template = "recipe_fullplatetunic", Unique = true},
				{ Weight = 10, Template = "recipe_cobalt", Unique = true},
				{ Weight = 10, Template = "recipe_obsidian", Unique = true},
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
		Default = 50,
		Iron = 50,
		Copper = 35,
		Gold = 20,
		Cobalt = 4,
		Obsidian = 1,
	},

	CraftingOrders = 
	{
	
	--SMALL ORDERS

	--WEAPONS

		--5 IronGreataxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronLongsword
		{
			Recipe = "Longsword",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronBroadsword
		{
			Recipe = "Broadsword",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},				
			},
		},

		--5 IronSaber
		{
			Recipe = "Saber",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},				
			},
		},

		--5 IronKatana
		{
			Recipe = "Katana",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},				
			},
		},

		--5 IronDagger
		{
			Recipe = "Dagger",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronKryss
		{
			Recipe = "Kryss",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronPoniard
		{
			Recipe = "Poniard",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronBoneDagger
		{
			Recipe = "BoneDagger",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronMace
		{
			Recipe = "Mace",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronHammer
		{
			Recipe = "Hammer",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronMaul
		{
			Recipe = "Maul",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronWarMace
		{
			Recipe = "WarMace",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronQuarterstaff
		{
			Recipe = "Quarterstaff",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronWarhammer
		{
			Recipe = "Warhammer",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronPitchfork
		{
			Recipe = "Pitchfork",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronVouge
		{
			Recipe = "Vouge",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronSpear
		{
			Recipe = "Spear",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronHalberd
		{
			Recipe = "Halberd",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronLargeAxe
		{
			Recipe = "LargeAxe",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronGreatAxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--10s

		--10 IronGreataxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronLongsword
		{
			Recipe = "Longsword",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronBroadsword
		{
			Recipe = "Broadsword",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronSaber
		{
			Recipe = "Saber",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronKatana
		{
			Recipe = "Katana",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronDagger
		{
			Recipe = "Dagger",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronKryss
		{
			Recipe = "Kryss",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronPoniard
		{
			Recipe = "Poniard",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronBoneDagger
		{
			Recipe = "BoneDagger",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronMace
		{
			Recipe = "Mace",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronHammer
		{
			Recipe = "Hammer",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronMaul
		{
			Recipe = "Maul",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronWarMace
		{
			Recipe = "WarMace",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronQuarterstaff
		{
			Recipe = "Quarterstaff",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronWarhammer
		{
			Recipe = "Warhammer",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronPitchfork
		{
			Recipe = "Pitchfork",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronVouge
		{
			Recipe = "Vouge",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronSpear
		{
			Recipe = "Spear",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronHalberd
		{
			Recipe = "Halberd",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronLargeAxe
		{
			Recipe = "LargeAxe",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--10 IronGreatAxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

	--15s

		--15 IronGreataxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronLongsword
		{
			Recipe = "Longsword",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronBroadsword
		{
			Recipe = "Broadsword",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronSaber
		{
			Recipe = "Saber",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronKatana
		{
			Recipe = "Katana",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronDagger
		{
			Recipe = "Dagger",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronKryss
		{
			Recipe = "Kryss",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronPoniard
		{
			Recipe = "Poniard",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronBoneDagger
		{
			Recipe = "BoneDagger",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronMace
		{
			Recipe = "Mace",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronHammer
		{
			Recipe = "Hammer",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronMaul
		{
			Recipe = "Maul",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronWarMace
		{
			Recipe = "WarMace",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronQuarterstaff
		{
			Recipe = "Quarterstaff",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronWarhammer
		{
			Recipe = "Warhammer",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronPitchfork
		{
			Recipe = "Pitchfork",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronVouge
		{
			Recipe = "Vouge",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronSpear
		{
			Recipe = "Spear",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronHalberd
		{
			Recipe = "Halberd",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronLargeAxe
		{
			Recipe = "LargeAxe",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronGreatAxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronBuckler
		{
			Recipe = "Buckler",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--20s

		--20 IronGreataxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronLongsword
		{
			Recipe = "Longsword",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronBroadsword
		{
			Recipe = "Broadsword",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronSaber
		{
			Recipe = "Saber",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronKatana
		{
			Recipe = "Katana",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronDagger
		{
			Recipe = "Dagger",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronKryss
		{
			Recipe = "Kryss",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronPoniard
		{
			Recipe = "Poniard",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronBoneDagger
		{
			Recipe = "BoneDagger",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronMace
		{
			Recipe = "Mace",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronHammer
		{
			Recipe = "Hammer",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronMaul
		{
			Recipe = "Maul",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronWarMace
		{
			Recipe = "WarMace",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronQuarterstaff
		{
			Recipe = "Quarterstaff",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronWarhammer
		{
			Recipe = "Warhammer",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronPitchfork
		{
			Recipe = "Pitchfork",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronVouge
		{
			Recipe = "Vouge",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronSpear
		{
			Recipe = "Spear",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronHalberd
		{
			Recipe = "Halberd",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronLargeAxe
		{
			Recipe = "LargeAxe",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronGreatAxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	-- ARMOR
		--5 IronChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--10s

		--10 IronChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 IronChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 IronChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "two",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 10, StackCountMax = 20},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 IronScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 IronScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 IronScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 IronFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 IronFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 IronFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Iron",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--15s

		--15 IronChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 IronFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Iron",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--20s

		--20 IronChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 IronFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Iron",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 GoldChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Gold",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 GoldChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Gold",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 GoldChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Gold",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 GoldScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Gold",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 GoldScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Gold",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 GoldScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Gold",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 GoldFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Gold",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 GoldFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Gold",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 GoldFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Gold",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--10s

		--10 GoldChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Gold",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 GoldChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Gold",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 GoldChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Gold",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 GoldScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Gold",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 GoldScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Gold",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 GoldScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Gold",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 GoldFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Gold",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 GoldFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Gold",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 GoldFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Gold",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--15s

		--15 GoldChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Gold",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 GoldChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Gold",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 GoldChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Gold",
			Amount = 15,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 GoldScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Gold",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 GoldScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Gold",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 GoldScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Gold",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 GoldFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Gold",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 GoldFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Gold",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 GoldFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Gold",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--20s

		--20 GoldChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Gold",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 GoldChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Gold",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 GoldChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Gold",
			Amount = 20,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 GoldScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Gold",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 GoldScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Gold",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 GoldScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Gold",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 GoldFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Gold",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 GoldFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Gold",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 GoldFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Gold",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CopperChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Copper",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CopperChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Copper",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CopperChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Copper",
			Amount = 5,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CopperScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Copper",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CopperScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Copper",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CopperScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Copper",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CopperFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Copper",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CopperFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Copper",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CopperFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Copper",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--10s

		--10 CopperChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Copper",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CopperChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Copper",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CopperChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Copper",
			Amount = 10,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CopperScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Copper",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CopperScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Copper",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CopperScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Copper",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CopperFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Copper",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CopperFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Copper",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CopperFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Copper",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--15s

		--15 CopperChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Copper",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CopperChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Copper",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CopperChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Copper",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CopperScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Copper",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CopperScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Copper",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CopperScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Copper",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CopperFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Copper",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CopperFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Copper",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CopperFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Copper",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--20s

		--20 CopperChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Copper",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CopperChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Copper",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CopperChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Copper",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CopperScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Copper",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CopperScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Copper",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CopperScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Copper",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CopperFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Copper",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CopperFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Copper",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CopperFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Copper",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CobaltChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Cobalt",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CobaltChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Cobalt",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CobaltChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Cobalt",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CobaltScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Cobalt",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CobaltScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Cobalt",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CobaltScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Cobalt",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CobaltFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Cobalt",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CobaltFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Cobalt",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 CobaltFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Cobalt",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--10s

		--10 CobaltChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Cobalt",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CobaltChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Cobalt",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CobaltChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Cobalt",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CobaltScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Cobalt",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CobaltScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Cobalt",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CobaltScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Cobalt",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CobaltFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Cobalt",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CobaltFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Cobalt",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 CobaltFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Cobalt",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--15s

		--15 CobaltChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Cobalt",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CobaltChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Cobalt",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CobaltChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Cobalt",
			Amount = 15,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CobaltScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Cobalt",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CobaltScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Cobalt",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CobaltScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Cobalt",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CobaltFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Cobalt",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CobaltFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Cobalt",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 CobaltFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Cobalt",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--20s

		--20 CobaltChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Cobalt",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CobaltChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Cobalt",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CobaltChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Cobalt",
			Amount = 20,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CobaltScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Cobalt",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CobaltScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Cobalt",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CobaltScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Cobalt",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CobaltFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Cobalt",
			Amount = 20,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CobaltFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Cobalt",
			Amount = 20,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 CobaltFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Cobalt",
			Amount = 20,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 ObsidianChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Obsidian",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 ObsidianChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Obsidian",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 ObsidianChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Obsidian",
			Amount = 5,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 ObsidianScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Obsidian",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 ObsidianScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Obsidian",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 ObsidianScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Obsidian",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 ObsidianFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Obsidian",
			Amount = 5,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 ObsidianFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Obsidian",
			Amount = 5,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 ObsidianFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Obsidian",
			Amount = 5,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--10s

		--10 ObsidianChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Obsidian",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 ObsidianChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Obsidian",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 ObsidianChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Obsidian",
			Amount = 10,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 ObsidianScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Obsidian",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 ObsidianScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Obsidian",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 ObsidianScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Obsidian",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 ObsidianFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Obsidian",
			Amount = 10,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 ObsidianFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Obsidian",
			Amount = 10,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 ObsidianFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Obsidian",
			Amount = 10,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--15s

		--15 ObsidianChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Obsidian",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 ObsidianChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Obsidian",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 ObsidianChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Obsidian",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 ObsidianScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Obsidian",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 ObsidianScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Obsidian",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 ObsidianScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Obsidian",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 ObsidianFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Obsidian",
			Amount = 15,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 ObsidianFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Obsidian",
			Amount = 15,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 ObsidianFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Obsidian",
			Amount = 15,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--20s

		--20 ObsidianChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Obsidian",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 ObsidianChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Obsidian",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 ObsidianChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Obsidian",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 ObsidianScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Obsidian",
			Amount = 20,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 ObsidianScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Obsidian",
			Amount = 20,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 ObsidianScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Obsidian",
			Amount = 20,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 ObsidianFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Obsidian",
			Amount = 20,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 ObsidianFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Obsidian",
			Amount = 20,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 ObsidianFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Obsidian",
			Amount = 20,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--LARGE ORDERS

	--WEAPONS

		--40 IronGreataxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronLongsword
		{
			Recipe = "Longsword",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronBroadsword
		{
			Recipe = "Broadsword",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronSaber
		{
			Recipe = "Saber",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronKatana
		{
			Recipe = "Katana",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronDagger
		{
			Recipe = "Dagger",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronKryss
		{
			Recipe = "Kryss",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronPoniard
		{
			Recipe = "Poniard",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronBoneDagger
		{
			Recipe = "BoneDagger",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronMace
		{
			Recipe = "Mace",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronHammer
		{
			Recipe = "Hammer",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronMaul
		{
			Recipe = "Maul",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronWarMace
		{
			Recipe = "WarMace",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronQuarterstaff
		{
			Recipe = "Quarterstaff",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronWarhammer
		{
			Recipe = "Warhammer",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronPitchfork
		{
			Recipe = "Pitchfork",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronVouge
		{
			Recipe = "Vouge",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronSpear
		{
			Recipe = "Spear",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronHalberd
		{
			Recipe = "Halberd",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronLargeAxe
		{
			Recipe = "LargeAxe",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronGreatAxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--80s

		--80 IronGreataxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronLongsword
		{
			Recipe = "Longsword",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronBroadsword
		{
			Recipe = "Broadsword",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronSaber
		{
			Recipe = "Saber",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronKatana
		{
			Recipe = "Katana",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronDagger
		{
			Recipe = "Dagger",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronKryss
		{
			Recipe = "Kryss",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronPoniard
		{
			Recipe = "Poniard",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronBoneDagger
		{
			Recipe = "BoneDagger",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronMace
		{
			Recipe = "Mace",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronHammer
		{
			Recipe = "Hammer",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronMaul
		{
			Recipe = "Maul",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronWarMace
		{
			Recipe = "WarMace",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronQuarterstaff
		{
			Recipe = "Quarterstaff",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronWarhammer
		{
			Recipe = "Warhammer",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronPitchfork
		{
			Recipe = "Pitchfork",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronVouge
		{
			Recipe = "Vouge",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronSpear
		{
			Recipe = "Spear",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronHalberd
		{
			Recipe = "Halberd",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronLargeAxe
		{
			Recipe = "LargeAxe",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronGreatAxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_gold", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--80s

		--WEAPONS

		--80 IronGreataxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronLongsword
		{
			Recipe = "Longsword",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronBroadsword
		{
			Recipe = "Broadsword",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronSaber
		{
			Recipe = "Saber",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronKatana
		{
			Recipe = "Katana",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronDagger
		{
			Recipe = "Dagger",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronKryss
		{
			Recipe = "Kryss",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronPoniard
		{
			Recipe = "Poniard",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronBoneDagger
		{
			Recipe = "BoneDagger",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronMace
		{
			Recipe = "Mace",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronHammer
		{
			Recipe = "Hammer",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronMaul
		{
			Recipe = "Maul",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronWarMace
		{
			Recipe = "WarMace",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronQuarterstaff
		{
			Recipe = "Quarterstaff",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronWarhammer
		{
			Recipe = "Warhammer",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronPitchfork
		{
			Recipe = "Pitchfork",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronVouge
		{
			Recipe = "Vouge",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronSpear
		{
			Recipe = "Spear",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronHalberd
		{
			Recipe = "Halberd",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronLargeAxe
		{
			Recipe = "LargeAxe",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronGreatAxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--100s

		--WEAPONS

		--100 IronGreataxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronLongsword
		{
			Recipe = "Longsword",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronBroadsword
		{
			Recipe = "Broadsword",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronSaber
		{
			Recipe = "Saber",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronKatana
		{
			Recipe = "Katana",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronDagger
		{
			Recipe = "Dagger",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronKryss
		{
			Recipe = "Kryss",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronPoniard
		{
			Recipe = "Poniard",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronBoneDagger
		{
			Recipe = "BoneDagger",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronMace
		{
			Recipe = "Mace",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronHammer
		{
			Recipe = "Hammer",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronMaul
		{
			Recipe = "Maul",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronWarMace
		{
			Recipe = "WarMace",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronQuarterstaff
		{
			Recipe = "Quarterstaff",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronWarhammer
		{
			Recipe = "Warhammer",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronPitchfork
		{
			Recipe = "Pitchfork",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronVouge
		{
			Recipe = "Vouge",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronSpear
		{
			Recipe = "Spear",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronHalberd
		{
			Recipe = "Halberd",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronLargeAxe
		{
			Recipe = "LargeAxe",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronGreatAxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "four",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_copper", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	-- ARMOR
		--40 IronChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Iron",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--80s

		--80 IronChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_cobalt", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Iron",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--80s

		--80 IronChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--100s

		--100 IronChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 IronFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Iron",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 GoldChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Gold",
			Amount = 40,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 GoldChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Gold",
			Amount = 40,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 GoldChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Gold",
			Amount = 40,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 GoldScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Gold",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 GoldScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Gold",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 GoldScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Gold",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 GoldFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Gold",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 GoldFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Gold",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 GoldFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Gold",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--80s

		--80 GoldChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Gold",
			Amount = 60,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Gold",
			Amount = 60,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Gold",
			Amount = 60,

			RewardCoins = "six",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_obsidian", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_obsidian", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Gold",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Gold",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Gold",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Gold",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Gold",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Gold",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--80s

		--80 GoldChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Gold",
			Amount = 80,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Gold",
			Amount = 80,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Gold",
			Amount = 80,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Gold",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Gold",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Gold",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Gold",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Gold",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 GoldFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Gold",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--100s

		--100 GoldChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Gold",
			Amount = 100,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 GoldChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Gold",
			Amount = 100,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 GoldChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Gold",
			Amount = 100,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 GoldScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Gold",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 GoldScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Gold",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 GoldScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Gold",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 GoldFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Gold",
			Amount = 100,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 GoldFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Gold",
			Amount = 100,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 GoldFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Gold",
			Amount = 100,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CopperChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Copper",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CopperChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Copper",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CopperChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Copper",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CopperScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Copper",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CopperScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Copper",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CopperScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Copper",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CopperFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Copper",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CopperFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Copper",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CopperFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Copper",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--80s

		--80 CopperChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Copper",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Copper",
			Amount = 60,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Copper",
			Amount = 60,

			RewardCoins = "one",

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_gold", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Copper",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Copper",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Copper",
			Amount = 60,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Copper",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Copper",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Copper",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--80s

		--80 CopperChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Copper",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Copper",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Copper",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Copper",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Copper",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Copper",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Copper",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Copper",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CopperFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Copper",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--100s

		--100 CopperChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Copper",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CopperChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Copper",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CopperChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Copper",
			Amount = 100,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CopperScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Copper",
			Amount = 100,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CopperScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Copper",
			Amount = 100,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CopperScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Copper",
			Amount = 100,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CopperFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Copper",
			Amount = 100,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CopperFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Copper",
			Amount = 100,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CopperFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Copper",
			Amount = 100,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CobaltChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Cobalt",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CobaltChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Cobalt",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CobaltChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Cobalt",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CobaltScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Cobalt",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CobaltScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Cobalt",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CobaltScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Cobalt",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CobaltFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Cobalt",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CobaltFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Cobalt",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 CobaltFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Cobalt",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--80s

		--80 CobaltChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Cobalt",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Cobalt",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Cobalt",
			Amount = 60,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Cobalt",
			Amount = 60,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Cobalt",
			Amount = 60,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Cobalt",
			Amount = 60,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Cobalt",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Cobalt",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Cobalt",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--80s

		--80 CobaltChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Cobalt",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Cobalt",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Cobalt",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Cobalt",
			Amount = 80,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Cobalt",
			Amount = 80,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Cobalt",
			Amount = 80,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Cobalt",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Cobalt",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 CobaltFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Cobalt",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--100s

		--100 CobaltChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Cobalt",
			Amount = 100,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CobaltChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Cobalt",
			Amount = 100,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CobaltChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Cobalt",
			Amount = 100,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CobaltScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Cobalt",
			Amount = 100,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CobaltScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Cobalt",
			Amount = 100,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CobaltScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Cobalt",
			Amount = 100,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CobaltFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Cobalt",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CobaltFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Cobalt",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 CobaltFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Cobalt",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 ObsidianChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Obsidian",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 ObsidianChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Obsidian",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 ObsidianChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Obsidian",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 ObsidianScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Obsidian",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 ObsidianScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Obsidian",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 ObsidianScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Obsidian",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 ObsidianFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Obsidian",
			Amount = 40,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 ObsidianFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Obsidian",
			Amount = 40,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 ObsidianFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Obsidian",
			Amount = 40,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--80s

		--80 ObsidianChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Obsidian",
			Amount = 60,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Obsidian",
			Amount = 60,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Obsidian",
			Amount = 60,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "furniture_table_blacksmith_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Obsidian",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Obsidian",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Obsidian",
			Amount = 60,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Obsidian",
			Amount = 60,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Obsidian",
			Amount = 60,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Obsidian",
			Amount = 60,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--80s

		--80 ObsidianChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Obsidian",
			Amount = 80,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Obsidian",
			Amount = 80,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Obsidian",
			Amount = 80,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_gold", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Obsidian",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Obsidian",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Obsidian",
			Amount = 80,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Obsidian",
			Amount = 80,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Obsidian",
			Amount = 80,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 ObsidianFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Obsidian",
			Amount = 80,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--100s

		--100 ObsidianChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Obsidian",
			Amount = 100,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 ObsidianChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Obsidian",
			Amount = 100,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 ObsidianChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Obsidian",
			Amount = 100,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_copper", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 ObsidianScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Obsidian",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 ObsidianScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Obsidian",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 ObsidianScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Obsidian",
			Amount = 100,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_cobalt", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 ObsidianFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Obsidian",
			Amount = 100,

			RewardCoins = "fourteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 ObsidianFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Obsidian",
			Amount = 100,

			RewardCoins = "fourteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--100 ObsidianFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Obsidian",
			Amount = 100,

			RewardCoins = "fourteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "tool_anvil_obsidian", Packed = true, Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},
	}
}