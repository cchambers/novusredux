FoodStats = {
	BaseFoodClass = {
		-- Ingredients don't need CookingDifficulty, if you want to 'cook' an ingredient, create a new cooked template version of that ingredient and require the 'raw' one to make it.
		
		Refreshment = {
			Replenish = 0,
		},
		Ingredient = {
			Replenish = 0.5,
		},
		Snack = {
			Replenish = 1,
		},
		Meal = {
			Replenish = 3,
			CookingDifficulty = 50,
		},
		Delicacy = {
			Replenish = 12,
			CookingDifficulty = 75,
		}
	},

	BaseFoodStats = {
		-- INGREDIENTS
		Wheat = {
			FoodClass = "Ingredient",
			Replenish = 0 -- at zero it disallows eating
		},
		Pumpkin = {
			FoodClass = "Snack",
			Replenish = 0
		},
		-- Edible ingredients
		Apple = {
			FoodClass = "Snack",
		},
		Broccoli = {
			FoodClass = "Snack",
		},
		Cabbage = {
			FoodClass = "Snack",
		},
		Cucumber = {
			FoodClass = "Snack",
		},
		GreenPepper = {
			FoodClass = "Snack",
		},
		Onion = {
			FoodClass = "Snack",
		},
		Potato = {
			FoodClass = "Snack",
		},
		CheeseWheel = {
			FoodClass = "Snack",
		},
		Grapes = {
			FoodClass = "Snack",
		},
		Lemon = {
			FoodClass = "Snack",
		},
		Orange = {
			FoodClass = "Snack",
		},
		Pear = {
			FoodClass = "Snack",
		},
		Tomato = {
			FoodClass = "Snack",
		},
		-- gross ingredients
		MushroomPoison = {
			FoodClass = "Ingredient",
			Replenish = 0, -- optional overwrite from base food class
			Gross = true,
		},
		MushroomNoxious = {
			FoodClass = "Ingredient",
			Replenish = 0, -- optional overwrite from base food class
			Gross = true,
		},
		-- reagents
		Ginseng = {
			FoodClass = "Ingredient",
			Replenish = 0, -- optional overwrite from base food class
		},
		LemonGrass = {
			FoodClass = "Ingredient",
			Replenish = 0, -- optional overwrite from base food class
		},
		Moss = {
			FoodClass = "Ingredient",
			Replenish = 0, -- optional overwrite from base food class
		},
		Mushrooms = {
			FoodClass = "Ingredient",
			Replenish = 0, -- optional overwrite from base food class
		},

		MysteryMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		StringyMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		ToughMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		TenderMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		GourmetMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		ChickenMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		CoyoteMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		CrocodileMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		DeerMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		DragonMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		FoxMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		HorseMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		RabbitMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		RatMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		TurkeyMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		WolfMeat = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		GoldenTreeBark = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		FishFilletBarrel = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		FishFilletRazor = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		FishFilletTero = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		FishFilletFourEyedSalar = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		FishFilletGoldenAether = {
			FoodClass = "Ingredient",
			Raw = true,
		},
		FishFilletSpottedTero = {
			FoodClass = "Ingredient",
			Raw = true,
		},

		-- DRINKS
		Wine = {
			FoodClass = "Refreshment",
			UseCases = {
				"Drink"
			},
			DrugEffect = "DrunkenEffect",
			DrugDuration = 10,
			Template = "item_wine",
		},
		Beer = {
			FoodClass = "Refreshment",
			UseCases = {
				"Drink"
			},
			CookingDifficulty = 5,
			DrugEffect = "DrunkenEffect",
			DrugDuration = 10,
			Ingredients = { Wheat = 5, Ginseng = 2, },
			Template = "item_beer",
		},
		Ale = {
			FoodClass = "Refreshment",
			UseCases = {
				"Drink"
			},
			CookingDifficulty = 5,
			DrugEffect = "DrunkenEffect",
			DrugDuration = 20,
			Ingredients = { Wheat = 5, LemonGrass = 2, },
			Template = "item_ale",
		},
		Mead = {
			FoodClass = "Refreshment",
			UseCases = {
				"Drink"
			},
			CookingDifficulty = 5,
			DrugEffect = "DrunkenEffect",
			DrugDuration = 60,
			Ingredients = { Wheat = 5, Moss = 2, },
			Template = "item_mead",
		},
		CookedMeat = {
			FoodClass = "Snack",
			CookingDifficulty = 10,
			Ingredients = { MysteryMeat = 1 },
			Template = "item_cooked_meat",
		},
		Jerky = {
			FoodClass = "Snack",
			CookingDifficulty = 30,
			Ingredients = { StringyMeat = 1 },
			Template = "item_jerky",
		},
		MeatLoaf = {
			FoodClass = "Meal",
			CookingDifficulty = 50,
			Ingredients = { ToughMeat = 1 },
			Template = "item_meat_loaf"
		},
		Brisket = {
			FoodClass = "Meal",
			CookingDifficulty = 70,
			Ingredients = { TenderMeat = 1 },
			Template = "item_brisket"
		},
		WildSteak = {
			FoodClass = "Delicacy",
			CookingDifficulty = 90,
			Ingredients = { GourmetMeat = 1 },
			Template = "item_wild_steak"
		},
		CookedAetherFish = {
			FoodClass = "Delicacy",
			CookingDifficulty = 95,
			Ingredients = { FishFilletGoldenAether = 1 },
			Template = "item_cooked_aetherfish"
		},		
		CookedBarrelFish = {
			FoodClass = "Snack",
			CookingDifficulty = 10,
			Ingredients = { FishFilletBarrel = 1 },
			Template = "item_cooked_barrelfish",
		},
		CookedTeroFish = {
			FoodClass = "Snack",
			CookingDifficulty = 30,
			Ingredients = { FishFilletTero = 1 },
			Template = "item_cooked_terofish",
		},
		CookedSpottedTero = {
			FoodClass = "Meal",
			CookingDifficulty = 50,
			Ingredients = { FishFilletSpottedTero = 1 },
			Template = "item_cooked_spottedterofish"
		},
		CookedFourEyeSalar = {
			FoodClass = "Meal",
			CookingDifficulty = 70,
			Ingredients = { FishFilletFourEyedSalar = 1 },
			Template = "item_cooked_salarfish"
		},
		CookedRazorFish = {
			FoodClass = "Delicacy",
			CookingDifficulty = 90,
			Ingredients = { FishFilletRazor = 1 },
			Template = "item_cooked_razorfish"
		},

		SacredDewFlower = {
			FoodClass = "Ingredient",		
			DrugEffect = "ClubDrugEffect",
			DrugDuration = 10,
			Template = "ingredient_sacred_dew"
		},
		SacredCactus = {
			FoodClass = "Ingredient",		
			DrugEffect = "SacredCactusEffect",
			DrugDuration = 10,
			Template = "ingredient_sacred_cactus_extract"
		},

		
		-- Ingredients table MUST be unique, 
			--if two different foods share the exact same ingredients, there's no guarantee which one will be created.
			--{Wheat=100} and {Wheat=100} are exactly the same, whereas {Wheat=100} and {Wheat=101} are different, the 101 will always get priority
		
		BowlOfStew = {
			FoodClass = "Meal",
		},

		-- MEALS
		Bread = {
			FoodClass = "Meal",
			--- These options only apply to stuff that can be cooked (ie, non-ingredients)
			CookingDifficulty = 25, -- optional, defaults to FoodClass CookingDifficulty
			Ingredients = { Wheat = 5, }, -- required to be craftable (cooked)
			Template = "item_bread", -- required to be craftable (cooked)
			---
		},
		RoastedChicken = {
			FoodClass = "Meal",
			--- These options only apply to stuff that can be cooked (ie, non-ingredients)
			CookingDifficulty = 35, -- optional, defaults to FoodClass CookingDifficulty
			Ingredients = { ChickenMeat = 5, GreenPepper = 1 }, -- required to be craftable (cooked)
			Template = "item_roasted_chicken", -- required to be craftable (cooked)
			---
		},
		RabbitStew = {
			FoodClass = "Meal",
			--- These options only apply to stuff that can be cooked (ie, non-ingredients)
			CookingDifficulty = 20, -- optional, defaults to FoodClass CookingDifficulty
			Ingredients = { RabbitMeat = 5, Water = 1, Onion = 1 }, -- required to be craftable (cooked)
			Template = "item_rabbit_stew", -- required to be craftable (cooked)
			---
		},
		RatStew = {
			FoodClass = "Meal",
			--- These options only apply to stuff that can be cooked (ie, non-ingredients)
			CookingDifficulty = 30, -- optional, defaults to FoodClass CookingDifficulty
			Ingredients = { RatMeat = 5, Water = 1, Onion = 1 }, -- required to be craftable (cooked)
			Template = "item_rat_stew", -- required to be craftable (cooked)
			---
		},
		FoxStew = {
			FoodClass = "Meal",
			--- These options only apply to stuff that can be cooked (ie, non-ingredients)
			CookingDifficulty = 30, -- optional, defaults to FoodClass CookingDifficulty
			Ingredients = { FoxMeat = 3, Water = 1, Onion = 1 }, -- required to be craftable (cooked)
			Template = "item_fox_stew", -- required to be craftable (cooked)
			---
		},
		RoastedTurkey = {
			FoodClass = "Meal",
			--- These options only apply to stuff that can be cooked (ie, non-ingredients)
			CookingDifficulty = 40, -- optional, defaults to FoodClass CookingDifficulty
			Ingredients = { TurkeyMeat = 5, GreenPepper = 1 }, -- required to be craftable (cooked)
			Template = "item_roasted_turkey", -- required to be craftable (cooked)
			---
		},
		CoyoteStew = {
			FoodClass = "Meal",
			--- These options only apply to stuff that can be cooked (ie, non-ingredients)
			CookingDifficulty = 40, -- optional, defaults to FoodClass CookingDifficulty
			Ingredients = { CoyoteMeat = 5, Water = 1, Onion = 1 }, -- required to be craftable (cooked)
			Template = "item_coyote_stew", -- required to be craftable (cooked)
			---
		},


		

		-- DelicacyS
		ApplePie = {
			FoodClass = "Delicacy",
			CookingDifficulty = 55,
			Ingredients = { Wheat = 20, Apple = 5, },
			Template = "item_pie_apple"
		},
		PumpkinPie = {
			FoodClass = "Delicacy",
			CookingDifficulty = 55,
			Ingredients = { Wheat = 20, Pumpkin = 5, },
			Template = "item_pie_pumpkin"
		},
		WolfSteak = {
			FoodClass = "Delicacy",
			CookingDifficulty = 60,
			Ingredients = { WolfMeat = 3, Mushrooms = 1, },
			Template = "item_wolf_steak"
		},
		DeerSteak = {
			FoodClass = "Delicacy",
			CookingDifficulty = 65,
			Ingredients = { DeerMeat = 3, Mushrooms = 1, },
			Template = "item_deer_steak"
		},
		HorseSteak = {
			FoodClass = "Delicacy",
			CookingDifficulty = 70,
			Ingredients = { HorseMeat = 3, Mushrooms = 1, },
			Template = "item_horse_steak"
		},
		BearSteak = {
			FoodClass = "Delicacy",
			CookingDifficulty = 75,
			Ingredients = { BearMeat = 3, Mushrooms = 1, },
			Template = "item_bear_steak"
		},
		FriedCrocodile = {
			FoodClass = "Delicacy",
			CookingDifficulty = 80,
			Ingredients = { CrocodileMeat = 5, GreenPepper = 2, },
			Template = "item_fried_crocodile"
		},
		SpiderEyeSoup = {
			FoodClass = "Delicacy",
			CookingDifficulty = 85,
			Ingredients = { SpiderEye = 5, Water = 1, Onion = 1 },
			Template = "item_spider_eye_soup"
		},

		SmokedDragonSteak = {
			FoodClass = "Delicacy",
			CookingDifficulty = 100,
			Ingredients = { DragonMeat = 1, GoldenTreeBark = 1 },
			Template = "item_dragon_steak"
		},					
	}
}