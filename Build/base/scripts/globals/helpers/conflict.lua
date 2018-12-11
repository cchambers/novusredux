

ConflictRelations = {
    Aggressor = {
        Name = "Aggressor",
    },
    Victim = {
        Name = "Victim"
    },
    Defender = {
        Name = "Defender"
    }
}

--- Get the conflict table for a mobile
-- @param mobile(mobileObj)
-- @return luaTable containing all conflicts for this mobile
function GetConflictTable(mobile)
    if ( mobile == nil or not mobile ) then
        LuaDebugCallStack("[Conflict] Invalid mobile provided.")
        return {}
    end
    return mobile:GetObjVar("Conflicts") or {}
end

--- Clear the conflict table of a mobile
-- @param mobile(mobileObj)
-- @return none
function ClearConflictTable(mobile)
    if ( mobile == nil or not mobile ) then
        LuaDebugCallStack("[Conflict] Invalid mobile provided.")
        return
    end
    if ( mobile:HasObjVar("Conflicts") ) then
        mobile:DelObjVar("Conflicts")
    end
end

--- Set the conflict table for a mobile
-- @param mobile(mobileObj)
-- @param data(luaTable)
-- @return none
function SetConflictTable(mobile, data)
    mobile:SetObjVar("Conflicts", data)
end

--- Freeze the conflict table on a mobile, optionally saving the frozen table on a different object. Will clear all conflicts for the mobile if target does not equal mobile.
-- @param mobile(mobileObj)
-- @param target(gameObj)(optional) the gameObj the conflict table will be saved to
-- @return none
function FreezeConflictTable(mobile, target)
    if ( target == nil ) then target = mobile end
    local conflictTable = GetConflictTable(mobile)
    for mobileB,conflict in pairs(conflictTable) do
        -- set all the expires to true, meaning they never expire
        conflictTable[mobileB][2] = true
    end
    -- save the frozen table on the target
    SetConflictTable(target, conflictTable)
end

-- Determine if a gameObj has any active conflicts of any type.
-- @param target(gameObj)
-- @return boolean true if any active conflicts on @target, false otherwise
function HasAnyActiveConflictRecords(target)
    for obj,relation in pairs(GetConflictTable(target)) do
        if ( ValidConflictRelationTable(relation) ) then
            return true
        end
    end
    return false
end

--- Get the relation of conflict mobileA is to mobileB.
-- @param mobileA(mobileObj)
-- @param mobileB(mobileObj)
-- @param mobileAConflictTable(optional) return value from GetConflictTable()
-- @return One of ConflictRelations, nil if not-found/expired.
function GetConflictRelation(mobileA, mobileB, mobileAConflictTable)
    mobileAConflictTable = mobileAConflictTable or GetConflictTable(mobileA) or {}
    -- only valid, frozen/non-expired, will make the cut.
    if ( ValidConflictRelationTable(mobileAConflictTable[mobileB]) ) then
        return mobileAConflictTable[mobileB][1]
    end
    return nil
end

