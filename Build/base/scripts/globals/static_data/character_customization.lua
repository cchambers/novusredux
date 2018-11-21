CharacterCustomization = {
	FaceTypesMale = {
		{Name = "Male A",},
		{Name = "Male B",Template = "head_male02"},
		{Name = "Male C",Template = "head_male03"},
		{Name = "Male D",Template = "head_male04"},
		{Name = "Male E",Template = "head_male05"},
	},
	FaceTypesFemale = {
		{Name = "Female A",Template = "head_female01"},
		{Name = "Female B",Template = "head_female02"},
		{Name = "Female C",Template = "head_female03"},
		{Name = "Female D",Template = "head_female04"},
		{Name = "Female E",Template = "head_female05"},
	},

	HairTypesMale = {
		{Name = "Regular",Template = "hair_male"},
		{Name = "Bangs",Template = "hair_male_bangs"},
		{Name = "Buzzcut",Template = "hair_male_buzzcut"},
		{Name = "Bald"},
		{Name = "Messy",Template = "hair_male_messy"},
		{Name = "Nobleman",Template = "hair_male_nobleman"},
		{Name = "Roguish",Template = "hair_male_rougish"},
		{Name = "Side-Undercut",Template = "hair_male_sideundercut"},
		{Name = "Undercut",Template = "hair_male_undercut"},
		{Name = "Windswept",Template = "hair_male_windswept"},
		--{Name = "Long",Template = "hair_male_long"},
	},

	HairTypesFemale = {
		{Name = "Pony-Tail A",Template = "hair_female"},
		{Name = "Bob",Template = "hair_female_bob"},
		{Name = "Bun",Template = "hair_female_bun"},
		{Name = "Buzzcut",Template = "hair_female_buzzcut"},
		{Name = "Pigtails",Template = "hair_female_pigtails"},
		{Name = "Pony-Tail B",Template = "hair_female_ponytail"},
		{Name = "Shaggy",Template = "hair_female_shaggy"},
		{Name = "Bald"},
	},

	FacialHairTypesMale = {
		{Name = "None"},
		{Name = "Beard",Template = "facial_hair_beard_thin"},
		{Name = "Full beard",Template = "facial_hair_beard"},
		{Name = "Long Beard",Template = "facial_hair_beard_long"},
		{Name = "Overgrown Beard",Template = "facial_hair_beard_longer"},
		{Name = "Mutton Chops",Template = "facial_hair_beard_chops"},
		{Name = "Side Burns",Template = "facial_hair_beard_chops2"},
		{Name = "Chin Goatee",Template = "facial_hair_beard_goatee3"},
		{Name = "Anchor Goatee",Template = "facial_hair_beard_goatee2"},
		{Name = "Full Goatee",Template = "facial_hair_beard_goatee"},
		{Name = "Mustache",Template = "facial_hair_beard_mustache"},
		{Name = "Long Mustache",Template = "facial_hair_beard_mustache_long"},
		{Name = "Handlebar Mustache",Template = "facial_hair_beard_mustache2"},		
	},

	-- DAB PAX TODO: Proper skin colors
	SkinToneTypes = {
		{Name = "Pale", Hue = 807},
		{Name = "Fair", Hue = 808},
		{Name = "Medium", Hue = 809},
		{Name = "Tan", Hue = 810},
		{Name = "Olive", Hue = 811},
		{Name = "Brown", Hue = 812},
		{Name = "Dark Brown", Hue = 813},
		{Name = "Black", Hue = 814},
		{Name = "Black", Hue = 815},
		{Name = "Black", Hue = 816},
		{Name = "Black", Hue = 817},
		{Name = "Black", Hue = 818},	
	},

	-- DAB PAX TODO: Proper hair colors
	HairColorTypes = {
		{Name = "Black", Hue = 4},
		{Name = "Light Black", Hue = 8},
		{Name = "Brown", Hue = 768},
		{Name = "Light Brown", Hue = 770},
		{Name = "Light Brown", Hue = 772},
		{Name = "Red", Hue = 781},
		{Name = "Orange", Hue = 793},
		{Name = "Blonde", Hue = 788},
		{Name = "Yellow", Hue = 789},
		{Name = "White", Hue = 792},
	},

	ShirtTypes = {
		{ Name = "Long Sleeve", Template = "clothing_long_sleeve_shirt_chest" },
		{ Name = "Short Sleeve", Template = "clothing_short_sleeve_shirt_chest" },
		{ Name = "Tattered", Template = "clothing_tattered_shirt_chest" },
		{ Name = "Beggar", Template = "clothing_chest_beggar" },
		{ Name = "Thief", Template = "clothing_chest_thief" },
		{ Name = "Craftsman", Template = "clothing_chest_blacksmith" },
		{ Name = "Apron", Template = "clothing_apron_chest" },
		{ Name = "Mayor", Template = "clothing_mayor_chest" },
		{ Name = "Merchant", Template = "merchant_clothing_chest" },

	},

	PantsTypes = {
		{ Name = "Pants", Template = "clothing_legs_pants" },
		{ Name = "Tattered", Template = "clothing_tattered_legs" },
		{ Name = "Shorts", Template = "clothing_shorts_legs" },
		{ Name = "Beggar", Template = "clothing_legs_beggar" },
		{ Name = "Thief", Template = "clothing_legs_thief" },
		{ Name = "Mayor", Template = "clothing_mayor_legs" },
		{ Name = "Merchant", Template = "merchant_clothing_legs" },
		{ Name = "Skirt", Template = "clothing_skirt_legs" },			
	},

	-- DAB PAX TODO: Proper hair colors
	ClothingColorTypes = {
		{Name = "Black", Hue = 13},
		{Name = "Grey", Hue = 37},
		{Name = "Orange", Hue = 64},
		{Name = "Gold", Hue = 77},
		{Name = "Red Orange", Hue = 163},
		{Name = "Dark Orange", Hue = 737},
		{Name = "Beige", Hue = 133},
		{Name = "Red", Hue = 199},
		{Name = "Light Red", Hue = 223},
		{Name = "Pink", Hue = 259},
		{Name = "Purple", Hue = 322},
		{Name = "Blue", Hue = 352},
		{Name = "Green", Hue = 556},
		{Name = "Forest Green", Hue = 658},
		{Name = "Dark Brown", Hue = 682},
		{Name = "Mustard", Hue = 694},
		{Name = "Pale Yellow", Hue = 703},
		{Name = "Brown", Hue = 774},

	},

	StartingItems = {
		{ Skill = "MeleeSkill", Items = { {"bandage", 10 } } },
		{ Skill = "HealingSkill", Items = { {"bandage", 10 } } },
		{ Skill = "PiercingSkill", Items = { "weapon_kryss" }},
		{ Skill = "SlashingSkill", Items = { "weapon_saber"}},
		{ Skill = "LancingSkill", Items = { "weapon_spear" }},
		{ Skill = "BashingSkill", Items = { "weapon_mace" }},
		{ Skill = "BlockingSkill", Items = { "shield_buckler" } },
		{ Skill = "AnimalTamingSkill", Items = { "tool_crook" } },
		{ Skill = "AnimalLoreSkill", Items = { "tool_crook" } },
		{ Skill = "ManifestationSkill", Items = { "spellbook_noob", "reagent_bag_noob" } },
		{ Skill = "EvocationSkill", Items = { "spellbook_noob", "reagent_bag_noob" } },
		{ Skill = "ChannelingSkill", Items = { "spellbook_noob", "reagent_bag_noob" } },
		{ Skill = "MagicAffinitySkill", Items = { "spellbook_noob", "reagent_bag_noob" } },
		{ Skill = "CookingSkill", Items = { "tool_cookingpot" } },
		{ Skill = "FishingSkill", Items = { "tool_fishing_rod" } },
		{ Skill = "LumberjackSkill", Items = { "tool_hatchet"} },
		{ Skill = "MiningSkill", Items = { "tool_mining_pick"} },
		{ Skill = "ArcherySkill", Items = { "weapon_shortbow", {"arrow", 100} } },		
		{ Skill = "TreasureHuntingSkill", Items = { "tool_shovel" } },
	},

	--Uses skill DisplayName
	ExcludedStartingSkills = {
	Beastmastery = ""
	},

	StartingTrades = {
		{ Name = "Warrior", Skills = { {"SlashingSkill", 30 },  {"MeleeSkill", 30 }, {"HealingSkill", 20 }, {"None", 0 } } },
       	{ Name = "Mage", Skills = { {"ManifestationSkill", 30 }, {"EvocationSkill", 30 }, {"MagicAffinitySkill", 20 }, {"None", 0 } } },
       	{ Name = "Archer", Skills = { {"ArcherySkill", 30 }, {"MeleeSkill", 30 }, {"HealingSkill", 20 }, {"None", 0 } } },
       	{ Name = "Blacksmith", Skills = { {"MetalsmithSkill", 30 },  {"MiningSkill", 30 }, {"BashingSkill", 20 }, {"None", 0 } } },
		{ Name = "Advanced", Skills = {  {"None", 0 },  {"None", 0 }, {"None", 0 }, {"None", 0 } } },
	}
}