
--- Fixing some prestige books/container limits/blessed items
local index = #AutoFixes + 1
local total = 0
local totalBlessFull = 0
local totalBlessTooltip = 0
local totalShield = 0
local totalMeditate = 0

AutoFixes[index] = {
    DoFix = function(object)
        if ( not object or not object:IsValid() ) then return end
        total = total + 1
        local template = object:GetCreationTemplateId()
        local templateData = GetTemplateData(template)

        -- fix all blessed items that are blessed in template but not blessed in world
         -- (founders rewards, etc)
        if ( templateData ~= nil and templateData.ObjectVariables and templateData.ObjectVariables.Blessed ) then
            local updateTooltip = false
            if not( object:HasObjVar("Blessed") ) then
                object:SetObjVar("Blessed", true)
                updateTooltip = true
                totalBlessFull = totalBlessFull + 1
                DebugMessage("Full Bless Fix: ", object.Id)
            end
            if not( updateTooltip ) then
                local tooltipInfo = object:GetObjVar("TooltipInfo") or {}
                if not( tooltipInfo.Blessed ) then
                    totalBlessTooltip = totalBlessTooltip + 1
                    updateTooltip = true
                    DebugMessage("Bless Tooltip Only: ", object.Id)
                end
            end
            if ( updateTooltip ) then
                object:DelObjVar("TooltipInfo")
                SetItemTooltip(object)
            end
        end

        -- fix a few prestige books
        if ( template == "prestige_spellshield" ) then
            AutoFixReplaceItem(object, "prestige_magearmor", function(item)
                if ( item ) then
                    DebugMessage("Fixed prestige_magearmor: ", item.Id)
                end
            end)
            totalShield = totalShield + 1
            return
        elseif ( template == "prestige_meditate" ) then
            object:SetObjVar("PrestigeAbility", "Meditation")
            object:DelObjVar("TooltipInfo")
            object:DelObjVar("UseCases")
            SetItemTooltip(object)
            object:DelModule("prestige_ability_book")
            object:AddModule("prestige_ability_book")
            totalMeditate = totalMeditate + 1
            DebugMessage("Fixed prestige_meditate: ", object.Id)
            return
        end

        -- update container capacity
        if ( object:HasSharedObjectProperty("Capacity") ) then
            if ( templateData and templateData.SharedObjectProperties and templateData.SharedObjectProperties.Capacity ) then
                object:SetSharedObjectProperty("Capacity", templateData.SharedObjectProperties.Capacity)
            end
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
    DebugMessage("[AutoFix] "..totalBlessFull.." Total Full Bless Fixed.")
    DebugMessage("[AutoFix] "..totalBlessTooltip.." Total Bless Tooltip Only.")
    DebugMessage("[AutoFix] "..totalShield.." Total prestige_spellshield Replaced.")
    DebugMessage("[AutoFix] "..totalMeditate.." Total prestige_meditate Updated.")
    DebugMessage("[AutoFix] "..total.." Total Objects.")
end