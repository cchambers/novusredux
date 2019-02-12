PRESTIGEBOOK_WIDTH = 789
PRESTIGEBOOK_HEIGHT = 455

mPrestigePageIndex = 1
mPrestigeSlotIndex = {1,1}
mPrestigeBookOpen = false

mAllAbilitiesSorted= nil
mDisciplinePageIndex = {}

function GetAllAbilitiesSorted()
	if not(mAllAbilitiesSorted) then
		mAllAbilitiesSorted = {}
		local abilityIndex = 1
		for i, classData in pairs(PrestigeDataSorted) do
			mDisciplinePageIndex[classData.Name] = GetAbilityDetailPageIndex(abilityIndex)

			for i,abilityData in pairs(classData.Data.AbilitiesSorted) do
				--DebugMessage(tostring(abilityIndex) .. ": " .. abilityData.Name)
				table.insert(mAllAbilitiesSorted,abilityData)
				abilityIndex = abilityIndex + 1
			end
			-- insert a blank page for classes with an odd number of abilities
			if(abilityIndex % 2 == 0) then
				table.insert(mAllAbilitiesSorted,{})
				abilityIndex = abilityIndex + 1
			end
		end
	end

	return mAllAbilitiesSorted
end

function BackToBooks(user)
	local one = user:GetObjVar("PrestigeAbility1")
	local two = user:GetObjVar("PrestigeAbility2")
	local three = user:GetObjVar("PrestigeAbility3")
	if (one ~= nil) then
		local bookname = tostring("prestige_"..one.AbilityName:lower())
		CreateObjInBackpack(user, bookname)
		user:DelObjVar("PrestigeAbility1")
	end
	if (two ~= nil) then
		local bookname = tostring("prestige_"..two.AbilityName:lower())
		CreateObjInBackpack(user, bookname)
		user:DelObjVar("PrestigeAbility2")
	end
	if (three ~= nil) then
		local bookname = tostring("prestige_"..three.AbilityName:lower())
		CreateObjInBackpack(user, bookname)
		user:DelObjVar("PrestigeAbility3")
	end
end

function GetActualAbilityPageIndex(position)
	return ((mPrestigePageIndex - 1) * 2) + position
end

function GetAbilityDetailIndex(position)
	local actualPageIndex = GetActualAbilityPageIndex(position)		
	return actualPageIndex - 2
end

function GetAbilityDetailPageIndex(abilityIndex)	
	return math.ceil((2 + abilityIndex) / 2)
end

