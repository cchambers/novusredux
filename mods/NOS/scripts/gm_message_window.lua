
function CloseGmMessageWindow()
	this:CloseDynamicWindow("GmMessageWindow")
	this:DelModule("gm_message_window")
end

function ShowGmMessageWindow(userId, MessageTitle, MessageContent)
	local newWindow = DynamicWindow("GmMessageWindow","GM Message",460,500,-300,-280,"Default","Center")

	local x = 20

	local GmMessageUserId = userId or ""
	--Title has a default title but can be changed
	local GmMessageTitle = MessageTitle or "NOTICE"
	local GmMessageContent = MessageContent or ""

	newWindow:AddLabel(x,10,"User Id:",0,0,20)
	newWindow:AddTextField(100, 10, 200,20, "GmMessageUserId", GmMessageUserId)
	newWindow:AddLabel(x,40,"Title:",0,0,20)
	newWindow:AddTextField(100, 40, 200, 20, "GmMessageTitle", GmMessageTitle)
	newWindow:AddLabel(x,70,"Message:",0,0,20)
	newWindow:AddTextField(x, 100, 400, 300, "GmMessageField", GmMessageContent)

	newWindow:AddButton(x + 300, 10, "SelectPlayer", "Select", 100, 23, "", "", false)

	newWindow:AddButton(x+190, 415, "SendMessage", "Submit", 100, 23, "", "", false)
	newWindow:AddButton(x+300, 415, "CloseWindow", "Cancel", 100, 23, "", "")

	this:OpenDynamicWindow(newWindow,this)
end

function HandleGmMessageWindowResponse(user,buttonId, gmMessageField)
	if (buttonId == "SendMessage") then
		if (gmMessageField.GmMessageUserId == nil or gmMessageField.GmMessageUserId == "") then
			user:SystemMessage("UserId cannot be empty.")
			return
		end

		if (gmMessageField.GmMessageTitle == nil or gmMessageField.GmMessageTitle == "") then
			user:SystemMessage("Title cannot be empty.")
			return
		end

		if (gmMessageField.GmMessageField == nil or gmMessageField.GmMessageField == "") then
			user:SystemMessage("Message cannot be empty.")
			return
		end

		local globalVarKey = "AccountMessages."..gmMessageField.GmMessageUserId

		local messageContent = {}
		messageContent.Title = gmMessageField.GmMessageTitle
		messageContent.Message = gmMessageField.GmMessageField

		SetGlobalVar(globalVarKey, function(record)
			table.insert(record,messageContent)
			return true
		end)

		--Show GM system message and a window that would be shown to the user
		this:SystemMessage("GM message sent to "..gmMessageField.GmMessageUserId)
		this:SystemMessage("Showing the copy of the GM message sent")

		ClientDialog.Show {
	        TargetUser = this,
	        TitleStr = messageContent.Title,
	        DescStr = messageContent.Message,
	        Button1Str = "Acknowledged",
	    }

		CloseGmMessageWindow()
	elseif (buttonId == "SelectPlayer") then
		this:RequestClientTargetGameObj(this, "select_player")
		RegisterSingleEventHandler(EventType.ClientTargetGameObjResponse,"select_player", 
			function(target)
				HandleSelectPlayer(target, gmMessageField.GmMessageTitle, gmMessageField.GmMessageField)
			end)
	elseif (buttonId == "CloseWindow" or buttonId == "") then
		CloseGmMessageWindow()
	end
end

RegisterEventHandler(EventType.DynamicWindowResponse,"GmMessageWindow",HandleGmMessageWindowResponse)

function HandleSelectPlayer(target, messageTitle, messageContent)
	if not (target:IsPlayer()) then
		this:SystemMessage("Target must be a player")
		return
	end
	local userId = target:GetAttachedUserId()
	ShowGmMessageWindow(userId, messageTitle, messageContent)
end

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ()
		this:DelModule("gm_message_window")
	end)

ShowGmMessageWindow()