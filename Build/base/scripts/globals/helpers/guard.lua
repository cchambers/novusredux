
SuperGuardThingsToSay = {
	"Violence is not tolerated here!",
	"Enough! Slay them!",
	"The justice of the Guardian Order is swift.",
}

--- Convenience wrapper to IsProtected with guranteed set true
-- @param mobile
-- @param from
-- @param mobileKaramLevel(optional)
-- @param fromKarmaLevel(optional)
-- @param guaranteed(optional) - If set to true, we are checking zones that deny these actions at all.
function IsGuaranteedProtected(mobile, from, mobileKarmaLevel, fromKarmaLevel)
	Verbose("Guard", "IsGuaranteedProtected", mobile, from, mobileKaramLevel, fromKarmaLevel)
	local protected = IsProtected(mobile, from, mobileKarmaLevel, fromKarmaLevel, true)

	if ( protected ) then
		if ( IsPlayerCharacter(from) ) then
			if ( from:HasTimer("ProtectedActionConsent") ) then
				-- zap them
				ForeachMobileAndPet(from, GuardInstaKill)
				from:RemoveTimer("ProtectedActionConsent")
			else
				-- Are you sure?
				ClientDialog.Show{
					TargetUser = from,
					DialogId = "ConsentToInstantDeath",
					TitleStr = "WARNING!",
					DescStr = "This is a protected area and you will be punished if you choose to proceed.",
					Button1Str = "Acknowledge",
					Button2Str = "Cancel",
					ResponseObj = from,
					ResponseFunc = function( user, buttonId )
						buttonId = tonumber(buttonId)
						if ( user == from and buttonId == 0 ) then
							from:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "ProtectedActionConsent")
						end
					end,
				}
			end
		end
	end

	return protected
end

-- Determine if a mobile is protected from another mobile.
-- @param mobile
-- @param from
-- @param mobileKaramLevel(optional)
-- @param fromKarmaLevel(optional)
-- @param guaranteed(optional) - If set to true, we are checking zones that deny these actions at all.
function IsProtected(mobile, from, mobileKarmaLevel, fromKarmaLevel, guaranteed)
	Verbose("Guard", "IsProtected", mobile, from, mobileKaramLevel, fromKarmaLevel, guaranteed)
	-- these factors allow fighting anywhere no matter what
	if ( ShareKarmaGroup(mobile, from) or InOpposingAllegiance(mobile, from) ) then
		return false
	end

	-- get ready to potentially cache mobile's guard protection
	local protection
	if ( guaranteed ) then
		-- since there are possible routes that do not require protection, we only get it here first sometimes
		protection = GetGuardProtection(mobile)
		-- when checking guaranteed protection, we can always return false on these protection types
		if ( protection == "None" or protection == "Neutral" ) then return false end
	end

	-- if mobileKarmaLevel was no provided, get it from the mobile that was provided.
	if not( mobileKarmaLevel ) then
		mobileKarmaLevel = GetKarmaLevel(GetKarma(mobile))
	end

	-- if mobile is guard protected
	if ( mobileKarmaLevel.GuardProtectPlayer or mobileKarmaLevel.GuardProtectNPC ) then
		-- if mobile is a player
		if ( IsPlayerCharacter(mobile) ) then
			-- if this is a guard protected player
			if ( mobileKarmaLevel.GuardProtectPlayer ) then
				if (
					-- if they are chaotic
					mobileKarmaLevel.IsChaotic
					or
					-- or they are temp chaotic and the 'attacker' is chaotic
					( mobile:HasObjVar("IsChaotic") and (fromKarmaLevel or GetKarmaLevel(GetKarma(from))).IsChaotic )
				) then
					if ( guaranteed ) then
						-- chaotic are only guarantee protected in Town
						--- or anyone flagged chaotic is only protected in Town vs other chaotic
						return ( protection == "Town" )
					else
						-- get the protection since it's never set for non-guarantee at this point
						protection = GetGuardProtection(mobile)
						-- when not checking guaranteed, we are calling nearby guards or similar, and chaotic actions don't call guards
						return ( protection ~= "Protection" )
					end
				else
					-- anyone that's not chaotic
					if ( guaranteed ) then
						return ( protection == "Town" or protection == "Protection" )
					else
						-- in a situation where nearby guards are called, this player always will get help.
						return true
					end
				end
			end
		else
			if ( mobileKarmaLevel.GuardProtectNPC ) then
				if ( guaranteed ) then
					-- NPC mobiles that are protected are safe in Town and Protection zones
					return ( protection == "Town" or protection == "Protection" )
				else
					-- in a situation where nearby guards are called, this NPC always will get help.
					return true
				end
			end
		end
	end
	return false
