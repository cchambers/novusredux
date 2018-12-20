-- DAB NOTE: Hotbars still appear on top of the tutorial UI 

SCREEN_WIDTH = 4096
SCREEN_HEIGHT = 2160
NextTutorialDepth = 11000

TutPageTitles = { "", "Know Your Character", "Manage Your Inventory", "Manage Your Action Bar", "Equipped Item Abilities", "Know Your Way", "", "" }

-- elements that go behind the BG
TutBGFuncs = {
	-- Page 1: Welcome
	function (playerObj)
		return {}
	end,
	-- Page 2: Character
	function (playerObj)
		return {}
	end,

	-- Page 3: Inventory
	function (playerObj)
		return {}
	end,

	-- Page 4: Action Bar
	function (playerObj)
		OpenTutItemWindow(playerObj)
		return {"TutItem"}
	end,
	-- Page 5: Abilities
	function (playerObj)
		OpenTutItemWindow(playerObj)
		OpenTutActionWindow(playerObj)
		return {"TutItem","TutAction"}
	end,
	-- Page 6: Map
	function (playerObj)
		OpenTutItemWindow(playerObj)
		OpenTutActionWindow(playerObj)
		OpenTutAbilityWindow(playerObj)
		
		return {"TutItem","TutAction","TutAbility"}
	end,
	-- Page 7: Movement and Interaction
	function (playerObj)
		OpenTutItemWindow(playerObj)
		OpenTutActionWindow(playerObj)
		OpenTutAbilityWindow(playerObj)

		return {"TutItem","TutAction","TutAbility"}
	end,
	-- Page 8: Basics of Combat
	function (playerObj)
		OpenTutItemWindow(playerObj)
		OpenTutActionWindow(playerObj)
		OpenTutAbilityWindow(playerObj)

		return {"TutItem","TutAction","TutAbility"}
	end
}

