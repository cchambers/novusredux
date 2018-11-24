


this:DelObjVar("UseCases")
SetItemTooltip(this)
-- recalc lockdown limit just incase the formula changed
this:SetObjVar("LockLimit", Plot.CalculateLockdownLimit(this:GetObjVar("PlotBounds") or {}))

Plot.ForeachHouse(this, function(house)
    local houseData = Plot.GetHouseDataFromHouse(house)
    house:SetObjVar("LockLimit", houseData.LockLimit or 10)
    house:SetObjVar("ContainerLimit", houseData.ContainerLimit or 1)
end)

CallFunctionDelayed(TimeSpan.FromSeconds(1), function()
    this:DelModule("plot_control_world_reset")
end)