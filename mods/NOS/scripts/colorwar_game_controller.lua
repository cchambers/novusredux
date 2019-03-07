mRound = 0
mPlayers = nil
mPlaying = false
mCountdown = 2

function StartRound()
    mRound = (this:GetObjVar("Round") or 0) + 1
    this:SetObjVar("Round", mRound)
    Countdown()
end

function Countdown() 
    mPlayers = FindPlayersInRegion()
    if (mCountdown > 1) then
        for i, j in pairs(mPlayers) do
            if (not(j:HasObjVar("ColorWarRound"))) then
                j:SetObjVar("ColorWarRound", mRound)
            end
            j:SystemMessage(tostring("[bada55]ROUND BEGINS IN [ffffff]"..mCountdown.."[-] MINUTES![-]"),"event")
            CallFunctionDelayed(TimeSpan.FromSeconds(30), function ( ... )
                j:SystemMessage(tostring("[bada55]ROUND BEGINS IN [ffffff]"..mCountdown..":30[-]![-]"),"event")
            end)
        end
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(60),"ColorWar.Countdown")
    elseif (mCountdown == 1) then
        for i, j in pairs(mPlayers) do
            j:SystemMessage(tostring("[bada55]ROUND BEGINS IN [ffffff]1[-] MINUTE![-]"),"event")
            CallFunctionDelayed(TimeSpan.FromSeconds(30), function ( ... )
                j:SystemMessage(tostring("[bada55]ROUND BEGINS IN [ffffff]30[-] SECONDS![-]"),"event")
            end)
            CallFunctionDelayed(TimeSpan.FromSeconds(50), function ( ... )
            j:SystemMessage(tostring("[bada55]ROUND BEGINS IN [ffffff]10[-] SECONDS![-]"),"event")
            end)
            CallFunctionDelayed(TimeSpan.FromSeconds(60), function ( ... )
                j:SystemMessage(tostring("[bada55]GO![-]"),"event")
            end)
        end
        CallFunctionDelayed(TimeSpan.FromSeconds(60), StartGame)
    end
    mCountdown = mCountdown - 1
end

function StartGame()
    mPlaying = true
end

function EndGame()
    mCountDown = 2

    CallFunctionDelayed(TimeSpan.FromSeconds(6), function () 
        mPlaying = false
        local cwbase = GameObj(68381273)
        cwbase:SendMessageGlobal("ColorWar.Go")
    end)
    
    local bodies = FindObjects(SearchTemplate("player_corpse"))
	
	local bodyCount = 0

	for i, j in pairs(bodies) do
		bodyCount = bodyCount + 1	
		j:Destroy()
	end

    DebugMessage(tostring("Destroyed " .. bodyCount .. " bodies."))
end


function FreezePing()
    mPlayers = FindPlayersInRegion()
    
    for i, j in pairs(mPlayers) do
        if (not(IsImmortal(j))) then
            if(mPlaying) then
                j:SendMessage("EndGodFreezeEffect")
            else
                j:SendMessage("StartMobileEffect", "GodFreeze")
            end

            -- if (j:HasObjVar("ColorWarRound")) then
            --     if (j:GetObjVar("ColorWarRound") ~= mRound) then
            --         -- EXIT THEM
            --     end
            -- end
        end
    end
    
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"ColorWar.FreezePing")
end


this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"ColorWar.FreezePing")
RegisterEventHandler(EventType.Timer, "ColorWar.FreezePing", FreezePing)
RegisterEventHandler(EventType.Timer, "ColorWar.Countdown", Countdown)

RegisterEventHandler(EventType.Message, "ColorWar.Countdown", StartRound)
RegisterEventHandler(EventType.Message, "ColorWar.StartRound", StartRound)
RegisterEventHandler(EventType.Message, "ColorWar.EndGame", EndGame)
RegisterEventHandler(EventType.Message, "ColorWar.StartGame", StartGame)