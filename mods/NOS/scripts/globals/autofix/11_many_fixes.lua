

-- includes an autofix for Escape Scrolls (old patch)
-- and autofix for lockboxes being pickable
-- fix for dropped furniture_candelabra_catacombs packed items

local index = #AutoFixes + 1
local totalItems = 0

AutoFixes[index] = {
    DoFix = function(object)
        if ( not object or not object:IsValid() ) then return end

        local resourceType = object:GetObjVar("ResourceType")
        if ( resourceType ~= nil ) then
            totalItems = totalItems + 1

            if ( object:GetObjVar("UnpackedTemplate") == "furniture_candleabra_catacombs" ) then
                object:SetObjVar("UnpackedTemplate", "furniture_candelabra_catacombs")
            end
            -- Escape Scrolls were updated as well, so let's just update all ResourceType tooltips
            object:DelObjVar("TooltipInfo")
            SetItemTooltip(object)
        elseif ( object:GetCreationTemplateId() == "lockbox" ) then
            totalItems = totalItems + 1
            -- also update lock boxes since they are pickable now
            object:SetObjVar("LockpickingDifficulty", 5)
        end

        -- recurse
        if ( object:IsContainer() ) then
            local items = object:GetContainedObjects() or {}
            for i=1,#items do
                if ( items[i] and items[i]:IsValid() ) then
                    AutoFixes[index].DoFix(items[i])
                end
            end
        end
        
    end,
}

AutoFixes[index].Player = function(player)
    ForeachMobileAndPet(player, AutoFixes[index].DoFix)
end

AutoFixes[index].World = function(clusterController)
    local worldObjects = FindObjects(SearchObjectsInWorld(),clusterController)
    local before = DateTime.UtcNow
    DebugMessage("[AutoFix] "..#worldObjects.." World Objects found.")
    for i=1,#worldObjects do
        AutoFixes[index].DoFix(worldObjects[i])
    end
    DebugMessage("[AutoFix] World Objects Done. TotalMS: "..DateTime.UtcNow:Subtract(before).TotalMilliseconds)
    DebugMessage("[AutoFix] "..totalItems.." Total items Updated.")
end