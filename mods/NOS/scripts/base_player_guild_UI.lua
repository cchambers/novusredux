require 'NOS:base_player_guild'

mCurrentTab = "Guild"
mSortOrder = {"LastOnline","Rank","Name"}
mSortDirection = {LastOnline=true,Rank=true,Name=true}
mItemsPerPage = 30
mShowOffline = true
mCurPage = 1
mNumPages = 0
mSelectedMemberId = nil
mGuildWindowOpen = false

function ShowMessageEditWindow(messageType)
	TextFieldDialog.Show{
        TargetUser = this,
        DialogId = "Edit Guild " ..messageType,
        Title = "Edit Guild "..messageType,
        Description = "",
        ResponseFunc = function(user,newName)
        	if(newName ~= nil and newName ~= "") then
        		-- dont allow colors in guild names
        		newName = StripColorFromString(newName)
        		
        		-- DAB TODO: VALIDATE GUILD NAME!
        		if (string.len(newName) > 250) then
			 		this:SystemMessage("The message must be less than 250 characters.","info")
			 		return
			 	end

				Guild.SetGuildMessage(this,nil,messageType,newName)
				
				CallFunctionDelayed(TimeSpan.FromSeconds(1),GuildInfo)
	        end
        end
    }
end

function ShowLeaveGuildConfirm()
	local g = GuildHelpers.Get(this)

	if (g == nil) then
		user:SystemMessage("You are not in a guild","info");
		return
	end

	if (this == g.Leader) then
		ClientDialog.Show{
			TargetUser = this,
			DialogId = "Disband Guild Confirm",
		    TitleStr = "Disband Guild",
		    DescStr = "Are you sure you wish to disband your guild?",
		    Button1Str = "Confirm",
		    Button2Str = "Cancel",
			ResponseFunc=function(user,buttonId)
				--DebugMessage("Guild: Handle Guild Invite Response");
				if (user == nil) then return end

				if (buttonId == nil) then return end

				-- Handles the invite command of the dynamic window
				if (buttonId == 0) then
					Guild.Disband(this)
					this:CloseDynamicWindow("GuildWindow")
					mGuildWindowOpen = false
					return
				end
			end,
		}
	else
		ClientDialog.Show{
			TargetUser = this,
			DialogId = "Leave Guild Confirm",
		    TitleStr = "Leave Guild",
		    DescStr = "Are you sure you wish to leave your guild?",
		    Button1Str = "Confirm",
		    Button2Str = "Cancel",
			ResponseFunc=function(user,buttonId)
				--DebugMessage("Guild: Handle Guild Invite Response");
				if (user == nil) then return end

				if (buttonId == nil) then return end

				-- Handles the invite command of the dynamic window
				if (buttonId == 0) then
					Guild.Remove(user, g)
					this:CloseDynamicWindow("GuildWindow")
					mGuildWindowOpen = false
					return
				end
			end,
		}			
	end		
end

function GetRosterList(g)		
	local resultTable = {}
	for mobileId,entry in pairs(g.Members) do
		if(mShowOffline or entry.IsOnline) then
			local arrayEntry = { Id=mobileId, Entry=entry}
			table.insert(resultTable,arrayEntry)
		end
	end	

	local totalItems = #resultTable

	table.sort(resultTable,
		function(a,b)
			for i,sortType in pairs(mSortOrder) do
				if(sortType == "Name") then
					local nameA = StripColorFromString(a.Entry.Name:lower())
					local nameB = StripColorFromString(b.Entry.Name:lower())
					if(nameA < nameB) then
						return mSortDirection.Name
					elseif(nameB < nameA) then
						return not(mSortDirection.Name)
					end
				elseif(sortType == "Rank") then
					local rankA = GuildHelpers.GetAccessLevelIndex(a.Entry.AccessLevel)
					local rankB = GuildHelpers.GetAccessLevelIndex(b.Entry.AccessLevel)
					if( rankA < rankB ) then
						return mSortDirection.Rank
					elseif(rankB < rankA ) then
						return not(mSortDirection.Rank)
					end					
				elseif(sortType == "LastOnline") then
					if(a.Entry.IsOnline and not b.Entry.IsOnline) then
						return mSortDirection.LastOnline
					elseif(b.Entry.IsOnline and not a.Entry.IsOnline) then
						return not(mSortDirection.LastOnline)
					end

					if(a.Entry.LastOnline > b.Entry.LastOnline) then
						return mSortDirection.LastOnline
					elseif(b.Entry.LastOnline > a.Entry.LastOnline) then
						return not(mSortDirection.LastOnline)
					end
				end
			end
			-- all things equal
			return true
		end)

	mNumPages = math.ceil(totalItems / mItemsPerPage)
	if(mCurPage > mNumPages) then
		mCurPage = mNumPages
	end

	local startIndex = ((mCurPage - 1) * mItemsPerPage) + 1
	local endIndex = startIndex + mItemsPerPage

	local trimmedTable = {}
	for i=startIndex,endIndex do
		table.insert(trimmedTable,resultTable[i])
	end

	return trimmedTable
