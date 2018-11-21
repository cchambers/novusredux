require 'incl_magic_sys'

--[[

Seperate module that attaches directly to the user to allow for capturing EventType.DynamicWindowResponse

]]

SPELLBOOK_X_OFFSET = 0.77
SPELLBOOK_Y_OFFSET = 0.77
SPELLBOOK_WIDTH = 789
SPELLBOOK_HEIGHT = 455

SPELLBOOK_CALC_WIDTH = SPELLBOOK_WIDTH * SPELLBOOK_X_OFFSET
SPELLBOOK_CALC_HEIGHT = SPELLBOOK_HEIGHT * SPELLBOOK_Y_OFFSET

mSpellBook = nil

-- page types are ManifestationIndex, EvocationIndex, ManifestationSpellDetail, EvocationSpellIndex
mPageType = "EvocationIndex"
mPageNumber = 1

function ShowSpellDetail(dynamicWindow,spellEntry,xOffset)
	dynamicWindow:AddLabel(
		xOffset+236, --(number) x position in pixels on the window
		44, --(number) y position in pixels on the window
		"[412A08]"..(spellEntry.Data.SpellDisplayName or spellEntry.Name).."[-]", --(string) text in the label
		0, --(number) width of the text for wrapping purposes (defaults to width of text)
		0, --(number) height of the label (defaults to unlimited, text is not clipped)
		46, --(number) font size (default specific to client)
		"center", --(string) alignment "left", "center", or "right" (default "left")
		false, --(boolean) scrollable (default false)
		false, --(boolean) outline (defaults to false)
		"Kingthings_Calligraphica_Dynamic" --(string) name of font on client (optional)
	)

	dynamicWindow:AddImage(
		xOffset+110, --(number) x position in pixels on the window
		80, --(number) y position in pixels on the window
		"SpellIndexInfo_Divider", --(string) sprite name
		250, --(number) width of the image
		0, --(number) height of the image
		"Sliced" --(string) sprite type Simple, Sliced or Object (defaults to Simple)
		--spriteHue, --(string) sprite hue (defaults to white)
		--opacity --(number) (default 1.0)
	)

	local actionData = GetSpellUserAction(spellEntry.Name)
	-- add spell user action
	dynamicWindow:AddUserAction(
		xOffset+110, --(number) x position in pixels of the window
		100, --(number) y position in pixels of the window
		actionData, --(table) table containing the user action data
		128, --(number) width in pixels of the window (default decided by client)
		128 --(number) height in pixels of the window (default decided by client)
	)

	dynamicWindow:AddLabel(
		xOffset+250, --(number) x position in pixels on the window
		118, --(number) y position in pixels on the window
		"[412A08]Difficulty: "..(spellEntry.Data.Circle or 1).."[-]", --(string) text in the label
		0, --(number) width of the text for wrapping purposes (defaults to width of text)
		0, --(number) height of the label (defaults to unlimited, text is not clipped)
		32, --(number) font size (default specific to client)
		"center", --(string) alignment "left", "center", or "right" (default "left")
		false, --(boolean) scrollable (default false)
		false, --(boolean) outline (defaults to false)
		"Kingthings_Calligraphica_Dynamic" --(string) name of font on client (optional)
	)

	dynamicWindow:AddImage(
		xOffset+110, --(number) x position in pixels on the window
		180, --(number) y position in pixels on the window
		"SpellInfo_ReagentFrame", --(string) sprite name
		250, --(number) width of the image
		190, --(number) height of the image
		"Sliced" --(string) sprite type Simple, Sliced or Object (defaults to Simple)
		--spriteHue, --(string) sprite hue (defaults to white)
		--opacity --(number) (default 1.0)
	)
	
	local regStr = GetReagentStr(spellEntry.Data.Reagents)
	if(regStr ~= "") then
		dynamicWindow:AddLabel(
			xOffset+128, --(number) x position in pixels on the window
			194, --(number) y position in pixels on the window
			"[412A08]"..regStr.."[-]", --(string) text in the label
			0, --(number) width of the text for wrapping purposes (defaults to width of text)
			0, --(number) height of the label (defaults to unlimited, text is not clipped)
			32, --(number) font size (default specific to client)
			"left", --(string) alignment "left", "center", or "right" (default "left")
			false, --(boolean) scrollable (default false)
			false, --(boolean) outline (defaults to false)
			"Kingthings_Calligraphica_Dynamic" --(string) name of font on client (optional)
		)
	end
end

