
friendList = nil

function CleanUp()
    this:CloseDynamicWindow("FriendWindow")
    if ( this:HasModule("friend_ui") ) then
        this:DelModule("friend_ui")
    end
end

function FriendWindow()
    if ( IsPossessed(this) or IsPossessing(this) ) then return false end

    friendList = this:GetObjVar("FriendList") or {}

    local rowHeight = 24
    local windowHeight = 362
    local windowWidth = 380

    local y = 37
    local buttonHeight = 24

    local friendWindow = DynamicWindow("FriendWindow","Friend List", windowWidth,windowHeight,-260,-185,"Default","Center")
    friendWindow:AddImage(8,27,"BasicWindow_Panel",344,252,"Sliced")

    friendWindow:AddImage(10,5,"HeaderRow_Bar",340,21,"Sliced")
    friendWindow:AddLabel(25,10,"Name",0,0,16,"left")

    friendWindow:AddLabel(228,10,"Status",0,0,16,"center")

    local scrollWindow = ScrollWindow(8,27,334,252,buttonHeight)

    for key,friendObject2 in pairs(friendList) do

        local friendObject = friendObject2.Friend
        local friendOnline = friendObject2.Online

        local scrollElement = ScrollElement()

        local chatEnabled = true

        local friendsfriendlist = friendObject:GetObjVar("FriendList")

        if (friendOnline) then
            status = "[32CD32]Online[-]"
        else
            chatEnabled = false
            status = "[708090]Offline[-]"
        end

        local talkLabel = nil
        local buttonPressed = ""

        if (chatEnabled) then
            talkLabel = "Tell"
            if (FriendInChatChannel(this, friendObject)) then
                buttonPressed = "pressed"
            end
        else
            talkLabel = "[999999]Tell[-]"
        end

        local friendName = friendObject:GetCharacterName() or "Unknown"

        scrollElement:AddButton(6,6,"","",318,buttonHeight,"","",false,"ThinFrameHover")
        scrollElement:AddLabel(16,12,friendName,0,0,16)

        scrollElement:AddLabel(200,12,status,0,0,16)

        scrollElement:AddButton(300,8,"RemoveFriend|"..key,"",20,20,"",nil,false,"Minus")
        scrollElement:AddButton(258,8,"TalkFriend|"..key,"",36,20,"",nil,false,"List", buttonPressed)
        scrollElement:AddLabel(264,11,talkLabel,0,0,16)

        scrollWindow:Add(scrollElement)
    end

    friendWindow:AddScrollWindow(scrollWindow)

    local myOnlineStatus = GlobalVarReadKey("User.AppearOffline", this)
    local offlineButtonState = ""

    if (myOnlineStatus) then
        offlineButtonState = "pressed"
    end

    friendWindow:AddButton(8, 284,"ChangeOfflineStatus","Appear Offline",110,30,"","",false,"Selection2",offlineButtonState)

    this:OpenDynamicWindow(friendWindow, this)
end

RegisterEventHandler(EventType.DynamicWindowResponse, "FriendWindow", function(user, button)
    if(button == nil or button == "") then
        CleanUp()
        return
    end

    if (button == "ChangeOfflineStatus") then
        ChangeOfflineMode(user)
        FriendWindow()
        return
    end

    local args = StringSplit(button,"|")
    local buttonId = args[1]
    local tableKey = tonumber(args[2])

    local friendTable = friendList[tableKey]

    if (friendTable == nil) then
        return
    end

    local friend = friendTable.Friend

    if (buttonId == "RemoveFriend") then
        ConfirmRemoveFriend(user, friend)
        return
    elseif (buttonId == "TalkFriend") then
        this:SendClientMessage("EnterChat",string.format("/tell %s ", friend:GetCharacterName()))
        --[[
        if not (FriendInChatChannel(user, friend)) then
            AddFriendToChatChannel(user, friend)
        else
            RemoveFriendFromChatChannel(user, friend)
        end
        ]]

        FriendWindow()
        return
    end
end)

RegisterEventHandler(EventType.Message, "FriendUpdate", function()
        FriendWindow()
    end)

RegisterEventHandler(EventType.Message, "FriendWindowClose", function()
        CleanUp()
    end)

FriendWindow()
