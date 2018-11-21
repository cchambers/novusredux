
PlayerTitles = {
}

--Note: the way that a title is stored on the player is different from the title list,
--in the title list, it is stored as a table as such
	--[1] = title
	--[2] = minimum value required by the function to add a title
	--[3] = maximum value required by the function to add a title
	--[4] = description of the title

--as stored on the player, the title is stored as such
	--[Title] = title
	--[Handle] = a handle to replace titles with other ones
	--[Description] = the description of the title


--gets a list of all the titles that you can get ingame
function PlayerTitles.GetAllIngameTitles()
	local result = {}
	local count = 1
	for i,j in pairs(AllTitles) do
		for n,k in pairs(j) do
			for l,m in pairs (k) do
				table.insert(result,count,m)
				count = count + 1
			end
		end
	end
	return result,count
end

--gets all titles from all factions
function PlayerTitles.GetAllFactionTitles()
	local result = {}
	local count = 1
	for n,k in pairs(AllTitles.FactionTitles) do
		for l,m in pairs(k) do
			table.insert(result,count,m)
			count = count + 1
		end
	end
	return result,count
end

--gets a list of all faction titles for a given faction
function PlayerTitles.GetFactionTitles(faction)
	local result = {}
	local count = 1
	for l,m in pairs(AllTitles.FactionTitles[faction]) do
		table.insert(result,count,m)
		count = count + 1
	end
	return result,count
end

--gets a list of all skill titles
function PlayerTitles.GetAllSkillTitles()
	local result = {}
	local count = 1
	for n,k in pairs(AllTitles.SkillTitles) do
		for l,m in pairs(k) do
			table.insert(result,count,m)
			count = count + 1
		end
	end
	return result,count
end

--gets a list of all titles you can get from gaining skills
function PlayerTitles.GetSkillTitles(skill)
	local result = {}
	local count = 1
	for n,k in pairs(AllTitles.SkillTitles) do
		if (skill == n) then
			for l,m in pairs(k) do
				table.insert(result,count,m)
				count = count + 1
			end
		end
	end
	return result,count
end

--gets a list of all titles that you can get from doing activities
function PlayerTitles.GetAllActivityTitles()
	local result = {}
	local count = 1
	for n,k in pairs(AllTitles.ActivityTitles) do
		for l,m in pairs(k) do
			table.insert(result,count,m)
			count = count + 1
		end
	end
	return result,count
end

--get a list of all titles that you can get from killing a mob with the key of a template
function PlayerTitles.GetAllMonsterTitles()
	local result = {}
	local count = 1
	if(AllTitles.MonsterTitles ~= nil) then
		for n,k in pairs(AllTitles.MonsterTitles) do
			for l,m in pairs(k) do
				table.insert(result,count,m)
				count = count + 1
			end
		end
	end
	if(AllTitles.MobModuleTitles ~= nil) then
		for n,k in pairs(AllTitles.MobModuleTitles) do
			for l,m in pairs(k) do
				table.insert(result,count,m)
				count = count + 1
			end
		end
	end
	if(AllTitles.MobTeamTitles ~= nil) then
		for n,k in pairs(AllTitles.MobTeamTitles) do
			for l,m in pairs(k) do
				table.insert(result,count,m)
				count = count + 1
			end
		end
	end
	return result,count
end

--get a list of all titles on the player, account and ingame
function PlayerTitles.GetAll(playerObj)
	if( playerObj == nil ) then playerObj = this end

	local allTitles = {}
	local accountTitles = {}

	-- login server based titles
	local customTitleStr = GetCustomTitles(playerObj)
	--DebugMessage(customTitleStr)
	if( customTitleStr ~= nil ) then
		accountTitles = StringSplit(customTitleStr,",")
	end

	for i,j in pairs(accountTitles) do
		local entry = 
		{
			Description = "[D7D700]Account Title[-]",
			Handle = j,
			Title = j,
			IsAccountTitle = true,
		}
		table.insert(allTitles,entry)
	end	
	local gameplayTitles = playerObj:GetObjVar("GameplayTitles")

	if(gameplayTitles ~= nil) then
		for i,j in pairs(gameplayTitles) do
			table.insert(allTitles,j)
		end
	end


	return allTitles
end

