
function CleanUp()
    this:CloseDynamicWindow("GroupWindow")
    if ( this:HasModule("group_ui") ) then
        this:DelModule("group_ui")
    end
end

mSelectedMemberId = nil
mContextMember = nil

-- when this is true, a GroupUpdate message is sent to each member as they are looped while building the gui
_ShouldUpdateMembers = false

function GroupWindow()
    local groupId = GetGroupId(this)
    if ( groupId == nil ) then
        CleanUp()
        return
    end


    local groupRecord = GetGroupRecord(groupId)

    if ( groupRecord == nil ) then
        CleanUp()
        return
    end

    local leader = groupRecord.Leader
    local members = groupRecord.Members
    local loot = groupRecord.Loot or GroupLootStrategies[1]
    local numMembers = #members
    --TEST
    --numMembers = 25
    --TEST

    local rowHeight = 24
    local membersHeight = numMembers * rowHeight
    local windowHeight = 165 + membersHeight
    local windowWidth = 380

    local dynamicWindow = DynamicWindow(
        "GroupWindow", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
        "Group", --(string) Title of the window for the client UI
        windowWidth, --(number) Width of the window
        windowHeight --(number) Height of the window
        --startX, --(number) Starting X position of the window (chosen by client if not specified)
        --startY, --(number) Starting Y position of the window (chosen by client if not specified)
        --windowType, --(string) Window type (optional)
        --windowAnchor --(string) Window anchor (default "TopLeft")
    )

    
    dynamicWindow:AddImage(8,27,"BasicWindow_Panel",344,10 + membersHeight,"Sliced")
    dynamicWindow:AddImage(10,5,"HeaderRow_Bar",340,21,"Sliced")
    dynamicWindow:AddLabel(
            25, --(number) x position in pixels on the window
            10, --(number) y position in pixels on the window
            "Name", --(string) text in the label
            0, --(number) width of the text for wrapping purposes (defaults to width of text)
            0, --(number) height of the label (defaults to unlimited, text is not clipped)
            16, --(number) font size (default specific to client)
            "left" --(string) alignment "left", "center", or "right" (default "left")
            --false, --(boolean) scrollable (default false)
            --false, --(boolean) outline (defaults to false)
            --"" --(string) name of font on client (optional)
        )

        dynamicWindow:AddLabel(
            280, --(number) x position in pixels on the window
            10, --(number) y position in pixels on the window
            "Status", --(string) text in the label
            0, --(number) width of the text for wrapping purposes (defaults to width of text)
            0, --(number) height of the label (defaults to unlimited, text is not clipped)
            16, --(number) font size (default specific to client)
            "center" --(string) alignment "left", "center", or "right" (default "left")
            --false, --(boolean) scrollable (default false)
            --false, --(boolean) outline (defaults to false)
            --"" --(string) name of font on client (optional)
        )

    local y = 32
    local myGroupKarma = nil
    -- cache some globals for the loop
    local kl = ServerSettings.Karma.Levels
    local str = string
    local groupLootDisplayStrs = GroupLootDisplayStrs
    local groupLootStrategiesDescriptions = GroupLootStrategiesDescriptions
    for i=1,numMembers do
        local member = members[i]
    --TEST
    --[[
        if ( i > 1 ) then
            member = members[2]
        else
            member = members[1]
        end
    ]]
    --TEST
        local groupKarma = member:GetObjVar("GroupKarma")
        local name = GlobalVarReadKey("User.Name", member) or "Unknown"
        local online = false
        if ( member == this ) then
            -- if it's yourself, you're definitely online.
            online = true
            -- cache our karma group so we can avoid another lookup
            myGroupKarma = groupKarma
        else
            online = GlobalVarReadKey("User.Online", member)
            -- if should update, send a message to the member to update their group ui
            if ( online and _ShouldUpdateMembers == true ) then
                member:SendMessageGlobal("GroupUpdate")
            end
        end

        local isSelected = mSelectedMemberId == member.Id

        local buttonState = isSelected and "pressed" or ""
        dynamicWindow:AddButton(12,y,str.format("Select|%s", member.Id),"",336,24,"","",false,"ThinFrameHover",buttonState)

        local colorStr = "FFFFFF"
        local leaderStr = ""
        if ( member == leader ) then
            leaderStr = "(L) "
        end
        if ( groupKarma == groupId ) then
            -- set their name color as outcast in group ui so it's known who has consented
            colorStr = kl[#kl].NameColor
        end
        dynamicWindow:AddLabel(
            25, --(number) x position in pixels on the window
            y+5, --(number) y position in pixels on the window
            str.format("%s[%s]%s[-]", leaderStr, colorStr, name), --(string) text in the label
            0, --(number) width of the text for wrapping purposes (defaults to width of text)
            0, --(number) height of the label (defaults to unlimited, text is not clipped)
            16 --(number) font size (default specific to client)
            --"center", --(string) alignment "left", "center", or "right" (default "left")
            --false, --(boolean) scrollable (default false)
            --false, --(boolean) outline (defaults to false)
            --"" --(string) name of font on client (optional)
        )

        local status = nil
        if ( online ) then
            status = "[32CD32]Online[-]"
        else
            status = "[708090]Offline[-]"
        end
        dynamicWindow:AddLabel(
            280, --(number) x position in pixels on the window
            y+5, --(number) y position in pixels on the window
            status, --(string) text in the label
            0, --(number) width of the text for wrapping purposes (defaults to width of text)
            0, --(number) height of the label (defaults to unlimited, text is not clipped)
            16, --(number) font size (default specific to client)
            "center" --(string) alignment "left", "center", or "right" (default "left")
            --false, --(boolean) scrollable (default false)
            --false, --(boolean) outline (defaults to false)
            --"" --(string) name of font on client (optional)
        )

        y = y + rowHeight
    end
    _ShouldUpdateMembers = false

    y = y + 50
       
    if ( this == leader ) then
        dynamicWindow:AddButton(
            12, --(number) x position in pixels on the window
            y, --(number) y position in pixels on the window
            "GroupLoot", --(string) return id used in the DynamicWindowResponse event
            groupLootDisplayStrs[loot], --(string) text in the button (defaults to empty string)
            113, --(number) width of the button (defaults to width of text)
            24,--(number) height of the button (default decided by type of button)            
            str.format("%s: %s", loot, groupLootStrategiesDescriptions[loot]), --(string) mouseover tooltip for the button (default blank)
            "", --(string) server command to send on button click (default to none)
            false,--closeWindowOnClick, --(boolean) should the window close when this button is clicked? (default true)
            "Default"--buttonType, --(string) button type (default "Default")
            --buttonState, --(string) button state (optional, valid options are default,pressed,disabled)
            --customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
        )
    else
        dynamicWindow:AddButton(
            15, --(number) x position in pixels on the window
            y, --(number) y position in pixels on the window
            "Nada", --(string) return id used in the DynamicWindowResponse event
            groupLootDisplayStrs[loot], --(string) text in the button (defaults to empty string)
            113, --(number) width of the button (defaults to width of text)
            24,--(number) height of the button (default decided by type of button)
            str.format("%s: %s", loot, groupLootStrategiesDescriptions[loot]), --(string) mouseover tooltip for the button (default blank)
            "", --(string) server command to send on button click (default to none)
            false,--closeWindowOnClick, --(boolean) should the window close when this button is clicked? (default true)
            "Default", --buttonType, --(string) button type (default "Default")
            "disabled" --(string) button state (optional, valid options are default,pressed,disabled)
            --customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
        )
    end

    dynamicWindow:AddButton(
        238, --(number) x position in pixels on the window
        y, --(number) y position in pixels on the window
        "GroupLeave", --(string) return id used in the DynamicWindowResponse event
        "Leave Group", --(string) text in the button (defaults to empty string)
        113, --(number) width of the button (defaults to width of text)
        24,--(number) height of the button (default decided by type of button)
        "Leave your group", --(string) mouseover tooltip for the button (default blank)
        "", --(string) server command to send on button click (default to none)
        false,--closeWindowOnClick, --(boolean) should the window close when this button is clicked? (default true)
        "Default"--buttonType, --(string) button type (default "Default")
        --buttonState, --(string) button state (optional, valid options are default,pressed,disabled)
        --customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
    ) 

    local karmaStr = nil
    if ( myGroupKarma == groupId ) then
        karmaStr = str.format("All [%s]consenting[-] group members can performing negative karma actions toward you freely, leave group to opt out.", kl[#kl].NameColor)
    else
        karmaStr = "Consent to allow members of this group to perform negative karma actions toward you."
        -- add a button for consent
        dynamicWindow:AddButton(
            125, --(number) x position in pixels on the window
            y, --(number) y position in pixels on the window
            "KarmaConsent", --(string) return id used in the DynamicWindowResponse event
            "Consent", --(string) text in the button (defaults to empty string)
            113, --(number) width of the button (defaults to width of text)
            24,--(number) height of the button (default decided by type of button)
            karmaStr, --(string) mouseover tooltip for the button (default blank)
            "", --(string) server command to send on button click (default to none)
            false,--closeWindowOnClick, --(boolean) should the window close when this button is clicked? (default true)
            "Default"--buttonType, --(string) button type (default "Default")
            --buttonState, --(string) button state (optional, valid options are default,pressed,disabled)
            --customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
        )
    end

    dynamicWindow:AddLabel(
        15, --(number) x position in pixels on the window
        y - 38, --(number) y position in pixels on the window
        karmaStr, --(string) text in the label
        windowWidth - 40, --(number) width of the text for wrapping purposes (defaults to width of text)
        40, --(number) height of the label (defaults to unlimited, text is not clipped)
        16, --(number) font size (default specific to client)
        "left" --(string) alignment "left", "center", or "right" (default "left")
        --false, --(boolean) scrollable (default false)
        --false, --(boolean) outline (defaults to false)
        --"" --(string) name of font on client (optional)
    )

    this:OpenDynamicWindow(dynamicWindow)
end

function KarmaConsent()
    ClientDialog.Show{
        TargetUser = this,
        DialogId = "KarmaConsent",
        TitleStr = "Consent",
        DescStr = "\n\n[FF8C00]WARNING: All consenting members of this group can perform negative karma actions without concequence. This includes, looting, attacking, killing, and anything guard protected.[-]",
        Button1Str = "Consent",
        Button2Str = "Reject",
        ResponseObj = this,
        ResponseFunc = function(user,buttonId)
            local buttonId = tonumber(buttonId)
            if ( user == nil or buttonId == nil ) then return end

            if ( buttonId == 0 ) then
                -- set them viable for no consequences
                user:SetObjVar("GroupKarma", GetGroupId(user))
                -- mark an update for all members in the next group window call
                _ShouldUpdateMembers = true
                -- update the group window
                GroupWindow()
            end
            -- on a decline, the option will remain open on the group UI
        end
    }
end

RegisterEventHandler(EventType.DynamicWindowResponse, "GroupWindow", function(user, button)
    if(button == nil or button == "") then
        CleanUp()
        return
    end

    local groupId = GetGroupId(this)
    if ( groupId == nil ) then
        this:SystemMessage("You are not in a group.", "info")
        CleanUp()
        return
    end

    if ( this:HasTimer("AnitSpamTimer") ) then
        return
    end
    this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(500), "AnitSpamTimer")

    if ( button == "GroupLeave" ) then
        GroupRemoveMember(groupId, this)
    elseif ( button == "KarmaConsent" ) then
        KarmaConsent()
    elseif ( GetGroupVar(groupId, "Leader") == this ) then
        if ( button == "GroupLoot") then
            local current = 1
            local loot = GetGroupVar(groupId, "Loot") or "FreeForAll"
            for i=1,#GroupLootStrategies do
                if ( GroupLootStrategies[i] == loot ) then
                    current = i
                end
            end
            local next = current + 1
            if ( next > #GroupLootStrategies ) then
                next = 1
            end
            SetGroupLoot(groupId, GroupLootStrategies[next])
        else
            local option, arg = string.match(button, "(.+)|(.+)")
            if ( option == "Select" ) then
                mContextMember = GameObj(tonumber(arg))
                if(mContextMember ~= this) then
                    this:OpenCustomContextMenu("GroupOptions","Action",{"Promote","Kick"})
                end
            elseif ( option == "Kick" ) then
                local member = GameObj(tonumber(arg))
                GroupRemoveMember(groupId, member)
            elseif ( option == "Promote" ) then
                local member = GameObj(tonumber(arg))
                SetGroupLeader(groupId, member)
            else
                CleanUp()
            end
        end    
    end
end)

RegisterEventHandler(EventType.Message, "GroupUpdate", function()
    GroupWindow()
end)

RegisterEventHandler(EventType.Message, "GroupClose", function()
    CallFunctionDelayed(TimeSpan.FromMilliseconds(1), CleanUp)
end)

RegisterEventHandler(EventType.ContextMenuResponse,"GroupOptions",
    function(user,optionStr)
        local groupId = GetGroupId(this)

        if ( groupId and mContextMember and GetGroupVar(groupId, "Leader") == this ) then
            if(optionStr == "Promote") then
                SetGroupLeader(groupId, mContextMember)
            elseif ( optionStr == "Kick" ) then
                GroupRemoveMember(groupId, mContextMember)          
            end
        end
    end)

GroupWindow()