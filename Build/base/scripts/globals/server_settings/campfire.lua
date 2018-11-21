ServerSettings.Campfire = {
    -- max range to get the campfire effect
    MaxRange = 5,
    -- do players have to be in a group together to benefit from the campfire?
    RequireGroup = true,
    -- Regen bonus for each stat the campfire 'refuels'
    Bonus = {
        Health = 1,
        Mana = 0.5,
        Stamina = 0.03,
    },
    Disturb = {
        -- do player disturb campfires while in war mode?
        Players = true,
        -- do non-player characters disturb campfires while in war mode?
        NPCs = true
    },
    -- how long does a campfire last when created by players?
    Expire = TimeSpan.FromMinutes(3),
    DecaySeconds = 120, -- number of seconds a campfire will hang around after it's been extinguished (disturbed)
}