TutPageFuncs = {
	-- Page 1: Welcome
	function (playerObj)
	    local dynamicWindow = DynamicWindow(
			"TutPage1", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
			"", --(string) Title of the window for the client UI
			0, --(number) Width of the window
			0, --(number) Height of the window
			0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
			0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
			"Transparent",--windowType, --(string) Window type (optional)
			"Center", --windowAnchor --(string) Window anchor (default "TopLeft")
			NextTutorialDepth
		)
		NextTutorialDepth = NextTutorialDepth + 1

		dynamicWindow:AddLabel(
	        0, --(number) x position in pixels on the window
	        -30, --(number) y position in pixels on the window
	        "[FFFFFF]Welcome to Novus Redux!", --(string) text in the label
	        0, --(number) width of the text for wrapping purposes (defaults to width of text)
	        0, --(number) height of the label (defaults to unlimited, text is not clipped)
	        48, --(number) font size (default specific to client)
	        "center", --(string) alignment "left", "center", or "right" (default "left")
	        false, --(boolean) scrollable (default false)
	        false, --(boolean) outline (defaults to false)
	        "SpectralSC-SemiBold" --(string) name of font on client (optional)
	    )

	    dynamicWindow:AddLabel(
	        0, --(number) x position in pixels on the window
	        30, --(number) y position in pixels on the window
	        "[FFFFFF]User Interface Basics Tutorial", --(string) text in the label
	        0, --(number) width of the text for wrapping purposes (defaults to width of text)
	        0, --(number) height of the label (defaults to unlimited, text is not clipped)
	        32, --(number) font size (default specific to client)
	        "center", --(string) alignment "left", "center", or "right" (default "left")
	        false, --(boolean) scrollable (default false)
	        false, --(boolean) outline (defaults to false)
	        "SpectralSC-SemiBold" --(string) name of font on client (optional)
	    )

		playerObj:OpenDynamicWindow(dynamicWindow)

		return {"TutPage1"}		
	end,
	-- Page 2: Character
	function (playerObj)
	    local dynamicWindow = DynamicWindow(
			"TutPage2", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
			"", --(string) Title of the window for the client UI
			0, --(number) Width of the window
			0, --(number) Height of the window
			0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
			0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
			"Transparent",--windowType, --(string) Window type (optional)
			"Center", --windowAnchor --(string) Window anchor (default "TopLeft")
			NextTutorialDepth
		)
		NextTutorialDepth = NextTutorialDepth + 1

		dynamicWindow:AddImage(
			-798/2, --(number) x position in pixels on the window
			-488/2, --(number) y position in pixels on the window
			"Instructions_CharacterWindow", --(string) sprite name	
			0,
			0
		)

		playerObj:OpenDynamicWindow(dynamicWindow)

		return {"TutPage2"}
	end,

	-- Page 3: Inventory
	function (playerObj)
	    local dynamicWindow = DynamicWindow(
			"TutPage3", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
			"", --(string) Title of the window for the client UI
			0, --(number) Width of the window
			0, --(number) Height of the window
			0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
			0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
			"Transparent",--windowType, --(string) Window type (optional)
			"Right", --windowAnchor --(string) Window anchor (default "TopLeft")
			NextTutorialDepth
		)
		NextTutorialDepth = NextTutorialDepth + 1

		dynamicWindow:AddImage(
			-90, --(number) x position in pixels on the window
			-105, --(number) y position in pixels on the window
			"Instructions_ItemBar", --(string) sprite name	
			0,
			0
		)

		dynamicWindow:AddImage(
			-930, --(number) x position in pixels on the window
			-95, --(number) y position in pixels on the window
			"Instructions_Inventory", --(string) sprite name	
			0,
			0
		)

		playerObj:OpenDynamicWindow(dynamicWindow)	

		return {"TutPage3"}
	end,

	-- Page 4: Action Bar
	function (playerObj)
	    local dynamicWindow = DynamicWindow(
			"TutPage4", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
			"", --(string) Title of the window for the client UI
			0, --(number) Width of the window
			0, --(number) Height of the window
			0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
			0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
			"Transparent",--windowType, --(string) Window type (optional)
			"Left", --windowAnchor --(string) Window anchor (default "TopLeft")
			NextTutorialDepth
		)
		NextTutorialDepth = NextTutorialDepth + 1

		dynamicWindow:AddImage(
			0, --(number) x position in pixels on the window
			-276, --(number) y position in pixels on the window
			"Instructions_SpellBar", --(string) sprite name	
			0,
			0
		)

		dynamicWindow:AddImage(
			45, --(number) x position in pixels on the window
			-279, --(number) y position in pixels on the window
			"Instructions_Spells", --(string) sprite name	
			0,
			0
		)

		playerObj:OpenDynamicWindow(dynamicWindow)	

		return {"TutPage4"}		
	end,
	-- Page 5: Abilities
	function (playerObj)
	    local dynamicWindow = DynamicWindow(
			"TutPage5", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
			"", --(string) Title of the window for the client UI
			0, --(number) Width of the window
			0, --(number) Height of the window
			0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
			0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
			"Transparent",--windowType, --(string) Window type (optional)
			"Bottom", --windowAnchor --(string) Window anchor (default "TopLeft")
			NextTutorialDepth
		)
		NextTutorialDepth = NextTutorialDepth + 1

		dynamicWindow:AddImage(
			-386/2, --(number) x position in pixels on the window
			-176, --(number) y position in pixels on the window
			"Instructions_Abilities", --(string) sprite name	
			0,
			0
		)
		
		playerObj:OpenDynamicWindow(dynamicWindow)	

		return {"TutPage5"}		
	end,
	-- Page 6: Map
	function (playerObj)
	    local dynamicWindow = DynamicWindow(
			"TutPage6", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
			"", --(string) Title of the window for the client UI
			0, --(number) Width of the window
			0, --(number) Height of the window
			0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
			0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
			"Transparent",--windowType, --(string) Window type (optional)
			"TopRight", --windowAnchor --(string) Window anchor (default "TopLeft")
			NextTutorialDepth
		)
		NextTutorialDepth = NextTutorialDepth + 1

		dynamicWindow:AddImage(
			-181, --(number) x position in pixels on the window
			18, --(number) y position in pixels on the window
			--"Instructions_AbilityBar", --(string) sprite name	
			"Instructions_Mini", --(string) sprite name	
			0,
			0
		)

		dynamicWindow:AddImage(
			-491, --(number) x position in pixels on the window
			4, --(number) y position in pixels on the window
			"Instructions_MiniMap", --(string) sprite name	
			0,
			0
		)

		playerObj:OpenDynamicWindow(dynamicWindow)	

		return {"TutPage6"}		
	end,
	-- Page 7: Movement and Interaction
	function (playerObj)
	    local dynamicWindow = DynamicWindow(
			"TutPage7", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
			"", --(string) Title of the window for the client UI
			0, --(number) Width of the window
			0, --(number) Height of the window
			0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
			0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
			"Transparent",--windowType, --(string) Window type (optional)
			"Center", --windowAnchor --(string) Window anchor (default "TopLeft")
			NextTutorialDepth
		)
		NextTutorialDepth = NextTutorialDepth + 1

		dynamicWindow:AddImage(
			-777/2, --(number) x position in pixels on the window
			-777/2, --(number) y position in pixels on the window
			"Instructions_Movement_Interaction", --(string) sprite name	
			0,
			0
		)

		playerObj:OpenDynamicWindow(dynamicWindow)
		return {"TutPage7"}		
	end,
	-- Page 8: Basics of Combat
	function (playerObj)
	    local dynamicWindow = DynamicWindow(
			"TutPage8", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
			"", --(string) Title of the window for the client UI
			0, --(number) Width of the window
			0, --(number) Height of the window
			0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
			0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
			"Transparent",--windowType, --(string) Window type (optional)
			"Center", --windowAnchor --(string) Window anchor (default "TopLeft")
			NextTutorialDepth
		)
		NextTutorialDepth = NextTutorialDepth + 1

		dynamicWindow:AddImage(
			-777/2, --(number) x position in pixels on the window
			-777/2, --(number) y position in pixels on the window
			"Instructions_CombatBasics", --(string) sprite name	
			0,
			0
		)

		playerObj:OpenDynamicWindow(dynamicWindow)
		return {"TutPage8"}		
	end,	
	-- Page 9: Mage Combat
	function (playerObj)
	    local dynamicWindow = DynamicWindow(
			"TutPage9", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
			"", --(string) Title of the window for the client UI
			0, --(number) Width of the window
			0, --(number) Height of the window
			0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
			0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
			"Transparent",--windowType, --(string) Window type (optional)
			"Center", --windowAnchor --(string) Window anchor (default "TopLeft")
			NextTutorialDepth
		)
		NextTutorialDepth = NextTutorialDepth + 1

		dynamicWindow:AddImage(
			-777/2, --(number) x position in pixels on the window
			-777/2, --(number) y position in pixels on the window
			"Instructions_MageCombatBasics", --(string) sprite name	
			0,
			0
		)

		playerObj:OpenDynamicWindow(dynamicWindow)		
		return {"TutPage9"}		
	end,
}

