require 'base_player_guild'

PossesseeCommandFuncs = {
    -- Possessee Commands

	GuildMessage = function(...)
		Guild.SendMessage(...)
	end,

	GroupMessage = function(...)
		local player = ChangeToPossessor(this)
		GroupSendChat(player,...)
	end,

	Tell = function(userNameOrId,...)
		if( userNameOrId == nil ) then Usage("tell", this) return end

		local line = CombineArgs(...)
		if ( line ~= nil) then

			local player = nil

			if not (IsImmortal(this)) then
				local friendList = this:GetObjVar("FriendList")

				local foundFriend = false

				for i=1, #friendList, 1 do
					if (friendList[i].Friend:GetCharacterName() == userNameOrId) then
						if (foundFriend == false) then
							player = friendList[i].Friend
							foundFriend = true
						else
							this:SystemMessage("You have multiple friends with that name.")
                    		return
                    	end
					end
				end

				--This should only happen when a mortal player replies using /r
				if (player == nil and replied == true) then
					player = GetPlayerByNameOrIdGlobal(userNameOrId)
				end
			else
				player = GetPlayerByNameOrIdGlobal(userNameOrId)
			end

			replied = false

			if( player ~= nil ) then

				local name = player:GetCharacterName() or "Unknown"
				local encoded = json.encode(line)
				local msgtype = 'tell","tellto":"' .. name
        		this:LogChat(msgtype, encoded)
				player:SendMessageGlobal("PrivateMessage",this:GetName(),line,this.Id)
				this:SystemMessage("[E352EA]To "..name..":[-] "..line,"custom")
			end
		end
	end,

	ReplyTell = function(...)
		replied = true
		PossesseeCommandFuncs.Tell(mLastTeller,...)
	end,

	AddToChat = function()
        local this = this:GetObjVar("controller") or this
		local player = GetPlayerByNameOrIdGlobal(mLastTeller)

		if (player ~= nil and not FriendInChatChannel(this, player) and FriendValidForChat(this, player)) then
			AddFriendToChatChannel(this, player)
		end
	end,

	EndPossess = function ()
		--if ( HasMobileEffect(this, "Charmed") ) then
			--this:SendMessage(string.format("End%sEffect", "Charmed"))
		--else
			EndPossess(this)
		--end
	end,
}

RegisterCommand{ Command="g", AccessLevel = AccessLevel.Mortal, Func=PossesseeCommandFuncs.GuildMessage, Desc="Sends a guild message" }
RegisterCommand{ Command="group", AccessLevel = AccessLevel.Mortal, Func=PossesseeCommandFuncs.GroupMessage, Desc="Sends a group message", Aliases={"gr", "party", "p"} }
RegisterCommand{ Command="tell", AccessLevel = AccessLevel.Mortal, Func=PossesseeCommandFuncs.Tell, Usage="<name|id>", Desc="Send a private message to another player." }
RegisterCommand{ Command="r", AccessLevel = AccessLevel.Mortal, Func=PossesseeCommandFuncs.ReplyTell, Desc="Reply to a direct message." }
RegisterCommand{ Command="addtochat", AccessLevel = AccessLevel.Mortal, Func=PossesseeCommandFuncs.AddToChat, Desc="Add user from recent direct message"}
RegisterCommand{ Command="endpossess", AccessLevel = AccessLevel.Mortal, Func=PossesseeCommandFuncs.EndPossess, Desc="End possession on current mob." }