ResourceEffectData.MapAtlas = {
    MobileEffect = "MapAtlas",
    MobileEffectArgs = {
        UseType = "open"
    },
    SelfOnly = true,
    NoConsume = true,
    Tooltip = {
        "Stores maps and waypoints.",
    },

    UseCases = {
        "Open",
        "Add Map",
        "Merge Waypoints",
        "Rename Atlas",
    },
    MobileEffectUseCases = {}
}

ResourceEffectData.MapAtlas.MobileEffectUseCases["Add Map"] = {
    MobileEffect = "MapAtlas",
    MobileEffectArgs = {
        UseType = "addMap"
    },
}

ResourceEffectData.MapAtlas.MobileEffectUseCases["Merge Waypoints"] = {
    MobileEffect = "MapAtlas",
    MobileEffectArgs = {
        UseType = "merge"
    },
}

ResourceEffectData.MapAtlas.MobileEffectUseCases["Rename Atlas"] = {
    MobileEffect = "MapAtlas",
    MobileEffectArgs = {
        UseType = "rename"
    },
}

ResourceEffectData.Map = {
    MobileEffect = "Map",
    MobileEffectArgs = {
        UseType = "open"
    },
    SelfOnly = true,
    NoConsume = true,
    Tooltip = {
        "View the map of a region.",
    },

    UseCases = {
        "Open",
        "Rename Map",
    },
    MobileEffectUseCases = {}
}

ResourceEffectData.Map.MobileEffectUseCases["Rename Map"] = {
    MobileEffect = "Map",
    MobileEffectArgs = {
        UseType = "rename"
    },
}