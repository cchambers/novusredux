WeaponAbilitiesData.Lumberjack = {		
    MobileEffect = "Harvest",
    Stamina = 1,
    NoCombat = true,
    QueueTarget = "Any",
    Instant = true,
    Cooldown = TimeSpan.FromSeconds(3),
    Action = {
        DisplayName = "Lumberjack",
        Tooltip = "Attempt to harvest wood from a nearby tree.",
        Icon = "hatchetlumberjacking",
        Enabled = true
    },
}

WeaponAbilitiesData.Mill = {		
    MobileEffect = "Mill",
    Stamina = 0,
    NoCombat = true,
    QueueTarget = "Obj",
    Instant = true,
    Cooldown = TimeSpan.FromSeconds(2.5),
    Action = {
        DisplayName = "Mill",
        Tooltip = "Mill wood collected from trees into boards for crafting.",
        Icon = "hatchetmilling",
        Enabled = true
    },
}

WeaponAbilitiesData.Mine = {        
    MobileEffect = "Harvest",
    Stamina = 1,
    NoCombat = true,
    QueueTarget = "Any",
    Instant = true,
    Cooldown = TimeSpan.FromSeconds(3),
    Action = {
        DisplayName = "Mine",
        Tooltip = "Attempt to harvest ore from a nearby rock.",
        Icon = "miningpickmining",
        Enabled = true
    },
}

WeaponAbilitiesData.Smelt = {        
    MobileEffect = "Smelt",
    Stamina = 0,
    NoCombat = true,
    QueueTarget = "Obj",
    Instant = true,
    Cooldown = TimeSpan.FromSeconds(2.5),
    Action = {
        DisplayName = "Smelt",
        Tooltip = "Smelt ore collected from rocks into ingots for crafting.",
        Icon = "miningpicksmelting",
        Enabled = true
    },
}

WeaponAbilitiesData.Skinning = {        
    MobileEffect = "Harvest",
    Stamina = 0,
    NoCombat = true,
    QueueTarget = "Obj",
    Instant = true,
    Cooldown = TimeSpan.FromSeconds(5),
    Action = {
        DisplayName = "Skinning",
        Tooltip = "Attempt to skin a nearby corpse.",
        Icon = "huntingknifeskinning",
        Enabled = true
    },
}

WeaponAbilitiesData.HuntingKnife = {        
    MobileEffect = "HuntingKnife",
    Stamina = 0,
    NoCombat = true,
    QueueTarget = "Obj",
    Instant = true,
    Cooldown = TimeSpan.FromSeconds(2),
    Action = {
        DisplayName = "Use",
        Tooltip = "Use the hunting knife on a target.",
        Icon = "huntingknifeskinning",
        Enabled = true
    },
}

WeaponAbilitiesData.Fish = {        
    MobileEffect = "Fish",
    Stamina = 1,
    NoCombat = true,
    QueueTarget = "Loc", -- loc works for location and/or dynamic objects in the same target
    Instant = true,
    Cooldown = TimeSpan.FromSeconds(3),
    Action = {
        DisplayName = "Fish",
        Tooltip = "Attempt to fish from nearby water.",
        Icon = "fishing",
        Enabled = true
    },
}

WeaponAbilitiesData.Dig = {        
    MobileEffect = "Dig",
    Stamina = 1,
    NoCombat = true,
    QueueTarget = "Loc", -- loc works for location and/or dynamic objects in the same target
    Instant = true,
    Cooldown = TimeSpan.FromSeconds(3),
    Action = {
        DisplayName = "Dig",
        Tooltip = "Attempt to dig nearby location.",
        Icon = "shoveldig",
        Enabled = true
    },
}