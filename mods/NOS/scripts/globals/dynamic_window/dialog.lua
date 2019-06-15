ClientDialog = {}

function ClientDialog.Show(args)
	args.TargetUser = args.TargetUser
	args.ResponseObj = args.ResponseObj or args.TargetUser
	args.DialogId = args.DialogId or ("Dialog"..uuid())
	args.TitleStr = args.TitleStr or ""
	args.DescStr = args.DescStr or ""
	args.Height = args.Height or 240

	-- if neither button is set, then use the default confirm, cancel
	if( not(args.Button1Str) and not(args.Button2Str) ) then
		args.Button1Str = "Confirm"
		args.Button2Str = "Cancel"
	else
		args.Button1Str = args.Button1Str or "Ok"
	end

	local newWindow = DynamicWindow(args.DialogId,args.TitleStr,442,args.Height,200,200,"","TopLeft")

	local x = 20
	local y = args.Height - 90

	newWindow:AddLabel( x, 10, args.DescStr, 400,131,18,"",true)
	
	if(args.Button2Str) then
		newWindow:AddButton(x+110, y, "0", args.Button1Str, 130, 0, "", "", true)
		newWindow:AddButton(x+250, y, "1", args.Button2Str, 130, 0, "", "", true)
	else
		newWindow:AddButton(x+250, y, "0", args.Button1Str, 130, 0, "", "", true)
	end

	--newWindow:AddButton(x, y, "CancelImprovement", "Cancel", 200, 0, "Stop Attempting to Improve the item.", "", false)
	args.TargetUser:OpenDynamicWindow(newWindow,args.ResponseObj)

	if(args.ResponseFunc ~= nil) then
		RegisterSingleEventHandler(EventType.DynamicWindowResponse,args.DialogId,
			function(user,buttonId)
				args.ResponseFunc(user,tonumber(buttonId))
			end)
	end
end

-- sends nil to response func if user cancelled
TextFieldDialog = {}
function TextFieldDialog.Show(args)
	args.TargetUser = args.TargetUser
	args.ResponseObj = args.ResponseObj or args.TargetUser
	args.DialogId = args.DialogId or ("TextEntry"..uuid())
	args.Title = args.Title or "Enter Text"
	args.Width = args.Width or 400
	args.Description = args.Description or "Enter your text here:"
	args.ButtonStr = args.ButtonStr or "Enter"

	local height = 80
	if(args.Description ~= "") then
		height = 120
	end
	local newWindow = DynamicWindow(args.DialogId,args.Title,args.Width+130,height)

	local curY = 10
	if(args.Description ~= "") then
		newWindow:AddLabel(16,curY,args.Description,0,0,16)
		curY = curY + 20
	end
	newWindow:AddTextField(15,curY + 4,args.Width,20,"entry")
    newWindow:AddButton(args.Width + 25, curY, "Enter", args.ButtonStr)  

    args.TargetUser:OpenDynamicWindow(newWindow,args.ResponseObj)
    if(args.ResponseFunc ~= nil) then
    	RegisterSingleEventHandler(EventType.DynamicWindowResponse,args.DialogId,
			function(user,buttonId,fieldData)
				if(buttonId == "Enter") then
					args.ResponseFunc(user,fieldData.entry)
				else
					args.ResponseFunc(user)
				end
			end)
	end
end

