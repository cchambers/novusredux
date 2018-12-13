require "scriptcommands_UI_goto"

RegisterEventHandler(
	EventType.ClientTargetLocResponse,
	"jump",
	function(success, targetLoc)
		local commandInfo = GetCommandInfo("jump")

		if not (LuaCheckAccessLevel(this, commandInfo.AccessLevel)) then
			return
		end

		if (success) then
			this:RequestClientTargetLoc(this, "jump")
			if (IsPassable(targetLoc)) then
				this:SetWorldPosition(targetLoc)
				this:PlayEffect("TeleportToEffect")
			end
		end
	end
)

RegisterEventHandler(
	EventType.Timer,
	"Clock",
	function()
		local clockWindow = DynamicWindow("ClockWindow", "Clock", 100, 100)
		clockWindow:AddLabel(100, 30, GetGameTimeOfDayString())

		local label = "Broken"
		local isDaytime = not IsNightTime()
		if (isDaytime) then
			label = "Day"
		else
			label = "Night"
		end

		clockWindow:AddLabel(100, 50, label)
		this:OpenDynamicWindow(clockWindow)

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "Clock")
	end
)

RegisterEventHandler(
	EventType.DynamicWindowResponse,
	"ClockWindow",
	function()
		this:RemoveTimer("Clock")
	end
)

UserListPage = 1

