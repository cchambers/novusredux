ServerSettings.Crafting = {

    MakersMark = {
        Enabled = true, -- should items have a "Created by" in the tooltip?
        MakersMark = "Crafted by %s" -- %s will be replaced with the crafter's name.
    },

    MaterialSkillDifficultyModifier = 5,

    -- The weighted roll works by performing a roll this many times,
    -- the roll closest to the weight of the material will be chosen.
    MaterialBonusCandidates = 3,
    -- holds data used to roll for a type of bonus upon crafting an item
    MaterialBonus = {
        -- these are in percents
        Attack = {
            Max = 75, -- max a material bonus can give to + attack %
            Weight = { -- different materials are weighted to give better results
                Iron = 0,
                Copper = 10,
                Gold = 20,
                Cobalt = 30,
                Obsidian = 60,
                Steel = 75,
                Spectral = 75,

                Boards = 0,
                AshBoards = 20,
                BlightwoodBoards = 40,
                BroodwoodBoards = 60
            }
        },
        Accuracy = {
            Max = 35, -- max a material bonus can give to + accuracy
            Weight = { -- different materials are weighted to give better results
                Iron = 0,
                Copper = 10,
                Gold = 20,
                Cobalt = 30,
                Obsidian = 40,
                Steel = 50,
                Spectral = 50,

                Boards = 0,
                AshBoards = 20,
                BlightwoodBoards = 60,
                BroodwoodBoards = 80
            }
        },
        -- these are NOT in percents
        Armor = {
            Max = 20, -- max amount of extra armor rating a material can give (This max is HALFED in final calculation)
            Weight = { -- different materials are weighted to give better results
                Iron = 1,
                Copper = 2,
                Gold = 3,
                Cobalt = 4,
                Obsidian = 5,
                Steel = 6,
                Spectral = 6,

                Cloth = 1,
                QuiltedCloth = 2,
                SilkCloth = 3,
                SpectralSilkCloth = 4,
                GildedSilkCloth = 4,
                AntiqueSilkCloth = 4,

                Leather = 1,
                BeastLeather = 3,
                VileLeather = 5,
            }
        },
        -- non-weighted, this is just added to the created item.
        Durability = {
            Iron = 25,
            Copper = 50,
            Gold = 100,
            Cobalt = 150,
            Obsidian = 75,
            Steel = 300,
            Spectral = 300,

            Cloth = 25,
            QuiltedCloth = 50,
            SilkCloth = 100,
            SpectralSilkCloth = 150,
            GildedSilkCloth = 150,
            AntiqueSilkCloth = 150,

            Leather = 25,
            BeastLeather = 75,
            VileLeather = 150,

            Boards = 25,
            AshBoards = 100,
            BlightwoodBoards = 200,
            BroodwoodBoards = 300
        }
    },
    -- bonus that can be gain frm the skill of crafting the item, the skill level is turned into a percent and multiplied against these numbers
    SkillBonus = {
        Attack = {
            Max = 25,
        },
        Accuracy = {
            Max = 5,
        },
        Armor = {
            Max = 1, -- (This max is HALFED in final calculation)
        },
        -- non-weighted, this is just added to the created item.
        Durability = {
            Max = 50, 
        }
    },

    RandomRecipes = {
        "arrow_broodwood",
        "battle_hammer",
        "bladed_bat",
        "boarspear",
        "broodwood",
        "butcher",
        "crescent",
        "fullered_dagger",
        "gladius",
        "hardened_buckler",
        "letter_opener",
        "naginata",
        "ninjato",
        "oval_shield",
        "shield_of_justice",
        "poleaxe",
        "pike",
        "rapier",
        "recurve",
        "skinner",
        "spetum",
        "steel",
        "stiletto",
        "tapered_heater",
        "warriors_kite",
        "zukuri"
    }
}