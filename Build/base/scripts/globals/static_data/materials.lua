
--[[
    A Material is something that transfers its hue to the crafted product
]]


-- this is a list of materials per crafting skill (so we can build out a nice selectable list)
MaterialIndex = {
	MetalsmithSkill = {
		"Iron",
        "Copper",
        "Bronze",
        "Steel",
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
    Bronze = 808,
    Copper = 667,
    Steel = 836,
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
