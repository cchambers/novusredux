
WeaponAbilitiesData.Stun = {
    TargetMobileEffect = "Stun",
    TargetMobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(1.5),
        PlayerDuration = TimeSpan.FromSeconds(1),
    },
    Stamina = 10,
    Action = {
        DisplayName = "Stun",
        Tooltip = "Stun your opponent for 1.5 seconds. Reduced to 1 second against players.",
        Icon = "Flame Mark",
        Enabled = true
    },
    SkipHitAction = true
}

WeaponAbilitiesData.Cleave = {      
    MobileEffect = "Cleave",
    MobileEffectArgs = {
        Range = 6
    },
    Stamina = 5,
    Action = {
        DisplayName = "Cleave",
        Tooltip = "Damage all targets 4 yards in front of you.",
        Icon = "Cleave",
        Enabled = true
    },
    SkipHitAction = true
}

WeaponAbilitiesData.StunPunch = {
    MobileEffect = "GeneralEffect",
    MobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(2),
        VisualEffects = {
            "BuffEffect_I"
        }
    },
    TargetMobileEffect = "Daze",
    TargetMobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(5),
    },
    Stamina = 10,
    Action = {
        DisplayName = "Stun Punch",
        Tooltip = "Daze your target for up to 5 seconds.",
        Icon = "Fire Shackles",
        Enabled = true,
    },
    SkipHitAction = true
}

WeaponAbilitiesData.Concus = {
    MobileEffect = "GeneralEffect",
    MobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(2),
        VisualEffects = {
            "BuffEffect_I"
        }
    },
    TargetMobileEffect = "Concus",
    TargetMobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(15),
        Modifier = -0.25
    },
    Stamina = 10,
    Action = {
        DisplayName = "Concus",
        Tooltip = "Your opponent's mana is reduced by 25% for 15 seconds.",
        Icon = "Sure Strike",
        Enabled = true,
    }
}

WeaponAbilitiesData.FollowThrough = {
    MobileEffect = "GeneralEffect",
    MobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(2),
        VisualEffects = {
            "BuffEffect_L"
        }
    },
    TargetMobileEffect = "AdjustStamina",
    TargetMobileEffectArgs = {
        Amount = -20,
    },
    Stamina = 10,
    Action = {
        DisplayName = "Follow Through",
        Tooltip = "Remove 20 stamina from your opponent.",
        Icon = "Hammer Smash",
        Enabled = true,
    },
}

WeaponAbilitiesData.Eviscerate = {
    MobileEffect = "GeneralEffect",
    MobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(2),
        VisualEffects = {
            "BuffEffect_M"
        }
    },  
    TargetMobileEffect = "Eviscerate",
    TargetMobileEffectArgs = {
        Duration = TimeSpan.FromMilliseconds(1500),
        WeaponDamageModifier = 1.35
    },
    Stamina = 20,
    Action = {
        DisplayName = "Eviscerate",
        Tooltip = "Cause 35% additional weapon damage 1.5 seconds after a strike.",
        Icon = "Sap2",
        Enabled = true
    }
}

WeaponAbilitiesData.Bleed = {       
    TargetMobileEffect = "Bleed",
    TargetMobileEffectArgs = {
        PulseFrequency = TimeSpan.FromSeconds(2),
        PulseMax = 5,
        DamageMin = 40,
        DamageMax = 60,
    },
    Stamina = 10,
    Action = {
        DisplayName = "Bleed",
        Tooltip = "Cause 40-60 damage a second for 20 seconds.",
        Icon = "Shred",
        Enabled = true,
    },
    SkipHitAction = true
}

WeaponAbilitiesData.Dismount = {        
    TargetMobileEffect = "Dismount",
    Stamina = 20,
    Action = {
        DisplayName = "Dismount",
        Tooltip = "Remove your foe from his mount. Cannot use while mounted.",
        Icon = "Revenge2",
        Enabled = true
    },
    SkipHitAction = true
}

WeaponAbilitiesData.Bash = {
    MobileEffect = "Bash",
    MobileEffectArgs = {
        AttackModifier = 0.25,
    },
    Stamina = 5,
    Action = {
        DisplayName = "Bash",
        Tooltip = "Increase your attack by 25%.",
        Icon = "Blessed Hammer",
        Enabled = true,
    },
    SkipHitAction = true
}

WeaponAbilitiesData.Power = {
    MobileEffect = "Power",
    MobileEffectArgs = {
        AttackModifier = 0.25,
    },
    Stamina = 10,
    Action = {
        DisplayName = "Power Shot",
        Tooltip = "Increase your attack by 25%.",
        Icon = "Wild Shot",
        Enabled = true,
    },
    SkipHitAction = true
}

WeaponAbilitiesData.Slash = {
    MobileEffect = "Slash",
    MobileEffectArgs = {
        AttackModifier = 0.25,
    },
    Stamina = 5,
    Action = {
        DisplayName = "Slash",
        Tooltip = "Increase your attack by 25%.",
        Icon = "sunder",
        Enabled = true,
    },
    SkipHitAction = true
}

WeaponAbilitiesData.Overpower = {
    MobileEffect = "Overpower",
    MobileEffectArgs = {
        AttackModifier = 0.25,
    },
    Stamina = 10,
    Action = {
        DisplayName = "Overpower",
        Tooltip = "Increase your attack by 25%.",
        Icon = "Hammer Smash",
        Enabled = true,
    },
    SkipHitAction = true
}

WeaponAbilitiesData.Stab = {
    MobileEffect = "Stab",
    MobileEffectArgs = {
        AttackModifier = 1,
        HitChanceFront = 0.4,
        HitChanceBack = 0.8,
    },
    Stamina = 10,
    Action = {
        DisplayName = "Stab",
        Tooltip = "Attempt to stab your target for a 100% attack bonus. ",
        Icon = "Fatal Strike",
        Enabled = true,
    },
    SkipHitAction = true
}

WeaponAbilitiesData.MortalStrike = {
    MobileEffect = "MortalStrike",
    MobileEffectArgs = {
        AttackModifier = -0.5,
    },
    Stamina = 10,
    Action = {
        DisplayName = "Mortal Strike",
        Tooltip = "50% Attack Power for swing, causes target to be mortally struck. They cannot heal with bandages/magic.",
        Icon = "Deep Cuts",
        Enabled = true,
    },
    SkipHitAction = true
}