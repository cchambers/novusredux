
--[[
    Negative actions, obviously, are only applicable to 'bad' player choices.
    (ie LootContainer should never apply when looting something from your bank or a mob you killed for example, but should apply if the thing you're looting has positive Karma)
]]

KarmaActions.Negative = {
    Attack = {
        Adjust = -50,
        NpcModifier = 0.5,
        EndInitiate = true,
    },
    -- This applies to looting players bodies as well as anything with ObjVar Karma
    LootContainer = {
        Adjust = -10,
        NpcModifier = 0.25,
        EndInitiate = true,
    },
    LootUnownedKill = {
        Adjust = -25,
        NpcModifier = 1, -- set to 1 to negate the effects of this modifer for this action since this only applies to npcs (corpses n such)
        EndInitiate = true,
    },
    Murder = {
        Adjust = -500,
        NpcModifier = 0.1,
        EndInitiate = true,
    },
    -- applies when a player performs a benefical act on a karma level set to punish beneficial acts
    PunishForBeneficial = {
        Adjust = -50,
        NpcModifier = 0.1,
        EndInitiate = true,
    },
}