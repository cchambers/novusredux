colorWars = "[FF0000]C[-][FF7F00]O[-][FFFF00]L[-][00FF00]O[-][0000FF]R[-] [4B0082]W[-][9400D3]A[-][FF0000]R[-][FF7F00]S[-]"
mCountdown = 10
mCountdownEvery = 2
mPlayers = {}
mPlayerCount = 0
mCaptains = {}
mLastTeamPick = nil

enterZone = {
    e831 = "2435.55, 0, 532.21",
    e834 = "2440.46, 0, 532.21"
}

function OpenRegistration()
    GlobalVarDelete("ColorWar.Player", nil)
    GlobalVarWrite(
        "ColorWar.Registration",
        nil,
        function(record)
            record["open"] = true
            return true
        end
    )

    DoBroadcast()
end

function DoBroadcast()
    ServerBroadcast(colorWars .. " registration open for the next " .. mCountdown .. " minutes! To queue, type: /cw", true)
    if (mCountdown > 5) then
        local nearbyPlayers = FindObjects(SearchPlayerInRange(30))
        for i = 1, #nearbyPlayers do
            nearbyPlayers[i]:SystemMessage("IF YOU JUST GOT OUT OF A COLOR WARS, YOU MUST RE-QUEUE WITH /cw OR BE EJECTED")
        end
    end
    mCountdown = mCountdown - mCountdownEvery
    if (mCountdown > 0) then
        this:ScheduleTimerDelay(TimeSpan.FromMinutes(mCountdownEvery), "ColorWar.Broadcast")
    else
        SummonPlayers()
    end
end

function SummonPlayers()
    mPlayers = GlobalVarRead("ColorWar.Queue")
    local count = 0
    if (mPlayers == nil) then
        ServerBroadcast("Color Wars cancelled -- not enough entrants.", true)
        CloseRegistration()
        return
    end
    for player, t in pairs(mPlayers) do
        if (GlobalVarReadKey("User.Online", player)) then
            count = count + 1
            player:SendMessageGlobal("GlobalSummon", this:GetObjVar("Destination"), this:GetObjVar("RegionAddress"))
            DebugMessage("Summoning " .. player:GetName() .. " for Color Wars.")
            GlobalVarWrite(
                "ColorWar.Player",
                nil,
                function(record)
                    record[this] = true
                    return true
                end
            )
        else
            DebugMessage(player:GetName() .. " is no longer online.")
        end
    end
    DebugMessage(tostring("Summoned " .. count .. " players for Color Wars."))

    -- if less than 6 people, extend "OPEN" for 5 mins?
    CloseRegistration()

    CallFunctionDelayed(TimeSpan.FromSeconds(5), PickCaptains)
end

function PickCaptains()
    DebugMessage("PickCaptains")
    for player, t in pairs(mPlayers) do
        player:ScheduleTimerDelay(TimeSpan.FromSeconds(30), "ColorWar.Roll")
        player:ScheduleTimerDelay(TimeSpan.FromSeconds(65), "ColorWar.DoCaptains")
        player:SystemMessage("Want to be a captain? Time to roll for it! (/roll)", "event")
    end
end

function DoCaptains()
    DebugMessage("DoCaptains")
    local heads = 0
    local headsPlayer = nil
    local tails = 0
    local tailsPlayer = nil

    for player, t in pairs(mPlayers) do
        local roll = player:GetObjVar("ColorWarRoll")
        player:DelObjVar("ColorWarRoll")

        if (roll > heads) then
            if (tailsPlayer) then
                tails = heads
                tailsPlayer = tailsPlayer
            end
            heads = roll
            headsPlayer = player
        end
    end

    ChooseTeam(headsPlayer, tailsPlayer)
end

function ChooseTeam(headsCaptain, tailsCaptain)
    DebugMessage("CHOOSE TEAM")
    mCaptains = {headsCaptain, tailsCaptain}
    mHeadsCaptain = headsCaptain
    mTailsCaptain = tailsCaptain
    -- pop "RED OR BLUE" window for HeadsPlayer. If they close it, open it for tailsPlayer
    MakeCaptain(headsCaptain, 831, true)
    MakeCaptain(tailsCaptain, 835)
end

function MakeCaptain(player, team, firstPick)
    player:SetObjVar("ColorWarCaptain", true)
    player:SetObjVar("ColorWarTeam", team)

    player:SendMessageGlobal("GlobalSummon", enterZone[tostring("e" .. team)], "AzureSky.NewCelador.EasternFrontier")

    if (firstPick) then
    -- triggerTeamChooserWindow after 3 seconds
    end
end

function ChooseTeammate(player, user)
    local team = user:GetObjVar("ColorWarTeam")
    mLastTeamPick = team
    player:SetObjVar("ColorWarTeam", team)
    player:SendMessageGlobal("GlobalSummon", enterZone[tostring("e" .. team)], "AzureSky.NewCelador.EasternFrontier")
    this:SendMessage("ColorWar.NextChoice")
end

function NextChoice()
    if (mLastTeamPick == 831) then
    else
    end
end

function CloseRegistration()
    GlobalVarDelete("ColorWar.Queue", nil)
    GlobalVarWrite(
        "ColorWar.Registration",
        nil,
        function(record)
            record["open"] = false
            return true
        end
    )
end

RegisterEventHandler(EventType.Timer, "ColorWar.Go", OpenRegistration)
RegisterEventHandler(EventType.Timer, "ColorWar.Broadcast", DoBroadcast)
RegisterEventHandler(EventType.Timer, "ColorWar.DoCaptains", DoCaptains)
RegisterEventHandler(EventType.Nessage, "ColorWar.NextChoice", NextChoice)
RegisterEventHandler(EventType.ModuleAttached, GetCurrentModule(), HandleModuleLoaded)

RegisterEventHandler(
    EventType.Message,
    "ColorWar.Queue",
    function(args)
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
    end
)
