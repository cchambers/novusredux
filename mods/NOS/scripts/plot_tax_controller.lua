
--- this is a module that cluster control attaches to its self when told to tax all the houses in a region


local _Controllers = {}
local _I,_Frame_I = 0,0
local _FrameDelay = TimeSpan.FromSeconds(1)
local _PlotsPerSecond = 10

local _Done = 0

function CleanUp()
    DebugMessage("[Tax] Done. Total Plots: "..#_Controllers)
    local players = FindObjects(SearchModule("plot_control_window"))
    for i=1,#players do players[i]:SendMessage("UpdatePlotControlWindow") end
    this:Destroy()
end

function TaxAll()
    DebugMessage("[Tax] Started.")
    local controllers = FindObjects(SearchTemplate("plot_controller"))
    for i=1,#controllers do
        local controller = controllers[i]
        if ( controller and controller:IsValid() and not controller:HasModule("plot_bid_controller") ) then
            _Controllers[#_Controllers+1] = controller
        end
    end
    if ( #_Controllers < 1 ) then
        CleanUp()
        return
    end
    TaxNext()
end

function CheckDone()
    _Done = _Done + 1
    if ( _Done >= #_Controllers ) then
        CleanUp()
    end
end

function TaxNext()
    _I = _I + 1
    -- no more
    if ( _I > #_Controllers ) then return end

    xpcall(function()
        -- tax the plot via controller
        Plot.Tax(_Controllers[_I])
        CheckDone()
    end, function(e)
        LuaDebugCallStack("[PLOT TAX CONTROLLER]" .. e)
    end)

    -- do next
    _Frame_I = _Frame_I + 1
    if ( _Frame_I > _PlotsPerSecond ) then
        _Frame_I = 0
        -- next frame
        this:ScheduleTimerDelay(_FrameDelay, "TaxNext")
    else
        -- same frame
        TaxNext()
    end
end

RegisterEventHandler(EventType.Timer, "TaxNext", TaxNext)

RegisterEventHandler(EventType.ModuleAttached, "plot_tax_controller", function()
    -- put it into the next frame so we can detach
    CallFunctionDelayed(_FrameDelay, TaxAll)
end)