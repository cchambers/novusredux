function GetPlayerAllegianceName(playerObj)
    local allegianceId = GetAllegianceId(playerObj)
    if ( allegianceId == nil ) then return nil end
    local allegianceData = GetAllegianceDataById(allegianceId)
    if ( allegianceData ) then
        return allegianceData.Name
    end
    return nil
end

--- Determine if two players are in opposing allegiances to eachother (both in allegiances but are not the same allegiance)
-- @param playerA
-- @param playerB
-- @return true if both players are in opposing allegiances
function InOpposingAllegiance(playerA, playerB)
    Verbose("Allegiance", "InOpposingAllegiance", playerA, playerB)
    local allegianceA = GetAllegianceId(playerA)
    if ( allegianceA ~= nil ) then
        local allegianceB = GetAllegianceId(playerB)
        if ( allegianceB ~= nil ) then
            return allegianceA ~= allegianceB
        end
    end
    return false
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

--- Get a player's allegiance id
-- @param playerObj
-- @return the players allegiance id or nil
function GetAllegianceId(playerObj)
    return playerObj:GetObjVar("Allegiance")
end

--- Set/Delete a player's allegiance Id
-- @param playerObj
-- @param value New allegiance id
function SetAllegianceId(playerObj, value)
    if ( value ) then
        local allegianceData = GetAllegianceDataById(value)
        if ( allegianceData == nil ) then return end
        playerObj:SetObjVar("Allegiance", value)
        -- set the allegiance icon
	    playerObj:SetSharedObjectProperty("Faction", allegianceData.Icon)
        playerObj:SystemMessage("You are now loyal to "..allegianceData.Name..".", "event")
    else
        -- create a unique event identifier
        local eventId = uuid()
        -- setup a listener for the global var update result
        RegisterSingleEventHandler(EventType.GlobalVarUpdateResult, eventId, function(success, name, record)
            if ( success ) then
                playerObj:SetSharedObjectProperty("Faction", "None")
                playerObj:SystemMessage("You have denounced your allegiance.", "event")

                -- clear all allegiance variables
                playerObj:DelObjVar("Allegiance")
                playerObj:DelObjVar("AllegianceResign")
                playerObj:DelObjVar("Favor")
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

--- Get a Global allegiance variable by name
-- @param id
-- @param name The variable name
-- @return value of the global variable or nil
function GetAllegianceVar(id, name)
    if ( id == nil or name == nil ) then return nil end
    return GlobalVarRead("Allegiance."..name.."."..tostring(id))
end

--- Set a Global allegiance variable by name
-- @param id
-- @param name The variable name
-- @param writeFunction
-- @return returns GlobalVarUpdateResult event id or false for bad params
function SetAllegianceVar(id, name, eventId, writeFunction)
    if ( id == nil or name == nil or writeFunction == nil ) then return false end
    GlobalVarWrite(string.format("Allegiance.%s.%s", name, id), eventId, writeFunction)
end

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
    local eventId = uuid()
    RegisterSingleEventHandler(EventType.GlobalVarUpdateResult, eventId, function(success, name, record)
        if ( success ) then
            -- set the allegiance id on the player
            SetAllegianceId(playerObj, allegianceId)
        end
    end)
    local writeFunction = function(record)
        -- set the value as the time joined
        record[playerObj] = DateTime.UtcNow
        return true
    end
    SetAllegianceVar(allegianceId, "Members", eventId, writeFunction)

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

    local eventId = uuid()
    RegisterSingleEventHandler(EventType.GlobalVarUpdateResult, eventId, function(success, name, record)
        -- remove the allegiance from the player
        SetAllegianceId(playerObj, nil)
    end)
    local writeFunction = function(record)
        if ( record[playerObj] == nil ) then return false end
        -- remove the player from the allegiance
        record[playerObj] = nil
        return true
    end
    SetAllegianceVar(allegianceId, "Members", eventId, writeFunction)

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
            AllegianceTransferFavor(player, winner)
        end
    end
end

function GetFavor(player)
    return player:GetObjVar("Favor") or 0
end

function SetFavor(player, favor)
    player:SetObjVar("Favor", favor)
end

--- Transfer favor from playerA to playerB, does not enforce they are in opposing allegiances tho they must both be in opposing allegiances.
-- @param playerA
-- @param playerB
function AllegianceTransferFavor(playerA, playerB)
    -- cannot gain points while resigning
    if ( playerA:HasObjVar("AllegianceResign") ) then return end
    local aAllegiance = GetAllegianceId(playerA)
    local bAllegiance = GetAllegianceId(playerB)

    -- if either are not in an allegiance stop here
    if ( aAllegiance == nil or bAllegiance == nil ) then return end

    -- get the favor of A
    local favorA = GetFavor(playerA)
    -- if playerA cannot loose anymore points
    if ( favorA <= -6 ) then
        -- tell B sorry
        playerB:SystemMessage("Your victim lacked favor.", "event")
        return
    end

    -- calculate the amount of favor to transfer
    local amount = 1
    if ( favorA > 19 ) then
        amount = math.floor(favorA * 0.10)
    end

    -- create a unique event identifier
    local eventId = uuid()
    -- setup a listener for the global var update result
    RegisterSingleEventHandler(EventType.GlobalVarUpdateResult, eventId, function(success, name, record)
        if ( success ) then
            -- successfully updated the global variables (transfered allegiance totals)

            -- transfer favor from A to B
            SetFavor(playerA, GetFavor(playerA) - amount)
            SetFavor(playerB, GetFavor(playerB) + amount)
        
            -- tell each player about it
            playerA:SystemMessage("Lost "..amount.." favor.", "event")
            playerB:SystemMessage("Received "..amount.." favor.", "event")
        
            -- update their title if necessary
            UpdateAllegianceTitle(playerB, bAllegiance, record[bAllegiance])
        end
    end)
    local writeFunction = function(record)
        -- default allegiance total favor to 0
        if ( record[aAllegiance] == nil ) then record[aAllegiance] = 0 end
        if ( record[bAllegiance] == nil ) then record[bAllegiance] = 0 end

        -- transfer total favor from allegianceA to allegianceB
        record[aAllegiance] = record[aAllegiance] - amount
        record[bAllegiance] = record[bAllegiance] + amount

        return true
    end
    -- write to the global variable
    GlobalVarWrite("AllegianceFavor", eventId, writeFunction)
end

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

    -- find their title for their pie slice size
    local found = nil
    for i=1,#allegianceData.Titles do
        if ( percent >= allegianceData.Titles[i].Percent ) then
            found = allegianceData.Titles[i]
        end
    end

    -- if they have a title, update/add it
    if ( found ) then
        local playerTitles = player:GetObjVar("GameplayTitles") or {}

        local titleIndex = nil
        for i=1,#playerTitles do
            if ( playerTitles.Handle == "Allegiance" ) then
                titleIndex = i
            end
        end

        if ( titleIndex ) then
            -- update title
            -- no change to title, stop here
            if ( playerTitles[titleIndex].Title == found.Title ) then return end

            playerTitles[titleIndex].Title = found.Title
            playerTitles[titleIndex].Description = found.Description
        else
            -- title is new
            table.insert(playerTitles, {
                Title = found.Title,
                Description = found.Description,
                Handle = "Allegiance",
                IsAccountTitle = true -- temp hack to throw them into Other
            })
        end

        titleIndex = titleIndex or #playerTitles

        player:SetObjVar("titleIndex", titleIndex)
		player:SetObjVar("GameplayTitles", playerTitles)
        player:SendMessage("UpdateTitle")

    end

end