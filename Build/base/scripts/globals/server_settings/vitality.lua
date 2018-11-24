ServerSettings.Vitality = {
    -- vitality is adjusted by this amount when a player is resurrected from the ghost and given a new body
    AdjustOnGhostResurrect = -10,
    -- what's considered low enough to apply LowVitality mobile effect
    Low = 20,
    -- when to start warning
    Warn = 40,

    DisplayStrings = {
        {1,"Well Rested"},
        {0.8,"Rested"},
        {0.6,"Content"},
        {0.4,"Restless"},
        {0.2,"Fatigued"},
        {0.0,"Exhausted"},
    },

    -- settings for hearth objects, primary purpose is to regenerate vitality of players around it
    Hearth = {
        -- max distance one can be from a hearth object to receive the effect
        MaxRange = 12,
        -- the regeneration bonus for a hearth that's not affected by anything.
        BaseBonus = 0.365,
        -- this pulse is a fail safe to prevent players from getting the buff stuck on them for whatever reason.
        PulseFrequency = TimeSpan.FromSeconds(1),
    },
}