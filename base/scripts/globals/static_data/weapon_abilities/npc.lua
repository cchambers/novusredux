
WeaponAbilitiesData.DragonFire = {
    MobileEffect = "DragonFire",
    Stamina = 5,
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
    Action = {
        DisplayName = "Poison",
        Tooltip = "Poison your enemy.",
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
    }
}