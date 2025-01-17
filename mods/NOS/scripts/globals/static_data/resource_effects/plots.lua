

ResourceEffectData.LandDeed = {
    NoConsume = true,
    SelfOnly = true,
    NoDismount = true,
    NoAutoTarget = true,
    MobileEffect = "LandDeed",
    MobileEffectObjectAsTarget = true, -- pass the used object as the target parameter
    Tooltip = {
        "Claim some land for yourself, will require tax payments to remain in your possession."
    }
}

ResourceEffectData.TaxCredit = {
    NoAutoTarget = true,
    NoDismount = true,
    MobileEffect = "TaxCredit",
    MobileEffectObjectAsArgs = true, -- pass the used object as the target parameter

    UseCases = {
        "Apply Credit",
    },

    UseCaseConditions = {
        "IsInBackpack"
    },

    TooltipFunc = function(tooltipInfo, item)
        local amount = item:GetObjVar("TaxCreditAmount") or 0
        if ( amount > 0 ) then
            tooltipInfo["TaxCredit"] = {
                TooltipString = string.format("Increase a plot's tax balance by %s.", ValueToAmountStr(amount)),
                Priority = -9999,
            }
        end
        return tooltipInfo
    end
}

ResourceEffectData.PackedObject = {
    NoConsume = true,
    SelfOnly = true,
    NoAutoTarget = true,
    NoDismount = true,
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
    NoDismount = true,
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
    NoDismount = true,
    MobileEffect = "HouseBlueprint",
    MobileEffectArgs = {Direction=1},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.HouseBlueprint.MobileEffectUseCases["Facing East"] = {
    NoDismount = true,
    MobileEffect = "HouseBlueprint",
    MobileEffectArgs = {Direction=3},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.HouseBlueprint.MobileEffectUseCases["Facing West"] = {
    NoDismount = true,
    MobileEffect = "HouseBlueprint",
    MobileEffectArgs = {Direction=4},
    MobileEffectObjectAsTarget = true,
}


ResourceEffectData.PlotController = {
    NoConsume = true,
    SelfOnly = true,
    NoAutoTarget = true,
    NoDismount = true,
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
    NoDismount = true,
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {1,0,0,0},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["+Adjust South"] = {
    NoDismount = true,
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {0,1,0,0},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["+Adjust East"] = {
    NoDismount = true,
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {0,0,1,0},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["+Adjust West"] = {
    NoDismount = true,
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {0,0,0,1},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["-Adjust North"] = {
    NoDismount = true,
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {-1,0,0,0},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["-Adjust South"] = {
    NoDismount = true,
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {0,-1,0,0},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["-Adjust East"] = {
    NoDismount = true,
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {0,0,-1,0},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["-Adjust West"] = {
    NoDismount = true,
    MobileEffect = "PlotAdjust",
    MobileEffectArgs = {0,0,0,-1},
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.PlotController.MobileEffectUseCases["God Destroy"] = {
    NoDismount = true,
    MobileEffect = "PlotDestroy",
    MobileEffectArgs = {GodDestroy=true},
    MobileEffectObjectAsTarget = true,
}



ResourceEffectData.HouseController = {
    NoConsume = true,
    SelfOnly = true,
    NoAutoTarget = true,
    NoDismount = true,
    Range = 40, -- allows to be used outside of backpack
    MobileEffect = "HouseController",
    MobileEffectObjectAsTarget = true, -- pass the used object as the target.
    UseCases = {
        "Use", -- first one is always default interaction
    },
    UseCaseConditions = {
        "HasHouseControl",
    },
    Tooltip = {
        "House Sign"
    },
    MobileEffectUseCases = {},
}


ResourceEffectData.HouseDoor = {
    NoConsume = true,
    SelfOnly = true,
    NoAutoTarget = true,
    NoDismount = true,
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
    Tooltip = {
        "Door"
    },
    MobileEffectUseCases = {},
}

ResourceEffectData.HouseDoor.MobileEffectUseCases["Lock"] = {
    NoDismount = true,
    MobileEffect = "HouseDoorLock",
    MobileEffectObjectAsTarget = true,
}
ResourceEffectData.HouseDoor.MobileEffectUseCases["Unlock"] = {
    NoDismount = true,
    MobileEffect = "HouseDoorUnlock",
    MobileEffectObjectAsTarget = true,
}

ResourceEffectData.PlotSaleSign = {
    NoDismount = true,
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