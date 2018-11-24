

ResourceEffectData.LandDeed = {
    NoConsume = true,
    SelfOnly = true,
    NoAutoTarget = true,
    MobileEffect = "LandDeed",
    MobileEffectObjectAsTarget = true, -- pass the used object as the target parameter
    Tooltip = {
        "Claim some land for yourself, will require tax payments to remain in your possession."
    }
}

ResourceEffectData.PackedObject = {
    NoConsume = true,
    SelfOnly = true,
    NoAutoTarget = true,
    MobileEffect = "PackedObject",
    MobileEffectObjectAsTarget = true, -- pass the used object as the target parameter

    UseCases = {
        "Unpack",
    },

    InitFunc = function(item)
        -- set the name of the item by what it unpacks
        local template = item:GetObjVar("UnpackedTemplate")
        if ( template ~= nil ) then
            local templateData = GetTemplateData(template)
            if(templateData ~= nil) then
                item:SetName(StripColorFromString(templateData.Name).." (Packed)")
            end
        end
    end,
    
    Tooltip = {
        "Can be unpacked and placed on land you control."
    }
}

ResourceEffectData.HouseBlueprint = {
    NoConsume = true,
    SelfOnly = true,
    NoAutoTarget = true,
    MobileEffect = "HouseBlueprint",
    MobileEffectObjectAsTarget = true, -- pass the used object as the target parameter
    MobileEffectArgs = {Direction=2},

    UseCases = {
        "Facing South", -- first is default
        "Facing East",
        "Facing North",
        "Facing West",
    },
    MobileEffectUseCases = {},

    Tooltip = {
        "Place a house foundation that can be built into a house."
    },

    TooltipFunc = function(tooltipInfo, item)
        local houseType = item:GetObjVar("HouseType")
        if ( houseType ~= nil and HouseData[houseType] and HouseData[houseType].min ) then
            tooltipInfo["HouseSize"] = {
                TooltipString = string.format("\nSize %dx%d", HouseData[houseType].min[1], HouseData[houseType].min[2]),
                Priority = -9999,
            }
        end
        return tooltipInfo
    end
}

ResourceEffectData.HouseBlueprint.MobileEffectUseCases["Facing North"] = {
    MobileEffect = "HouseBlueprint",
    MobileEffectArgs = {Direction=1},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.HouseBlueprint.MobileEffectUseCases["Facing East"] = {
    MobileEffect = "HouseBlueprint",
    MobileEffectArgs = {Direction=3},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.HouseBlueprint.MobileEffectUseCases["Facing West"] = {
    MobileEffect = "HouseBlueprint",
    MobileEffectArgs = {Direction=4},
    MobileEffectObjectAsTarget = true,
}


ResourceEffectData.PlotController = {
    NoConsume = true,
    SelfOnly = true,
    NoAutoTarget = true,
    --MobileEffectDropHandle = "PlotDropHandle",
    Range = ServerSettings.Plot.MaximumSize, -- allows to be used outside of backpack
    MobileEffect = "PlotController",
    MobileEffectObjectAsTarget = true, -- pass the used object as the target.
    UseCases = {
        "Manage Plot", -- first one is always default interaction        
        "God Destroy",
    },
    UseCaseConditions = {
        "",        
        "IsGod",
    },
    Tooltip = {},
    TooltipFunc = function(tooltipInfo, item)
        tooltipInfo["plot_name"] = {
            TooltipString = item:GetObjVar("PlotName"),
            Priority = 9,
        }
        return tooltipInfo
    end,
    MobileEffectUseCases = {},
}

-- continuation of PlotController
ResourceEffectData.PlotController.MobileEffectUseCases["+Adjust North"] = {
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {1,0,0,0},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["+Adjust South"] = {
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {0,1,0,0},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["+Adjust East"] = {
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {0,0,1,0},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["+Adjust West"] = {
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {0,0,0,1},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["-Adjust North"] = {
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {-1,0,0,0},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["-Adjust South"] = {
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {0,-1,0,0},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["-Adjust East"] = {
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {0,0,-1,0},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["-Adjust West"] = {
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {0,0,0,-1},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["God Destroy"] = {
    MobileEffect = "PlotDestroy",
    MobileEffectArgs = {GodDestroy=true},
    MobileEffectObjectAsTarget = true,
}



ResourceEffectData.HouseController = {
    NoConsume = true,
    SelfOnly = true,
    NoAutoTarget = true,
    Range = 40, -- allows to be used outside of backpack
    MobileEffect = "HouseController",
    MobileEffectObjectAsTarget = true, -- pass the used object as the target.
    UseCases = {
        "Use", -- first one is always default interaction
    },
    UseCaseConditions = {
        "HasHouseControl",
    },
    Tooltip = {},
    MobileEffectUseCases = {},
}


ResourceEffectData.HouseDoor = {
    NoConsume = true,
    SelfOnly = true,
    NoAutoTarget = true,
    Range = 5, -- allows to be used outside of backpack
    MobileEffect = "HouseDoorToggle",
    MobileEffectObjectAsTarget = true, -- pass the used object as the target.
    UseCases = {
        "Open/Close", -- first one is always default interaction
        "Lock",
        "Unlock",
    },
    UseCaseConditions = {
        "",
        {"HasHouseControl", "IsUnlocked"},
        {"HasHouseControl", "IsLocked"},
    },
    Tooltip = {},
    MobileEffectUseCases = {},
}

ResourceEffectData.HouseDoor.MobileEffectUseCases["Lock"] = {
    MobileEffect = "HouseDoorLock",
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.HouseDoor.MobileEffectUseCases["Unlock"] = {
    MobileEffect = "HouseDoorUnlock",
    MobileEffectObjectAsTarget = true,
}

ResourceEffectData.PlotSaleSign = {
    NoConsume = true,
    SelfOnly = true,
    NoAutoTarget = true,
    --MobileEffectDropHandle = "PlotDropHandle",
    Range = ServerSettings.Plot.MaximumSize, -- allows to be used outside of backpack
    MobileEffect = "PlotController",
    MobileEffectObjectAsTarget = true, -- pass the used object as the target.
    UseCases = {
        "Use", -- first one is always default interaction
    },
    UseCaseConditions = {
        "",
    },
    Tooltip = {},
    MobileEffectUseCases = {},
}