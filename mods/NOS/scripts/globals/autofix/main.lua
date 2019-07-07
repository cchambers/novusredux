
AutoFixes = {}

-- This relies on the table size and ordering, never delete/reorder anything required below!!

require 'globals.autofix.1_karma_reset'
require 'globals.autofix.2_secure_house_containers'
require 'globals.autofix.3_books_containers_and_bless'
require 'globals.autofix.4_secure_toggle_friends'
require 'globals.autofix.5_allegiance_friendly_factions'
require 'globals.autofix.6_jewelry_durability'
require 'globals.autofix.7_tax_interval'
require 'globals.autofix.8_full_tooltip_update'
require 'globals.autofix.9_full_tooltip_update'
require 'globals.autofix.10_tooltips'
require 'globals.autofix.11_many_fixes'
require 'globals.autofix.12_statue_mount_to_pet'
require 'globals.autofix.13_tax_return'
require 'globals.autofix.14_pet_statues'
require 'globals.autofix.15_auction_start_time'

function DoPlayerAutoFix(player)
    if ( player and player:IsValid() ) then
        local lastFix = player:GetObjVar("LastAutoFix") or 0
        while ( lastFix < #AutoFixes ) do
            lastFix = lastFix + 1
            if ( AutoFixes[lastFix] and AutoFixes[lastFix].Player ) then
                AutoFixes[lastFix].Player(player)
            end
            player:SetObjVar("LastAutoFix", lastFix)
        end
    end
end

function DoWorldAutoFix(clusterController)
    if ( clusterController and clusterController:IsValid() ) then
        local lastFix = clusterController:GetObjVar("LastAutoFix") or 0
        while ( lastFix < #AutoFixes ) do
            lastFix = lastFix + 1
            if ( AutoFixes[lastFix] and AutoFixes[lastFix].World ) then
                DebugMessage("Applying World Autofix #", lastFix)
                AutoFixes[lastFix].World(clusterController)
            end
            clusterController:SetObjVar("LastAutoFix", lastFix)
        end
    end
end

function AutoFixReplaceItem(item, template, cb)
    local containedBy = item:ContainedBy()
    local loc = item:GetLoc()
    if ( containedBy ) then
        -- replace in container, easy peasy.
        Create.InContainer(template, containedBy, loc, cb)
    else
        -- replace when locked down, little more difficult.
        local controller = Plot.GetAtLoc(loc)
        if ( controller and controller:IsValid() ) then
            Create.AtLoc(template, loc, function(itm)
                itm:SetObjVar("LockedDown",true)
                itm:SetObjVar("NoReset",true)
                itm:SetObjVar("PlotController", controller)
                SetTooltipEntry(itm,"locked_down","Locked Down",98)
                
                local house = Plot.GetHouseAt(controller, loc, false, true) -- checking roof bounds
                if ( house ) then
                    itm:SetObjVar("PlotHouse", house)
                end
                
                if ( itm:DecayScheduled() ) then
                    itm:RemoveDecay()
                end
                if ( cb ) then cb(itm) end
            end)
        else
            if ( cb ) then cb(nil) end
        end
    end
    item:Destroy()
end