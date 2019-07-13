-- require "account_functions"

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

		local friendObject = GetPlayerByNameOrIdGlobal(sourceObj)

		--If source object is a friend, do not keep show message received system message
		if (IsInFriendList(this, friendObject)) then
			if (not (this:HasTimer("MessageFrom"..sourceObj))) then
				if not (FriendInChatChannel(this, friendObject)) then
					this:SystemMessage("Use /addtochat to add "..friendObject:GetCharacterName().." to the chat channel","custom")
				end
				this:SystemMessage("You have received a message.","event")
			end

			this:ScheduleTimerDelay(TimeSpan.FromMinutes(1),"MessageFrom"..sourceObj)
		else
			this:SystemMessage("You have received a message.","event")
		end
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


-- RegisterCommand{ Command="prestige", AccessLevel = AccessLevel.Mortal, Func=function(a,b,c,d) PrestigeAbilityWindow(this,a,b,c,d) end, Desc="Handy dandy prestige window." }

RegisterCommand {
    Command = "jail",
    AccessLevel = AccessLevel.Immortal,
    Func = function(targetObjId)
        this:RequestClientTargetGameObj(this, "jail")
    end,
    Desc = "Jail a player."
}

RegisterCommand {
    Command = "cd",
    Category = "God Power",
    AccessLevel = AccessLevel.Immortal,
    Func = function()
        local mFrom = 5
        RegisterEventHandler(
            EventType.Timer,
            "countdown",
            function()
                if (mFrom == 0) then
                    this:NpcSpeech("[b][ff0000]FIGHT![-]")
                    this:PlayEffect("ShockwaveEffect")
                    CallFunctionDelayed(TimeSpan.FromSeconds(0.5), function ()
                        this:PlayEffect("BodyExplosion")
                    end)
                    CallFunctionDelayed(TimeSpan.FromSeconds(0.55), function ()
                        ImmortalCommandFuncs.Cloak()
                    end)
                else
                    this:NpcSpeech(tostring("[b][bada55]" .. mFrom .. "[-]"))
                    this:PlayEffect("ImpactWaveEffect")
                    mFrom = mFrom - 1
                    this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "countdown")
                end
            end
        )

        this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "countdown")

    end,
    Desc = "Countdown."
}

RegisterCommand {
    Command = "exit",
    Category = "God Power",
    AccessLevel = AccessLevel.Immortal,
    Func = function()
        this:PlayEffect("BodyExplosion")
        CallFunctionDelayed(TimeSpan.FromSeconds(0.1), ImmortalCommandFuncs.Cloak)
    end,
    Desc = "Exit in a cool cool way."
}

RegisterCommand {
    Command = "pets",
    Category = "Mortal Power",
    AccessLevel = AccessLevel.Mortal,
    Func = function()
        local remaining = GetRemainingActivePetSlots(this)
        local max = MaxActivePetSlots(this)
        this:SystemMessage(tostring("You can control " .. max .. " slots worth of pets."))
        this:SystemMessage(tostring("You have " .. remaining .. " remaining slots open."))
    end,
    Desc = "Check pet slots."
}


RegisterCommand {
    Command = "cw",
    Category = "Mortal Power",
    AccessLevel = AccessLevel.Mortal,
    Func = function()
        local open = GlobalVarReadKey("ColorWar.Registration", "open")
        if (open) then
            local queued = GlobalVarReadKey("ColorWar.Queue", this)
            if (queued) then
                GlobalVarWrite("ColorWar.Queue", nil, function (record) 
                    record[this] = nil
                    return true
                end)
                this:SystemMessage("You have been de-queued.", "info")
            else
                GlobalVarWrite("ColorWar.Queue", nil, function (record) 
                    record[this] = true
                    return true
                end)
                this:SystemMessage("You will be summoned soon, store everything and get ready!", "info")
            end
        else
            this:SystemMessage("Color Wars entry is not open at this time.", "info")
        end
    end,
    Desc = "Join or leave color war queue."
}


