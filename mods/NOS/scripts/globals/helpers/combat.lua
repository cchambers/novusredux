-- NOTE: Just adding to this table does not add new stats. There are many places in code that reference the stat names directly (We should fix this one day)
allStatsTable = {
	"Strength",
	"Agility",
	"Intelligence",
	"Constitution",
	"Wisdom",
	"Will"
}

-- This is not in server settings because it is deeply engrained in the combat system. Not something that is easily modified
ARMORSLOTS ={
	"Head",
	"Chest",
	"Legs"
}

--- Determine if a mobile is disabled (cannot use items or abilites)
-- @param mobileObj
-- @return true if mobile is disabled.
function IsMobileDisabled(mobileObj)
    Verbose("Combat", "IsMobileDisabled", mobileObj)
	return mobileObj:HasObjVar("Disabled")
end

--- Determine if the mobile has an effect that makes them immune.
-- @param mobileObj
-- @return true if mobile is immune
function IsMobileImmune(mobileObj)
    Verbose("Combat", "IsMobileImmune", mobileObj)
	return ( HasMobileEffect(mobileObj, "Immune") )
end

--- Display the indicator that a mobile is immune
-- @param mobileObj
function DoMobileImmune(mobileObj, type)
	if ( type ) then
		mobileObj:NpcSpeech(string.format("[08FFFF]%s immune[-]", type), "combat")
	else
		mobileObj:NpcSpeech("[08FFFF]immune[-]", "combat")
	end
end

--- Determine if a is withing range of b
-- @param objA gameObj
-- @param objB gameObj
-- @param range double
-- @return true if within in range.
function WithinRange(objA, objB, range)
    Verbose("Combat", "WithinRange", objA, objB, range)
	if( objA == nil or not objA:IsValid() or objB == nil or not objB:IsValid() ) then return false end
	if ( objA == objB ) then return true end
	local distance = objA:DistanceFrom(objB)
    if( distance == nil ) then return false end
    return ( distance <= range )
end

--- Determine if an attacker is within range of a defender given a weaponType.
function WithinWeaponRange(attacker, defender, weaponType)
    Verbose("Combat", "WithinWeaponRange", attacker, defender, weaponType)
    return WithinRange(attacker, defender, GetCombatWeaponRange(attacker, defender, weaponType))
end

--- Determine if an attacker is within range of a defender given a range.
function WithinCombatRange(attacker, defender, range)
    Verbose("Combat", "WithinCombatRange", attacker, defender, range)
    return WithinRange(attacker, defender, GetCombatRange(attacker, defender, range))
end

--- Get the distance attacker must be from defender for combat.
-- @param attacker mobileObj
-- @param defender mobileObj
-- @param range double, weapon range or barehand range if not provided
-- @return distance to consider attacker close enough to defender for combat
function GetCombatRange(attacker, defender, range)
    Verbose("Combat", "GetCombatRange", attacker, defender, range)
	return ( range or Weapon.GetRange("BareHand") ) + GetBodySize(attacker) + GetBodySize(defender)
end

--- Convenience function that does what GetCombatRange does, but instead takes a weaponType as last parameter
-- @param attacker mobileObj (for body size/weapon range)
-- @param defender mobileObj (for body size)
-- @param weaponType(optional) string Defaults to weapon type of primary weapon for attacker
-- @return distance to consider attacker close enough to defender for combat
function GetCombatWeaponRange(attacker, defender, weaponType)
    Verbose("Combat", "GetCombatWeaponRange", attacker, defender, weaponType)
	weaponType = weaponType or GetPrimaryWeaponType(attacker)
	return GetCombatRange(attacker, defender, Weapon.GetRange(weaponType))
end

