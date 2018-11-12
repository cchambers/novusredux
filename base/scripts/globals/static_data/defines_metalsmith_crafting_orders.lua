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
				{ Weight = 10, Template = "recipe_vouge", Unique = true},
				{ Weight = 10, Template = "recipe_spear", Unique = true},
				{ Weight = 10, Template = "recipe_scalehelm", Unique = true},
				{ Weight = 10, Template = "recipe_warhammer", Unique = true},
				{ Weight = 10, Template = "recipe_halberd", Unique = true},
				{ Weight = 10, Template = "recipe_smallshield", Unique = true},
				{ Weight = 10, Template = "recipe_scalelegs", Unique = true},
				{ Weight = 10, Template = "recipe_scaletunic", Unique = true},
				{ Weight = 10, Template = "recipe_curvedshield", Unique = true},
				{ Weight = 10, Template = "recipe_fullplatehelm", Unique = true},
				{ Weight = 10, Template = "recipe_kiteshield", Unique = true},
				{ Weight = 10, Template = "recipe_fullplatelegs", Unique = true},
				{ Weight = 10, Template = "recipe_fullplatetunic", Unique = true},
				{ Weight = 10, Template = "recipe_bronze", Unique = true},
				{ Weight = 10, Template = "recipe_copper", Unique = true},
				{ Weight = 10, Template = "recipe_steel", Unique = true},
				{ Weight = 10, Template = "recipe_obsidian", Unique = true},
			},
		},	
	},

	AmountWeights = 
	{
		{
			Amount = 5,
			Weight = 10,
		},

		{
			Amount = 10,
			Weight = 9,
		},

		{
			Amount = 20,
			Weight = 8,
		},

		{
			Amount = 40,
			Weight = 4,
		},

		{
			Amount = 80,
			Weight = 2,
		},

		{
			Amount = 150,
			Weight = 1,
		},
	},


	MaterialWeights = 
	{
		Default = 10,
		Iron = 10,
		Copper = 9,
		Bronze = 8,
		Steel = 4,
		Obsidian = 1,
	},

	CraftingOrders = 
	{
	
	--SMALL ORDERS

	--WEAPONS & SHIELDS

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

		--5 IronBuckler
		{
			Recipe = "Buckler",
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

		--5 IronSmallShield
		{
			Recipe = "SmallShield",
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

		--5 IronCurvedShield
		{
			Recipe = "CurvedShield",
			Material = "Iron",
			Amount = 5,

			RewardCoins = "one",

			LootTables = 
			{
				--Reward 1
				{

	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_iron", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 IronKiteShield
		{
			Recipe = "KiteShield",
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

		--10 IronBuckler
		{
			Recipe = "Buckler",
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

		--10 IronSmallShield
		{
			Recipe = "SmallShield",
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

		--10 IronCurvedShield
		{
			Recipe = "CurvedShield",
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

		--10 IronKiteShield
		{
			Recipe = "KiteShield",
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

		--15 IronSmallShield
		{
			Recipe = "SmallShield",
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

		--15 IronCurvedShield
		{
			Recipe = "CurvedShield",
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

		--15 IronKiteShield
		{
			Recipe = "KiteShield",
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

		--20 IronBuckler
		{
			Recipe = "Buckler",
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

		--20 IronSmallShield
		{
			Recipe = "SmallShield",
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

		--20 IronCurvedShield
		{
			Recipe = "CurvedShield",
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

		--20 IronKiteShield
		{
			Recipe = "KiteShield",
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 BronzeChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Bronze",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 BronzeChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Bronze",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 BronzeChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Bronze",
			Amount = 5,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 BronzeScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Bronze",
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

		--5 BronzeScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Bronze",
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

		--5 BronzeScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Bronze",
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

		--5 BronzeFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Bronze",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 BronzeFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Bronze",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 BronzeFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Bronze",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--10s

		--10 BronzeChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Bronze",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 BronzeChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Bronze",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 BronzeChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Bronze",
			Amount = 10,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 BronzeScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Bronze",
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

		--10 BronzeScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Bronze",
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

		--10 BronzeScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Bronze",
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

		--10 BronzeFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Bronze",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 BronzeFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Bronze",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 BronzeFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Bronze",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--15s

		--15 BronzeChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Bronze",
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

		--15 BronzeChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Bronze",
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

		--15 BronzeChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Bronze",
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

		--15 BronzeScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Bronze",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 BronzeScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Bronze",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 BronzeScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Bronze",
			Amount = 15,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 BronzeFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Bronze",
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

		--15 BronzeFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Bronze",
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

		--15 BronzeFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Bronze",
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

		--20 BronzeChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Bronze",
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

		--20 BronzeChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Bronze",
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

		--20 BronzeChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Bronze",
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

		--20 BronzeScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Bronze",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 BronzeScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Bronze",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 BronzeScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Bronze",
			Amount = 20,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 BronzeFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Bronze",
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

		--20 BronzeFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Bronze",
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

		--20 BronzeFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Bronze",
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 SteelChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Steel",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 SteelChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Steel",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 SteelChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Steel",
			Amount = 5,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 SteelScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Steel",
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

		--5 SteelScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Steel",
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

		--5 SteelScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Steel",
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

		--5 SteelFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Steel",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 SteelFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Steel",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--5 SteelFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Steel",
			Amount = 5,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--10s

		--10 SteelChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Steel",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 SteelChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Steel",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 SteelChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Steel",
			Amount = 10,

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 SteelScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Steel",
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

		--10 SteelScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Steel",
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

		--10 SteelScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Steel",
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

		--10 SteelFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Steel",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 SteelFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Steel",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--10 SteelFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Steel",
			Amount = 10,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--15s

		--15 SteelChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Steel",
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

		--15 SteelChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Steel",
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

		--15 SteelChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Steel",
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

		--15 SteelScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Steel",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 SteelScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Steel",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 SteelScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Steel",
			Amount = 15,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 SteelFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Steel",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 SteelFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Steel",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--15 SteelFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Steel",
			Amount = 15,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--20s

		--20 SteelChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Steel",
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

		--20 SteelChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Steel",
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

		--20 SteelChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Steel",
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

		--20 SteelScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Steel",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 SteelScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Steel",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 SteelScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Steel",
			Amount = 20,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 SteelFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Steel",
			Amount = 20,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 SteelFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Steel",
			Amount = 20,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--20 SteelFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Steel",
			Amount = 20,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--LARGE ORDERS

	--WEAPONS & SHIELDS

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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronBuckler
		{
			Recipe = "Buckler",
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronSmallShield
		{
			Recipe = "SmallShield",
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronCurvedShield
		{
			Recipe = "CurvedShield",
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 IronKiteShield
		{
			Recipe = "KiteShield",
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
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
			Amount = 80,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronBuckler
		{
			Recipe = "Buckler",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronSmallShield
		{
			Recipe = "SmallShield",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronCurvedShield
		{
			Recipe = "CurvedShield",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 IronKiteShield
		{
			Recipe = "KiteShield",
			Material = "Iron",
			Amount = 80,

			RewardCoins = "three",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_bronze", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--120s

		--WEAPONS & SHIELDS

		--120 IronGreataxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 120,

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

		--120 IronLongsword
		{
			Recipe = "Longsword",
			Material = "Iron",
			Amount = 120,

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

		--120 IronBroadsword
		{
			Recipe = "Broadsword",
			Material = "Iron",
			Amount = 120,

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

		--120 IronSaber
		{
			Recipe = "Saber",
			Material = "Iron",
			Amount = 120,

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

		--120 IronKatana
		{
			Recipe = "Katana",
			Material = "Iron",
			Amount = 120,

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

		--120 IronDagger
		{
			Recipe = "Dagger",
			Material = "Iron",
			Amount = 120,

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

		--120 IronKryss
		{
			Recipe = "Kryss",
			Material = "Iron",
			Amount = 120,

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

		--120 IronPoniard
		{
			Recipe = "Poniard",
			Material = "Iron",
			Amount = 120,

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

		--120 IronBoneDagger
		{
			Recipe = "BoneDagger",
			Material = "Iron",
			Amount = 120,

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

		--120 IronMace
		{
			Recipe = "Mace",
			Material = "Iron",
			Amount = 120,

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

		--120 IronHammer
		{
			Recipe = "Hammer",
			Material = "Iron",
			Amount = 120,

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

		--120 IronMaul
		{
			Recipe = "Maul",
			Material = "Iron",
			Amount = 120,

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

		--120 IronWarMace
		{
			Recipe = "WarMace",
			Material = "Iron",
			Amount = 120,

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

		--120 IronQuarterstaff
		{
			Recipe = "Quarterstaff",
			Material = "Iron",
			Amount = 120,

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

		--120 IronWarhammer
		{
			Recipe = "Warhammer",
			Material = "Iron",
			Amount = 120,

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

		--120 IronPitchfork
		{
			Recipe = "Pitchfork",
			Material = "Iron",
			Amount = 120,

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

		--120 IronVouge
		{
			Recipe = "Vouge",
			Material = "Iron",
			Amount = 120,

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

		--120 IronSpear
		{
			Recipe = "Spear",
			Material = "Iron",
			Amount = 120,

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

		--120 IronHalberd
		{
			Recipe = "Halberd",
			Material = "Iron",
			Amount = 120,

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

		--120 IronLargeAxe
		{
			Recipe = "LargeAxe",
			Material = "Iron",
			Amount = 120,

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

		--120 IronGreatAxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 120,

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

		--120 IronBuckler
		{
			Recipe = "Buckler",
			Material = "Iron",
			Amount = 120,

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

		--120 IronSmallShield
		{
			Recipe = "SmallShield",
			Material = "Iron",
			Amount = 120,

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

		--120 IronCurvedShield
		{
			Recipe = "CurvedShield",
			Material = "Iron",
			Amount = 120,

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

		--120 IronKiteShield
		{
			Recipe = "KiteShield",
			Material = "Iron",
			Amount = 120,

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

	--150s

		--WEAPONS & SHIELDS

		--150 IronGreataxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 150,

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

		--150 IronLongsword
		{
			Recipe = "Longsword",
			Material = "Iron",
			Amount = 150,

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

		--150 IronBroadsword
		{
			Recipe = "Broadsword",
			Material = "Iron",
			Amount = 150,

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

		--150 IronSaber
		{
			Recipe = "Saber",
			Material = "Iron",
			Amount = 150,

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

		--150 IronKatana
		{
			Recipe = "Katana",
			Material = "Iron",
			Amount = 150,

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

		--150 IronDagger
		{
			Recipe = "Dagger",
			Material = "Iron",
			Amount = 150,

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

		--150 IronKryss
		{
			Recipe = "Kryss",
			Material = "Iron",
			Amount = 150,

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

		--150 IronPoniard
		{
			Recipe = "Poniard",
			Material = "Iron",
			Amount = 150,

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

		--150 IronBoneDagger
		{
			Recipe = "BoneDagger",
			Material = "Iron",
			Amount = 150,

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

		--150 IronMace
		{
			Recipe = "Mace",
			Material = "Iron",
			Amount = 150,

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

		--150 IronHammer
		{
			Recipe = "Hammer",
			Material = "Iron",
			Amount = 150,

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

		--150 IronMaul
		{
			Recipe = "Maul",
			Material = "Iron",
			Amount = 150,

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

		--150 IronWarMace
		{
			Recipe = "WarMace",
			Material = "Iron",
			Amount = 150,

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

		--150 IronQuarterstaff
		{
			Recipe = "Quarterstaff",
			Material = "Iron",
			Amount = 150,

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

		--150 IronWarhammer
		{
			Recipe = "Warhammer",
			Material = "Iron",
			Amount = 150,

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

		--150 IronPitchfork
		{
			Recipe = "Pitchfork",
			Material = "Iron",
			Amount = 150,

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

		--150 IronVouge
		{
			Recipe = "Vouge",
			Material = "Iron",
			Amount = 150,

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

		--150 IronSpear
		{
			Recipe = "Spear",
			Material = "Iron",
			Amount = 150,

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

		--150 IronHalberd
		{
			Recipe = "Halberd",
			Material = "Iron",
			Amount = 150,

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

		--150 IronLargeAxe
		{
			Recipe = "LargeAxe",
			Material = "Iron",
			Amount = 150,

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

		--150 IronGreatAxe
		{
			Recipe = "GreatAxe",
			Material = "Iron",
			Amount = 150,

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

		--150 IronBuckler
		{
			Recipe = "Buckler",
			Material = "Iron",
			Amount = 150,

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

		--150 IronSmallShield
		{
			Recipe = "SmallShield",
			Material = "Iron",
			Amount = 150,

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

		--150 IronCurvedShield
		{
			Recipe = "CurvedShield",
			Material = "Iron",
			Amount = 150,

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

		--150 IronKiteShield
		{
			Recipe = "KiteShield",
			Material = "Iron",
			Amount = 150,

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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

			RewardCoins = "five",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "resource_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
					},
				},

				--Reward 2
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Weight = 100, Template = "tool_mining_pick_steel", Unique = true, StackCountMin = 5, StackCountMax = 10},
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

		--80 IronScaleTunic
		{
			Recipe = "ScaleTunic",
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

		--80 IronFullPlateHelm
		{
			Recipe = "FullPlateHelm",
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--120s

		--120 IronChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Iron",
			Amount = 120,

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

		--120 IronChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Iron",
			Amount = 120,

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

		--120 IronChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Iron",
			Amount = 120,

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

		--120 IronScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Iron",
			Amount = 120,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 IronScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Iron",
			Amount = 120,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 IronScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Iron",
			Amount = 120,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 IronFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Iron",
			Amount = 120,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 IronFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Iron",
			Amount = 120,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 IronFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Iron",
			Amount = 120,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--150s

		--150 IronChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Iron",
			Amount = 150,

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

		--150 IronChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Iron",
			Amount = 150,

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

		--150 IronChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Iron",
			Amount = 150,

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

		--150 IronScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Iron",
			Amount = 150,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 IronScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Iron",
			Amount = 150,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 IronScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Iron",
			Amount = 150,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 IronFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Iron",
			Amount = 150,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 IronFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Iron",
			Amount = 150,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 IronFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Iron",
			Amount = 150,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 BronzeChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Bronze",
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

		--40 BronzeChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Bronze",
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

		--40 BronzeChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Bronze",
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

		--40 BronzeScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Bronze",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 BronzeScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Bronze",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 BronzeScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Bronze",
			Amount = 40,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 BronzeFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Bronze",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 BronzeFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Bronze",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 BronzeFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Bronze",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--80s

		--80 BronzeChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Bronze",
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

		--80 BronzeChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Bronze",
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

		--80 BronzeChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Bronze",
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

		--80 BronzeScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Bronze",
			Amount = 80,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 BronzeScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Bronze",
			Amount = 80,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 BronzeScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Bronze",
			Amount = 80,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 BronzeFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Bronze",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 BronzeFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Bronze",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 BronzeFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Bronze",
			Amount = 80,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--120s

		--120 BronzeChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Bronze",
			Amount = 120,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 BronzeChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Bronze",
			Amount = 120,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 BronzeChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Bronze",
			Amount = 120,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 BronzeScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Bronze",
			Amount = 120,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 BronzeScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Bronze",
			Amount = 120,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 BronzeScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Bronze",
			Amount = 120,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 BronzeFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Bronze",
			Amount = 120,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 BronzeFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Bronze",
			Amount = 120,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 BronzeFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Bronze",
			Amount = 120,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--150s

		--150 BronzeChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Bronze",
			Amount = 150,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 BronzeChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Bronze",
			Amount = 150,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 BronzeChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Bronze",
			Amount = 150,

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 BronzeScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Bronze",
			Amount = 150,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 BronzeScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Bronze",
			Amount = 150,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 BronzeScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Bronze",
			Amount = 150,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 BronzeFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Bronze",
			Amount = 150,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 BronzeFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Bronze",
			Amount = 150,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 BronzeFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Bronze",
			Amount = 150,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
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

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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

			RewardCoins = "one",

			RewardCoins = "seven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_table", Unique = true },
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

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
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

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
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

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
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

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--120s

		--120 CopperChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Copper",
			Amount = 120,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 CopperChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Copper",
			Amount = 120,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 CopperChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Copper",
			Amount = 120,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 CopperScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Copper",
			Amount = 120,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 CopperScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Copper",
			Amount = 120,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 CopperScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Copper",
			Amount = 120,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 CopperFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Copper",
			Amount = 120,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 CopperFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Copper",
			Amount = 120,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 CopperFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Copper",
			Amount = 120,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--150s

		--150 CopperChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Copper",
			Amount = 150,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 CopperChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Copper",
			Amount = 150,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 CopperChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Copper",
			Amount = 150,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 CopperScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Copper",
			Amount = 150,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 CopperScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Copper",
			Amount = 150,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 CopperScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Copper",
			Amount = 150,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 CopperFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Copper",
			Amount = 150,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 CopperFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Copper",
			Amount = 150,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 CopperFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Copper",
			Amount = 150,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 SteelChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Steel",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 SteelChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Steel",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 SteelChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Steel",
			Amount = 40,

			RewardCoins = "eight",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 SteelScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Steel",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 SteelScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Steel",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 SteelScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Steel",
			Amount = 40,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 SteelFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Steel",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 SteelFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Steel",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--40 SteelFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Steel",
			Amount = 40,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--80s

		--80 SteelChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Steel",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 SteelChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Steel",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 SteelChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Steel",
			Amount = 80,

			RewardCoins = "nine",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 SteelScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Steel",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 SteelScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Steel",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 SteelScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Steel",
			Amount = 80,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 SteelFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Steel",
			Amount = 80,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 SteelFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Steel",
			Amount = 80,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--80 SteelFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Steel",
			Amount = 80,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--120s

		--120 SteelChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Steel",
			Amount = 120,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 SteelChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Steel",
			Amount = 120,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 SteelChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Steel",
			Amount = 120,

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 SteelScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Steel",
			Amount = 120,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 SteelScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Steel",
			Amount = 120,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 SteelScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Steel",
			Amount = 120,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 SteelFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Steel",
			Amount = 120,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 SteelFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Steel",
			Amount = 120,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 SteelFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Steel",
			Amount = 120,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--150s

		--150 SteelChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Steel",
			Amount = 150,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 SteelChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Steel",
			Amount = 150,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 SteelChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Steel",
			Amount = 150,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 SteelScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Steel",
			Amount = 150,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 SteelScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Steel",
			Amount = 150,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 SteelScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Steel",
			Amount = 150,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 SteelFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Steel",
			Amount = 150,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 SteelFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Steel",
			Amount = 150,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 SteelFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Steel",
			Amount = 150,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_anvil", Unique = true },
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
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_steel_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
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
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
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

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
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

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
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

			RewardCoins = "ten",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_table", Unique = true },
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

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
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

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
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

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
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

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "pa1", Unique = true },
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

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_anvil", Unique = true },
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

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--120s

		--120 ObsidianChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Obsidian",
			Amount = 120,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 ObsidianChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Obsidian",
			Amount = 120,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 ObsidianChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Obsidian",
			Amount = 120,

			RewardCoins = "eleven",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_bronze_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 ObsidianScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Obsidian",
			Amount = 120,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 ObsidianScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Obsidian",
			Amount = 120,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 ObsidianScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Obsidian",
			Amount = 120,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 ObsidianFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Obsidian",
			Amount = 120,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 ObsidianFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Obsidian",
			Amount = 120,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--120 ObsidianFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Obsidian",
			Amount = 120,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

	--150s

		--150 ObsidianChainHelm
		{
			Recipe = "ChainHelm",
			Material = "Obsidian",
			Amount = 150,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 ObsidianChainLeggings
		{
			Recipe = "ChainLeggings",
			Material = "Obsidian",
			Amount = 150,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 ObsidianChainTunic
		{
			Recipe = "ChainTunic",
			Material = "Obsidian",
			Amount = 150,

			RewardCoins = "twelve",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_copper_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 ObsidianScaleHelm
		{
			Recipe = "ScaleHelm",
			Material = "Obsidian",
			Amount = 150,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 ObsidianScaleLeggings
		{
			Recipe = "ScaleLeggings",
			Material = "Obsidian",
			Amount = 150,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 ObsidianScaleTunic
		{
			Recipe = "ScaleTunic",
			Material = "Obsidian",
			Amount = 150,

			RewardCoins = "thirteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_steel_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 ObsidianFullPlateHelm
		{
			Recipe = "FullPlateHelm",
			Material = "Obsidian",
			Amount = 150,

			RewardCoins = "fourteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 ObsidianFullPlateLeggings
		{
			Recipe = "FullPlateLeggings",
			Material = "Obsidian",
			Amount = 150,

			RewardCoins = "fourteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},

		--150 ObsidianFullPlateTunic
		{
			Recipe = "FullPlateTunic",
			Material = "Obsidian",
			Amount = 150,

			RewardCoins = "fourteen",

			LootTables = 
			{
				--Reward 1
				{
					NumItems = 1,
	    			LootItems = 
	    			{
	    				{ Chance = 100, Template = "packed_obsidian_anvil", Unique = true },
					},
				},	

				--Reward 2
				CraftingOrderRecipes,
			},
		},
	}
}