ResourceEffectData.Bandage = {
    MobileEffect = "Bandage",
    RequireMobileTarget = true,
    Beneficial = true,
    Tooltip = {
        "Used to heal wounds.",
    }
}

ResourceEffectData.BloodyBandage = {
    MobileEffect = "WashBandage",
    RequireSkill = {
        HealingSkill = 40,
    },
    Tooltip = {
        "Wash with water.",
    },
    NoCombat = true,
    QueueTarget = "Loc", 
    Instant = true,
    Cooldown = TimeSpan.FromSeconds(5)
}


ResourceEffectData.Salve = {
    MobileEffect = "Salve",
    RequireMobileTarget = true,
    Beneficial = true,
    RequireSkill = {
        HealingSkill = 40,
    },
    Tooltip = {
        "Used to cure poison and stop bleeding.",
    }
}