--- Determine if a gameObj is valid to gain skill on
-- @param gameObj
-- @param gainer
-- @return true if valid to gain skill from this gameObj.
function ValidCombatGainTarget(target,gainer)
	Verbose("Combat", "ValidCombatGainTarget", target,gainer)
	-- players cannot gain against players.
	if ( IsPlayerObject(target) ) then return false end

	-- players cannot gain against mobs with owners/previous owners.
	if ( target:HasObjVar("PreviousOwners") ) then return false end

	if ( target:HasObjVar("InvalidTarget") ) then return false end

	-- objects with attackable can be gained, they will default to 0 skill, (set a skill dictionary on them to change it)
	return ( target:HasModule("attackable_object_skill_gain") or (target:IsMobile() and not IsDead(target) and not target:GetObjVar("Invulnerable")) )
end

--- Determine if an attacker can attack/damage a victim
-- @param attack mobileObj, the mobile doing the targeting.
-- @param victim mobileObj, the mobile being targeted.
-- @return true if valid combat target
function ValidCombatTarget(attacker, victim, silent)
    Verbose("Combat", "ValidCombatTarget", attacker, victim, silent)
	-- validate our attacker and victim
	if ( attacker == nil or victim == nil ) then return false end
	if ( not attacker:IsValid() or not victim:IsValid() ) then return false end
	-- explicitly force a mobile non valid always
	if ( victim:HasObjVar("InvalidTarget") ) then
		if ( IsPlayerCharacter(attacker) ) then
			attacker:SystemMessage("Invalid Target.", "info")
		end
		return false
	end

	--if victim is related to an allegiance, determine if it is attackable by the attacker
	if ( Allegiance.CanAttackAllegianceAttackable(attacker, victim) ~= true ) then
		attacker:SystemMessage("Cannot interfere with Allegiance matters.", "info")
		return false
	end

	if ( victim:IsMobile() ) then
		if ( IsDead(victim) ) then return false end
		-- reassign to owners if applicable
		local victimOwner = victim:GetObjVar("controller")
		-- don't reassign owner if victim is possessed
		if ( victimOwner and victimOwner:IsValid() and not IsPossessed(victim)) then victim = victimOwner end
		local attackerOwner = attacker:GetObjVar("controller")
		if ( attackerOwner and attackerOwner:IsValid() ) then attacker = attackerOwner end
	else
		if ( victim:GetObjVar("Attackable") ~= true ) then return false end
		if ( victim:HasSharedObjectProperty("IsDestroyed") ) then
			return not(victim:GetSharedObjectProperty("IsDestroyed"))
		end
	end

	if ( IsImmortal(attacker) and not TestMortal(attacker) ) then return true end

	local attackerInKarmaZone = WithinKarmaZone(attacker)
	local victimInKarmaZone = WithinKarmaZone(victim)
	if ( 
		-- mobiles in arena (or similar) are not valid to mobiles outside of arena
		(
			victimInKarmaZone and not attackerInKarmaZone
		)
		or
		-- vice versa
		(
			attackerInKarmaZone and not victimInKarmaZone
		)
	) then
		return false
	end

	-- prevent attacking guard protected stuff when the karma protection flag is on
		-- and both involved are in a karma protected zone
	if (
		attackerInKarmaZone
		and
		victimInKarmaZone
		and
		(
			ShouldKarmaProtect(attacker, KarmaActions.Negative.Attack, victim, silent)
			or
			ShouldChaoticProtect(attacker, victim, false, silent)
			or
			IsPlayerCharacter(attacker) and IsGuaranteedProtected(victim, attacker)
		)
	) then
		return false
	end

	-- default to attack everything (sandbox!)
	return true
end

