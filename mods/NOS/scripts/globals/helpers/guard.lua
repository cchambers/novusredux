
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
function IsGuaranteedProtected(mobile, from, mobileKarmaLevel, fromKarmaLevel, loc)
	Verbose("Guard", "IsGuaranteedProtected", mobile, from, mobileKaramLevel, fromKarmaLevel)
	local protected = IsProtected(mobile, from, mobileKarmaLevel, fromKarmaLevel, loc, true)

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
function IsProtected(mobile, from, mobileKarmaLevel, fromKarmaLevel, loc, guaranteed)
	Verbose("Guard", "IsProtected", mobile, from, mobileKaramLevel, fromKarmaLevel, guaranteed)
	-- these factors allow fighting anywhere no matter what
	if ( ShareKarmaGroup(mobile, from) or InOpposingAllegiance(mobile, from) ) then
		return false
	end

	-- get ready to potentially cache mobile's guard protection
	local protection
	if ( guaranteed ) then
		-- since there are possible routes that do not require protection, we only get it here first sometimes
		protection = GetGuardProtectionForLoc(loc or mobile:GetLoc())
		-- when checking guaranteed protection, we can always return false on these protection types
		if ( protection == "None" or protection == "Neutral" ) then return false end
	end

	-- if mobileKarmaLevel was no provided, get it from the mobile that was provided.
	if not( mobileKarmaLevel ) then
		mobileKarmaLevel = GetKarmaLevel(GetKarma(mobile))
	end

	-- if mobile is guard protected
	if ( mobileKarmaLevel.GuardProtectPlayer or mobileKarmaLevel.GuardProtectNPC ) then
		-- if mobile is a player object (player/corpse/pet/etc)
		if ( IsPlayerObject(mobile) ) then
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
						protection = GetGuardProtectionForLoc(loc or mobile:GetLoc())
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

--- Get the protection type for a specific loc
-- @param loc
-- @return "None", "Neutral", "Protection", "Town"
function GetGuardProtectionForLoc(loc)
	Verbose("Guard", "GetGuardProtectionForLoc", tostring(loc))
	local ss = ServerSettings.PlayerInteractions

    --if this setting is enabled do for the entire map
    if ( ss.GuaranteedTownProtectionFullMap ) then
        return "Town"
	end
	
	if ( IsLocInRegion(loc,"Arena") ) then
		return "None"
	end

	if ( ss.TownProtectionZones ) then
		for i=1,#ss.TownProtectionZones do
			if ( IsLocInRegion(loc,ss.TownProtectionZones[i]) ) then
				return "Town"
			end
		end
	end

	if ( ss.ProtectionZones ) then
		for i=1,#ss.ProtectionZones do
			if ( IsLocInRegion(loc,ss.ProtectionZones[i]) ) then
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
			if ( IsLocInRegion(loc,ss.NeutralZones[i]) ) then
				return "Neutral"
			end
		end
	end

	local guardTower = FindObjectWithTagInRange("GuardTowerObject",loc,ss.GuardTowerProtectionRange)
	if ( guardTower ) then
		return "Protection",guardTower
	end
	
	local teleportTower = FindObjectWithTagInRange("TeleportTowerObject",loc,ss.GatekeeperProtectionRange)
	if ( teleportTower ) then
		return "Town",teleportTower
	end

    return "None"
end

--- Get the protection type for a mobile
-- @param mobile
-- @return "None", "Neutral", "Protection", "Town"
function GetGuardProtection(mobile)
	return GetGuardProtectionForLoc(mobile:GetLoc())
end

--- Calling this on a lua vm context (attached module) will return the all guards near the gameObj of the lua VM context.
-- @return guards(luaTable of mobileObjs) or empty table
function GetNearbyGuards(neutral)
	local nearbyGuards = nil
	
	if ( neutral ) then
		return FindObjects(SearchMulti(
		{
			SearchMobileInRange(40), -- hacked to 40 until better super guards are implemented.
			SearchHasObjVar("IsNeutralGuard")
		})) or {}
	else
		return FindObjects(SearchMulti(
		{
			SearchMobileInRange(40), -- hacked to 40 until better super guards are implemented.
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
-- @return none
function GuardProtect(victim, aggressor)
	Verbose("Guard", "GuardProtect", victim, aggressor)
	
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

	-- call the non-neutral guards
	ForeachMobileAndPet(aggressor, CallNearbyGuardsOn)
end

--- Neutral guard protect mobileB from mobileA
-- @param mobileB
-- @param mobileA
-- @param isPlayerB
-- @param isPlayerA
-- @param locB
function NeutralGuardProtect(mobileB, mobileA, isPlayerB, isPlayerA, locB)
	if (
        -- if B is player and in neutral guard protection
        isPlayerB and GetGuardProtectionForLoc(locB or mobileB:GetLoc()) == "Neutral"
        and
        (
            -- A is player not sharing karma group / not in opposing faction
            (
                isPlayerA
                and
                not ShareKarmaGroup(mobileA, mobileB)
                and
                not InOpposingAllegiance(mobileA, mobileB)
            )
            or
            -- or A is non-guard protected npc (like a beetle or something)
            (
                not isPlayerA -- is npc
                and
                not GetKarmaLevel(GetKarma(mobileA)).GuardProtectNPC -- not guard protected
            )
        )
	) then
		-- nuke em
        ForeachMobileAndPet(mobileA, GuardInstaKill)
    end
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
	else
		aggressor:SetObjVar("guardKilled", true)
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

	-- always check so we can remove initiate if they remain in unguarded too long
	CheckInitiateProtection(player, newProtection)
	
	if(newProtection == curProtection) then return end

    player:SetObjVar("GuardProtection", newProtection)

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


function IsGuardEnemy(targetObj, guard, AI)
    if (targetObj == nil or not targetObj:IsValid()) then return true end
    if (targetObj:HasObjVar("IsGuard")) then return false end
    if (targetObj:HasObjVar("IsNeutralGuard")) then return false end

    if not( AI.IsValidTarget(targetObj) ) then return false end

    if ( AI.MainTarget == targetObj ) then return true end

    if ( targetObj:GetObjVar("GuardIgnore") ) then return false end

    -- get the karma level of the targetObj
	local karmaLevel = GetKarmaLevel(GetKarma(targetObj))
	
    -- handle NPCs (cept pets)
    if not( IsPlayerObject(targetObj) ) then

        if ( karmaLevel.GuardHostileNPC ) then return true end

        -- if guards protect this npc, they are never an enemy. 
        if ( karmaLevel.GuardProtectNPC or targetObj:HasObjVar("ImportantNPC") ) then return false end

        -- guards always attack monsters that are not pets
        if ( targetObj:GetMobileType() == "Monster" ) then return true end

        return false
    end

    -- here down is players/pets

    -- if this guard is not neutral
    if ( guard:GetObjVar("IsNeutralGuard") ~= true ) then
        -- outcasts, for example, are attacked as soon as the guard sees them.
        if ( karmaLevel.GuardHostilePlayer ) then return true end
    end

    if ( IsPet(targetObj) ) then
        -- guards attack pets that have enemy owners
        local owner = GetPetOwner(targetObj) or targetObj
        if ( targetObj ~= owner ) then return IsGuardEnemy(owner, guard, AI) end
    end

    -- if guards kill aggressors
    if ( ServerSettings.Conflict.GuardsKillAggressors == true ) then
        -- and if the target object is an aggressor(guardIgnore==true), they are an enemy to this guard.
        if ( IsAggressor(targetObj, true) ) then return true end
    end

    return false
end