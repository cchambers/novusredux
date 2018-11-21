FoodStats = {
	BaseFoodClass = {
		-- Ingredients don't need CookingDifficulty, if you want to 'cook' an ingredient, create a new cooked template version of that ingredient and require the 'raw' one to make it.
		Ingredient = {
			Replenish = 2,
		},
		Refreshment = {
			Replenish = 5,
			CookingDifficulty = 25,
		},
		Meal = {
			Replenish = 10,
			CookingDifficulty = 50,
		},
		Feast = {
			Replenish = 30,
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
			FoodClass = "Ingredient",
			Replenish = 0
		},
		-- Edible ingredients
		Apple = {
			FoodClass = "Ingredient",
		},
		Broccoli = {
			FoodClass = "Ingredient",
		},
		Cabbage = {
			FoodClass = "Ingredient",
		},
		Cucumber = {
			FoodClass = "Ingredient",
		},
		GreenPepper = {
			FoodClass = "Ingredient",
		},
		Onion = {
			FoodClass = "Ingredient",
		},
		Potato = {
			FoodClass = "Ingredient",
		},
		CheeseWheel = {
			FoodClass = "Ingredient",
		},
		Grapes = {
			FoodClass = "Ingredient",
		},
		Lemon = {
			FoodClass = "Ingredient",
		},
		Orange = {
			FoodClass = "Ingredient",
		},
		Pear = {
			FoodClass = "Ingredient",
		},
		-- gross ingredients
		MushroomPoison = {
			FoodClass = "Ingredient",
			Replenish = 1, -- optional overwrite from base food class
			Gross = true,
		},
		MushroomNoxious = {
			FoodClass = "Ingredient",
			Replenish = 1, -- optional overwrite from base food class
			Gross = true,
		},
		-- reagents
		Ginseng = {
			FoodClass = "Ingredient",
			Replenish = 1, -- optional overwrite from base food class
		},
		LemonGrass = {
			FoodClass = "Ingredient",
			Replenish = 1, -- optional overwrite from base food class
		},
		Moss = {
			FoodClass = "Ingredient",
			Replenish = 1, -- optional overwrite from base food class
		},
		Mushrooms = {
			FoodClass = "Ingredient",
			Replenish = 1, -- optional overwrite from base food class
		},
		-- fish
		FishFilletBarrel = {
			FoodClass = "Ingredient",
			Replenish = 0, -- optional overwrite from base food class
		},
		FishFilletTero = {
			FoodClass = "Ingredient",
			Replenish = 0, -- optional overwrite from base food class
		},
		FishFilletSpottedTero = {
			FoodClass = "Ingredient",
			Replenish = 0, -- optional overwrite from base food class
		},
		FishFilletFourEyedSalar = {
			FoodClass = "Ingredient",
			Replenish = 0, -- optional overwrite from base food class
		},
		FishFilletRazor = {
			FoodClass = "Ingredient",
			Replenish = 0, -- optional overwrite from base food class
		},
		FishFilletGoldenAether = {
			FoodClass = "Ingredient",
			Replenish = 0, -- optional overwrite from base food class
		},
		AnimalMeat = {
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
		CookedBarrelFish = {
			FoodClass = "Refreshment",
			CookingDifficulty = 5,
			Ingredients = { FishFilletBarrel = 1 },
			Template = "item_cooked_barrelfish",
		},
		CookedTeroFish = {
			FoodClass = "Refreshment",
			CookingDifficulty = 5,
			Ingredients = { FishFilletTero = 1 },
			Template = "item_cooked_terofish",
		},
		CookedAnimalMeat = {
			FoodClass = "Refreshment",
			CookingDifficulty = 5,
			Ingredients = { AnimalMeat = 1, },
			Template = "animalparts_cooked_meat",
		},
		SacredDewFlower = {
			FoodClass = "Refreshment",		
			DrugEffect = "ClubDrugEffect",
			DrugDuration = 10,
			Template = "ingredient_sacred_dew"
		},
		SacredCactus = {
			FoodClass = "Refreshment",		
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
			CookingDifficulty = 10, -- optional, defaults to FoodClass CookingDifficulty
			Ingredients = { Wheat = 5, }, -- required to be craftable (cooked)
			Template = "item_bread", -- required to be craftable (cooked)
			---
		},
		ApplePieSlice = {
			FoodClass = "Meal",
			Ingredients = { Wheat = 4, Apple = 1, },
			Template = "item_pie_apple_slice"
		},
		PumpkinPieSlice = {
			FoodClass = "Meal",
			Ingredients = { Wheat = 4, Pumpkin = 1, },
			Template = "item_pie_pumpkin_slice"
		},
		CookedSpottedTero = {
			FoodClass = "Meal",
			Ingredients = { FishFilletSpottedTero = 1 },
			Template = "item_cooked_spottedterofish"
		},
		CookedFourEyeSalar = {
			FoodClass = "Meal",
			Ingredients = { FishFilletFourEyedSalar = 1 },
			Template = "item_cooked_salarfish"
		},

		-- FEASTS
		ApplePie = {
			FoodClass = "Feast",
			CookingDifficulty = 55,
			Ingredients = { Wheat = 20, Apple = 5, },
			Template = "item_pie_apple"
		},
		PumpkinPie = {
			FoodClass = "Feast",
			CookingDifficulty = 55,
			Ingredients = { Wheat = 20, Pumpkin = 5, },
			Template = "item_pie_pumpkin"
		},
		CookedRazorFish = {
			FoodClass = "Feast",
			CookingDifficulty = 55,
			Ingredients = { FishFilletRazor = 1 },
			Template = "item_cooked_razorfish"
		},
		CookedAetherFish = {
			FoodClass = "Feast",
			CookingDifficulty = 75,
			Ingredients = { FishFilletGoldenAether = 1 },
			Template = "item_cooked_aetherfish"
		},				
	}
}