ButtonMenu = {}
function ButtonMenu.Show(args)
	if(args.Buttons == nil or #args.Buttons == 0
			or args.TargetUser == nil or not(args.TargetUser:IsValid())) then 
		DebugMessage("ERROR: Invalid ButtonMenu arguments see ButtonMenu.Show in incl_dialogwindow.lua")
		return
	end

	if(not(args.TargetUser:IsPlayer())) then
		DebugMessage("ERROR: Sending ButtonMenu to NPC. NPCs cannot pick buttons!")
		return
	end

	args.ResponseObj = args.ResponseObj or args.TargetUser		

	local dialogId = args.DialogId or "ButtonMenu"
	local titleStr = args.TitleStr or ""
	-- can be index or str
	local responseType = args.ResponseType or "index"	
	local numButtons = #args.Buttons
	local size = args.Size or 200
	
	local closeOnClick = true
	if(args.CloseOnClick == false) then closeOnClick = false end

	local yPadding = 70
	if(args.SubtitleStr) then
		yPadding = yPadding + 20
	end

	if(numButtons <= 6) then
		local newWindow = DynamicWindow(dialogId,titleStr,size+42,yPadding + (numButtons*26),0,0,"")

		local startY = 5
		if(args.SubtitleStr) then
			newWindow:AddLabel((size+20)/2,4,args.SubtitleStr,size,20,20,"center")
			startY = startY + 20
		end
		
		for i,buttonData in pairs(args.Buttons) do
			local yVal = startY + (i-1)*26
			local buttonId = tostring(i)
			local buttonStr = buttonData
			local tooltipStr = ""
			if(responseType == "str") then
				buttonId = buttonData
				buttonStr = buttonData
			elseif(responseType == "id") then
				buttonId = buttonData.Id
				buttonStr = buttonData.Text
				buttonTooltip = buttonData.Tooltip or ""
			end
			newWindow:AddButton(10, yVal, buttonId, buttonStr, size, 26, buttonTooltip, "", closeOnClick,"List")
		end
		args.TargetUser:OpenDynamicWindow(newWindow,args.ResponseObj)
	else
		local newWindow = DynamicWindow(dialogId,titleStr,size+42,yPadding + (6*26),0,0,"")
		local startY = 10
		if(args.SubtitleStr) then
			newWindow:AddLabel((size+20)/2,4,args.SubtitleStr,size,20,20,"center")
			startY = startY + 20
		end

		local scrollWindow = ScrollWindow(10,startY,size,156,26)
		for i,buttonData in pairs(args.Buttons) do
			local scrollElement = ScrollElement()
			local buttonId = tostring(i)
			local buttonStr = buttonData
			local tooltipStr = ""
			if(responseType == "str") then
				buttonId = buttonData
				buttonStr = buttonData
			elseif(responseType == "id") then
				buttonId = buttonData.Id
				buttonStr = buttonData.Text
				buttonTooltip = buttonData.Tooltip or ""
			end
			scrollElement:AddButton(0, 0, buttonId, buttonStr, size-10, 26, buttonTooltip, "", closeOnClick,"List")
			scrollWindow:Add(scrollElement)
		end
		newWindow:AddScrollWindow(scrollWindow)
		args.TargetUser:OpenDynamicWindow(newWindow,args.ResponseObj)
	end	

	if(args.ResponseFunc ~= nil) then
		RegisterSingleEventHandler(EventType.DynamicWindowResponse,dialogId,
			function(user,buttonId)
				local response = buttonId
				if(responseType == "index") then
					response = tonumber(buttonId)
				end
				args.ResponseFunc(user,response)
			end)
	end
end

-- Args table
--     Anchor (Window Anchor) (Default Center)
-- 	   X (Default 0)
--     Y (Default -100)
--     Width (Default 200)
--     Label: Label text (Default empty)
--     BarColor (Default C45E05 - Orange)
--     Duration: Duration in seconds (Default 1)
--     TargetUser: Target user to show window 
--     DialogId: Id of window (must be unique to have more than one at the same time. Default Label)
--     PresetLocation: Currently supported "UnderPlayer" (default) and "AboveHotbar"
-- NOTE: Height is not yet supported for the progress bar widget
ProgressBar = {}
function ProgressBar.Show(args)
	--DebugMessage("ProgressBar.Show",DumpTable(args))
	args = args or {}
	args.Anchor = args.Anchor or "Center"
	args.X = args.X or 0
	args.Y = args.Y or 100
	args.Width = args.Width or 200
	args.Label = args.Label or ""
	args.BarColor = args.BarColor or ""
	args.Duration = args.Duration or TimeSpan.FromSeconds(1.0)
	if(type(args.Duration) == "number") then
		args.Duration = TimeSpan.FromSeconds(args.Duration)
	end
	args.DialogId = args.DialogId or args.Label
	args.TargetUser = args.TargetUser
	args.SourceObject = args.SourceObject or args.TargetUser
	args.CanCancel = args.CanCancel or false

	if(args.PresetLocation == "UnderPlayer") then
		args.Anchor = "Center"
		args.X = 0
		args.Y = 100
	elseif(args.PresetLocation == "AboveHotbar") then
		args.Anchor = "Bottom"
		args.X = 0
		args.Y = -170
	end

	local progressBarWidth = args.Width
	if(args.CanCancel) then 
		progressBarWidth = progressBarWidth - 44 
	end

	local newWindow = DynamicWindow(args.DialogId,"",0,0,0,0,"Transparent",args.Anchor)	
	newWindow:AddProgressBar(args.X,args.Y,progressBarWidth,0,args.Label,args.Duration.TotalSeconds,true,args.BarColor)
	if(args.CanCancel) then
		newWindow:AddButton(args.Width/2 - 22,args.Y - 11,"Close","",22,22,"","",true,"CloseSquare")
	end

	args.TargetUser:OpenDynamicWindow(newWindow,args.SourceObject)

	RegisterSingleEventHandler(EventType.Timer,args.DialogId.."Close",
		function()
			args.TargetUser:CloseDynamicWindow(args.DialogId)
		end)

	if(args.CancelFunc) then
		RegisterSingleEventHandler(EventType.DynamicWindowResponse,args.DialogId,
			function(user,buttonId)
				if(buttonId == "Close") then
					args.CancelFunc(args.DialogId)
				end
			end)
	end

	args.SourceObject:ScheduleTimerDelay(args.Duration,args.DialogId.."Close")
end

