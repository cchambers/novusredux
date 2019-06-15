


--- Validate a range is less than or equal to a value, optionally give errors to any players involed. Safe for a and b to be the same obj.
-- @param range double The distance to check
-- @param a mobileObj
-- @param b mobileObj
-- @param aErr(optional) Given the distance between a and b is > range, a will receive this in a system message.
-- @param bErr(optional) Given the distance between a and b is > range, b will receive this in a system message.
-- @return true if distance between a and b is less than or equal to range.
function ValidateRangeWithError(range, a, b, aErr, bErr)
	if ( a ~= b and a:DistanceFrom(b) > range ) then
		if ( aErr ~= nil and a:IsPlayer() ) then
			a:SystemMessage(aErr, "info")
		end
		if ( bErr ~= nil and b:IsPlayer() ) then
			b:SystemMessage(bErr, "info")
		end
		return false
	else
		return true
	end
end

function IsDungeonMap()
	local worldName = ServerSettings.WorldName
	if ( 
		worldName
		and
		(
			worldName == "Contempt"
			or
			worldName == "Deception"
			or
			worldName == "Ruin"
			or
			worldName == "Corruption"
			or
			worldName == "Catacombs"
		)
		or
		IsSewerDungeon()
	) then
		return true 
	end
	return false
end

function IsSewerDungeon()
	local subregionName = ServerSettings.SubregionName
	return ( subregionName and subregionName:match("SewerDungeon") )
end

--- Determine if a is behind b
-- @param a mobileObj
-- @param b mobileObj
-- @param angle(optional) number, default to 90
-- @return true if a is behind b, otherwise false.
function IsBehind(a, b, angle)
	angle = angle or 90
	local diff = (b:GetFacing() - b:GetLoc():YAngleTo(a:GetLoc())) + 180
	if ( diff > 0 ) then
		return diff < angle
	else
		return diff > -angle
	end
end

--- Determine if mobile b is infront of mobile a
-- @param a mobileObj
-- @param b mobileObj
-- @param angle(optional) number, defaults to 90
function InFrontOf(a, b, angle)
	angle = angle or 90
	return ( math.abs( a:GetFacing() - a:GetLoc():YAngleTo(b:GetLoc()) ) < angle )
end

--- Cause mobile a to look at mobile b
-- @param a mobileObj
-- @param b mobileObj
function LookAt(a, b)
	if ( a ~= b ) then
		LookAtLoc(a, b:GetLoc())
	end
end

--- Cause mobile a to look at location loc
-- @param a mobileObj
-- @param loc location
-- @param aloc (options) provide for optimization
function LookAtLoc(a, loc, aloc)
	a:SetFacing((aloc or a:GetLoc()):YAngleTo(loc))
end

function GetRegionalName(location)
	-- first see if we are in a named area
	local namedArea = GetSmallestRegionAtLoc(location,"Area-")
	if(namedArea) then
		return namedArea.RegionName:sub(6)
	end

	local worldName = ServerSettings.WorldName
	if(worldName == "NewCelador") then
		local subregionName = ServerSettings.SubregionName
		if(subregionName and subregionName ~= "") then
			return SubregionDisplayNames[subregionName]
		end
	else
		return worldName
	end
end