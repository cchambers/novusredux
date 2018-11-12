
SuperGuardThingsToSay = {
	"Violence is not tolerated here!",
	"Enough! Slay them!",
	"The justice of the Guardian Order is swift.",
}


--- Get the protection type for a mobile
-- @param mobile
-- @param damager(optional)
-- @return "None", "InstaKill", or "Guard"
function GetGuardProtection(mobile, damager)
	if( mobile:IsInRegion("Arena")) then
		return "None"
	end

	if (damager ~= nil) then
		if( damager:IsInRegion("Arena")) then
			return "None"
		end
	end

	if(ServerSettings.PlayerInteractions.SlayImmediateProtectionZones) then
		for i,j in pairs(ServerSettings.PlayerInteractions.SlayImmediateProtectionZones) do
			if (mobile:IsInRegion(j)) then
				return "InstaKill"
			end
		end
	end

    --if this setting is enabled do for the entire map
    if (ServerSettings.PlayerInteractions.GuaranteedGuardProtectionFullMap) then
        return "Guard"
    end

	if(ServerSettings.PlayerInteractions.GuaranteedGuardProtectionZones) then
		for i,j in pairs(ServerSettings.PlayerInteractions.GuaranteedGuardProtectionZones) do
			if (mobile:IsInRegion(j) and (not(damager) or (damager and damager:IsInRegion(j)))) then
				return "Guard"
			end
		end
	end

	local curMap = GetWorldName()
	if(ServerSettings.PlayerInteractions.SlayImmediateProtectionMaps) then
		for i,j in pairs(ServerSettings.PlayerInteractions.SlayImmediateProtectionMaps) do
			if(curMap == j) then
				return "Guard"
			end
		end
	end

	if(ServerSettings.PlayerInteractions.NeutralTownRegionNames) then
		for i,j in pairs(ServerSettings.PlayerInteractions.NeutralTownRegionNames) do
			if (mobile:IsInRegion(j)) then
				return j
			end
		end
	end

	local mobileLoc = mobile:GetLoc()
	local guardTower = FindObjectWithTagInRange("GuardTowerObject",mobileLoc,ServerSettings.PlayerInteractions.GuardTowerProtectionRange)
	if(guardTower) then
		return "GuardTower",guardTower
	end
	
	local teleportTower = FindObjectWithTagInRange("TeleportTowerObject",mobileLoc,ServerSettings.PlayerInteractions.GatekeeperProtectionRange)
	if(teleportTower) then
		return "GuardTower",teleportTower
	end

    return "None"
end


--- Calling this on a lua vm context (attached module) will return the all guards near the gameObj of the lua VM context.
-- @return guards(luaTable of mobileObjs) or empty table
function GetNearbyGuards(neutral)
	local nearbyGuards = nil
	
	if ( neutral ) then
		return FindObjects(SearchMulti(
		{
			SearchMobileInRange(ServerSettings.PlayerInteractions.GuardTowerProtectionRange),
			SearchHasObjVar("IsNeutralGuard")
		})) or {}
	else
		return FindObjects(SearchMulti(
		{
			SearchMobileInRange(ServerSettings.PlayerInteractions.GuardTowerProtectionRange),
			SearchHasObjVar("IsGuard"),
		})) or {}
	end
end

--- Calling this on a lua vm context (attached module) will return the nearest guard to the gameObj of the lua VM context.
-- @param mobileObj guard closest to this mobile
-- @return guard(mobileObj) or nil
function GetNearestGuard(mobileObj)
	local nearbyGuards = GetNearbyGuards()

	local nearestGuard = nil
	local nearestDistance = 0
	for index, guardObj in pairs(nearbyGuards) do
		local distance = mobileObj:DistanceFrom(guardObj)
		if( nearestGuard == nil or distance < nearestDistance ) then
			nearestGuard = guardObj
			nearestDistance = distance
		end
	end

	return nearestGuard
end

