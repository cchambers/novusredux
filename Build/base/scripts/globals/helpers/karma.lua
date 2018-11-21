--- Get the Karma for a mobile
-- @param mobile(mobileObj)
-- @return Amount of Karma the mobile has(number), 0 if Karma is not set
function GetKarma(mobile)
    Verbose("Karma", "GetKarma", mobile)
    if ( mobile == nil ) then
        LuaDebugCallStack("[Karma] Nil mobile provided to GetKarma()")
        return
    end
    -- important npcs are off the charts.
    if ( mobile:HasObjVar("ImportantNPC") ) then return 100000 end

    return mobile:GetObjVar("Karma") or 0
end

--- Set a mobiles karma to an exact amount, does not adjust.
-- @param mobile(mobileObj)
-- @param amount(number) The exact number to set their Karma too
-- @return none
function SetKarma(mobile, amount)
    Verbose("Karma", "SetKarma", mobile, amount)
    if ( mobile == nil ) then
        LuaDebugCallStack("[Karma] Nil mobile provided to SetKarma()")
        return
    end
    mobile:SetObjVar("Karma", amount)
end

--- Convert an amount of karma gained/lost to a string representation
-- @param amount(number)
-- @return string amount
function GetKarmaStringAmount(amount)
    Verbose("Karma", "GetKarmaStringAmount", amount)
    if ( amount < 10 ) then
        return " a little "
    elseif ( amount < 50 ) then
        return " some "
    elseif ( amount < 100 ) then
        return " "
    elseif ( amount < 1000 ) then
        return " a lot of "
    else
        return " a substantial amount of "
    end
end

--- Adjust the karma for a mobile, a system message pertaining to the change is sent.
-- @param mobile(mobileObj)
-- @param amount(number) The amount to adjust by.
-- @return none
function AdjustKarma(mobile, amount)
    Verbose("Karma", "AdjustKarma", mobile, amount)
    if ( amount == 0 or amount == nil ) then return end
    local karma = GetKarma(mobile)
    -- cache the karma level so we can check if it changed.
    local karmaLevel = GetKarmaLevel(karma)

    karma = math.floor(karma + amount + 0.5)
    SetKarma(mobile, karma)

    if ( amount > 0 ) then
        mobile:SystemMessage("You have gained"..GetKarmaStringAmount(amount).."karma.", "info")
    else
        mobile:SystemMessage("You have lost"..GetKarmaStringAmount(math.abs(amount)).."karma.", "info")
    end

	local newKarmaLevel = GetKarmaLevel(karma)
	if ( karmaLevel.Name ~= newKarmaLevel.Name ) then
        -- Karma was changed, update the name and whatever else, maybe a message?
        if ( newKarmaLevel.DisallowAllegiance ) then AllegianceRemovePlayer(mobile) end
        mobile:SystemMessage("Your karma level is now "..newKarmaLevel.Name, "event")
        -- update all pets
        local activePets = GetActivePets(mobile, nil, true)
        for i=1,#activePets do
            activePets[i]:SetObjVar("Karma", karma)
            activePets[i]:SendMessage("UpdateName")
        end
        -- update the name
        mobile:SendMessage("UpdateName")
    end
end

--- convenience function to alter a karma action's amount before applying it
-- @param karmaAction Lua table karma action
-- @param newAmount(number)
-- @return the altered karma action
function AlterKarmaAction(karmaAction, newAmount)
    Verbose("Karma", "AlterKarmaAction", karmaAction, newAmount)
    karmaAction = deepcopy(karmaAction)
    karmaAction.Adjust = newAmount
    return karmaAction
end

