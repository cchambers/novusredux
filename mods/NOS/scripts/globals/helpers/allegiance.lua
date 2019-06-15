require 'stackable_helpers'
Allegiance = {}

--[[ Major Functions ]]

--- Puts a player into a allegiance, fails if player already in allegiance
-- @param playerObj
-- @param allegianceId
-- @return the GlobalVarUpdateResult event id or false if already in allegiance/bad params
Allegiance.AddPlayer = function(playerObj, allegianceId)
    if ( playerObj == nil ) then
        LuaDebugCallStack("[Allegiance.AddPlayer] Nil playerObj provided.")
        return false
    end
    if ( Allegiance.GetDataById(allegianceId) == nil ) then
        LuaDebugCallStack("[Allegiance.AddPlayer] Invalid Allegiance Id provided '"..tostring(allegianceId).."'")
        return false
    end

    -- already in a allegiance, stop here.
    if ( Allegiance.GetId(playerObj) ~= nil ) then return false end
    
    -- save the allegiance members list
    Allegiance.SetVar("Members."..allegianceId, function(record)
        -- set the value as the time joined
        record[playerObj] = DateTime.UtcNow
        return true
    end,
    function(success)
        if ( success ) then
            -- set the allegiance id on the player
            Allegiance.SetId(playerObj, allegianceId)
        end
    end)
end

--- Determines whether a player meets basic criteria to join an Allegiance
-- @param playerObj
-- @return true or false
Allegiance.ValidateJoin = function(playerObj)
    if ( GetTotalBaseStats(playerObj) ~= ServerSettings.Stats.TotalPlayerStatsCap ) then return false end
    return true
end

--- Remove a player from a allegiance if they are in one
-- @param playerObj
Allegiance.RemovePlayer = function(playerObj)
    if ( playerObj == nil ) then
        LuaDebugCallStack("[Allegiance.RemovePlayer] Nil playerObj provided.")
        return false
    end
    local allegianceId = Allegiance.GetId(playerObj)
    if ( allegianceId == nil ) then return false end

    Allegiance.SetVar("Members."..allegianceId, function(record)
        -- remove the player from the allegiance
        record[playerObj] = nil
        return true
    end,
    function(success)
        if ( success ) then
            -- remove the allegiance from the player
            Allegiance.SetId(playerObj, nil)
        end
    end)
end

--- Set/Delete a player's allegiance Id, also tons of other stuff
-- @param playerObj
-- @param value New allegiance id
Allegiance.SetId = function(playerObj, value)
    if ( value ) then
        local allegianceData = Allegiance.GetDataById(value)
        if ( allegianceData == nil ) then return end
        playerObj:SetObjVar("Allegiance", value)
        -- set the allegiance icon
        playerObj:SetSharedObjectProperty("Faction", allegianceData.Icon)
        playerObj:SetSharedObjectProperty("FriendlyFactions", allegianceData.Icon)
        -- set allegiance player vars to defaults, unless they have favor already
        local favor = ServerSettings.Allegiance.SignupFavor or 1
        favor = favor + Allegiance.GetFavor(playerObj)
        Allegiance.SetPlayerVarsDefault(playerObj, favor)
        Allegiance.UpdatePlayerVars(playerObj)
        -- update pets
        ForeachActivePet(playerObj, function(pet)
            UpdatePetAllegiance(pet, value, allegianceData)
        end, true)
        playerObj:SystemMessage("You are now loyal to "..allegianceData.Name..".", "event")
    else
        -- create a unique event identifier
        local eventId = uuid()
        -- setup a listener for the global var update result
        RegisterSingleEventHandler(EventType.GlobalVarUpdateResult, eventId, function(success, name, record)
            if ( success ) then
                playerObj:SetSharedObjectProperty("Faction", "None")
                playerObj:SetSharedObjectProperty("FriendlyFactions", "")
                playerObj:SystemMessage("You have denounced your allegiance.", "event")

                Allegiance.RemovePlayerFromFavorTable(playerObj)
                Allegiance.ClearPlayerVars(playerObj)
                if playerObj:HasObjVar("AllegianceResign") then playerObj:DelObjVar("AllegianceResign") end
                if playerObj:HasObjVar("Allegiance") then playerObj:DelObjVar("Allegiance") end
                -- update pets
                ForeachActivePet(playerObj, UpdatePetAllegiance, true)
            end
        end)

        local allegianceId = Allegiance.GetId(playerObj)
        if ( allegianceId ~= nil ) then
            local amount = Allegiance.GetFavor(playerObj)
            local writeFunction = function(record)
                -- default allegiance total favor to 0
                if ( record[allegianceId] == nil ) then record[allegianceId] = 0 end

                -- remove their favor from allegiance total favor
                record[allegianceId] = record[allegianceId] - amount

                return true
            end
            -- write to the global variable
            GlobalVarWrite("AllegianceFavor", eventId, writeFunction)
        end
    end
    playerObj:SendMessage("UpdateCharacterWindow")