end


--- Get the protection type for a mobile
-- @param mobile
-- @return "None", "Neutral", "Protection", "Town"
function GetGuardProtection(mobile)
	Verbose("Guard", "GetGuardProtection", mobile)
	local ss = ServerSettings.PlayerInteractions

    --if this setting is enabled do for the entire map
    if ( ss.GuaranteedTownProtectionFullMap ) then
        return "Town"
	end
	
	if ( mobile:IsInRegion("Arena") ) then
		return "None"
	end

	if ( ss.TownProtectionZones ) then
		for i=1,#ss.TownProtectionZones do
			if ( mobile:IsInRegion(ss.TownProtectionZones[i]) ) then
				return "Town"
			end
		end
	end

	if ( ss.ProtectionZones ) then
		for i=1,#ss.ProtectionZones do
			if ( mobile:IsInRegion(ss.ProtectionZones[i]) ) then
				return "Protection"
			end
		end
	end

	if ( ss.ProtectionMaps ) then
		local currentMap = ServerSettings.WorldName
		for i=1,#ss.ProtectionMaps do
			if ( currentMap == ss.ProtectionMaps[i] ) then
				return "Protection"
			end
		end
	end

	if ( ss.NeutralZones ) then
		for i=1,#ss.NeutralZones do
			if ( mobile:IsInRegion(ss.NeutralZones[i]) ) then
				return "Neutral"
			end
		end
	end

	local mobileLoc = mobile:GetLoc()
	local guardTower = FindObjectWithTagInRange("GuardTowerObject",mobileLoc,ServerSettings.PlayerInteractions.GuardTowerProtectionRange)
	if ( guardTower ) then
		return "Protection",guardTower
	end
	
	local teleportTower = FindObjectWithTagInRange("TeleportTowerObject",mobileLoc,ServerSettings.PlayerInteractions.GatekeeperProtectionRange)
	if ( teleportTower ) then
		return "Town",teleportTower
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
-- @param allGuards(boolean) if true will cause all guards to attack vs only neutral
-- @return none
function GuardProtect(victim, aggressor, allGuards)
	Verbose("Guard", "GuardProtect", victim, aggressor, allGuards)
	
	if( TRAILER_BUILD ) then
		do return end
	end

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

	-- call all neutral guards to protect
	ForeachMobileAndPet(aggressor, CallNearbyNeutralGuardsOn)

	-- if not calling all guards, we end here since neutral guards have already been called.
	if ( allGuards ~= true ) then return end

	-- call the non-neutral guards
	ForeachMobileAndPet(aggressor, CallNearbyGuardsOn)


	-- DEBUGING PURPOSES ONLY! FALLBACK DOUBLECHECK. ONCE SOLID THIS CAN BE REMOVED!
	--[[
	-- This will kill players that somehow happen to trigger guards when the victim is guaranteed protection
	if ( IsPlayerCharacter(aggressor) and IsGuaranteedProtected(victim, aggressor) ) then
		LuaDebugCallStack("THIS SHOULDN'T HAPPEN!!!!!")
		ForeachMobileAndPet(aggressor, GuardInstaKill)
	end
	--]]
	-- DEBUGING PURPOSES ONLY! FALLBACK DOUBLECHECK. ONCE SOLID THIS CAN BE REMOVED!
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
	-- ghosts don't need guard protection updated
	if ( IsDead(player) ) then return end

	local curProtection = player:GetObjVar("GuardProtection")
	local newProtection = GetGuardProtection(player)
	
	if(newProtection == curProtection) then return end

    player:SetObjVar("GuardProtection",newProtection)

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
