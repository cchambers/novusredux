ServerSettings.Death = {

    -- amount of time before a corpse is automatically released
    CorpseAutoRelease = TimeSpan.FromMinutes(1),

    -- time it takes for a corpse to decay
    CorpseDecay = TimeSpan.FromHours(1),

    -- how far from a corpse does a player get the option to self resurrect
    SelfResurrectDistance = 15,

    -- stat percentages for being resurrected different ways
    SelfResurrectStatPercent = 0.15,
    CorpseResurrectStatPercent = 0.15,
    DefaultResurrectStatPercent = 0.15,
}