require 'scriptcommands'

local isGodWindowOpen = false
local commandArgs = ""

function GetCommandAction(commandInfo)
	tooltip = ""
	
	if( commandInfo.Desc ~= nil ) then
		tooltip = tooltip .. "[FACC2E]Description:[-] "..commandInfo.Desc .. "\n"
	end
	if(commandArgs ~= "") then
		tooltip = tooltip .. "[FACC2E]Args:[-] "..commandArgs
	elseif( commandInfo.Usage ~= nil ) then
		tooltip = tooltip .. "[FACC2E]Usage:[-] " .. commandInfo.Usage
	end

	-- DAB TODO: ENTERCHAT if takes arguments and none provided
	local serverCommand = "EnterChat " .. commandInfo.Command
	if(commandArgs ~= "") then
		serverCommand = commandInfo.Command .. " " .. commandArgs
	elseif(commandInfo.Usage == nil or commandInfo.Usage:sub(1,1) == "[") then
		serverCommand = commandInfo.Command
	end

	-- DAB TODO: Custom ID if uses custom arguments
	return {
		ID = commandInfo.Command,
		ActionType = "Command",
		DisplayName = commandInfo.Command,
		IconText = commandInfo.Command:sub(0,5),
		Enabled = true,
		Tooltip = tooltip,
		ServerCommand = serverCommand,
	}
end

function GetCommandElement(commandIndex,commandInfo)
	local scrollElement = ScrollElement()
	if(commandIndex % 2 == 1) then
		scrollElement:AddImage(0,0,"Blank",265,50,"Sliced","242400")
	end	
	
	scrollElement:AddUserAction(0,0,GetCommandAction(commandInfo))
	scrollElement:AddLabel(55,16,commandInfo.Command,0,0,18)

	--local skillName,minSkill = GetSkillRequirement(userAction)
	--if(skillName ~= "") then
	--	local minSkillStr = tostring(minSkill)
	--	local hasSkill = GetSkillLevel(this,skillName) >= minSkill
	--	if not(hasSkill) then
	--		minSkillStr = "[9C3D39]"..tostring(minSkill).."[-]"
	--	end
	--	scrollElement:AddLabel(262,6,"Min Skill: "..minSkillStr,150,0,18,"right")
	--	scrollElement:AddLabel(55,28,GetSkillDisplayName(skillName),150,0,18)
	--end

	--if not(hasAbility) then
	--	scrollElement:AddImage(0,0,"GreyOutImage",265,50,"Sliced","FFFFFF",50)
	--end

	return scrollElement
end

local selectedCommandCategoryIndex = 1
local selectedCommandCategory = "God Power"

function GetCommandCategories()
	local categories = { }

	for i,command in pairs(CommandList) do
		if(command.Category ~= nil and not(IsInTableArray(categories,command.Category))) then
			table.insert(categories,command.Category)
		end
	end

	return categories
end

function OpenGodCommandWindow()
	local dynWindow = DynamicWindow("GodCommandWindow","God Commands",342,600,-485,-365,"","Right")
	
	dynWindow:AddImage(40,12,"TitleBackground",250,20,"Sliced")
	dynWindow:AddButton(40,16,"CatLeft","",0,0,"","",false,"Previous")
	dynWindow:AddLabel(160,15,selectedCommandCategory,323,0,18,"center")
	dynWindow:AddButton(260,16,"CatRight","",0,0,"","",false,"Next")

	dynWindow:AddImage(8,40,"DropHeaderBackground",302,470,"Sliced")

	local scrollWindow = ScrollWindow(18,50,275,450,50)

	for i,commandInfo in pairs(CommandList) do 
		if((commandInfo.Category == selectedCommandCategory)
			and (commandInfo.AccessLevel ~= AccessLevel.Mortal)
			and LuaCheckAccessLevel(this,commandInfo.AccessLevel) )then
			scrollWindow:Add(GetCommandElement(i,commandInfo))
		end
	end

	dynWindow:AddScrollWindow(scrollWindow)

	dynWindow:AddLabel(20,520,"Args:",0,0,16)
	dynWindow:AddTextField(60,516,170,20,"Args",commandArgs)
	dynWindow:AddButton(230,510,"Args","Update",80,0,"","",false,"")

	isGodWindowOpen = true

	this:OpenDynamicWindow(dynWindow)
end

if(LuaCheckAccessLevel(this,AccessLevel.Immortal)) then
	RegisterEventHandler(EventType.ClientUserCommand,"EnterChat",
		function ( command )
			this:SendClientMessage("EnterChat","/" .. command .." ")
		end)

	RegisterEventHandler(EventType.ClientObjectCommand,"dropAction",
		function (user,sourceId,actionType,actionId,slot)
			if(sourceId == "GodCommandWindow" and slot ~= nil) then
				local commandInfo = GetCommandInfo(actionId)

				if(commandInfo ~= nil) then
					local commandAction = GetCommandAction(commandInfo)
					commandAction.Slot = tonumber(slot)
					AddUserActionToSlot(commandAction)
				end
			end
		end)

	RegisterEventHandler(EventType.DynamicWindowResponse, "GodCommandWindow",
		function(user,buttonId,fieldData)
			if(buttonId == "CatLeft") then
				local commandCategories = GetCommandCategories()
				selectedCommandCategoryIndex = ((selectedCommandCategoryIndex - 2) % #commandCategories) + 1
				selectedCommandCategory = commandCategories[selectedCommandCategoryIndex]
				OpenGodCommandWindow()
			elseif(buttonId == "CatRight") then
				local commandCategories = GetCommandCategories()
				selectedCommandCategoryIndex = (selectedCommandCategoryIndex % #commandCategories) + 1
				selectedCommandCategory = commandCategories[selectedCommandCategoryIndex]
				OpenGodCommandWindow()
			elseif(buttonId == "Args") then
				commandArgs = fieldData.Args
				OpenGodCommandWindow()
			else
				isGodWindowOpen = false
			end
		end)

	RegisterEventHandler(EventType.ClientUserCommand, "ToggleGodWindow",
		function (...)
			if(isGodWindowOpen) then
				this:CloseDynamicWindow("OpenGodCommandWindow")
				isGodWindowOpen = false
			else
				OpenGodCommandWindow()
			end
		end)
end