--- Get the karma level data table for the given amount of karma.
-- @param karma(number) return value of GetKarma()
-- @return KarmaLevelData(luaTable) from ServerSettings.Karma.Levels
function GetKarmaLevel(karma)
    Verbose("Karma", "GetKarmaLevel", karma)
    karma = karma or 0
    if ( karma >= 0 ) then
        for i,data in pairs(ServerSettings.Karma.Levels) do
            if ( karma >= data.Amount ) then return data end
        end
    elseif ( karma < 0 ) then
        --negative karma we check the list backwards
        local ii = #ServerSettings.Karma.Levels
        for i,data in pairs(ServerSettings.Karma.Levels) do
            if ( ServerSettings.Karma.Levels[ii].Amount >= karma ) then
                return ServerSettings.Karma.Levels[ii]
            end
            ii = ii - 1
        end
    end
end

--- Are they a player as far as Karma is concerned?
-- @param mobile
-- @return boolean true, second boolean is for isPet
function IsKarmaPlayer(mobile)
    Verbose("Karma", "IsKarmaPlayer", mobile)
    -- check traditional and player corpse
    local isPlayer = IsPlayerCharacter(mobile) or IsPlayerCorpse(mobile)
    -- if not a player check if it's a pet
    local isPet = false
    if ( isPlayer == false ) then isPet = IsPet(mobile) end
    if ( isPet ) then isPlayer = true end
    return isPlayer, isPet
end

--- Perform the actual karma handling for a karma action, will adjust mobileA's karma appropriately(if at all) for the given action.
-- @param mobileA the mobile that is performing the karma action
-- @param karmaAction(table) The KarmaActions.Positive/KarmaActions.Negative for the action.
-- @param mobileB(mobileObj)(optional) The mobile that the karma action is being performed on(if any)
-- @return none
function ExecuteKarmaAction(mobileA, action, mobileB)
	Verbose("Karma", "ExecuteKarmaAction", mobileA, action, mobileB)
    if ( mobileA == nil ) then
        LuaDebugCallStack("[Karma] Nil mobileA provided, need at least one mobile for a karma action.")
        return
    end
    if ( action == nil ) then
        LuaDebugCallStack("[Karma] Nil action supplied.")
        return
    end
    if ( action.Adjust == nil ) then
        LuaDebugCallStack("[Karma] Supplied action without 'Adjust', this karma action is invalid until resolved.")
        return
    end

    -- if mobileB is passed, ensure mobileA is not mobileB and mobileB is in the same region.
    if ( mobileB ~= nil and (mobileB == mobileA or not mobileB:IsValid()) ) then return end
    
    -- karma adjustments can only be applied to players
    if not( IsPlayerCharacter(mobileA) ) then return end

    local karmaA = GetKarma(mobileA)

    -- if they cannot be affected by this karma action any further, stop here.
    if ( action.Adjust < 0 ) then
        if ( action.UpTo and karmaA < action.UpTo ) then return end
    else
        if ( action.UpTo and karmaA > action.UpTo ) then return end
    end

    -- ensure they are both within the karma area.
    if ( not WithinKarmaArea(mobileA) and (mobileB ~= nil and not WithinKarmaArea(mobileB)) ) then
        return
    end

    local isPlayerB = false
    local karmaB = 0

    -- setup mobileB if supplied
    if ( mobileB ~= nil ) then
        local isPetB = false
        isPlayerB, isPetB = IsKarmaPlayer(mobileB)
        if ( isPetB ) then mobileB = mobileB:GetObjectOwner() or mobileB end
        karmaB = GetKarma(mobileB)
    end
    
    local conflictMod = 1
    local pvpMod = 1
    local negativeAdjustMod = 1
    local npcMod = 1

    -- players in opposing factions (and sometimes guilds) never effect each other's karma
    if ( isPlayerB and (ShareKarmaGroup(mobileA, mobileB) or InOpposingAllegiance(mobileA, mobileB)) ) then return end

    -- handle negative karma actions
    if ( action.Adjust < 0 ) then

        local karmaALevel = nil
        if ( mobileB ~= nil ) then
            local karmaBLevel = GetKarmaLevel(karmaB)
            -- if guards don't protect them, they are free to perform negative actions on.
            -- the guards are the metaphorical judge/jury/(literal)executioner
            if ( (not isPlayerB and karmaBLevel.GuardProtectNPC ~= true) 
                or (isPlayerB and karmaBLevel.GuardProtectPlayer ~= true) ) then return end

            if ( isPlayerB ) then
                --determine their player vs player modifiers
                karmaALevel = GetKarmaLevel(karmaA)
                karmaBLevel = karmaBLevel or GetKarmaLevel(karmaB)
                pvpMod = karmaALevel.PvPMods[karmaBLevel.Name]
                -- anytime an initiate gets to this point, we remove their intiate status (if the action says to)
                if ( action.EndInitiate and IsInitiate(mobileA) ) then EndInitiate(mobileA) end
            else
                if ( mobileB ~= nil and action.NpcModifier ~= nil ) then
                    -- if mobileB is not a player, modify as such
                    npcMod = action.NpcModifier
                end
            end

            -- get conflict mod
            if ( pvpMod > 0 ) then
                if ( ConflictEquals(GetConflictRelation(mobileB, mobileA), ConflictRelations.Aggressor) ) then
                    --victim/defender karma action against aggressor, this is free.
                    conflictMod = 0
                end
            end

        end
        
        if ( pvpMod > 0 and conflictMod > 0 ) then
            -- determine the negative karma adjust mod
            karmaALevel = karmaALevel or GetKarmaLevel(karmaA)
            negativeAdjustMod = karmaALevel.NegativeKarmaAdjustMod
        end
    
    else
        -- handle positive karma actions

    end

    --[[
    DebugMessage("--Execute Karma Action--")
    DebugMessage("Adjust: "..action.Adjust)
    DebugMessage("conMod: "..conflictMod)
    DebugMessage("pvpMod: "..pvpMod)
    DebugMessage("negMod: "..negativeAdjustMod)
    DebugMessage("npcMod: "..npcMod)
    ]]

    local adjust = action.Adjust * conflictMod * pvpMod * negativeAdjustMod * npcMod

    -- prevent positive actions from going negative
    if ( action.Adjust > 0 and adjust < 0 ) then return end
    -- prevent negative actions from going positive
    if ( action.Adjust < 0 and adjust > 0 ) then return end

    -- finally apply all the calculated karma
    AdjustKarma(mobileA, adjust)