function GetAbilityPageCount()
	return math.ceil((2 + #GetAllAbilitiesSorted()) / 2)
end

function AddTrainedAbility(dynamicWindow,position)
	local curY = 48 + (position*68)
	local curAction = GetPrestigeAbilityUserAction(this, position,nil,nil)
	dynamicWindow:AddUserAction(120,curY,curAction,52)

	local displayName = "Not Trained"
	if(curAction.ID ~= "") then
		displayName = curAction.DisplayName
	end
	dynamicWindow:AddLabel(190,curY+16,"[43240f]"..displayName.."[-]",150,0,26,"left",false,false,"Kingthings_Dynamic")
end

function AddAbilityDetail(dynamicWindow,position,abilityTable)
	-- blank entry means leave a blank page
	if(abilityTable.Name ~= nil) then
		local abilityIcon = abilityTable.Data.Action.Icon or abilityTable.Name
		curX = (position-1) * 312
		dynamicWindow:AddImage(curX + 209,62,abilityIcon,64,64)
		dynamicWindow:AddImage(curX + 204,57,"Prestige_StaticIconFrame",74,74,"Sliced")	

		dynamicWindow:AddImage(curX + 146,138,"Prestige_TitleHeader")
		dynamicWindow:AddLabel(curX + 240,141,"[43240f]"..(abilityTable.Data.Action.DisplayName or abilityTable.Name).."[-]",150,0,28,"center",false,false,"Kingthings_Dynamic")
		dynamicWindow:AddImage(curX + 114,174,"Prestige_Divider",250,0,"Sliced")

		local reqStr = "Requires: "..StripTrailingComma(BuildPrestigePrerequisitesString(abilityTable.Data,", "))
		local descStr = abilityTable.Data.Tooltip or ""
		dynamicWindow:AddLabel(curX + 114,192,"[43240f]"..reqStr.."\n\n"..descStr.."[-]",220,300,18,"left",false,false,"PermianSlabSerif_Dynamic_Bold")
	end
end

function OpenPrestigeWindow()
	local allAbilities = GetAllAbilitiesSorted()

	local dynamicWindow = DynamicWindow(
		"PrestigeBook", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
		"", --(string) Title of the window for the client UI
		PRESTIGEBOOK_WIDTH, --(number) Width of the window
		PRESTIGEBOOK_HEIGHT, --(number) Height of the window
		-PRESTIGEBOOK_WIDTH/2, --startX, --(number) Starting X position of the window (chosen by client if not specified)
		-PRESTIGEBOOK_HEIGHT/2, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
		"TransparentDraggable",--windowType, --(string) Window type (optional)
		"Center" --windowAnchor --(string) Window anchor (default "TopLeft")
	)

	dynamicWindow:AddImage(
		0, --(number) x position in pixels on the window
		0, --(number) y position in pixels on the window
		"PrestigeBook", --(string) sprite name
		PRESTIGEBOOK_WIDTH, --(number) width of the image
		PRESTIGEBOOK_HEIGHT --(number) height of the image
		--spriteType, --(string) sprite type Simple, Sliced or Object (defaults to Simple)
		--spriteHue, --(string) sprite hue (defaults to white)
		--opacity --(number) (default 1.0)		
	)

	dynamicWindow:AddButton(
			726, --(number) x position in pixels on the window
			22, --(number) y position in pixels on the window
			"", --(string) return id used in the DynamicWindowResponse event
			"", --(string) text in the button (defaults to empty string)
			0, --(number) width of the button (defaults to width of text)
			0,--(number) height of the button (default decided by type of button)
			"", --(string) mouseover tooltip for the button (default blank)
			"", --(string) server command to send on button click (default to none)
			true, --(boolean) should the window close when this button is clicked? (default true)
			"CloseSquare" --(string) button type (default "Default")
			--buttonState --(string) button state (optional, valid options are default,pressed,disabled)
			--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
		)

	if(mPrestigePageIndex == 1) then
		dynamicWindow:AddImage(146,64,"Prestige_TitleHeader")
		dynamicWindow:AddLabel(240,67,"[43240f]Trained Abilities[-]",150,0,28,"center",false,false,"Kingthings_Dynamic")
		dynamicWindow:AddImage(114,100,"Prestige_Divider",250,0,"Sliced")
		dynamicWindow:AddImage(458,64,"Prestige_TitleHeader")
		dynamicWindow:AddLabel(554,67,"[43240f]Disciplines[-]",150,0,28,"center",false,false,"Kingthings_Dynamic")
		dynamicWindow:AddImage(428,100,"Prestige_Divider",250,0,"Sliced")

		AddTrainedAbility(dynamicWindow,1)
		AddTrainedAbility(dynamicWindow,2)
		AddTrainedAbility(dynamicWindow,3)

		dynamicWindow:AddImage(114,314,"Prestige_Divider",250,0,"Sliced")

		curY = 124
		for i,data in pairs(PrestigeDataSorted) do
			dynamicWindow:AddButton(473,curY,"Page|"..mDisciplinePageIndex[data.Name],"",0,0,nil,nil,false,"Plate")
			dynamicWindow:AddLabel(553,curY+2,"[43240f]"..data.Data.DisplayName.."[-]",160,0,28,"center",false,false,"Kingthings_Dynamic")
			curY = curY + 34
		end

		dynamicWindow:AddButton(
			430, --(number) x position in pixels on the window
			300, --(number) y position in pixels on the window
			"ResetPrestige", --(string) return id used in the DynamicWindowResponse event
			"Reset Abilities Back to Books", --(string) text in the button (defaults to empty string)
			nil, --(number) width of the button (defaults to width of text)
			0,--(number) height of the button (default decided by type of button)
			"", --(string) mouseover tooltip for the button (default blank)
			"", --(string) server command to send on button click (default to none)
			true, --(boolean) should the window close when this button is clicked? (default true)
			"Default" --(string) button type (default "Default")
			--buttonState --(string) button state (optional, valid options are default,pressed,disabled)
			--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
		)

		dynamicWindow:AddLabel(196-22,334,"[43240f]Experience[-]",160,0,24,"center",false,false,"Kingthings_Dynamic")
		dynamicWindow:AddLabel(196+90,334,"[43240f]Ability Points[-]",160,0,24,"center",false,false,"Kingthings_Dynamic")
		dynamicWindow:AddImage(118,361,"StatBarFrame",112,9,"Sliced")
		dynamicWindow:AddStatBar(120,364,110,3,"PrestigeXP","5176FF",this);
		dynamicWindow:AddLabel(276+10,358,"[43240f]"..GetPrestigePoints(this).."[-]",160,0,24,"center")

		local xpTooltip = "[E9D20E]Ability Training Points[-]\nYou earn training experience during your adventures. It takes "..ServerSettings.Prestige.PrestigePointXP.." xp to gain an ability point. Ability points are consumed when training abilities.\n\nRank I: "..ServerSettings.Prestige.AbilityRankPointCost[1].." points\nRank II: "..ServerSettings.Prestige.AbilityRankPointCost[2].." points\nRank III: "..ServerSettings.Prestige.AbilityRankPointCost[3].." points"
		dynamicWindow:AddButton(110,330,"","",264,40,xpTooltip,"",false,"Invisible")

		local buttonState = HasSkillInTracker("Prestige") and "pressed" or ""
		dynamicWindow:AddButton(338,344,"ToggleTrack","",0,0,"Track training point experience on the game HUD","",false,"Track",buttonState)
	else
		local detailIndex = GetAbilityDetailIndex(1)			
		if(detailIndex <= #allAbilities) then
			AddAbilityDetail(dynamicWindow,1,allAbilities[detailIndex])
		end

		detailIndex = GetAbilityDetailIndex(2)				
		if(detailIndex <= #allAbilities) then
			AddAbilityDetail(dynamicWindow,2,allAbilities[detailIndex])
		end
	end

	local hasPrevPage = mPrestigePageIndex > 1
		if (hasPrevPage) then
			local pageStr = tostring(mPrestigePageIndex - 1)
			dynamicWindow:AddButton(
				60, --(number) x position in pixels on the window
				24, --(number) y position in pixels on the window
				"Page|"..pageStr, --(string) return id used in the DynamicWindowResponse event
				"", --(string) text in the button (defaults to empty string)
				154, --(number) width of the button (defaults to width of text)
				93,--(number) height of the button (default decided by type of button)
				"", --(string) mouseover tooltip for the button (default blank)
				"", --(string) server command to send on button click (default to none)
				false, --(boolean) should the window close when this button is clicked? (default true)
				"BookPageDown" --(string) button type (default "Default")
				--(string) button state (optional, valid options are default,pressed,disabled)
				--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
			)
		end

		local hasNextPage = mPrestigePageIndex < GetAbilityPageCount()
		if (hasNextPage) then
			local pageStr = tostring(mPrestigePageIndex + 1)
			dynamicWindow:AddButton(
				574, --(number) x position in pixels on the window
				24, --(number) y position in pixels on the window
				"Page|"..pageStr, --(string) return id used in the DynamicWindowResponse event
				"", --(string) text in the button (defaults to empty string)
				154, --(number) width of the button (defaults to width of text)
				93,--(number) height of the button (default decided by type of button)
				"", --(string) mouseover tooltip for the button (default blank)
				"", --(string) server command to send on button click (default to none)
				false, --(boolean) should the window close when this button is clicked? (default true)
				"BookPageUp" --(string) button type (default "Default")
				--(string) button state (optional, valid options are default,pressed,disabled)
				--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
			)
		end

	-- add this last so it goes over the previous page button if there is one
	dynamicWindow:AddButton(
		3, --(number) x position in pixels on the window
		70, --(number) y position in pixels on the window
		"Page|1", --(string) return id used in the DynamicWindowResponse event
		"", --(string) text in the button (defaults to empty string)
		78, --(number) width of the button (defaults to width of text)
		58,--(number) height of the button (default decided by type of button)
		"", --(string) mouseover tooltip for the button (default blank)
		"", --(string) server command to send on button click (default to none)
		false, --(boolean) should the window close when this button is clicked? (default true)
		"PrestigeTab" --(string) button type (default "Default")
		--buttonState --(string) button state (optional, valid options are default,pressed,disabled)
		--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
	)

	this:OpenDynamicWindow(dynamicWindow)

	RegisterEventHandler(EventType.DynamicWindowResponse,"PrestigeBook",function(...) HandlePrestigeBookWindowResponse(...) end)

	RegisterEventHandler(EventType.ClientObjectCommand, "dropAction",
	function (user,sourceId,actionType,actionId,slot)
		--DebugMessage(1)
		--DebugMessage(user,sourceId,actionType,actionId,slot)
		if((sourceId == "PrestigeBook") and slot ~= nil) then
			--DebugMessage(2)
			local prestigeClass, prestigeName = actionId:match("pa_(%a+)_(%a+)")
			local hotbarAction = GetPrestigeAbilityUserAction(this, nil,prestigeClass,prestigeName)
			if not(hotbarAction.Locked) then
				hotbarAction.Slot = tonumber(slot)
				AddUserActionToSlot(hotbarAction)
			end
		end
	end)

	mPrestigeBookOpen = true
end

function HandlePrestigeBookWindowResponse(user,buttonId)
	if(not(buttonId) or buttonId == "" or buttonId == "Close") then
		UnregisterEventHandler("",EventType.DynamicWindowResponse,"PrestigeBook")
		UnregisterEventHandler("",EventType.ClientObjectCommand, "dropAction")
		mPrestigeBookOpen = false
	elseif(buttonId == "ToggleTrack") then
		if not(HasSkillInTracker("Prestige")) then
			AddSkillToTracker("Prestige")
		else
			RemoveSkillFromTracker("Prestige")
		end
		OpenPrestigeWindow()
	elseif(buttonId == "ResetPrestige") then
		BackToBooks(user)
	else
		local option, arg = string.match(buttonId, "(.+)|(.+)")
		if(option == "Page") then
			mPrestigePageIndex = tonumber(arg)
			OpenPrestigeWindow()		
		elseif(option == "Slot1") then
			local slotIndex = tonumber(arg)
			mPrestigeSlotIndex[1] = slotIndex
			OpenPrestigeWindow()
		elseif(option == "Slot2") then
			local slotIndex = tonumber(arg)
			mPrestigeSlotIndex[2] = slotIndex
			OpenPrestigeWindow()
		end
	end
end

RegisterEventHandler(EventType.Message,"OpenPrestigeBook",
	function ( ... )
		if not(mPrestigeBookOpen) then
			OpenPrestigeWindow()
		end
	end)

RegisterEventHandler(EventType.Message,"UpdatePrestigeBook",
	function ( ... )
		if(mPrestigeBookOpen) then
			OpenPrestigeWindow()
		end
	end)

function TogglePrestigeWindow()
	if not(mPrestigeBookOpen) then
		OpenPrestigeWindow()
	else
		this:CloseDynamicWindow("PrestigeBook")
		mPrestigeBookOpen = false
	end
end
RegisterEventHandler(EventType.ClientUserCommand,"toggleabilitywindow",TogglePrestigeWindow)