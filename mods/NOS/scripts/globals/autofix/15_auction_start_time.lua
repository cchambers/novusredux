
-- Auctions were spaced by the auction length not the slot interval (oops) this will fix that.
local index = #AutoFixes + 1

AutoFixes[index] = {
    World = function(clusterController)
        local before = DateTime.UtcNow
        local plots = FindObjects(SearchModule("plot_bid_controller"),clusterController)
        DebugMessage("[AutoFix] "..#plots.." plots for sale found.")

        -- first find the earliest start bids
        local soonest = DateTime.UtcNow:Add(TimeSpan.FromDays(365))
        for i=1,#plots do
            local controller = plots[i]
            local startBids = controller:GetObjVar("StartBids")
            if ( startBids < soonest ) then
                soonest = startBids
            end
        end

        -- using the earliest start bids, update the rest accordingly
        for i=1,#plots do
            local controller = plots[i]
            local startBids = controller:GetObjVar("StartBids")
            local diff = startBids:Subtract(soonest)
            if ( diff.TotalSeconds > 0 ) then
                local i = math.floor(diff.TotalDays / 4)
                controller:SetObjVar("StartBids", soonest:Add(TimeSpan.FromHours(i)))
            end
        end

        -- reload all the modules
        ReloadModule("plot_bid_controller")
        ReloadModule("plot_bid_window")

        DebugMessage("[AutoFix] Auction Start Fix Done. TotalMS: "..DateTime.UtcNow:Subtract(before).TotalMilliseconds)
    end
}