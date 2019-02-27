colorWars = "[FF7F00]COLOR[-][0000FF]WARS[-]"
mCountdown = 6
mCountdownEvery = 2
mPlayers = {}
mPlayerCount = 0
mCaptains = {}
mLastTeamPick = nil

function OpenRegistration()
    mCountdown = 6
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
    if (mCountdown <= 0) then
        ServerBroadcast("Summoning players for " .. colorWars, true)
    else
        ServerBroadcast(colorWars.." registration open for the next "..mCountdown.." minutes! To queue, type: /cw", true)
    end
    if (mCountdown > 5) then
        local nearbyPlayers = FindObjects(SearchPlayerInRange(30))
        for i = 1, #nearbyPlayers do
            nearbyPlayers[i]:SystemMessage("IF YOU JUST GOT OUT OF A COLOR WARS, YOU MUST RE-QUEUE WITH /cw OR BE EJECTED")
        end
    end
    mCountdown = mCountdown - mCountdownEvery
    if (mCountdown >= 0) then 
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
            player:SetObjVar("ColorWarWaiting", true)
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

    CallFunctionDelayed(TimeSpan.FromSeconds(30), PickCaptains)
end

function PickCaptains()
    for player, t in pairs(mPlayers) do
        player:ScheduleTimerDelay(TimeSpan.FromSeconds(15), "ColorWar.Roll")
        player:SystemMessage("Want to be a captain? Time to roll for it! (/roll)", "event")
    end
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(20), "ColorWar.DoCaptains")
end

function DoCaptains()
    mCaptains = {}
    local heads = 0
    local tails = 0

    for player, t in pairs(mPlayers) do
        local roll = player:GetObjVar("ColorWarRoll") or 0
        player:DelObjVar("ColorWarRoll")

        if (roll > heads) then
            if (mCaptains.red) then
                mCaptains.blue = mCaptains.red
                tails = heads
            end
            heads = roll
            mCaptains.red = player
        elseif (roll > tails) then
            tails = roll
            mCaptains.blue = player
        end
    end
    this:SendMessage("ColorWar.MakeCaptains")
end

function MakeCaptains()
    ChoosePlayer(mCaptains.red, 831, true, true)
    CallFunctionDelayed(TimeSpan.FromSeconds(0.25), function () 
        ChoosePlayer(mCaptains.blue, 835, true)
    end)
end

function ChoosePlayer(player, team, captain, firstPick)
    if (player == nil) then
        DebugMessage(tostring("PLAYER NIL " .. team))
        return
    end
    player:SetObjVar("ColorWarTeam", team)
 
    if (captain) then
        player:SetObjVar("ColorWarCaptain", true)
    end

    if (team == 831) then
        player:SendMessageGlobal("GlobalSummon", this:GetObjVar("e831"), this:GetObjVar("RegionAddress"))
    end

    if (team == 835) then
        player:SendMessageGlobal("GlobalSummon", this:GetObjVar("e835"), this:GetObjVar("RegionAddress"))
    end

    if (firstPick) then
        player:SystemMessage("Choose someone for your team.", "event")
    else
        mLastTeamPick = team
    end
    
    this:SendMessage("ColorWar.NextChoice")
end


function NextChoice()
    if (mLastTeamPick == 831) then
        ShowPicker(mCaptains.blue)
    else
        ShowPicker(mCaptains.red)
    end
end

function ShowPicker(user) 
    user:RequestClientTargetGameObj(this, "ColorWar.PlayerChosen")
end

function PlayersWaiting()

end

function HandlePlayerChosen(target, user) 
    if( target == nil or target == user or not(IsPlayerCharacter(target))) then
        local nearbyPlayers = FindObjects(SearchPlayerInRange(30))
        local count = 0
        for i = 1, #nearbyPlayers do
            if(nearbyPlayers[i]:HasObjVar("ColorWarWaiting")) then
                count = count + 1
            end
        end
        if (count > 0) then
            user:SystemMessage(tostring("Choose someone! There are " .. count .. " players waiting."), "info")
        else
            for i = 1, #nearbyPlayers do
                if(nearbyPlayers[i]:HasObjVar("ColorWarTeam")) then
                    nearbyPlayers[i]:SystemMessage("That's everyone! Hurry to your base, the round begins SOON!")
                    CheckRoundStarted()
                end
            end
        end
    elseif (target:HasObjVar("ColorWarTeam")) then 
        user:SystemMessage("Choose someone that isn't already on a team.", "info")
        ShowPicker(user)
    else
       ChoosePlayer(target, user:GetObjVar("ColorWarTeam"))
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

function CheckRoundStarted()
    return
end

RegisterEventHandler(EventType.Message, "ColorWar.Go", OpenRegistration)
RegisterEventHandler(EventType.Message, "ColorWar.NextChoice", NextChoice)
RegisterEventHandler(EventType.Message, "ColorWar.MakeCaptains", MakeCaptains)

RegisterEventHandler(EventType.Timer, "ColorWar.Broadcast", DoBroadcast)
RegisterEventHandler(EventType.Timer, "ColorWar.PickCaptains", PickCaptains)
RegisterEventHandler(EventType.Timer, "ColorWar.DoCaptains", DoCaptains)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "ColorWar.PlayerChosen", HandlePlayerChosen)

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
