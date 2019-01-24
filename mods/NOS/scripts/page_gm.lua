RegisterSingleEventHandler(
	EventType.ModuleAttached,
	"page_gm",
	function()
		local newWindow = DynamicWindow("PageWindow","Page a GM",400,300,200,200,"Default","TopLeft")

		local x = 30
		local y = 215
		newWindow:AddTextField(x, 10, 320,200, "PageDetails", "Details are important! Delete this line.")
		
		newWindow:AddButton(x, y, "Submit", "Submit", 150, 0, "", "", true)
		newWindow:AddButton(x+170, y, "Cancel", "Cancel", 150, 0, "", "", true)
		--newWindow:AddButton(x, y, "CancelImprovement", "Cancel", 200, 0, "Stop Attempting to Improve the item.", "", false)
		this:OpenDynamicWindow(newWindow,this)
		
	end
)




RegisterEventHandler(EventType.DynamicWindowResponse,"PageWindow",
function (user,buttonId,page)
	if (user == nil or not user:IsValid()) then
		return 
	end
	if ( buttonId == "Submit" ) then
		if ( page.PageDetails == "" or page.PageDetails == bugReportStartingText ) then
			this:SystemMessage("[D70000]Please provide more detail in your report.[-]","info")
			return
		end
		
		Totem(this, "page", page.PageDetails)
		
		user:SystemMessage("Thanks! We will be by to help you as soon as possible.","info")

		-- send global message to GMs only
	else
		user:DelModule("page_gm")
		return
	end
end)
