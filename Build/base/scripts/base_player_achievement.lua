
mAchievementWindowOpen = false
mAchievementTab = "Skill"
mCategory = "Skill"

TabInfo = {
	"Skill" ,
	"Activity",
	"Executioner",
	"PvP",
	"Boss Kills",
	"Crafting",
	"Treasure Hunting",
	"Fishing",
	"Renown",
	"Other",
}

function ToggleAchievementWindow(user)
	mAchievementWindowOpen = not mAchievementWindowOpen
	if (mAchievementWindowOpen) == false then
		user:CloseDynamicWindow("PlayerAchievementWindow")
	else
		OpenAchievementWindow(user)
	end
end

--Used to add scroll window element to achievement scroll window
function AddAchievementElement(scrollWindow,achievementName,achievementDescription,isDisabled,isActive, completed, achievementLevel, completeAchievementLevel, reward, type, subcategory)
	local scrollElement = ScrollElement()	

	--Change achievement name color if achievement is diables (have not fulfilled achievement requirement)
	if (isDisabled) then
		achievementName = "[918369]"..achievementName
	end

	if (subcategory == nil) then
		subcategory = ""
	end

	local buttonState = (isActive and "pressed") or ((isDisabled and "disabled") or "")
	scrollElement:AddButton(157,10,achievementName.."|"..type.."|"..tostring(completed).."|"..subcategory,"",382,78,"",nil,false,"AchievementButton", buttonState)

	--Add filled gem for every levels of achievement done then add empty gem for remaining levels of achievement
	local yImage = 16
	local achievementStatus = 1
	if (completeAchievementLevel ~= nil) then
		achievementStatus = completeAchievementLevel + 1
		for i = 1, completeAchievementLevel do
			scrollElement:AddImage(220, yImage, "Gem_Filled",15, 12)
			yImage = yImage + 14
		end
	end

	for i = achievementStatus, achievementLevel do
		scrollElement:AddImage(220, yImage,"Gem_Empty",15,12)
		yImage = yImage + 14
	end

	--Add achievement name and description
	scrollElement:AddLabel(242, 18, achievementName,796,80,20,"left",false,false,"SpectralSC-SemiBold")
	scrollElement:AddLabel(242, 40, achievementDescription, 260, 80, 16, "left")

	--Add icon next to achievement name and description to indicate the type of reward
	local invisibleTooltip = ""
	if (reward ~= nil) then
		if (reward["Title"] ~= nil) then
			scrollElement:AddImage(504, 33, "AchievementTitle_Icon", 30, 30)
			invisibleTooltip = "This achivement grants you title on completion"
		elseif (reward["Renown"] ~= nil) then
			scrollElement:AddImage(504, 33, "RenownPoints_Icon", 30, 30)
			local renownAmount = AchievementsReward.Renown[reward["Renown"]] or reward["Renown"]
			invisibleTooltip = "This achivement grants you "..tostring(renownAmount).. " renown on completion"
		end
	end

	--Invisible button on reward icon to show tooltip
	scrollElement:AddButton(504,30,"","",30,30,invisibleTooltip,"",false,"Invisible")

	--Add achievement icon to the window. If achievement tab is set to "Other" show renown achievement icon
	local achievementIcon = nil
	if (mAchievementTab ~= "Other") then
		achievementIcon = "achievement_"..mAchievementTab.."_"..type
	else
		achievementIcon = "achievement_Renown_RenownAmount"
	end

	scrollElement:AddImage(163, 24, achievementIcon,52,52)

	--Add notification icon if achievement is ready to be completed
	if (completed == false and mAchievementTab ~= "Other") then
		scrollElement:AddImage(158,14,"NotificationIcon",21,20)
	end

	scrollWindow:Add(scrollElement)
end