function OpenTutBGWindow(playerObj)
    local dynamicWindow = DynamicWindow(
		"TutBG", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
		"", --(string) Title of the window for the client UI
		0, --(number) Width of the window
		0, --(number) Height of the window
		0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
		0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
		"Transparent",--windowType, --(string) Window type (optional)
		"Center", --windowAnchor --(string) Window anchor (default "TopLeft")
		NextTutorialDepth
	)
	NextTutorialDepth = NextTutorialDepth + 1
    
	dynamicWindow:AddButton(
		-SCREEN_WIDTH/2, --(number) x position in pixels on the window
		-SCREEN_HEIGHT/2, --(number) y position in pixels on the window
		"", --(string) return id used in the DynamicWindowResponse event
		"", --(string) text in the button (defaults to empty string)
		SCREEN_WIDTH, --(number) width of the button (defaults to width of text)
		SCREEN_HEIGHT,--(number) height of the button (default decided by type of button)
		"", --(string) mouseover tooltip for the button (default blank)
		"", --(string) server command to send on button click (default to none)
		false, --(boolean) should the window close when this button is clicked? (default true)
		"Invisible" --(string) button type (default "Default")
		--(string) button state (optional, valid options are default,pressed,disabled)
		--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
	)

	dynamicWindow:AddImage(
		-SCREEN_WIDTH/2, --(number) x position in pixels on the window
		-SCREEN_HEIGHT/2, --(number) y position in pixels on the window
		"Blank", --(string) sprite name
		SCREEN_WIDTH, --(number) width of the image
		SCREEN_HEIGHT, --(number) height of the image
		"Sliced", --(string) sprite type Simple, Sliced or Object (defaults to Simple)
		"000000", --(string) sprite hue (defaults to white)
		0, -- hueindex
		0.9 --(number) (default 1.0)		
	)

	playerObj:OpenDynamicWindow(dynamicWindow)
