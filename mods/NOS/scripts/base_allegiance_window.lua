
ALLEGIANCE_WINDOW_WIDTH = 300
ALLEGIANCE_WINDOW_HEIGHT = 280

function AllegianceInfo()
	local allegianceResign = this:GetObjVar("AllegianceResign")
	if (allegianceResign) then
		local text = "You can speak to your allegiance leader to fully renounce your allegiance now."

		local now = DateTime.UtcNow
		if ( now < allegianceResign ) then
			text = "You are currently in the allegiance resignation waiting period. Speak to your allegiance leader in "..TimeSpanToWords(allegianceResign:Subtract(now)).." to complete the resignation."
		end

		ClientDialog.Show{
	        TargetUser = this,
	        ResponseObj = this,
	        DialogId = "AllegianceResignInfo",
	        TitleStr = "Resignation Pending",
	        DescStr = text,
	        Button1Str = "Ok",	        
	    }
	else
		local allegianceId = GetAllegianceId(this)
		if ( allegianceId == nil ) then 
			this:SystemMessage("You are not in an allegiance.","info")
			return 
		end

		local allegianceData = GetAllegianceDataById(allegianceId)
		if ( allegianceData == nil ) then return end

		local dynamicWindow = DynamicWindow(
			"Allegiance", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
			"Allegiance", --(string) Title of the window for the client UI
			ALLEGIANCE_WINDOW_WIDTH, --(number) Width of the window
			ALLEGIANCE_WINDOW_HEIGHT --(number) Height of the window
			--nil, --startX, --(number) Starting X position of the window (chosen by client if not specified)
			--nil, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
			--"TransparentDraggable",--windowType, --(string) Window type (optional)
			--"Center" --windowAnchor --(string) Window anchor (default "TopLeft")
		)

		dynamicWindow:AddImage(100,0,allegianceData.IconLarge,76,106)
		dynamicWindow:AddLabel(138,112,allegianceData.Name,500,32,24,"center")

		dynamicWindow:AddImage(20,140,"Divider",240,0,"Sliced")

		dynamicWindow:AddLabel(20,162,"Favor: "..GetFavor(this),500,32,14,"")

		dynamicWindow:AddButton(
			18, --(number) x position in pixels on the window
			190, --(number) y position in pixels on the window
			"Leave", --(string) return id used in the DynamicWindowResponse event
			"Resign", --(string) text in the button (defaults to empty string)
			240, --(number) width of the button (defaults to width of text)
			0,--(number) height of the button (default decided by type of button)
			"", --(string) mouseover tooltip for the button (default blank)
			"", --(string) server command to send on button click (default to none)
			true --(boolean) should the window close when this button is clicked? (default true)
			--"CloseSquare", --(string) button type (default "Default")
			--buttonState --(string) button state (optional, valid options are default,pressed,disabled)
			--customSprites --(table) Table of custom button sprites (normal, hover, pressed. disabled)
		)

		mAllegianceWindowOpen = true

		this:OpenDynamicWindow(dynamicWindow)
	end	
end

RegisterEventHandler(EventType.DynamicWindowResponse, "Allegiance", function(user, buttonId)
	if ( buttonId == "Leave" ) then
		ClientDialog.Show{
	        TargetUser = this,
	        ResponseObj = this,
	        DialogId = "AllegianceResign",
	        TitleStr = "Confirm Resignation",
	        DescStr = "Are you sure you wish to leave your allegiance? During the resignation period (".. TimeSpanToWords(ServerSettings.Allegiance.ResignTime) .."), you will be unable to earn favor and you can not join another allegiance until it ends.",
	        Button1Str = "Confirm",
	        Button2Str = "Cancel",
	        ResponseFunc=function(user,buttonId)
	        	if(buttonId == 0) then
		            AllegianceBeginResignation(this)
		        end
	        end,
	    }
	elseif(buttonId == "" or buttonId == nil) then
		mAllegianceWindowOpen = false
	end
end)

function ToggleAllegianceWindow()
	if(mAllegianceWindowOpen) then
		mAllegianceWindowOpen = false
		this:CloseDynamicWindow("Allegiance")
	else
		AllegianceInfo()
	end
end