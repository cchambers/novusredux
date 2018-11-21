BOOK_WIDTH = 789
BOOK_HEIGHT = 455

TEXT_PER_LINE = 40
MAX_RETURNS = 11
MAX_TEXT_PER_PAGE = TEXT_PER_LINE*MAX_RETURNS
MAX_WORD_LENGTH = 11
WRITING_ANIMATION = "fishreel"

if (initializer ~= nil) then
	--DebugMessage(initializer.Text)
	this:SetObjVar("BookContents",initializer.Text)
end

function GetCurrentPageText(user,lines,lineNumb)
	local resultText = ""
	local textColor = this:GetObjVar("TextColor") or "[000000]"
	for i=lineNumb,#lines,1 do
		if (lines[i] == "\n") then
			resultText = resultText.."\n"
		elseif ( lines[i] ~= nil ) then
			resultText = resultText ..lines[i]
		end
		if (i >= lineNumb + MAX_RETURNS) then
			break
		end
	end
	return textColor ..resultText.."[-]"
end

function CalcLines(text)
	local lines = {}
	local lengthOfString = string.len(text)
	local i = 1
	local charCount = 1
	local line = ""
	while i < lengthOfString or i < MAX_TEXT_PER_PAGE do
		local char = string.sub(text,i,i)
		line = line .. char
		if (charCount > TEXT_PER_LINE or char == "\n" or ((char == " " or char == "-"  or char == "," or char == ".") and charCount + MAX_WORD_LENGTH > TEXT_PER_LINE)) then
			if (char ~= "\n") then
				line = line .."\n"
			end
			--DebugMessage(line)
			table.insert(lines,line)
			charCount = 0
			line = ""
		end
		charCount = charCount + 1
		i = i + 1
	end
	local char = string.sub(text,i,i)
	line = line .. char
	table.insert(lines,line)
	return lines
end