end

--- Resignation for a allegiance takes time, this starts that 'countdown'
-- @param playerObj
Allegiance.BeginResignation = function(playerObj)
    local allegianceId = Allegiance.GetId(playerObj)

    if ( allegianceId == nil ) then return end

    playerObj:SetObjVar("AllegianceResign", DateTime.UtcNow:Add(ServerSettings.Allegiance.ResignTime))
end

--- Take a player that just died and reward the player with the most damage that's within range.
-- @param player
Allegiance.RewardKill = function(player)
    local damagers = player:GetObjVar("Damagers")
    if ( damagers ~= nil ) then
        -- get a list of all groups/solos involved in all the damage
        local most = 0
        local winner = nil
        local loc = player:GetLoc()
        for damager,data in pairs(damagers) do
            if ( 
                damager ~= nil
                and
                damager:IsValid()
                and
                Allegiance.InOpposing(damager, player)
                and
                damager:GetLoc():Distance(loc) < 60
            ) then
                if ( data.Amount > most ) then
                    most = data.Amount
                    winner = damager
                end
            end
        end
        -- transfer points from the player to the winner
        if ( winner ) then
            Allegiance.TransferFavor(player, winner)
        end
    end
end

--- Transfer favor from victim to aggressor, does not enforce they are in opposing allegiances tho they must both be in opposing allegiances.
-- @param victim
-- @param aggressor
Allegiance.TransferFavor = function(victim, aggressor)
    -- cannot gain points while resigning
    --if ( victim:HasObjVar("AllegianceResign") ) then return end
    local aAllegiance = Allegiance.GetId(victim)
    local bAllegiance = Allegiance.GetId(aggressor)
    -- if either are not in an allegiance stop here
    if ( aAllegiance == nil or bAllegiance == nil ) then return end
    -- get the favor of A and B
    local favorVictim = Allegiance.GetFavor(victim)
    local favorAggressor = Allegiance.GetFavor(aggressor)
    if ( favorVictim == nil or favorAggressor == nil ) then return end

    -- calculate the amount of favor to transfer
    local favorMultiplier = Allegiance.GetFavorDRMultiplier(victim, aggressor)
    local favorTransfer = favorVictim * favorMultiplier * ServerSettings.Allegiance.FavorTransferOnKill
    local favorVictim = favorVictim - favorTransfer
    local favorAggressor = favorAggressor + favorTransfer

    --update victim
    local controllerIDVictim = Allegiance.GetRosterControllerID(victim)
    if ( controllerIDVictim == nil ) then return nil end
    Allegiance.SetFavor(victim, favorVictim)
    controllerIDVictim:SendMessageGlobal("AdjustFavorTable", victim, favorVictim)

    --update aggressor
    local controllerIDVictim = Allegiance.GetRosterControllerID(aggressor)
    if ( controllerIDVictim == nil ) then return nil end
    Allegiance.SetFavor(aggressor, favorAggressor)
    Allegiance.UpdateFavorDR(victim, aggressor)
    controllerIDVictim:SendMessageGlobal("AdjustFavorTable", aggressor, favorAggressor)
end

--- Checks if current season should end, updates global with new season, triggers reset of favor tables, recalculates standings
-- @param none
Allegiance.CheckForAndStartNewSeason = function()
    local season = GlobalVarRead("Allegiance.CurrentSeason")
    if ( season == nil or season.StartDate == nil or DateTime.UtcNow > season.EndDate ) then
        Allegiance.DoNewSeason()
    end
end

