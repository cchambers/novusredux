--Achievement is saved on file in this format
--AchievementCategory{
--		AchievementType = {
--			{"AchievementName",AchievementRequirement,"Description",RewardTable}
--		}
--}

--Achievement is saved to players in this format
	-- Achievement = achievement name
	-- Description = achievement description
	-- Handle = Anything extra this achievement should have
	-- Reward = Reward table for this achievement
	-- Type = achievement type
	-- Requirement = achievement requirement
	-- Category = achievement category

--gets a list of all the achievement that you can get ingame
function GetAllIngameAchievements()
	local result = {}
	local count = 1
	for i,j in pairs(AllAchievements) do
		for n,k in pairs(j) do
			for l,m in pairs (k) do
				table.insert(result,count,m)
				count = count + 1
			end
		end
	end
	return result,count
end

--gets a list of all the achievement from given category
function GetAllCategoryAchievements(category)
	local result = {}
	local keys = {}
	local count = 1

	category = string.gsub(category," ","")

	local achievementToGet = category.."Achievements"

	if not(AllAchievements[achievementToGet]) then
		return
	end
	
	local achievementTable = {}
	local achievementSubcategory = {}

	for n,k in pairs(AllAchievements[achievementToGet]) do
		if (k[1] == nil) then
			table.insert(achievementSubcategory, n)
		else
			achievementTable = k
			achievementTable["Type"] = n
			table.insert(result,count,achievementTable)
			count = count + 1
			achievementTable = {}
		end
	end

	table.sort(result,function(a,b) return a[1][1] < b[1][1] end)

	if (next(achievementSubcategory) ~= nil) then
		table.sort(achievementSubcategory,function(a,b) return a < b end)
	end

	--If achievement category has subcategory, sort them by category
	for i,j in pairs(achievementSubcategory) do
		local achievementSubcategorySorted = {}

		for n,k in pairs(AllAchievements[achievementToGet][j]) do
			local tableToInsert = k
			tableToInsert["Type"] = n
			table.insert(achievementSubcategorySorted,k)
		end

		table.sort(achievementSubcategorySorted, function(a,b) return a[1][1] < b[1][1] end)

		for n,k in pairs(achievementSubcategorySorted) do
			achievementTable = k
			table.insert(result,k)
		end
	end

	return result,count
end

--gets a list of specific type of achievement from given category
function GetSpecificAchievement(category, type)
	local result = {}
	local count = 1

	category = string.gsub(category," ","")

	local achievementCategory = category.."Achievements"

	for l,m in pairs(AllAchievements[achievementCategory][type]) do
		table.insert(result,count,m)
		count = count + 1
	end
	return result,count
end

--get a list of all achievements on the player, account and ingame
--get only achievement with title if onlyTitle is true
function GetAllAchievementsObtained(playerObj, onlyTitle)
	onlyTitle = onlyTitle or false
	if( playerObj == nil ) then return {} end

	local allAchievements = {}
	local accountAchievements = {}

	-- login server based titles
	local customAchievementsStr = GetCustomAchievements(playerObj)
	if( customAchievementsStr ~= nil ) then
		accountAchievements = StringSplit(customAchievementsStr,",")
	end

	for i,j in pairs(accountAchievements) do
		local entry = 
		{
			Description = "[D7D700]Account Achievement[-]",
			Handle = j,
			Achievement = j,
			IsAccountAchievement = true,
		}
		table.insert(allAchievements,entry)
	end	

	local completedAchievements = playerObj:GetObjVar("CompletedAchievements") or {}
	local waitingAchievements = playerObj:GetObjVar("AchievementWaiting") or {}

	for i,j in pairs(completedAchievements) do
		if (onlyTitle == false or j.Reward.Title ~= nil) then
			local achievementTypeGroup = allAchievements[j.Type] or {}
			table.insert(achievementTypeGroup,j)
			allAchievements[j.Type] = achievementTypeGroup
		end
	end

	for i,j in pairs(waitingAchievements) do
		if (onlyTitle == false or j.Reward.Title ~= nil) then
			local achievementTypeGroup = allAchievements[j.Type] or {}
			table.insert(achievementTypeGroup,j)
			allAchievements[j.Type] = achievementTypeGroup
		end
	end

	return allAchievements
end

