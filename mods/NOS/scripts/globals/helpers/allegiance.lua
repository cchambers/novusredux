--[[ Major Functions ]]

--- Puts a player into a allegiance, fails if player already in allegiance
-- @param playerObj
-- @param allegianceId
-- @return the GlobalVarUpdateResult event id or false if already in allegiance/bad params
function AllegianceAddPlayer(playerObj, allegianceId)
    if ( playerObj == nil ) then
        LuaDebugCallStack("[AllegianceAddPlayer] Nil playerObj provided.")
        return false
    end
    if ( GetAllegianceDataById(allegianceId) == nil ) then
        LuaDebugCallStack("[AllegianceAddPlayer] Invalid Allegiance Id provided '"..tostring(allegianceId).."'")
        return false
    end

    -- already in a allegiance, stop here.
    if ( GetAllegianceId(playerObj) ~= nil ) then return false end
    
    -- save the allegiance members list
    SetAllegianceVar("Members."..allegianceId, function(record)
        -- set the value as the time joined
        record[playerObj] = DateTime.UtcNow
        return true
    end,
    function(success)
        if ( success ) then
            -- set the allegiance id on the player
            SetAllegianceId(playerObj, allegianceId)
        end
    end)
end

--- Determines whether a player meets basic criteria to join an Allegiance
-- @param playerObj
-- @return true or false
function AllegianceValidateJoin(playerObj)
    if ( GetTotalBaseStats(playerObj) ~= ServerSettings.Stats.TotalPlayerStatsCap ) then return false end
    return true
end

--- Remove a player from a allegiance if they are in one
-- @param playerObj
function AllegianceRemovePlayer(playerObj)
    if ( playerObj == nil ) then
        LuaDebugCallStack("[AllegianceRemovePlayer] Nil playerObj provided.")
        return false
    end
    local allegianceId = GetAllegianceId(playerObj)
    if ( allegianceId == nil ) then return false end

    SetAllegianceVar("Members."..allegianceId, function(record)
        -- remove the player from the allegiance
        record[playerObj] = nil
        return true
    end,
    function(success)
        if ( success ) then
            -- remove the allegiance from the player
            SetAllegianceId(playerObj, nil)
        end
    end)
end

--- Set/Delete a player's allegiance Id, also tons of other stuff
-- @param playerObj
-- @param value New allegiance id
function SetAllegianceId(playerObj, value)
    if ( value ) then
        local allegianceData = GetAllegianceDataById(value)
        if ( allegianceData == nil ) then return end
        playerObj:SetObjVar("Allegiance", value)
        -- set the allegiance icon
        playerObj:SetSharedObjectProperty("Faction", allegianceData.Icon)
        playerObj:SetSharedObjectProperty("FriendlyFactions", allegianceData.Icon)
        -- set allegiance player vars to defaults, unless they have favor already
        local favor = ServerSettings.Allegiance.SignupFavor or 1
        favor = favor + GetFavor(playerObj)
        SetAllegiancePlayerVarsDefault(playerObj, favor)
        UpdateAllegiancePlayerVars(playerObj)
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

                RemovePlayerFromFavorTable(playerObj)
                ClearAllegiancePlayerVars(playerObj)
                if playerObj:HasObjVar("AllegianceResign") then playerObj:DelObjVar("AllegianceResign") end
                if playerObj:HasObjVar("Allegiance") then playerObj:DelObjVar("Allegiance") end
                -- update pets
                ForeachActivePet(playerObj, UpdatePetAllegiance, true)
            end
        end)

        local allegianceId = GetAllegianceId(playerObj)
        if ( allegianceId ~= nil ) then
            local amount = GetFavor(playerObj)
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
function AllegianceBeginResignation(playerObj)
    local allegianceId = GetAllegianceId(playerObj)

    if ( allegianceId == nil ) then return end

    playerObj:SetObjVar("AllegianceResign", DateTime.UtcNow:Add(ServerSettings.Allegiance.ResignTime))
end

--- Take a player that just died and reward the player with the most damage that's within range.
-- @param player
function AllegianceRewardKill(player)
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
                InOpposingAllegiance(damager, player)
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
            TransferFavor(player, winner)
        end
    end
end

