SKILLBOOK_WIDTH = 789
SKILLBOOK_HEIGHT = 455
NUMSKILLSPERPAGE = 10

mSkillPageIndex = 1
mSkillBookOpen = false
mSkillsSorted = nil

-- cache this while we build the favorites page to save on objvar lookups
local favTable = nil

function IsFavoriteSkill(skillName)
	local skillFavs = favTable or this:GetObjVar("SkillFavorites") or {}
	return skillFavs[skillName]
end

function SetFavoriteSkill(skillName,isAdd)
	local skillFavs = favTable or this:GetObjVar("SkillFavorites") or {}
	if(isAdd == nil) then
		isAdd = not(skillFavs[skillName] == true)
	end

	if(isAdd) then
		if(CountTable(skillFavs) >= 10) then
			this:SystemMessage("You can only have 10 favorite skills.","info")
			return
		end
		skillFavs[skillName] = true
	else
		skillFavs[skillName] = nil
	end

	if(CountTable(skillFavs) > 0) then
		this:SetObjVar("SkillFavorites",skillFavs)
	else
		this:DelObjVar("SkillFavorites")
	end
end

function GetAllSkills()
	if not(mSkillsSorted) then
		mSkillsSorted = {}
		for skillName,skillData in pairs(SkillData.AllSkills) do
			if not(skillData.Skip) then
				table.insert(mSkillsSorted,{Name = skillName, Data = skillData})
			end
		end

		table.sort(mSkillsSorted,function(a,b) return GetSkillDisplayName(a.Name) < GetSkillDisplayName(b.Name) end)
	end

	return mSkillsSorted
end

function GetActualSkillPageIndex(position)
	--DebugMessage("actualPageIndex "..tostring(mSkillPageIndex).." "..tostring(position))
	return ((mSkillPageIndex - 1) * 2) + position
end