---- TODO: Transition this to IsFriend function ( to help with auto targets and AoE effects )
--- Allow friendly actions to a potential friend?
-- @param mobileObj
-- @param potentialFriend mobileObj
-- @param notSilent(optional) Boolean
-- @param return true or false
function AllowFriendlyActions(mobileObj, potentialFriend, notSilent)
    Verbose("Combat", "AllowFriendlyActions", mobileObj, potentialFriend, notSilent)    

	-- reassign variables to the owner if applicable
	mobileObj = mobileObj:GetObjVar("controller") or mobileObj
	potentialFriend = potentialFriend:GetObjVar("controller") or potentialFriend

	-- always friendly to yourself and your pets.
	if ( mobileObj == potentialFriend ) then return true end

	--can't benefit allegiance mobs
	if ( potentialFriend:HasObjVar("AllegianceAttackable") ) then
		mobileObj:SystemMessage("Cannot interfere with Allegiance matters.", "info")
		return false
	end

	-- prevent friendly actions against bad karma actors unless criminal is enabled.
	if ( ShouldKarmaProtect(mobileObj, KarmaActions.Negative.PunishForBeneficial, potentialFriend, not notSilent) ) then
		return false
	end
	
	if ( ShouldChaoticProtect(mobileObj, potentialFriend, true, not notSilent) ) then
		return false
	end

	-- npcs don't follow further rules
    if ( not IsPlayerCharacter(mobileObj) or not IsPlayerObject(potentialFriend) ) then return true end

	-- allegiance rules
	-- prevent people in an allegiance being benefited by anyone not in their allegiance
	local theirAllegianceId = Allegiance.GetId(potentialFriend)
	-- if potential friend is in an Allegiance
	if ( theirAllegianceId ~= nil ) then
		local myAllegianceId = Allegiance.GetId(mobileObj)
		-- if mobileObj is not in the same Allegiance
		if ( myAllegianceId ~= theirAllegianceId ) then
			-- if potential friend is in a player conflict
			if ( HasAnyActiveConflictRecords(potentialFriend, true) ) then
				if ( notSilent ) then
					mobileObj:SystemMessage("Cannot interfere with active Allegiance conflicts.", "info")
				end
				-- potential friend in an Allegiance and it's not mobileObj's Allegiance, end here.
				return false
			end
		end
	end

	-- allow friendly actions.
	return true
end

function IsCombatMap()
	local worldName = ServerSettings.WorldName
	for i,j in pairs(ServerSettings.Misc.NonCombatMaps) do
		if (worldName == j) then
			return false
		end
	end
	return true
end

--Randomly Selects a location from the list of available slots 
function GetHitLocation()	
	local rnd = math.random(1,100)
	if ( rnd <= 10 ) then return "Head" end
	if ( rnd <= 40 ) then return "Legs" end
	return "Chest"
end

function CheckActiveSpellResist(target)
	-- 0 to 50% chance, 10 will = 0, 50 will = 50%
	if ( Success(0.5*((( GetWis(target) or 0 ) - ServerSettings.Stats.IndividualStatMin) / (ServerSettings.Stats.IndividualPlayerStatCap - ServerSettings.Stats.IndividualStatMin))) ) then
		target:PlayEffect("HoneycombShield", 1)
		return true
	end
	return false
end

function GetArmorProficiencyType(target)
	local armorClass = nil
	for i,slot in pairs(ARMORSLOTS) do
		local item = target:GetEquippedObject(slot)
		local curArmorClass = EquipmentStats.BaseArmorStats.Natural.ArmorClass
		if(item) then
			curArmorClass = GetArmorClass(item)			
		end

		if not(armorClass) then
			armorClass = curArmorClass
		elseif(curArmorClass ~= armorClass) then
			return nil
		end
	end

	return armorClass
end

function PlayWeaponSound(target, audioId, weapon)
	if(weapon == nil) then
		weapon = GetPrimaryWeapon(target)
	end
	if( weapon ~= nil) then
		weapon:PlayObjectSound(audioId, true)
	else
		local soundPrefix = "event:/weapons/hammer/hammer_"
		target:PlayObjectSound(soundPrefix..audioId, false)
	end
end

function PlayShieldSound(target,audioId, shield)
	if(shield == nil) then
		shield = target:GetEquippedObject("LeftHand")
	end
	if( shield ~= nil ) then
		shield:PlayObjectSound(audioId, true)
	end
end

function RandomAttackSoundChance(attacker)
	if(math.random(1,5) == 1) then 
		--D*ebugMessage(attacker:GetName().. " OUCH!")
		attacker:PlayObjectSound("Attack", true) 
	end
