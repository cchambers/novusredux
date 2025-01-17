local controller, plotController, isHouse, tab, contextCoOwner

function Init(controllerObj, plotControllerObj, defaultTab)
    controller = controllerObj
    plotController = plotControllerObj

    if (controller == nil or plotController == nil) then
        CleanUp()
        return
    end

    -- when controller isn't plot controller, it's a house.
    isHouse = controller.Id ~= plotController.Id

    tab = defaultTab or ((isHouse and "Security") or "Info")
    UpdateWindow()
end

function CleanUp()
    this:CloseDynamicWindow("PlotControlWindow")
    this:DelModule("plot_control_window")
end

function UpdateWindow()
    if
        ((isHouse and not Plot.HasHouseControl(this, plotController, controller)) or
            (not isHouse and not Plot.IsOwner(this, controller)))
     then
        CleanUp()
        return
    end

    local dynamicWindow =
        DynamicWindow("PlotControlWindow", (isHouse and "House" or "Plot") .. " Control", 350, 354, 0, 0, "")

    local tabs = {}
    if (isHouse) then
        table.insert(tabs, {Text = "Security"})
    else
        table.insert(tabs, {Text = "Info"})
    end
    table.insert(tabs, {Text = "Decorate"})
    table.insert(tabs, {Text = "Manage"})

    AddTabMenu(
        dynamicWindow,
        {
            ActiveTab = tab,
            Buttons = tabs,
            ButtonWidth = 103,
            Width = 310
        }
    )

    HandleTabs(dynamicWindow)

    this:OpenDynamicWindow(dynamicWindow, this)
end

function HandleTabs(dynamicWindow)
    if (tab == "Manage") then
        ManageTab(dynamicWindow)
    elseif (tab == "Decorate") then
        DecorateTab(dynamicWindow)
    else
        if (isHouse) then
            if (tab == "Security") then
                CoOwnerTab(dynamicWindow)
                FriendTab(dynamicWindow)
            end
        else
            if (tab == "Info") then
                TaxTab(dynamicWindow)
            end
        end
    end
end

function HandleDecorateWindowResponse(returnId)
    if (returnId == "LockDownItem") then
        this:SendMessage("StartMobileEffect", "PlotLockdown", plotController)
    elseif (returnId == "ReleaseItem") then
        this:SendMessage("StartMobileEffect", "PlotRelease", plotController)
    elseif (returnId == "MoveItem") then
        this:SendMessage("StartMobileEffect", "PlotMoveObject", plotController)
    else
        -- nothing matched
        return false
    end

    -- something matched
    return true
end

function HandleSecurityTabResponse(returnId, user)
    local option, arg = string.match(returnId, "(.+)|(.+)")
    if (option == "SelectCoOwner") then
        contextArg = arg
        user:OpenCustomContextMenu("CoOwnerOptions", "Action", {"Remove"})
    elseif (option == "SelectFriend") then
        contextArg = arg
        user:OpenCustomContextMenu("FriendOptions", "Action", {"Remove"})
    else
        -- nothing matched
        return false
    end
    -- something matched
    return true
end

function DecorateTab(dynamicWindow)
    dynamicWindow:AddImage(8, 32, "BasicWindow_Panel", 314, 264, "Sliced")

    local lockdownStr =
        string.format("%d / %d", controller:GetObjVar("LockCount") or 0, controller:GetObjVar("LockLimit") or 10)
    dynamicWindow:AddLabel(20, 44, "Lockdowns:", 0, 0, 18)
    dynamicWindow:AddLabel(180, 44, lockdownStr, 0, 0, 18)

    local buttonStartY = 70
    -- add the container count if we are controlling a house
    if (isHouse) then
        local containerStr =
            string.format(
            "%d / %d",
            controller:GetObjVar("ContainerCount") or 0,
            controller:GetObjVar("ContainerLimit") or 1
        )
        dynamicWindow:AddLabel(20, 64, "Containers:", 0, 0, 18)
        dynamicWindow:AddLabel(180, 64, containerStr, 0, 0, 18)

        buttonStartY = buttonStartY + 24
    end

    dynamicWindow:AddButton(
        20,
        buttonStartY,
        "MoveItem",
        "Decorate",
        290,
        26,
        "Adjust the location and orientation of a locked down item.",
        "",
        false,
        "List"
    )
    dynamicWindow:AddButton(20, buttonStartY + 26, "LockDownItem", "Lock Down", 290, 26, "[$1828]", "", false, "List")
    dynamicWindow:AddButton(
        20,
        buttonStartY + 52,
        "ReleaseItem",
        "Release/Pack",
        290,
        26,
        "Select an item to release from lock down.",
        "",
        false,
        "List"
    )
