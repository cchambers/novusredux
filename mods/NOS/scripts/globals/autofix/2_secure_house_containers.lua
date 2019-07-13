
--- Fixing secure house containers
local index = #AutoFixes + 1
local totalSecure = 0

AutoFixes[index] = {
    DoFix = function(object)
        if ( not object or not object:IsValid() ) then return end

        -- secure containers that were not placed secure but are in a secure area since fixes.
        if ( object:IsContainer() and object:HasObjVar("LockedDown") and not object:HasObjVar("SecureContainer") ) then
            local controller = object:GetObjVar("PlotController")
            if ( controller ) then
                local house = Plot.GetHouseAt(controller, object:GetLoc(), false, true) -- checking roof bounds
                if ( house ) then
                    SetTooltipEntry(object,"locked_down","Secure",98)
                    -- remove a plot lockdown
                    Plot.AlterLockCountBy(controller, -1)
                    -- add a house container
                    Plot.AlterContainerCountBy(house, 1)
                    object:SetObjVar("SecureContainer", true)
                    object:SetObjVar("locked", true)
                    object:SetObjVar("PlotHouse", house)

                    DebugMessage("Fixed Secure Chest:", object.Id)
                    totalSecure = totalSecure + 1
                end
            end
        end
    end,
}

AutoFixes[index].World = function(clusterController)
    local worldObjects = FindObjects(SearchObjVar("NoReset", true))
    local before = DateTime.UtcNow
    DebugMessage("[AutoFix] "..#worldObjects.." World Objects found via NoReset ObjVar.")
    for i=1,#worldObjects do
        AutoFixes[index].DoFix(worldObjects[i])
    end
    DebugMessage("[AutoFix] World Objects Done. TotalMS: "..DateTime.UtcNow:Subtract(before).TotalMilliseconds)
    DebugMessage("[AutoFix] "..totalSecure.." Total Secure Chests Fixed.")
end