Allegiance.DoNewSeason = function(durationDays)
    Allegiance.SetVar("CurrentSeason", function(record)
        local durationDays = durationDays or ServerSettings.Allegiance.SeasonDurationDays or 90
        local durationDays = TimeSpan.FromDays(durationDays)
        local now = DateTime.UtcNow
        local monthsTable = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
        local seasonTable = {
            Name = monthsTable[now.Month].." "..now.Year,
            StartDate = now,
            EndDate = now:Add(durationDays),
        }
        for k, v in pairs(record) do
            record[k] = nil
        end
        for k, v in pairs(seasonTable) do
            record[k] = v
        end

        return true
    end,
    function(success)
        if ( success ) then
            Allegiance.UpdateValidCharactersVars()
            Allegiance.WipeAllFavorTables()
            DebugMessage("New Allegiance season successfully started")
        end
    end)
end

Allegiance.SetDaysUntilEnd = function(durationDays)
    Allegiance.SetVar("CurrentSeason", function(record)
        local durationDays = durationDays or ServerSettings.Allegiance.SeasonDurationDays or 90
        local durationDays = TimeSpan.FromDays(durationDays)
        local now = DateTime.UtcNow
        local seasonTable = {
            EndDate = now:Add(durationDays),
        }
        for k, v in pairs(seasonTable) do
            record[k] = v
        end
        return true
    end,
    function(success)
        if ( success ) then
            DebugMessage("New Allegiance end date set.")
        end
    end)
end

--- Sends a message to the controller that matches the allegiance ID to delete it's favor table
-- @param allegianceId
Allegiance.WipeFavorTable = function(allegianceId)
    local rosterController = GlobalVarRead("Allegiance.RosterController."..allegianceId)
    if ( rosterController == nil or rosterController["ID"] == nil ) then return nil end
    rosterController["ID"]:SendMessageGlobal("WipeFavorTable")
end
Allegiance.WipeAllFavorTables = function()
    for i = 1, 3 do
        Allegiance.WipeFavorTable(i)
    end
end

--- Sends a message to the controller that matches the allegiance ID to calculate ranks for that Allegiance
-- @param allegianceId
Allegiance.CalculateRanks = function(allegianceId)
    local rosterController = GlobalVarRead("Allegiance.RosterController."..allegianceId)
    if ( rosterController == nil or rosterController["ID"] == nil ) then return nil end
    rosterController["ID"]:SendMessageGlobal("CalculateAndUpdateRanks")
end
Allegiance.CalculateAllRanks = function()
    for i = 1, 3 do
        Allegiance.CalculateRanks(i)
    end
end

Allegiance.GetHighestRankedPlayer = function(allegianceId)
    local leader = "None"
    local standings = GlobalVarRead("Allegiance.Standings."..allegianceId)
    if ( standings == nil ) then return leader end
    for k, v in pairs(standings) do
        if ( type(k) == "userdata" and v[1] == 1 ) then
            leader = k:GetCharacterName()
        end
    end
    return leader
end

Allegiance.GetOnlinePlayers = function()
    local onlineAllegianceMembers = {}
    for i = 1, 3 do
        local allegianceMembers = GlobalVarRead("Allegiance.Members."..i)
        if ( allegianceMembers ~= nil ) then
            for memberObj, v in pairs(allegianceMembers) do
                if ( GlobalVarReadKey("User.Online", memberObj) ) then
                    table.insert(onlineAllegianceMembers, memberObj)
                end
            end
        end
    end
    return onlineAllegianceMembers
end

--- Gets and updates a player's allegiance ObjVars
-- @param playerObj
-- @return rank name, rank number, if applicable
Allegiance.UpdateValidCharactersVars = function()
    -- tell all cluster controllers accross all regions to reset all players.
    for regionAddress, v in pairs(GetClusterRegions()) do
        if ( regionAddress == ServerSettings.RegionAddress ) then
            --cluster control should always be master, this is called by master controller pulse
            local clusterController = GlobalVarReadKey("ClusterControl", "Master")
            if ( clusterController ~= nil ) then
                clusterController:SendMessage("Allegiance.UpdateValidCharactersVars")
            end
        elseif ( IsClusterRegionOnline(regionAddress) ) then
            MessageRemoteClusterController(regionAddress, "Allegiance.UpdateValidCharactersVars")
        end
    end
end

