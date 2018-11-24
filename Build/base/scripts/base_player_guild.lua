require 'base_player_guild_UI'

-- Internal structure of the guild
-- the memberinfo table keeps track of the member
-- settings
GuildMemberInfo = {
	Create = function(m)
		local res = {}

		res.AccessLevel="Member";
		res.JoinDate = DateTime.UtcNow;
		res.Name = m:GetName();
		res.UserId = m:GetAttachedUserId()
		res.LastOnline = DateTime.UtcNow;
		return res;
	end
}

GuildInvitation = {
	Create = function(m, g)
		local res = {}
			res.InvitedBy = m
			res.Guild = g

		return res;
	end
}

Guild.InviteTarget = function()
	this:RequestClientTargetGameObj(this, "guildinvite")
end



Guild.Initialize = function()
	--DebugMessage("Checking for dormant invitations")

	local guildInvite = this:GetObjVar("GuildInvitation")

	if (guildInvite ~= nil) then

		local guild = Guild.ValidateInvitation(guildInvite)

		--if(guild ~= nil) then
			--InviteGump(this, guild.Name)
		--else
			this:DelObjVar("GuildInvitation")
		--end

		return
	end		

	guild = Guild.UpdateMemberInfo(this)

	if (guild ~= nil) then
		Guild.SendToAll( this, guild, "(Has logged on)");	
	end
end

Guild.Invite = function ( from, target )
	local g = Guild.Get( from );

	if ( g == nil ) then
		from:SystemMessage("[00FF00][Guild] You have not yet created a guild!","custom")
		return
	end

	if (not Guild.CanInvite(target,from)) then
		return
	end
		ClientDialog.Show{
			TargetUser = target,
			DialogId = "GroupInvite"..target.Id,
		    TitleStr = "Guild Invitation",
		    DescStr = "You have been invited to "..from:GetName().."'s guild.",
		    Button1Str = "Accept",
		    Button2Str = "Decline",
		    ResponseObj= from,
		    ResponseFunc= function(user,buttonId)
				local buttonId = tonumber(buttonId)
				--DebugMessage("Guild: Handle Group Invite Response");
				if (user == nil) then return end

				-- Handles the invite command of the dynamic window
				if (buttonId == 0) then
					--DebugMessage("Bam")
					Guild.Accept(target)		
					return
				end
				--DebugMessage("Bam2")
				Guild.Decline(target)
			end
		}

	target:SystemMessage("[$1686]"..g.Name,"custom")

	from:SystemMessage( "[$1687]" ,"custom")
	--LuaDebugCallStack("AAA")
	target:SetObjVar("GuildInvitation", GuildInvitation.Create(from, g.Id))
end

Guild.CanInvite = function(target,user)
		if not( target:IsPlayer() ) then
			user:SystemMessage("[$1688]","custom")
			return false
		end

		if (target == user) then
			user:SystemMessage("[$1689]","custom")
			return false
		end

		local g = Guild.Get( user );
		local mg = Guild.Get( target );

		if ( g ~= nil and not(Guild.HasAccessLevel(this, "Emissary",g))) then
			user:SystemMessage("[$1690]","custom")
			return false
		end

		if ( mg ~= nil and mg == g ) then
			user:SystemMessage("[$1691]","custom")
			return false
		end

		if ( mg ~= nil ) then
			user:SystemMessage("[00FF00][Guild] This person is already in a guild!", "custom")
			return false
		end

		local guildInvite = target:GetObjVar("GuildInvitation")

		if (guildInvite ~= nil) then
			user:SystemMessage("[$1692]","custom")
			return false
		end
		return true
end

