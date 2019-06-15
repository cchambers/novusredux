
-- Taxes were significantly decreased and those with full balances were able to get multiple years worth of tax, this is refunding that extra.
local index = #AutoFixes + 1

AutoFixes[index] = {
    World = function(clusterController)
        local plots = FindObjects(SearchTemplate("plot_controller"),clusterController)
        local before = DateTime.UtcNow
        DebugMessage("[AutoFix] "..#plots.." plots found.")
        for i=1,#plots do
            local controller = plots[i]
            local balance = Plot.GetBalance(controller)
            local rate = Plot.CalculateRateController(controller)
            local max = Plot.CalculateTaxMax(rate)
            if ( balance > max ) then
                local taxreturn = balance - max
                controller:SetObjVar("PlotTaxBalance", max)
                controller:SetObjVar("PlotTaxReturn", taxreturn)
                Plot.UpdateDetailLedger(controller, -taxreturn, nil, "Tax Return")
            end
        end
        DebugMessage("[AutoFix] Tax Return Done. TotalMS: "..DateTime.UtcNow:Subtract(before).TotalMilliseconds)
    end
}