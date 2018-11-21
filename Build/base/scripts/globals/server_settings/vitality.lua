ServerSettings.Vitality = {
    -- vitality is adjusted by this amount when a player ends death (resurrected)
    AdjustOnDeathEnd = -10,
    -- what's considered low enough to apply LowVitality mobile effect
    Low = 20,
    -- when to start warning
    Warn = 40,
    -- how often to check if vitality is low enough for a debuff,
    PulseFrequency = TimeSpan.FromMinutes(1),

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