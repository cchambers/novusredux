require "base_player_guild"

function checkGuild(uzr)
	local array = {}

	uzr:SystemMessage("EXCUSE")
	local g = Guild.Get(uzr)

	local resultTable = {}

	if (g == nil) then
		createGuild(uzr)
		return
	end

	-- populate the table with is online
	for id, memberData in pairs(g.Members) do
		if (GlobalVarReadKey("this.Online", GameObj(id))) then
			g.Members[id].IsOnline = true
		end
	end

	-- convert legacy time to datetime
	for id, memberData in pairs(g.Members) do
		if (type(memberData.LastOnline) == "number") then
			memberData.LastOnline = UnixTimeToDateTime(memberData.LastOnline)
		end
	end

	local newWindow = DynamicWindow("GuildWindow", g.Name, 590, 480)

	AddTabMenu(
		newWindow,
		{
			ActiveTab = mCurrentTab,
			Buttons = {
				{Text = "Guild"},
				{Text = "Roster"}
			}
		}
	)

	if (mCurrentTab == "Roster") then
		newWindow:AddImage(8, 52, "BasicWindow_Panel", 554, 340, "Sliced")
		newWindow:AddImage(10, 35, "HeaderRow_Bar", 550, 21, "Sliced")

		newWindow:AddButton(10, 35, "Sort|Name", "Name", 74, 21, "", "", false, "Text")
		newWindow:AddButton(272, 35, "Sort|LastOnline", "Last Online", 132, 21, "", "", false, "Text")
		newWindow:AddButton(402, 35, "Sort|Rank", "Rank", 144, 21, "", "", false, "Text")

		local scrollWindow = ScrollWindow(10, 60, 535, 312, 24)

		for i, memberData in pairs(GetRosterList(g)) do
			local isSelected = mSelectedMemberId == memberData.Id

			local labelColor = (memberData.Entry.IsOnline and "") or "[918369]"

			local scrollElement = ScrollElement()

			local buttonState = isSelected and "pressed" or ""
			scrollElement:AddButton(
				4,
				0,
				"Select|" .. tostring(memberData.Id),
				"",
				522,
				24,
				"",
				"",
				false,
				"ThinFrameHover",
				buttonState
			)

			scrollElement:AddLabel(
				18,
				6,
				labelColor .. StripColorFromString(memberData.Entry.Name) .. "[-]",
				300,
				20,
				18,
				"left"
			)

			if (memberData.Entry.IsOnline) then
				scrollElement:AddLabel(330, 6, labelColor .. "Now[-]", 120, 20, 18, "center")
			else
				scrollElement:AddLabel(
					330,
					6,
					labelColor .. memberData.Entry.LastOnline:ToString("MM/dd/yy") .. "[-]",
					120,
					20,
					18,
					"center"
				)
			end

			scrollElement:AddLabel(466, 6, labelColor .. memberData.Entry.AccessLevel .. "[-]", 120, 20, 18, "center")

			if (isSelected and uzr.Id ~= mSelectedMemberId) then
				local buttons = {}

				if (memberData.Entry.IsOnline) then
					table.insert(buttons, "Message")
					table.insert(buttons, "Invite to Group")
				end

				if (Guild.CanKickMembers(uzr)) then
					table.insert(buttons, "Kick")
				end

				if (Guild.CanBePromotedBy(uzr, GameObj(memberData.Id))) then
					table.insert(buttons, "Promote")
					table.insert(buttons, "Demote")
				end

				if (Guild.GetAccessLevel(uzr, Guild.Get(uzr)) == "Guildmaster") then
					table.insert(buttons, "Transfer Guild")
				end

				if (#buttons > 0) then
					table.insert(buttons, "Cancel")

					local frameHeight = #buttons * 30 + 4
					local yVal = 12 - frameHeight / 2
					scrollElement:AddImage(530, yVal, "SearchBarFrame", 130, frameHeight, "Sliced")
					yVal = yVal + 2
					for i, button in pairs(buttons) do
						scrollElement:AddButton(532, yVal, "Action|" .. button, button, 126, 28, "", "", false, "")
						yVal = yVal + 30
					end
				end
			end

			scrollWindow:Add(scrollElement)
		end

		newWindow:AddScrollWindow(scrollWindow)

		if (mNumPages > 1 and mCurPage > 1) then
			newWindow:AddButton(204, 398, "PrevEnd|", "", 0, 0, "", "", false, "PreviousEnd")
			newWindow:AddButton(217, 398, "Prev|", "", 0, 0, "", "", false, "Previous")
		end

		newWindow:AddLabel(275, 395, "Page " .. mCurPage .. " of " .. mNumPages, 250, 24, 20, "center")

		if (mNumPages > 1 and mCurPage < mNumPages) then
			newWindow:AddButton(327, 398, "Next|", "", 0, 0, "", "", false, "Next")
			newWindow:AddButton(340, 398, "NextEnd|", "", 0, 0, "", "", false, "NextEnd")
		end

		local checkedState = mShowOffline and "pressed" or ""

		newWindow:AddButton(
			10,
			404,
			"ShowOffline|",
			"Show Offline Members",
			110,
			30,
			"",
			"",
			false,
			"Selection2",
			checkedState
		)
	elseif (mCurrentTab == "Guild") then
		newWindow:AddImage(8, 33, "BasicWindow_Panel", 550, 174, "Sliced")
		newWindow:AddLabel(20, 37 + 8, "Guild Information", 250, 40, 24, "", false, false, "SpectralSC-SemiBold")

		local guildInfo = Guild.GetGuildMessage(uzr, g, "Info")
		newWindow:AddLabel(25, 37 + 40, guildInfo, 500, 200, 18)

		newWindow:AddImage(8, 33 + 180, "BasicWindow_Panel", 550, 174, "Sliced")
		newWindow:AddLabel(20, 37 + 180 + 8, "Message of the Day", 250, 40, 24, "", false, false, "SpectralSC-SemiBold")

		local guildMessage = Guild.GetGuildMessage(uzr, g, "MOTD")
		newWindow:AddLabel(25, 37 + 180 + 40, guildMessage, 500, 200, 18)

		if (Guild.HasAccessLevel(uzr, "Officer", g)) then
			newWindow:AddButton(440, 180, "Edit|Info", "", 120, 20, "", "", false, "Invisible")
			newWindow:AddLabel(500, 184, "[9393b3][Edit Message][9393b3]", 120, 20, 18, "center")

			newWindow:AddButton(440, 180 + 180, "Edit|MOTD", "", 120, 20, "", "", false, "Invisible")
			newWindow:AddLabel(500, 184 + 180, "[9393b3][Edit Message][9393b3]", 120, 20, 18, "center")
		end
		newWindow:AddButton(10, 392, "Leave|", "Leave", 110, 30, "", "", false, "")
	end

	uzr:SystemMessage("ME")
	local membersOnline = Guild.GetOnlineMemberCount(uzr, g)
	local membersTotal = CountTable(g.Members)
	local membersOnlineStr = tostring(membersOnline) .. "/" .. tostring(membersTotal)
	newWindow:AddLabel(550, 408, "Members Online: " .. membersOnlineStr, 250, 40, 18, "right")

	uzr:OpenDynamicWindow(newWindow)
end

function createGuild(uzr)
	TextFieldDialog.Show {
		TargetUser = uzr,
		Title = "Create Guild",
		DialogId = "Create Guild",
		Description = "Enter the guild name.",
		ResponseFunc = function(user, newName)
			if (newName ~= nil and newName ~= "") then
				-- dont allow colors in guild names
				newName = StripColorFromString(newName)

				-- DAB TODO: VALIDATE GUILD NAME!
				if (string.len(newName) < 4) then
					TargetUser:SystemMessage("The guild name must longer than 3 characters.")
					return
				end

				if (string.len(newName) > 35) then
					TargetUser:SystemMessage("The guild name must be less than 36 characters.")
					return
				end

				if (#newName:gsub("[%a ]", "") ~= 0) then
					TargetUser:SystemMessage("[$1696]")
					return
				end

				if (ServerSettings.Misc.EnforceBadWordFilter and HasBadWords(newName)) then
					TargetUser:SystemMessage("[$1697]")
					return
				end

				if (g ~= nil) then
					TargetUser:SystemMessage("You are already in a guild")
					return
				end

				local guildInvite = TargetUser:GetObjVar("GuildInvitation")

				if (guildInvite ~= nil) then
					user:SystemMessage("You are already considering joining another guild")
					return
				end

				--TODO GW hack to use same window id for sub window. Should re-work into proper dynamic window state system.
				CallFunctionDelayed(
					TimeSpan.FromSeconds(0.25),
					function()
						createGuildTag(uzr, newName)
					end
				)
			end
		end
	}
end

function createGuildTag(uzr, newName)
	TextFieldDialog.Show {
		TargetUser = uzr,
		Title = "Guild Tag",
		DialogId = "Create Guild",
		Description = "[$1698]",
		ResponseFunc = function(user, tag)
			if (tag ~= nil and tag ~= "") then
				-- dont allow colors in guild names
				tag = StripColorFromString(tag)

				-- DAB TODO: VALIDATE GUILD NAME!
				if (string.len(tag) < 2) then
					TargetUser:SystemMessage("The guild tag must be more than 1 character.")
					return
				end

				if (string.len(tag) > 4) then
					TargetUser:SystemMessage("The guild tag must be less than 4 characters.")
					return
				end

				if (tag:match("%A")) then
					TargetUser:SystemMessage("The guild tag can only contain letters.")
					return
				end

				if (ServerSettings.Misc.EnforceBadWordFilter and HasBadWords(tag)) then
					TargetUser:SystemMessage("[$1699]")
					return
				end

				local g = Guild.Get(TargetUser)

				if (g ~= nil) then
					TargetUser:SystemMessage("You are already in a guild")
					return
				end

				local guildInvite = TargetUser:GetObjVar("GuildInvitation")

				if (guildInvite ~= nil) then
					TargetUser:SystemMessage("You are already considering joining another guild")
					return
				end

				if (Guild.IsTagUnique(tag) == false) then
					TargetUser:SystemMessage("This guild tag is already in use")
					return
				end

				Guild.TryCreate(TargetUser, newName, tag)
			end
		end
	}
end

RegisterEventHandler(
	EventType.Message,
	"UseObject",
	function(user, usedType)
		checkGuild(user)
	end
)