end

function ManageTab(dynamicWindow)
    dynamicWindow:AddImage(8, 32, "BasicWindow_Panel", 314, 264, "Sliced")

    -- shared buttons
    dynamicWindow:AddButton(20, 40, "Rename", "Rename", 290, 26, "Max 20 characters", "", false, "List")
    dynamicWindow:AddButton(20, 66, "Kick", "Kick", 290, 26, "Remove a target from your plot.", "", false, "List")

    if (isHouse) then
        dynamicWindow:AddButton(
            20,
            200,
            "OpenBank",
            "Open Your Bank",
            290,
            26,
            "Costs 10,000g.",
            "",
            false,
            "List"
        )
        dynamicWindow:AddButton(20, 92, "Destroy", "Destroy", 290, 26, "Destroy this house.", "", false, "List")
    else
        dynamicWindow:AddButton(
            20,
            92,
            "Resize",
            "Resize Plot",
            290,
            26,
            "Expand or Shrink your plot, altering the required tax payment.",
            "",
            false,
            "List"
        )
        dynamicWindow:AddButton(
            20,
            118,
            "Transfer",
            "Transfer Ownership",
            290,
            26,
            "Opens a secure trade transaction containing the deed to the plot. Cannot transfer with active merchants on land. Target must be standing near mailbox.",
            "",
            false,
            "List"
        )
        dynamicWindow:AddButton(
            20,
            144,
            "Destroy",
            "Relinquish Control",
            290,
            26,
            "Relinquish control of the land. Plot cannot have any houses or locked down items. Will refund a land deed.",
            "",
            false,
            "List"
        )
    end
end

-- house only
function CoOwnerTab(dynamicWindow)
    dynamicWindow:AddImage(8, 32, "BasicWindow_Panel", 314, 132, "Sliced")
    dynamicWindow:AddButton(
        11,
        135,
        "AddCoOwner",
        "Add Co-Owner",
        308,
        26,
        "Co-Owners can Lock/Unlock the door, use secure containers, and lock down/release items. Only in this house.",
        "",
        false,
        "List"
    )

    local coOwners = controller:GetObjVar("HouseCoOwners") or {}
    local scrollWindow = ScrollWindow(18, 38, 280, 92, 23)
    local any = false

    for coowner, v in pairs(coOwners) do
        any = true
        local scrollElement = ScrollElement()
        scrollElement:AddButton(
            0,
            0,
            string.format("SelectCoOwner|%s", coowner.Id),
            "",
            260,
            23,
            "",
            "",
            false,
            "ThinFrameHover",
            ""
        )
        scrollElement:AddLabel(
            6, --(number) x position in pixels on the window
            6, --(number) y position in pixels on the window
            coowner:GetCharacterName(), --(string) text in the label
            0, --(number) width of the text for wrapping purposes (defaults to width of text)
            0, --(number) height of the label (defaults to unlimited, text is not clipped)
            16 --(number) font size (default specific to client)
            --"center", --(string) alignment "left", "center", or "right" (default "left")
            --false, --(boolean) scrollable (default false)
            --false, --(boolean) outline (defaults to false)
            --"" --(string) name of font on client (optional)
        )
        scrollWindow:Add(scrollElement)
    end

    if not (any) then
        local scrollElement = ScrollElement()
        scrollElement:AddLabel(
            6, --(number) x position in pixels on the window
            6, --(number) y position in pixels on the window
            "No Co-Owners Added.", --(string) text in the label
            0, --(number) width of the text for wrapping purposes (defaults to width of text)
            0, --(number) height of the label (defaults to unlimited, text is not clipped)
            16 --(number) font size (default specific to client)
            --"center", --(string) alignment "left", "center", or "right" (default "left")
            --false, --(boolean) scrollable (default false)
            --false, --(boolean) outline (defaults to false)
            --"" --(string) name of font on client (optional)
        )
        scrollWindow:Add(scrollElement)
    end

    dynamicWindow:AddScrollWindow(scrollWindow)
