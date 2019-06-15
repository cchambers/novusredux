
WeaponAbilitiesData.SpiritWalk = {
    MobileEffect = "SpiritWalk",
    Stamina = 0,
    Instant = true,
    NoTarget = true,
    NoCombat = true,
    AllowDead = true,
    Cooldown = TimeSpan.FromMinutes(5),
    Action = {
        DisplayName = "Spirit Walk",
        Tooltip = "Teleport your spirit to the closest resurrection shrine.\n5 Minute Cooldown.",
        Icon = "resurrect",
        Enabled = true
    }
}


WeaponAbilitiesData.EphemeralProjection = {
    MobileEffect = "EphemeralProjection",
    MobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(30),
    },
    Stamina = 0,
    Instant = true,
    NoTarget = true,
    NoCombat = true,
    AllowDead = true,
    Cooldown = TimeSpan.FromMinutes(5),
    Action = {
        DisplayName = "Ephemeral Projection",
        Tooltip = "Allows you to peer into the physical realm temporarily.\n Lasts 30 Seconds.\n5 Minute Cooldown.",
        Icon = "Force Push 02",
        Enabled = true
    }
}