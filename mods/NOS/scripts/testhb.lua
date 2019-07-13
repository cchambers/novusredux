
-- house bounds test
local loc = this:GetLoc()
local bounds = Plot.GetHouseBounds(Plot.GetHouseDataFromHouse(this), loc)

for i=1,#bounds do
    local bound = bounds[i]
    local points = bound.Points
    for ii=1,5 do
        local l = Loc(ii<5 and points[ii] or bound.Center)
        Create.AtLoc("plot_marker", l, function(marker)
            l = l - loc
            marker:SetName(string.format("%s (%s,%s) %s", i, math.round(l.X, 3), math.round(l.Z, 3), ii))
            Decay(marker, 30)
        end)
    end
end

CallFunctionDelayed(TimeSpan.FromSeconds(1), function()
    this:DelModule("testhb")
end)