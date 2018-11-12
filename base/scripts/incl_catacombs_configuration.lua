function GetCatacombsConfigController()
    return FindObject(SearchTemplate("catacombs_spawn_controller"))    
end

function GetNextCatacombsConfigurationTime()
    local configController = GetCatacombsConfigController()
    if (configController == nil) then
        return nil,nil
    end

    local delay = configController:GetTimerDelay("ConfigNotifyResetTimer")
    if (delay == nil) then
        return nil,nil        
    end

    return delay.Hours, delay.Minutes
end

function GetCurrentCatacombsConfiguration()
    local configController = GetCatacombsConfigController()
    if (configController == nil) then
        return nil
    end

    return configController:GetObjVar("Config") 
end