Allegiance.Chat = function(from, allegianceId , line)
local name = ""
	if ( from ~= nil) then
		local actualName = from:GetObjVar("actualName")

		if (actualName == nil) then
			name = from:GetName()
		else
			name = actualName
		end
	end

    local allegianceMembers = GlobalVarRead("Allegiance.Members."..allegianceId)
    if ( allegianceMembers ~= nil ) then
        from:SetObjVar("AllegianceChatCooldown", DateTime.UtcNow:Add(ServerSettings.Allegiance.ChatCooldown))
        for memberObj, v in pairs(allegianceMembers) do
            if ( GlobalVarReadKey("User.Online", memberObj) ) then
                memberObj:SendMessageGlobal("Allegiance.Chat", name, Allegiance.GetRankNumber(from), line)
            end
        end
    end
end

Allegiance.EventMessagePlayers = function(message)
    if ( message == nil ) then return false end
    local onlineAllegiancePlayers = Allegiance.GetOnlinePlayers()
    for i = 1, #onlineAllegiancePlayers do
        onlineAllegiancePlayers[i]:SendMessageGlobal("AllegianceEventMessage", message)
    end
end

Allegiance.RewardAllegianceCurrency = function(playerObj, currencyAmount, silent)
    if ( playerObj == nil or not playerObj:IsValid() ) then return false end
    if ( currencyAmount == nil or currencyAmount < 1 ) then return false end
    local backpack = playerObj:GetEquippedObject("Backpack")
    if ( backpack == nil ) then return false end
    Create.Stack.InBackpack("allegiance_salt", playerObj, currencyAmount, nil, function(obj)
        if ( obj ) then
                if not( silent ) then
                    playerObj:NpcSpeech("+ "..currencyAmount.." salt", "combat")
                end
        else
                DebugMessage("Salt creation to backpack failed for playerId: "..playerObj.Id)
        end
    end, false, false, true)
end

--[[ Updaters ]]

--- Searches for the roster controller for given ID, and creates it if necessary, used by allegiance recruiter/leader
-- @param allegianceLeader (mobileObj) Allegiance leader
Allegiance.CheckAndCreateRosterController = function(allegianceLeader)
    local allegianceId = Allegiance.GetId(allegianceLeader)
    if ( allegianceId ~= nil ) then
        --search for controller, create if necessary
        local templateNames = {"pyros_allegiance_roster_controller", "tethys_allegiance_roster_controller", "ebris_allegiance_roster_controller"}
        local template = templateNames[allegianceId]
        local searchResult = FindObjects(SearchTemplate(template), allegianceLeader)
        local next = next
        --check if table is empty
        if not( next(searchResult) ) then
            --create controller
            Create.AtLoc(template, allegianceLeader:GetLoc(), function(controller)
                controller:SetObjVar("NoReset", true)
            end)
        end
    end
end

