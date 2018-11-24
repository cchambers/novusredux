



WeaponAbilitiesData.DoubleShot = {      
    MobileEffect = "DoubleShot",
    MobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(1),
    },
    Stamina = 10,
    Action = {
        DisplayName = "Double Shot",
        Tooltip = "Shoot your bow, with a follow up shot 1 second later.",
        Icon = "Multishot",
        Enabled = true
    }
}

WeaponAbilitiesData.PoisonShot = {      
    TargetMobileEffect = "Poison",
    TargetMobileEffectArgs = {
        PulseFrequency = TimeSpan.FromSeconds(2),
        PulseMax = 6,
        MinDamage = 2,
        MaxDamage = 7,
    },
    Stamina = 60,
    Action = {
        DisplayName = "Poison Shot",
        Tooltip = "Poison your target.",
        Icon = "Poison Arrow",
        Enabled = true
    }
}

WeaponAbilitiesData.Power = {
    MobileEffect = "Power",
    MobileEffectArgs = {
        AttackModifier = 0.4,
    },
    Stamina = 25,
    Action = {
        DisplayName = "Overdraw",
        Tooltip = "Increase your attack by 40%.",
        Icon = "Wild Shot",
        Enabled = true,
    },
    SkipHitAction = true
}