Guild.Decline = function(target)
	if( target:HasObjVar("GuildInvitation") ) then
		local guildInvite = target:GetObjVar("GuildInvitation")

		if (guildInvite == nil) then
			target:SystemMessage( "[00FF00][Guild] Nobody invited you." ,"custom")
			return
		end

		local g = Guild.Get(guildInvite.InvitedBy)

		if (g == nil) then
			target:SystemMessage( "[00FF00][Guild] The guild no longer exists." ,"custom")
			target:DelObjVar("GuildInvitation");
			return
		end

		guildInvite.InvitedBy:SystemMessage( "[00FF00][Guild] Does not wish to join your guild." ,"custom")

		target:SystemMessage( "[$1693]" ,"custom")
		target:DelObjVar("GuildInvitation");
	end
end

Guild.Accept = function(target)
	--DebugMessage(target:GetObjVar("GuildInvitation"))
	if( target:HasObjVar("GuildInvitation") ) then
		local guildInvitation = target:GetObjVar("GuildInvitation")

		local g = Guild.Get(guildInvitation.InvitedBy)
		Guild.AddToGuild(g.Id,target)	
		target:DelObjVar("GuildInvitation");
	else
		target:DelObjVar("GuildInvitation");
		target:SystemMessage( "[00FF00][Guild] Nobody invited you.","custom")
	end
end

Guild.AddToGuild = function(guildId,target)
	--DebugMessage(1)
	local g =Guild.GetGuildRecord(guildId)

	if (g == nil) then
		this:SystemMessage( "[00FF00][Guild] The guild no longer exists.","custom" )	
		return
	end

	target = target or this

	local mi = g.Members[target.Id];
	--DebugMessage(DumpTable(g.Members))

	if ( mi == nil ) then
		--DebugMessage(2)
		mi = GuildMemberInfo.Create( target );
		g.Members[target.Id] = mi
		target:SetObjVar("Guild", g.Id);

		Guild.SendToAll( nil, g, StripColorFromString(target:GetName()) .." has joined the guild.");
		Guild.SendMessageToAll(g,"UpdateGuildInfo")

		CheckAchievementStatus(target, "Activity", "Guild", 1)

		Guild.SetGuildTooltip(target,g.Name)
		if(Guild.CheckAccessLevel(mi.AccessLevel,"Emissary")) then
			Guild.SetGuildTitle(target,mi.AccessLevel)
		end

		CallFunctionDelayed(TimeSpan.FromSeconds(1),function() 
			target:SendMessage("UpdateName")
			target:SendMessage("UpdateChatChannels")
		end)		
	end
	--DebugMessage(3)
	Guild.UpdateGuildRecord(g)		

	EventTracking.UpdateGuildRecord(g)	
end

Guild.Contains = function( m , g )
	return ( g.Members[m.Id] ~= nil );
end

Guild.Remove = function ( m, g )
	g = g or Guild.Get(this)
	if(g == nil) then
		return
	end

	if(m:IsValid()) then
		m:SystemMessage( "[$1694]","custom")
		m:DelObjVar("Guild");
		Guild.RemoveGuildTooltip(m)
		Guild.RemoveGuildTitle(m)
	elseif(IsUserOnline(m)) then
		CallFunctionDelayed(TimeSpan.FromSeconds(1),function() m:SendMessageGlobal("UpdateGuildMemberInfo") end)
	end

	Guild.SendToAll( nil, g, "A player has been removed from your guild.");

	if (g.Members[m.Id] ~= nil) then
		g.Members[m.Id] = nil;			
	end

	Guild.UpdateGuildRecord(g)		

	EventTracking.UpdateGuildRecord(g)	

	CallFunctionDelayed(TimeSpan.FromSeconds(1),function ( ... )
			m:SendMessage("UpdateName")
		end)

	Guild.SendMessageToAll(g,"UpdateGuildInfo")
	this:SendMessage("UpdateGuildInfo")
end