function OpenAchievementWindow(user)

	local window = DynamicWindow("PlayerAchievementWindow","Achievements",604,678,-260,-185,"Default","Center")

	window:AddImage(152, 4, "BasicWindow_Panel",402,567,"Sliced")

	window:AddButton(247, 585, "RemoveTitle","Remove title", 100, 30, "", nil, false)

	mCategory = string.gsub(mAchievementTab," ","")

	--Add button ShowOnlyTitle
	local showOnlyTitle = user:HasObjVar("ShowOnlyTitle")
	local buttonState = ""
	if (showOnlyTitle) then
		buttonState = "pressed"
	end

	local lockTitle = user:HasObjVar("LockTitle")
	local lockTitleButtonState = ""
	if (lockTitle) then
		lockTitleButtonState = "pressed"
	end
	window:AddButton(357,577,"ShowOnlyTitle","Show titles only",110,30,"","",false,"Selection2",buttonState)
	window:AddButton(357,602,"LockTitle","Lock title",110,30,"","",false,"Selection2",lockTitleButtonState)

	local totalRenown = this:GetObjVar("Renown") or 0

	window:AddLabel(20, 593, "Renown Earned: "..tostring(totalRenown),200, 80, 18, "left")

	--Get all achievements that fits to current tab
	local achievements = GetAllCategoryAchievements(mAchievementTab)

	local scrollWindow = ScrollWindow(5,6,560,564,78)

	--This function gets every completed achievements and achievements waiting to be completed
	local availableAchievements = GetAllAchievementsObtained(user)
	local activeTitle = GetActiveTitle(user)
	local activeTitleType = GetActiveTitleType(user)

	local completedAchievements = this:GetObjVar("CompletedAchievements") or {}
	
	--First get all the achievements player completed or waiting to be completed and show them on achievement window
	--If current tab is "Other" follow different procedure
	if (mAchievementTab ~= "Other" and achievements ~= nil) then
		local achievementToShow = nil
		local completedAchievmentLevels = 0
		local achievementToShowPrevious = nil
		for i,j in pairs(achievements) do
			local isActive = false
			--achievementsDone is a table of completed or waiting achievements of the same type
			local achievementsDone = availableAchievements[j.Type]
			if (achievementsDone ~= nil) then
				--For every completed or waiting achievements of the same type
				for n,k in pairs(achievementsDone) do
					if (achievementToShow == nil) then
						achievementToShow = k
					else 
						local achievementToCheckRequirement = k.Requirement.Value
						local achievementToShowRequirement = achievementToShow.Requirement.Value
						if (achievementToCheckRequirement >= achievementToShowRequirement) then
							--Set achievementToShow to the highest completed level of the achievement
							achievementToShowPrevious = achievementToShow
							achievementToShow = k
						end
					end

					--Check if current achievementToShow has already been completed
					completed = false
					for a,b in pairs(completedAchievements) do
						if (achievementToShow.Achievement == b.Achievement) then
							completedAchievmentLevels = completedAchievmentLevels + 1
							completed = true
							break
						end
					end

					--If current achievement has not been completed then show previous achievement
					if (completed == false) then
						if (achievementToShowPrevious ~= nil) then
							achievementToShow = achievementToShowPrevious
						end
						break
					end

					--If we are using title rewarded by achievement we are trying to show, set isActive true
					if (achievementToShow.Reward.Title ~= nil and activeTitleType == j.Type) then
						isActive = true
					end
				end

				if (achievementToShow ~= nil) then
					if (showOnlyTitle == false or achievementToShow.Reward.Title ~= nil) then
						local totalAchievementLevel = 0
						if (achievementToShow.Subcategory ~= nil and achievementToShow.Subcategory ~= "") then
							totalAchievementLevel = #AllAchievements[achievementToShow.Category.."Achievements"][achievementToShow.Subcategory][achievementToShow.Type]
						else
							totalAchievementLevel = #AllAchievements[achievementToShow.Category.."Achievements"][achievementToShow.Type]
						end

						AddAchievementElement(scrollWindow, achievementToShow.Achievement, achievementToShow.Description, false, isActive, completed, totalAchievementLevel, completedAchievmentLevels, achievementToShow.Reward, achievementToShow.Type, achievementToShow.Subcategory)
					end
				end
				completedAchievmentLevels = 0
				achievementToShow = nil
				achievementToShowPrevious = nil
			end
		end
	else
		--Every Other achievements are going to be in table for completed achievement
		for i,j in pairs(completedAchievements) do
			if (j.Category == "Other") then
				AddAchievementElement(scrollWindow, j.Achievement, j.Description, false, activeTitle == j.Achievement, true, 1, 1, j.Reward, j.Type, j.Subcategory)	
			end
		end
	end

	if (achievements ~= nil) then
		--then add achievements player have not completed yet
		for i,j in pairs(achievements) do
			--Any achievement with any level completed should be handled already. Don't process that achievement in this loop
			if (availableAchievements[j.Type] == nil) then
				local achievementLevels = 0
				achievementLevels = #j

				--If no level of the achievement has been completed, show the first level of the achievement
				if (showOnlyTitle == false or j[1][4]["Title"] ~= nil) then
					AddAchievementElement(scrollWindow, j[1][1],j[1][3], true, false, nil, achievementLevels, nil, j[1][4], j.Type)	
				end
			end
		end
	end

	local ButtonTab = {}
	for key,value in pairs(TabInfo) do
		if (not showOnlyTitle or AchievementTabHasTitle(this, value)) then
			local text = {}
			text["Text"] = value
			table.insert(ButtonTab, text)
		end
	end

	window:AddScrollWindow(scrollWindow)

	--Add tab menus on the side of the achievement window
	AddVerticalTabMenu(window,
	{
        ActiveTab = mAchievementTab, 
        OffsetY = 8,
        OffsetX = 5,
        Buttons = ButtonTab,
    })

    local achievementWaiting = this:GetObjVar("AchievementWaiting")

    --Add notification icon on the side of the certain tab if an achievement is waiting for completion
	if (achievementWaiting ~= nil) then
		for key,value in pairs(ButtonTab) do
			local tabName = string.gsub(value["Text"]," ","")
			for i,j in pairs(achievementWaiting) do
				if (j.Category == tabName) then
					window:AddImage(127,19 + ((key-1) * 35),"NotificationIcon",21,20)
					break
				end
			end
		end
	end

	mAchievementWindowOpen = true
	this:OpenDynamicWindow(window,this)
