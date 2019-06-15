
-- used to add a single weeks worth of taxes to all plots in a region.
-- attach this to yourself.

local total = 0

local controllers = FindObjects(SearchTemplate("plot_controller"))
local controller, rate, balance
for i=1,#controllers do
    controller = controllers[i]
    if ( controller and controller:IsValid() ) then
        rate = Plot.CalculateRateController(controller)
        total = total + rate
        balance = Plot.GetBalance(controller)
        controller:SetObjVar("PlotTaxBalance", balance + rate)
    end
end

this:SystemMessage("Total of "..total.." tax credited to "..#controllers.." plots.")

CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
    this:DelModule("plot_credit_all_single_rate")
end)