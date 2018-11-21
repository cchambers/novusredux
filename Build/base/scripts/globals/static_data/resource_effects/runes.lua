ResourceEffectData.Rune = {
    MobileEffect = "Rune",
    MobileEffectArgs = {
        UseType = "bury"
    },
    SelfOnly = true,
    NoConsume = true,
    Tooltip = {
        "Use this to summon a portal to a marked location. Must be marked before it can be used.",
    },

    UseCases = {
        "Bury",
        "Rename",
    },
    MobileEffectUseCases = {}
}

ResourceEffectData.Rune.MobileEffectUseCases["Rename"] = {
    MobileEffect = "Rune",
    MobileEffectArgs = {
        UseType = "rename"
    },
}

ResourceEffectData.EldeirVillage = {
    NoUse = true,
    Tooltip = {
        ServerSettings.Teleport.Destination.EldeirVillage.DisplayName,
    }
}

ResourceEffectData.Helm = {
    NoUse = true,
    Tooltip = {
        ServerSettings.Teleport.Destination.Helm.DisplayName,
    }
}

ResourceEffectData.PyrosLanding = {
    NoUse = true,
    Tooltip = {
        ServerSettings.Teleport.Destination.PyrosLanding.DisplayName,
    }
}

ResourceEffectData.Oasis = {
    NoUse = true,
    Tooltip = {
        ServerSettings.Teleport.Destination.Oasis.DisplayName,
    }
}

ResourceEffectData.Valus = {
    NoUse = true,
    Tooltip = {
        ServerSettings.Teleport.Destination.Valus.DisplayName,
    }
}

ResourceEffectData.Crossroads = {
    NoUse = true,
    Tooltip = {
        ServerSettings.Teleport.Destination.Crossroads.DisplayName,
    }
}

ResourceEffectData.BlackForest = {
    NoUse = true,
    Tooltip = {
        ServerSettings.Teleport.Destination.BlackForest.DisplayName,
    }
}