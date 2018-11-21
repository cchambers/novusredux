
WeaponAbilitiesData.Focus = {
    MobileEffect = "Focus",
    Stamina = 0,
    Instant = true,
    NoTarget = true,
    NoCombat = true,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Focus",
        Tooltip = "Enter a trance and quickly regenerate mana.",
        Icon = "Thunder Storm",
        Enabled = true
    }
}

WeaponAbilitiesData.Tame = {
    MobileEffect = "Tame",
    Stamina = 0,
    Instant = true,
    QueueTarget = "Obj",
    NoCombat = true,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Tame",
        Tooltip = "Tame a creature to become your pet.",
        Icon = "tamecreature",
        Enabled = true
    }
}