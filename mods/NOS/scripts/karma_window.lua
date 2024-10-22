KARMA_WINDOW_WIDTH = 550
KARMA_WINDOW_HEIGHT = 478

function CloseKarmaWindow()
	this:CloseDynamicWindow("KarmaWindow")
	this:DelModule("karma_window")
end

function ShowKarmaWindow()
	-- local dynamicWindow = DynamicWindow(
	-- 	"KarmaWindow", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
	-- 	"Karma", --(string) Title of the window for the client UI
	-- 	KARMA_WINDOW_WIDTH, --(number) Width of the window
	-- 	KARMA_WINDOW_HEIGHT --(number) Height of the window
	-- 	--nil, --startX, --(number) Starting X position of the window (chosen by client if not specified)
	-- 	--nil, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
	-- 	--"TransparentDraggable",--windowType, --(string) Window type (optional)
	-- 	--"Center" --windowAnchor --(string) Window anchor (default "TopLeft")
	-- )

	-- dynamicWindow:AddImage(8,6,"BasicWindow_Panel",514,186,"Sliced")
	-- dynamicWindow:AddImage(10,6,"HeaderRow_Bar",510,26,"Sliced")

	-- dynamicWindow:AddLabel(265,12,"Alignment",310,32,20,"center",false,true,"SpectralSC-SemiBold")
	
	-- local karmaState = GetKarmaAlignmentName(this)

	-- if(karmaState == "Peaceful") then
	-- 	dynamicWindow:AddImage(21,36,"Karma_Circle_Frame_Glow")	
	-- end
	-- dynamicWindow:AddImage(28,44,"Karma_Circle_Frame")	
	-- dynamicWindow:AddButton(
	-- 			32, --(number) x position in pixels on the window
	-- 			48, --(number) y position in pixels on the window
	-- 			"State|Peaceful", --(string) return id used in the DynamicWindowResponse event
	-- 			"", --(string) text in the button (defaults to empty string)
	-- 			0, --(number) width of the button (defaults to width of text)
	-- 			0,--(number) height of the button (default decided by type of button)
	-- 			"", --(string) mouseover tooltip for the button (default blank)
	-- 			"", --(string) server command to send on button click (default to none)
	-- 			false, --(boolean) should the window close when this button is clicked? (default true)
	-- 			"Peaceful" --(string) button type (default "Default")
	-- 			--(string) button state (optional, valid options are default,pressed,disabled)
	-- 			--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
	-- 		)
	-- dynamicWindow:AddLabel(70,45,"[$3379]",460,80,18)

	-- if(karmaState == "Chaotic") then
	-- 	dynamicWindow:AddImage(21,86,"Karma_Circle_Frame_Glow")	
	-- end
	-- dynamicWindow:AddImage(28,94,"Karma_Circle_Frame")	
	-- dynamicWindow:AddButton(
	-- 			32, --(number) x position in pixels on the window
	-- 			98, --(number) y position in pixels on the window
	-- 			"State|Chaotic", --(string) return id used in the DynamicWindowResponse event
	-- 			"", --(string) text in the button (defaults to empty string)
	-- 			0, --(number) width of the button (defaults to width of text)
	-- 			0,--(number) height of the button (default decided by type of button)
	-- 			"", --(string) mouseover tooltip for the button (default blank)
	-- 			"", --(string) server command to send on button click (default to none)
	-- 			false, --(boolean) should the window close when this button is clicked? (default true)
	-- 			"Chaotic" --(string) button type (default "Default")
	-- 			--(string) button state (optional, valid options are default,pressed,disabled)
	-- 			--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
	-- 		)
	-- dynamicWindow:AddLabel(70,95,"[$3380]",460,80,18)

	-- if(karmaState == "Unlawful") then
	-- 	dynamicWindow:AddImage(21,136,"Karma_Circle_Frame_Glow")	
	-- end
	-- dynamicWindow:AddImage(28,144,"Karma_Circle_Frame")	
	-- dynamicWindow:AddButton(
	-- 			32, --(number) x position in pixels on the window
	-- 			148, --(number) y position in pixels on the window
	-- 			"State|Unlawful", --(string) return id used in the DynamicWindowResponse event
	-- 			"", --(string) text in the button (defaults to empty string)
	-- 			0, --(number) width of the button (defaults to width of text)
	-- 			0,--(number) height of the button (default decided by type of button)
	-- 			"", --(string) mouseover tooltip for the button (default blank)
	-- 			"", --(string) server command to send on button click (default to none)
	-- 			false, --(boolean) should the window close when this button is clicked? (default true)
	-- 			"Unlawful" --(string) button type (default "Default")
	-- 			--(string) button state (optional, valid options are default,pressed,disabled)
	-- 			--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
	-- 		)
	-- dynamicWindow:AddLabel(70,145,"[$3381]",460,80,18)
	
	-- local isDisabled = this:HasObjVar("ForceOrderOptIn")
	-- dynamicWindow:AddButton(28, 200, "OrderOptIn", "Disable Order confirmation when attacking chaotic players.", 400, 23, "", "", false,"Selection",GetButtonState(isDisabled,true))

	-- isDisabled = this:HasObjVar("DisableWildernessConfirm")
	-- dynamicWindow:AddButton(28, 230, "DisableWildernessConfirm", "Disable unsafe portal confirmation window.", 400, 23, "", "", false,"Selection",GetButtonState(isDisabled,true))

	-- local yOffset = 262

	-- dynamicWindow:AddImage(20,yOffset+2,"Divider",480,0,"Sliced")

	-- dynamicWindow:AddLabel(265,yOffset+14,"Icon Legend",0,32,20,"center",false,true,"SpectralSC-SemiBold")
	
	-- dynamicWindow:AddImage(10,yOffset+40,"Aggressor")
	-- dynamicWindow:AddLabel(50,yOffset+40,"Victim: Can attack you with no karma loss.",122,80,18)

	-- dynamicWindow:AddImage(180,yOffset+40,"Aggressed")
	-- dynamicWindow:AddLabel(220,yOffset+40,"Aggressor: Can be attacked with no karma loss.",122,80,18)

	-- dynamicWindow:AddImage(350,yOffset+40,"OrderShieldIcon",32,32,"Sliced")
	-- dynamicWindow:AddLabel(390,yOffset+40,"Order: Can be attacked by chaotic with no karma loss.",122,80,18)

	-- dynamicWindow:AddLabel(265,yOffset+116,"Name Colors",0,32,20,"center",false,true,"SpectralSC-SemiBold")

	-- levelStr = ""
	-- for i,levelData in pairs(ServerSettings.Karma.Levels) do
	-- 	if not(levelData.Hidden) then
	-- 		levelStr = levelStr.."["..levelData.NameColor .. "]"..levelData.Name
	-- 		if(i ~= #levelData) then
	-- 			levelStr = levelStr.."    "
	-- 		end
	-- 	end
	-- end
	-- dynamicWindow:AddLabel(265,yOffset+142,levelStr,0,32,18,"center",false,true)

	-- this:OpenDynamicWindow(dynamicWindow)

	this:SystemMessage("That button does nothing.")
end

RegisterEventHandler(EventType.DynamicWindowResponse,"KarmaWindow",
	function (user, buttonId)
		if(buttonId:match("State")) then
			local alignment = buttonId:sub(7)
			local level, amount = GetKarmaLevelFromAlignmentName(alignment)
			local karma = GetKarma(user)
			if ( amount < 0 and karma > 0 ) then
				-- warn them they are about to lose ALL KARMA!
				-- Are you sure?
				ClientDialog.Show{
					TargetUser = user,
					DialogId = "KarmaDestroy",
					TitleStr = "Karma",
					DescStr = string.format("Choosing Chaotic alignment will surrender all positive karma and make you vulnerable to attack.\n\nAll of your positive karma (%s) will be removed and your Karma will become negative.", karma),
					Button1Str = "I Understand",
					Button2Str = "Cancel",
					ResponseObj = user,
					ResponseFunc = function( usr, buttonId )
						buttonId = tonumber(buttonId)
						if ( user == usr and buttonId == 0 ) then
							-- Are you super sure?
							ClientDialog.Show{
								TargetUser = user,
								DialogId = "KarmaDestroyConfirm",
								TitleStr = "Karma",
								DescStr = string.format("Do you truly wish to become Chaotic?", karma),
								Button1Str = "Yes",
								Button2Str = "No",
								ResponseObj = user,
								ResponseFunc = function( usr, buttonId )
									buttonId = tonumber(buttonId)
									if ( user == usr and buttonId == 0 ) then
										SetKarmaAlignment(user, level)
										user:SendClientMessage("SetKarmaState", alignment)
										user:SystemMessage(string.format("Karma Alignment set to %s.", alignment), "info")
										ShowKarmaWindow(user)
									end
								end,
							}
						end
					end,
				}
			else
				SetKarmaAlignment(user, level)
				user:SendClientMessage("SetKarmaState", alignment)
				user:SystemMessage(string.format("Karma Alignment set to %s.", alignment), "info")
				ShowKarmaWindow(user)
			end
		elseif(buttonId == "OrderOptIn") then
			local isDisabled = user:HasObjVar("ForceOrderOptIn")
			if(isDisabled) then
				user:DelObjVar("ForceOrderOptIn")
			else
				user:SetObjVar("ForceOrderOptIn",true)
			end
			ShowKarmaWindow(user)
		elseif(buttonId == "DisableWildernessConfirm") then
			local isDisabled = user:HasObjVar("DisableWildernessConfirm")
			if(isDisabled) then
				user:DelObjVar("DisableWildernessConfirm")
			else
				user:SetObjVar("DisableWildernessConfirm",true)
			end
			ShowKarmaWindow(user)
		elseif(buttonId == "" or buttonId == nil) then		
			CloseKarmaWindow()
		end
	end)

RegisterEventHandler(EventType.ModuleAttached,"karma_window",
	function ()
		ShowKarmaWindow()
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ()
		this:DelModule("karma_window")
	end)

RegisterEventHandler(EventType.Message,"UpdateKarmaWindow",
	function ()
		ShowKarmaWindow()
	end)

RegisterEventHandler(EventType.Message,"CloseKarmaWindow",
	function ()
		CloseKarmaWindow()
	end)