

function HandleModuleLoaded() 
    CallFunctionDelayed(TimeSpan.FromSeconds(2), OpenRegistration)
end

function OpenRegistration()
    GlobalVarDelete("ColorWar.Player", nil)
    GlobalVarWrite("ColorWar.Registration", nil, function (record) 
        record["open"] = true
        return true
    end)

    ServerBroadcast("Color Wars registration open for the next ten (10) minutes! To queue, type: /cw", true)
    
    CallFunctionDelayed(TimeSpan.FromSeconds(5), function()
        ServerBroadcast("Color Wars registration open for the next five (5) minutes! To queue, type: /cw", true)
    end)

    CallFunctionDelayed(TimeSpan.FromSeconds(10), function()
        SummonPlayers()
    end)
end

function SummonPlayers()
    local players = GlobalVarRead("ColorWar.Queue")
    local count = 0
    if (players == nil) then
        DebugMessage("No one is queued.")
        CloseRegistration()
        return
    end
    for player, t in pairs(players) do
        if ( GlobalVarReadKey("User.Online", player) ) then
            count = count + 1
            player:SendMessageGlobal("GlobalSummon", this:GetObjVar("Destination"), this:GetObjVar("RegionAddress"))
            DebugMessage("Summoning " .. player:GetName() .. " for Color Wars.")
            GlobalVarWrite("ColorWar.Player", nil, function (record) 
                record[this] = true
                return true
            end)
        else
            DebugMessage(player:GetName() .. " is no longer online.")
        end
    end
    DebugMessage(tostring("Summoned " .. count .. " players for Color Wars."))

    -- if less than 6 people, extend "OPEN" for 5 mins?
    CloseRegistration()
end

function CloseRegistration()
    GlobalVarDelete("ColorWar.Queue", nil)
    GlobalVarWrite("ColorWar.Registration", nil, function (record) 
        record["open"] = false
        return true
    end)
end

RegisterEventHandler(EventType.ModuleAttached, GetCurrentModule(), HandleModuleLoaded)

RegisterEventHandler(EventType.Message,"ColorWar.Queue", function ( args )
    local user = args.user

    for index, char in pairs(mQueue) do
        if (char == user) then
            table.remove(mQueue, index)
            DebugMessage("De-queued " .. user:GetName() .. " for Color Wars.")
            user:SendMessageGlobal("ColorWar.Exit")
            return
        end
    end

    table.insert(mQueue, user)
    DebugMessage("Queued " .. user:GetName() .. " for Color Wars.")
    user:SendMessageGlobal("ColorWar.Enter")
end)