function ShowSpellBookDialog()
	if ( circle == nil ) then circle = 1 end

	local castingSkill = "EvocationSkill"
	if(mPageType == "ManifestationIndex" or mPageType == "ManifestationSpellDetail") then
		castingSkill = "ManifestationSkill"
	end

	local detailPageStr = (mPageType == "ManifestationIndex" or mPageType == "ManifestationSpellDetail") and "ManifestationSpellDetail" or "EvocationSpellDetail"
	local isDetailPage = (mPageType == "ManifestationSpellDetail" or mPageType == "EvocationSpellDetail")

	local bookSpells = mSpellBook:GetObjVar("SpellList") or nil
	local spellsSorted = {}
	if(bookSpells) then
		for k,v in pairs(SpellData.AllSpells) do
			if(bookSpells[k] and v.Skill == castingSkill) then
				table.insert(spellsSorted,{Name = k, Data = v})
			end
		end

		table.sort(spellsSorted,
			function(a,b) 
				local circleA = (a.Data.Circle or 0)
				local circleB = (b.Data.Circle or 0)
				if(circleA == circleB) then
					return a.Name < b.Name
				else
					return circleA < circleB
				end
			end)
	end

	local dynamicWindow = DynamicWindow(
		"SpellBook", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
		"", --(string) Title of the window for the client UI
		SPELLBOOK_WIDTH, --(number) Width of the window
		SPELLBOOK_HEIGHT, --(number) Height of the window
		-SPELLBOOK_WIDTH/2, --startX, --(number) Starting X position of the window (chosen by client if not specified)
		-SPELLBOOK_HEIGHT/2, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
		"TransparentDraggable",--windowType, --(string) Window type (optional)
		"Center" --windowAnchor --(string) Window anchor (default "TopLeft")
	)

	dynamicWindow:AddImage(
		0, --(number) x position in pixels on the window
		0, --(number) y position in pixels on the window
		"Spellbook", --(string) sprite name
		SPELLBOOK_WIDTH, --(number) width of the image
		SPELLBOOK_HEIGHT --(number) height of the image
		--spriteType, --(string) sprite type Simple, Sliced or Object (defaults to Simple)
		--spriteHue, --(string) sprite hue (defaults to white)
		--opacity --(number) (default 1.0)		
	)

	if(isDetailPage) then		
		local isFirstPage = (mPageNumber == 1)
		local isLastPage = (mPageNumber == math.ceil(#spellsSorted/2))

		if not(isFirstPage) then
			local pageStr = tostring(mPageNumber - 1)
			dynamicWindow:AddButton(
				60, --(number) x position in pixels on the window
				24, --(number) y position in pixels on the window
				"ChangePage|"..detailPageStr.."|"..pageStr, --(string) return id used in the DynamicWindowResponse event
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

		if not(isLastPage) then
			local pageStr = tostring(mPageNumber + 1)
			dynamicWindow:AddButton(
				574, --(number) x position in pixels on the window
				24, --(number) y position in pixels on the window
				"ChangePage|"..detailPageStr.."|"..pageStr, --(string) return id used in the DynamicWindowResponse event
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
	end

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
			"CloseSquare", --(string) button type (default "Default")
			buttonState --(string) button state (optional, valid options are default,pressed,disabled)
			--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
		)

	local buttonState = ""
	if(mPageType == "EvocationIndex" or mPageType == "EvocationSpellDetail") then
		buttonState = "pressed"
	end

	dynamicWindow:AddButton(
			3, --(number) x position in pixels on the window
			70, --(number) y position in pixels on the window
			"ChangePage|EvocationIndex|1", --(string) return id used in the DynamicWindowResponse event
			"", --(string) text in the button (defaults to empty string)
			78, --(number) width of the button (defaults to width of text)
			58,--(number) height of the button (default decided by type of button)
			"", --(string) mouseover tooltip for the button (default blank)
			"", --(string) server command to send on button click (default to none)
			false, --(boolean) should the window close when this button is clicked? (default true)
			"EvocationTab", --(string) button type (default "Default")
			buttonState --(string) button state (optional, valid options are default,pressed,disabled)
			--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
		)

	buttonState = ""
	if(mPageType == "ManifestationIndex" or mPageType == "ManifestationSpellDetail") then
		buttonState = "pressed"
	end

	dynamicWindow:AddButton(
			3, --(number) x position in pixels on the window
			126, --(number) y position in pixels on the window
			"ChangePage|ManifestationIndex|1", --(string) return id used in the DynamicWindowResponse event
			"", --(string) text in the button (defaults to empty string)
			76, --(number) width of the button (defaults to width of text)
			58,--(number) height of the button (default decided by type of button)
			"", --(string) mouseover tooltip for the button (default blank)
			"", --(string) server command to send on button click (default to none)
			false, --(boolean) should the window close when this button is clicked? (default true)
			"ManifestationTab", --(string) button type (default "Default")
			buttonState --(string) button state (optional, valid options are default,pressed,disabled)
			--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
		)	

	if(mPageType == "ManifestationIndex" or mPageType == "EvocationIndex") then
		local labelStr = (mPageType == "ManifestationIndex") and "[412A08]Manifestation[-]" or "[412A08]Evocation[-]"

		dynamicWindow:AddLabel(
			236, --(number) x position in pixels on the window
			44, --(number) y position in pixels on the window
			labelStr, --(string) text in the label
			0, --(number) width of the text for wrapping purposes (defaults to width of text)
			0, --(number) height of the label (defaults to unlimited, text is not clipped)
			46, --(number) font size (default specific to client)
			"center", --(string) alignment "left", "center", or "right" (default "left")
			false, --(boolean) scrollable (default false)
			false, --(boolean) outline (defaults to false)
			"Kingthings_Calligraphica_Dynamic" --(string) name of font on client (optional)
		)

		dynamicWindow:AddImage(
			110, --(number) x position in pixels on the window
			80, --(number) y position in pixels on the window
			"SpellIndexInfo_Divider", --(string) sprite name
			250, --(number) width of the image
			0, --(number) height of the image
			"Sliced" --(string) sprite type Simple, Sliced or Object (defaults to Simple)
			--spriteHue, --(string) sprite hue (defaults to white)
			--opacity --(number) (default 1.0)
		)		

		local xOffset = 110
		local yOffset = 90
		local spellIndex = 1
		for i,spellEntry in pairs(spellsSorted) do
			local pageStr = tostring(math.ceil(spellIndex/2))
			dynamicWindow:AddButton(
				xOffset, --(number) x position in pixels on the window
				yOffset, --(number) y position in pixels on the window
				"ChangePage|"..detailPageStr.."|"..pageStr, --(string) return id used in the DynamicWindowResponse event
				tostring(spellEntry.Data.Circle or 1).."|"..(spellEntry.Data.SpellDisplayName or spellEntry.Name), --(string) text in the button (defaults to empty string)
				250, --(number) width of the button (defaults to width of text)
				34,--(number) height of the button (default decided by type of button)
				"", --(string) mouseover tooltip for the button (default blank)
				"", --(string) server command to send on button click (default to none)
				false, --(boolean) should the window close when this button is clicked? (default true)
				"BookList" --(string) button type (default "Default")
				--(string) button state (optional, valid options are default,pressed,disabled)
				--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
			)

			yOffset = yOffset + 36
			spellIndex = spellIndex + 1
			if(spellIndex == 9) then
				yOffset = 48
				xOffset = xOffset + 320
			end
		end

		dynamicWindow:AddButton(
				xOffset, --(number) x position in pixels on the window
				yOffset, --(number) y position in pixels on the window
				"Drop", --(string) return id used in the DynamicWindowResponse event
				"+|Drop spell scroll here", --(string) text in the button (defaults to empty string)
				250, --(number) width of the button (defaults to width of text)
				34,--(number) height of the button (default decided by type of button)
				"", --(string) mouseover tooltip for the button (default blank)
				"", --(string) server command to send on button click (default to none)
				false, --(boolean) should the window close when this button is clicked? (default true)
				"BookList", --(string) button type (default "Default")
				"faded"--(string) button state (optional, valid options are default,pressed,disabled)
				--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
			)
	else		
		local xOffset = 0
		local castingSkill = (mPageType == "ManifestationSpellDetail") and "ManifestationSkill" or "EvocationSkill"
		local spellIndex = 1
		local spellStart = ((mPageNumber-1) * 2) + 1
		for i,spellEntry in pairs(spellsSorted) do
			if(spellIndex >= spellStart and spellIndex <= spellStart + 1) then
				ShowSpellDetail(dynamicWindow,spellEntry,xOffset)
				xOffset = 320
			end
			spellIndex = spellIndex + 1
		end			
	end

	this:OpenDynamicWindow(dynamicWindow)
	mOpen = true

end

RegisterEventHandler(EventType.Message, "OpenCircleSpellBook", 
	function(spellBook,pageType)
		if ( spellBook == nil ) then
			DebugMessage("[spellbook_dynamic_window|Message:OpenSpellBook] ERROR: spellBook is nil")
			return
		end
		if(pageType) then
			mPageType = pageType
			mPageNumber = 1
		end
		mSpellBook = spellBook
		ShowSpellBookDialog()
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "SpellBook", function(user, returnId)
	if(returnId ~= nil) then
		local result = StringSplit(returnId, "|")
		if(result[1] == "ChangePage") then			
			mPageType = result[2]
			mPageNumber = tonumber(result[3])
			ShowSpellBookDialog()
			return
		elseif(returnId == "Drop") then
			local carriedObject = user:CarriedObject()			
			if(carriedObject ) then
				local spell = carriedObject:GetObjVar("Spell")
				if(spell and SpellData.AllSpells[spell]) then					
					TryAddSpellToSpellbook(mSpellBook,carriedObject,user)
				end
			end
			return
		end
	end

	this:DelModule("spellbook_dynamic_window")
end)

RegisterEventHandler(EventType.ClientObjectCommand, "dropAction",
	function (user,sourceId,actionType,actionId,slot)
		--DebugMessage(1)
		--DebugMessage(user,sourceId,actionType,actionId,slot)
		if((sourceId == "SpellBook") and slot ~= nil) then
			--DebugMessage(2)
			local hotbarAction = GetSpellUserAction(actionId)
			hotbarAction.Slot = tonumber(slot)
			RequestAddUserActionToSlot(user,hotbarAction)
		end
	end)

RegisterEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
	function()
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(5), "SWABNOCleanup")
	end)

-- Spell Window Attached But Not Open Cleanup
RegisterEventHandler(EventType.Timer, "SWABNOCleanup",
	function()
		if not( mOpen ) then
			this:DelModule("spellbook_dynamic_window")
		end
	end)