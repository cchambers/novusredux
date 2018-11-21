
ServerSettings.Durability = {
    -- max durability an item will have if it doesn't have a MaxDurability ObjVar on it.
    DefaultMax = 10,
    -- number of times to warn the item is about to break
    BreakWarnings = 4,
    Chance = {
        -- the percent chance a weapon will be damaged and loose durability when swung (missing doesn't count)
        OnSwing = 0.005,
        -- the percent chance an item will be damaged and loose durability when being struck
        OnHit = 0.025,

        -- Use these values when repair works
        -- OnSwing = 0.01,
        -- OnHit = 0.05,


        -- the percent chance an item will be damaged and loose durability when being used
        OnToolUse = 0.005,
        OnMapDecipher = 0.25,
    },

    FailHit = {
        OnMapDecipher = -5,
    },
}