--Complete achievement for a player
function CompleteAchievement(playerObj,achievement,makeActive,description,reward,achievementType,requirement, achievementCategory, achievementSubcategory, handle)
	if( makeActive == nil ) then makeActive = true end
	--DebugMessage(tostring(playerObj)..tostring(title)..tostring(makeActive)..tostring(description)..tostring(handle))
	if( achievement ~= nil and achievement ~= "" ) then

		local achievementWaiting = playerObj:GetObjVar("AchievementWaiting") or {}

		local entry = 
		{
			Description = description or "In-Game Achievement",
			Handle = handle or "",
			Achievement = achievement,
			Reward = reward or "",
			Type = achievementType or "",
			Requirement = requirement or {},
			Category = achievementCategory or "",
			Subcategory = achievementSubcategory or ""
		}
		table.insert(achievementWaiting,entry)

		playerObj:SystemMessage("Achievement "..achievement.." is ready to be completed.","info")
		
		playerObj:SendClientMessage("SetAchievementNotification",true)
		playerObj:SetObjVar("AchievementWaiting", achievementWaiting)

		playerObj:SendMessage("ReopenAchievementWindow")

		return newIndex
	end
end

--checks to see if the player has already completed an achievement
function HasAchievement(playerObj,achievement)	
	local customAchievementsStr = GetCustomTitles(playerObj) or ""	
	local customAchievements = StringSplit(customAchievementsStr,",")
	for i,achievementStr in pairs(customAchievements) do
		if( achievementStr == achievement ) then
			return true
		end
	end

	local completedAchievements = playerObj:GetObjVar("CompletedAchievements") or {}
	local waitingAchievements = playerObj:GetObjVar("AchievementWaiting") or {}

	for i,j in pairs(completedAchievements) do
		if (achievement == j.Achievement) then
			return true
		end
	end

	for i,j in pairs(waitingAchievements) do
		if (achievement == j.Achievement) then
			return true
		end
	end
	
	return false
end

--Check if player has fulfilled requirement for an achievement and have not completed an achievement yet
function CheckAchievementStatus(player, category, achievement,value, reference, subcategory)
	if (player == nil or IsPlayerCharacter(player) ~= true) then
		return
	end

	local achievementTable = {}

	if (subcategory == nil) then
		achievementTable = AllAchievements[category.."Achievements"][achievement]
	else
		achievementTable = AllAchievements[category.."Achievements"][subcategory][achievement]
	end

	if (achievementTable ~= nil or category == "Other") then
		if (value == nil and category ~= "Other") then
			LuaDebugCallStack("ERROR: value is nil for CheckAchievementStatus: ")
			return
		end

		if (reference == nil) then
			reference = {}
		end

		local achievementType = achievement or nil
		local noRestriction = reference.NoRestriction or false
		--Some achievements like karma may check if value passed in is lower than achievement requirement
		local requirement = {}

		if (category ~= "Other" or achievementTable ~= nil) then
			for i,j in pairs (achievementTable) do
				if j[1] ~= nil and not (HasAchievement(player,j[1])) then
					if (value >= j[2] or noRestriction) then
						if (reference.TitleCheck ~= nil) then
							requirement.Type = reference.TitleCheck
						end
						requirement.Value = j[2]
						CompleteAchievement(player, j[1],true,j[3],j[4], achievementType, requirement, category, subcategory)
					end
				end
			end
		else
			local handle = "Other"
			local achievementDescription = reference.Description or ""
			AddAchievement(player,achievementType, reference.Description, category, reference.CustomAchievement, reference.Reward, subcategory, handle)
		end
	end
end

--Function called to check every skill achievement for player
function CheckAchievementStatusAllSkills(player)
	for key,value in pairs(AllAchievements.SkillAchievements) do
		CheckAchievementStatus(player, "Skill", key, GetSkillLevel(player,key),{TitleCheck = "Skill"})
	end
end

--gets the current title on the player
function GetActiveTitle(playerObj)
	return playerObj:GetSharedObjectProperty("Title")
end

--Returns true if currently using title is in the given category
function GetActiveTitleType(playerObj)
	local title = GetActiveTitle(playerObj)
	local completedAchievements = playerObj:GetObjVar("CompletedAchievements") or {}
	for i,j in pairs(completedAchievements) do
		if (j.Reward.Title == title) then
			return j.Type
		end
	end
	return ""
end

function CanUseTitle(player, requirement, category, reference)
	local currentPlayerValue = nil
	if (requirement.Type == "Skill") then
		currentPlayerValue = GetSkillLevel(player, category)
	elseif (requirement.Type == "Karma") then
		currentPlayerValue = GetKarma(player)
		if (category == "KarmaBad") then
			currentPlayerValue = currentPlayerValue * -1
		end
	elseif (requirement.Type == "Allegiance") then
		local totalFavor = GlobalVarRead("AllegianceFavor") or {}
		local allegiance = GetAllegianceId(player)
   		totalFavor = totalFavor[allegiance] or 0
		currentPlayerValue = GetFavor(player) / totalFavor
	end

	if currentPlayerValue ~= nil and requirement.Value ~= nil and (currentPlayerValue < requirement.Value) then
		return false
	end

	return true
end

