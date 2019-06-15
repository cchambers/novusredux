function RoundToDecimal(val, place)
	local shift = 10 ^ place
	return math.floor( val * shift + 0.5 ) / shift
end

function xyzStr(xyz)
	return " "..RoundToDecimal(xyz.X, 3).." "..RoundToDecimal(xyz.Y, 3).." "..RoundToDecimal(xyz.Z, 3)
end

function BuildObjectCreationParams(object, template)
	if ( template == nil ) then template = object:GetCreationTemplateId() end
	return template..xyzStr(object:GetLoc())..xyzStr(object:GetRotation())..xyzStr(object:GetScale())
end

function GetObjectCreationParams(object)
	if ( object:IsMobile() ) then
		local spawner = object:GetObjVar("Spawner")
		if ( spawner ~= nil ) then
			object = spawner
		end
	end
	return BuildObjectCreationParams(object)
end

-- need to require each lua controller here so the server can execute them.
require 'globals.htmlwindows.controllers.seedobjects'
require 'globals.htmlwindows.controllers.test'