--- Transfer favor from victim to aggressor, does not enforce they are in opposing allegiances tho they must both be in opposing allegiances.
-- @param victim
-- @param aggressor
function TransferFavor(victim, aggressor)
    -- cannot gain points while resigning
    --if ( victim:HasObjVar("AllegianceResign") ) then return end
    local aAllegiance = GetAllegianceId(victim)
    local bAllegiance = GetAllegianceId(aggressor)
    -- if either are not in an allegiance stop here
    if ( aAllegiance == nil or bAllegiance == nil ) then return end
    -- get the favor of A and B
    local favorVictim = GetFavor(victim)
    local favorAggressor = GetFavor(aggressor)
    if ( favorVictim == nil or favorAggressor == nil ) then return end

    -- calculate the amount of favor to transfer
    local favorMultiplier = GetFavorDRMultiplier(victim, aggressor)
    local favorTransfer = favorVictim * favorMultiplier * ServerSettings.Allegiance.FavorTransferOnKill
    local favorVictim = favorVictim - favorTransfer
    local favorAggressor = favorAggressor + favorTransfer

    --update victim
    local controllerIDVictim = GetAllegianceRosterControllerID(victim)
    if ( controllerIDVictim == nil ) then return nil end
    SetFavor(victim, favorVictim)
    controllerIDVictim:SendMessageGlobal("AdjustFavorTable", victim, favorVictim)

    --update aggressor
    local controllerIDVictim = GetAllegianceRosterControllerID(aggressor)
    if ( controllerIDVictim == nil ) then return nil end
    SetFavor(aggressor, favorAggressor)
    UpdateFavorDR(victim, aggressor)
    controllerIDVictim:SendMessageGlobal("AdjustFavorTable", aggressor, favorAggressor)
end

