

--[[
	/seedobjects
]]

function seedobjectsHtmlController()
	return GetWorldName()
end

--[[
	/seedobjects_lua
]]
function seedobjects_luaHtmlController(...)
	local arg = {...}
	if ( arg[1] == "sendto" ) then
		if ( arg[2] ~= nil and arg[2]:IsValid() ) then
			local loc = Loc(tonumber(arg[3]),tonumber(arg[4]),tonumber(arg[5]))
			arg[2]:SendClientMessage("SetRTSCameraPosition",loc)
			--arg[2]:SetPosition(loc)
		else
			return "Invalid object id specified."
		end
	end
	if ( arg[1] == "targetocp" ) then -- target object creation params
		if ( arg[2] ~= nil and arg[2]:IsValid() ) then
			if( arg[2]:HasModule("seedobjects") ) then
				arg[2]:DelModule("seedobjects")
			end
			arg[2]:AddModule("seedobjects", {Command = "targetocp"})
		else
			return "Invalid object id specified."
		end
	end
	return "Unknown command specified."
end