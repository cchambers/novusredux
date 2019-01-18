require "incl_player_titles"
require "incl_gametime"
require "scriptcommands_UI_customcommand"
require "base_player_guild"
require "base_allegiance_window"
require "base_player_emotes"
require "base_bug_report"

MortalCommandFuncs = {
	-- Mortal Commands

	Page = function()
		this:AddModule("page_gm")
	end,

	Help = function(commandName)
		if (commandName ~= nil) then
			if (commandName == "actions") then
				local emotesStr = ""
				for commandName, animName in pairs(Emotes) do
					emotesStr = emotesStr .. "/" .. commandName .. ", "
				end
				emotesStr = StripTrailingComma(emotesStr)
				this:SystemMessage("Emotes: " .. emotesStr)
			else
				local commandInfo = GetCommandInfo(commandName)
				if (commandInfo == nil) then
					this:SystemMessage("Invalid command")
				elseif (not (LuaCheckAccessLevel(this, commandInfo.AccessLevel) or this:HasObjVar("IsGod"))) then
					this:SystemMessage("You do not have the power to use that command.")
				else
					local usageStr = "Usage: /" .. commandName
					if (commandInfo.Usage ~= nil) then
						usageStr = usageStr .. " " .. commandInfo.Usage
					end
					this:SystemMessage(usageStr)
					if (commandInfo.Desc ~= nil) then
						this:SystemMessage(commandInfo.Desc)
					end
				end
			end
		else
			local outStr = "Available Commands: "
			for i, commandInfo in pairs(CommandList) do
				if (LuaCheckAccessLevel(this, commandInfo.AccessLevel) or this:HasObjVar("IsGod")) then
					outStr = outStr .. commandInfo.Command .. ", "
				end
			end
			this:SystemMessage(outStr)
			this:SystemMessage("Type /help <command> to get more info.")
			this:SystemMessage("For a list of emotes type /help actions")
		end
	end,
	Title = function()
		ToggleAchievementWindow(this)
	end,
	Achievement = function()
		ToggleAchievementWindow(this)
	end,
	Autoharvesting = function()
		if (this:HasObjVar("NoQueueHarvest")) then
			this:SystemMessage("Autoharvesting of resources enabled.")
			this:DelObjVar("NoQueueHarvest")
		else
			this:SystemMessage("Autoharvesting of resources disabled.")
			this:SetObjVar("NoQueueHarvest", true)
		end
	end,
	Say = function(...)
		local line = CombineArgs(...)
		this:LogChat("say", json.encode(line))
		if (IsDead(this)) then
			local oos = {"o", "O", "oO", "Oo"}
			local spiritSpoken = line
			local ghostTalk =
				line:gsub(
				"%S",
				function()
					return oos[math.random(1, #oos)]
				end
			)
			this:PlayerSpeech(ghostTalk, 30)
			local nearbyPlayers = FindObjects(SearchPlayerInRange(25))
			for i, v in pairs(nearbyPlayers) do
				if (HasMobileEffect(v, "SpiritSpeak")) then
					this:NpcSpeechToUser(spiritSpoken, v, "info")
					CheckSkillChance(v, "SpiritSpeak")
				end
			end
		else
			this:PlayerSpeech(line, 30)
		end
	end,
	Roll = function(...)
		if (this:HasTimer("AntiSpamTimer")) then
			return
		end
		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(500), "AntiSpamTimer")

		local args = table.pack(...)
		local lower = math.max(1, tonumber(args[1]) or 1)
		local upper = math.min(1000, tonumber(args[2]) or 100)
		if (lower > upper) then
			local temp = upper
			upper = lower
			lower = temp
		end
		local name = StripColorFromString(this:GetName())
		local roll = math.random(lower, upper)
		local message = string.format("%s rolls %d (%d-%d)", name, roll, lower, upper)
		this:SystemMessage(message)
		local nearbyPlayers = FindObjects(SearchPlayerInRange(30))
		for i = 1, #nearbyPlayers do
			nearbyPlayers[i]:SystemMessage(message)
		end
	end,
	Stats = function()
		this:SystemMessage("Str:" .. GetStr(this) .. ",  Agi:" .. GetAgi(this) .. ",  Int:" .. GetInt(this))
		this:SystemMessage(
			"Health:" ..
				GetCurHealth(this) .. "/" .. GetMaxHealth(this) .. " Regen:" .. math.floor(GetHealthRegen(this) * 10) / 10
		)
		this:SystemMessage(
			"Stam:" ..
				GetCurStamina(this) .. "/" .. GetMaxStamina(this) .. " Regen:" .. math.floor(GetStaminaRegen(this) * 10) / 10
		)
		this:SystemMessage(
			"Mana:" .. GetCurMana(this) .. "/" .. GetMaxMana(this) .. " Regen:" .. math.floor(GetManaRegen(this) * 10) / 10
		)
	end,
	Where = function()
		local loc = this:GetLoc()
		local locX = string.format("%.2f", loc.X)
		local locY = string.format("%.2f", loc.Y)
		local locZ = string.format("%.2f", loc.Z)
		local facing = string.format("%.0f", this:GetFacing())
		local regions = GetRegionsAtLoc(loc)
		local regionStr = ""
		for i, regionName in pairs(regions) do
			regionStr = regionStr .. regionName .. ", "
		end

		local regionAddress = ServerSettings.RegionAddress
		if (regionAddress ~= nil and regionAddress ~= "") then
			this:SystemMessage("Region Address: " .. regionAddress)
		end

		if (IsGod(this)) then
			local ClusterId = ServerSettings.ClusterId
			if (ClusterId ~= nil and ClusterId ~= "") then
				this:SystemMessage("ClusterId: " .. ServerSettings.ClusterId)
			end
			this:SystemMessage("World: " .. ServerSettings.WorldName)
			this:SystemMessage("Subregions: " .. regionStr)
		end

		this:SystemMessage("Loc: " .. locX .. ", " .. locY .. ", " .. locZ .. ", Facing: " .. tostring(facing))
	end,
	GroupLeave = function(...)
		local groupId = GetGroupId(this)

		if (groupId == nil) then
			this:SystemMessage("You are not in a group.", "info")
			return
		end

		ClientDialog.Show {
			TargetUser = this,
			DialogId = uuid(),
			TitleStr = "Leave Group",
			DescStr = "Are you sure you wish to leave your group?",
			Button1Str = "Confirm",
			Button2Str = "Cancel",
			ResponseFunc = function(user, buttonId)
				if (user == nil or buttonId ~= 0) then
					return
				end

				GroupRemoveMember(groupId, this)
			end
		}
	end,
	GroupMessage = function(...)
		GroupSendChat(this, ...)
	end,
	GuildMessage = function(...)
		Guild.SendMessage(...)
	end,
	GuildMenu = function()
		ToggleGuildWindow()
	end,
	AllegianceMenu = function()
		ToggleAllegianceWindow()
	end,
	Time = function()
		this:SystemMessage("It is " .. GetGameTimeOfDayString())
	end,
	Hunger = function()
		if (this:HasTimer("CheckedHunger")) then
			return
		end
		local hunger = this:GetObjVar("Hunger") or 0
		if (hunger < ServerSettings.Hunger.Threshold) then
			local tillHungry =
				TimeSpan.FromSeconds(((ServerSettings.Hunger.Threshold - hunger) / ServerSettings.Hunger.Rate) * 60)

			this:SystemMessage("You will be hungry in " .. TimeSpanToWords(tillHungry))
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(60), "CheckedHunger")
		else
			this:SystemMessage("You are hungry.")
		end
	end,
	Resethotbar = function()
		WipeHotbarData()
		this:SystemMessage("Your hotbars have been reset, please log out and then back in.")
	end,
	CustomCommand = function()
		ShowCustomCommandWindow()
	end,
	DeleteChar = function()
		local createdAt = this:GetObjVar("CreationDate")
		if (createdAt) then
			local totalTime = DateTime.UtcNow - createdAt
			local overrideExists = (this:GetObjVar("AllowCharDelete") ~= nil)
			if (totalTime.TotalDays < ServerSettings.NewPlayer.MinimumDeleteDays and overrideExists == false) then
				this:SystemMessage(
					"Your character must be at least " ..
						ServerSettings.NewPlayer.MinimumDeleteDays ..
							" days old before it can be deleted. This character has existed for " .. TimeSpanToWords(totalTime) .. "."
				)
				return
			end
		end
		TextFieldDialog.Show {
			TargetUser = this,
			Title = "Delete Character",
			Description = "[$2467]",
			ResponseFunc = function(user, newValue)
				if (newValue == "DELETE") then
					-- remove from guild (function does nothing if not in a guild)
					Guild.Remove(this)

					local clusterController = GetClusterController()
					clusterController:SendMessage("UserLogout", this, true)

					this:DeleteCharacter()
				else
					this:SystemMessage("Delete character cancelled")
				end
			end
		}
	end,
	PlayTime = function()
		this:SystemMessage(
			"You have played for a total of " .. TimeSpanToWords(TimeSpan.FromMinutes(this:GetObjVar("PlayMinutes") or 1))
		)
	end,
	BugReport = function()
		OpenBugReportDialog(this)
	end,
	HelpReport = function()
		if not (this:HasModule("help_report_window")) then
			this:AddModule("help_report_window")
		end
	end,
	ResetWindowPos = function()
		this:SendClientMessage("ClearCachedPanelPositions")
	end,
	Karma = function()
		if not (this:HasModule("karma_window")) then
			this:AddModule("karma_window")
		else
			this:SendMessage("CloseKarmaWindow")
		end
	end,
	Tell = function(userNameOrId, ...)
		if (userNameOrId == nil) then
			Usage("tell")
			return
		end

		local line = CombineArgs(...)
		if (line ~= nil) then
			local player = GetPlayerByNameOrIdGlobal(userNameOrId)
			if (player ~= nil) then
				local name = player:GetCharacterName() or "Unknown"
				local encoded = json.encode(line)
				local msgtype = 'tell","tellto":"' .. name
				this:LogChat(msgtype, encoded)

				player:SendMessageGlobal("PrivateMessage", this:GetName(), line, this.Id)
				this:SystemMessage("[E352EA]To " .. name .. ":[-] " .. line, "custom")
			end
		end
	end,
	ReplyTell = function(...)
		MortalCommandFuncs.Tell(mLastTeller, ...)
	end
}