--- Trigger guards to protect a victim from an aggressor
-- @param victim(mobileObj)
-- @param aggressor(mobileObj)
-- @param karmaLevelProtected(boolean) true is the karma level of victim is guard protected
-- @return none
function GuardProtect(victim, aggressor, karmaLevelProtected)
	Verbose("Guard", "GuardProtect", victim, aggressor, karmaLevelProtected)

	if ( IsDead(aggressor) ) then
		return
	end
	
	local owner = aggressor:GetObjectOwner() or aggressor
	-- guards are safe from other guards, also ignore Invulnerable mobiles.
	if ( owner:HasObjVar("IsGuard") or owner:HasObjVar("IsNeutralGuard") or owner:HasObjVar("Invulnerable") ) then
		return
	end

	-- gods are safe from guards, unless they are a TestMortal...
	if ( not owner:HasObjVar("TestMortal") and IsDemiGod(owner) ) then
		return
	end

	if ( victim:HasTimer("EnteredProtection") ) then return end

	-- call all neutral guards to protect
	ForeachMobileAndPet(aggressor, CallNearbyNeutralGuardsOn)

	-- if the karma level is not protected, we end here since neutral guards have already been called.
	if ( karmaLevelProtected ~= true ) then return end
	
	if (
		-- if the attacker is a player (or player pet)
		IsPlayerCharacter(owner)
		and
		-- and the victim is in a place karma matters
		WithinKarmaArea(victim)
	) then
		local isVictimPlayer = IsPlayerCharacter(victim:GetObjectOwner() or victim)
		if (
			-- and the victim is a player (or player pet)
			isVictimPlayer
			or
			-- or the victim is not a player/pet and victim is karmaLevelProtected (npc that's guard protected)
			(not isVictimPlayer and karmaLevelProtected)
		) then

			local guardProtectionType = GetGuardProtection(victim, aggressor)
	
			-- instantly kill the attacking player in certain situations
			if ( guardProtectionType == "InstaKill" ) then
				ForeachMobileAndPet(aggressor, GuardInstaKill)
				return
			end
	
			-- spawn super guards in other situations
			if ( guardProtectionType == "Guard" ) then
				ForeachMobileAndPet(aggressor, SpawnSuperGuardsOn)
				return
			end

		end
	end

	-- not guaranteed protection, add threat to all nearby physical guards
	ForeachMobileAndPet(aggressor, CallNearbyGuardsOn)
end

--- Spawn super guards on an aggressor, does not do saftey checks on aggressor
-- @param aggressor(mobileObj)
-- @param numGuards(number) Number of super guards to spawn on
-- @return none
function SpawnSuperGuardsOn(aggressor, numGuards)
	if ( numGuards == nil or numGuards < 1 ) then numGuards = 1 end
	
	for i=1,numGuards do
		CreateObj("super_guard", GetNearbyPassableLoc(aggressor,360,6,7), "super_guard", aggressor)
	end
end

--- Instantly kill an aggressor via guard insta kill means (lightning bolt), does not do saftey checks on aggressor
-- @param aggressor(mobileObj)
-- @return none
function GuardInstaKill(aggressor)
	if not( HasMobileEffect(aggressor, "SwiftJustice") ) then
		aggressor:SendMessage("StartMobileEffect", "SwiftJustice")
	end
	aggressor:SendMessage("ProcessTrueDamage", aggressor, 5000, true)
	aggressor:PlayEffect("LightningCloudEffect")
	if ( IsPlayerCharacter(aggressor) ) then
		aggressor:SystemMessage("[$1820]")
		aggressor:SystemMessage("[$1820]","info")
	end
end

--- Convenience function to call neutral guards
-- @param aggressor mobileObj - The mobile to call guards on.
function CallNearbyNeutralGuardsOn(aggressor)
	CallNearbyGuardsOn(aggressor, true)
end

--- Call nearby (physical) guards on an aggressor
-- @param aggressor(mobileObj)
-- @param neutral(boolean)(optional) If true, only neutral guards will be called.
-- @return none
function CallNearbyGuardsOn(aggressor, neutral)
	Verbose("Guard", "CallNearbyGuardsOn", aggressor, neutral)
	local nearbyGuards = GetNearbyGuards(neutral)
	local any = false
	for i,guard in pairs(nearbyGuards) do
		guard:SendMessage("AddThreat", aggressor, 100)
		any = true
	end
	if ( any and not HasMobileEffect(aggressor, "SwiftJustice") ) then
		aggressor:SendMessage("StartMobileEffect", "SwiftJustice")
	end
end

--- Update the UI with the player's current protection status and message the user when changed.
-- @param player(playerObj)
-- @return none
function UpdatePlayerProtection(player)
	local curProtection = player:GetObjVar("GuardProtection")
	local newProtection = GetGuardProtection(player)
	
	if(newProtection == curProtection) then return end

    player:SetObjVar("GuardProtection",newProtection)

    if(newProtection ~= "None" and newProtection ~= "InstaKill") then
    	player:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"EnteredProtection")
    end

    --enter/exit messages
	local msgStr

	if(newProtection == "None" and curProtection ~= nil) then
		msgStr = curProtection .. ".Exit"
	else
		msgStr = newProtection .. ".Enter"
	end

	player:SystemMessage(ServerSettings.PlayerInteractions.GuardProtectionEnterExitMsgMap[msgStr], "event")
    UpdateRegionStatus(player,nil,newProtection)
end