end
-- house only
function FriendTab(dynamicWindow)
    dynamicWindow:AddImage(8, 162, "BasicWindow_Panel", 314, 132, "Sliced")

    dynamicWindow:AddButton(
        11,
        265,
        "AddFriend",
        "Add Friend",
        308,
        26,
        "Friends can open locked doors and use assigned secure containers. Only in this house.",
        "",
        false,
        "List"
    )

    local friends = controller:GetObjVar("HouseFriends") or {}
    local scrollWindow = ScrollWindow(18, 168, 280, 92, 23)
    local any = false

    for friend, v in pairs(friends) do
        any = true
        local scrollElement = ScrollElement()
        scrollElement:AddButton(
            0,
            0,
            string.format("SelectFriend|%s", friend.Id),
            "",
            260,
            23,
            "",
            "",
            false,
            "ThinFrameHover",
            ""
        )
        scrollElement:AddLabel(
            6, --(number) x position in pixels on the window
            6, --(number) y position in pixels on the window
            friend:GetCharacterName(), --(string) text in the label
            0, --(number) width of the text for wrapping purposes (defaults to width of text)
            0, --(number) height of the label (defaults to unlimited, text is not clipped)
            16 --(number) font size (default specific to client)
            --"center", --(string) alignment "left", "center", or "right" (default "left")
            --false, --(boolean) scrollable (default false)
            --false, --(boolean) outline (defaults to false)
            --"" --(string) name of font on client (optional)
        )
        scrollWindow:Add(scrollElement)
    end

    if not (any) then
        local scrollElement = ScrollElement()
        scrollElement:AddLabel(
            6, --(number) x position in pixels on the window
            6, --(number) y position in pixels on the window
            "No Friends Added.", --(string) text in the label
            0, --(number) width of the text for wrapping purposes (defaults to width of text)
            0, --(number) height of the label (defaults to unlimited, text is not clipped)
            16 --(number) font size (default specific to client)
            --"center", --(string) alignment "left", "center", or "right" (default "left")
            --false, --(boolean) scrollable (default false)
            --false, --(boolean) outline (defaults to false)
            --"" --(string) name of font on client (optional)
        )
        scrollWindow:Add(scrollElement)
    end

    dynamicWindow:AddScrollWindow(scrollWindow)
end

-- plot only
function TaxTab(dynamicWindow)
    dynamicWindow:AddImage(8, 32, "BasicWindow_Panel", 314, 226, "Sliced")

    local plotBounds = plotController:GetObjVar("PlotBounds")
    -- this will need to be updated to support L shaped plots
    local plotSize = plotBounds[1][2]
    local taxBalance = Plot.GetBalance(plotController)
    local taxesBalanceStr = "0"
    if (taxBalance < 0) then
        taxesBalanceStr = "[FF0000]-[-]" .. GetAmountStrShort(ValueToAmounts(math.abs(taxBalance)))
    elseif (taxBalance > 0) then
        taxesBalanceStr = GetAmountStrShort(ValueToAmounts(taxBalance))
    end

    local plotSizeStr = plotSize.X .. "x" .. plotSize.Z
    -- local taxesDueStr = Plot.GetTaxDueString()
    -- local taxesAmountStr = GetAmountStrShort(ValueToAmounts(Plot.CalculateRate(plotBounds)))
    -- dynamicWindow:AddLabel(20,44,"Plot Size:",0,0,18)
    -- dynamicWindow:AddLabel(162,44,plotSizeStr,0,0,18)
    -- dynamicWindow:AddLabel(20,64,"Taxes Due:",0,0,18)
    -- dynamicWindow:AddLabel(162,64,taxesDueStr,0,0,18)
    -- dynamicWindow:AddLabel(20,84,"Weekly Tax:",0,0,18)
    -- dynamicWindow:AddLabel(162,84,taxesAmountStr,0,0,18)
    -- dynamicWindow:AddLabel(20,104,"Tax Balance:",0,0,18)
    -- dynamicWindow:AddLabel(162,104,taxesBalanceStr,0,0,18)

    dynamicWindow:AddButton(
        10,
        248,
        "Checkin",
        "Check in weekly!",
        311,
        26,
        "Check in here or open stuff on your plot to reset decay timers.",
        "",
        false,
        "List"
    )

    -- dynamicWindow:AddButton(10,268,"Pay","Add to Tax Balance",311,26,"Deposit money into the tax balance for this plot.","",false,"List")
end

-- Events

RegisterEventHandler(
    EventType.ContextMenuResponse,
    "CoOwnerOptions",
    function(user, optionStr)
        if (contextArg) then
            if (optionStr == "Remove") then
                Plot.RemoveHouseCoOwner(user, GameObj(tonumber(contextArg)), controller)
                UpdateWindow()
            end
        end
    end
)

