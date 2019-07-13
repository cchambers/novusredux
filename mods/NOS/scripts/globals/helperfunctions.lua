
function InSameGuild(objA, objB)
	if(objA == nil) or (objB == nil) then
		return false
	end
	if not(objA:IsValid()) or not(objB:IsValid()) then
		return false
	end
	local aGuild = objA:GetObjVar("Guild")
	local bGuild = objB:GetObjVar("Guild")
	if(aGuild ~= nil) and (bGuild ~= nil) and (aGuild == bGuild) then
		return true
	end

	local controllerA = objA:GetObjVar("controller")
	local controllerB = objB:GetObjVar("controller")
	local cAGuild = nil
	local cBGuild = nil
	if(controllerA ~= nil) then
		cAGuild = controllerA:GetObjVar("Guild")
	end
	if(controllerB ~= nil) then
		cBGuild = controllerB:GetObjVar("Guild")
	end
	if(aGuild == nil) and (cAGuild == nil) then
		return false
	end

	if(bGuild == nil) and (cBGuild == nil) then
		return false
	end
	
	if (aGuild ~= nil) and (aGuild == cBGuild) then
		return true
	end

	if(bGuild ~= nil) and (bGuild == cAGuild) then 
		return true
	end
	if(cAGuild ~= nil) and (cAGuild == cBGuild) then
		return true
	end

	return false


end