function CheckGmMessage(player)
    if ( player == nil ) then
        return
    end

    local globalVarKey = "AccountMessages."..player:GetAttachedUserId()
    local gmMessages = GlobalVarRead(globalVarKey)

    if (gmMessages == nil) then
    	return
    end

    OpenGmMessage(player, gmMessages, globalVarKey, 1)
end

--Open friend request prompt window on a target character
function OpenGmMessage(player, gmMessages, globalVarKey, gmMessageNumber)

    local playerName = player:GetCharacterName() or "Unknown"

    local gmMessageToShow = gmMessages[1]

    ClientDialog.Show {
        TargetUser = player,
        DialogId = "GmMessage"..player.Id..tostring(gmMessageNumber),
        TitleStr = gmMessageToShow.Title,
        DescStr = gmMessageToShow.Message,
        Button1Str = "Acknowledged",
        ResponseObj = player,
        ResponseFunc = function(user,buttonId)

            if ( user == nil ) then return end

            table.remove(gmMessages,1)

            if (gmMessages[1] == nil) then
            	DelGlobalVar(globalVarKey)
            	return
            end

            --If there is some message left, update the global var
			SetGlobalVar(globalVarKey, function(record)
				table.remove(record,1)
				return true
			end)

			OpenGmMessage(player, gmMessages, globalVarKey, gmMessageNumber + 1)

            return
        end
    }
end