--- Gets and updates a player's allegiance ObjVars
-- @param playerObj
-- @return rank name, rank number, if applicable
Allegiance.UpdatePlayerVars = function(playerObj)
    if ( playerObj == nil or type(playerObj) ~= "userdata" or not playerObj:IsValid() ) then return false end
    --don't update anything if there is no season
    local currentGlobalSeason = GlobalVarRead("Allegiance.CurrentSeason")
    if ( currentGlobalSeason == nil or currentGlobalSeason.StartDate == nil ) then return false end
    --reset allegiance player vars if the season is unknown or doesn't match, even for non-allegiance
    local playerVarSeason = playerObj:GetObjVar("AllegianceSeasonStart")
    if ( playerVarSeason == nil or playerVarSeason ~= currentGlobalSeason.StartDate ) then
        if ( playerObj:HasObjVar("Favor") ) then playerObj:DelObjVar("Favor") end
		if ( playerObj:HasObjVar("FavorDR") ) then playerObj:DelObjVar("FavorDR") end
		Allegiance.ClearPlayerVars(playerObj)
		Allegiance.SetPlayerVarsDefault(playerObj)
		if ( Allegiance.GetId(playerObj) ~= nil ) then
            CallFunctionDelayed(TimeSpan.FromSeconds(5),function()playerObj:SystemMessage("A new Allegiance season has started! Rankings have been reset!","event")end)
		end
    end

    local allegianceId = Allegiance.GetId(playerObj)
    if ( allegianceId == nil ) then return false end

    --get percentile and standing from globals
    local playerStats = GlobalVarReadKey("Allegiance.Standings."..allegianceId, playerObj)
    local playerVarSeason = playerObj:GetObjVar("AllegianceSeasonStart")
    local standingsSeason = GlobalVarReadKey("Allegiance.Standings."..allegianceId, "SeasonStartDate")
    if ( playerStats ~= nil and 
    playerStats[1] ~= nil and 
    playerStats[2] ~= nil and 
    playerVarSeason ~= nil and 
    standingsSeason ~= nil and
    playerVarSeason == standingsSeason ) then
        local percentile = playerStats[1]
        local standing = playerStats[2]
        playerObj:SetObjVar("AllegiancePercentile", percentile)
        playerObj:SetObjVar("AllegianceStanding", standing)
        
        --set rank name and number
        local rankTable = ServerSettings.Allegiance.Allegiances[allegianceId].Ranks
        if ( rankTable == nil ) then
            DebugMessage("No Allegiance rank table found.")
            return false
        end
        local oldRankName = playerObj:GetObjVar("AllegianceRankName")
        for k, v in pairs(rankTable) do
            if ( v.Standing and standing <= v.Standing ) then
                playerObj:SetObjVar("AllegianceRankName", v.Name)
                playerObj:SetObjVar("AllegianceRankNumber", v.Number)
                local newRankName = playerObj:GetObjVar("AllegianceRankName")
                if ( newRankName and newRankName ~= oldRankName ) then
                    CallFunctionDelayed(TimeSpan.FromSeconds(5),function()playerObj:SystemMessage("Your Allegiance rank is now "..v.Name, "event")end)
                end
                return
            elseif ( v.Percentile and percentile >= v.Percentile ) then
                playerObj:SetObjVar("AllegianceRankName", v.Name)
                playerObj:SetObjVar("AllegianceRankNumber", v.Number)
                local newRankName = playerObj:GetObjVar("AllegianceRankName")
                if ( newRankName and newRankName ~= oldRankName ) then
                    CallFunctionDelayed(TimeSpan.FromSeconds(5),function()playerObj:SystemMessage("Your Allegiance rank is now "..v.Name, "event")end)
                end
                return
            end
        end
    else
        playerObj:SetObjVar("AllegiancePercentile", 0)
        playerObj:SetObjVar("AllegianceStanding", 0)
        playerObj:SetObjVar("AllegianceRankName", "Inactive")
        playerObj:SetObjVar("AllegianceRankNumber", 0)
    end
    
    StartMobileEffect(playerObj, "AllegianceTopRank")
end

--- Set a player's allegiance ObjVars to default values for a new enlistee
-- @param playerObj
-- @param (optional) favor
Allegiance.SetPlayerVarsDefault = function(playerObj, favor)
    if not( playerObj:HasObjVar("Allegiance") ) then return false end
    local newFavor = favor or ServerSettings.Allegiance.SignupFavor or 1
    Allegiance.SetFavor(playerObj, newFavor)
    Allegiance.SetFavorFromEvents(playerObj, ServerSettings.Allegiance.FavorFromEvents)

    local currentGlobalSeason = GlobalVarRead("Allegiance.CurrentSeason")
    if ( currentGlobalSeason ~= nil and currentGlobalSeason.StartDate ~= nil ) then
        playerObj:SetObjVar("AllegianceSeasonStart", currentGlobalSeason.StartDate)
    end
end

--- Removes all allegiance ObjVars on the player EXCEPT for Favor, AllegianceResign, Allegiance
-- @param playerObj
Allegiance.ClearPlayerVars = function(playerObj)
    if ( playerObj:HasObjVar("FavorFromEvents") ) then playerObj:DelObjVar("FavorFromEvents") end
    if ( playerObj:HasObjVar("AllegianceStanding") ) then playerObj:DelObjVar("AllegianceStanding") end
    if ( playerObj:HasObjVar("AllegiancePercentile") ) then playerObj:DelObjVar("AllegiancePercentile") end
    if ( playerObj:HasObjVar("AllegianceRankName") ) then playerObj:DelObjVar("AllegianceRankName") end
    if ( playerObj:HasObjVar("AllegianceRankNumber") ) then playerObj:DelObjVar("AllegianceRankNumber") end
    if ( playerObj:HasObjVar("AllegianceSeasonStart") ) then playerObj:DelObjVar("AllegianceSeasonStart") end
end

--[[ Favor ]]

