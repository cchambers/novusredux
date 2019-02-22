
colorWars = "[FF0000]C[-][FF7F00]O[-][FFFF00]L[-][00FF00]O[-][0000FF]R[-] [4B0082]W[-][9400D3]A[-][FF0000]R[-][FF7F00]S[-]"
mCountdown = 10
mCountdownEvery = 2


function HandleModuleLoaded() 
    CallFunctionDelayed(TimeSpan.FromSeconds(5), OpenRegistration)
end

function OpenRegistration()
    GlobalVarDelete("ColorWar.Player", nil)
    GlobalVarWrite("ColorWar.Registration", nil, function (record) 
        record["open"] = true
        return true
    end)

    DoBroadcast()
end

function DoBroadcast() 
    ServerBroadcast(colorWars.." registration open for the next "..mCountdown.." minutes! To queue, type: /cw", true)
    mCountdown = mCountdown - mCountdownEvery
    if (mCountdown > 0) then 
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(mCountdownEvery), "ColorWar.Broadcast")
    else
        SummonPlayers()
    end
end

function SummonPlayers()
    local players = GlobalVarRead("ColorWar.Queue")
    local count = 0
    if (players == nil) then
        ServerBroadcast("Color Wars cancelled -- no entrants.", true)
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

RegisterEventHandler(EventType.Timer, "ColorWar.Broadcast", DoBroadcast)
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