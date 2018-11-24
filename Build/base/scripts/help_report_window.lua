HELP_REPORT_DISABLED = false

helpReportStartingText = "[$3376]"

helpWindowType = nil
harassmentTarget = nil
requestingTarget = false
successfulSubmission = false

function CloseHelpReportWindow()
	this:CloseDynamicWindow("HelpReportWindow")
	this:DelModule("help_report_window")
end

function ShowHelpReportWindow()
	if (HELP_REPORT_DISABLED) then
		this:SystemMessage("Help reporting temporarily disabled.","info")
		return
	end
	local newWindow = DynamicWindow("HelpReportWindow","Help Report",600,560,-300,-280,"Default","Center")

	local x = 20
	local y = 460

	newWindow:AddLabel(x,10,"What type of issue are you experiencing?",0,0,20)

	--newWindow:AddButton(x+20, 40, "Type|play", "I need help playing the game.", 100, 23, "", "", false,"Selection",GetButtonState(helpWindowType,"play"))
	newWindow:AddButton(x+20, 40, "Type|help", "I need in-game assistance.", 100, 23, "I'm experiencing a game breaking issue that can only be solved by a gamemaster.", "", false,"Selection",GetButtonState(helpWindowType,"help"))
	newWindow:AddButton(x+20, 70, "Type|harassment", "I'm being harassed.", 100, 23, "I have asked this person to stop their harassment and they refuse.", "", false,"Selection",GetButtonState(helpWindowType,"harassment"))

	if(helpWindowType=="harassment") then
		newWindow:AddLabel(x+80,130,"I'm being harassed by: ",0,0,19)
		if not(harassmentTarget) then
			newWindow:AddButton(x+236, 126, "HarassmentTarget", "Select Target", 100, 23, "[$3378]", "")			
		else
			newWindow:AddLabel(x+236,130,harassmentTarget.Name .. " ("..harassmentTarget.Id..")",0,0,19)
		end
	end

	newWindow:AddTextField(x, 160, 540,280, "HelpReportMessage", helpReportStartingText)
	
	newWindow:AddButton(410, y, "Submit", "Submit", 150, 0, "", "", true)
	newWindow:AddButton(x+230, y, "Cancel", "Cancel", 150, 0, "", "", true)
	--newWindow:AddButton(x, y, "CancelImprovement", "Cancel", 200, 0, "Stop Attempting to Improve the item.", "", false)
	this:OpenDynamicWindow(newWindow,this)
end

function HandleHelpReportWindowResponse(user,buttonId,helpReportField)	
	--DebugMessage("HandleHelpReportWindowResponse",tostring(buttonId))
	if (successfulSubmission) then return end
	if ( buttonId == "Submit" ) then
		if ( helpReportField.HelpReportMessage == "" or helpReportField.HelpReportMessage == helpReportStartingText ) then
			this:SystemMessage("Please provide more detail in your report.","info")
			return
		end
		
		local body = "User Message:\n" .. helpReportField.HelpReportMessage .. "\n\n" .. BuildReportData()

		--DebugMessage(body)

		SendEmail(BUG_REPORT_EMAIL, "Help Report: "..os.date().." from "..tostring(this:GetName()), body)

		this:SystemMessage("Help report submitted. Thanks for your patience while we investigate.","info")
		successfulSubmission = true
		CloseHelpReportWindow()
	elseif(buttonId == "HarassmentTarget") then
		this:CloseDynamicWindow("HelpReportWindow")
		this:RequestClientTargetGameObj(this, "select_harassment")
		requestingTarget = true		
	elseif(buttonId:match("Type")) then
		helpWindowType = buttonId:sub(6)
		harassmentTarget = nil
		ShowHelpReportWindow()
	elseif not(requestingTarget) then
		this:SystemMessage("Help report cancelled.","info")
		CloseHelpReportWindow()
		return
	end
end

function HandleHarassmentTarget (target, user)
	requestingTarget = false

	if(target and target ~= this and target:IsPlayer()) then
		harassmentTarget = { Name=target:GetName(), Id=target.Id }
	else
		this:SystemMessage("You must select another player.","info")				
	end
	ShowHelpReportWindow()
end

function BuildReportData()
	return json.encode({
		Region = ServerSettings.RegionAddress,
		UserID = this:GetAttachedUserId(),
		Location = tostring(this:GetLoc()),
		Facing = tostring(this:GetFacing()),
		UTC = DateTime.UtcNow:ToString(),
		HarassmentName = harassmentTarget and harassmentTarget.Name,
		HarassmentId = harassmentTarget and harassmentTarget.Id
	})
end

RegisterEventHandler(EventType.DynamicWindowResponse,"HelpReportWindow",HandleHelpReportWindowResponse)
RegisterEventHandler(EventType.ClientTargetGameObjResponse,"select_harassment",HandleHarassmentTarget)

RegisterEventHandler(EventType.ModuleAttached,"help_report_window",
	function ()
		if(ServerSettings.Misc.HelpReportEnabled) then
			ShowHelpReportWindow()
		else
			this:SystemMessage("We are experiencing technical difficulties. Help report system is currently disabled.","info")
			CloseHelpReportWindow()
		end
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ()
		this:DelModule("help_report_window")
	end)

RegisterEventHandler(EventType.Message,"UpdateHelpReportWindow",
	function ()
		ShowHelpReportWindow()
	end)

RegisterEventHandler(EventType.Message,"CloseHelpReportWindow",
	function ()
		CloseHelpReportWindow()
	end)