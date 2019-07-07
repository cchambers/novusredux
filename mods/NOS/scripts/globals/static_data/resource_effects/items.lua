

ResourceEffectData.MountStatue = {
    MobileEffect = "Mount",
    MobileEffectObjectAsTarget = true, -- pass the used object as the target.
    SelfOnly = true,
    NoConsume = true,
    Tooltip = {
        "Summon this mount.",
    },

    UseCases = {
        "Summon",
    },
    UseCaseConditions = { 
        "HasObject",
    }
}

ResourceEffectData.PetStatue = {
    MobileEffect = "PetSummon",
    MobileEffectObjectAsTarget = true, -- pass the used object as the target.
    SelfOnly = true,
    NoConsume = true,
    Tooltip = {
        "Summon this dismissed pet.",
    },

    UseCases = {
        "Summon",
    },
    UseCaseConditions = { 
        "HasObject",
    }
}

ResourceEffectData.Hearthstone = {
    MobileEffect = "Hearthstone",
    SelfOnly = true,
    NoConsume = true,
    NoDismount = true,
    Tooltip = {
        "Teleports you to your bind location.\n\nCooldown: "..ServerSettings.Misc.HearthstoneCooldown.TotalMinutes.." minutes",
    },

    UseCases = {
        "Activate",
    },
    MobileEffectUseCases = {}
}

ResourceEffectData.EscapeScroll = {
    MobileEffect = "EscapeScroll",
    MobileEffectArgs = {
    },
    SelfOnly = true,
    NoConsume = true,
    NoDismount = true,
    Tooltip = {
        "Teleports you to the nearest escape location.",
    },

    UseCases = {
        "Recite",
    },
    MobileEffectUseCases = {}
}

ResourceEffectData.BlessDeed = {
    NoDismount = true,
    NoAutoTarget = true,
    MobileEffect = "Bless",
    TargetMessage = "Select the item you wish to bless.",
    Tooltip = {
        "Bless one item of clothing. Blessed clothing stays with you upon death.",
    }
}

ResourceEffectData.CurseScroll = {
    NoDismount = true,
    NoAutoTarget = true,
    MobileEffect = "Curse",
    TargetMessage = "Select the item you wish to curse.",
    Tooltip = {
        "Curse one equippable item. A cursed item stays with you upon death.",
    }
}

ResourceEffectData.Lockpick = {
    NoConsume = true,
    NoAutoTarget = true,
    MobileEffect = "Lockpick",
    MobileEffectObjectAsArgs = true, -- pass the used object as the arg, negates MobileEffectArgs parameter.
    Tooltip = {
        "Used to pick the lock on chests."
    }
}

ResourceEffectData.WaterContainer = {    
    SelfOnly = true,
    NoConsume = true,
    Tooltip = {
        "Once filled, can be used for refreshment or in cooking recipes.",
    },

    UseCases = {
        "Fill",
        "Drink"
    },

    InitFunc = function(item) UpdateWaterContainerState(item) end,

    MobileEffectUseCases = {
        Fill = {
            MobileEffect = "FillWaterContainer",
        },
        Drink = {
            MobileEffect = "DrinkContainer",            
        },
    },
}

ResourceEffectData.LotteryBox = {
    NoDismount = true,
    NoConsume = true,
    SelfOnly = true,
    MobileEffect = "LotteryBox",
}

ResourceEffectData.GuildCharter = {
    NoDismount = true,
    SelfOnly = true,
    NoConsume = true,
    MobileEffect = "GuildCharter",
    Tooltip = {
        "Used to form a guild.",
    },

    UseCases = {
        "Edit",
    }
}