end

function OpenTutTitleWindow(playerObj,curPage)
    local dynamicWindow = DynamicWindow(
		"TutTitle", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
		"", --(string) Title of the window for the client UI
		0, --(number) Width of the window
		0, --(number) Height of the window
		0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
		0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
		"Transparent",--windowType, --(string) Window type (optional)
		"Top", --windowAnchor --(string) Window anchor (default "TopLeft")
		NextTutorialDepth
	)
	NextTutorialDepth = NextTutorialDepth + 1

	dynamicWindow:AddLabel(
        0, --(number) x position in pixels on the window
        30, --(number) y position in pixels on the window
        "[FFFFFF]"..TutPageTitles[curPage], --(string) text in the label
        0, --(number) width of the text for wrapping purposes (defaults to width of text)
        0, --(number) height of the label (defaults to unlimited, text is not clipped)
        32, --(number) font size (default specific to client)
        "center", --(string) alignment "left", "center", or "right" (default "left")
        false, --(boolean) scrollable (default false)
        false, --(boolean) outline (defaults to false)
        "SpectralSC-SemiBold" --(string) name of font on client (optional)
    )

    playerObj:OpenDynamicWindow(dynamicWindow)
end

function OpenTutBottomWindow(playerObj,curPage)
	local dynamicWindow = DynamicWindow(
		"TutBottom", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
		"", --(string) Title of the window for the client UI
		0, --(number) Width of the window
		0, --(number) Height of the window
		0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
		0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
		"Transparent",--windowType, --(string) Window type (optional)
		"Bottom", --windowAnchor --(string) Window anchor (default "TopLeft")
		NextTutorialDepth
	)
	NextTutorialDepth = NextTutorialDepth + 1

	dynamicWindow:AddImage(
		-SCREEN_WIDTH/2, --(number) x position in pixels on the window
		-SCREEN_HEIGHT/2, --(number) y position in pixels on the window
		"Blank", --(string) sprite name
		SCREEN_WIDTH, --(number) width of the image
		SCREEN_HEIGHT, --(number) height of the image
		"Sliced", --(string) sprite type Simple, Sliced or Object (defaults to Simple)
		"000000", --(string) sprite hue (defaults to white)
		0, -- hueindex
		0.8 --(number) (default 1.0)		
	)

	dynamicWindow:AddImage(
		-SCREEN_WIDTH/2, --(number) x position in pixels on the window
		-60, --(number) y position in pixels on the window
		"Blank", --(string) sprite name
		SCREEN_WIDTH, --(number) width of the image
		60, --(number) height of the image
		"Sliced", --(string) sprite type Simple, Sliced or Object (defaults to Simple)
		"181818" --(string) sprite hue (defaults to white)
		--opacity --(number) (default 1.0)		
	)

	dynamicWindow:AddImage(
		-SCREEN_WIDTH/2, --(number) x position in pixels on the window
		-60, --(number) y position in pixels on the window
		"Divider", --(string) sprite name
		SCREEN_WIDTH, --(number) width of the image
		1, --(number) height of the image
		"Sliced" --(string) sprite type Simple, Sliced or Object (defaults to Simple)
		--hue --(string) sprite hue (defaults to white)
		--opacity --(number) (default 1.0)		
	)

	local nextButtonStr = "Complete"
	if (curPage < #TutPageFuncs) then
		nextButtonStr = "Next"
	end

	dynamicWindow:AddButton(
		-145, --(number) x position in pixels on the window
		-58, --(number) y position in pixels on the window
		nextButtonStr, --(string) return id used in the DynamicWindowResponse event
		nextButtonStr, --(string) text in the button (defaults to empty string)
		0, --(number) width of the button (defaults to width of text)
		0,--(number) height of the button (default decided by type of button)
		"", --(string) mouseover tooltip for the button (default blank)
		"", --(string) server command to send on button click (default to none)
		false, --(boolean) should the window close when this button is clicked? (default true)
		"OrnateButton" --(string) button type (default "Default")
		--(string) button state (optional, valid options are default,pressed,disabled)
		--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
	)

	playerObj:OpenDynamicWindow(dynamicWindow)	

	dynamicWindow = DynamicWindow(
		"TutBottomRight", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
		"", --(string) Title of the window for the client UI
		0, --(number) Width of the window
		0, --(number) Height of the window
		0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
		0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
		"Transparent",--windowType, --(string) Window type (optional)
		"BottomRight", --windowAnchor --(string) Window anchor (default "TopLeft")
		NextTutorialDepth
	)
	NextTutorialDepth = NextTutorialDepth + 1

	dynamicWindow:AddImage(
		-78, --(number) x position in pixels on the window
		-44, --(number) y position in pixels on the window
		"Tab_Bar", --(string) sprite name
		80, --(number) width of the image
		30, --(number) height of the image
		"Sliced" --(string) sprite type Simple, Sliced or Object (defaults to Simple)
		--hue --(string) sprite hue (defaults to white)
		--opacity --(number) (default 1.0)		
	)

	dynamicWindow:AddLabel(
        -37, --(number) x position in pixels on the window
        -37, --(number) y position in pixels on the window
        "Skip", --(string) text in the label
        0, --(number) width of the text for wrapping purposes (defaults to width of text)
        0, --(number) height of the label (defaults to unlimited, text is not clipped)
        22, --(number) font size (default specific to client)
        "center", --(string) alignment "left", "center", or "right" (default "left")
        false, --(boolean) scrollable (default false)
        false, --(boolean) outline (defaults to false)
        "SpectralSC-SemiBold" --(string) name of font on client (optional)
    )

    dynamicWindow:AddButton(
		-78, --(number) x position in pixels on the window
		-44, --(number) y position in pixels on the window
		"Complete", --(string) return id used in the DynamicWindowResponse event
		"", --(string) text in the button (defaults to empty string)
		80, --(number) width of the button (defaults to width of text)
		30,--(number) height of the button (default decided by type of button)
		"", --(string) mouseover tooltip for the button (default blank)
		"", --(string) server command to send on button click (default to none)
		false, --(boolean) should the window close when this button is clicked? (default true)
		"Invisible" --(string) button type (default "Default")
		--(string) button state (optional, valid options are default,pressed,disabled)
		--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
	)

	playerObj:OpenDynamicWindow(dynamicWindow)			
end

function OpenTutActionWindow(playerObj,curPage)
    local dynamicWindow = DynamicWindow(
		"TutAction", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
		"", --(string) Title of the window for the client UI
		0, --(number) Width of the window
		0, --(number) Height of the window
		0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
		0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
		"Transparent",--windowType, --(string) Window type (optional)
		"Left", --windowAnchor --(string) Window anchor (default "TopLeft")
		NextTutorialDepth
	)
	NextTutorialDepth = NextTutorialDepth + 1

	dynamicWindow:AddImage(
		0, --(number) x position in pixels on the window
		-276, --(number) y position in pixels on the window
		"Instructions_SpellBar", --(string) sprite name	
		0,
		0
	)

	playerObj:OpenDynamicWindow(dynamicWindow)	
end

function OpenTutAbilityWindow(playerObj,curPage)
    local dynamicWindow = DynamicWindow(
		"TutAbility", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
		"", --(string) Title of the window for the client UI
		0, --(number) Width of the window
		0, --(number) Height of the window
		0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
		0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
		"Transparent",--windowType, --(string) Window type (optional)
		"Bottom", --windowAnchor --(string) Window anchor (default "TopLeft")
		NextTutorialDepth
	)
	NextTutorialDepth = NextTutorialDepth + 1

	dynamicWindow:AddImage(
		-66, --(number) x position in pixels on the window
		-130, --(number) y position in pixels on the window
		"Instructions_AbilityBar", --(string) sprite name	
		0,
		0
	)
	
	playerObj:OpenDynamicWindow(dynamicWindow)	
end

function OpenTutItemWindow(playerObj,curPage)
	local dynamicWindow = DynamicWindow(
		"TutItem", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
		"", --(string) Title of the window for the client UI
		0, --(number) Width of the window
		0, --(number) Height of the window
		0, --startX, --(number) Starting X position of the window (chosen by client if not specified)
		0, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
		"Transparent",--windowType, --(string) Window type (optional)
		"Right", --windowAnchor --(string) Window anchor (default "TopLeft")
		NextTutorialDepth
	)
	NextTutorialDepth = NextTutorialDepth + 1

	dynamicWindow:AddImage(
		-90, --(number) x position in pixels on the window
		-105, --(number) y position in pixels on the window
		"Instructions_ItemBar", --(string) sprite name	
		0,
		0
	)

	playerObj:OpenDynamicWindow(dynamicWindow)	
end

function CloseAllTutorialUI(playerObj,openPages,openPagesBG,includeBG)
	if(includeBG) then
		-- CLOSE ALL OF THEM
		playerObj:CloseDynamicWindow("TutBG")
		playerObj:CloseDynamicWindow("TutBottom")	
		playerObj:CloseDynamicWindow("TutBottomRight")
		playerObj:CloseDynamicWindow("TutTitle")
		playerObj:CloseDynamicWindow("TutAction")
		playerObj:CloseDynamicWindow("TutItem")
		playerObj:CloseDynamicWindow("TutAbility")
		for i=1,9 do
			playerObj:CloseDynamicWindow("TutPage"..tostring(i))
		end		
	else
		for i,pageName in pairs(openPagesBG) do
			playerObj:CloseDynamicWindow(pageName)
		end

		for i,pageName in pairs(openPages) do
			playerObj:CloseDynamicWindow(pageName)
		end
	end
end

function ShowTutorialUI(playerObj,curPage)	
	curPage = curPage or 1	

	NextTutorialDepth = 11000

	local openPagesBG = {}
	if(curPage <= #TutPageFuncs) then
		openPagesBG = TutBGFuncs[curPage](playerObj)
	end	

	OpenTutBGWindow(playerObj)
	OpenTutBottomWindow(playerObj,curPage)
	OpenTutTitleWindow(playerObj,curPage)	
	
	local openPages = {}
	if(curPage <= #TutPageFuncs) then
		openPages = TutPageFuncs[curPage](playerObj)
	end	
	
	RegisterEventHandler(EventType.DynamicWindowResponse, "TutBottom",
		function (user,buttonId)			
			
			if(buttonId == "Next" and curPage < #TutPageFuncs) then
				CloseAllTutorialUI(playerObj,openPages,openPagesBG,false)
				ShowTutorialUI(user,curPage+1)				
			else
				CloseAllTutorialUI(playerObj,openPages,openPagesBG,true)
				user:SendMessage("UITutorialComplete")
			end
		end)

	RegisterEventHandler(EventType.DynamicWindowResponse, "TutBottomRight",
		function (user,buttonId)	
			CloseAllTutorialUI(playerObj,openPages,openPagesBG,true)
			user:SendMessage("UITutorialComplete")
		end)
end