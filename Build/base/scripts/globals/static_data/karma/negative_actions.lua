
--[[
    Negative actions, obviously, are only applicable to 'bad' player choices.
    (ie LootPlayerContainer should never apply when looting something from your bank or a mob you killed for example, but should apply if the thing you're looting has positive Karma)
]]

KarmaActions.Negative = {
    Nothing = {
        Adjust = 0,
    },
    Attack = {
        Adjust = -5,
        UpTo = -9999,
        NpcModifier = 0.5,
        EndInitiate = true,
        PvPMods = {
            Innocent = 1,
            Neutral = 0,
            Chaos = 1,
            Outcast = 0,
        },
        -- when preventing attacking, we also need to prevent murders since attacking leads to murders and we can't deny a kill.
        PreventAdditional = "Murder"
    },
    -- This applies to looting players bodies as well, containers players own (like pets too)
    LootPlayerContainer = {
        Adjust = -100,
        UpTo = -5000,
        NpcModifier = 0.25,
        EndInitiate = true,
        PvPMods = {
            Innocent = 1,
            Neutral = 1,
            Chaos = 0,
            Outcast = 0,
        }
    },
    LootUnownedKill = {
        Adjust = -50,
        UpTo = -2500,
        NpcModifier = 1, -- set to 1 to negate the effects of this modifer for this action since this only applies to npcs (corpses n such)
        EndInitiate = true,
        PvPMods = {
            Innocent = 1,
            Neutral = 1,
            Chaos = 0,
            Outcast = 0,
        },
        Range = 30,
    },
    Murder = {
        Adjust = -2000,
        UpTo = -50000,
        NpcModifier = 0.1,
        EndInitiate = true,
        PvPMods = {
            Innocent = 1,
            Neutral = 1,
            Chaos = 0,
            Outcast = 0,
        },
        Range = 60,
        ClearConflicts = true,
    },
    -- applies when a player performs a benefical act on a karma level set to punish beneficial acts
    PunishForBeneficial = {
        Adjust = -75,
        UpTo = -7500,
        NpcModifier = 0.1,
        EndInitiate = true,
        Beneficial = true,
    },
}