Allegiance.GetFavor = function(player)
    return player:GetObjVar("Favor") or 0
end

Allegiance.GetAllegianceName = function(playerObj)
    local allegianceId = Allegiance.GetId(playerObj)
    if ( allegianceId == nil ) then return nil end
    local allegianceData = Allegiance.GetDataById(allegianceId)
    if ( allegianceData ) then
        return allegianceData.Name
    end
    return nil
end

Allegiance.SetFavor = function(player, favor)
    player:SetObjVar("Favor", math.round(favor, 4))
end

Allegiance.SetFavorFromEvents = function(player, favor)
    player:SetObjVar("FavorFromEvents", favor)
end

--- Remove a player's entry from their respective roster controller
-- @param playerObj
Allegiance.RemovePlayerFromFavorTable = function(playerObj)
    local controllerID = Allegiance.GetRosterControllerID(playerObj)
    if ( controllerID == nil ) then return nil end
    controllerID:SendMessageGlobal("AdjustFavorTable", playerObj, 0, true)
end

--- Gets a player's corresponding roster controller ID
-- @param playerObj
Allegiance.GetRosterControllerID = function(playerObj)
    local allegianceId = Allegiance.GetId(playerObj)
    if ( allegianceId == nil ) then return nil end
    local rosterController = GlobalVarRead("Allegiance.RosterController."..allegianceId)
    if ( rosterController == nil or rosterController.ID == nil ) then return nil end

    return rosterController.ID
end

--[[ Diminishing Returns ]]

--- Adds a kill count to the aggressor(killer) FavorDR ObjVar, creates expiration time if it's the first kill in the entry
-- @param victim (playerObj)
-- @param aggressor (playerObj)
Allegiance.UpdateFavorDR = function(victim, aggressor)
    local FavorDR = aggressor:GetObjVar("FavorDR") or {}
    if ( FavorDR[victim] == nil ) then
        --set kills to 1, set entry expire date
        FavorDR[victim] = {1, DateTime.UtcNow:Add(ServerSettings.Allegiance.DRResetTime)}
    else
        FavorDR[victim][1] = FavorDR[victim][1] + 1
    end
    aggressor:SetObjVar("FavorDR", FavorDR)
end

--- Returns the diminishing returns modifier for a kill on a victim by an aggressor, based on FavorDR table
-- @param victim (playerObj)
-- @param aggressor (playerObj)
-- @return number from 0 to 1, to be used as multiplier for Favor transfer
Allegiance.GetFavorDRMultiplier = function(victim, aggressor)
    Allegiance.PruneFavorDR(aggressor)
    local KillsToZero = ServerSettings.Allegiance.DRKillsToZero
    local FavorDR = aggressor:GetObjVar("FavorDR") or {}
    local KillsOnTarget = 0
    if ( FavorDR[victim] ~= nil and FavorDR[victim][1] ~= nil ) then
        KillsOnTarget = FavorDR[victim][1]
    end
    if ( KillsOnTarget >= KillsToZero ) then 
        return 0
    else
        return ( 1 - ( KillsOnTarget / KillsToZero ) )
    end
end

--- Removes expired diminishing returns entries from a player's FavorDR ObjVar table
-- @param playerObj
Allegiance.PruneFavorDR = function(playerObj)
    local FavorDR = playerObj:GetObjVar("FavorDR") or {}
    for k, v in pairs(FavorDR) do
        if ( FavorDR[k] ~= nil ) then
            if ( DateTime.UtcNow > v[2] ) then
                FavorDR[k] = nil
            end
        end
    end
    playerObj:SetObjVar("FavorDR", FavorDR)
end

--[[ Gets, Basic Convenience Functions ]]

--- Set a Global allegiance variable by name
-- @param id
-- @param name The variable name
-- @param writeFunction
-- @param cb
Allegiance.SetVar = function(name, writeFunction, cb)
    if ( name == nil or writeFunction == nil ) then return false end
    SetGlobalVar(string.format("Allegiance.%s", name), writeFunction, cb)
end

--- Get a Global allegiance variable by name
-- @param id
-- @param name The variable name
-- @return value of the global variable or nil
Allegiance.GetVar = function(id, name)
    if ( id == nil or name == nil ) then return nil end
    return GlobalVarRead("Allegiance."..name.."."..tostring(id))
end

