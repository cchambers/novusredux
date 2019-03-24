
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
        "BroodwoodBoards",
    },
    StonemasonSkill = {
        "Blocks",
        "QuartziteBlocks",
        "GraniteBlocks",
    },
}

-- a resource must be defined in here to count as a material, the value is the hue
Materials = {
    Iron = 22,
    Gold = 787,
    Copper = 667,
    Cobalt = 913,
    Steel = 871,
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
    BroodwoodBoards = 851,

    Blocks = 44,
    QuartziteBlocks = 45,
    GraniteBlocks = 43.
}

MaterialTooltipColors = {
    Iron = "[969696]",
    Gold = "[e6b032]",
    Copper = "[9cff3c]",
    Cobalt = "[0049ab]",
    Steel = "[43464b]",
    Obsidian = "[b459ff]",

    Cloth = "[b3a489]",
    QuiltedCloth = "[e6cfa5]",
    SilkCloth = "[fff2d9]",

    Leather = "[ab805c]",
    BeastLeather = "[b459ff]",
    VileLeather = "[d61c1c]",

    Boards = "[b5751b]",
    AshBoards = "[dbb47d]",
    BlightwoodBoards = "[b459ff]",
    BroodwoodBoards = "[551a8b]",

    Blocks = "[9B9DA1]",
    QuartziteBlocks = "[CFD1D6]",
    GraniteBlocks = "[4C4D4F]",    
}