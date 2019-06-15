
-- lua accesses local variables faster than global
local ss = ServerSettings

function CheckInitiate(player)
	if ( ss.NewPlayer.InitiateSystemEnabled ) then
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

--= remove player's initiate status after leaving protection and remaining out of protection for too long.
-- @param player
-- @param protection
-- @return none
function CheckInitiateProtection(player, protection)
    if ( ss.NewPlayer.InitiateProtectionWarning == nil ) then return end
	if ( IsInitiate(player) ) then
		local inProtection = ( protection == "Protection" or protection == "Town" )
		local removeAt = player:GetObjVar("InitiateRemoveAt")
		if ( removeAt == nil ) then
			if not( inProtection ) then
				player:SetObjVar("InitiateRemoveAt", DateTime.UtcNow:Add(ss.NewPlayer.InitiateProtectionWarning))
                ClientDialog.Show{
                    TargetUser = player,
                    DialogId = "InitiateWarning",
                    TitleStr = "[FF0000]WARNING[-]",
                    DescStr = string.format("You are leaving the protected area and will lose your initiate status in %s if you do not return.", TimeSpanToWords(ss.NewPlayer.InitiateProtectionWarning)),
                    Button1Str = "Ok",
                }
			end
		else
			if ( DateTime.UtcNow >= removeAt ) then
				if not( inProtection ) then
                    -- remove initiate
                    EndInitiate(player)
				else
					player:DelObjVar("InitiateRemoveAt")
				end
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