--- Determine if two players are in opposing allegiances to eachother (both in allegiances but are not the same allegiance)
-- @param victim
-- @param aggressor
-- @return true if both players are in opposing allegiances
Allegiance.InOpposing = function(victim, aggressor)
    Verbose("Allegiance", "Allegiance.InOpposing", victim, aggressor)
    local allegianceA = Allegiance.GetId(victim)
    if ( allegianceA ~= nil ) then
        local allegianceB = Allegiance.GetId(aggressor)
        if ( allegianceB ~= nil ) then
            return allegianceA ~= allegianceB
        end
    end
    return false
end

--- determines whether a mobile meets criteria to attack another mobile, in context of Allegiances
-- @param victim
-- @param aggressor
-- @return true or false
Allegiance.CanAttackAllegianceAttackable = function(aggressor, victim)
    --if victim does not have AllegianceAttackable, victim is attackable
    local allegianceAttackable = victim:GetObjVar("AllegianceAttackable")
    if ( allegianceAttackable == nil or allegianceAttackable ~= true ) then return true
    --if aggressor is not in an Allegiance and assuming victim has AllegianceAttackable, return false
    elseif ( aggressor:GetObjVar("Allegiance") == nil ) then return false
    else
        --otherwise return true
        return true
    end
end

--- Get a player's allegiance id
-- @param playerObj
-- @return the players allegiance id or nil
Allegiance.GetId = function(playerObj)
    return playerObj:GetObjVar("Allegiance")
end

Allegiance.CheckItemRequirements = function(playerObj, itemObj)
    if ( playerObj == nil or itemObj == nil ) then return false end
    local allegianceRequired = itemObj:GetObjVar("AllegianceRequired")
    if ( allegianceRequired ) then
        local allegianceId = playerObj:GetObjVar("Allegiance")
        if ( allegianceId == nil or allegianceId ~= allegianceRequired ) then
            playerObj:SystemMessage("Must be a member of that Allegiance to use.", "info")
            return false
        end
    end
    local rankRequired = itemObj:GetObjVar("AllegianceRankRequired")
    if ( rankRequired ) then
        local rank = Allegiance.GetRankNumber(playerObj)
        if ( rank == nil or rank < rankRequired ) then
            playerObj:SystemMessage("Requires an Allegiance rank of "..rankRequired..".", "info")
            return false
        end
    end
    return true
end

--- The the details about a allegiance by the allegiance's id
-- @param allegianceId
-- @return The allegiance data for the allegiance id or nil
Allegiance.GetDataById = function(allegianceId)
    for i=1,#ServerSettings.Allegiance.Allegiances do
        if ( ServerSettings.Allegiance.Allegiances[i].Id == allegianceId ) then
            return ServerSettings.Allegiance.Allegiances[i]
        end
    end
    return nil
end

Allegiance.GetPercentile = function(playerObj)
    return playerObj:GetObjVar("AllegiancePercentile") or 0
end

Allegiance.GetStanding = function(playerObj)
    return playerObj:GetObjVar("AllegianceStanding") or 0
end

Allegiance.GetRankName = function(playerObj)
    return playerObj:GetObjVar("AllegianceRankName") or "Inactive"
end

Allegiance.GetRankNumber = function(playerObj)
    return playerObj:GetObjVar("AllegianceRankNumber") or 0
end

--[[ Titles ]]

--- Update a player's title for their allegiance, does not enfore or check much and is pretty raw
-- @param player
-- @param allegiance
Allegiance.UpdateTitlele = function(player)
    local allegiance = Allegiance.GetId(player)
    -- not in an allegiance, stop here
    if ( allegiance == nil ) then return end

    -- get the allegiance data
    local allegianceData = Allegiance.GetDataById(allegiance)
    if ( allegianceData == nil ) then
        LuaDebugCallStack("[Allegiance.UpdateTitlele] Nil allegianceData, is allegiance '"..allegiance.."' valid?")
        return
    end

    -- decide the size of their slice of the pie
    local rankNumber = Allegiance.GetRankNumber(player)

    --Check if player should earn achievement for current allegiance
    CheckAchievementStatus(player, "PvP", allegianceData.Icon.."Allegiance", rankNumber, {TitleCheck = "Allegiance"}, "Allegiance")

    --Check if a player who lost rank can use allegiance title
    CheckTitleRequirement(victim, allegianceData.Icon.."Allegiance")
end