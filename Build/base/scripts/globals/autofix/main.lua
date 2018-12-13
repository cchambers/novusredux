
AutoFixes = {}

-- This relies on the table size and ordering, never delete/reorder anything required below!!

require 'globals.autofix.1_karma_reset'

function DoAutoFix(player)
    if ( player and player:IsValid() ) then
        local lastFix = player:GetObjVar("LastAutoFix") or 0
        while ( lastFix < #AutoFixes ) do
            lastFix = lastFix + 1
            if ( AutoFixes[lastFix] ) then
                AutoFixes[lastFix](player)
            end
            player:SetObjVar("LastAutoFix", lastFix)
        end
    end
end