--- Validate a conflict relation table (make sure it's not expired)
-- @param conflictRelationTable(luaTable) A single entry from return value GetConflictTable()
-- @return true if valid, false if not
function ValidConflictRelationTable(conflictRelationTable)
    return (
        conflictRelationTable ~= nil
        and
        (
            -- frozen
            conflictRelationTable[2] == true
            or
            -- or non-expired
            DateTime.UtcNow < conflictRelationTable[2]
        )
    )
end

--- Update the conflict relation between two mobiles, also cleans mobileA's conflict table of any expired.
-- @param mobileA(mobileObj)
-- @param mobileB(mobileObj)
-- @param newRelation(luaTable) the entry from ConflictRelations
-- @param guardCheck(boolean) If true, this update will check for guard protection, this way you can refresh a conflict on both sides but only one will care check guards.
-- @return none
function UpdateConflictRelation(mobileA, mobileB, isPlayerA, isPlayerB, newRelation, guardCheck)
    Verbose("Conflict", "UpdateConflictRelation", mobileA, mobileB, isPlayerA, isPlayerB)
    if ( newRelation == nil ) then
        LuaDebugCallStack("[Conflict] Nil conflict relation table provided")
        return
    end
    if ( newRelation.Name == nil ) then
        LuaDebugCallStack("[Conflict] Invalid conflict relation table, missing Name")
        return
    end
    if ( mobileA == nil ) then
        LuaDebugCallStack("[Conflict] Nil mobileA provided.")
        return
    end
    if ( mobileB == nil ) then
        LuaDebugCallStack("[Conflict] Nil mobileB provided.")
        return
    end

    local tableA = GetConflictTable(mobileA)
    local wasGuardIgnored = false
    if ( not guardCheck and tableA[mobileB] ~= nil and tableA[mobileB][3] ) then
        wasGuardIgnored = true
    end

    local now = DateTime.UtcNow
    -- cleanse table of any expired.
    for k,v in pairs(tableA) do
        if (
            -- if not mobile of current update
            k ~= mobileB
            and
            -- if not frozen
            v[2] ~= true
            and
            -- if expired
            v[2] < now
        ) then
            -- clear the entry
            tableA[k] = nil
        end
    end
    
    -- set/update the conflict
    tableA[mobileB] = {newRelation.Name}
    -- set when the conflict should end
    tableA[mobileB][2] = now:Add(ServerSettings.Conflict.RelationDuration)

    -- if mobileA's new relation is aggressor
    if ( ConflictEquals(newRelation.Name, ConflictRelations.Aggressor) ) then
        local karmaBLevel = GetKarmaLevel(GetKarma(mobileB))
        local karmaALevel = nil

        if ( isPlayerA and isPlayerB ) then
            -- mobileB has zero karma concequences against mobileA
            -- Turn mobileA AGGRESSIVE on mobileB's client (so B is looking at an aggressive A)
            mobileA:SendClientMessage("UpdateMobileConflictStatus",{mobileB,"Aggressor",ServerSettings.Conflict.RelationDuration.TotalSeconds})
            mobileB:SendClientMessage("UpdateMobileConflictStatus",{mobileA,"Aggressed",ServerSettings.Conflict.RelationDuration.TotalSeconds})

            if ( karmaBLevel.IsChaotic ) then
                karmaALevel = GetKarmaLevel(GetKarma(mobileA))
                if ( karmaALevel.Amount > karmaBLevel.Amount and WithinKarmaZone(mobileA) and WithinKarmaZone(mobileB) ) then
                    mobileA:SendMessage("StartMobileEffect", "Chaotic")
                end
            end
        end

        -- Handle Guard protection triggers for aggressive actions.
        if ( guardCheck ) then
            if not( karmaBLevel ) then
                karmaBLevel = GetKarmaLevel(GetKarma(mobileB))
            end
            local guardIgnore = true

            -- if mobileB's karma level is guard protected
            if (
                -- if B is not player
                ( not isPlayerB and karmaBLevel.GuardProtectNPC )
                or
                ( -- if B is player
                    isPlayerB
                    and
                    not ShareKarmaGroup(mobileA, mobileB)
                    and
                    not InOpposingAllegiance(mobileA, mobileB)
                )
            ) then
                -- allGuards vs neutral only
                local allGuards = IsProtected(mobileB, mobileA, karmaBLevel, karmaALevel or GetKarmaLevel(GetKarma(mobileA)))
                -- make the guards protect B from A
                GuardProtect(mobileB, mobileA, allGuards)
                -- only if you are guard protected (neutral don't count) is this aggressive action guard ignored (they won't attack you on sight)
                if ( allGuards ) then guardIgnore = false end
            end

            -- if guards don't protect mobileB's karma level, add an ignore guard entry
            -- (This is so, for example, players can be aggressors against an outcast, but guards won't attack them for being aggressors against outcasts)
            if ( guardIgnore == true ) then tableA[mobileB][3] = true end
        end
        -- when skipping guard protect checks this value would be ignored and overwritten if not cached from previous data.
        if ( wasGuardIgnored ) then tableA[mobileB][3] = true end
    end

    -- save the updated conflict table for the mobile
    SetConflictTable(mobileA, tableA)
end

--- Convenience function to make checking conflicts more readable
-- @param strRelation(string) The string Name of the relation to check for
-- @param tableRelation(luaTable) The ConflictRelations entry to check against
-- @return true or false
function ConflictEquals(strRelation, tableRelation)
    return ( strRelation == tableRelation.Name )
end

--- Advance mobileA against mobileB in conflict, will also refresh any current conflicts between the two.
-- @param mobileA(mobileObj)
-- @param mobileB(mobileObj)
-- @param karmaAction(luaTable)(optional) KarmaAction that will be executed on mobileA if they are an aggressor, when passed will prevent default negative action 'Attack' for becoming an aggressor
-- @param neverGuards(boolean) if true, this advance will never call guards
-- @return none
function AdvanceConflictRelation(mobileA, mobileB, karmaAction, neverGuards)
    Verbose("Conflict", "AdvanceConflictRelation", mobileA, mobileB, karmaAction, neverGuards)

    local ownerA, ownerB = mobileA:GetObjectOwner(), mobileB:GetObjectOwner()
    -- reassign to owners if applicable
    if ( ownerA ~= nil ) then mobileA = ownerA end
    if ( ownerB ~= nil ) then mobileB = ownerB end
    -- conflict don't care what you do to yourself or your pets
    if ( mobileA == mobileB ) then return end

    local isPlayerA, isPlayerB = IsPlayerCharacter(mobileA), IsPlayerCharacter(mobileB)

    local aToBRelation = GetConflictRelation(mobileA, mobileB)
    local bToARelation = GetConflictRelation(mobileB, mobileA)
    local refreshA = true
    local refreshB = true

    -- when one side has a relation but the other side does not, we count neither side as having a relation.
        -- this is so we can clear a conflict relation on either side and not need to clear both involved parties (the other involved could be in a different region at time of clearing!)
    if ( aToBRelation == nil or bToARelation == nil  ) then
        -- A becomes aggressor, B becomes victim.
        UpdateConflictRelation(mobileA, mobileB, isPlayerA, isPlayerB, ConflictRelations.Aggressor, not neverGuards)
        UpdateConflictRelation(mobileB, mobileA, isPlayerA, isPlayerB, ConflictRelations.Victim)
        refreshA = false
        refreshB = false
        -- warn players when they are attacked by other players
        if ( isPlayerA and isPlayerB ) then
            mobileB:SystemMessage(string.format("%s [FF8C00]is attacking you![-]", StripColorFromString(mobileA:GetName())), "info")
        end
        -- Karma action for becoming the aggressor
        ExecuteKarmaAction(mobileA, karmaAction or KarmaActions.Negative.Attack, mobileB)
    elseif ( ConflictEquals(aToBRelation, ConflictRelations.Victim) ) then
        -- A was a victim, now A is a defender.
        UpdateConflictRelation(mobileA, mobileB, isPlayerA, isPlayerB, ConflictRelations.Defender)
        refreshA = false
    elseif ( karmaAction and ConflictEquals(aToBRelation, ConflictRelations.Aggressor) ) then
        -- karma action for repeated agressive actions
        ExecuteKarmaAction(mobileA, karmaAction, mobileB)
    end

    -- refresh the conflict expiration.
    if ( aToBRelation ~= nil and refreshA ) then
        UpdateConflictRelation(mobileA, mobileB, isPlayerA, isPlayerB, ConflictRelations[aToBRelation], not neverGuards)
    end
    if ( bToARelation ~= nil and refreshB ) then
        UpdateConflictRelation(mobileB, mobileA, isPlayerA, isPlayerB, ConflictRelations[bToARelation])
    end
end


--- Perform a function on each aggressor of a mobile
-- @param mobile(mobileObj)
-- @param callback(function(id))
-- @return none
function ForeachAggressor(mobile, callback)
    local conflictTable = GetConflictTable(mobile)
    for mobileB,relation in pairs(conflictTable) do
        if (
            (
                ConflictEquals(relation[1], ConflictRelations.Victim) 
                or
                ConflictEquals(relation[1], ConflictRelations.Defender)
            )
            and
            ValidConflictRelationTable(relation)
        ) then
            callback(mobileB)
        end
    end
end


--- Determine if a mobile is an aggressor
-- @param mobile(mobileObj)
-- @param guardIgnore(boolean)(optional) if true, ignore any relation that's tagged guard ignore. (this is so guards ignore when someone is an aggressor against an outcast for example)
-- @return true if mobile is an aggressor
function IsAggressor(mobile, guardIgnore)
    for mobileId,conflict in pairs(GetConflictTable(mobile)) do
        if (
            (
                guardIgnore ~= true
                or
                (
                    guardIgnore == true
                    and
                    conflict[3] ~= true
                )
            )
            and
            ConflictEquals(conflict[1], ConflictRelations.Aggressor)
            and
            ValidConflictRelationTable(conflict)
        ) then return true end
	end
	return false
end

--- Check to see if a mobile(npc) is tagged by a player
-- @param mobile(mobileObj) DOES NOT force this to be an NPC ( but it should be )
-- @param player(playerObj) DOES NOT force this to be an Player ( but it should be )
-- @return true or false
function IsMobTaggedBy(mobile, player)
    local tag = mobile:GetObjVar("Tag")
    if ( player == nil or tag == nil ) then return true end
    return ( tag[player] == true )
end

--- Uses the damage list to determine what Single Player/Collective Group did the most damage and sets the ObjVar Tag with the mobiles that fit the bill
-- @param mobile(mobileObj) the NPC that has died
-- @return a list of nearby killers (to be used for rewards)
function TagMob(mobile) -- Beef nation dayum..
    local damagers = mobile:GetObjVar("Damagers")
    if ( damagers ~= nil ) then
        -- get a list of all groups/solos involved in all the damage
        local groups = {}
        local solos = {}
        for damager,data in pairs(damagers) do
            if ( damager ~= nil and damager:IsValid() ) then
                local gid = GetGroupId(damager)
                if ( gid ~= nil ) then
                    if ( groups[gid] == nil ) then groups[gid] = {} end
                    table.insert(groups[gid], {damager,data.Amount})
                else
                    table.insert(solos, {damager,data.Amount})
                end
            end
        end
        -- calculate the damage for each group
        local groupsDamage = {}
        for gid,data in pairs(groups) do
            for i,d in pairs(groups[gid]) do
                if ( groupsDamage[gid] == nil ) then groupsDamage[gid] = 0 end
                groupsDamage[gid] = groupsDamage[gid] + d[2]
            end
        end
        -- finally determine who's the winner
        local most = {nil,0}
        -- first check solos
        for mobile,data in pairs(solos) do
            if ( data[2] > most[2] and IsPlayerCharacter(data[1]) ) then
                most = data
            end
        end
        local isGroup = false
        -- then check collective groups
        for gid,amount in pairs(groupsDamage) do
            if ( amount > most[2] ) then
                most = {gid,amount}
                -- solos were checked first
                isGroup = true
            end
        end
        -- nothing won, early exit, free for all loot.
        if ( most[1] == nil ) then return end
        -- list of players that can loot freely
        local tag = {}
        -- list of players that get rewards
        local killers = {}
        if ( isGroup ) then
            -- add every mobile in the group that won
            local members = GetGroupVar(most[1], "Members") or {}
            local loot = GetGroupVar(most[1], "Loot") or "FreeForAll"
            -- prepare to cache the leader if loot is master
            local leader = nil
            if ( loot == "Master" ) then
                leader = GetGroupVar(most[1], "Leader")
            end
            -- create some tables to be used in different loot strategies
            local t = {}
            local w = {}
            for i=1,#members do
                local member = members[i]
                -- freeforall loot, tag every group member regardless of other checks
                if ( loot == "FreeForAll" ) then
                    tag[member] = true
                end
                local loc = mobile:GetLoc()
                if ( loot == "Master" ) then
                    -- if the leader is nearby
                    if (
                        leader ~= nil
                        and
                        leader:IsValid()
                        and
                        leader:GetLoc():Distance(loc) <= ServerSettings.Group.RewardRange
                    ) then
                        tag[leader] = true
                    else
                        -- failed to find the leader nearby, fallback to random.
                        loot = "Random"
                    end
                end
                -- only members nearby get rewards/can loot
                if (
                    member:IsValid()
                    and
                    member:GetLoc():Distance(loc) <= ServerSettings.Group.RewardRange
                ) then
                    -- insert the nearby valid mobile to the killers list (for rewards)
                    table.insert(killers, member)
                    -- build some tables depending on the loot strategy
                    if ( loot == "Random" ) then
                        table.insert(t, member)
                    elseif ( loot == "RoundRobin" ) then
                        if ( member:HasObjVar("GroupLastLoot") ) then
                            -- those with last loot
                            table.insert(t, member)
                        else
                            -- those without last loot
                            table.insert(w, member)
                        end
                    end
                end
            end

            -- use built tables dependant on strategy
            if ( loot == "Random" ) then
                local winner = t[math.random(1,#t)]
                tag[winner] = true
            elseif ( loot == "RoundRobin" ) then
                -- if there are any members without last loot, they are guaranteed to be randomly next.
                if ( #w > 0 ) then
                    local winner = w[math.random(1,#w)]
                    winner:SetObjVar("GroupLastLoot", DateTime.UtcNow)
                    tag[winner] = true
                else
                    -- otherwise tag the member with the oldest loot.
                    local lowest = {nil,nil}
                    for i=1,#t do
                        local member = t[i]
                        local lastLoot = member:GetObjVar("GroupLastLoot")
                        if ( lastLoot ~= nil and (lowest[2] == nil or lastLoot < lowest[2]) ) then
                            lowest = {member, lastLoot}
                        end
                    end

                    if ( lowest[1] ) then
                        lowest[1]:SetObjVar("GroupLastLoot", DateTime.UtcNow)
                        tag[lowest[1]] = true
                    end
                end
            end
            -- save the group so we have clearer information when someone breaks the rules
            mobile:SetObjVar("TagGroup", most[1])
        else
            -- add the solo mobile that won
            tag[most[1]] = true
            -- add the solo mobile to the killers list
            table.insert(killers, most[1])
        end
        local one = false
        local backpack = mobile:GetEquippedObject("Backpack")
        for t,y in pairs(tag) do
            one = true
            -- make it glow
            if ( backpack ~= nil ) then
                if not( backpack:HasModule("tagged_mob") ) then
                    backpack:AddModule("tagged_mob")
                end
                backpack:SendMessage("Tag", t)
            end
        end
        -- if there's atleast one to add
        if ( one ) then
            -- set the people that are allowed to loot it
            mobile:SetObjVar("Tag", tag)
        end
        -- if there's atleast one killer
        if ( #killers > 0 ) then
            -- incase someone breaks the rules, we know who to make them aggressors against
            mobile:SetObjVar("TagKillers", killers)
        end
        -- return the list of people that deserve rewards for the kill
        return killers
    end
end

--- Sets every conflict relation to guard ignore, useful for when a player dies, it's like wiping the slate clean for guards.
--- Any subsequent action performed by the aggressor will cause their guard ignore flag to be logically re-evaluated.
-- @param mobile(mobileObj)
-- @return none
function SetAllRelationsGuardIgnore(mobile)
    local conflictTable = GetConflictTable(mobile)
    for mobileB,relation in pairs(conflictTable) do
        conflictTable[mobileB][3] = true
    end
    SetConflictTable(mobile, conflictTable)
end

--- Refresh the client with conflict status on login

function InitializeClientConflicts(mobile)  
    local conflictTable = GetConflictTable(mobile)
    for mobileB,relation in pairs(conflictTable) do
        if ( mobileB:IsValid() ) then -- if the mobile is in same region currently.
            local bToARelation = GetConflictRelation(mobileB, mobile) -- if they have a valid relation with us
            if ( bToARelation ~= nil ) then
                if ((
                        ConflictEquals(relation[1], ConflictRelations.Victim) 
                        or
                        ConflictEquals(relation[1], ConflictRelations.Defender)
                    )
                    and
                    ConflictEquals(bToARelation, ConflictRelations.Aggressor)
                    and
                    ValidConflictRelationTable(relation)
                ) then
                    local timeRemaining = relation[2] - DateTime.UtcNow
                    mobile:SendClientMessage("UpdateMobileConflictStatus",{mobileB,"Aggressed",timeRemaining.TotalSeconds})
                    if ( IsPlayerCharacter(mobileB) ) then
                        mobileB:SendClientMessage("UpdateMobileConflictStatus",{mobile,"Aggressor",timeRemaining.TotalSeconds})
                    end
                elseif( 
                    ConflictEquals(relation[1], ConflictRelations.Aggressor)
                    and
                    (
                        ConflictEquals(bToARelation, ConflictRelations.Victim) 
                        or
                        ConflictEquals(bToARelation, ConflictRelations.Defender)
                    )
                    and
                    ValidConflictRelationTable(relation)
                ) then 
                    local timeRemaining = relation[2] - DateTime.UtcNow
                    mobile:SendClientMessage("UpdateMobileConflictStatus",{mobileB,"Aggressor",timeRemaining.TotalSeconds})
                    if ( IsPlayerCharacter(mobileB) ) then
                        mobileB:SendClientMessage("UpdateMobileConflictStatus",{mobile,"Aggressed",timeRemaining.TotalSeconds})
                    end
                end
            end
        end
    end
end