end

--- Does the graphic/sound of an arrow flying from one mobile to another
-- @param from mobileObj
-- @param to mobileObj
-- @param weapon gameObj
function PerformClientArrowShot(from, to, weapon)
	PlayAttackAnimation(from)
	from:PlayProjectileEffectTo("ArrowEffect", to, 100, 0, "Bone=Bone_Proj_Source")
	PlayWeaponSound(from, "Shoot", weapon)
end

--- Plays the attack animation for mobileObj
-- @param mobile mobileObj
function PlayAttackAnimation(mobile)
	if ( mobile ) then mobile:PlayAnimation("attack") end
end

-- NOS FROM HERE

mPowerHourTrigger = 1250000

function DoResist(target, resistLevel, damage)
    local resistAmount = (resistLevel * 10 - 400) / 15
    -- target:SystemMessage(tostring("Damage: " .. damage .. " Resist: " .. resistAmount))
    target:PlayEffect("HoneycombShield", 1.5)
    if (target:HasObjVar("ProtectionSpell")) then
        resistAmount = resistAmount - (resistAmount * 0.35)
    end
    return (damage * (resistAmount) * 0.01)
end

-- -- STATS --
-- DebugMessage("TOTEM LOADED")


-- http = LoadExternalModule("http")
-- ltn12 = LoadExternalModule("ltn12")
-- coroutine = LoadExternalModule("coroutine")

--local coroutine = require("coroutine")

function TotemGlobalEvent(task) 
    return
    -- go = coroutine.create(function()
    --     local api = tostring("http://localhost:1337/api/"..task)
        
    --     local payload = ""

    --     if (task == "powerhour") then
    --         payload = [[ { "name": "nada" } ]]
    --         local res, code, response_headers, status =
    --         http.request{
    --             url = api,
    --             method = "POST",
    --             headers = { 
    --                 ["Content-Type"] = "application/json",
    --                 ["Content-Length"] = payload:len()
    --             },
    --             source = ltn12.source.string(payload),
    --             sink = ltn12.sink.table(response_body)
    --         }
    --     end
    -- end)
end

function Totem(mobile, task, args)
    return
    -- go = coroutine.create(function()
    --     local id = mobile.Id
    --     local account = tostring(mobile:GetAttachedUserId())
    --     local ip = tostring(mobile:GetIPAddress())
    --     local name = mobile:GetName()
    --     local api = tostring("http://localhost:1337/api/player/"..task)
    --     local when = tostring(os.date())
    --     local where = tostring(mobile:GetLoc())
    --     local payload = ""

    --     if (task == "murder") then
    --         payload = [[ {"worldid": "]]..id..[["} ]]
    --     elseif (task == "page") then
    --         api = tostring("http://localhost:1337/api/page")
    --         local who = tostring(name .. " (" .. id .. ")")
    --         payload = [[ {
    --             "who": "]]..who..[[",
    --             "what": "]]..args..[[",
    --             "when": "]]..when..[[",
    --             "where": "]]..where..[["
    --         } ]]
    --     elseif (task == "death") then
    --         if (args) then 
    --             payload = [[ {
    --                 "name": "]]..name..[[",
    --                 "aggressor": "]]..args.aggressor..[[",
    --                 "kind": "]]..args.kind..[[",
    --                 "when": "]]..when..[[",
    --                 "where": "]]..where..[["
    --             } ]]
    --         else 
    --             payload = [[ {
    --                 "name": "]]..name..[[",
    --                 "when": "]]..when..[[",
    --                 "where": "]]..where..[["
    --             } ]]
    --         end
    --     else
    --         -- default just updates player
    --         local skill = GetSkillTotal(mobile) or 0
    --         local playMinutes = mobile:GetObjVar("PlayMinutes") or 0
    --         local fame = mobile:GetObjVar("Fame") or 0
    --         local karma = mobile:GetObjVar("Karma") or 0
    --         local staff = IsImmortal(mobile)

    --         payload = [[ {
    --             "account": "]]..account..[[",
    --             "ip": "]]..ip..[[",
    --             "worldid": "]]..id..[[",
    --             "name": "]]..name..[[",
    --             "skillTotal": ]]..skill..[[,
    --             "playMinutes": ]]..playMinutes..[[,
    --             "fame": ]]..fame..[[,
    --             "karma": ]]..karma..[[,
    --             "staff": ]]..tostring(staff)..[[
    --         } ]]
    --     end

    --     -- diff paylods for diff tasks?
    --     local res, code, response_headers, status =
    --         http.request{
    --             url = api,
    --             method = "POST",
    --             headers = { 
    --                 ["Content-Type"] = "application/json",
    --                 ["Content-Length"] = payload:len()
    --             },
    --             source = ltn12.source.string(payload),
    --             sink = ltn12.sink.table(response_body)
    --         }
    -- end)