end

--- Check when a player performs a beneficial action on a mobile(player/npc/etc)
-- @param player(playerObj) DOES NOT ENFORCE IsPlayerCharacter()
-- @param mobile(mobileObj) Anything with a karma level
-- @return none
function CheckKarmaBeneficialAction(player, mobileB)
    Verbose("Karma", "CheckKarmaBeneficialAction", player, mobileB)
    -- can't get in trouble for benefiting yourself
    if ( player == mobileB ) then return end
    -- beneficial actions are only bad against some
    local karmaLevelB = GetKarmaLevel(GetKarma(mobileB))
    local isPlayerB, isPetB = IsKarmaPlayer(mobileB)
    if (
        (isPlayerB and karmaLevelB.PunishBeneficialToPlayer)
        or
        (not isPlayerB and karmaLevelB.PunishBeneficialToNPC)
    ) then
        ExecuteKarmaAction(player, KarmaActions.Negative.PunishForBeneficial)
    end
    if ( isPlayerB ) then
        -- if mobileB is a pet, get the owner instead.
        if ( isPetB ) then mobileB = mobileB:GetObjectOwner() or mobileB end
        -- when players benefit players, they inherit their aggressive conflict relations.
        InheritAggressivePlayerConflicts(mobileB, player)
    end
end

