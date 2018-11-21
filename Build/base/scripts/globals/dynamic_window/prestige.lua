function PrestigeAbilityWindow(playerObj, prestigeClass, abilityName, level, slot)

    if ( playerObj and prestigeClass and abilityName and level and slot ) then
        playerObj:SystemMessage("set ability: "..prestigeClass.."."..abilityName.."."..level.." to slot "..slot)
        level = tonumber(level)
        GiveMobileMinimumSkillXpForAbility(playerObj, abilityName, level)
        SlotPrestigeAbility(playerObj, prestigeClass, abilityName, slot)
        UnlockPrestigeAbility(playerObj, prestigeClass, abilityName, level)
        UpdatePrestigeAbilityAction(playerObj, slot)
        return
    end

    local spacing = 0
    local offset = 10
    local buttonHeight = 30
    local buttonWidth = 240
    
    local dynamicWindow = DynamicWindow(
        "PrestigeAbilities", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
        "Prestige Abilities", --(string) Title of the window for the client UI
        280, --(number) Width of the window
        300 --(number) Height of the window
        --startX, --(number) Starting X position of the window (chosen by client if not specified)
        --startY, --(number) Starting Y position of the window (chosen by client if not specified)
        --windowType, --(string) Window type (optional)
        --windowAnchor --(string) Window anchor (default "TopLeft")
    )

    local y = 10
    if ( prestigeClass ) then
        if ( abilityName ) then
            if ( level ) then
                dynamicWindow:AddLabel(
                    25, --(number) x position in pixels on the window
                    y, --(number) y position in pixels on the window
                    PrestigeData[prestigeClass].Abilities[abilityName].Action.DisplayName .. " " .. GetLevelText(tonumber(level)), --(string) text in the label
                    buttonWidth, --(number) width of the text for wrapping purposes (defaults to width of text)
                    20, --(number) height of the label (defaults to unlimited, text is not clipped)
                    16 --(number) font size (default specific to client)
                    --"center" --(string) alignment "left", "center", or "right" (default "left")
                    --scrollable, --(boolean) scrollable (default false)
                    --outline, --(boolean) outline (defaults to false)
                    --font --(string) name of font on client (optional)
                )
                y = y + spacing + buttonHeight
                dynamicWindow:AddButton(
                    offset, --(number) x position in pixels on the window
                    y, --(number) y position in pixels on the window
                    "", --(string) return id used in the DynamicWindowResponse event
                    "Make Book", --(string) text in the button (defaults to empty string)
                    buttonWidth, --(number) width of the button (defaults to width of text)
                    buttonHeight,--(number) height of the button (default decided by type of button)
                    PrestigeData[prestigeClass].Abilities[abilityName].Action.Description, --(string) mouseover tooltip for the button (default blank)
                    "makebook "..abilityName.." "..level, --(string) server command to send on button click (default to none)
                    true,--closeWindowOnClick, --(boolean) should the window close when this button is clicked? (default true)
                    "List"--buttonType, --(string) button type (default "Default")
                    --buttonState, --(string) button state (optional, valid options are default,pressed,disabled)
                    --customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
                )
                y = y + spacing + buttonHeight
                for s=1,3 do
                    dynamicWindow:AddButton(
                        offset, --(number) x position in pixels on the window
                        y, --(number) y position in pixels on the window
                        "", --(string) return id used in the DynamicWindowResponse event
                        "Assign ability to slot "..s, --(string) text in the button (defaults to empty string)
                        buttonWidth, --(number) width of the button (defaults to width of text)
                        buttonHeight,--(number) height of the button (default decided by type of button)
                        PrestigeData[prestigeClass].Abilities[abilityName].Action.Description, --(string) mouseover tooltip for the button (default blank)
                        "prestige "..prestigeClass.." "..abilityName.." "..level.." "..s, --(string) server command to send on button click (default to none)
                        true,--closeWindowOnClick, --(boolean) should the window close when this button is clicked? (default true)
                        "List"--buttonType, --(string) button type (default "Default")
                        --buttonState, --(string) button state (optional, valid options are default,pressed,disabled)
                        --customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
                    )
                    y = y + spacing + buttonHeight
                end
            else
                for i,levelData in pairs(PrestigeData[prestigeClass].Abilities[abilityName].Levels) do
                    dynamicWindow:AddButton(
                        offset, --(number) x position in pixels on the window
                        y, --(number) y position in pixels on the window
                        "", --(string) return id used in the DynamicWindowResponse event
                        PrestigeData[prestigeClass].Abilities[abilityName].Action.DisplayName .. " " .. GetLevelText(i), --(string) text in the button (defaults to empty string)
                        buttonWidth, --(number) width of the button (defaults to width of text)
                        buttonHeight,--(number) height of the button (default decided by type of button)
                        PrestigeData[prestigeClass].Abilities[abilityName].Action.Description, --(string) mouseover tooltip for the button (default blank)
                        "prestige "..prestigeClass.." "..abilityName.." "..i, --(string) server command to send on button click (default to none)
                        false,--closeWindowOnClick, --(boolean) should the window close when this button is clicked? (default true)
                        "List"--buttonType, --(string) button type (default "Default")
                        --buttonState, --(string) button state (optional, valid options are default,pressed,disabled)
                        --customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
                    )
                    y = y + spacing + buttonHeight
                end
            end
        else
            for ability,data in pairs(PrestigeData[prestigeClass].Abilities) do
                dynamicWindow:AddButton(
                    offset, --(number) x position in pixels on the window
                    y, --(number) y position in pixels on the window
                    "PrestigeAbilityWindow", --(string) return id used in the DynamicWindowResponse event
                    data.Action.DisplayName, --(string) text in the button (defaults to empty string)
                    buttonWidth, --(number) width of the button (defaults to width of text)
                    buttonHeight,--(number) height of the button (default decided by type of button)
                    data.Action.Description, --(string) mouseover tooltip for the button (default blank)
                    "prestige "..prestigeClass.. " "..ability, --(string) server command to send on button click (default to none)
                    false,--closeWindowOnClick, --(boolean) should the window close when this button is clicked? (default true)
                    "List"--buttonType, --(string) button type (default "Default")
                    --buttonState, --(string) button state (optional, valid options are default,pressed,disabled)
                    --customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
                )
                y = y + spacing + buttonHeight
            end
        end
    else
        for class,data in pairs(PrestigeData) do
            if ( PrestigeData[class].NoUnlock ~= true ) then
                dynamicWindow:AddButton(
                    offset, --(number) x position in pixels on the window
                    y, --(number) y position in pixels on the window
                    "PrestigeAbilityWindow", --(string) return id used in the DynamicWindowResponse event
                    PrestigeData[class].DisplayName, --(string) text in the button (defaults to empty string)
                    buttonWidth, --(number) width of the button (defaults to width of text)
                    buttonHeight,--(number) height of the button (default decided by type of button)
                    PrestigeData[class].Description, --(string) mouseover tooltip for the button (default blank)
                    "prestige "..class, --(string) server command to send on button click (default to none)
                    false,--closeWindowOnClick, --(boolean) should the window close when this button is clicked? (default true)
                    "List"--buttonType, --(string) button type (default "Default")
                    --buttonState, --(string) button state (optional, valid options are default,pressed,disabled)
                    --customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
                )
                y = y + spacing + buttonHeight
            end
        end
    end

    playerObj:OpenDynamicWindow(dynamicWindow)

end

function PrestigeCommandMakeBook(playerObj, prestigeAbility, abilityLevel)
    if not ( prestigeAbility ) then
        playerObj:SystemMessage("Please specify a prestige ability.")
        return
    end

    GiveMobileMinimumSkillXpForAbility(playerObj, prestigeAbility, abilityLevel)

    RegisterSingleEventHandler(EventType.CreatedObject,"book_created",function (success,objRef)
        objRef:SendMessage("SetBook",prestigeAbility,abilityLevel)
    end)

    CreateObj("prestige_ability_book_blank", playerObj:GetLoc(), "book_created")
end