--add a gameplay title to the player
function PlayerTitles.Entitle(playerObj,title,makeActive,description,handle)
	if( makeActive == nil ) then makeActive = true end
	--DebugMessage(tostring(playerObj)..tostring(title)..tostring(makeActive)..tostring(description)..tostring(handle))
	if( title ~= nil and title ~= "" ) then

		local gameplayTitles = playerObj:GetObjVar("GameplayTitles") or {}
		local entryToReplace = nil

		--make sure we dont already have the title
		if (handle ~= nil and handle ~= "") then
			--if the handle is the same, replace the old one.
			for i,titleEntry in pairs(gameplayTitles) do
				if( titleEntry.Handle == handle ) then
					entryToReplace = i
				end
			end
		else
			--otherwise check for the title string
			for i,titleStr in pairs(gameplayTitles) do
				if( titleStr.Title == title ) then
					return nil
				end
			end
		end

		if (entryToReplace ~= nil) then
			gameplayTitles[entryToReplace].Description = description or "In-Game Title"
			gameplayTitles[entryToReplace].Handle = handle or ""
			gameplayTitles[entryToReplace].Title = title
		else
			local entry = 
			{
				Description = description or "In-Game Title",
				Handle = handle or "",
				Title = title
			}
			table.insert(gameplayTitles,entry)
		end

		local keepTitle = playerObj:GetObjVar("KeepTitle") or false
		playerObj:SetObjVar("GameplayTitles",gameplayTitles)
		playerObj:SystemMessage("You have earned the title "..title..". (Use /title to choose a title)","event")

		local newIndex = #gameplayTitles

		if( makeActive and keepTitle == false) then
			PlayerTitles.SetTitleByIndex(playerObj,newIndex)
		end

		return newIndex
	end
end

--checks to see if the player has a title
function PlayerTitles.HasTitle(playerObj,title)	
	--LuaDebugCallStack("Titles------------------")	
	--DebugMessage(tostring(playerObj))
	--DebugMessage(playerObj:GetName())
	local customTitleStr = GetCustomTitles(playerObj) or ""	
	local customTitles = StringSplit(customTitleStr,",")
	for i,titleStr in pairs(customTitles) do
		if( titleStr == title ) then
			return true
		end
	end
	
	local gameplayTitles = playerObj:GetObjVar("GameplayTitles") or {}
	for i,titleEntry in pairs(gameplayTitles) do
		if( titleEntry.Title == title ) then
			return true
		end
	end
	
	return false
end

--removes a title from a player's title list
function PlayerTitles.Remove(playerObj,handle)	
	local gameplayTitles = playerObj:GetObjVar("GameplayTitles") or {}
	local newTitles = {}
	local removedTitleEntry = nil
	for i,titleEntry in pairs(gameplayTitles) do
		if not( titleEntry.Handle:find(handle,1,true) ~= nil ) then			
			table.insert(newTitles,titleEntry)
		else
			removedTitleEntry = titleEntry
		end
	end
	playerObj:SetObjVar("GameplayTitles",newTitles)

	if(removedTitleEntry ~= nil and PlayerTitles.GetActiveTitle(playerObj):find(removedTitleEntry.Title,1,true) ~= nil ) then
		PlayerTitles.SetTitleByIndex(playerObj,1)
	end

	return #gameplayTitles - #newTitles
end

--gets the current title on the player
function PlayerTitles.GetActiveTitle(playerObj)
	return this:GetSharedObjectProperty("Title")
end

--sets the player's title from a given index
function PlayerTitles.SetTitleByIndex(playerObj,titleIndex)
	playerObj:SetObjVar("titleIndex",titleIndex)
	playerObj:SendMessage("UpdateTitle")
end

--returns the index in an array of the player's stored useable titles
function PlayerTitles.GetTitleIndex(playerObj,title)
	local allPlayerTitles = PlayerTitles.GetAll(playerObj)
	for i,titleEntry in pairs(gameplayTitles) do
		if ( titleEntry.Title:find(title,1,true) ~= nil ) then
			return i
		end
	end
end

--checks an activity title, specifying a value and a identifier
function PlayerTitles.CheckTitleGain(player,titleTable,value,reference)
	if(titleTable == nil) then
		return
	end
	if (value == nil) then
		LuaDebugCallStack("ERROR: value is nil for CheckTitleGain: ")
		return
	end
	--LuaDebugCallStack("Title Gain")
	--DebugMessage("player is "..tostring(player).."titleTable"..tostring(titleTable).."value"..tostring(value)..tostring(titleTable[1]))
	for i,j in pairs (titleTable) do
		--DebugMessage("value is "..tostring(value).."  j[2] is "..tostring(j[2]).." j[3] is "..tostring(j[3]))
		if (value >= j[2] and value <= j[3] and not PlayerTitles.HasTitle(player,j[1])) then
			PlayerTitles.Entitle(player,j[1],true,j[4])
			player:SendMessage("HandlePlayerTitleAdd",reference)
		end
	end
	--send a message to the player that checks for more title gains
	if (reference ~= nil) then
		player:SendMessage("TitleValueIncrease",reference.."|"..tostring(value))
	end
end

function PlayerTitles.EntitleFromTable(player,titleTable,reference)
	if(titleTable == nil) then
		LuaDebugCallStack("TITLE TABLE IS NIL")
		return
	end
	--LuaDebugCallStack("Title Gain")
	--DebugMessage("player is "..tostring(player).."titleTable"..tostring(titleTable).."value"..tostring(value)..tostring(titleTable[1]))
	for i,j in pairs (titleTable) do
		--DebugMessage("value is "..tostring(value).."  j[2] is "..tostring(j[2]).." j[3] is "..tostring(j[3]))
		PlayerTitles.Entitle(player,j[1],true,j[4])
		player:SendMessage("HandlePlayerTitleAdd",reference)
	end
end