function ProgressBar.Cancel(dialogId,user)
	--DebugMessage("ProgressBar.Cancel",tostring(dialogId),tostring(user))
	user = user or this
	user:CloseDynamicWindow(dialogId)
end

--DFB NOTE: DEPRECATED
function NPCInteractionLongButton(text,npc,user,windowHandle,responses,width,height,max_distance)
	local title = ""
	if (npc ~= nil) then
		title = npc:GetName()
	end
	NPCInteraction(text,npc,user,windowHandle,responses,title,max_distance)
end

function NPCInteraction(text,npc,user,windowHandle,responses,title,max_distance)
	if (user == nil) then
		--DebugMessage("invalid user")
		return
	end

	local userType = GetValueType(user)
	if(userType ~= "GameObj") then
		LuaDebugCallStack("ERROR: User parameter is of wrong type: "..userType)
		return
	end

	if(not user:IsValid()) then
		return
	end

	if (npc ~= nil and IsDead(npc) and not npc:HasObjVar("UseableWhileDead")) then 
		--DebugMessage("dead npc or user")
		return
	end

	max_distance = max_distance or OBJECT_INTERACTION_RANGE
	if (type(max_distance) == "string") then max_distance = OBJECT_INTERACTION_RANGE end
	if (npc ~= nil and (max_distance >= 0 and npc:DistanceFrom(user) > max_distance)) then
		--LuaDebugCallStack("ERROR: NPCInteraction sent for mob out of range: "..max_distance)
		return 
	end

	if(npc ~= nil) then
		npc:SendMessage("WakeUp")
	end

	if((title == nil or type(title) ~= "string") and npc ~= nil) then
		title = npc:GetName()
	end
	--DebugMessage("Title is "..tostring(title))
	width = 877
	height = 200 
	local npcWindow = DynamicWindow(windowHandle,"",width,height,-(width/2),-280,"Transparent","Bottom")
	npcWindow:AddButton(860,28,"","",46,28,"","",true,"ScrollClose")
	npcWindow:AddImage(0,0,"ConversationWindow_BG")

	npcWindow:AddLabel(40,24,"[433518]"..StripColorFromString(title):upper(),0,0,24,"left",false,false,"PermianSlabSerif_Dynamic_Bold")
	npcWindow:AddLabel(40,50,"[433518]"..text,440,120,20,"left",true,false,"PermianSlabSerif_Dynamic_Bold")

	if (responses == nil) then
		responses = {}
		responses[1] = {}
		responses[1].handle = "Close"
		responses[1].text = "Okay."
	end

	local k = 1
	local curY = 24
	if (type(responses) == "string") then
		LuaDebugCallStack("[incl_dialogwindow] responses is a string value")
	end
	for i,j in pairs(responses) do
		if (responses[i] ~= nil) then				
			local closeOnClick = not(j.handle) or j.handle == "" or j.handle == "Close" or j.close ~= nil

			if (k==1) then				
				npcWindow:AddButton(506,curY,j.handle,j.text,245,20,"","",closeOnClick,"ScrollSelection")
			end
			if (k==2) then
				npcWindow:AddButton(506,curY,j.handle,j.text,245,20,"","",closeOnClick,"ScrollSelection")
			end
			if (k==3) then
				npcWindow:AddButton(506,curY,j.handle,j.text,245,20,"","",closeOnClick,"ScrollSelection")
			end
			if (k==4) then
				npcWindow:AddButton(506,curY,j.handle,j.text,245,20,"","",closeOnClick,"ScrollSelection")
			end
			if (k==5) then
				npcWindow:AddButton(506,curY,j.handle,j.text,245,20,"","",closeOnClick,"ScrollSelection")
			end
			if (k==6) then
				npcWindow:AddButton(506,curY,j.handle,j.text,245,20,"","",closeOnClick,"ScrollSelection")
			end

			curY = curY + 26
			k = k + 1
		end
	end
	--DebugMessage("User is "..tostring(user:GetName()))
	user:OpenDynamicWindow(npcWindow,npc)	
	--DebugMessage("Window Opened")

	if (npc ~= nil) then
		user:SendMessage("DynamicWindowRangeCheck",npc,windowHandle,max_distance)
	end
end

function TaskDialogNotification(user,text,title)
 	NPCInteraction(text,nil,user,"Responses",nil,nil,title)
end

function QuickDialogMessage(source,user,text,max_distance)
	--DebugMessage("Text is " ..text,"User is" ..tostring(user))
	NPCInteraction(text,source,user,"Responses",nil,source:GetName(),max_distance,true)
end

function DialogReturnMessage(source,user,text,button)
    response = {}

    response[1] = {}
    response[1].text = button
    response[1].handle = "Nevermind" 

    NPCInteraction(text,source,user,"Responses",response)
end

function DialogEndMessage(source,user,text,button)
    response = {}

    response[1] = {}
    response[1].text = button
    response[1].handle = "" 

    NPCInteraction(text,source,user,"Responses",response)
end