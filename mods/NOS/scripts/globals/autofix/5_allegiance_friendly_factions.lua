

AutoFixes[#AutoFixes+1] = {
    Player = function(player)
        local allegiance = GetAllegianceId(player)
        if ( allegiance ) then
            local allegianceData = GetAllegianceDataById(allegiance)
            if ( allegianceData ) then
                -- this fixes default interaction of attack on self/pets for current allegiance members.
                -- This is set for anyone new that joins an allegiance.
                player:SetSharedObjectProperty("FriendlyFactions", allegianceData.Icon)
            end
        end
    end
}