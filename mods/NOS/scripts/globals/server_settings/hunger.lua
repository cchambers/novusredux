--[[
    a player with 0 hunger is full, all Thresholds use a >= to compare current hunger vs threshold.
]]

ServerSettings.Hunger = {
    -- amount to add to hunger each PlayerTick (player ticks are at 1 minute intervals)
    Rate = 0.25,
    -- hunger level to consider the player 'hungry'
    Threshold = 50,
    -- when to start warning players they are getting hungry, set to nil to disable warnings
    WarnThreshold = 40,
    -- maximum hunger can ever get to
    MaxHunger = 60,

    -- how does hunger affect vitality
    Vitality = {
        Enabled = true, -- enable/disable hunger affecting vitality
    },
}