--- Returns true if the player should be karma protected from performing a harmful action on target
-- @param player
-- @param target
-- @return true or false
function ShouldKarmaProtect(player, target, silent)
    Verbose("Karma", "ShouldKarmaProtect", player, target, silent)
    if ( player == nil ) then
        LuaDebugCallStack("[ShouldKarmaProtect] Nil player provided")
        return
    end
    if ( target == nil ) then
        LuaDebugCallStack("[ShouldKarmaProtect] Nil target provided")
        return
    end
    if ( player:GetObjVar("KarmaProtectionEnabled") == true ) then
        local isPlayer, isPet = IsKarmaPlayer(target)
        if ( isPet ) then target = target:GetObjectOwner() or target end
		local karmaLevel = GetKarmaLevel(GetKarma(target))
		if (
            (
                isPlayer
                and
                karmaLevel.GuardProtectPlayer
                and
                not ShareKarmaGroup(player, target)
                and
                not InOpposingAllegiance(player, target)
            )
			or
			(not isPlayer and karmaLevel.GuardProtectNPC)
        ) then
            if not( ConflictEquals(GetConflictRelation(target, player), ConflictRelations.Aggressor) ) then
                if ( not silent and not player:HasTimer("KarmaWarned")  ) then
                    player:ScheduleTimerDelay(ServerSettings.Karma.MinimumBetweenNegativeWarnings, "KarmaWarned")
                    player:SystemMessage("That action would cause you to lose karma.", "info")
                end
                return true
            end
		end
    end
    return false
end

--- Check player against a container on a loot (item removed from a container)
-- @param player(playerObj) Player doing the looting
-- @param container(Container) Container being looted from (mobileB:TopmostContainer())
-- @return false if should prevent
function CheckKarmaLoot(player, container)
    Verbose("Karma", "CheckKarmaLoot", player, container)
    if ( container == nil ) then
        LuaDebugCallStack("[CheckKarmaLoot] Nil container provided.")
        return false
    end
    if (container:IsPermanent()) then return end
    -- can't get in trouble doing stuff to yourself..
    if ( player == container ) then return end
    -- only mobiles supported right now
    if not( container:IsMobile() ) then return end

    local containerOwner = nil
    -- re-assign the container to the owner if applicable.
    if ( container:GetCreationTemplateId() == "player_corpse" ) then
        containerOwner = container:GetObjVar("BackpackOwner")
    else
        if ( IsPet(container) ) then
            containerOwner = container:GetObjectOwner() or container
        else
            containerOwner = container
        end
    end

    -- can't get in trouble doing stuff to yourself or your pets
    if ( containerOwner == nil or player == containerOwner ) then return end

    local isPlayer = IsPlayerCharacter(containerOwner)

    local karmaLevel = GetKarmaLevel(GetKarma(containerOwner))
    if (
        (isPlayer and karmaLevel.GuardProtectPlayer)
        or
        (not isPlayer and karmaLevel.GuardProtectNPC)
    ) then
        if ( ShouldKarmaProtect(player, containerOwner) ) then return false end
        -- if looting a player owned container that's not theirs, advance the conflict
        AdvanceConflictRelation(player, containerOwner, KarmaActions.Negative.LootContainer)
        return
    else
        if ( IsMobTaggedBy(containerOwner, player) == false ) then
            if ( player:GetObjVar("KarmaProtectionEnabled") == true and not player:HasTimer("KarmaWarned") ) then
                player:ScheduleTimerDelay(ServerSettings.Karma.MinimumBetweenNegativeWarnings, "KarmaWarned")
                local groupId = GetGroupId(player)
                if ( groupId ~= nil and containerOwner:GetObjVar("TagGroup") == groupId ) then
                    player:SystemMessage("Not your turn, looting would cause karma loss.", "info")
                else
                    player:SystemMessage("That is not your kill, looting would cause karma loss.", "info")
                end
                return false
            end
            -- the container is not tagged by the player, therefor the player doesn't have the right to loot.
            -- advance the conflict against all TagKillers (Those close enough for a chance at loot when it died, aka the ones being wronged)
            local killers = containerOwner:GetObjVar("TagKillers") or {}
            for i=1,#killers do
                local killer = killers[i]
                if ( killer ~= player and killer:IsValid() ) then
                    AdvanceConflictRelation(player, killer, KarmaActions.Negative.LootUnownedKill)
                end
            end
        end
    end