function ShowContents(user,line)
	local dynamicWindow = DynamicWindow(
		"Book", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
		"", --(string) Title of the window for the client UI
		BOOK_WIDTH, --(number) Width of the window
		BOOK_HEIGHT, --(number) Height of the window
		-BOOK_WIDTH/2, --startX, --(number) Starting X position of the window (chosen by client if not specified)
		-BOOK_HEIGHT/2, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
		"TransparentDraggable",--windowType, --(string) Window type (optional)
		"Center" --windowAnchor --(string) Window anchor (default "TopLeft")
	)

	dynamicWindow:AddImage(
		0, --(number) x position in pixels on the window
		0, --(number) y position in pixels on the window
		"Spellbook", --(string) sprite name
		BOOK_WIDTH, --(number) width of the image
		BOOK_HEIGHT --(number) height of the image
		--spriteType, --(string) sprite type Simple, Sliced or Object (defaults to Simple)
		--spriteHue, --(string) sprite hue (defaults to white)
		--opacity --(number) (default 1.0)		
	)

	local text = this:GetObjVar("BookContents") or ""
	local indexes = CalcLines(text)
	local page1text = GetCurrentPageText(user,indexes,line)
	local p2line = line + MAX_RETURNS + 1
	local page2text = GetCurrentPageText(user,indexes,p2line)

	if (line > 1) then
		dynamicWindow:AddButton(
				60, --(number) x position in pixels on the window
				24, --(number) y position in pixels on the window
				"Decrease", --(string) return id used in the DynamicWindowResponse event
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
	if (p2line + MAX_RETURNS < #indexes) then
		dynamicWindow:AddButton(
				574, --(number) x position in pixels on the window
				24, --(number) y position in pixels on the window
				"Increase", --(string) return id used in the DynamicWindowResponse event
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

	dynamicWindow:AddLabel(
			110, --(number) x position in pixels on the window
			60, --(number) y position in pixels on the window
			page1text, --(string) text in the label
			0, --(number) width of the text for wrapping purposes (defaults to width of text)
			0, --(number) height of the label (defaults to unlimited, text is not clipped)
			28, --(number) font size (default specific to client)
			"left", --(string) alignment "left", "center", or "right" (default "left")
			false, --(boolean) scrollable (default false)
			false, --(boolean) outline (defaults to false)
			"Kingthings_Calligraphica_Dynamic" --(string) name of font on client (optional)			
		)

	dynamicWindow:AddLabel(
			436, --(number) x position in pixels on the window
			60, --(number) y position in pixels on the window
			page2text, --(string) text in the label
			0, --(number) width of the text for wrapping purposes (defaults to width of text)
			0, --(number) height of the label (defaults to unlimited, text is not clipped)
			28, --(number) font size (default specific to client)
			"left", --(string) alignment "left", "center", or "right" (default "left")
			false, --(boolean) scrollable (default false)
			false, --(boolean) outline (defaults to false)
			"Kingthings_Calligraphica_Dynamic" --(string) name of font on client (optional)			
		)

	--[[window:AddButton(498,28,"","",46,28,"","",true,"ScrollClose")
	
	local indexes = CalcLines(text)
	text = GetCurrentPageText(user,indexes,line)
	window:AddImage(-60,-60,"ScrollParchmentUIWindow",0,0)
	window:AddLabel(60,80,text,430,515,20,"left",false,false,"Kingthings_18")
	if (line > 1) then
		window:AddButton(10 ,585,"Decrease","",0,0,"","",false,"OrnateLeft")
	end
	if (line + MAX_RETURNS < #indexes) then
		window:AddButton(420,585,"Increase","",0,0,"","",false,"OrnateRight")
	end]]

	user:OpenDynamicWindow(dynamicWindow,this)	
end

RegisterEventHandler(EventType.DynamicWindowResponse, "Book",
	function (user,buttonId)
		--DebugMessage("Returning")
		local text = this:GetObjVar("BookContents")
		if (text == nil) then return end
		local indexes = CalcLines(text)
		line = user:GetObjVar("Line") or 1
		if (buttonId == "Increase") then
			line = line + (MAX_RETURNS + 1)*2
			user:SetObjVar("Line",line)
			ShowContents(user,line)
			return
		elseif (buttonId == "Decrease") then
			line = line - (MAX_RETURNS + 1)*2
			user:SetObjVar("Line",line)
			ShowContents(user,line)
			return
		end
	end)


RegisterEventHandler(EventType.Message, "UseObject",
	function (user,usedType)
		--DebugMessage("Start here, usedType is "..tostring(usedType))
		if(usedType ~= "Use" and (usedType ~= "Examine" and usedType ~= "Write" and usedType ~= "Rename")) then return end
		if (usedType == "Write") then
			if (this:TopmostContainer() ~= user) then
				user:SystemMessage("[$1947]")
				return
			end
			--DebugMessage("Attempt to open the dialog.")
			OpenWriteDialog(user)
			return
		elseif(usedType == "Rename") then
			RenameBook(user)
			return
		end

		if this:HasObjVar("AnotherLanguage") then 
			user:SystemMessage("[$1950]")
			return
		end
		user:SetObjVar("Line",1)
		ShowContents(user,1)
	end)

function RenameBook(user)
	TextFieldDialog.Show{
        TargetUser = user,
        ResponseObj = this,
        Title = "Rename Book",
        DialogId = "Rename Book",
        Description = "Enter the name of the book.",
        ResponseFunc = function(user,newName)
        	if(newName ~= nil and newName ~= "") then

        		if (string.len(newName) > 25) then
			 		user:SystemMessage("The book name must be less than 26 characters.")
			 		return
			 	end

        		if(ServerSettings.Misc.EnforceBadWordFilter and HasBadWords(newName)) then
    		 		user:SystemMessage("Book name can not contain any foul language!")
    		 		return
    		 	end

    		 	local strippedName, color = StripColorFromString(this:GetName())
		   		if not(color) then
				   	this:SetName(newName)
				else
					this:SetName(color .. newName .. "[-]")
				end
	        end
        end
    }            
end

function OpenWriteDialog(user)
	local newWindow = DynamicWindow("WriteBookWindow","Write Book",400,620,200,200,"Default","TopLeft")

	local currentContents = this:GetObjVar("BookContents")

	local x = 30

	newWindow:AddTextField(x, 15, 320,140+140+150+150, "WritingContents", currentContents)
	
	newWindow:AddButton(x, 526, "Write", "Write", 150, 0, "", "", false)
	newWindow:AddButton(x+170, 526, "Cancel", "Cancel", 150, 0, "", "", true)
	--newWindow:AddButton(x, y, "CancelImprovement", "Cancel", 200, 0, "Stop Attempting to Improve the item.", "", false)
	user:OpenDynamicWindow(newWindow,this)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"WriteBookWindow",function (user,buttonId,contents)
	if (user == nil or not user:IsValid()) then
		return
	end
	if (buttonId == "Cancel") then
		return
	end
	if (buttonId == "Write") then
		local badWord = GetBadWord(contents.WritingContents)
		if (ServerSettings.Misc.EnforceBadWordFilter and badWord ~= nil) then
			user:SystemMessage("[$1951]"..badWord)
			return
		end
		local writeTime = math.min(5000,math.max(1000,contents.WritingContents:len()*4 + 1))
		--DebugMessage("Write time is "..tostring(writeTime))
		user:SystemMessage("You write the book.")
		user:CloseDynamicWindow("WriteBookWindow")
		--user:PlayAnimation(WRITING_ANIMATION)	
		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(writeTime),"PreventExamine")
		SetMobileModExpire(user, "Disable", "Writing", true, TimeSpan.FromMilliseconds(writeTime))
		ProgressBar.Show
		{
			Label="Writing",
			Duration=(writeTime/1000),
			TargetUser = user,
			PresetLocation="AboveHotbar",
			CanCancel = false,
		}
		CallFunctionDelayed(TimeSpan.FromMilliseconds(writeTime),function()
			user:PlayAnimation("idle")
			this:SystemMessage("You finish writing the book.")
			this:SendMessage("WriteBook",contents.WritingContents)
		end)
	end
end)


RegisterEventHandler(EventType.Message, "DecipherReadObject", 
	function (user)
        --DebugMessage("Message received in tablet")
		ShowContents(user,1)
	end)


RegisterEventHandler(EventType.Message,"WriteBook",
	function(contents)
		this:SetObjVar("BookContents",contents)
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, "book", 
    function ()
         SetTooltipEntry(this,"idol", "Perhaps you should inspect this item further.")
         if (this:HasObjVar("Rewriteable")) then
         	AddUseCase(this,"Write",false)
         	AddUseCase(this,"Rename",false)
         	--AddUseCase(this,"Add Map Marker",false)
         end
         AddUseCase(this,"Examine",true)
    end)

RegisterSingleEventHandler(EventType.LoadedFromBackup,"",
	function ()
		if this:HasObjVar("Rewriteable") and not (HasUseCase(this, "Rename")) then
			AddUseCase(this,"Rename",false)
		end
	end)