RegisterCommand {
    Command = "cwvote",
    Category = "Mortal Power",
    AccessLevel = AccessLevel.Mortal,
    Func = function()
        -- Is the vote running?
        ColorWarVote(this)
    end,
    Desc = "Start or join a ColorWar vote."
}


-- RegisterCommand {
-- 	Command = "pve",
-- 	Category = "Mortal Power",
-- 	AccessLevel = AccessLevel.Mortal,
-- 	Func = function(user, buttonId)
--         ClientDialog.Show {
--             TargetUser = user,
--             DialogId = "CareBear" .. user.Id,
--             TitleStr = "CONVERT TO PvE ONLY",
--             DescStr = string.format("This will PERMANENTLY alter your character! If you enter PvE mode, you will never be able to participate in PvP with this character. Are you sure you want to be Player vs Environment only?"),
--             Button1Str = "Continue",
--             Button2Str = "Cancel",
--             ResponseObj = user,
--             ResponseFunc = function(user, buttonId)
--                 local buttonId = tonumber(buttonId)
--                 if (user == nil or buttonId == nil) then
--                     return
--                 end
--                 -- Handles the invite command of the dynamic window
--                 if (buttonId == 0) then
--                     user:SetObjVar("CareBear", true)
--                     return
--                 end
--             end
--         }
--     end,
-- 	Desc = "Exit in a cool cool way."
-- }

RegisterCommand {
    Command = "fixtracks",
    AccessLevel = AccessLevel.Mortal,
    Func = function()
        this:DelObjVar("TrackedSkills")
        this:DelObjVar("SkillFavorites")
        this:SystemMessage("Your tracked and favorited skills have been reset.")
    end,
    Desc = "Reset your tracked skills."
}

RegisterCommand {
    Command = "credit",
    AccessLevel = AccessLevel.Mortal,
    Func = function()
        local credit = this:GetObjVar("Credits") or 0
        this:SystemMessage("You are the proud owner of [bada55]" .. credit .. "[-] Credits.", "info")
    end,
    Desc = "Reset your tracked skills."
}

RegisterCommand {
    Command = "setjail",
    AccessLevel = AccessLevel.Immortal,
    Func = function()
        this:RequestClientTargetLoc(this, "set_jail_loc")
    end,
    Desc = "Sets the jail location in the world."
}

RegisterEventHandler(
    EventType.ClientTargetGameObjResponse,
    "jail",
    function(target, user)
        if (target == nil) then
            return
        end
        local user_id = target:GetAttachedUserId()

        WriteAccountVar(user_id, "jail", "jailLocation", target:GetLoc())
        WriteAccountVar(user_id, "jail", "isJailed", true)
        WriteAccountVar(user_id, "jail", "jailTime", os.time())
        WriteAccountVar(user_id, "jail", "sentence", 240)
        WriteAccountVar(user_id, "jail", "characterJailed", tostring(target))

        target:SetObjVar("NoGains", true)

        local jail_settings = GlobalVarRead("settings_jail")

        local jailLocation = jail_settings["location"]

        DoSlay(target)

        target:SetWorldPosition(jailLocation)

        this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1500), "resurrectTimer")

        RegisterEventHandler(
            EventType.Timer,
            "resurrectTimer",
            function()
                target:SystemMessage(
                    "You were just jailed, until your sentence is served you can only log in to this character, any attempt to login to another character will kick you automatically. You can pick up horse maneure to speed up your release."
                )
                target:SendMessage("PlayerResurrect", this, nil, true)
            end
        )
    end
)

RegisterEventHandler(
    EventType.ClientTargetLocResponse,
    "set_jail_loc",
    function(success, location, objectSelected)
        this:SystemMessage(tostring(location))
        WriteAccountVar("settings", "jail", "location", location)
    end
)
