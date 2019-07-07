-- To use: (should start as close to center of a region as possible since this goes out in a spiral)
-- /create house_bot
-- /info house_bot
-- Add Obj Var
--- GameObj 'Player'
---- Target Player
-- Send Message Start


local _Running = false
local _HousingRegion = GetRegion("Housing")
local _Total = 0 -- total plots created
local _Failures = 0
local _MinPlotSizeWithBuffer = 17 -- this is the size of a plot + the buffer size
local _I = 0
local _Loc = Loc(0, 0, 0)
local _PlayerObj = nil -- the player all the houses go to
local _SubRegion = nil -- Subregion player is in, if any.
local _This_I = 0

local _MAX = 999999

local math = math

RegisterEventHandler(EventType.Message, "Start", function(at)

    _PlayerObj = this:GetObjVar("Player")
    _Center = this:GetObjVar("Center") or this:GetLoc()

    if not( _PlayerObj ) then
        this:NpcSpeech("No Player.")
        return
    end
    
	if ( at ) then
    	_I = tonumber(at) or 0
	end
	-- if this map has no valid housing region, fail
	if ( _HousingRegion == nil ) then
		_PlayerObj:SystemMessage("This server region does not have a housing region.", "info")
		return
    end

    local subregion = ServerSettings.SubregionName
    if ( subregion ) then
        _SubRegion = GetRegion("Subregion-"..subregion)
    end
    
    -- Are you sure?
    ClientDialog.Show{
        TargetUser = _PlayerObj,
        DialogId = "HouseBot",
        TitleStr = "House Bot",
        DescStr = "ARE YOU SURE? THIS WILL FILL THE ENTIRE REGION WITH PLOTS AND HOUSES!! SERIOUSLY DON'T DO THIS UNLESS YOU KNOW WHAT YOU'RE DOING FFS.",
        Button1Str = "DO IT",
        Button2Str = "Cancel",
        ResponseObj = this,
        ResponseFunc = function( user, buttonId )
            buttonId = tonumber(buttonId)
            if ( buttonId == 0 ) then
                _Running = true
                this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1), "TryCreatePlot")
            end
        end,
    }
end)

function Next()
    if ( _Total < _MAX ) then
        _I = _I + 1
        _Loc = GetSpiralLoc(_I, _Center, _MinPlotSizeWithBuffer)
        _This_I = _This_I + 1
        if ( _This_I > 150 ) then
            _This_I = 0
            this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1), "TryCreatePlot")
        else
            DoNext()
        end
    end
end

function DoNext()
    if ( _Running ) then
        if ( not _SubRegion or _SubRegion:Contains(_Loc) ) then
            this:SetWorldPosition(_Loc)
            if ( this:HasLineOfSightToLoc(_Loc) ) then
                Plot.New(_PlayerObj, _Loc, function(controller)
                    if ( controller ) then
                        local houseData = Plot.GetHouseData("wood_house", math.random(1,2) == 1 and 2 or 3)
                        local success, controller = Plot.TryPlaceHouse(_PlayerObj, _Loc, houseData)
                        if ( success ) then
                            Plot.CreateHouse(controller, _Loc, houseData, function()
                                _PlayerObj:SystemMessage("Created:".._Total.." Failed:".._Failures.." Tried:".._I, "info")
                            end, false)
                        end
                        _Total = _Total + 1
                    else
                        _Failures = _Failures + 1
                    end
                    Next()
                end)
            else
                _PlayerObj:SystemMessage("Cannot see that.", "info") -- keep it consistent
                _Failures = _Failures + 1
                Next()
            end
        else
            Next()
        end
    end
end

RegisterEventHandler(EventType.Timer, "TryCreatePlot", DoNext)

RegisterEventHandler(EventType.Message, "Stop", function()
    _Running = false
end)