RegisterEventHandler(
    EventType.ContextMenuResponse,
    "FriendOptions",
    function(user, optionStr)
        if (contextArg) then
            if (optionStr == "Remove") then
                Plot.RemoveHouseFriend(user, GameObj(tonumber(contextArg)), controller)
                UpdateWindow()
            end
        end
    end
)

RegisterEventHandler(
    EventType.DynamicWindowResponse,
    "PlotControlWindow",
    function(user, returnId)
        if
            ((isHouse and not Plot.HasHouseControl(this, plotController, controller)) or
                (not isHouse and not Plot.IsOwner(this, controller)))
        then
            CleanUp()
            return
        end

        if (user ~= this or HandleDecorateWindowResponse(returnId) or HandleSecurityTabResponse(returnId, user)) then
            return
        end

        -- handle tabs
        local newTab = HandleTabMenuResponse(returnId)
        if (newTab) then
            tab = newTab
            UpdateWindow()
            return
        end

        if (returnId == "Kick") then
            this:SendMessage("StartMobileEffect", "PlotKick", plotController, isHouse and controller or nil)
            return -- don't cleanup
        end

        if (isHouse) then
            -- handle individual button responses (all tabs) for houses
            if (returnId == "Rename") then
                this:SendMessage("StartMobileEffect", "HouseRename", controller)
                return -- don't cleanup
            elseif (returnId == "Destroy") then
                this:SendMessage("StartMobileEffect", "HouseDestroy", controller)
                return -- don't cleanup
            elseif (returnId == "AddCoOwner") then
                this:SendMessage("StartMobileEffect", "HouseAddCoOwner", controller)
                return -- don't cleanup
            elseif (returnId == "AddFriend") then
                this:SendMessage("StartMobileEffect", "HouseAddFriend", controller)
                return -- don't cleanup
            elseif (returnId == "OpenBank") then
                local distance = controller:GetLoc():Distance(this:GetLoc())
                if (distance > 6) then
                    user:SystemMessage(
                        tostring("Move a little closer to the center of your house to access your bank!"), "info"
                    )
                else
                    -- ClientDialog.Show {
                    --     TargetUser = user,
                    --     DialogId = "OpenBank" .. user.Id,
                    --     TitleStr = "Open your bank?",
                    --     DescStr = string.format(
                    --         "Are you sure you want to open your bank? It will cost 10,000 gold! \nBe sure not to move or it may close!"
                    --     ),
                    --     Button1Str = "Yes",
                    --     Button2Str = "No",
                    --     ResponseObj = this, -- try 'controller'
                    --     ResponseFunc = function(user, buttonId) 
                    --         DebugMessage('GO THERE')
                    --         local buttonId = tonumber(buttonId)
                    --         if (user == nil or buttonId == nil) then
                    --             return
                    --         end
                    --         if (buttonId == 0) then
                                -- local count = CountCoins(user)
                                -- local amount = 10000
                                -- if (count >= amount) then
                                    user:SystemMessage("Opening bank...", "info")
                                    -- ConsumeResourceContainer(user, "coins", amount)
                                    user:SendMessage("OpenBank", controller)
                                -- else
                                --     user:SystemMessage("You cannot afford to do that.")
                                --     return
                                -- end
                    --         end
                    --         return
                    --     end
                    -- }
                end
            end
        else
            -- handle individual button responses (all tabs) for plots
            if (returnId == "Rename") then
                this:SendMessage("StartMobileEffect", "PlotRename", controller)
                return -- don't cleanup
            elseif (returnId == "Destroy") then
                this:SendMessage("StartMobileEffect", "PlotDestroy", controller)
                return -- don't cleanup
            elseif (returnId == "Transfer") then
                this:SendMessage("StartMobileEffect", "PlotTransferOwnership", controller)
                return -- don't cleanup
            elseif (returnId == "Resize") then
                if not (this:HasModule("plot_resize_window")) then
                    this:AddModule("plot_resize_window")
                end
                this:SendMessage("InitResize", plotController)
                return -- don't cleanup
            elseif (returnId == "Checkin") then
                this:SystemMessage("Your plot has been refreshed.", "info")
                return
            elseif (returnId == "Pay") then
                if not (this:HasModule("plot_tax_window")) then
                    this:AddModule("plot_tax_window")
                end
                this:SendMessage("InitTaxWindow", plotController)
                return
            end
        end

        CleanUp()
    end
)

RegisterEventHandler(EventType.Message, "UpdatePlotControlWindow", UpdateWindow)
RegisterEventHandler(EventType.Message, "ClosePlotControlWindow", CleanUp)
RegisterEventHandler(EventType.Message, "InitControlWindow", Init)
