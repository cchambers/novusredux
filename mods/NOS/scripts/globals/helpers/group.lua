GroupLootStrategies = {
    "FreeForAll",
    "RoundRobin",
    "Random",
    "Master"
}

GroupLootStrategiesDescriptions = {
    FreeForAll = "No loot privileges will be assigned to any mobs killed by the group.",
    RoundRobin = string.format("Assign loot privileges to the next group member in line, must be within %d units when mob dies to be eligible.", ServerSettings.Group.RewardRange),
    Random = string.format("Randomly picks a group member to assign loot privileges to, must be within %d units when mob dies to be eligible.", ServerSettings.Group.RewardRange),
    Master = string.format("All loot privileges go to the group leader, leader must be within %d units when mob dies to be eligible. If leader is not eligible, falls back to Random.", ServerSettings.Group.RewardRange)
}

GroupLootDisplayStrs = {
    FreeForAll = "Free For All",
    RoundRobin = "Round Robin",
    Random = "Random",
    Master = "Master"
}

--- Get a Global group variable by name
-- @param id
-- @param name The variable name
-- @return value of the global variable or nil
function GetGroupVar(id, name)
    if ( id == nil or name == nil ) then return nil end
    return GlobalVarReadKey(string.format("Group.%s", id), name)
end

--- Get the entire group record
-- @param id
-- @return full global group record table
function GetGroupRecord(id)
    return GlobalVarRead(string.format("Group.%s", id))
end

function WriteGroupVar(id, writeFunction, callbackFunction)
    if ( id == nil ) then
        LuaDebugCallStack("[WriteGroupVar] Nil id provided.")
        return false
    end
    if ( writeFunction == nil ) then
        LuaDebugCallStack("[WriteGroupVar] Nil writeFunction provided.")
        return false
    end
    -- handle global var write event
    local eventId = uuid()
    RegisterSingleEventHandler(EventType.GlobalVarUpdateResult, eventId, function(success, name, record)
        if not( success ) then
            LuaDebugCallStack("Failed to write group var for groupId "..groupId)
        end
        if ( callbackFunction ) then callbackFunction(success, name) end
    end)
    -- kick off the global write
    GlobalVarWrite(string.format("Group.%s", id), eventId, writeFunction)
end

--- Delete all group variables
-- @param id
-- @param callback
function DelGroupVar(id, callback)
    local eventId = uuid()
    RegisterSingleEventHandler(EventType.GlobalVarUpdateResult, eventId, function(success, name, record)
        if ( callback ) then callback(success) end
    end)
    GlobalVarDelete(string.format("Group.%s", id), eventId)
end

--- Get the group id of a player, if any
-- @param player
-- @return groupId or nil
function GetGroupId(player)
    return ChangeToPossessor(player):GetObjVar("Group")
end

function GroupClearPlayer(player)
    player:DelObjVar("Group")
    player:DelObjVar("GroupKarma")
    player:DelObjVar("JoiningGroup")
end

--- Set the group id of a player, 
--- this function should be ignored and GroupAddMember/GroupRemoveMember should be used if you wish to alter a player's group
-- @param player
-- @param value
function SetGroupId(player, value)
    player:SetObjVar("Group", value)
end

--- Check if a player is in a group with a mobileObj, does not check if a pet's owner is in the group with the player.
-- @param playerObj
-- @param mobileObj
-- @return true/false
function ShareGroup(playerObj, mobileObj)
    -- always in a group with yourself.
    if ( mobileObj == playerObj ) then return true end

    local mobileObjGroup = mobileObj:GetObjVar("Group")
    return( mobileObjGroup ~= nil and mobileObjGroup == playerObj:GetObjVar("Group") )
end

--- Check if a player is in a group with a mobileObj, will check if the mobileObj is a pet and if so check the mobileObj's owner instead.
-- @param playerObj
-- @param mobileObj
-- @return true/false
function ShareGroupCheckControlled(playerObj, mobileObj)
    Verbose("Group", "ShareGroupCheckControlled", playerObj, mobileObj)
    -- reassign mobileObj to the owner if mobileObj is a pet
    local controller = mobileObj:GetObjVar("controller")
    if ( controller ~= nil and controller:IsValid() ) then mobileObj = mobileObj:GetObjVar("controller") end

    return ShareGroup(playerObj, mobileObj)
