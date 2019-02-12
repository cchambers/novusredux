RegisterSingleEventHandler(
	EventType.ModuleAttached,
	"page_gm",
	function()
		if not(this:HasTimer("NoPageTimer")) then
			local newWindow = DynamicWindow("PageWindow","Page a GM",400,300,200,200,"Default","TopLeft")
			local x = 30
			local y = 215
			newWindow:AddTextField(x, 30, 320, 180, "PageDetails", "")
			
			newWindow:AddLabel(x, 10, "What's up? Remember: details are important!", 400, 30, 18, "left", true, true, "PermianSlabSerif_Dynamic_Bold")
			newWindow:AddButton(x, y, "Submit", "Send Page", 150, 0, "", "", true)
			newWindow:AddButton(x+170, y, "Cancel", "Cancel", 150, 0, "", "", true)
			--newWindow:AddButton(x, y, "CancelImprovement", "Cancel", 200, 0, "Stop Attempting to Improve the item.", "", false)
			this:OpenDynamicWindow(newWindow,this)
		else 
			this:SystemMessage("You will need to wait a bit before doing that again.", "info")
			this:DelModule("page_gm")
		end
	end
)

RegisterEventHandler(EventType.DynamicWindowResponse,"PageWindow",
function (user,buttonId,page)
	if (user == nil or not user:IsValid()) then
		return 
	end
	if ( buttonId == "Submit" ) then
		if ( page.PageDetails == "" or page.PageDetails == bugReportStartingText ) then
			user:SystemMessage("[D70000]Please provide more detail in your report.[-]","info")
			return
		end
		Totem(user, "page", page.PageDetails)
		user:ScheduleTimerDelay(TimeSpan.FromMinutes(5),"NoPageTimer")
		user:SystemMessage("Thanks! We will be by to help you as soon as possible.","info")
	else
		user:DelModule("page_gm")
	end
end)
