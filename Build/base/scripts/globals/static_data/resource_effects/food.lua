ResourceEffectData.MushroomsPoison = {
    MobileEffect = "Poison",
    MobileEffectArgs = {
        PulseMax = 12,
        PulseFrequency = TimeSpan.FromSeconds(2),
    },
    SelfOnly = true,
    Tooltip = {
        "Will make you sick.",
    },
}








--- TEST ITEMS


--useful for stunning yourself when testing.
ResourceEffectData.StunBread = {
    SelfOnly = true,
    Tooltip = {
        "Will stun you.",
    },
    -- default stun is short.
    MobileEffect = "Stun",
    MobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(1),
    },
    UseCases = {
        "1 Second Stun", -- first one is always default interaction
        "5 Second Stun",
        "10 Second Stun",
    },
    MobileEffectUseCases = {}
}
-- continuation of StunBread
ResourceEffectData.StunBread.MobileEffectUseCases["5 Second Stun"] = {
    MobileEffect = "Stun",
    MobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(5),
    },
}
ResourceEffectData.StunBread.MobileEffectUseCases["10 Second Stun"] = {
    MobileEffect = "Stun",
    MobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(10),
    },
}



ResourceEffectData.JusticeBread = {
    MobileEffect = "SwiftJustice",
    MobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(15),
    },
    SelfOnly = true,
    Tooltip = {
        "The Justice of the Guardian Order is swift.",
    },
}