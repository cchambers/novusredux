

ResourceEffectData.MountStatue = {
    MobileEffect = "MountSummon",
    MobileEffectObjectAsTarget = true, -- pass the used object as the target.
    SelfOnly = true,
    NoConsume = true,
    Tooltip = {
        "Summon this dismissed mount.",
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
    MobileEffectArgs = {
    },
    SelfOnly = true,
    NoConsume = true,
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
    Tooltip = {
        "Use this to instantly teleport to the nearest escape location.",
    },

    UseCases = {
        "Recite",
    },
    MobileEffectUseCases = {}
}

ResourceEffectData.BlessDeed = {
    NoAutoTarget = true,
    MobileEffect = "Bless",
    TargetMessage = "Select the item you wish to bless.",
    Tooltip = {
        "Bless one item of clothing. Blessed clothing stays with you upon death.",
    }
}

ResourceEffectData.CurseScroll = {
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
    NoConsume = true,
    SelfOnly = true,
    MobileEffect = "LotteryBox",
}

ResourceEffectData.GuildCharter = {
    MobileEffect = "GuildCharter",
    MobileEffectArgs = {
    },
    SelfOnly = true,
    NoConsume = true,
    Tooltip = {
        "Used to form a guild.",
    },

    UseCases = {
        "Edit",
    },
    MobileEffectUseCases = {}
}