function GetNumSkillIndexPages()
	return math.ceil(#GetAllSkills() / NUMSKILLSPERPAGE)
end

function GetSkillPageType(position)
	local actualPageIndex = GetActualSkillPageIndex(position)
	--DebugMessage("actualPageIndex "..tostring(actualPageIndex))
	if(actualPageIndex == 1) then
		return "Favorites"
	elseif(actualPageIndex > 1 and actualPageIndex <= (1 + GetNumSkillIndexPages())) then
		return "Index",actualPageIndex - 1
	else
		--DebugMessage("GetSkillPageType",tostring(actualPageIndex),tostring(GetNumSkillIndexPages()))
		return "Detail",actualPageIndex - (1 + GetNumSkillIndexPages())
	end
end

function GetSkillDetailPageIndex(skillIndex)
	--DebugMessage("GetSkillDetailPageIndex",tostring(GetNumSkillIndexPages()),tostring(skillIndex))
	return math.ceil((1 + GetNumSkillIndexPages() + skillIndex) / 2)
end

function GetSkillPageCount()
	return math.ceil((1 + GetNumSkillIndexPages() + #GetAllSkills()) / 2)
end

function AddIndexElements(dynamicWindow,curX,startIndex,isFavorites)
	local skillIndex = 1
	for i,skillInfo in pairs(GetAllSkills()) do
		-- if this skill goes on this page and passes the favorites filter
		if((i >= startIndex and skillIndex <= NUMSKILLSPERPAGE)
				and (not(isFavorites) or IsFavoriteSkill(skillInfo.Name))) then

			local curY = (skillIndex-1)*25
			if((skillIndex-1) % 2 == 1) then
				dynamicWindow:AddImage(curX+108,curY + 107,"TextDivider",250,0,"Sliced")
			end

			local buttonId = "Page|"..GetSkillDetailPageIndex(i)
			local buttonLabel = GetSkillDisplayName(skillInfo.Name).."|"..GetSkillLevel(this,skillInfo.Name)
			dynamicWindow:AddButton(curX+112,curY + 113,buttonId,buttonLabel,242,25,"","",false,"TextTwoColumn")

			skillIndex = skillIndex + 1
		end
	end

	return skillIndex -1
end

function AddFavoritesPage(dynamicWindow)
	favTable = this:GetObjVar("SkillFavorites") or {}

	dynamicWindow:AddImage(146,64,"Prestige_TitleHeader")
	dynamicWindow:AddLabel(240,67,"[43240f]Favorites[-]",150,0,28,"center",false,false,"Kingthings_Dynamic")
	dynamicWindow:AddImage(114,100,"Prestige_Divider",250,0,"Sliced")

	if(AddIndexElements(dynamicWindow,0,1,true) == 0) then
		dynamicWindow:AddLabel(112,113,"[412A08]No Favorites[-]",300,0,18,"",false,false,"PermianSlabSerif_Dynamic_Bold")
	end
end

function AddSkillIndexPage(dynamicWindow,position,pageTypeIndex)
	local curX = (position - 1) * 312

	dynamicWindow:AddImage(curX + 146,64,"Prestige_TitleHeader")
	dynamicWindow:AddLabel(curX + 240,67,"[43240f]Skills[-]",150,0,28,"center",false,false,"Kingthings_Dynamic")
	dynamicWindow:AddImage(curX + 114,100,"Prestige_Divider",250,0,"Sliced")

	local startIndex = ((pageTypeIndex - 1) * NUMSKILLSPERPAGE) + 1
	AddIndexElements(dynamicWindow,curX,startIndex,false)
end

-- function AddSkillDetail(dynamicWindow,position,pageTypeIndex)
-- 	--DebugMessage("AddSkillDetail",tostring(position),tostring(pageTypeIndex))
-- 	local curX = (position - 1) * 312

-- 	local skillInfo = GetAllSkills()[pageTypeIndex]
-- 	if(skillInfo) then
-- 		dynamicWindow:AddImage(curX + 188,48,"SkillIconsFrame",102,102)

-- 		local skillIcon = skillInfo.Data.SkillIcon or ("Skill_"..string.sub(skillInfo.Name,1,-6))
-- 		dynamicWindow:AddImage(curX + 206,66,skillIcon,66,66)

-- 		dynamicWindow:AddImage(curX + 146,150,"Prestige_TitleHeader")
-- 		dynamicWindow:AddLabel(curX + 240,153,"[43240f]"..GetSkillDisplayName(skillInfo.Name).."[-]",146,28,28,"center",false,false,"Kingthings_Dynamic")
-- 		dynamicWindow:AddImage(curX + 114,186,"Prestige_Divider",250,0,"Sliced")

-- 		dynamicWindow:AddLabel(curX + 114,204,"[412A08]"..(skillInfo.Data.Description or "").."[-]",250,110,18,"",false,false,"PermianSlabSerif_Dynamic_Bold")

-- 		dynamicWindow:AddImage(curX + 114,308,"Prestige_Divider",250,0,"Sliced")

-- 		dynamicWindow:AddSkillSlider(curX + 122,330,skillInfo.Name,GetSkillCap(this,skillInfo.Name),GetSkillMaxAttained(this,skillInfo.Name),372)
-- 		dynamicWindow:AddButton(curX + 114,314,"","",250,100,"[$3371]","",false,"Invisible")

-- 		if(skillInfo.Data.Abilities) then
-- 			local curAbilityX = curX + 120
-- 			for i, abilityName in pairs(skillInfo.Data.Abilities) do
-- 				local curAction = GetPrestigeAbilityUserAction(this, nil,"Skills",abilityName)
-- 				dynamicWindow:AddUserAction(curAbilityX,248,curAction,52)
-- 				curAbilityX = curAbilityX + 40
-- 			end
-- 		end

-- 		local displayString = "Track Skill"
-- 		if ( HasSkillInTracker(skillInfo.Name)) then
-- 			displayString = "Untrack Skill"
-- 		end
-- 		--dynamicWindow:AddButton(curX + 188,352,"ToggleTrackSkill|"..skillInfo.Name,displayString,90,22,"Track/Untrack the progress of this skill.",nil,false,"List")	

-- 		local trackState = ""
-- 		if(HasSkillInTracker(skillInfo.Name)) then
-- 			trackState = "pressed"
-- 		end
-- 		dynamicWindow:AddButton(curX + 307,51,"ToggleTrackSkill|"..skillInfo.Name,"",22,22,"Tracked skills appear on the game HUD.","",false,"Track",trackState)

-- 		local favState = ""
-- 		if(IsFavoriteSkill(skillInfo.Name)) then
-- 			favState = "pressed"
-- 		end
-- 		dynamicWindow:AddButton(curX + 327,50,"ToggleFavorite|"..skillInfo.Name,"",22,22,"Favorite skills are shown on the first page of the skill book.","",false,"Star",favState)
-- 	end
-- end

function OpenSkillWindow()
	local dynamicWindow = DynamicWindow(
		"SkillWindow", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
		"", --(string) Title of the window for the client UI
		SKILLBOOK_WIDTH, --(number) Width of the window
		SKILLBOOK_HEIGHT, --(number) Height of the window
		-SKILLBOOK_WIDTH/2, --startX, --(number) Starting X position of the window (chosen by client if not specified)
		-SKILLBOOK_HEIGHT/2, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
		"TransparentDraggable",--windowType, --(string) Window type (optional)
		"Center" --windowAnchor --(string) Window anchor (default "TopLeft")
	)

	dynamicWindow:AddImage(
		0, --(number) x position in pixels on the window
		0, --(number) y position in pixels on the window
		"SkillBook", --(string) sprite name
		SKILLBOOK_WIDTH, --(number) width of the image
		SKILLBOOK_HEIGHT --(number) height of the image
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

	local hasPrevPage = mSkillPageIndex > 1
	if (hasPrevPage) then
		local pageStr = tostring(mSkillPageIndex - 1)
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

	local hasNextPage = mSkillPageIndex < GetSkillPageCount()
	if (hasNextPage) then
		local pageStr = tostring(mSkillPageIndex + 1)
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

	local pageType, pageTypeIndex = GetSkillPageType(1)
	if(pageType == "Favorites") then
		AddFavoritesPage(dynamicWindow)
	elseif(pageType == "Index") then
		AddSkillIndexPage(dynamicWindow,1,pageTypeIndex)
	elseif(pageType == "Detail") then
		AddSkillDetail(dynamicWindow,1,pageTypeIndex)
	end

	local pageType, pageTypeIndex = GetSkillPageType(2)
	if(pageType == "Index") then
		AddSkillIndexPage(dynamicWindow,2,pageTypeIndex)
	elseif(pageType == "Detail") then
		AddSkillDetail(dynamicWindow,2,pageTypeIndex)
	end

	dynamicWindow:AddLabel(568,416, GetSkillTotal(this) .. " / "..ServerSettings.Skills.PlayerSkillCap.Total,100,20,20,"center",false,false,"PermianSlabSerif_Dynamic_Bold")
	dynamicWindow:AddButton(506,406,"","",120,38,"[$3370]","",false,"Invisible")

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
		"SkillTab" --(string) button type (default "Default")
		--buttonState --(string) button state (optional, valid options are default,pressed,disabled)
		--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
	)

	this:OpenDynamicWindow(dynamicWindow)

	RegisterEventHandler(EventType.DynamicWindowResponse,"SkillWindow",function(...) HandleSkillBookWindowResponse(...) end)
	RegisterEventHandler(EventType.ClientObjectCommand, "dropAction",
	function (user,sourceId,actionType,actionId,slot)
		--DebugMessage(1)
		--DebugMessage(user,sourceId,actionType,actionId,slot)
		if((sourceId == "SkillWindow") and slot ~= nil) then
			--DebugMessage(2)
			local prestigeClass, prestigeName = actionId:match("pa_(%a+)_(%a+)")
			local hotbarAction = GetPrestigeAbilityUserAction(this, nil,prestigeClass,prestigeName)
			hotbarAction.Slot = tonumber(slot)
			
			AddUserActionToSlot(hotbarAction)
		end
	end)

	mSkillBookOpen = true
end

function HandleSkillBookWindowResponse(user,buttonId,fieldData)
	if(not(buttonId) or buttonId == "" or buttonId == "Close") then
		UnregisterEventHandler("",EventType.DynamicWindowResponse,"SkillWindow")
		mSkillBookOpen = false
	else
		local option, arg = string.match(buttonId, "(.+)|(.+)")
		if(option == "Page") then
			--DebugMessage("GOTO PAGE "..arg)
			mSkillPageIndex = tonumber(arg)
			OpenSkillWindow()		
		elseif(option == "ToggleFavorite") then
			local favSkill = arg
			SetFavoriteSkill(favSkill)
			OpenSkillWindow()
		elseif (option == "ToggleTrackSkill") then
			--DebugMessage(2)
			if (HasSkillInTracker(arg)) then
				--DebugMessage(3)
				RemoveSkillFromTracker(arg)
			else
				--DebugMessage(4)
				AddSkillToTracker(arg)
			end
			OpenSkillWindow()
		elseif (option == "SkillSlider") then
			local skillName = arg
			local parts = StringSplit(tostring(fieldData.SliderValue),",") 
            local newCap = tonumber(parts[1])
			if(newCap) then
				--DebugMessage("HandleAdjustSkillCapRequest",tostring(skillName),tostring(newCap))
				HandleAdjustSkillCapRequest(skillName, newCap)
			end
		end
	end
end

function ToggleSkillWindow()
	if not(mSkillBookOpen) then
		OpenSkillWindow()
	else
		this:CloseDynamicWindow("SkillWindow")
		mSkillBookOpen = false
	end
end

RegisterEventHandler(EventType.Message,"UpdateSkillBook",
	function ( ... )
		if(mSkillBookOpen) then
			OpenSkillWindow()
		end
	end)

RegisterEventHandler(EventType.ClientUserCommand,"toggleskillwindow",ToggleSkillWindow)

-- NOS Edits
function AddSkillDetail(dynamicWindow,position,pageTypeIndex)
	--DebugMessage("AddSkillDetail",tostring(position),tostring(pageTypeIndex))
	local curX = (position - 1) * 312

	local skillInfo = GetAllSkills()[pageTypeIndex]
	if(skillInfo) then
		dynamicWindow:AddImage(curX + 188,48,"SkillIconsFrame",102,102)

		local skillIcon = skillInfo.Data.SkillIcon or ("Skill_"..string.sub(skillInfo.Name,1,-6))
		dynamicWindow:AddImage(curX + 206,66,skillIcon,66,66)

		dynamicWindow:AddImage(curX + 146,150,"Prestige_TitleHeader")
		dynamicWindow:AddLabel(curX + 240,153,"[43240f]"..GetSkillDisplayName(skillInfo.Name).."[-]",146,28,28,"center",false,false,"Kingthings_Dynamic")
		dynamicWindow:AddImage(curX + 114,186,"Prestige_Divider",250,0,"Sliced")

		dynamicWindow:AddLabel(curX + 114,204,"[412A08]"..(skillInfo.Data.Description or "").."[-]",250,110,18,"",false,false,"PermianSlabSerif_Dynamic_Bold")

		dynamicWindow:AddImage(curX + 114,308,"Prestige_Divider",250,0,"Sliced")

		-- dynamicWindow:AddSkillSlider(curX + 122,330,skillInfo.Name,GetSkillCap(this,skillInfo.Name),GetSkillMaxAttained(this,skillInfo.Name),372)
		dynamicWindow:AddButton(curX + 114,314,"","",250,100,"[$3371]","",false,"Invisible")

		if(skillInfo.Data.Abilities) then
			local curAbilityX = curX + 120
			for i, abilityName in pairs(skillInfo.Data.Abilities) do
				local curAction = GetPrestigeAbilityUserAction(this, nil,"Skills",abilityName)
				dynamicWindow:AddUserAction(curAbilityX,248,curAction,52)
				curAbilityX = curAbilityX + 40
			end
		end

		local displayString = "Track Skill"
		if ( HasSkillInTracker(skillInfo.Name)) then
			displayString = "Untrack Skill"
		end
		--dynamicWindow:AddButton(curX + 188,352,"ToggleTrackSkill|"..skillInfo.Name,displayString,90,22,"Track/Untrack the progress of this skill.",nil,false,"List")	

		local trackState = ""
		if(HasSkillInTracker(skillInfo.Name)) then
			trackState = "pressed"
		end
		dynamicWindow:AddButton(curX + 307,51,"ToggleTrackSkill|"..skillInfo.Name,"",22,22,"Tracked skills appear on the game HUD.","",false,"Track",trackState)

		local favState = ""
		if(IsFavoriteSkill(skillInfo.Name)) then
			favState = "pressed"
		end
		dynamicWindow:AddButton(curX + 327,50,"ToggleFavorite|"..skillInfo.Name,"",22,22,"Favorite skills are shown on the first page of the skill book.","",false,"Star",favState)
	end
end
