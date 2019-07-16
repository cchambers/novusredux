
--Sends friend request to target character
function SendFriendRequest(player, target)
    if ( player == nil or target == nil) then
        return false
    end

    local friendList = player:GetObjVar("FriendList")

    --If target is already in friend list, do nothing
    if (IsInFriendList(player, target, friendList)) then
        return
    end

    if (friendList ~= nil) then
        if (#friendList >= ServerSettings.Friend.MaximumSize) then
            player:SystemMessage("Maximum number of friends in a friend list has been reached. Failed to send a friend request.")
            return
        end
    end

    --If target character is in combet, do not send them friend request and inform the player character
    if (IsInCombat(target)) then
        player:SystemMessage("Friend request cannot be sent to a target in combat.","info")
        return
    end

    player:SystemMessage("Friend request sent to "..target:GetName())

    target:SendMessageGlobal("FriendRequestReceived", player)
end

--Open friend request prompt window on a target character
function FriendRequestPrompt(player, target)

    local playerName = player:GetCharacterName() or "Unknown"
    local targetName = target:GetCharacterName() or "Unknown"

    ClientDialog.Show {
        TargetUser = target,
        DialogId = "FriendRequest"..target.Id,
        TitleStr = "Friend Request",
        DescStr = string.format("%s sent a friend request to you.", playerName),
        Button1Str = "Accept",
        Button2Str = "Decline",
        ResponseObj = target,
        ResponseFunc = function(user,buttonId)
            local buttonId = tonumber(buttonId)
            if ( user == nil or buttonId == nil ) then return end

            if (buttonId == 0) then
                if ( player:IsValid() ) then
                    AcceptFriendRequestConfirm(player, target)
                else
                    player:SendMessageGlobal("AcceptFriendRequestConfirm", target)
                end
            end

            return
        end
    }
end

function AcceptFriendRequestConfirm(player, target)
    if (player == nil or target == nil) then
        return
    end

    AddPlayerToFriendList(player, target)

    --Target can be in other region
    if (target:IsValid()) then
        AddPlayerToFriendList(target, player)
    else
        target:SendMessageGlobal("AddPlayerToFriendList", player)
    end

    --We update friend list for both players after adding them to each others list
    player:SendMessage("UpdateFriendList")
    --Send message global to target since target maybe in a different region
    target:SendMessageGlobal("UpdateFriendList")
end

function AddPlayerToFriendList(player, target)
    local playerFriendList = player:GetObjVar("FriendList") or {}

    if (not IsInFriendList(player, target, playerFriendList)) then
        local friendTable = {}
        friendTable.Friend = target
        friendTable.Online = true

        playerFriendList[#playerFriendList+1] = friendTable

        player:SetObjVar("FriendList",playerFriendList)

        local targetName = target:GetName() or "Unknown"
        player:SystemMessage(targetName.." has been added to your friend list.")
    end

    player:SendMessage("ChangeInBothList", target, true)
end

--Check if target is currently in friend list
function IsInFriendList(player, target, friendList)
    if (player == nil or target == nil) then
        return
    end

    local playerFriendList = friendList or player:GetObjVar("FriendList") or {}

    for i = 1,#playerFriendList,1 do
        if (playerFriendList[i].Friend == target) then
            return true
        end
    end

    return false
end

--This function gets called when a player login
function FriendSystemOnLogin(player)
    if (player == nil) then
        return
    end

    local friendList = player:GetObjVar("FriendList") or {}

    for i = 1, #friendList, 1 do
        local friend = friendList[i]
        friend.Online = false
    end

    player:SetObjVar("FriendList", friendList)
end

--This function gets called when a player logout
function FriendSystemOnLogout(player)
    if (player == nil) then
        return
    end

    --[[
    local friendList = player:GetObjVar("FriendList") or {}

    --Update friends friend list on logout
    for key,value in pairs(friendList) do
        if GlobalVarReadKey("User.Online", value) and IsInFriendList(value, player) then
            CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
                --If friend is not in a same region as a player, send global message
                if (value:IsValid()) then
                    RemoveFriendFromChatChannel(value, player)
                else
                    value:SendMessageGlobal("RemoveFriendFromChatChannel", player)
                end
            end)
        end
    end]]

    --Remove every friend chat channel on logout
    ClearFriendChat(player)
end



--Remove friend from friend list. This gets called after remove confirmation window
function RemoveFriend(player, friend)
    local friendList = player:GetObjVar("FriendList")

    if (player == nil or friend == nil) then
        return
    end

    --Do nothing if there is nothing in a friend list
    if (friendList == nil) then
        return
    end

    --Find friend to remove from friend list, update friend list and
    --chat channel for both characters on successfully removing friend
    for i=1,#friendList,1 do
        local value = friendList[i].Friend
        if (value == friend) then
            table.remove(friendList,i)
            player:SetObjVar("FriendList",friendList)
            player:SendMessage("FriendUpdate")
            player:SendMessage("UpdateChatChannels")
            if ( GlobalVarReadKey("User.Online", value) ) then
                value:SendMessageGlobal("ChangeInBothList", player, false)

                value:SendMessageGlobal("UpdateChatChannels")
            end
            break
        end
    end
end

--Show confirmation window for removing friend
function ConfirmRemoveFriend(player, target)
    if (player == nil or target == nil) then
        return
    end

    local targetName = target:GetCharacterName() or "Unknown"
    local targetId = target.Id

    ClientDialog.Show{
        TargetUser = player,
        DialogId = "RemoveFriend"..targetId,
        TitleStr = "Remove Friend",
        DescStr = string.format("Do you wish to remove %s from your friend list?", targetName),
        Button1Str = "Accept",
        Button2Str = "Decline",
        ResponseObj = player,
        ResponseFunc = function(user,buttonId)
            local buttonId = tonumber(buttonId)
            if ( user == nil or buttonId == nil ) then return end

            if (buttonId == 0) then
                RemoveFriend(player, target)
            end

            return
        end
    }
end

--Change appear offline setting for this player. 
--Update friends friend list so it will show this player as offline
function ChangeOfflineMode(player)
    if (player == nil) then
        return
    end

    if (player:HasTimer("AppearOfflineCooldown")) then
        player:SystemMessage("Cannot change offline setting yet.")
        return
    end

    local writeOnline = nil

    if (GlobalVarReadKey("User.AppearOffline", player)) then
        writeOnline = function(record)
            record[player] = nil
            return true
        end
    else
        writeOnline = function(record)
            record[player] = true
            return true
        end
    end

    SetGlobalVar("User.AppearOffline", writeOnline)

    if (player:HasModule("friend_ui")) then
        CallFunctionDelayed(TimeSpan.FromMilliseconds(10), function()
            player:SendMessage("FriendUpdate")
        end)
    end

    player:ScheduleTimerDelay(TimeSpan.FromSeconds(20),"AppearOfflineCooldown")
end

function AddFriendToChatChannel(player, friend)

    if (player == nil or friend == nil) then
        return
    end

    --Checks if the player trying to add friend to chat channel can use friend chat
    if not (CanUseFriendChat(player)) then
        return
    end

    --Checks if player and friend characters are friends and friend is valid for chat 
    if not (FriendValidForChat(player, friend)) then
        return
    end

    local friendList = player:GetObjVar("FriendList")

    --This is a way to deal with if there is multiple character with same character name for now
    if (friendList ~= nil) then
        local friendFound = false

        for i=1, #friendList, 1 do
            DebugMessage(friendList[i].Friend)
            if (friendList[i].Friend:GetCharacterName() == friend:GetCharacterName()) then
                if (friendFound == false) then
                    friendFound = true
                else
                    player:SystemMessage("You have multiple friends with that name.")
                    return
                end
            end
        end
    end

    local friendChatChannel = player:GetObjVar("FriendChatChannel") or {}

    friendChatChannel[#friendChatChannel + 1] = friend

    player:SystemMessage(friend:GetCharacterName().." has been added to a chat channel")
    player:SetObjVar("FriendChatChannel", friendChatChannel)
    player:SendMessage("FriendUpdate")
    player:SendMessage("UpdateChatChannels")
end

function RemoveFriendFromChatChannel(player, friend)
    if (player == nil or friend == nil) then
        return
    end

    local friendChatChannel = player:GetObjVar("FriendChatChannel")

    --Do nothing if chat channel is empty
    if (friendChatChannel == nil) then
        return
    end

    --for key,value in pairs(friendChatChannel) do
    for i=1, #friendChatChannel, 1 do
        local value = friendChatChannel[i]
        if (value == friend) then
            player:RemoveTimer("MessageFrom"..friend.Id)
            player:SystemMessage(friend:GetCharacterName().." has been removed from a chat channel")
            if (#friendChatChannel > 1) then
                friendChatChannel[i] = nil
                player:SetObjVar("FriendChatChannel", friendChatChannel)
            else
                player:DelObjVar("FriendChatChannel")
            end
            player:SendMessage("UpdateChatChannels")
            break
        end
    end
end

--Return true if friend is in player's chat channel
function FriendInChatChannel(player, friend)
    if (player == nil or friend == nil) then
        return false
    end

    local friendChatChannel = player:GetObjVar("FriendChatChannel")

    --If there is no friend chat channel, friend cannot be in chat channel
    if (friendChatChannel == nil) then
        return false
    end

    for i=1, #friendChatChannel,1 do
        if (friendChatChannel[i] == friend) then
            return true
        end
    end

    return false
end

--Check if friend is available for a chat
function FriendValidForChat(player, friend, friendList)
    if (player == nil or friend == nil) then
        return false
    end

    friendList = friendList or player:GetObjVar("FriendList")

    if (friendList == nil) then
        return false
    end

    for i=1, #friendList,1 do
        local friendInList = friendList[i]
        if (friendInList.Friend == friend and friendInList.Online and friendInList.InBothList) then
            return true
        end
    end

    --If friend does not appear from my friend list, friend is not valid for a chat
    return false
end

--Remove every friend from friend chat channel
function ClearFriendChat(player)
    if (player == nil) then
        return
    end

    local friendChatChannel = player:GetObjVar("FriendChatChannel")

    if (friendChatChannel == nil) then
        return
    end

    for i=1, #friendChatChannel, 1 do
        player:RemoveTimer("MessageFrom"..friendChatChannel[i].Id)
    end

    player:DelObjVar("FriendChatChannel")
end

--Check if this player can use friend chat
function CanUseFriendChat(player)
    if (player == nil) then
        return false
    end

    if (GlobalVarReadKey("User.AppearOffline", player)) then
        return false
    end

    return true
end