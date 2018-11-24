-- This list is populated with the RegisterCommand function, all built in commands are
-- registered at the bottom of this file
CommandList = {}

-- Command functions

function GetCommandInfo(commandName)
	for i, commandInfo in pairs(CommandList) do
		if( commandInfo.Command == commandName 
			or (commandInfo.Aliases ~= nil and IsInTableArray(commandInfo.Aliases,commandName)) ) then
			-- we also return the index as the second parameter
			return commandInfo, i		
		end
	end
end

function Usage(commandName)
	local commandInfo = GetCommandInfo(commandName)
	local usageStr = "Usage: /"..commandName
	if( commandInfo.Usage ~= nil ) then
		usageStr = usageStr.." "..commandInfo.Usage
	end
	this:SystemMessage(usageStr)
end	

-- Note: This function replaces any existing command with the same name
-- This makes it easy for mods to replace existing commands
function RegisterCommand(commandInfo)
	if( commandInfo.Func == nil ) then
		DebugMessage("[scriptcommands][RegisterCommand] ERROR: Invalid command function! " .. commandInfo.Command)
	end

	-- remove old command with this name
	local oldCommandInfo, oldIndex = GetCommandInfo(commandInfo.Command)
	if(oldCommandInfo ~= nil) then
		-- unregister the user command event handlers
		local oldCommandNames = oldCommandInfo.Aliases or {}
    	table.insert(oldCommandNames,oldCommandInfo.Command)
    	for i,commandName in pairs(oldCommandNames) do
    		UnregisterEventHandler('scriptcommands',EventType.ClientUserCommand,commandName)
    	end
    	-- replace the old command in the list
    	CommandList[oldIndex] = commandInfo
	else
		-- add this new command to the end
		table.insert(CommandList,commandInfo)
	end

	local commandNames = commandInfo.Aliases or {}
    table.insert(commandNames,commandInfo.Command)

	for i,commandName in pairs(commandNames) do
		RegisterEventHandler(EventType.ClientUserCommand, commandName, 
			function (...)
				if ( LuaCheckAccessLevel(this,commandInfo.AccessLevel) or this:HasObjVar("IsGod") ) then
					if ( this:HasTimer("RecentCommand") ) then return end
					this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.2), "RecentCommand")
					local level = tostring(commandInfo.AccessLevel)
					if(level ~= "Mortal: 1") then 
						local args = {...}
						args["commandName"] = commandName
						this:LogChat("cmd", json.encode(args))
					end
					commandInfo.Func(...)			
				end
			end)
	end
end

-- Helper functions/event handlers for commands

function GetTemplateMatch(templateSearchStr)
	templateList = GetAllTemplateNames()

	-- if we have an exact match, then return it
	if( IsInTableArray(templateList,templateSearchStr) ) then
		return templateSearchStr
	end

	matches = {}
	for i, templateName in pairs(templateList) do		
		if (templateName:find(templateSearchStr) ~= nil) then
			matches[#matches+1] = templateName
		end
	end

	if( #matches == 1 ) then
		return matches[1]
	elseif( #matches > 1 ) then
		resultStr = "Multiple templates match: "
		for i, match in pairs(matches) do
			resultStr = resultStr .. ", " .. match
		end
		this:SystemMessage(resultStr)
		return nil		
	else
		this:SystemMessage("No template matches search string")
	end
end

function GetPlayerByNameOrIdGlobal(partialNameOrId)
	local found = FindGlobalUsers(partialNameOrId)

	if( #found == 0 ) then
		this:SystemMessage("No players found by that name")
	elseif( #found == 1 ) then
		return found[1]
	else
		this:SystemMessage("Multiple matches found (use /command [id] instead)")
		local matches = ""
		for user,y in pairs(found) do
			local name = user:GetCharacterName() or "Unknown"
			matches = string.format("%s%s:%s ,", matches, name, user.Id)
		end
		this:SystemMessage(matches)
	end
end

function GetPlayerByNameOrId(arg)
	if tonumber(arg) ~= nil then
		local targetObj = GameObj(tonumber(arg))
		if( targetObj:IsValid() or isGlobal ) then
			return targetObj		
		else
			this:SystemMessage("No players found by that id")
		end
	else
		local found = GetPlayersByName(arg)
		if( #found == 0 ) then
			this:SystemMessage("No players found by that name")
		elseif( #found == 1 ) then
			return found[1]
		else
			this:SystemMessage("Multiple matches found (use /command [id] instead)")
			local matches = ""
			for index, obj in pairs(found) do
				matches = matches .. obj:GetName() .. ":"..obj.Id..", "
			end
			this:SystemMessage(matches)
		end
	end
end

-- Handlers for commands

RegisterEventHandler(EventType.Message,"PrivateMessage",
	function(sourceName,line,sourceObj)
		if (line == nil) then return end
		this:SystemMessage("[E352EA]From "..StripColorFromString(sourceName)..":[-] "..line.. " (use /r to reply)","custom")
		mLastTeller = sourceObj
		this:SystemMessage("You have received a message.","event")
	end)

RegisterEventHandler(EventType.Message,"transfer",
	function (targetRegion)
		--DebugMessage("GOING to ".. targetRegion .. "! "..this:GetName())	
		this:TransferRegionRequest(targetRegion,Loc(0,0,0))
	end)

require 'scriptcommands_mortal'
if(IsImmortal(this)) then
	require 'scriptcommands_immortal'
end
if(IsDemiGod(this)) then
	require 'scriptcommands_demigod'
end
if(IsGod(this)) then
	require 'scriptcommands_god'
end
