ResourceEffectData.Bandage = {
    MobileEffect = "Bandage",
    RequireMobileTarget = true,
    Beneficial = true,
    Tooltip = {
        "Used to heal wounds.",
    }
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