
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
	},
	FabricationSkill = {
        "Cloth",
        "QuiltedCloth",
        "SilkCloth",

        "Leather",
        "BeastLeather",
        "VileLeather",
	},
    WoodsmithSkill = {
        "Boards",
        "AshBoards",
        "BlightwoodBoards",
    }
}

-- a resource must be defined in here to count as a material, the value is the hue
Materials = {
    Iron = 22,
    Gold = 787,
    Copper = 667,
    Cobalt = 836,
    Obsidian = 893,

    Cloth = 139,
    QuiltedCloth = 934,
    SilkCloth = 872,

    Leather = 800,
    BeastLeather = 893,
    VileLeather = 941,

    Boards = 775,
    AshBoards = 866,
    BlightwoodBoards = 865,
}

MaterialTooltipColors = {
    Iron = "[969696]",
    Copper = "[9cff3c]",
    Gold = "[e6b032]",
    Cobalt = "[d7f5f2]",
    Obsidian = "[b459ff]",

    Cloth = "[b3a489]",
    QuiltedCloth = "[e6cfa5]",
    SilkCloth = "[fff2d9]",

    Leather = "[ab805c]",
    BeastLeather = "[b459ff]",
    VileLeather = "[d61c1c]",

    Wooden = "[b5751b]",
    Ash = "[dbb47d]",
    Blightwood = "[b459ff]",
}