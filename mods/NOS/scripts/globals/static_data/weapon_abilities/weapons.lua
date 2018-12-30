
WeaponAbilitiesData.Stun = {
    TargetMobileEffect = "Stun",
    TargetMobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(1.5),
        PlayerDuration = TimeSpan.FromSeconds(1),
    },
    Stamina = 25,
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
    Stamina = 25,
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
        Duration = TimeSpan.FromSeconds(3),
    },
    Stamina = 25,
    Action = {
        DisplayName = "Stun Punch",
        Tooltip = "Daze your target for up to 3 seconds.",
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
        Duration = TimeSpan.FromSeconds(5),
        Modifier = -0.5
    },
    Stamina = 25,
    Action = {
        DisplayName = "Concus",
        Tooltip = "Your opponent's mana is reduced by 50% for 5 seconds.",
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
        Amount = -40,
    },
    Stamina = 25,
    Action = {
        DisplayName = "Follow Through",
        Tooltip = "Remove 40 stamina from your opponent.",
        Icon = "Shield Breaker",
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
    Stamina = 25,
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
    Stamina = 25,
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

WeaponAbilitiesData.Overpower = {
    MobileEffect = "Overpower",
    MobileEffectArgs = {
        AttackModifier = 0.50,
    },
    Stamina = 25,
    Action = {
        DisplayName = "Overpower",
        Tooltip = "Increase your attack by 50%.",
        Icon = "Whirlwind",
        Enabled = true,
    },
    SkipHitAction = true
}

WeaponAbilitiesData.Stab = {
    MobileEffect = "Stab",
    MobileEffectArgs = {
        AttackModifier = 0.25,
        StealthAttackModifier = 2,
    },
    Stamina = 25,
    Action = {
        DisplayName = "Stab",
        Tooltip = "Attempt to stab your target 25% attack bonus. Stabbing from stealth rewards 200% attack bonus.",
        Icon = "Fatal Strike",
        Enabled = true,
    },
    SkipHitAction = true,
    AllowCloaked = true, -- the "Stab" effect will break cloak.
}

WeaponAbilitiesData.Sunder = {
    MobileEffect = "GeneralEffect",
    MobileEffectArgs = {
        Duration = TimeSpan.FromSeconds(2),
        VisualEffects = {
            "BuffEffect_M"
        },
        SoundEffects = {
            "event:/character/combat_abilities/female_shout"
        }
    },
    TargetMobileEffect = "Sunder",
    Stamina = 25,
    Action = {
        DisplayName = "Sunder",
        Tooltip = "Sunder target for up to 10 seconds. Next physical attack will ignore all equipped armor and clear the effect.",
        Icon = "Windshot",
        Enabled = true,
    },
    SkipHitAction = true
}

WeaponAbilitiesData.MortalStrike = {
    MobileEffect = "MortalStrike",
    MobileEffectArgs = {
        AttackModifier = -0.5,
    },
    Stamina = 25,
    Action = {
        DisplayName = "Mortal Strike",
        Tooltip = "50% Attack Power for swing, causes target to be mortally struck. They cannot heal with bandages/magic.",
        Icon = "Deep Cuts",
        Enabled = true,
    },
    SkipHitAction = true
}

WeaponAbilitiesData.TelecrookMove = {
    MobileEffect = "TelecrookMove",
    Stamina = 0,
    NoCombat = true,
    AllowMounted = true,
    QueueTarget = "Loc",
    Instant = true,
    Cooldown = TimeSpan.FromSeconds(0),
    Action = {
        DisplayName = "Move",
        Tooltip = "Teleport yourself or another object somewhere.",
        Icon = "Leap",
        Enabled = true
    },
}

WeaponAbilitiesData.TelecrookRes = {
    MobileEffect = "TelecrookRes",
    Stamina = 0,
    NoCombat = true,
    AllowMounted = true,
    QueueTarget = "Loc",
    Instant = true,
    Cooldown = TimeSpan.FromSeconds(0),
    Action = {
        DisplayName = "Res",
        Tooltip = "Force resurrect someone.",
        Icon = "Regrowth",
        Enabled = true
    },
}

WeaponAbilitiesData.CrookCalm = {
    MobileEffect = "CrookCalm",
    Stamina = 0,
    NoCombat = true,
    AllowMounted = true,
    QueueTarget = "Loc",
    Instant = true,
    Cooldown = TimeSpan.FromSeconds(0),
    Action = {
        DisplayName = "Calm",
        Tooltip = "Attempt to calm an aggressive creature.",
        Icon = "Regrowth",
        Enabled = true
    },
}
