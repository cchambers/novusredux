
local _Max_Distance = 25
local _TimeSpan = TimeSpan.FromMilliseconds(1)

local _I, _VI, _Center, _Max, _Loc, _Validating, _InfoCount

function Tick()
    this:ScheduleTimerDelay(_TimeSpan, "UnstuckTick")
end

RegisterEventHandler(EventType.Timer, "UnstuckInfo", function()
    if ( _InfoCount > 2 ) then
        this:SystemMessage("This could take a while, please be patient...", "info")
        _InfoCount = 0
    else
        this:SystemMessage("Searching for closest pathable location...", "info")
        _InfoCount = _InfoCount + 1
    end
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(4), "UnstuckInfo")
end)

RegisterEventHandler(EventType.ModuleAttached, "unstuck", function()
    _I, _Max = 0, _Max_Distance*_Max_Distance
    _Center = this:GetLoc()
    this:FireTimer("UnstuckTick")
    _InfoCount = 0
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.5), "UnstuckInfo")
end)

RegisterEventHandler(EventType.Timer, "UnstuckTick", function()
    if ( _Validating ) then
        _VI = _VI + 1
        if ( _VI > 10 or not IsPassable(_Loc) ) then
            _Validating = false
        else
            _Valid = CanPathTo(_Loc, _Loc:Project(_VI*36, 20)) and Plot.GetAtLoc(_Loc) == nil
            if ( _Valid ) then _Validating = false end
        end
        Tick()
    else
        if ( _Valid ) then
            ClearAndMove(_Loc)
        else
            if ( _I < _Max ) then
                if ( _I == 0 ) then
                    _Loc = _Center
                else
                    _Loc = GetSpiralLoc(_I, _Center)
                end
                _I = _I + 1
                _Validating, _VI = true, 0
                Tick()
            else
                DebugMessage("[UNSTUCK] Failed too many times for Loc", _Loc)
                -- failed too many times, send them to guaranteed un-stuck spot.
                ClearAndMove()
            end
        end
    end

end)

RegisterEventHandler(EventType.Timer, "ClearAndMove", ClearAndMove)
RegisterEventHandler(EventType.StartMoving, "", function()
    this:SystemMessage("Unstuck Cancelled.", "event")
    this:DelModule("unstuck")
end)
RegisterEventHandler(EventType.Message, "DamageInflicted", function()
    this:SystemMessage("Unstuck Cancelled.", "event")
    this:DelModule("unstuck")
end)

function ClearAndMove(loc)
    -- didn't move anywhere, don't give the benefits
    if ( loc:Equals(_Center) ) then
        this:SystemMessage("You are not stuck.", "info")
        this:DelModule("unstuck")
        return
    end
	this:SetMobileFrozen(false, false)
	this:SendMessage("StopSitting")
	this:SendMessage("WakeUp")

	this:SystemMessage("[$2408]","event")

	this:SendMessage("BreakInvisEffect", "Action")
	-- hack to fix people being perma cloaked
	if (not this:HasObjVar("IsGhost")) then
		this:SetCloak(false)
    end

    -- loc was not provided, check outcast status
    if not( loc ) then
        if ( GetKarmaLevel(GetKarma(this)).GuardHostilePlayer ) then
            local spawnPosition = FindObjectWithTag("OutcastSpawnPosition")
            if ( spawnPosition ) then
                loc = spawnPosition:GetLoc()
            end
        end
    end

    -- loc still not set, use player spawn position
    if not( loc ) then
        loc = GetPlayerSpawnPosition(this)
    end

    if ( loc ) then
        -- move player and any pets
        ForeachMobileAndPet(this, function(mobile)
            mobile:SetWorldPosition(loc)
        end)
    end

    this:DelModule("unstuck")

end