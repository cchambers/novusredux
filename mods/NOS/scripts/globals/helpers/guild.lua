GuildHelpers = {}
-- Main Guild Module

GuildHelpers.AccessLevels = 
{
	"Guildmaster",
	"Officer",
	"Emissary",
	"Member",
	"Trial",
}

GuildHelpers.SetAccessLevel = function(member, level)
	local found = false
	for i=1,#GuildHelpers.AccessLevels do
        found = GuildHelpers.AccessLevels[i] == level
        if ( found ) then break end
	end
	if not( found ) then return end
	local g = GuildHelpers.Get(member)
	if ( not g or not g.Members or not g.Members[member.Id] ) then return end
	g.Members[member.Id].AccessLevel = level
	GuildHelpers.UpdateGuildRecord(g)
end

GuildHelpers.UpdateGuildRecord = function(g)
	GlobalVarWrite("Guild."..g.Id,nil,
		function(record)
			record.Data = g
			return true
		end)
end

GuildHelpers.DeleteGuildRecord = function(guildId)
	GlobalVarDelete("Guild."..guildId,nil)
end

GuildHelpers.GetGuildRecord = function(id)
	--LuaDebugCallStack("GetGuildRecord")
	local record = GlobalVarRead("Guild."..id)
	if(record ~= nil) then
		return record.Data
	end
end

GuildHelpers.ScrubEmptyGuilds = function()
	local guildRecords = GlobalVarListRecords("Guild.")
	for i, recordName in pairs(guildRecords) do
		local guildVar = GlobalVarRead(recordName)
		-- first make sure its an actual guild record (For example Guild.Tag is not a guild record)
		if(guildVar and guildVar.Data) then
			local g = guildVar.Data
			-- if there are no members then delete the guild record
			if(CountTable(g.Members) == 0) then
				DebugMessage("[GuildHelpers.ScrubEmptyGuilds] Scrubbing: "..g.Name)
				GuildHelpers.DeleteGuildRecord(g.Id)
			end		
		end
	end
end

GuildHelpers.SendMessageToAll = function(g,messageName,...)
	for id,memberData in pairs(g.Members) do
		local user = GameObj(id)
		if ( GlobalVarReadKey("User.Online", user) ) then
			user:SendMessageGlobal(messageName,...)
		end
	end
end

GuildHelpers.SendToAll = function(from, g , line)
	local name = ""
	if ( from ~= nil) then
		local actualName = from:GetObjVar("actualName")

		if (actualName == nil) then
			name = from:GetName()
		else
			name = actualName
		end
	end

	GuildHelpers.SendMessageToAll(g,"GuildChat",name,line)		
end

GuildHelpers.GetGuildId = function (mobile)
	if (mobile == nil or not mobile:IsValid()) then
		return nil
	end
	return mobile:GetObjVar("Guild")
end

GuildHelpers.Get = function (mobile)
	local guildId = GuildHelpers.GetGuildId(mobile)

	if (guildId == nil) then return nil end

	-- check if the player still exists in the guild record
	local g = GuildHelpers.GetGuildRecord(guildId)
	if not(g) then return nil end
	if not(g.Members[mobile.Id]) then return nil end

	return g
end

GuildHelpers.GetName = function(user,guild)
	if (user == nil or not user:IsValid()) then return end
	if (guild == nil) then guild = GuildHelpers.Get(user) end
	if (guild == nil) then return end

	return guild.Name
end

GuildHelpers.GetNameByGuildId = function(guildId)
	if (guildId == nil) then return "[Unknown]" end
	local guild = GetGuildRecord(guildId)
	if not(guild) then return "[Unknown]" end
	return guild.Name
end


GuildHelpers.IsInGuildWith = function (playerA,playerB)
	local g = GuildHelpers.Get(playerA)
	if(g == nil) then 
		return false
	end

	return g.Members[playerB.Id] ~= nil
end

GuildHelpers.IsInGuild = function(m)
	return GuildHelpers.Get(m) ~= nil
end

GuildHelpers.IsTagUnique = function(guildtag)
local tag = string.lower(guildtag)
	if ( GlobalVarReadKey("Guild.Tag", tag) == nil ) then return true end
	return false
end

GuildHelpers.AddTagToGlobalList = function(guildtag, guildID, callbackFunction)
local tag = string.lower(guildtag)

local eventId = uuid()
RegisterSingleEventHandler(EventType.GlobalVarUpdateResult, eventId, function(success, name, record)
  if ( callbackFunction ) then callbackFunction(success) end
  end)

GlobalVarWrite("Guild.Tag",eventId,
		function(record)
			if(record[tag] ~= nil) then
				return false;
			end

			record[tag] = guildID 
			return true
		end)
end

GuildHelpers.RemoveTagFromGlobalList = function(guild)
	if(guild == nil) then return end
	local tag = string.lower(guild.Tag)

	GlobalVarWrite("Guild.Tag",nil,
		function(record)
			if(record[tag] ~= nil and record[tag] == guild.Id) then
				record[tag] = nil 
				return true
			end
			return false
		end)
end

GuildHelpers.GuildExists = function(guildId)
	return GlobalVarExists("Guild."..guildId)
end

--- Get the guild record from the guild id
-- @param id double
-- @return luaTable
function GetGuildRecord(id)
	local record = GlobalVarRead("Guild."..id)
	if ( record ~= nil ) then
		return record.Data
	end
end

function ShareGuild(playerA, playerB)
	if ( playerA == nil ) then
		LuaDebugCallStack("[ShareGuild] Nil playerA provided.")
		return
	end
	if ( playerB == nil ) then
		LuaDebugCallStack("[ShareGuild] Nil playerB provided.")
		return
	end
	local aGuild = playerA:GetObjVar("Guild")
	if ( aGuild ~= nil ) then
		local bGuild = playerB:GetObjVar("Guild")
		if ( bGuild ~= nil ) then
			return aGuild == bGuild
		end
	end
	return false
end