end

--- Are these two in a group that is karma free?
-- @param playerA
-- @param playerB
-- @return true/false
function ShareKarmaGroup(playerA, playerB)
    Verbose("Group", "ShareKarmaGroup", playerA, playerB)
    if ( playerA == playerB ) then return true end

    local groupKarmaA = playerA:GetObjVar("GroupKarma")
    return ( groupKarmaA ~= nil and groupKarmaA == playerB:GetObjVar("GroupKarma") )
end

--- Invite a player to a group
-- @param player (This function should be executed on the player's region)
-- @param target
function GroupInvite(player, target)
    if ( player == nil ) then
        LuaDebugCallStack("[GroupInvite] Nil player provided.")
        return false
    end
    if ( target == nil ) then
        LuaDebugCallStack("[GroupInvite] Nil target provided.")
        return false
    end

    local possessorOrPlayer = ChangeToPossessor(player)

    local groupId = GetGroupId(possessorOrPlayer)

    if not( GroupCanInvite(possessorOrPlayer, ChangeToPossessor(target), groupId) ) then return end

    GroupInfoGlobal(possessorOrPlayer, string.format("You have invited %s to your group.", ChangeToPossessor(target):GetCharacterName()))

    ChangeToPossessee(target):SendMessageGlobal("GroupInvitePrompt", possessorOrPlayer, groupId)
end

function GroupMemberInMembers(member, members)
    for i=1,#members do
        if ( members[i] == member ) then return true end
    end
    return false
end

--- Send the prompt to a user to join our group, this is called on the receiving end
-- @param player
-- @param target (This function should be called on the target's region)
-- @param groupId
function GroupInvitePrompt(player, target, groupId)
    local target = ChangeToPossessor(target)

    if ( player == nil ) then
        LuaDebugCallStack("[GroupInvitePrompt] Nil player provided.")
        return false
    end
    if ( target == nil ) then
        LuaDebugCallStack("[GroupInvitePrompt] Nil target provided.")
        return false
    end

    if not ( GroupCanInviteConfirm(player, target, groupId) ) then return end
    
    local targetName = StripColorFromString(target:GetName())

    local playerName = player:GetCharacterName() or "Unknown"

    local possesseeOrTarget = ChangeToPossessee(target)
    ClientDialog.Show{
        TargetUser = possesseeOrTarget,
        DialogId = "GroupInvite"..possesseeOrTarget.Id,
        TitleStr = "Group Invitation",
        DescStr = string.format("%s has invited you to join their group.", playerName),
        Button1Str = "Accept",
        Button2Str = "Decline",
        ResponseObj = possesseeOrTarget,
        ResponseFunc = function(user,buttonId)
            local buttonId = tonumber(buttonId)
            if ( user == nil or buttonId == nil ) then return end

            -- Handles the invite command of the dynamic window
            if ( buttonId == 0 ) then

                -- confirm the target can be invited (again)
                if not ( GroupCanInviteConfirm(player, target, groupId) ) then return end

                -- tag them as in the process of joining a group.
                target:SetObjVar("JoiningGroup", groupId or "new")

                if ( player:IsValid() ) then
                    -- person inviting us is on same region, confirm directly
                    GroupInviteConfirm(player, target, groupId)
                else
                    player:SendMessageGlobal("GroupInviteConfirm", target, groupId)
                end

                return
            end

            GroupInfoGlobal(player, targetName.." has declined your group invitation.")
            
            -- invite declined
            GroupInfo(target, "[$1887]", true)
        end
    }
    GroupInfo(target, "You are invited to join a group.")
end

--- Confirm a group invitation, this is called on the sending end
-- @param player (this function should be called in this player's region)
-- @param target
-- @param groupId
function GroupInviteConfirm(player, target, groupId)
    if ( groupId == nil ) then
        player:SetObjVar("JoiningGroup", groupId or "new")
        local clearFunction = function(success)
            if ( target:IsValid() ) then
                target:DelObjVar("JoiningGroup")
            else
                target:SendMessageGlobal("GroupJoiningDone")
            end
            player:DelObjVar("JoiningGroup")
            if not( player:HasModule("group_ui") ) then
                player:AddModule("group_ui")
            end
        end
        GroupCreate(player, target, clearFunction)
    else
        local clearFunction = function(success)
            if ( target:IsValid() ) then
                target:DelObjVar("JoiningGroup")
            else
                target:SendMessageGlobal("GroupJoiningDone")
            end
        end
        GroupAddMember(groupId, target, clearFunction)
    end
end

--- Determine if a player can invite target to their group, this is called on the sending end.
-- @param player The player inviting (This function should be execution on this player's region)
-- @param target The player being invited
-- @return true or false
function GroupCanInvite(player, target, groupId)
    local target = ChangeToPossessor(target)

    if ( player == nil ) then
        LuaDebugCallStack("[GroupCanInvite] Nil player provided.")
        return false
    end
    if ( target == nil ) then
        LuaDebugCallStack("[GroupCanInvite] Nil target provided.")
        return false
    end

    if ( player == target ) then
        GroupInfo(player, "Cannot add yourself to a group.")
        return false
    end

    local joiningGroup = player:GetObjVar("JoiningGroup")
    if ( joiningGroup ~= nil and joiningGroup ~= (groupId or "new") ) then
        GroupInfo(player, "You are currently in the process of joining a group.")
        return false
    end

    if ( groupId == nil ) then groupId = GetGroupId(player) end

    if ( groupId ~= nil ) then
        -- ensure they are the leader
        local leader = GetGroupVar(groupId, "Leader")
        if ( player ~= leader ) then
            GroupInfo(player, "[$1884]")
            return false
        end
        -- ensure we aren't over limit
        local members = GetGroupVar(groupId, "Members")
        if ( CountTable(members) >= ServerSettings.Group.MaximumSize ) then
            GroupInfo(player, "At group maximum size.")
            return false
        end
    end

    return true
end

--- Determine if a player can be invited to a group, this is called on the receiving end.
-- @param player The player inviting 
-- @param target The player being invited (This function should be execution on the same region as target)
-- @return true or false
function GroupCanInviteConfirm(player, target, groupId)
    -- player is only good for being a gameObj with an id..
    if ( player == nil ) then
        LuaDebugCallStack("[GroupCanInvite] Nil player provided.")
        return false
    end
    if ( target == nil ) then
        LuaDebugCallStack("[GroupCanInvite] Nil target provided.")
        return false
    end

    if ( player == target ) then
        GroupInfoGlobal(player, "Cannot add yourself to a group.")
        return false
    end

    local joiningGroup = target:GetObjVar("JoiningGroup")
    if ( joiningGroup ~= nil and joiningGroup ~= (groupId or "new") ) then
        GroupInfoGlobal(player, "They are currently in the process of joining a group.")
        return false
    end

    local targetGroupId = GetGroupId(target)
    if ( targetGroupId ~= nil ) then
        if ( targetGroupId == groupId ) then
            GroupInfoGlobal(player, "They are already in your group.")
        else
            GroupInfoGlobal(player, "They are already in a group.")
        end
        return false
    end

    if ( groupId ~= nil ) then
        -- ensure we aren't over limit
        local members = GetGroupVar(groupId, "Members")
        if ( #members >= ServerSettings.Group.MaximumSize ) then
            GroupInfoGlobal(player, "At group maximum size.")
            return false
        end
    end

    return true
end

function SetGroupLeader(groupId, leader, callback)
    if ( groupId == nil ) then
        LuaDebugCallStack("[SetGroupLeader] Nil groupId provided.")
        return
    end
    -- stop here since we need at least one of these to make the operation worth it
    if ( leader == nil ) then
        LuaDebugCallStack("[SetGroupLeader] Nil leader provided.")
        return
    end
    local cb = function(success, name)
        if ( success ) then
            -- successfully updated leader
            -- tell everyone about it.
            local members = GetGroupVar(groupId, "Members") or {}
            for i=1,#members do
                local member = members[i]
                if ( GlobalVarReadKey("User.Online", member) ) then
                    member:SendMessageGlobal("OnGroupLeader", leader)
                end
            end
        end
        if ( callback ) then callback(success) end
    end
    local now = DateTime.UtcNow
    local write = function(record)
        record.Leader = leader
        record.UpdatedAt = now
        return true
    end
    WriteGroupVar(groupId, write, cb)
end

function SetGroupLoot(groupId, loot, callback)
    if ( groupId == nil ) then
        LuaDebugCallStack("[SetGroupLoot] Nil groupId provided.")
        return
    end
    if ( loot == nil ) then
        LuaDebugCallStack("[SetGroupLoot] Nil loot provided.")
        return
    end
    local index = nil
    for i=1,#GroupLootStrategies do
        if ( GroupLootStrategies[i] == loot ) then index = i end
    end
    if ( index == nil ) then
        LuaDebugCallStack(string.format("[SetGroupLoot] Invalid loot strategy '%s' provided.", loot))
        return
    end
    local cb = function(success, name)
        if ( success ) then
            -- successfully updated, tell all members about it
            local members = GetGroupVar(groupId, "Members")
            for i=1,#members do
                local member = members[i]
                -- if the member is online
                if ( GlobalVarReadKey("User.Online", member) ) then
                    -- if in same region
                    member:SendMessageGlobal("OnGroupLoot", loot)
                end
            end
        end
        if ( callback ) then callback(success) end
    end
    local now = DateTime.UtcNow
    local write = function(record)
        record.Loot = loot
        record.UpdatedAt = now
        return true
    end
    WriteGroupVar(groupId, write, cb)
end

--- Create a new player group
-- @param playerA group leader (this function should be executed on playerA's region)
-- @param playerB first member
-- @param nameB The name of playerB (since we can't get it if they are on a different region)
-- @param callback function ( success )
function GroupCreate(playerA, playerB, callback)
    if ( playerA == nil ) then
        LuaDebugCallStack("[GroupCreate] Nil playerA provided")
        return
    end
    if ( playerB == nil ) then
        LuaDebugCallStack("[GroupCreate] Nil playerB provided")
        return
    end
    if ( GetGroupId(playerA) ~= nil ) then
        LuaDebugCallStack("[GroupCreate] Attempting to create group with player in existing different group. (PlayerA Leader)")
        return
    end

    -- double check again
    if not( GroupCanInvite(playerA, playerB, groupId) ) then return end

    -- create a new groupId
    local groupId = uuid()

    -- using the groupId as the event return for wrting to global var
    local writeCallback = function(success, name)
        -- put the group in the players
        playerA:SendMessage("OnGroupJoin", groupId, playerA)
        playerA:SendMessage("OnGroupJoin", groupId, playerB)
        playerB:SendMessageGlobal("OnGroupJoin", groupId, playerA)
        playerB:SendMessageGlobal("OnGroupJoin", groupId, playerB)

        -- write the group to the global list of groups
        GroupAddToGlobalList(groupId, callback)
    end
    local now = DateTime.UtcNow
    -- write the group global record
    local writeFunction = function(record)
        -- set the leader
        record.Leader = playerA
        -- put the players in the group
        record.Members = {
            playerA,
            playerB,
        }
        record.UpdatedAt = now
        return true
    end
    -- kick off the write
    WriteGroupVar(groupId, writeFunction, writeCallback)
end

--- Add a member to a group, can be called on any region.
-- @param groupId to add player to
-- @param player Player to add to group
function GroupAddMember(groupId, player, callback)
    if ( groupId == nil ) then
        LuaDebugCallStack("[GroupAddMember] Nil groupId provided")
        return
    end
    if ( player == nil ) then
        LuaDebugCallStack("[GroupAddMember] Nil player provided")
        return
    end
    local writeCallback = function(success, name, record)
        -- put the group in the player
        if ( success ) then
            -- tell all members
            local members = GetGroupVar(groupId, "Members")
            for i=1,#members do
                local member = members[i]
                if ( GlobalVarReadKey("User.Online", member) ) then
                    member:SendMessageGlobal("OnGroupJoin", groupId, player)
                end
            end
        end
        if ( callback ) then callback(success) end
    end
    -- write global variable
    local now = DateTime.UtcNow
    local writeFunction = function(record)
        if ( record.Members == nil ) then return false end
        -- put the player in the group
        record.Members[#record.Members+1] = player
        record.UpdatedAt = now
        return true
    end
    -- kick off the write
    WriteGroupVar(groupId, writeFunction, writeCallback)
    return true
end

function GroupRemoveMember(groupId, player, callback)
    if ( groupId == nil ) then
        LuaDebugCallStack("[GroupRemoveMember] Nil groupId provided")
        return
    end
    if ( player == nil ) then
        LuaDebugCallStack("[GroupRemoveMember] Nil player provided")
        return
    end
    local members = GetGroupVar(groupId, "Members") or {}
    -- build the new members
    local newMembers = {}
    for i=1,#members do
        if ( members[i] ~= player ) then
            table.insert(newMembers, members[i])
        end
    end
    if ( #newMembers < 2 ) then
        -- groups can only exist with atleast two members.
        GroupDestroy(groupId, callback)
        return
    end
    local wasLeader = (GetGroupVar(groupId, "Leader") == player)
    -- setup the callback for when write completes
    local writeCallback = function(success, name, record)
        -- remove the group from the player
        if ( success ) then
            if ( GlobalVarReadKey("User.Online", player) ) then
                player:SendMessageGlobal("OnGroupLeave", player)
            end
            -- tell all the new members as well
            for i=1,#newMembers do
                local member = newMembers[i]
                if ( GlobalVarReadKey("User.Online", member) ) then
                    member:SendMessageGlobal("OnGroupLeave", player)
                    -- send the update to the new group leader
                    if ( wasLeader and i == 1 ) then
                        member:SendMessageGlobal("OnGroupLeader", member)
                    end
                end
            end
        end
        if ( callback ) then callback(success) end
    end
    local now = DateTime.UtcNow
    -- write global variable
    local writeFunction = function(record)
        if ( wasLeader ) then
            -- update the new leader
            record.Leader = newMembers[1]
        end
        record.Members = newMembers
        record.UpdatedAt = now
        return true
    end
    -- kick off the write
    WriteGroupVar(groupId, writeFunction, writeCallback)
    return true
end

function GroupDestroy(groupId, callback)
    local members = GetGroupVar(groupId, "Members") or {}
    local onDeleted = function(success)
        -- tell all members about it
        for i=1,#members do
            local member = members[i]
            if ( GlobalVarReadKey("User.Online", member) ) then
                member:SendMessageGlobal("OnGroupDestroy")
            end
        end
        -- remove from all groups
        GroupRemoveFromGlobalList(groupId, callback)
    end
    DelGroupVar(groupId, onDeleted)
end

--- Add a groupId to the master list of AllGroups
-- @param groupId
-- @param callback
function GroupAddToGlobalList(groupId, callback)
    local eventId = uuid()
    RegisterSingleEventHandler(EventType.GlobalVarUpdateResult, eventId, function(success, name, record)
        if ( callback ) then callback(success) end
    end)
    local now = DateTime.UtcNow
    local writeFunction = function(record)
        -- add to record
        record[groupId] = now
        return true
    end
    GlobalVarWrite("AllGroups", eventId, writeFunction)
end

--- Remove a groupId from the master list of AllGroups
-- @param groupId
-- @param callback
function GroupRemoveFromGlobalList(groupId, callback)
    local eventId = uuid()
    RegisterSingleEventHandler(EventType.GlobalVarUpdateResult, eventId, function(success, name, record)
        if ( callback ) then callback(success) end
    end)
    local writeFunction = function(record)
        -- remove from record
        record[groupId] = nil
        return true
    end
    GlobalVarWrite("AllGroups", eventId, writeFunction)
end

function GroupScrubStaleRecords()
    local allGroups = GlobalVarRead("AllGroups") or {}
    -- if a group has not been updated in this amount of time, destroy it.
    local oldestUpdate = DateTime.UtcNow:Subtract(TimeSpan.FromHours(4))
    for groupId,createdAt in pairs(allGroups) do
        -- let's see if it's been updated recently.
        local updatedAt = GetGroupVar(groupId, "UpdatedAt")
        if ( updatedAt == nil or updatedAt < oldestUpdate ) then
            -- invalid updatedAt or it hasn't been updated for this long, destroy it.
        end
    end
end

function GroupLoginMember(player)
    -- incase this gets stuck..
    player:DelObjVar("JoiningGroup")
    
    local groupId = GetGroupId(player)
    if ( groupId == nil ) then
        return
    end

    -- remove them from their group if the group no longer exists
    local members = GetGroupVar(groupId, "Members")
    if ( members == nil or not GroupMemberInMembers(player, members) ) then
        player:SendMessage("OnGroupDestroy")
        return
    end

    -- tell all other online members we've connected
    for i=1,#members do
        local member = members[i]
        if ( player ~= member and (member:IsValid() or GlobalVarReadKey("User.Online", member)) ) then
            member:SendMessageGlobal("OnGroupConnect", player)
        end
    end
end

function GroupLogoutMember(player)
    
    local groupId = GetGroupId(player)
    if ( groupId == nil ) then
        return
    end

    -- remove them from their group if the group no longer exists
    local members = GetGroupVar(groupId, "Members")
    if ( members == nil or not GroupMemberInMembers(player, members) ) then
        player:SendMessage("OnGroupDestroy")
        return
    end

    -- tell all other online members we've disconnected
    for i=1,#members do
        local member = members[i]
        if ( player ~= member and (member:IsValid() or GlobalVarReadKey("User.Online", member)) ) then
            member:SendMessageGlobal("OnGroupDisconnect", player)
        end
    end

end

function GroupSendChat(player, ...)
    local groupId = GetGroupId(player)
    if ( groupId == nil ) then
        player:SystemMessage("You are not in a group.", "info")
        return
    end

    local arg = table.pack(...)

    local message = ""
    if ( #arg > 0 ) then
        local members = GetGroupVar(groupId, "Members")
        if ( members == nil ) then return end
        local name = StripColorFromString(player:GetName())
        -- build the message from the arguments
        for i=1,#arg do message = string.format("%s%s ", message, arg[i]) end
        -- log it
        local encoded = json.encode(message)

        player:LogChat("group", encoded)

        -- send the message to all members
        for i=1,#members do
            local member = members[i]
            if ( member:IsValid() ) then
                local member = ChangeToPossessee(member)
                GroupChat(member, message, name)
            else
                -- only send a message to another region if they are online
                if ( GlobalVarReadKey("User.Online", member) ) then
                    member:SendMessageGlobal("GroupChat", message, name)
                end
            end
        end
    else
        -- if no arguments just show the group ui
        if not( player:HasModule("group_ui") ) then
            player:AddModule("group_ui")
        end
        player:SendMessage("GroupUpdate")
    end
end

function GroupChat(member, message, name)
    if ( member == nil ) then
        LuaDebugCallStack("[GroupChat] Nil member provided.")
        return
    end
    if ( message == nil ) then
        LuaDebugCallStack("[GroupChat] Nil message provided.")
        return
    end
    if ( name == nil ) then
        LuaDebugCallStack("[GroupChat] Nil name provided.")
        return
    end
    member:SystemMessage(string.format("[00FFFF][Group] %s: %s[-]", name, message), "custom")
end

function GroupInfoGlobal(member, message, updateUi)
    if ( member:IsValid() ) then
        GroupInfo(member, message, updateUi)
    else
        member:SendMessageGlobal("GroupInfo", message, updateUi)
    end
end

function GroupInfo(member, message, updateUi)
    if ( member == nil ) then
        LuaDebugCallStack("[GroupInfo] Nil member provided")
        return
    end
    if ( message == nil ) then
        LuaDebugCallStack("[GroupInfo] Nil message provided.")
        return
    end

    local possesseeOrMember = ChangeToPossessee(member)
    
    possesseeOrMember:SystemMessage(string.format("[00FFFF]%s[-]", message), "info")
    -- if the group ui is open, update it.
    if ( updateUi == true and possesseeOrMember:HasModule("group_ui") ) then
        possesseeOrMember:SendMessage("GroupUpdate")
    end
end