end


function DonateItem(obj) 
    local obj = obj or this
    local value = GetItemValue(obj) or 10
    if (value < 10) then value = 10 end
    go = coroutine.create(function()
        PowerHourDonate(value)
    end)
    CallFunctionDelayed(TimeSpan.FromSeconds(2), function() 
        obj:Destroy()
    end)
end

function PowerHourDonate(amount) 
    local donations = GlobalVarReadKey("GlobalPowerHour", "Donations") or 0
    donations = donations + amount
	GlobalVarWrite("GlobalPowerHour", nil, function(record) 
        record["Donations"] = donations;
        return true;
	end);
    DebugMessage(tostring("Another item donated! (+" .. amount .. ") > GlobalPowerHour at " .. donations))
    if (donations >= mPowerHourTrigger) then
        local overflow = donations - mPowerHourTrigger
        TriggerGlobalPowerHour(overflow)
    end
end

function TriggerGlobalPowerHour(overflow) 
    DebugMessage("Global Power Hour triggered!")
    GlobalVarWrite("GlobalPowerHour", nil, function(record) 
        record["Donations"] = 0
        record["Ends"] = DateTime.UtcNow:Add(TimeSpan.FromHours(1))
        return true;
    end);
    local online = GlobalVarRead("User.Online") or {}
	local results = {}
	for gameObj,dummy in pairs(online) do
        gameObj:SendMessageGlobal("StartGlobalPowerHour")
    end

    if (overflow > 0) then 
        CallFunctionDelayed(TimeSpan.FromSeconds(2), function() 
            PowerHourDonate(overflow) 
        end)
    end

    TotemGlobalEvent("powerhour")
end


function ColorWarStart()
    local obj = GameObj(68381273)
    obj:SendMessage("ColorWar.Go")
end

function ColorWarVote(user)
    local open = GlobalVarReadKey("ColorWar.Vote", "open")
    if (open) then
        local queued = GlobalVarReadKey("ColorWar.Queue", user)
        if (queued) then
            GlobalVarWrite("ColorWar.Queue", nil, function (record) 
                record[user] = nil
                return true
            end)
            user:SystemMessage("You have un-voted.", "info")
        else
            GlobalVarWrite("ColorWar.Queue", nil, function (record) 
                record[user] = true
                return true
            end)
            user:SystemMessage("You have voted to start Color Wars!", "info")
        end
    else -- VOTE NOT RUNNING
        if (user:HasTimer("NoVote")) then
            user:SystemMessage("You are doing that too quickly.", "info")
            return
        end
        local cwController = GameObj(68381273)
        if (cwController) then
            if (cwController:HasTimer("ColorWar.NoVote")) then
                user:SystemMessage("Color Wars vote can not be started yet.", "info")
                user:ScheduleTimerDelay(TimeSpan.FromSeconds(30), "NoVote")
                return
            else
                GlobalVarWrite("ColorWar.Queue", nil, function (record) 
                    record[user] = true
                    return true
                end)
                cwController:SendMessage("ColorWar.VoteStart")
            end
        end
    end
end