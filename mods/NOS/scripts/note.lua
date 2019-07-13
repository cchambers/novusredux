
TEXT_PER_LINE = 55
MAX_RETURNS = 22
MAX_TEXT_PER_PAGE = TEXT_PER_LINE*MAX_RETURNS
MAX_WORD_LENGTH = 11
WRITING_ANIMATION = "fishreel"

if (initializer ~= nil) then
	--DebugMessage(initializer.Text)
	this:SetObjVar("ScrollContents",initializer.Text)
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
	local window = DynamicWindow("NoteDialog",StripColorFromString(this:GetName()),545,751,-300,-300,"Transparent","Center")
	window:AddButton(498,28,"","",46,28,"","",true,"ScrollClose")
	local text = this:GetObjVar("ScrollContents") or ""
	local indexes = CalcLines(text)
	text = GetCurrentPageText(user,indexes,line)
	window:AddImage(-60,-60,"ScrollParchmentUIWindow",0,0)
	window:AddLabel(60,80,text,430,515,20,"left",false,false,"Kingthings_18")
	if (line > 1) then
		window:AddButton(10 ,585,"Decrease","",0,0,"","",false,"OrnateLeft")
	end
	if (line + MAX_RETURNS < #indexes) then
		window:AddButton(420,585,"Increase","",0,0,"","",false,"OrnateRight")
	end

	user:OpenDynamicWindow(window,this)	
end

RegisterEventHandler(EventType.DynamicWindowResponse, "NoteDialog",
	function (user,buttonId)
		--DebugMessage("Returning")
		local text = this:GetObjVar("ScrollContents")
		if (text == nil) then return end
		local indexes = CalcLines(text)
		line = user:GetObjVar("Line") or 1
		if (buttonId == "Increase") then
			line = line + MAX_RETURNS + 1
			user:SetObjVar("Line",line)
			ShowContents(user,line)
			return
		elseif (buttonId == "Decrease") then
			line = line - MAX_RETURNS - 1
			user:SetObjVar("Line",line)
			ShowContents(user,line)
			return
		end
	end)


RegisterEventHandler(EventType.Message, "UseObject",
	function (user,usedType)
		--DebugMessage("Start here, usedType is "..tostring(usedType))
		if(usedType ~= "Use" and (usedType ~= "Examine" and usedType ~= "Write")) then return end
		if (usedType == "Write") then
			if (this:TopmostContainer() ~= user) then
				user:SystemMessage("[$1947]","info")
				return
			end
			--DebugMessage("Attempt to open the dialog.")
			OpenWriteDialog(user)
			return
		end

		if this:HasObjVar("AnotherLanguage") then 
			user:SystemMessage("[$1950]","info")
			return
		end
		user:SetObjVar("Line",1)
		ShowContents(user,1)
	end)

function OpenWriteDialog(user)
	local newWindow = DynamicWindow("WriteNoteWindow","Write Note",400,620,200,200,"Default","TopLeft")

	local currentContents = this:GetObjVar("ScrollContents")

	local x = 30

	newWindow:AddTextField(x, 15, 320,140+140+150+150, "WritingContents", currentContents)
	
	newWindow:AddButton(x, 526, "Write", "Write", 150, 0, "", "", false)
	newWindow:AddButton(x+170, 526, "Cancel", "Cancel", 150, 0, "", "", true)
	--newWindow:AddButton(x, y, "CancelImprovement", "Cancel", 200, 0, "Stop Attempting to Improve the item.", "", false)
	user:OpenDynamicWindow(newWindow,this)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"WriteNoteWindow",function (user,buttonId,contents)
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
		user:SystemMessage("You write the note.","info")
		user:CloseDynamicWindow("WriteNoteWindow")
		user:PlayAnimation(WRITING_ANIMATION)	
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
			this:SystemMessage("You finish writing the note.","info")
			this:SendMessage("WriteNote",contents.WritingContents)
		end)
	end
end)


RegisterEventHandler(EventType.Message, "DecipherReadObject", 
	function (user)
        --DebugMessage("Message received in tablet")
		ShowContents(user,1)
	end)


RegisterEventHandler(EventType.Message,"WriteNote",
	function(contents)
		this:SetObjVar("ScrollContents",contents)
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, "note", 
    function ()
         SetTooltipEntry(this,"idol", "Perhaps you should inspect this item further.")
         if (this:HasObjVar("Rewriteable")) then
         	AddUseCase(this,"Write",false)
         	--AddUseCase(this,"Add Map Marker",false)
         end
         AddUseCase(this,"Examine",true)
    end)