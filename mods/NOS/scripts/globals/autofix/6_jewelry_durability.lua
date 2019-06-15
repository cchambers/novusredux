
--- Fixing some prestige books/container limits/blessed items
local index = #AutoFixes + 1
local totalJewelry = 0

AutoFixes[index] = {
    DoFix = function(object)
        if ( not object or not object:IsValid() ) then return end

        if not(object:HasObjVar("MaxDurability")) and object:HasObjVar("JewelryType") then
            totalJewelry = totalJewelry + 1
            object:SetObjVar("MaxDurability",40)
            SetItemTooltip(object)
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
    local worldObjects = FindObjects(SearchObjVar("NoReset", true))
    local before = DateTime.UtcNow
    DebugMessage("[AutoFix] "..#worldObjects.." World Objects found via NoReset ObjVar.")
    for i=1,#worldObjects do
        AutoFixes[index].DoFix(worldObjects[i])
    end
    DebugMessage("[AutoFix] World Objects Done. TotalMS: "..DateTime.UtcNow:Subtract(before).TotalMilliseconds)
    DebugMessage("[AutoFix] "..totalJewelry.." Total jewelry Updated.")
end