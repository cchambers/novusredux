
--[[
    A Material is something that transfers its hue to the crafted product
]]


-- this is a list of materials per crafting skill (so we can build out a nice selectable list)
MaterialIndex = {
	MetalsmithSkill = {
		"Iron",
        "Copper",
        "Gold",
        "Cobalt",
		"Obsidian",
        "Steel",
        "Spectral",
	},
	TinkeringSkill = {
        "Copper",
        "Gold",
        "Steel",
        "Spectral",
	},
	FabricationSkill = {
        "Cloth",
        "QuiltedCloth",
        "SilkCloth",
        "SpectralSilkCloth",
        "GildedSilkCloth",
        "AntiqueSilkCloth",

        "Leather",
        "BeastLeather",
        "VileLeather",
	},
    WoodsmithSkill = {
        "Boards",
        "AshBoards",
        "BlightwoodBoards",
        "BroodwoodBoards",
    }
}

-- a resource must be defined in here to count as a material, the value is the hue
Materials = {
    Iron = 22,
    Gold = 787,
    Copper = 667,
    Cobalt = 913,
    Obsidian = 893,
    Steel = 871,
    Spectral = 947,

    Cloth = 139,
    QuiltedCloth = 934,
    SilkCloth = 872,
    SpectralSilkCloth = 947,
    GildedSilkCloth = 787,
    AntiqueSilkCloth = 667,

    Leather = 800,
    BeastLeather = 893,
    VileLeather = 941,

    Boards = 775,
    AshBoards = 866,
    BlightwoodBoards = 865,
    BroodwoodBoards = 851,
}

MaterialBonus = {
    Spectral = {
        AgiBonus = 5,
        AttackSpeed = 5
    },
    SpectralSilkCloth = {
        AgiBonus = 2
    },
    GildedSilkCloth = {
        ManaRegen = 3
    },
    AntiqueSilkCloth = {
        HealthRegen = 3
    }
}

MaterialTooltipColors = {
    Iron = "[969696]",
    Gold = "[e6b032]",
    Copper = "[9cff3c]",
    Cobalt = "[0049ab]",
    Obsidian = "[b459ff]",
    Steel = "[43464b]",
    Spectral = "[00FFFF]",

    Cloth = "[b3a489]",
    QuiltedCloth = "[e6cfa5]",
    SilkCloth = "[fff2d9]",
    SpectralSilkCloth = "[00FFFF]",
    AntiqueSilkCloth = "[9cff3c]",
    GildedSilkCloth = "[e6b032]",

    Leather = "[ab805c]",
    BeastLeather = "[b459ff]",
    VileLeather = "[d61c1c]",

    Boards = "[b5751b]",
    AshBoards = "[dbb47d]",
    BlightwoodBoards = "[b459ff]",
    BroodwoodBoards = "[551a8b]",
}