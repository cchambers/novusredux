BUG_REPORT_DISABLED = false

bugReportStartingText = "[$1619]"

function OpenBugReportDialog(user)
	if (BUG_REPORT_DISABLED) then
		user:SystemMessage("Bug reporting temporarily disabled for now.")
		return
	end
	local newWindow = DynamicWindow("BugReportWindow","Bug Report",400,388,200,200,"Default","TopLeft")

	local x = 30
	local y = 300
	newWindow:AddTextField(x, 10, 320,280, "BugReportMessage", bugReportStartingText)
	
	newWindow:AddButton(x, y, "Submit", "Submit", 150, 0, "", "", true)
	newWindow:AddButton(x+170, y, "Cancel", "Cancel", 150, 0, "", "", true)
	--newWindow:AddButton(x, y, "CancelImprovement", "Cancel", 200, 0, "Stop Attempting to Improve the item.", "", false)
	user:OpenDynamicWindow(newWindow,this)
end

function BuildReportData()
	-- only include mods that have something on them.
	local mods = {}
	for type,data in pairs(MobileMod) do
		for i,v in pairs(data) do
			mods[type] = data
			break
		end
	end
	return json.encode({
		Region = GetRegionAddress(),
		UserID = this:GetAttachedUserId(),
		Location = tostring(this:GetLoc()),
		Facing = tostring(this:GetFacing()),
		UTC = DateTime.UtcNow:ToString(),
		MobileEffects = this:GetObjVar("MobileEffects") or {},
		MobileMods = mods,
	})
end

RegisterEventHandler(EventType.DynamicWindowResponse,"BugReportWindow",
function (user,buttonId,bugReportField)
	if (user == nil or not user:IsValid()) then
		return 
	end
	if ( buttonId == "Submit" ) then

		if ( bugReportField.BugReportMessage == "" or bugReportField.BugReportMessage == bugReportStartingText ) then
			this:SystemMessage("[D70000]Please provide more detail in your report.[-]")
			return
		end
		
		local body = "User Message:\n" .. bugReportField.BugReportMessage .. "\n\n" .. BuildReportData()

		--DebugMessage(body)

		SendEmail(BUG_REPORT_EMAIL, "Bug Report: "..os.date().." from "..tostring(this:GetName()), body)

		user:SystemMessage("[$1620]")
		
	else
		return
	end
end)

RegisterEventHandler(EventType.Message, "BugReportCurrentMobileModResponse", function(mobileMods)
		
	SendEmail(BUG_REPORT_EMAIL,"Bug Report: "..os.date().." from "..tostring(this:GetName()), debugInformation)

end)