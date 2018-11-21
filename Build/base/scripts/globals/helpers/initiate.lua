function CheckInitiate(player)
	if ( ServerSettings.NewPlayer.InitiateSystemEnabled ) then
        local initiateMinutes = player:GetObjVar("InitiateMinutes")
        if ( initiateMinutes ) then
            initiateMinutes = initiateMinutes - 1

            if ( initiateMinutes < 1 ) then
                player:SendMessage("EndNPE")
            else
                -- keep at it a bit longer..
                player:SetObjVar("InitiateMinutes", initiateMinutes)
            end
        end
	end
end

function IsInitiate(player)
	return player:HasObjVar("InitiateMinutes")
end

function EndInitiate(player)
    return player:SendMessage("EndNPE")
end