end

--- Anyone that is an aggressor to the victim will have a Murder Karma action executed on them.
-- @param victim(mobileObj)
-- @return none
function KarmaPunishAllAggressorsForMurder(victim)
    Verbose("Karma", "KarmaPunishAllAggressorsForMurder", victim)
    ForeachAggressor(victim, function(aggressor)
		if ( victim ~= aggressor and aggressor:IsValid() ) then
			ExecuteKarmaAction(aggressor, KarmaActions.Negative.Murder, victim)
		end
	end)
end

--- Colorize a mobile name dependant on their karma
-- @param mobile(mobileObj) the mobile used to decide the name color
-- @param newName(string) The name to be colorized
-- @return colorized newName(string)
function ColorizeMobileName(mobile, newName)
    Verbose("Karma", "ColorizeMobileName", mobile, newName)
    if ( mobile == nil ) then
        LuaDebugCallStack("[Karma] Nil mobile supplied to ColorizeMobileName")
        return newName
    end

    local color = nil

    if ( mobile:GetObjVar("ImportantNPC") ~= nil ) then
        color = "F2F5A9"
    else
        color = GetKarmaLevel(GetKarma(mobile)).NameColor
    end
    
	return string.format("[%s]%s[-]", color, newName)
end

--- Colorize a player's name dependant on their karma
-- @param player(mobileObj) the playerObj used to decide the name color
-- @param newName(string) The name to be colorized
-- @return colorized newName(string)
function ColorizePlayerName(player, newName)
    Verbose("Karma", "ColorizePlayerName", player, newName)
    if ( player == nil ) then
        LuaDebugCallStack("[Karma] Nil player supplied to ColorizePlayerName")
        return newName
    end

    local color = player:GetObjVar("NameColorOverride")

    if ( color == nil ) then
        if ( IsImmortal(player) and not TestMortal(player) ) then color = "FFBF00" end
    end

    if ( color == nil ) then
        color = GetKarmaLevel(GetKarma(player)).NameColor
    end

	return string.format("[%s]%s[-]", color, newName)
end

--- Perform the positive karma action Daily Login with checks
-- @param player(playerObj)
-- @return none
function DailyLogin(player)
    Verbose("Karma", "DailyLogin", player)
    local lastDailyLoginReward = player:GetObjVar("KarmaDaily")
    local now = DateTime.UtcNow
    if ( lastDailyLoginReward == nil or lastDailyLoginReward + ServerSettings.Karma.DailyLoginInterval < now ) then
        player:SetObjVar("KarmaDaily", now)
		ExecuteKarmaAction(player, KarmaActions.Positive.DailyLogin)
    end
end

--- Determine if a mobile is in a local zone region (Checks only specific Zones)
-- @param mobileObj
-- @return true/false
function WithinKarmaZone(mobileObj)
    Verbose("Karma", "WithinKarmaZone", mobileObj)
	for i,j in pairs(ServerSettings.Karma.DisableKarmaZones) do
		if ( mobileObj:IsInRegion(j) ) then return false end
    end
    return true
end

--- Determine if a mobile is in a location that karma matters (Check RegionAddress and Specific zones)
-- @param mobileObj
-- @return true/false
function WithinKarmaArea(mobileObj)
    Verbose("Karma", "WithinKarmaArea", mobileObj)
    -- first check region address
	local regionAddress = GetRegionAddress()
	for i,disabledRegionAddress in pairs(ServerSettings.Karma.DisableKarmaRegionAddresses) do
		if ( regionAddress == disabledRegionAddress ) then
			return false
		end
    end
    -- then check zone
    return WithinKarmaZone(mobileObj)
end