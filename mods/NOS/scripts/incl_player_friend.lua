RegisterEventHandler(EventType.Message, "FriendRequestReceived", 
	function(player)
		FriendRequestPrompt(player, this)
	end)

RegisterEventHandler(EventType.Message, "AcceptFriendRequestConfirm",
	function(target)
		AcceptFriendRequestConfirm(this, target)
	end)

RegisterEventHandler(EventType.Message, "AddPlayerToFriendList",
	function(target)
		AddPlayerToFriendList(this, target)
	end)

RegisterEventHandler(EventType.Message, "UpdateFriendList",
	function()
		if (this:HasModule("friend_ui")) then
			this:SendMessage("FriendUpdate")
		else
			this:AddModule("friend_ui")
		end
	end)

RegisterEventHandler(EventType.Message, "RemoveFriendFromChatChannel",
	function(target)
		RemoveFriendFromChatChannel(this, target)
	end)

RegisterEventHandler(EventType.Message, "CheckPlayerInFriendList",
	function(target)
		if not (IsInFriendList(this, target)) then
			target:SendMessageGlobal("ChangeInBothList", this, false)
		else
			target:SendMessageGlobal("ChangeInBothList", this, true)
		end
	end)

RegisterEventHandler(EventType.Message, "ChangeInBothList",
	function(target, value)
		local friendList = this:GetObjVar("FriendList")
		if (friendList == nil) then
			return
		end

		for i=1,#friendList,1 do
			local friend = friendList[i].Friend
			if (friend == target) then
				friendList[i].InBothList = value
				if (GlobalVarReadKey("User.Online", friend)) then
					friendList[i].Online = value
				end
				break
			end
		end

		this:SetObjVar("FriendList", friendList)

		if (this:HasModule("friend_ui")) then
			this:SendMessage("FriendUpdate")
		end
	end)