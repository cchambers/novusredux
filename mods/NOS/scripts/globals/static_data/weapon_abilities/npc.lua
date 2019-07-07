
WeaponAbilitiesData.DragonFire = {
    MobileEffect = "DragonFire",
    MobileEffectArgs = {
        PulseFrequency = TimeSpan.FromSeconds(1),
        PulseCount = 5,
        MinDamage = 60,
        MaxDamage = 100,
    },

    Stamina = 5,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Dragon Fire",
        Tooltip = "Rain fire down on your foes.",
        Icon = "Fireball",
        Enabled = true
    }
}

WeaponAbilitiesData.DragonFireSmall = {
    MobileEffect = "DragonFire",
    MobileEffectArgs = {
        PulseFrequency = TimeSpan.FromSeconds(1),
        PulseCount = 5,
        MinDamage = 30,
        MaxDamage = 60,
    },

    Stamina = 5,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Dragon Fire",
        Tooltip = "Rain fire down on your foes.",
        Icon = "Fireball",
        Enabled = true
    }
}

WeaponAbilitiesData.Poison = {		
    TargetMobileEffect = "Poison",
    TargetMobileEffectArgs = {
        PulseFrequency = TimeSpan.FromSeconds(2),
        PulseMax = 20,
        MinDamage = 2,
        MaxDamage = 6
    },
    Stamina = 30,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Poison",
        Tooltip = "Poison your enemy.",
        Icon = "Poison Claws",
        Enabled = true
    },
}

WeaponAbilitiesData.Hamstring = {      
    TargetMobileEffect = "Hamstring",
    TargetMobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(5),
        Modifier = -0.1,
    },
    Stamina = 30,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Hamstring",
        Tooltip = "Hamstring your enemy.",
        Icon = "Poison Claws",
        Enabled = true
    },
}

WeaponAbilitiesData.Silence = {      
    TargetMobileEffect = "Silence",
    TargetMobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(8),
    },
    Stamina = 30,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Silence",
        Tooltip = "Silence your enemy.",
        Icon = "Poison Claws",
        Enabled = true
    },
}


WeaponAbilitiesData.CerberusCharge = {
    MobileEffect = "CerberusCharge",
    Stamina = 5,
    Range = 20,
    Instant = true,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Cerberus Charge",
        Tooltip = "Charge with cool effects.",
        Icon = "Fireball",
        Enabled = true
    }
}

WeaponAbilitiesData.Charge = {
    MobileEffect = "Charge",
    Stamina = 5,
    Range = 20,
    Instant = true,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Charge",
        Tooltip = "Charge.",
        Icon = "Fireball",
        Enabled = true
    }
}

WeaponAbilitiesData.PoisonBreath = {
    MobileEffect = "PoisonBreath",
    Stamina = 5,
    Range = 20,
    Instant = true,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Cerberus Poison Breath",
        Tooltip = "Make Cerberus spew and poison those in front of him.",
        Icon = "Fireball",
        Enabled = true
    }
}

WeaponAbilitiesData.NpcStun = {
    MobileEffect = "NpcStunAttack",

    Stamina = 20,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Stun",
        Tooltip = "Stun your opponent for 2 seconds.",
        Icon = "Flame Mark",
        Enabled = true
    },
}

WeaponAbilitiesData.NpcAoeStun = {
    MobileEffect = "NpcAoeStunAttack",

    Instant = true,
    NoTarget = true,
    Stamina = 20,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Roar",
        Tooltip = "Stun all nearby opponents for 2 seconds.",
        Icon = "Flame Mark",
        Enabled = true
    },
}

WeaponAbilitiesData.VoidTeleport = {
    MobileEffect = "VoidTeleport",
    Stamina = 5,
    Range = 20,
    Instant = true,
    NoTarget = true,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Void Teleport",
        Tooltip = "Randomly teleport to a mobile around you and attack them.",
        Icon = "Fireball",
        Enabled = true
    }
}

WeaponAbilitiesData.DeathWave = {
    MobileEffect = "DeathWave",
    Stamina = 5,
    Range = 20,
    Instant = true,
    NoTarget = true,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Death Wave",
        Tooltip = "Wave goodbye to everyone around you.",
        Icon = "Fireball",
        Enabled = true
    },
}

WeaponAbilitiesData.Howl = {
    MobileEffect = "Howl",
    Stamina = 20,
    Instant = true,
    NoTarget = true,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Howl",
        Tooltip = "Stun close enemies for 2 seconds and enrage nearby allies.",
        Icon = "Roar",
        Enabled = true
    },
}

WeaponAbilitiesData.Hibernate = {
    MobileEffect = "Hibernate",
    Stamina = 20,
    Instant = true,
    NoTarget = true,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Hibernate",
        Tooltip = "Stop all actions for a defence boost, and fast health regen.",
        Icon = "Roar",
        Enabled = true
    },
}

    WeaponAbilitiesData.PoisonSplash = {
    MobileEffect = "PoisonCloud",
    Stamina = 20,
    Instant = true,
    NoTarget = true,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Poison Splash",
        Tooltip = "Inflicts poison around nearby mobs.",
        Icon = "Roar",
        Enabled = true
    },
}

WeaponAbilitiesData.Dart = {
    MobileEffect = "Dart",
    Stamina = 20,
    Instant = true,
    NoTarget = true,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Dart",
        Tooltip = "Dart.",
        Icon = "Roar",
        Enabled = true
    },
}