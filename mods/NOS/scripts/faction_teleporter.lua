require 'NOS:teleporter'

-- override do teleport
function DoTeleport(playerObj,targetLoc)
	local team = this:GetObjVar("MobileTeamType")
	local playerTeam = playerObj:GetObjVar("MobileTeamType")
	if( playerTeam ~= nil and team ~= playerTeam ) then
		playerObj:SystemMessage("The teleporter fails to acknowledge you.","info")
		return
	end
	playerObj:SetObjVar("lastTeleport",ServerTimeMs())
	playerObj:SetWorldPosition(targetLoc)
end