require 'incl_player_titles'

mTitleWindowOpen = false
mTitleTab = "Skill"

function ToggleTitleWindow(user)
	mTitleWindowOpen = not mTitleWindowOpen
	if (mTitleWindowOpen) == false then
		user:CloseDynamicWindow("PlayerTitleWindow")
	else
		OpenTitleWindow(user)
	end
end

function AddTitleElement(scrollWindow,titleIndex,titleName,titleDescription,isDisabled,isActive)
	local scrollElement = ScrollElement()	

	if (isDisabled) then
		titleName = "[918369]"..titleName
	end

	local buttonState = (isActive and "pressed") or ((isDisabled and "disabled") or "")
	scrollElement:AddButton(0,0,titleName.."|"..titleIndex,"",460,50,"","",false,"List",buttonState)
	
	scrollElement:AddLabel(10,8,titleName,420,80,20,"left",false,false,nil,"bold")
	if(titleDescription ~= nil) then
		if(isDisabled) then
			titleDescription = "[918369]"..titleDescription
		end
		scrollElement:AddLabel(10,30,titleDescription,440,20,16,"left")
	end
	
	scrollWindow:Add(scrollElement)
end

function OpenTitleWindow(user)
	local window = DynamicWindow("PlayerTitleWindow","Player Titles",520,370,-260,-185,"Default","Center")

	AddTabMenu(window,
	{
        ActiveTab = mTitleTab, 
        Width = 478,
        Buttons = {
			{ Text = "Skill" },
			{ Text = "Faction" },
			{ Text = "Combat" },
			{ Text = "Other" },
        }
    })	

	local titles = nil
	if (mTitleTab == "Skill") then
		titles = PlayerTitles.GetAllSkillTitles()		
	elseif (mTitleTab == "Faction") then
		titles = PlayerTitles.GetAllFactionTitles()
	elseif (mTitleTab == "Combat") then
		titles = PlayerTitles.GetAllMonsterTitles()
	elseif (mTitleTab == "Other") then
		titles = PlayerTitles.GetAllActivityTitles()
	end	

	local scrollWindow = ScrollWindow(10,30,470,250,50)

	local achievedTitles = PlayerTitles.GetAll(user)
	local activeTitle = PlayerTitles.GetActiveTitle(user)
	local showCount = 0
	--first get all the titles a player has
	if (achievedTitles ~= nil) then
		for i,j in pairs(achievedTitles) do
			local show = false

			-- show account titles in other
			if(mTitleTab == "Other" and j.IsAccountTitle) then
				show = true
			elseif (mTitleTab == "Other" and j.Handle == "GuildTitle") then
				show = true
			elseif (titles ~= nil) then
				--otherwise see if the player's titles are in the current tab
				for n,k in pairs (titles) do
					if (k[1]:find(j.Title,1,true) ~= nil) then
						show = true
					end
				end
			end
			--add them if they are
			if (show) then
				showCount = showCount + 1
				AddTitleElement(scrollWindow,i,j.Title,j.Description,false,activeTitle == j.Title)
			end
		end
	end
	
	local show = true

	--then add titles the player doesn't have yet
	for i,j in pairs(titles) do
		local show = true
		if (achievedTitles ~= nil) then
		--otherwise see if the player's titles are in the current tab
			for n,k in pairs (achievedTitles) do
				if (j[1]:find(k.Title,1,true) ~= nil) then
					show = false
				end
			end
		end

		if (not PlayerTitles.HasTitle(user,j[1]) and show) then
			showCount = showCount + 1
			AddTitleElement(scrollWindow,i,j[1],j[4],true,false)				
		end
	end

	if (showCount == 0) then
		local text = (mTitleTab == "Available") and "You have not unlocked any titles." or "No titles in this section."
		window:AddLabel(260,50,text,0,0,18,"center")
	else
		window:AddScrollWindow(scrollWindow)
	end

	window:AddButton(200,285,"Clear","Clear Title",0,0,"Removes your current title.","",false,"", "")	

	local checkKeepTitle = user:GetObjVar("KeepTitle") or false
	local pressed = ""
	if (checkKeepTitle == true) then
		pressed = "pressed"
	end
	window:AddButton(300, 288, "KeepTitle", "", 0, 22, "Keep current title when you earn new title.", "", false, "Selection",pressed)
	window:AddLabel(330, 292,"Keep title",0,0,18)

	this:OpenDynamicWindow(window,this)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"PlayerTitleWindow",
	function (user,buttonId)
		if(buttonId == nil or buttonId == "") then mTitleWindowOpen = false return end		

		local newTab = HandleTabMenuResponse(buttonId)
		if(newTab) then
			mTitleTab = newTab
			OpenTitleWindow(user)
			return
		end

		if (buttonId == "Clear") then
			this:SetObjVar("titleIndex",0)
			this:SetSharedObjectProperty("Title","")
			RemoveTooltipEntry(this,"Title")
			this:SystemMessage("Your title has been cleared.")
			OpenTitleWindow(user)
			return
		end

		if (buttonId == "KeepTitle") then
			local checkKeepTitle = user:GetObjVar("KeepTitle") or false
			if (checkKeepTitle == false) then
				user:SetObjVar("KeepTitle",true)
			else
				user:SetObjVar("KeepTitle",false)
			end
			OpenTitleWindow(user)
			return
		end

		local args = StringSplit(buttonId,"|")
		local title = args[1]
		local index = args[2]

		if (not PlayerTitles.HasTitle(user,title)) then
			user:SystemMessage("[D70000]You have not achieved the title "..title.." yet.[-]")
			return 
		end

		-- DAB TODO: This should use the Update title code
		this:SetObjVar("titleIndex",index)
		this:SetSharedObjectProperty("Title",title)
		SetTooltipEntry(this,"Title",title,100)
		this:SystemMessage("Your title has been set to "..title)
		OpenTitleWindow(user)
	end)
	

RegisterEventHandler(EventType.Message, "CheckSkillTitleChange", function(skillName, newVal)
	if ( AllTitles.SkillTitles[skillName] ) then
		PlayerTitles.CheckTitleGain(this,AllTitles.SkillTitles[skillName], newVal)
	end
end)