function AddAchievement(playerObj, achievementType, description, category, customAchievement, reward, handle, subcategory)

	local completedAchievements = playerObj:GetObjVar("CompletedAchievements") or {}
	local entryToReplace = nil

	for key,value in pairs(completedAchievements) do
		if (value.Type == achievementType) then
			entryToReplace = key
		end
	end

	if (entryToReplace ~= nil) then
		local currentTitle = GetActiveTitle(playerObj)
		local achievementToReplaceReward = completedAchievements[entryToReplace].Reward.Title

		if (achievementToReplaceReward ~= nil and achievementToReplaceReward == currentTitle) then
			playerObj:SetSharedObjectProperty("Title", reward.Title)
		end

		completedAchievements[entryToReplace].Description = description or "In-Game Achievement"
		completedAchievements[entryToReplace].Handle = handle or ""
		completedAchievements[entryToReplace].Achievement = customAchievement
		completedAchievements[entryToReplace].Reward = reward or {}
		completedAchievements[entryToReplace].Type = achievementType or ""
		completedAchievements[entryToReplace].Requirement = requirement or {}
		completedAchievements[entryToReplace].Category = category or ""
		completedAchievements[entryToReplace].Subcategory = subcategory or ""
	else
		local entry = 
			{
				Description = description or "In-Game Achievement",
				Handle = handle or "",
				Achievement = customAchievement,
				Reward = reward or "",
				Type = achievementType or "",
				Requirement = requirement or {},
				Category = category or "",
				Subcategory = subcategory or ""
			}
		table.insert(completedAchievements, entry)
	end

	playerObj:SystemMessage("You have gained the title "..customAchievement,"info")

	playerObj:SetObjVar("CompletedAchievements", completedAchievements)

	playerObj:SendMessage("ReopenAchievementWindow")
end

function RemoveOtherAchievement(playerObj, achievementType)
	local completedAchievements = playerObj:GetObjVar("CompletedAchievements") or {}

	for i,j in pairs(completedAchievements) do
		if (j.Type == achievementType) then
			local currentTitle = GetActiveTitle(playerObj)
			if (j.Achievement == currentTitle) then
				playerObj:SetSharedObjectProperty("Title","")
			end

			table.remove(completedAchievements,i)
			break
		end
	end

	playerObj:SetObjVar("CompletedAchievements", completedAchievements)

	playerObj:SendMessage("ReopenAchievementWindow")
end

--Check if a player can use current title. If not, set player title to lower level title or remove title
function CheckTitleRequirement(player, achievementType)
	if (player == nil or achievementType == nil) then
		return
	end

	local currentTitle = GetActiveTitle(player)

	--Second argument is titleOnly. Setting it to true gives only achievements with title
	local allTitles = GetAllAchievementsObtained(player, true)
	local canUseTitle = true

	--Take titles we are interested in only
	local allTitlesTable = allTitles[achievementType]
	local titleChecked = false

	if (allTitlesTable == nil) then
		return
	end

	for i = #allTitlesTable, 1, -1 do
		local completedAchievement = allTitlesTable[i]

		canUseTitle = CanUseTitle(player, completedAchievement.Requirement, completedAchievement.Type)

		if (canUseTitle == false) then
			if (titleChecked == false and completedAchievement.Reward.Title == currentTitle) then
				titleChecked = true
				player:SystemMessage("You no longer meet the requirement for the title "..currentTitle)
			end

			if (titleChecked and i == 1) then
				player:SetSharedObjectProperty("Title","")
				RemoveTooltipEntry(player,"Title")
				player:SendMessage("ReopenAchievementWindow")
			end
		elseif (currentTitle ~= completedAchievement.Reward.Title) then
			if ((titleChecked == false and not player:HasObjVar("LockTitle")) or titleChecked == true) then
				player:SystemMessage("Title has been set to "..completedAchievement.Reward.Title..".")
				player:SetSharedObjectProperty("Title",completedAchievement.Reward.Title)
				return
			end
		end
	end
end

--Check if a category of an achievement has at least one achievement with title reward
function AchievementTabHasTitle(player, category)
	--Handle Other category differently since it is a custom/removable achievement
	if (category == "Other") then
		local completedAchievements = player:GetObjVar("CompletedAchievements")

		if (completedAchievements == nil) then
			return false
		end

		for i,j in pairs(completedAchievements) do
			if (j.Handle == "Other" and j.Reward.Title ~= nil) then
				return true
			end
		end

		return false
	end

	category = string.gsub(category," ","")

	local achievementToGet = category.."Achievements"

	if not(AllAchievements[achievementToGet]) then
		return false
	end

	for key,value in pairs(AllAchievements[achievementToGet]) do
		if (value[1] ~= nil) then
			if (value[1][4] ~= nil and value[1][4].Title ~= nil) then
				return true
			end
		else
			if (type(value) == "table") then
				for i,j in pairs(value) do
					if (j[1] ~= nil and j[1][4] ~= nil and j[1][4].Title ~= nil) then
						return true
					end
				end
			end
		end
	end

	return false
end