end

function GuildInfo()
	local array = {}

	local g = GuildHelpers.Get(this)

	local resultTable = {}

	if (g == nil) then		
		this:SystemMessage("You are not in a guild","info");
		return
	end

	mGuildWindowOpen = true

	-- populate the table with is online
	for id,memberData in pairs(g.Members) do
		if ( GlobalVarReadKey("User.Online", GameObj(id)) ) then
	    	g.Members[id].IsOnline = true
	    end
	end

	-- convert legacy time to datetime
	for id,memberData in pairs(g.Members) do 
		if(type(memberData.LastOnline) == "number") then
			memberData.LastOnline = UnixTimeToDateTime(memberData.LastOnline)
		end
	end

	local newWindow = DynamicWindow("GuildWindow",g.Name,590,480)

	AddTabMenu(newWindow,
	{
        ActiveTab = mCurrentTab, 
        Buttons = {
			{ Text = "Guild" },
			{ Text = "Roster" },
        }
    })	

	if(mCurrentTab == "Roster") then		
		newWindow:AddImage(8,52,"BasicWindow_Panel",554,340,"Sliced")
		newWindow:AddImage(10,35,"HeaderRow_Bar",550,21,"Sliced")

		newWindow:AddButton(10,35,"Sort|Name","Name",74,21,"","",false,"Text")
		newWindow:AddButton(272,35,"Sort|LastOnline","Last Online",132,21,"","",false,"Text")
		newWindow:AddButton(402,35,"Sort|Rank","Rank",144,21,"","",false,"Text")		

		local scrollWindow = ScrollWindow(10,60,535,312,24)		

		for i,memberData in pairs(GetRosterList(g)) do
			local isSelected = mSelectedMemberId == memberData.Id

			local labelColor = (memberData.Entry.IsOnline and "") or "[918369]"

			local scrollElement = ScrollElement()

			local buttonState = isSelected and "pressed" or ""
			scrollElement:AddButton(4,0,"Select|"..tostring(memberData.Id),"",522,24,"","",false,"ThinFrameHover",buttonState)

			scrollElement:AddLabel(18,6,labelColor..StripColorFromString(memberData.Entry.Name).."[-]",300,20,18,"left")	

			if(memberData.Entry.IsOnline) then
				scrollElement:AddLabel(330,6,labelColor.."Now[-]",120,20,18,"center")	
			else
				scrollElement:AddLabel(330,6,labelColor..memberData.Entry.LastOnline:ToString("MM/dd/yy").."[-]",120,20,18,"center")					
			end

			scrollElement:AddLabel(466,6,labelColor..memberData.Entry.AccessLevel.."[-]",120,20,18,"center")	

			if(isSelected and this.Id ~= mSelectedMemberId) then
				local buttons = {}

				if(memberData.Entry.IsOnline) then
					table.insert(buttons,"Message")
					table.insert(buttons,"Invite to Group")
				end

				if(Guild.CanKickMembers(this, GameObj(memberData.Id))) then
					table.insert(buttons,"Kick")
				end

				if(Guild.CanBePromotedBy(this,GameObj(memberData.Id))) then
					table.insert(buttons,"Promote")
					table.insert(buttons,"Demote")
				end

				if (GuildHelpers.GetAccessLevel(this, GuildHelpers.Get(this)) == "Guildmaster") then
					table.insert(buttons,"Transfer Guild")
				end

				if(#buttons > 0) then
					table.insert(buttons,"Cancel")

					local frameHeight = #buttons * 30 + 4
					local yVal = 12 - frameHeight/2
					scrollElement:AddImage(530,yVal,"BasicWindow_Panel",130,frameHeight,"Sliced")
					yVal = yVal + 2
					for i,button in pairs(buttons) do
						scrollElement:AddButton(532,yVal,"Action|"..button,button,126,28,"","",false,"")
						yVal = yVal + 30
					end
				end
			end

			scrollWindow:Add(scrollElement)
		end

		newWindow:AddScrollWindow(scrollWindow)

		if(mNumPages > 1 and mCurPage > 1) then
			newWindow:AddButton(204,398,"PrevEnd|","",0,0,"","",false,"PreviousEnd")
			newWindow:AddButton(217,398,"Prev|","",0,0,"","",false,"Previous")
		end

		newWindow:AddLabel(275,395,"Page "..mCurPage.." of "..mNumPages,250,24,20,"center")	

		if(mNumPages > 1 and mCurPage < mNumPages) then
			newWindow:AddButton(327,398,"Next|","",0,0,"","",false,"Next")
			newWindow:AddButton(340,398,"NextEnd|","",0,0,"","",false,"NextEnd")
		end

		local checkedState = mShowOffline and "pressed" or ""

		newWindow:AddButton(10,404,"ShowOffline|","Show Offline Members",110,30,"","",false,"Selection2",checkedState)
		
	elseif (mCurrentTab == "Guild") then
		newWindow:AddImage(8,33,"BasicWindow_Panel",550,174,"Sliced")
		newWindow:AddLabel(20,37+8,"Guild Information",250,40,24,"",false,false,"SpectralSC-SemiBold")		

		local guildInfo = GuildHelpers.GetGuildMessage(this,g,"Info")
		newWindow:AddLabel(25,37+40,guildInfo,500,200,18)		

		newWindow:AddImage(8,33+180,"BasicWindow_Panel",550,174,"Sliced")
		newWindow:AddLabel(20,37+180+8,"Message of the Day",250,40,24,"",false,false,"SpectralSC-SemiBold")		

		local guildMessage = GuildHelpers.GetGuildMessage(this,g,"MOTD")
		newWindow:AddLabel(25,37+180+40,guildMessage,500,200,18)

		if(Guild.HasAccessLevel(this,"Officer",g)) then
			newWindow:AddButton(440,180,"Edit|Info","",120,20,"","",false,"Invisible")
			newWindow:AddLabel(500,184,"[9393b3][Edit Message][9393b3]",120,20,18,"center")	

			newWindow:AddButton(440,180+180,"Edit|MOTD","",120,20,"","",false,"Invisible")
			newWindow:AddLabel(500,184+180,"[9393b3][Edit Message][9393b3]",120,20,18,"center")	
		end
		newWindow:AddButton(10,392,"Leave|","Leave",110,30,"","",false,"")
	end

	local membersOnline = GuildHelpers.GetOnlineMemberCount(this,g)
	local membersTotal = CountTable(g.Members)
	local membersOnlineStr = tostring(membersOnline) .. "/" .. tostring(membersTotal)
	newWindow:AddLabel(550,408,"Members Online: "..membersOnlineStr,250,40,18,"right")

	this:OpenDynamicWindow(newWindow)
end
RegisterEventHandler(EventType.Message,"UpdateGuildInfo",
	function()
		if(mGuildWindowOpen) then
			GuildInfo()
		end
	end)
RegisterEventHandler(EventType.Message,"OpenGuildInfo",GuildInfo)

RegisterEventHandler(EventType.DynamicWindowResponse,"GuildWindow",
	function ( user, buttonId )
		local result = StringSplit(buttonId,"|")
		local action = result[1]
		local arg = result[2]
		--DebugMessage("DynamicWindowResponse",action,arg)

		local newTab = HandleTabMenuResponse(buttonId)
		if(newTab) then
			mCurrentTab = newTab
			GuildInfo()
		elseif(action == "Edit") then
			ShowMessageEditWindow(arg)
		elseif(action == "Leave") then
			ShowLeaveGuildConfirm()
		elseif(action == "ShowOffline") then
			mShowOffline = not(mShowOffline)
			GuildInfo()
		elseif(action == "Next" and mCurPage ~= mNumPages) then
			mCurPage = mCurPage + 1
			GuildInfo()
		elseif(action == "NextEnd" and mCurPage ~= mNumPages) then
			mCurPage = mNumPages
			GuildInfo()
		elseif(action == "Prev" and mCurPage > 1) then
			mCurPage = mCurPage - 1
			GuildInfo()
		elseif(action == "PrevEnd" and mCurPage > 1) then
			mCurPage = 1
			GuildInfo()
		elseif(action == "Sort" ) then
			if(mSortOrder[1] ~= arg) then
				RemoveFromArray(mSortOrder,arg)
				table.insert(mSortOrder,1,arg)
				--DebugMessage(DumpTable(mSortOrder))				
			else
				mSortDirection[arg] = not(mSortDirection[arg])
				--DebugMessage("SortDir",arg,mSortDirection[arg])
			end
			GuildInfo()
		elseif(action == "Select") then
			mSelectedMemberId = tonumber(arg)
			GuildInfo()
		elseif(action == "Action") then
			if(arg == "Message") then
				this:SendClientMessage("EnterChat","/tell " .. mSelectedMemberId .." ")
			elseif(arg == "Invite to Group") then
				local memberObj = GameObj(mSelectedMemberId)
				local groupId = GetGroupId(this)
				if( groupId ~= nil and GetGroupVar(groupId, "Leader") ~= this ) then
					this:SystemMessage("You are not the leader of your group.", "info")
				else
					GroupInvite(this, memberObj)
				end
			elseif(arg == "Kick") then
				local g = GuildHelpers.Get(this)
				if(g == nil or g.Members[mSelectedMemberId] == nil) then return end

				local kickMember = GameObj(mSelectedMemberId)
				local kickName = g.Members[mSelectedMemberId].Name or "him"
				
				if (Guild.CanKickMembers(this,kickMember)) then
					ClientDialog.Show{
						TargetUser = this,
						DialogId = "Kick Guild Member:"..mSelectedMemberId,
					    TitleStr = "Kick Guild Member",
					    DescStr = "Are you sure you wish to remove "..kickName.." from your guild?",
					    Button1Str = "Confirm",
					    Button2Str = "Cancel",
						ResponseFunc=function(user,buttonId)
							--DebugMessage("Guild: Handle Guild Invite Response");
							if (user == nil) then return end

							if (buttonId == nil) then return end

							-- Handles the invite command of the dynamic window
							if (buttonId == 0) then
								Guild.Remove(kickMember)
								CallFunctionDelayed(TimeSpan.FromSeconds(1),GuildInfo)
							end
						end,
					}
				end
			elseif(arg == "Promote") then
				local memberObj = GameObj(mSelectedMemberId)
				if(Guild.CanBePromotedBy(this,memberObj)) then
					Guild.PromoteMember(memberObj)
					CallFunctionDelayed(TimeSpan.FromSeconds(1),GuildInfo)
				end
			elseif(arg == "Demote") then
				local memberObj = GameObj(mSelectedMemberId)
				if(Guild.CanBePromotedBy(this,memberObj)) then
					Guild.DemoteMember(memberObj)
					CallFunctionDelayed(TimeSpan.FromSeconds(1),GuildInfo)
				end
			elseif(arg == "Transfer Guild") then
				local g = GuildHelpers.Get(this)
				local memberObj = GameObj(mSelectedMemberId)
				if (Guild.CanChangeGuildMaster(memberObj, g)) then
					ClientDialog.Show{
						TargetUser = this,
						DialogId = "Transfer Guild:"..mSelectedMemberId,
					    TitleStr = "Transfer Guild",
					    DescStr = "Are you sure you wish to transfer "..g.Name.." to " ..memberObj:GetName().. "?",
					    Button1Str = "Confirm",
					    Button2Str = "Cancel",
						ResponseFunc=function(user,buttonId)
							if (user == nil) then return end
							if (buttonId == nil) then return end
							if (buttonId == 0) then
								Guild.ChangeGuildMaster(memberObj)
								CallFunctionDelayed(TimeSpan.FromSeconds(1),GuildInfo)
							end
						end,
					}
				end
			elseif(arg == "Cancel") then
				mSelectedMemberId = nil
				GuildInfo()
			end
		elseif(buttonId == "" or buttonId == nil) then
			mGuildWindowOpen = false
		end
	end)

function ToggleGuildWindow()
	if(mGuildWindowOpen) then
		mGuildWindowOpen = false
		this:CloseDynamicWindow("GuildWindow")
	else
		GuildInfo()
	end
end