Guild.SendMessage = function (...)

	local g = Guild.Get(this)

	if (g == nil) then
		return
	end

	local arg = table.pack(...)

	local line = ""
	if(#arg > 0) then
		for i = 1,#arg do line = line .. tostring(arg[i]) end
	end

	local encoded = json.encode(line)
	local msgtype = 'guild","guildname":"' .. g.Name
	this:LogChat(msgtype, encoded)

	Guild.SendToAll( this, g, line);
end

Guild.SendAllegianceMessage = function (...)
	--[[
	local g = Guild.Get(this)

	if (g == nil) then
		return
	end

	local arg = table.pack(...)

	local line = ""
	if(#arg > 0) then
		for i = 1,#arg do line = line .. tostring(arg[i]) .. " " end
	end	

	Guild.SendToAllAllegiance( this, g, line);
	]]
end

Guild.TryCreate = function(leader,guildName,guildTag,foundingMembers)

 guildID = uuid()
 local cb = function(success)
        if ( success ) then
           	--we reserved our guild tag, lets actually create our guild now.
           	Guild.Create(leader, guildName, guildID, guildTag,foundingMembers)           	
        else
        	leader:SystemMessage("Guild creation failed, please try again")
        end  
    end

    Guild.AddTagToGlobalList(guildTag, guildID, cb)
end

-- NOTE: if no id is specified its generated automatically
Guild.Create = function(leader,guildName, guildId,guildTag,foundingMembers)	
	if(guildId == nil) then guildId = uuid() end

	local res = {}
	res.Leader = leader;

	res.Members = {}

	res.Id = guildId
	res.Name = guildName or "New Guild"		
	res.Tag = guildTag

	if(leader ~= nil) then
		local mi = GuildMemberInfo.Create( leader );
		mi.AccessLevel = "Guildmaster"

		res.Members[leader.Id] = mi
		leader:SystemMessage("[00FF00][Guild] The "..res.Name.." has been founded.","custom")
		leader:SystemMessage("You have joined the guild "..res.Name..".","info")
		
		CheckAchievementStatus(leader, "Activity", "Guild", 1)
		Guild.SetGuildTooltip(leader,res.Name)
		Guild.SetGuildTitle(leader,mi.AccessLevel)
		leader:SetObjVar("Guild",res.Id)
		CallFunctionDelayed(TimeSpan.FromSeconds(1),function ( ... )
					leader:SendMessage("UpdateName")
					leader:SendMessage("UpdateChatChannels")
					leader:SendMessage("OpenGuildInfo")
				end)			

		if(foundingMembers) then
			for i,foundingMember in pairs(foundingMembers) do
				mi = GuildMemberInfo.Create( foundingMember );
				res.Members[foundingMember.Id] = mi
				foundingMember:SetObjVar("Guild", res.Id);

				foundingMember:SystemMessage("[00FF00][Guild] The "..res.Name.." has been founded.","custom")
				foundingMember:SystemMessage("You have joined the guild "..res.Name..".","info")
				
				CheckAchievementStatus(foundingMember, "Activity", "Guild", 1)

				Guild.SetGuildTooltip(foundingMember,res.Name)
				if(Guild.CheckAccessLevel(mi.AccessLevel,"Emissary")) then
					Guild.SetGuildTitle(foundingMember,mi.AccessLevel)
				end

				CallFunctionDelayed(TimeSpan.FromSeconds(1),function() 
					foundingMember:SendMessage("UpdateName")
					foundingMember:SendMessage("UpdateChatChannels")
					foundingMember:SendMessage("OpenGuildInfo")
				end)		
			end
		end
	end

	Guild.UpdateGuildRecord(res)		
	
	EventTracking.UpdateGuildRecord(res)
	return res
end

Guild.Disband = function(user)
	local g = Guild.Get(user)

	if (g == nil) then
		return
	end

	Guild.SendToAll( this, g, "Your guild has been disbanded!");

	-- DAB TODO: This only hands users on the same region!
	for mobile, entry in pairs (g.Members) do
		local mob = GameObj(mobile)

		if (mob ~= nil and mob:IsValid()) then
			mob:DelObjVar("Guild")
			Guild.RemoveGuildTooltip(mob)
			Guild.RemoveGuildTitle(mob)
			mob:SendMessage("UpdateGuildInfo")
		end
	end

	Guild.RemoveTagFromGlobalList(g)

	Guild.DeleteGuildRecord(g.Id)

	CallFunctionDelayed(TimeSpan.FromSeconds(1),function ( ... )
					Guild.SendMessageToAll(g,"UpdateName")
				end)

	this:SendMessage("UpdateGuildInfo")
end

Guild.ValidateInvitation = function(invite)
	if (invite == nil) then
		return nil
	end

	local guild = invite.Guild

	if (guild == nil) then
		return nil
	end

	return Guild.GetGuildRecord(guild)
end

Guild.UpdateMemberInfo = function(user)
	local g = Guild.Get(user)

	if (g == nil) then 
		if(this:HasObjVar("Guild")) then
			user:SystemMessage("[00FF00][Guild] Your guild was disbanded.","custom")
			user:DelObjVar("Guild")
			Guild.RemoveGuildTooltip(user)
			Guild.RemoveGuildTitle(user)
		end
		return 
	end
	--DebugMessage("Updating...")

	local mi = g.Members[user.Id];

	if ( mi ~= nil) then
		--DebugMessage("Setting Member info")

		mi.LastOnline = DateTime.UtcNow

		local name = ""

		local actualName = user:GetObjVar("actualName")

		if (actualName == nil) then
			name = user:GetName()
		else
			name = actualName
		end

		mi.Name = name

		g.Members[user.Id] = mi

		return g

			--DebugMessage("writing..."..g.Members[user.Id].Name.." - "..g.Members[user.Id].LastOnline)
	else
		user:SystemMessage("[$1695]","custom")
		user:DelObjVar("Guild")
		Guild.RemoveGuildTooltip(user)
		Guild.RemoveGuildTitle(user)
	end
end

Guild.SetGuildTooltip = function(mobileObj,guildName)
	SetTooltipEntry(mobileObj,"Guild","<"..guildName..">",101)
end

Guild.RemoveGuildTooltip = function(mobileObj)
	RemoveTooltipEntry(mobileObj,"Guild")
end

Guild.SetGuildTitle = function(mobileObj,guildTitle)
	CheckAchievementStatus(mobileObj, "Other", "GuildTitle", nil, {Description = "Title granted by guild rank", CustomAchievement = guildTitle, Reward = {Title = guildTitle}})
end

Guild.RemoveGuildTitle = function(mobileObj)
	RemoveOtherAchievement(mobileObj, "GuildTitle")
end

Guild.HasAccessLevel = function(user,required,g)
	local g = g or Guild.Get(user)

	if (g == nil) then
		return
	end

	local mi = g.Members[user.Id]

	if (mi == nil) then return false end

	local level = mi.AccessLevel

	return Guild.CheckAccessLevel(level,required)
end

Guild.CheckAccessLevel = function(level,required)
	if (level == "Guildmaster") then return true end

	if (level == "Officer" and required == "Officer") then return true end
	if (level == "Officer" and required == "Emissary") then return true end
	if (level == "Officer" and required == "Member") then return true end
	if (level == "Officer" and required == "Trial") then return true end

	if (level == "Emissary" and required == "Emissary") then return true end
	if (level == "Emissary" and required == "Member") then return true end
	if (level == "Emissary" and required == "Trial") then return true end

	if (level == "Member" and required == "Member") then return true end
	if (level == "Member" and required == "Trial") then return true end

	if (level == "Trial" and required == "Trial") then return true end

	return false
end

Guild.GetAccessLevel = function(m,g)
	g = g or Guild.Get(m)

	if (g == nil) then return nil end

	local mi = g.Members[m.Id]

	if (mi == nil) then return nil end

	return mi.AccessLevel

end
Guild.CanBePromotedBy = function(promoter, promotee,g)
	g = g or Guild.Get(promoter)

	local mylevel = Guild.GetAccessLevel(promoter,g)
	local theirlevel = Guild.GetAccessLevel(promotee,g)

	if (mylevel == "Guildmaster" and theirlevel =="Guildmaster") then return false end
	if (mylevel == "Officer" and theirlevel =="Guildmaster") then return false end
	if (mylevel == "Officer" and theirlevel =="Officer") then return false end

	if (mylevel == "Emissary" and theirlevel =="Guildmaster") then return false end
	if (mylevel == "Emissary" and theirlevel =="Officer") then return false end
	if (mylevel == "Emissary" and theirlevel =="Emissary") then return false end

	return true
end

Guild.PromoteAccessLevel = function (current)
	if (current == "Guildmaster") then return "Guildmaster" end
	if (current == "Officer") then return "Guildmaster" end
	if (current == "Emissary") then return "Officer" end
	if (current == "Member") then return "Emissary" end
	if (current == "Trial") then return "Member" end

	return "Member"
end
Guild.DemoteAccessLevel = function (current)
	if (current == "Guildmaster") then return "Officer" end
	if (current == "Officer") then return "Emissary" end
	if (current == "Emissary") then return "Member" end
	if (current == "Member") then return "Trial" end
	if (current == "Trial") then return "Trial" end

	return "Member"
end

Guild.PromoteMember = function(member, g, level, force)
	local mylevel = Guild.GetAccessLevel(this,g)
	local theirlevel = Guild.GetAccessLevel(member,g)

	g = g or Guild.Get(this)

	if (g == nil or not(Guild.HasAccessLevel(this,"Emissary",g) or IsImmortal(this))) then return end

	--Officer cannot be promoted to Guildmaster if one already exists
	if (mylevel == "Guildmaster" and theirlevel == "Officer") then
		this:SystemMessage("[00FF00][Guild] Only one guildmaster can exist","custom")
		return false
	end

	if(not(force)) then			
		if ( not(Guild.CanBePromotedBy(this, member,g)) ) then
			this:SystemMessage("[00FF00][Guild] Access level not high enough.","custom")
			return
		end
	end

	--DebugMessage("Guild: Promoting..."..tostring(id))

	local mi = g.Members[member.Id];

	if ( mi ~= nil ) then
		local currentLevel =  mi.AccessLevel

		if(level == nil) then
			level = Guild.PromoteAccessLevel(currentLevel)
		end
		mi.AccessLevel = level

		if(Guild.CheckAccessLevel(level,"Emissary")) then
			Guild.SetGuildTitle(member,level)
		end

		g.Members[member.Id] = mi

		--DebugMessage("writing..."..g.Members[id].AccessLevel)

		Guild.UpdateGuildRecord(g)
	end
end
Guild.DemoteMember = function(member, g)
	g = g or Guild.Get(this)

	if (g == nil or not(Guild.HasAccessLevel(this,"Emissary",g))) then return end

	if (not(Guild.CanBePromotedBy(this, member,g))) then
		this:SystemMessage("[00FF00][Guild] Access level not high enough","custom")
		return
	end

	local mi = g.Members[member.Id];

	if ( mi ~= nil ) then
		local currentLevel =  mi.AccessLevel

		mi.AccessLevel = Guild.DemoteAccessLevel(currentLevel)

		if(Guild.CheckAccessLevel(mi.AccessLevel,"Emissary")) then
			Guild.SetGuildTitle(member,mi.AccessLevel)
		else
			Guild.RemoveGuildTitle(member)
		end

		g.Members[member.Id] = mi

		--DebugMessage("writing..."..g.Members[id].AccessLevel)
		Guild.UpdateGuildRecord(g)
	end
end

Guild.CanChangeGuildMaster = function(member, g)
	g = g or Guild.Get(this)
	
	local mylevel = Guild.GetAccessLevel(this,g)
	local theirlevel = Guild.GetAccessLevel(member,g)

	if (mylevel ~= "Guildmaster") then
		this:SystemMessage("[00FF00][Guild] You do not have a permission to transfer guild","custom")
		return false
	elseif (theirlevel ~= "Officer") then
		this:SystemMessage("[00FF00][Guild] Only an officer can be made to guildmaster", "custom")
		return false
	end

	return true
end

Guild.ChangeGuildMaster = function(member, g)
	local mylevel = Guild.GetAccessLevel(this,g)
	local theirlevel = Guild.GetAccessLevel(member,g)

	g = g or Guild.Get(this)

	if (g == nil or not(Guild.HasAccessLevel(this,"Emissary",g) or IsImmortal(this))) then return end

	local mi = g.Members[member.Id];
	local promoter = g.Members[this.Id];

	if ( mi ~= nil ) then
		local currentLevel =  mi.AccessLevel
		local promoterLevel = promoter.AccessLevel

		--Since we are changing Guildmaster, changed level of member is always Guildmaster
		level = "Guildmaster"

		if (theirlevel == "Officer" and mylevel == "Guildmaster") then
			promoter.AccessLevel = "Officer"
			Guild.SetGuildTitle(this,promoter.AccessLevel)
		end

		mi.AccessLevel = level

		if(Guild.CheckAccessLevel(level,"Emissary")) then
			Guild.SetGuildTitle(member,level)
		end

		g.Members[member.Id] = mi
		g.Members[this.Id] = promoter

		Guild.UpdateGuildRecord(g)
	end
end

Guild.CanKickMembers = function(m,target,g)
	if (Guild.GetAccessLevel(target,g) == "Guildmaster") then
		m:SystemMessage("[00FF00][Guild] You cannot kick the guildmaster", "custom") 
		return false 
	end 
	return Guild.HasAccessLevel(m,"Officer",g)
end

Guild.GetAccessLevelIndex = function(accessLevel)
	return IndexOf(Guild.AccessLevels,accessLevel)
end

Guild.SetGuildMessage = function(m, g, messageType, message)
	g = g or Guild.Get(m)

	if(g ~= nil and messageType and message and Guild.HasAccessLevel(this,"Officer",g)) then
		if not(g.Messages) then
			g.Messages = {}
		end
		g.Messages[messageType] = message
		Guild.UpdateGuildRecord(g)
	end
end

Guild.GetGuildMessage = function(m, g, messageType)
	g = g or Guild.Get(m)

	-- no guild return nil
	if not(g) then return end

	-- no messages set yet
	if not(g.Messages) then return "" end

	return g.Messages[messageType] or ""
end

Guild.GetOnlineMemberCount = function(m, g)
	local count = 0
	for id,memberData in pairs(g.Members) do
		if ( GlobalVarReadKey("User.Online", GameObj(id)) ) then
			count = count + 1
		end
	end
	return count
end

-- This function handles the player targeted event to check if all conditions are met
-- After that Guild.Invite is called to do the management stuff
RegisterEventHandler(EventType.ClientTargetGameObjResponse, "guildinvite",
	function(target,user)
		if( target == nil ) then
			return
		end

		if (not Guild.CanInvite(target,user)) then 
			return
		end

		Guild.Invite(user, target)
		--InviteGump(target, g.Name)
	end)

RegisterEventHandler(EventType.Message,"GuildChat",
	function(name,line)
		if(name ~= nil and name ~= "") then
			this:SystemMessage( "[00FF00][Guild] " .. name ..": " .. line.."[-]","custom") ;
		else
			this:SystemMessage( "[00FF00][Guild] " .. line.."[-]","custom") ;
		end
	end)

RegisterEventHandler(EventType.Message,"LoggedIn",function ()
	Guild.Initialize()
end)

RegisterEventHandler(EventType.Message,"JoinGuild",
	function (guildId)
		-- make sure this person isnt somehow in a guild
		if(Guild.Get(this) == nil) then				
			if ( Guild.GetGuildRecord(guildId) ~= nil ) then
				Guild.AddToGuild(guildId)
			end				
		end
	end)

RegisterEventHandler(EventType.Message,"UpdateGuildMemberInfo",
	function ()
		Guild.UpdateMemberInfo(this)
	end)