RegisterCommand {
	Command = "help",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.Help,
	Usage = "<command_name>",
	Desc = "[$2471]"
}
RegisterCommand {
	Command = "title",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.Title,
	Desc = "Show title window"
}
RegisterCommand {
	Command = "achievement",
	Accesslevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.Achievement,
	Desc = "Show achievement window"
}
RegisterCommand {
	Command = "bugreport",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.Page,
	Desc = "Send a bug report"
}
RegisterCommand {
	Command = "helpreport",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.Page,
	Desc = "Send a help report"
}
RegisterCommand {
	Command = "say",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.Say,
	Desc = "Say something."
}
RegisterCommand {
	Command = "roll",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.Roll,
	Desc = "Roll between 0.0 and 100.0"
}
RegisterCommand {
	Command = "stats",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.Stats,
	Desc = "Prints out your stats"
}
RegisterCommand {
	Command = "where",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.Where,
	Desc = "Prints location on the map"
}
RegisterCommand {
	Command = "g",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.GuildMessage,
	Desc = "Sends a guild message"
}
RegisterCommand {
	Command = "r",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.ReplyTell,
	Desc = "Reply to a direct message."
}
--RegisterCommand{ Command="allegiance", AccessLevel = AccessLevel.Mortal, Func=MortalCommandFuncs.AllegianceMessage, Desc="[$2472]" }
RegisterCommand {
	Command = "guild",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.GuildMenu,
	Desc = "Open guild window"
}
RegisterCommand {
	Command = "allegiance",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.AllegianceMenu,
	Desc = "Open allegiance window"
}
RegisterCommand {
	Command = "karma",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.Karma,
	Desc = "Give you details and options regarding Karma."
}
RegisterCommand {
	Command = "group",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.GroupMessage,
	Desc = "Sends a group message",
	Aliases = {"gr", "party", "p"}
}
RegisterCommand {
	Command = "leavegroup",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.GroupLeave,
	Desc = "Leaves your group."
}
RegisterCommand {
	Command = "time",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.Time,
	Desc = "Gets the current game time"
}
RegisterCommand {
	Command = "autoharvest",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.Autoharvesting,
	Desc = "Toggles autoharvesting on and off."
}
RegisterCommand {
	Command = "custom",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.CustomCommand,
	Desc = "[$2474]"
}
RegisterCommand {
	Command = "deletechar",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.DeleteChar,
	Desc = "Permanently deletes your player character.",
	Aliases = {"delchar", "deletecharacter", "delcharacter"}
}
RegisterCommand {
	Command = "playtime",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.PlayTime,
	Desc = "Tells you your total ingame time.",
	Aliases = {"timeplayed", "totaltime"}
}
RegisterCommand {
	Command = "resethotbar",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.Resethotbar,
	Usage = "<command_name>",
	Desc = "Resets your hotbars removing all items."
}
RegisterCommand {
	Command = "hunger",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.Hunger,
	Desc = "Displays your current hunger status"
}
RegisterCommand {
	Command = "resetwindowpos",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.ResetWindowPos,
	Desc = "Resets the saved window positions on the client. Used if one of your windows gets stuck off screen."
}
RegisterCommand {
	Command = "page",
	AccessLevel = AccessLevel.Mortal,
	Func = MortalCommandFuncs.Page,
	Desc = "Page the staff."
}