function ShowUserList(selectedUser)
	if (selectedUser == nil) then
		selectedUser = this
	end
	local newWindow = DynamicWindow("UserList", "Player List", 450, 530)
	local allPlayers = FindPlayersInRegion()

	if (#allPlayers == 0) then
		table.insert(allPlayers, {Name = "Center", Loc = Loc(0, 0, 0)})
	end

	local scrollWindow = ScrollWindow(20, 40, 380, 375, 25)
	for i, player in pairs(allPlayers) do
		local scrollElement = ScrollElement()

		if ((i - 1) % 2 == 1) then
			scrollElement:AddImage(0, 0, "Blank", 360, 25, "Sliced", "1A1C2B")
		end

		scrollElement:AddLabel(5, 3, player:GetName(), 0, 0, 18)

		local selState = ""
		if (player.Id == selectedUser.Id) then
			selState = "pressed"
		end
		scrollElement:AddButton(340, 3, "select|" .. player.Id, "", 0, 18, "", "", false, "Selection", selState)
		scrollWindow:Add(scrollElement)
	end
	newWindow:AddScrollWindow(scrollWindow)

	-- Goto
	newWindow:AddButton(15, 420, "teleport|" .. selectedUser.Id, "Tele To", 100, 23, "", "", false, "", buttonState)
	newWindow:AddButton(115, 420, "teleportToMe|" .. selectedUser.Id, "Tele Here", 100, 23, "", "", false, "", buttonState)
	newWindow:AddButton(215, 420, "heal|" .. selectedUser.Id, "Heal", 100, 23, "", "", false, "", buttonState)
	newWindow:AddButton(315, 420, "resurrect|" .. selectedUser.Id, "Resurrect", 100, 23, "", "", false, "", buttonState)

	this:OpenDynamicWindow(newWindow)
end

RegisterEventHandler(
	EventType.DynamicWindowResponse,
	"UserList",
	function(user, returnId)
		if (returnId ~= nil) then
			action = StringSplit(returnId, "|")[1]
			playerId = StringSplit(returnId, "|")[2]
			--DebugMessage("action is "..tostring(action))
			--DebugMessage("playerId is "..tostring(playerId))
			if (playerId ~= nil) then
				local playerObj = GetPlayerByNameOrId(playerId)
				if (action == "teleport") then
					if (playerObj ~= nil) then
						this:SetWorldPosition(playerObj:GetLoc())
						this:PlayEffect("TeleportToEffect")
					end
				elseif (action == "teleportToMe") then
					if (playerObj ~= nil) then
						playerObj:PlayEffect("TeleportFromEffect")
						playerObj:SetWorldPosition(this:GetLoc())
						playerObj:PlayEffect("TeleportToEffect")
					end
				elseif (action == "select") then
					local playerObj = GetPlayerByNameOrId(playerId)
					ShowUserList(playerObj)
				elseif (action == "heal") then
					local curHealth = math.floor(GetCurHealth(playerObj))
					local healAmount = GetMaxHealth(playerObj) - curHealth
					SetCurHealth(playerObj, curHealth + healAmount)
					playerObj:PlayEffect("HealEffect")
					this:SystemMessage("Healed " .. playerObj:GetName() .. " for " .. healAmount, "event")
				elseif (action == "resurrect") then
					if (playerObj ~= nil) then
						playerObj:SendMessage("Resurrect", 1.0)
					end
				end
			end
		end
	end
)

isFollowing = false
RegisterEventHandler(
	EventType.ClientTargetGameObjResponse,
	"follow",
	function(target, user)
		if (target ~= nil) then
			if (IsImmortal(user) or ShareGroup(target, user)) then
				local runspeed = ServerSettings.Stats.RunSpeedModifier
				if (IsMounted(this)) then
					runspeed = ServerSettings.Stats.MountSpeedModifier
				end
				user:PathToTarget(target, 1, runspeed)
				isFollowing = true
			end
		end
	end
)

ImmortalCommandFuncs = {
	Who = function(keyword)
		if (not (IsImmortal(this))) then
			this:SystemMessage("Who command has been temporarily disabled.")
			return
		end
		local max = 64
		local total = 0
		local isGod = IsGod(this)
		local online = GlobalVarRead("User.Online")
		for user, y in pairs(online) do
			local name = user:GetCharacterName()
			if (total < max and (keyword == nil or name:match(keyword))) then
				this:SystemMessage(string.format("[FFBF00]%s (%s)[-]", name, user.Id))
			end
			total = total + 1
		end

		local suffix = ""
		if (total > max) then
			suffix = " (List Truncated)"
		end
		if (isGod) then
			this:SystemMessage(string.format("[FFBF00]%d players online.%s[-]", total, suffix))
		end
	end,
	Clock = function()
		this:FireTimer("Clock")
	end,
	WhoDialog = function()
		ShowUserList(this)
	end,
	Cloak = function(nameOrId)
		local targetObj = this
		if (nameOrId ~= nil) then
			targetObj = GetPlayerByNameOrId(nameOrId)
		end

		if (targetObj ~= nil) then
			local isCloaked = targetObj:IsCloaked()
			targetObj:SetCloak(not (isCloaked))
		end
	end,
	TeleportTo = function(nameOrId)
		if (nameOrId ~= nil) then
			if (nameOrId:sub(1, 1) == "$" or nameOrId:sub(1, 1) == "$") then
				local permObj = PermanentObj(tonumber(nameOrId:sub(2)))
				if (permObj ~= nil) then
					this:SetWorldPosition(permObj:GetLoc())
					this:PlayEffect("TeleportToEffect")
				end
			else
				local playerObj = GetPlayerByNameOrId(nameOrId)
				if (playerObj ~= nil) then
					playerObj = playerObj:TopmostContainer() or playerObj
					this:SetWorldPosition(playerObj:GetLoc())
					this:PlayEffect("TeleportToEffect")
				end
			end
		else
			Usage("teleportto")
		end
	end,
	Jump = function()
		this:RequestClientTargetLoc(this, "jump")
	end,
	Goto = function(...)
		local args = table.pack(...)
		if (#args < 1) then
			ShowGoToList()
			return
		end

		local x, y, z = 0, 0, 0
		if (#args == 2) then
			x = tonumber(args[1])
			z = tonumber(args[2])
		else
			x = tonumber(args[1])
			y = tonumber(args[2])
			z = tonumber(args[3])
		end
		if (type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number") then
			return
		end
		this:SetWorldPosition(Loc(x, y, z))
	end,
	Portal = function(...)
		local args = table.pack(...)
		if (#args < 1) then
			Usage("portal")
			return
		end

		local x, y, z = 0, 0, 0
		if (#args == 2) then
			x = tonumber(args[1])
			z = tonumber(args[2])
		else
			x = tonumber(args[1])
			y = tonumber(args[2])
			z = tonumber(args[3])
		end

		OpenTwoWayPortal(this:GetLoc(), Loc(x, y, z), 20)
	end,
	JoinGuild = function(guildId, guildName)
		if (GuildHelpers.Get(this)) then
			this:SystemMessage("You must leave your guild first")
			return
		end

		if (guildId == nil) then
			guildId = NEW_PLAYER_GUILD_ID
			guildName = ServerSettings.Misc.NewPlayerGuildName
		end

		if not (GuildHelpers.GetGuildRecord(guildId)) then
			if (guildName == nil) then
				this:SystemMessage("Guild does not exist, specify a guild name!")
				return
			end
			npGuildRecord = GuildHelpers.Create(nil, guildName, guildId)
		end

		CallFunctionDelayed(
			TimeSpan.FromSeconds(1),
			function(...)
				GuildHelpers.AddToGuild(guildId)
			end
		)

		CallFunctionDelayed(
			TimeSpan.FromSeconds(2),
			function(...)
				local guildRecord = GuildHelpers.GetGuildRecord(guildId)
				GuildHelpers.PromoteMember(this, guildRecord, "Officer", true)
			end
		)
	end,
	Follow = function()
		if (isFollowing) then
			this:ClearPathTarget()
			isFollowing = false
		else
			this:SystemMessage("Select the group member you wish to follow.", "info")
			this:RequestClientTargetGameObj(this, "follow")
		end
	end
}

RegisterCommand {
	Command = "who",
	AccessLevel = AccessLevel.Immortal,
	Func = ImmortalCommandFuncs.Who,
	Desc = "Lists players on the server"
}
RegisterCommand {
	Command = "clock",
	AccessLevel = AccessLevel.Immortal,
	Func = ImmortalCommandFuncs.Clock,
	Desc = "Opens a window that shows the time"
}
RegisterCommand {
	Command = "follow",
	AccessLevel = AccessLevel.Immortal,
	Func = ImmortalCommandFuncs.Follow,
	Desc = "Automatically follow a mob."
}
RegisterCommand {
	Command = "cloak",
	Category = "God Power",
	AccessLevel = AccessLevel.Immortal,
	Func = ImmortalCommandFuncs.Cloak,
	Usage = "[<name|id>]",
	Desc = "[$2476]"
}
RegisterCommand {Command = "reveal", Category = "God Power", AccessLevel = AccessLevel.Immortal, Func = function()
		DoReveal(this)
	end, Desc = "Reveal yourself in a cool cool way."}
RegisterCommand {
	Command = "jump",
	Category = "God Power",
	AccessLevel = AccessLevel.Immortal,
	Func = ImmortalCommandFuncs.Jump,
	Desc = "Get a cursor for a location to jump to"
}
RegisterCommand {
	Command = "gotolocation",
	Category = "God Power",
	AccessLevel = AccessLevel.Immortal,
	Func = ImmortalCommandFuncs.Goto,
	Usage = "[<x>] [<y>] [<z>]",
	Desc = "[$2477]",
	Aliases = {"goto"}
}
RegisterCommand {
	Command = "teleportto",
	Category = "God Power",
	AccessLevel = AccessLevel.Immortal,
	Func = ImmortalCommandFuncs.TeleportTo,
	Usage = "<name|id>",
	Desc = "Teleport to a person by name or an object by id",
	Aliases = {"tpto"}
}
RegisterCommand {
	Command = "portal",
	Category = "God Power",
	AccessLevel = AccessLevel.Immortal,
	Func = ImmortalCommandFuncs.Portal,
	Usage = "[<x>] [<y>] [<z>]",
	Desc = "Open a two way portal to a location on the map"
}
RegisterCommand {
	Command = "whod",
	Category = "God Power",
	AccessLevel = AccessLevel.Immortal,
	Func = ImmortalCommandFuncs.WhoDialog,
	Desc = "List players on server in a dialog window"
}
RegisterCommand {
	Command = "joinguild",
	Category = "God Power",
	AccessLevel = AccessLevel.Immortal,
	Func = ImmortalCommandFuncs.JoinGuild,
	Usage = "[<guild_id>]",
	Desc = "[$2483]"
}
-- this one is in mortal cause its used in replies too
RegisterCommand {
	Command = "tell",
	AccessLevel = AccessLevel.Immortal,
	Func = MortalCommandFuncs.Tell,
	Usage = "<name|id>",
	Desc = "Send a private message to another player."
}
