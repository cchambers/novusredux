
--- this is a module that cluster control attaches to its self when told to check all houses in region to be put up for sale


local _Controllers = {}
local _I,_Frame_I = 0,0
local _FrameDelay = TimeSpan.FromSeconds(1)
local _PlotsPerSecond = 10

local _Done = 0

function CleanUp()
    DebugMessage("[Sale] Done. Total Plots Put Up for Sale: "..#_Controllers)
    local players = FindObjects(SearchModule("plot_control_window"))
    for i=1,#players do players[i]:SendMessage("UpdatePlotControlWindow") end
    this:Destroy()
end

function SaleAll()
    DebugMessage("[Sale] Started.")
    local controllers = FindObjects(SearchTemplate("plot_controller"))
    for i=1,#controllers do
        local controller = controllers[i]
        if ( controller and controller:IsValid() ) then
            local balance = GlobalVarReadKey("Plot."..controller.Id, "Balance") or 0
            if ( balance < 0 ) then
                _Controllers[#_Controllers+1] = controller
            end
        end
    end
    if ( #_Controllers < 1 ) then
        CleanUp()
        return
    end
    SaleNext()
end

function CheckDone()
    _Done = _Done + 1
    if ( _Done >= #_Controllers ) then
        CleanUp()
    end
end

function SaleNext()
    _I = _I + 1
    -- done
    if ( _I > #_Controllers ) then return end

    xpcall(function()
        -- sale the plot via controller
        Plot.Sale(_Controllers[_I], _I, CheckDone)
    end, function(e)
        LuaDebugCallStack("[PLOT SALE CONTROLLER]" .. e)
    end)

    -- do next
    _Frame_I = _Frame_I + 1
    if ( _Frame_I > _PlotsPerSecond ) then
        _Frame_I = 0
        -- next frame
        this:ScheduleTimerDelay(_FrameDelay, "SaleNext")
    else
        -- same frame
        SaleNext()
    end
end

RegisterEventHandler(EventType.Timer, "SaleNext", SaleNext)

RegisterEventHandler(EventType.ModuleAttached, "plot_sale_controller", function()
    -- put it into the next frame so we can detach
    CallFunctionDelayed(_FrameDelay, SaleAll)
end)