--- Checks if current season should end, updates global with new season, triggers reset of favor tables, recalculates standings
-- @param none
function CheckForAndStartNewSeason()
    local season = GlobalVarRead("Allegiance.CurrentSeason")
    if ( season == nil or season.StartDate == nil or DateTime.UtcNow > season.EndDate ) then
        SetAllegianceVar("CurrentSeason", function(record)
            local now = DateTime.UtcNow
            local monthsTable = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
            local seasonTable = {
                Name = monthsTable[now.Month].." "..now.Year,
                StartDate = now,
                EndDate = now:Add(ServerSettings.Allegiance.SeasonDuration),
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
                UpdateValidCharactersAllegianceVars()
                WipeAllegianceRosterTable(1)
                WipeAllegianceRosterTable(2)
                WipeAllegianceRosterTable(3)
                DebugMessage("[Allegiance] New Allegiance season successfully started")
            end
        end)

    end
end

--- Sends a message to the controller that matches the allegiance ID to delete it's favor table
-- @param allegianceId
function WipeAllegianceRosterTable(allegianceId)
    local rosterController = GlobalVarRead("Allegiance.RosterController."..allegianceId)
    if ( rosterController["ID"] == nil ) then return nil end
    rosterController["ID"]:SendMessageGlobal("WipeRosterTable")
end

--- Gets and updates a player's allegiance ObjVars
-- @param playerObj
-- @return rank name, rank number, if applicable
function UpdateValidCharactersAllegianceVars()
    -- tell all cluster controllers accross all regions to reset all players.
    for regionAddress, v in pairs(GetClusterRegions()) do
        if ( regionAddress == ServerSettings.RegionAddress ) then
            --cluster control should always be master, this is called by master controller pulse
            local clusterController = GlobalVarReadKey("ClusterControl", "Master")
            if ( clusterController ~= nil and clusterController ~= {} ) then
                clusterController:SendMessage("UpdateValidCharactersAllegianceVars")
            end
        elseif ( IsClusterRegionOnline(regionAddress) ) then
            MessageRemoteClusterController(regionAddress, "UpdateValidCharactersAllegianceVars")
        end
    end
end

--[[ Updater Shiz ]]

--- Searches for the roster controller for given ID, and creates it if necessary, used by allegiance recruiter/leader
-- @param allegianceLeader (mobileObj) Allegiance leader
function CheckAndCreateRosterController(allegianceLeader)
    local allegianceId = GetAllegianceId(allegianceLeader)
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
function UpdateAllegiancePlayerVars(playerObj)
    if ( playerObj == nil or not playerObj:IsValid() ) then return false end
    --don't update anything if there is no season
    local currentGlobalSeason = GlobalVarRead("Allegiance.CurrentSeason")
    if ( currentGlobalSeason == nil or currentGlobalSeason.StartDate == nil ) then return false end
    --reset allegiance player vars if the season is unknown or doesn't match, even for non-allegiance
    local playerVarSeason = playerObj:GetObjVar("AllegianceSeasonStart")
    if ( playerVarSeason == nil or playerVarSeason ~= currentGlobalSeason.StartDate ) then
        if ( playerObj:HasObjVar("Favor") ) then playerObj:DelObjVar("Favor") end
		if ( playerObj:HasObjVar("FavorDR") ) then playerObj:DelObjVar("FavorDR") end
		ClearAllegiancePlayerVars(playerObj)
		SetAllegiancePlayerVarsDefault(playerObj)
		if ( GetAllegianceId(playerObj) ~= nil ) then
            CallFunctionDelayed(TimeSpan.FromSeconds(5),function()playerObj:SystemMessage("A new Allegiance season has started! Rankings have been reset!","event")end)
		end
    end

    local allegianceId = GetAllegianceId(playerObj)
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
        
        local oldRankName = playerObj:GetObjVar("AllegianceRankName")
        --set rank name and number
        local rankTable = ServerSettings.Allegiance.Allegiances[allegianceId].Ranks
        for k, v in pairs(rankTable) do
            if ( rankTable ~= nil and percentile >= v.Percentile ) then
                playerObj:SetObjVar("AllegianceRankName", v.Name)
                playerObj:SetObjVar("AllegianceRankNumber", v.Number)
                local newRankName = playerObj:GetObjVar("AllegianceRankName")
                if ( newRankName and newRankName ~= oldRankName ) then
                    CallFunctionDelayed(TimeSpan.FromSeconds(5),function()playerObj:SystemMessage("Your Allegiance rank is now "..v.Name, "event")end)
                end
                return v.Name, v.Number
            end
        end
    else
        playerObj:SetObjVar("AllegiancePercentile", 0)
        playerObj:SetObjVar("AllegianceStanding", 0)
        playerObj:SetObjVar("AllegianceRankName", "Unranked")
        playerObj:SetObjVar("AllegianceRankNumber", 0)
    end
end

--- Set a player's allegiance ObjVars to default values for a new enlistee
-- @param playerObj
-- @param (optional) favor
function SetAllegiancePlayerVarsDefault(playerObj, favor)
    if not( playerObj:HasObjVar("Allegiance") ) then return false end
    local newFavor = favor or ServerSettings.Allegiance.SignupFavor or 1
    SetFavor(playerObj, newFavor)
    SetFavorFromEvents(playerObj, ServerSettings.Allegiance.FavorFromEvents)

    local currentGlobalSeason = GlobalVarRead("Allegiance.CurrentSeason")
    if ( currentGlobalSeason ~= nil and currentGlobalSeason.StartDate ~= nil ) then
        playerObj:SetObjVar("AllegianceSeasonStart", currentGlobalSeason.StartDate)
    end
end

--- Removes all allegiance ObjVars on the player EXCEPT for Favor, AllegianceResign, Allegiance
-- @param playerObj
function ClearAllegiancePlayerVars(playerObj)
    if ( playerObj:HasObjVar("FavorFromEvents") ) then playerObj:DelObjVar("FavorFromEvents") end
    if ( playerObj:HasObjVar("AllegianceStanding") ) then playerObj:DelObjVar("AllegianceStanding") end
    if ( playerObj:HasObjVar("AllegiancePercentile") ) then playerObj:DelObjVar("AllegiancePercentile") end
    if ( playerObj:HasObjVar("AllegianceRankName") ) then playerObj:DelObjVar("AllegianceRankName") end
    if ( playerObj:HasObjVar("AllegianceRankNumber") ) then playerObj:DelObjVar("AllegianceRankNumber") end
    if ( playerObj:HasObjVar("AllegianceSeasonStart") ) then playerObj:DelObjVar("AllegianceSeasonStart") end
end

--[[ Favor ]]

function GetFavor(player)
    return player:GetObjVar("Favor") or 0
end

function GetAllegianceName(playerObj)
    local allegianceId = GetAllegianceId(playerObj)
    if ( allegianceId == nil ) then return nil end
    local allegianceData = GetAllegianceDataById(allegianceId)
    if ( allegianceData ) then
        return allegianceData.Name
    end
    return nil
end

function SetFavor(player, favor)
    player:SetObjVar("Favor", math.round(favor, 4))
end

function SetFavorFromEvents(player, favor)
    player:SetObjVar("FavorFromEvents", favor)
end

--- Remove a player's entry from their respective roster controller
-- @param playerObj
function RemovePlayerFromFavorTable(playerObj)
    local controllerID = GetAllegianceRosterControllerID(playerObj)
    if ( controllerID == nil ) then return nil end
    controllerID:SendMessageGlobal("AdjustFavorTable", playerObj, 0, true)
end

--- Gets a player's corresponding roster controller ID
-- @param playerObj
function GetAllegianceRosterControllerID(playerObj)
    local allegianceId = GetAllegianceId(playerObj)
    if ( allegianceId == nil ) then return nil end
    local rosterController = GlobalVarRead("Allegiance.RosterController."..allegianceId)
    if ( rosterController.ID == nil ) then return nil end

    return rosterController.ID
end

--[[ Diminishing Returns ]]

--- Adds a kill count to the aggressor(killer) FavorDR ObjVar, creates expiration time if it's the first kill in the entry
-- @param victim (playerObj)
-- @param aggressor (playerObj)
function UpdateFavorDR(victim, aggressor)
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
function GetFavorDRMultiplier(victim, aggressor)
    PruneFavorDR(aggressor)
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
function PruneFavorDR(playerObj)
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
function SetAllegianceVar(name, writeFunction, cb)
    if ( name == nil or writeFunction == nil ) then return false end
    SetGlobalVar(string.format("Allegiance.%s", name), writeFunction, cb)
end

--- Get a Global allegiance variable by name
-- @param id
-- @param name The variable name
-- @return value of the global variable or nil
function GetAllegianceVar(id, name)
    if ( id == nil or name == nil ) then return nil end
    return GlobalVarRead("Allegiance."..name.."."..tostring(id))
end

--- Determine if two players are in opposing allegiances to eachother (both in allegiances but are not the same allegiance)
-- @param victim
-- @param aggressor
-- @return true if both players are in opposing allegiances
function InOpposingAllegiance(victim, aggressor)
    Verbose("Allegiance", "InOpposingAllegiance", victim, aggressor)
    local allegianceA = GetAllegianceId(victim)
    if ( allegianceA ~= nil ) then
        local allegianceB = GetAllegianceId(aggressor)
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
function CanAttackAllegianceAttackable(aggressor, victim)
    local allegianceId = aggressor:GetObjVar("Allegiance")
    --attacker can't attack an allegiance mob if attacker is not in an allegiance
    if ( allegianceId == nil ) then return false end
    local allegianceAttackable = victim:GetObjVar("AllegianceAttackable")
    --if victim doesn't have AllegianceAttackable true then return false
    if ( allegianceAttackable ~= nil and allegianceAttackable ~= true ) then return false end
    --otherwise true
    return true
end

--- Get a player's allegiance id
-- @param playerObj
-- @return the players allegiance id or nil
function GetAllegianceId(playerObj)
    return playerObj:GetObjVar("Allegiance")
end

--- The the details about a allegiance by the allegiance's id
-- @param allegianceId
-- @return The allegiance data for the allegiance id or nil
function GetAllegianceDataById(allegianceId)
    for i=1,#ServerSettings.Allegiance.Allegiances do
        if ( ServerSettings.Allegiance.Allegiances[i].Id == allegianceId ) then
            return ServerSettings.Allegiance.Allegiances[i]
        end
    end
    return nil
end

function GetAllegiancePercentile(playerObj)
    return playerObj:GetObjVar("AllegiancePercentile") or 0
end

function GetAllegianceStanding(playerObj)
    return playerObj:GetObjVar("AllegianceStanding") or 0
end

function GetAllegianceRankName(playerObj)
    return playerObj:GetObjVar("AllegianceRankName") or "Unranked"
end

function GetAllegianceRankNumber(playerObj)
    return playerObj:GetObjVar("AllegianceRankNumber") or 0
end

--[[ unused ]]

--- Higher level allegiance title check, only requiring player
-- @param player
function CheckAllegianceTitle(player)
    local allegiance = GetAllegianceId(player)

    -- not in an allegiance, stop here
    if ( allegiance == nil ) then return end

    local totalFavor = GlobalVarRead("AllegianceFavor") or {}
    totalFavor = totalFavor[allegiance] or 0

    UpdateAllegianceTitle(player, allegiance, totalFavor)
end

--- Update a player's title for their allegiance, does not enfore or check much and is pretty raw
-- @param player
-- @param allegiance
-- @param totalFavor, Number Total favor for the allegiance
function UpdateAllegianceTitle(player, allegiance, totalFavor)
    totalFavor = totalFavor or 0

    -- get the allegiance data
    local allegianceData = GetAllegianceDataById(allegiance)
    if ( allegianceData == nil ) then
        LuaDebugCallStack("[UpdateAllegianceTitle] Nil allegianceData, is allegiance '"..allegiance.."' valid?")
        return
    end

    -- decide the size of their slice of the pie
    local percent = GetFavor(player) / totalFavor

    --Check if player should earn achievement for current allegiance
    CheckAchievementStatus(player, "PvP", allegianceData.Icon.."Allegiance", percent, {TitleCheck = "Allegiance"}, "Allegiance")

    --Check if a player who lost favor can use allegiance title
    CheckTitleRequirement(victim, allegianceData.Icon.."Allegiance")
end