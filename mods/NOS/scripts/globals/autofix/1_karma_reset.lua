
-- Issues caused by looting advancing players was allowing negative actions to happen where they shouldn't have
-- This will set everyone's alignment back to default and set their karma to 1 if it's negative.

AutoFixes[#AutoFixes+1] = {
    Player = function(player)
        -- remove old auto fix
        if ( player:HasModule("autofix") ) then
            player:DelModule("autofix")
        end

        -- set karma alignment to Peaceful
        player:SetObjVar("KarmaAlignment", ServerSettings.Karma.NewPlayerKarmaAlignment)
        player:SendClientMessage("SetKarmaState", "Peaceful")

        -- reset karma if they have negative karma
        local karma = GetKarma(player)
        if ( karma < 0 ) then
            player:SetObjVar("Karma", 51) -- (51 cause Daily login Bonus + 1 as new starting number)
            player:SendMessage("UpdateName")
            player:SystemMessage("Your Karma has been reset.", "event")
        end
        
    end
}