

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