end

--This function is called when a player presses achievement button on achievement window
function CompleteAchievementPressed(achievement, achievementType, achievementSubcategory, completed)
	local achievementReward = nil
	local completedAchievements = this:GetObjVar("CompletedAchievements") or {}

	if (completed == "true") then
		local completedAchievementGroup = {}

		--Take only completedAchievements with achievementType we are looking for
		for key,value in pairs(completedAchievements) do
			if (value.Type == achievementType) then
				table.insert(completedAchievementGroup, value)
			end
		end

		--Iterate from achievement with highest requirement to lowest, so we can use title with lower rquirement if we can't use higher requirement
		for i = #completedAchievementGroup, 1, -1 do
			local completedAchievement = completedAchievementGroup[i]

			if not (CanUseTitle(this, completedAchievement.Requirement, completedAchievement.Type)) then
				if (i == #completedAchievementGroup) then
					this:SystemMessage("Cannot use the title "..completedAchievement.Reward.Title..".","info")
				elseif (i == 1) then
					return false
				end
			elseif (completedAchievement.Reward.Title ~= nil and GetActiveTitle(this) ~= completedAchievement.Reward.Title) then
				if (this:HasObjVar("LockTitle")) then
					this:SystemMessage("Disable title lock to change the title.","info")
					return
				end
				this:SetSharedObjectProperty("Title",completedAchievement.Reward.Title)
				SetTooltipEntry(this, "Title",completedAchievement.Reward.Title, 100)
				this:SystemMessage("Title has been set to "..completedAchievement.Reward.Title..".","info")
				this:SendMessage("UpdateCharacterWindow")
				return true
			else
				return false
			end
		end

		return false
	end
	
	local achievementWaiting = this:GetObjVar("AchievementWaiting") or {}

	local achievementToComplete = nil
	for key,value in pairs(achievementWaiting) do
		if (value.Category == mCategory) and (value.Type == achievementType) and (value.Subcategory == "" or value.Subcategory == achievementSubcategory) then
			local tab = {}
			if (value.Subcategory == "") then
				tab = AllAchievements[value.Category.."Achievements"][value.Type]
			else
				tab = AllAchievements[value.Category.."Achievements"][value.Subcategory][value.Type]
			end
			if (tab ~= nil) then
				for i,j in pairs(tab) do
					if (i == 1 and j[1] == achievement) or (j[1] == achievement and tab[i + 1][1] == value.Achievement) then
						achievementReward = value.Reward
						table.insert(completedAchievements, value)
						table.remove(achievementWaiting, key)
						achievementToComplete = value
						break
					end
				end
			end
			break
		end
	end

	if (achievementToComplete ~= nil) then
		if (#achievementWaiting > 0) then
			this:SetObjVar("AchievementWaiting",achievementWaiting)
		else
			this:SendClientMessage("SetAchievementNotification",false)
			this:DelObjVar("AchievementWaiting")
		end
			
		DistributeAchievementReward(achievementReward, achievementToComplete.Achievement)
		this:SetObjVar("CompletedAchievements",completedAchievements)

		return true
	end
end

function DistributeAchievementReward(reward, achievementName)
	if (reward == nil) then
		return
	end

	for key,value in pairs(reward) do
		if (key == "Renown") then
			local renownAmount = AchievementsReward.Renown[value] or value
			local curRenown = this:GetObjVar("Renown") or 0
			this:SetObjVar("Renown", curRenown + renownAmount)
			CheckAchievementStatus(this, "Renown", "RenownAmount", curRenown + renownAmount, {TitleCheck = "Renown"})
			this:SystemMessage("Earned "..renownAmount.." renown.","info")
		end
	end

	this:SystemMessage("Completed an achievement "..achievementName..".","info")
end

RegisterEventHandler(EventType.DynamicWindowResponse,"PlayerAchievementWindow",
	function (user,buttonId)

		if(buttonId == nil or buttonId == "") then mAchievementWindowOpen = false return end		

		if (buttonId == "ShowOnlyTitle") then
			local showOnlyTitle = this:HasObjVar("ShowOnlyTitle")
			if (showOnlyTitle) then
				this:DelObjVar("ShowOnlyTitle")
			else
				this:SetObjVar("ShowOnlyTitle",true)
			end
			ReopenAchievementWindow()
			return
		end

		if (buttonId == "LockTitle") then
			local lockTitle = this:HasObjVar("LockTitle")
			if (lockTitle) then
				this:DelObjVar("LockTitle")
			else
				this:SetObjVar("LockTitle",true)
			end
			ReopenAchievementWindow()
			return
		end

		if (buttonId == "RemoveTitle") then
			this:SystemMessage("Title has been removed.","info")
			this:SetSharedObjectProperty("Title","")
			RemoveTooltipEntry(this,"Title")
			ReopenAchievementWindow()
			return
		end

		local newTab = HandleTabMenuResponse(buttonId)
		if(newTab) then
			mAchievementTab = newTab
			OpenAchievementWindow(user)
			return
		end

		if (buttonId == "ShowOnlyTitle") then
			local showOnlyTitle = user:HasObjVar("ShowOnlyTitle")
			if (showOnlyTitle == false) then
				user:SetObjVar("ShowOnlyTitle",true)
			else
				user:DelObjVar("ShowOnlyTitle")
			end
			OpenAchievementWindow(user)
			return
		end

		local args = StringSplit(buttonId,"|")
		local achievement = args[1]
		local achievementType = args[2]
		local achievementCompleted = args[3]
		local achievementSubcategory = args[4]

		local reOpenWindow = CompleteAchievementPressed(achievement, achievementType, achievementSubcategory, achievementCompleted)

		if (reOpenWindow == true) then
			OpenAchievementWindow(user)
		end
	end)

function ReopenAchievementWindow()
	if (mAchievementWindowOpen) then
		OpenAchievementWindow(this)
	end
end

RegisterEventHandler(EventType.Message, "ReopenAchievementWindow", 
	function()
		ReopenAchievementWindow()
	end)