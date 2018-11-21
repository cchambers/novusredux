
RegisterEventHandler(EventType.Message, "GroupChat", function(message, name)
	GroupChat(this, message, name)
end)

RegisterEventHandler(EventType.Message, "GroupInfo", function(message, updateUi)
	GroupInfo(this, message, updateUi)
end)

RegisterEventHandler(EventType.Message, "GroupJoiningDone", function()
	this:DelObjVar("JoiningGroup")
end)

RegisterEventHandler(EventType.Message, "OnGroupJoin", function(groupId, member)
	CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
		if ( member == this ) then
			SetGroupId(this, groupId)
			if not( this:HasModule("group_ui") ) then
				this:AddModule("group_ui")
			end
			GroupInfo(this, "You have joined a group.", true)
		else
			local name = "Unknown"
			if ( member:IsValid() ) then
				name = StripColorFromString(member:GetName())
			else
				name = GlobalVarReadKey("User.Name", member)
			end
			GroupInfo(this, string.format("%s has joined your group.", name), true)
		end
	end)
end)

RegisterEventHandler(EventType.Message, "OnGroupDisconnect", function(member)
	if ( member ~= this ) then
		CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
			GroupInfo(this, string.format("%s has disconnected.", GlobalVarReadKey("User.Name", member)), true)
		end)
	end
end)

RegisterEventHandler(EventType.Message, "OnGroupConnect", function(member)
	if ( member ~= this ) then
		CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
			GroupInfo(this, string.format("%s has connected.", GlobalVarReadKey("User.Name", member)), true)
		end)
	end
end)

RegisterEventHandler(EventType.Message, "OnGroupDestroy", function()
	GroupClearPlayer(this)
	CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
		GroupInfo(this, "Your group has been disbanded.", true)
	end)
end)

RegisterEventHandler(EventType.Message, "OnGroupLeave", function(member)
	if ( member == this ) then
		GroupClearPlayer(this)
		GroupInfo(this, "You have left your group.", true)
	else
		local name = "Unknown"
		if ( member:IsValid() ) then
			name = StripColorFromString(member:GetName())
		else
            name = GlobalVarReadKey("User.Name", member)
		end
		GroupInfo(this, string.format("%s has left your group.", name), true)
	end
end)

RegisterEventHandler(EventType.Message, "OnGroupLeader", function(leader)
	CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
		if ( leader == this ) then
			if not( this:HasModule("group_ui") ) then
				this:AddModule("group_ui")
			end
			GroupInfo(this, "You are now the leader of your group.", true)
		else
			this:SendMessage("GroupUpdate")
		end
	end)
end)

RegisterEventHandler(EventType.Message, "OnGroupLoot", function(loot)
	CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
		if ( loot ) then
			GroupInfo(this, string.format("Group looting changed to %s.", loot), true)
		end
	end)
end)

RegisterEventHandler(EventType.Message, "GroupRemoveMember", function(groupId)
	GroupRemoveMember(groupId, this)
end)

-- register some functions for SendMessageGlobal and inter-region invitation.
RegisterEventHandler(EventType.Message, "GroupInvitePrompt", function(player, groupId)
	GroupInvitePrompt(player, this, groupId)
end)

RegisterEventHandler(EventType.Message, "GroupInviteConfirm", function(target, groupId)
	GroupInviteConfirm(this, target, groupId)
end)

RegisterEventHandler(EventType.Message, "GroupInviteDecline", function()
	GroupInviteDecline(this)
end)