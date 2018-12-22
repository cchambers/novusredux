

Plot = {}

--- Will Create a new plot with given dimensions and fire a callback when done
-- @param playerObj
-- @param (Loc)center
-- @param (Function)cb - function(controller)
Plot.New = function(playerObj, center, cb)
    if not( cb ) then cb = function(controller) end end
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.New] playerObj not provided.")
        cb(nil)
        return
    end
    if not( center ) then
        LuaDebugCallStack("[Plot.New] center not provided.")
        cb(nil)
        return
    end
    local userId = playerObj:GetAttachedUserId()
    if not( userId ) then
        LuaDebugCallStack("[Plot.New] Failed to retrieve userId.")
        cb(nil)
        return
    end

    local remainingSlots = Plot.GetRemainingSlots(userId)
    -- zero slots left
	if ( remainingSlots < 1 and not IsGod(playerObj) ) then
        playerObj:SystemMessage("Cannot claim anymore land.", "info")
        cb(nil)
		return
    end

    -- one slot left, but active bid.
    if ( remainingSlots == 1 and GlobalVarReadKey("Bid.Active", userId) ) then
        playerObj:SystemMessage("This account has an active plot bid, cannot claim land until auction is over.", "info")
        cb(nil)
        return
    end
    
    -- keep all plots always alligned (this requires the min size to be even (vs odd))
    center.X = math.floor(center.X)
    center.Z = math.floor(center.Z)
    local size = Loc(ServerSettings.Plot.MinimumSize, 0, ServerSettings.Plot.MinimumSize)

    -- verify the size
    if not( Plot.ValidateSize(playerObj, size) ) then
        cb(nil)
        return
    end

    -- translate the center to the real location
    local loc = Loc(center.X - (size.X * 0.5), 0, center.Z - (size.Z * 0.5))
    local bound = Plot.CalculateBound({loc,size})

    -- verify the plot bound
    if not( Plot.ValidateBound(playerObj, bound, size) ) then
        cb(nil)
        return
    end

    -- handle controller created
    RegisterSingleEventHandler(EventType.CreatedObject, "plot_controller_created", function(success, controller)
        if ( not success or not Plot.SetBound(controller, loc, size) ) then
            if ( controller ) then controller:Destroy() end
            cb(nil)
            return
        end
        -- auto unstuck players inside the plot controller
        MoveMobilesOutOfObject(controller)
        
        controller:SetObjVar("NoReset", true)
        controller:SetObjVar("IsPlotObject", true)

        controller:SetObjVar("PlotName", Plot.DefaultName(playerObj))
        SetItemTooltip(controller)

        -- create the 4 corners
        Plot.CreateMarkers(bound, controller, function(allSuccess)
            if ( allSuccess ) then
                Plot.SetOwner(controller, userId, function(success)
                    if (success) then
                        -- pass the controller
                        cb(controller)
                    else
                        LuaDebugCallStack("[Plot.New] Failed to create one or all plot markers!")
                        Plot.Destroy(controller, function()
                            cb(nil)
                        end)
                    end
                end)
            else
                LuaDebugCallStack("[Plot.New] Failed to create one or all plot markers!")
                Plot.Destroy(controller, function()
                    cb(nil)
                end)
            end
        end)
    end)
    -- create the controller
    CreateObj("plot_controller", Plot.ControllerLoc(bound), "plot_controller_created")
end

--- Determine if a player is the owner of a plot via it's controller.
-- @param playerObj
-- @param controller
Plot.IsOwner = function(playerObj, controller)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.IsOwner] playerObj not provided.")
        return false
    end
    if not( controller ) then
        LuaDebugCallStack("[Plot.IsOwner] controller not provided.")
        return false
    end
    if ( IsGod(playerObj) ) then return true end
    
    local userId = playerObj:GetAttachedUserId()
    if ( userId ) then
        return Plot.GetOwner(controller) == userId
    end
    return false
end

--- Get the plot's owner UserId
-- @param controller
-- @return userId
Plot.GetOwner = function(controller)
    if not( controller ) then
        LuaDebugCallStack("[Plot.GetOwner] controller not provided.")
        return false
    end
    return GlobalVarReadKey("Plot."..controller.Id, "Owner")
end

--- Determine if a player is a co-owner of a house
-- @param playerObj
-- @param house
-- @return boolean
Plot.IsHouseCoOwner = function(playerObj, house)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.IsHouseCoOwner] playerObj not provided.")
        return false
    end
    if not( house ) then
        LuaDebugCallStack("[Plot.IsHouseCoOwner] house not provided.")
        return false
    end
    local coOwners = house:GetObjVar("HouseCoOwners") or {}
    return (coOwners[playerObj] == true)
end

--- Determine if a player is a friend of a house
-- @param playerObj
-- @param house
-- @return boolean
Plot.IsHouseFriend = function(playerObj, house)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.IsHouseFriend] playerObj not provided.")
        return false
    end
    if not( house ) then
        LuaDebugCallStack("[Plot.IsHouseFriend] house not provided.")
        return false
    end
    local friends = house:GetObjVar("HouseFriends") or {}
    return (friends[playerObj] == true)
end

--- Nuke a plot, destroying the plot, all houses, and all items and containers on the plot. Wipes this plot off the face of the world.
-- @param controller
-- @param cb
Plot.Destroy = function(controller, cb)
    if not( cb ) then cb = function() end end
    if not( controller ) then
        LuaDebugCallStack("[Plot.Destroy] controller not provided.")
        return cb(false)
    end

    Plot.RemoveOwner(controller, function()
    
        -- destroy all markers
        Plot.ForeachMarker(controller, function(marker)
            marker:Destroy()
        end)

        -- destroy all lockdowns
        Plot.ForeachLockdown(controller, function(object)
            object:Destroy()
        end)

        -- destroy all houses
        Plot.ForeachHouse(controller, function(house)
            local door = house:GetObjVar("HouseDoor")
            local sign = house:GetObjVar("HouseSign")
            if ( door and door:IsValid() ) then door:Destroy() end
            if ( sign and sign:IsValid() ) then sign:Destroy() end
            house:Destroy()
        end)

        -- remove global and finally the controller
        DelGlobalVar("Plot."..controller.Id, function()
            controller:Destroy()
            cb(true)
        end)

    end)
end

--- Attempt to rename a plot controller
-- @param playerObj
-- @param controller
-- @param newName
-- @return boolean, newName
Plot.TryRename = function(playerObj, controller, newName)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.TryRename] playerObj not provided.")
        return false
    end
    if not( controller ) then
        LuaDebugCallStack("[Plot.TryRename] controller not provided.")
        return false
    end
    
    local nextRename = controller:GetObjVar("NextRename")
    if ( nextRename ~= nil and DateTime.UtcNow < nextRename ) then
        playerObj:SystemMessage("Please wait to rename plot again.", "info")
        return false
    end
    
    newName = StripColorFromString(newName)

    local valid, error = ValidatePlayerInput(newName, 3, 20)
    if not( valid ) then
        playerObj:SystemMessage("Plot name "..error, "info")
        return false
    end

    return true, newName

end

--- Rename a plot, runs TryRename internally
-- @param playerObj
-- @param controller
-- @param newName
Plot.Rename = function(playerObj, controller, newName)
    local success, newName = Plot.TryRename(playerObj, controller, newName)

    if ( success ) then
        -- set when they can rename this plot again.
        controller:SetObjVar("NextRename", DateTime.UtcNow:Add(ServerSettings.Plot.MaxRenameInterval))
        
        controller:SetObjVar("PlotName", newName)
        SetTooltipEntry(controller,"plot_name",newName)
        
        -- set plot name global so we can pay outside region and know what plot we are paying for
        SetGlobalVar("Plot."..controller.Id, function(record)
            record.Name = newName
            return true
        end)
        
        if ( playerObj:HasModule("plot_control_window") ) then
            playerObj:SendMessage("UpdatePlotControlWindow")
        else
            playerObj:SendMessage("StartMobileEffect", "PlotController", target)
        end

        -- tell them about it.
        ClientDialog.Show{
            TargetUser = playerObj,
            DialogId = "RenamePlotConfirm",
            TitleStr = "Plot Name Changed",
            DescStr = "Plot has been renamed to "..newName,
            Button1Str = "Ok",
        }
        
    end

    return success
end

--- Get the default name of a plot
-- @param playerObj
-- @return name
Plot.DefaultName = function(playerObj)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.DefaultName] playerObj not provided.")
        return "A plot of land."
    end
    return "A plot of land. Owner: "..(playerObj:GetCharacterName() or "")
end

--- Set the owner of a plot, replacing old owner. Does not remove user records for old owner if they exist.
-- @param controller
-- @param userId - new owner's userId
-- @param cb
Plot.SetOwner = function(controller, userId, cb)
    if not ( cb ) then cb = function() end end
    if not( controller ) then
        LuaDebugCallStack("[Plot.SetOwner] controller not provided.")
        return cb(false)
    end
    if not( userId ) then
        LuaDebugCallStack("[Plot.SetOwner] userId not provided.")
        return cb(false)
    end
    -- make a mark globally so new characters on same account cannot place a plot
    Plot.UpdateUserPlotRecord(controller, userId, function(success)
        if not( success ) then return cb(false) end
        local regionAddress = ServerSettings.RegionAddress
        SetGlobalVar("Plot."..controller.Id, function(record)
            record.Controller = controller
            record.Owner = userId
            record.Region = regionAddress
            record.Name = nil -- always clear on owner change, so it defaults name
            return true
        end, function(success)
            if ( success ) then return cb(true) end
            -- failed to set plot record, clear user record
            Plot.UpdateUserPlotRecord(controller, userId, function(success)
                cb(false)
            end, true)
        end)
    end)
end

--- Update the userId plot entry list
-- @param controller - plot_controller (mailbox)
-- @param userId
-- @param cb - function(success)
-- @param remove - (bool) if true will remove, instead of add, the entry.
Plot.UpdateUserPlotRecord = function(controller, userId, cb, remove)
    if not ( cb ) then cb = function() end end
    if not( controller ) then
        LuaDebugCallStack("[Plot.UpdateUserPlotRecord] controller not provided.")
        return cb(false)
    end
    if not( userId ) then
        LuaDebugCallStack("[Plot.UpdateUserPlotRecord] userId not provided.")
        return cb(false)
    end

    if ( remove ) then
        -- if there's only one, clean up the entry completely.
        if ( #Plot.GetUserPlots(userId) == 1 ) then
            DelGlobalVar("User.Plots."..userId, cb)
        else
            -- remove global record of plot if it exists
            SetGlobalVar("User.Plots."..userId, function(record)
                for i=1,#record do
                    if ( record[i] and record[i].Id == controller.Id ) then
                        record[i] = nil
                    end
                end
                return true -- always return true, even if not found, so we can rely on the success being the result of the actual write.
            end, cb)
        end
    else
        -- simple add to list
        SetGlobalVar("User.Plots."..userId, function(record)
            record[#record+1] = controller
            return true
        end, cb)
    end

end

--- Remove the owner from a plot, leaving it ownerless and owned by the game. Must be called on the region containing the plot.
-- @param controller
-- @param cb
Plot.RemoveOwner = function(controller, cb)
    if not( cb ) then cb = function() end end
    if not( controller ) then
        LuaDebugCallStack("[Plot.RemoveOwner] controller not provided.")
        return cb()
    end

    local userId = Plot.GetOwner(controller)
    if not( userId ) then return cb() end

    local tempName = "For Sale"
    -- clear the plot entry's owner
    SetGlobalVar("Plot."..controller.Id, function(record)
        record.Owner = nil
        record.Name = tempName
        return true
    end, function()
        controller:SetObjVar("PlotName", tempName)
        SetItemTooltip(controller)
        -- remove old assigned co-owners/friends
        Plot.ForeachHouse(controller, function(house)
            house:DelObjVar("HouseCoOwners")
            house:DelObjVar("HouseFriends")
        end)
        -- remove user records
        Plot.UpdateUserPlotRecord(controller, userId, function(success)
            if not( success ) then
                DebugMessage(string.format("WARNING! User Record for Controller(%s) and UserId(%s) failed to be removed!", controller.Id, userId))
            end
            cb(true)
        end, true)
    end)
end

--- Get the number of remaining plot slots for an account (how many plots they can still create)
-- @param userId
Plot.GetRemainingSlots = function(userId)
    if not( userId ) then
        LuaDebugCallStack("[Plot.GetUserPlots] userId not provided.")
        return false
    end

    -- If we ever allow more than 1 plot per account, this is the place to do it..
    local allowed = 1

    return allowed - #Plot.GetUserPlots(userId)
end

--- Get the global record array of all plot controllers for a player
-- @param userId
-- @return Array of Plot Controllers, empty array if none
Plot.GetPlayerPlots = function(playerObj)
    local userId = playerObj:GetAttachedUserId()
    return Plot.GetUserPlots(userId)
end

--- Get the global record array of all plot controllers for a user
-- @param userId
-- @return Array of Plot Controllers, empty array if none
Plot.GetUserPlots = function(userId)
    if not( userId ) then
        LuaDebugCallStack("[Plot.GetUserPlots] userId not provided.")
        return {}
    end
    return GlobalVarRead("User.Plots."..userId) or {}
end

--- Get the plot markers for a plot controller
-- @param controller
Plot.GetMarkers = function(controller)
    if not( controller ) then
        LuaDebugCallStack("[Plot.GetMarkers] controller not provided.")
        return false
    end
    return controller:GetObjVar("PlotMarkers") or {}
end

--- Self calling function that fires a callback when completed.
-- @param bound
-- @param controller
-- @param cb - Called when all markers are created, first param is a boolean, if true all creations succeeded.
-- @param i (used for the recursion)
Plot.CreateMarkers = function(bound, controller, cb, i)
    if not( i ) then i = 1 end
    if not( cb ) then cb = function(allSuccess) end end
    if ( i < 1 or i > 4 ) then return cb(false) end
    local eventId = string.format("marker_%s_created", i)
    local allSuccess = true
    RegisterSingleEventHandler(EventType.CreatedObject, eventId, function(success, objRef)
        if ( success ) then
            objRef:SetObjVar("NoReset", true)
            objRef:SetObjVar("PlotController", controller)
            objRef:SetObjVar("IsPlotObject", true)
            local markers = Plot.GetMarkers(controller)
            markers[i] = objRef
            controller:SetObjVar("PlotMarkers", markers)
        else
            allSuccess = false
        end
        if ( i == 4 ) then
            -- 4th one created, completed.
            if ( cb ) then cb(allSuccess) end
        else
            Plot.CreateMarkers(bound, controller, cb, i + 1)
        end
    end)
    local pos = Plot.MarkerLoc(bound, i)
    CreateObj("plot_marker", pos, eventId)
    PlayEffectAtLoc("TeleportFromEffect",pos)
end

Plot.ControllerLoc = function(bound)
    return Plot.MarkerLoc(bound, 2, -0.25)
end

Plot.MarkerLoc = function(bound, i, distance)
    return Loc(bound.Points[i].X,0,bound.Points[i].Z):ProjectTowards(Loc(bound.Center.X, 0, bound.Center.Z), distance or 0.2)
end

--- Validate plot size with error to player, this is to prevent long skinny stretches of land grabs and enforce min/max size.
-- @param playerObj
-- @param (Loc)size
-- @return boolean
Plot.ValidateSize = function(playerObj, size)
    local ss = ServerSettings.Plot
    -- enforce the min/max of size
    if ( size.X < ss.MinimumSize or size.Z < ss.MinimumSize ) then
        playerObj:SystemMessage(string.format("Plot too small, Cannot go under %sx%s.", ss.MinimumSize,ss.MinimumSize), "info")
        return false
    end

    -- Upper limit is necessary so we know the exact max range we much search to always get a ploc at a loc.
    if ( size.X > ss.MaximumSize or size.Z > ss.MaximumSize ) then
        playerObj:SystemMessage(string.format("Plot too large, Cannot go over %sx%s.", ss.MaximumSize,ss.MaximumSize), "info")
        return false
    end

    -- if they are the same size we don't need to ensure ratio
    if ( size.X == size.Z ) then return true end

    if ( size.X > size.Z ) then
        if ( size.X / size.Z >= 0.5 ) then
            return true
        end
    else
        if ( size.Z / size.X >= 0.5 ) then
            return true
        end
    end

    playerObj:SystemMessage("Plot cannot be twice as wide as it is long.", "info")
    return false
end

Plot.PointToLoc = function(point)
    return Loc(point.X, 0, point.Z)
end

--- Validate the plot bound with error output to player
-- @param playerObj
-- @param bound AABox2
-- @param size Loc
-- @param ignoreLoc Loc - if a plot bound matches will not be included
Plot.ValidateBound = function(playerObj, bound, size, ignoreLoc)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.ValidateBound] playerObj not provided.")
        return false
    end
    if not( bound ) then
        LuaDebugCallStack("[Plot.ValidateBound] bound not provided.")
        return false
    end

    local housingRegion = GetRegion("Housing")	
	-- if this map has no valid housing region, fail
	if(housingRegion == nil) then
		playerObj:SystemMessage("That land cannot be claimed.", "info")
		return false
    end
    
    -- if any of the four corners are not in a housing area then fail
    --[[ -- don't need this since we are allowing housing anywhere (except further checks down lower) that has a Housing region
	local pointsToCheck = bound.Points
	table.insert(pointsToCheck,bound.Center)
	for i=1,#pointsToCheck do
		if not( housingRegion:Contains(pointsToCheck[i]) ) then 
			playerObj:SystemMessage("That land cannot be claimed.", "info")
			return false
		end
    end]]
    
    -- -- if any of the four corners are not passable then fail
    -- local pointsToCheck = bound.Points
	-- table.insert(pointsToCheck,bound.Center)
	-- for i=1,#pointsToCheck do
	-- 	if not( IsPassable(Loc(pointsToCheck[i])) ) then 
	-- 		playerObj:SystemMessage("Something is blocking one of the four corners.", "info")
	-- 		return false
	-- 	end
	-- end

	local noHousingRegion = GetRegion("NoHousing")
	if ( noHousingRegion ~= nil and noHousingRegion:Intersects(bound) ) then
		playerObj:SystemMessage("That land cannot be claimed.", "info")
		return false
    end

	local waterRegion = GetRegion("Water")
	if(waterRegion ~= nil and waterRegion:Intersects(bound)) then
		playerObj:SystemMessage("Can only claim land, not water.", "info")
		return false
	end

    -- prevent plots from encroaching on other plots
    local nearbyPlots = Plot.GetNearby(Plot.PointToLoc(bound.Center))
    for i=1,#nearbyPlots do
        local plot = nearbyPlots[i]
        local bbounds = Plot.GetBufferedBounds(plot, ignoreLoc)
        for i=1,#bbounds do
            if ( bound:Intersects(bbounds[i]) ) then
                -- now check the unbuffered bounds to give the player better information
                local bounds = Plot.GetBounds(plot, ignoreLoc)
                for ii=1,#bounds do
                    if ( bound:Intersects(bounds[ii]) ) then
                        playerObj:SystemMessage("That land is already claimed.", "info")
                        return false
                    end
                end
                playerObj:SystemMessage("Too close to existing plot.", "info")
                return false
            end
        end
    end

    -- -- expand the bound to find stuff nearby including a 'buffer'
	-- local searcher = PermanentObjSearchRect(Box2(AABox2(bound.TopLeft.X-2,bound.TopLeft.Z-2,bound.Width+4,bound.Height+4)))
    -- local anyPermanent = FindPermanentObjects(searcher)
    -- if ( #anyPermanent > 0 ) then
    --     playerObj:SystemMessage("There is something in the way.", "info")
    --     return false
    -- end
    
    return true
end

--- Return nearby plot controllers
-- @param (Loc)loc
-- @return array of PlotControllers
Plot.GetNearby = function(loc)
    if not( loc ) then
        LuaDebugCallStack("[Plot.GetNearby] loc not provided.")
        return false
    end
    local markers = FindObjects(SearchMulti({SearchRange(loc, ServerSettings.Plot.MaximumSize),SearchTemplate("plot_marker")}),GameObj(0))
    local found = {}
    local controllers = {}
    for i=1,#markers do
        local controller = markers[i]:GetObjVar("PlotController")
        if ( controller and found[controller] == nil ) then
            found[controller] = true
            controllers[#controllers+1] = controller
        end
    end
    return controllers
end

--- Get the cross region info for a plot (used in paying taxes)
-- @param controller
-- @return table
Plot.GetInfo = function(controller)
    if not( controller ) then
        LuaDebugCallStack("[Plot.GetInfo] controller not provided.")
        return {
            Rate = 0,
            Balance = 0,
        }
    end

    return {
        Rate = Plot.CalculateRateController(controller),
        Balance = Plot.GetBalance(controller),
    }
end

--- Safely get the tax balance of a plot controller (must be called on same region containing the plot)
-- @param controller
-- @return balance (number)
Plot.GetBalance = function(controller)
    if not( controller ) then
        LuaDebugCallStack("[Plot.GetBalance] controller not provided.")
        return 0
    end
    if not( controller:IsValid() ) then
        LuaDebugCallStack("[Plot.GetBalance] attempting to get the plot balance of In-Valid Object:", controller)
        return 0
    end
    return controller:GetObjVar("PlotTaxBalance") or 0
end

--- Make a tax payment onto a plot_controller, updating the Tax Balance and the Tax Ledger by amount.
Plot.TaxPayment = function(controller, playerObj, amount)
    if not( controller ) then
        LuaDebugCallStack("[Plot.TaxPayment] controller not provided.")
        return false
    end
    if not( controller:IsValid() ) then
        LuaDebugCallStack("[Plot.TaxPayment] attempting to make a tax payment on an invalid controller:", controller)
        return false
    end
    amount = math.floor(amount or 0)
    if ( amount < 1 ) then return false end

    -- add onto the tax
    local current = controller:GetObjVar("PlotTaxBalance") or 0
    controller:SetObjVar("PlotTaxBalance", current + amount)

    -- add onto the ledger
    if not( playerObj ) then playerObj = GameObj(0) end
    local ledger = controller:GetObjVar("PlotTaxLedger") or {}
    if not( ledger[playerObj] ) then ledger[playerObj] = 0 end
    ledger[playerObj] = ledger[playerObj] + amount
    controller:SetObjVar("PlotTaxLedger", ledger)

    return true
end

--- Will tax the plot, does not check if the plot as been taxed recently!
-- @param controller
Plot.Tax = function(controller)
    if not( controller ) then
        LuaDebugCallStack("[Plot.Tax] controller not provided.")
        return
    end
    if not( controller:IsValid() ) then
        LuaDebugCallStack("[Plot.Tax] invalid controller provided:", controller)
        return
    end

    local rate = Plot.CalculateRate(controller:GetObjVar("PlotBounds"))
    local current = Plot.GetBalance(controller)
    local remaining = current - rate
    controller:SetObjVar("PlotTaxBalance", remaining)
    DebugMessage(string.format("[TAX] PlotController(%s) has had %s removed. Remaining Balance: %s", controller.Id, rate, remaining))
end

--- Get the string describing how long until tax time
Plot.GetTaxDueString = function()
    local now = GetTimeTable()
    if ( IsTime(ServerSettings.Plot.Tax.TaxTime, now, 300) ) then
        return "Taxing..."
    else
        local seconds = TimeUntil(ServerSettings.Plot.Tax.TaxTime, now)
        if ( seconds == 0 ) then return "Taxing.." end -- should never get here..
        return TimeSpanToWords(TimeSpan.FromSeconds(seconds))
    end
end

--- Will tax all plots via the schedule, must be run from MasterController
-- @param clusterController - Master Cluster Controller
-- @param cb - optional callback that fires when done
-- @param force boolean (optional) - force taxing, regardless of server timing, careful with this...
Plot.TaxAll = function(clusterController, cb, force)
    if not( cb ) then cb = function() end end
    if not( ServerSettings.Plot.Tax.Enabled ) then return cb() end

    local now
    if ( force ~= true ) then
        now = GetTimeTable()
        -- only attempt to tax on time
        if not( IsTime(ServerSettings.Plot.Tax.TaxTime, now, ServerSettings.Plot.Tax.TaxTimeResolution) ) then return cb() end
        -- already taxed this interval
        local lastTax = GlobalVarReadKey("Taxes", "LastTax")
        if ( lastTax ~= nil and IsTime(lastTax, now, ServerSettings.Plot.Tax.TaxTimeResolution) ) then return cb() end
    end

    -- tell all cluster controllers accross all regions to tax all plots.
    for regionAddress,data in pairs(GetClusterRegions()) do
        if ( regionAddress == ServerSettings.RegionAddress ) then
            clusterController:SendMessage("DoPlotTax")
        else
            if ( IsClusterRegionOnline(regionAddress) ) then
                MessageRemoteClusterController(regionAddress, "DoPlotTax")
            end
        end
    end
    
    if ( force == true ) then return cb(true) end

    -- record the last time we did this
    SetGlobalVar("Taxes", function(record)
        record.LastTax = now
        return true
    end, cb)
end

--- Will put a plot up for sale, removing current owner and starting the auction. WARNING! Does not check before doing!
-- @param controller
-- @param index - the index of all plots for sale, this is used to time out aution starts
-- @param cb - function that will fire when done
Plot.Sale = function(controller, index, cb)
    if not( cb ) then cb = function() end end
    if not( controller ) then
        LuaDebugCallStack("[Plot.Sale] controller not provided.")
        return cb()
    end
    if not( index ) then
        LuaDebugCallStack("[Plot.Sale] index not provided.")
        return cb()
    end
    if not( controller:IsValid() ) then
        LuaDebugCallStack("[Plot.Sale] invalid controller provided.")
        return cb()
    end

    -- already sold this iteration (double check)
    if ( controller:HasModule("plot_bid_controller") ) then
        DebugMessage("WARNING! Attempting to sale a plot that is already up for sale!")
        return cb()
    end

    -- Put up for sale

    -- remove owner
    Plot.RemoveOwner(controller, function()
        -- unlock all doors
        Plot.ForeachHouse(controller, function(house)
            local door = house:GetObjVar("HouseDoor")
            if ( door ) then Door.Unlock(door, true) end
        end)

        -- set time auction will start
        local startTime = os.time(FixDate(ServerSettings.Plot.Auction.StartTime))
        index = (index % ServerSettings.Plot.Auction.Slots.Max ) - 1
        if ( index > 0 ) then
            startTime = startTime + (ServerSettings.Plot.Auction.Length * index)
        end

        -- add sign
        local loc = controller:GetLoc()
        loc.Y = loc.Y + 3
        Create.AtLoc("plot_forsale_sign", loc, function(sign)
            if ( sign ) then
                controller:SetObjVar("BidWindow", sign)
                sign:SetObjVar("BidController", controller)
                sign:AddModule("plot_bid_window")
                SetItemTooltip(sign)

                controller:SetObjVar("StartBids", startTime)
                -- add bid controller
                controller:AddModule("plot_bid_controller")
            end
            cb()
        end, true)
    end)
end

--- Will check all negative plots, see if they are still negative, and if so, remove the owner and put up for sale.
-- @param clusterController - Master Cluster Controller
-- @param cb - optional callback that fires when done
-- @param force boolean (optional) - force the check, regardless of server timing
Plot.SaleAll = function(clusterController, cb, force)
    if not( cb ) then cb = function() end end
    if not( ServerSettings.Plot.Tax.Enabled ) then return cb() end
    
    local now
    if ( force ~= true ) then
        now = GetTimeTable()
        -- only attempt to sale on sale time
        if not( IsTime(ServerSettings.Plot.Tax.SaleTime, now, ServerSettings.Plot.Tax.SaleTimeResolution) ) then return cb() end
        -- already done sale this interval
        local lastSale = GlobalVarReadKey("Taxes", "LastSale")
        if ( lastSale ~= nil and IsTime(lastSale, now, ServerSettings.Plot.Tax.SaleTimeResolution) ) then return cb() end
    end
    
    -- tell all cluster controllers accross all regions to sale all plots.
    for regionAddress,data in pairs(GetClusterRegions()) do
        if ( regionAddress == ServerSettings.RegionAddress ) then
            clusterController:SendMessage("DoPlotSale")
        else
            if ( IsClusterRegionOnline(regionAddress) ) then
                MessageRemoteClusterController(regionAddress, "DoPlotSale")
            end
        end
    end

    if ( force == true ) then return cb(true) end

    -- record the last time we did this
    SetGlobalVar("Taxes", function(record)
        record.LastSale = now
        return true
    end, cb)
end

--- Get the minimum price a plot can sell for when auctioning plots
Plot.CalculateStartingBid = function(controller)
    -- go with half a year of tax as starting bid
    return Plot.CalculateRateController(controller) * 26
end

--- Each account can only have a single bid active at anytime
-- @param playerObj
-- @param cb
Plot.ClearActiveBid = function(playerObj, userId, cb)
    if not( cb ) then cb = function() end end
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.ClearActiveBid] playerObj not provided.")
        return cb()
    end
    if not( userId ) then
        userId = playerObj:GetAttachedUserId()
    end

    if ( GlobalVarReadKey("Bid.Active", userId) ~= nil ) then
        SetGlobalVar("Bid.Active", function(record)
            record[userId] = nil
            return true
        end, cb)
    else
        cb()
    end
end

--- Check if a player has a bid for a house that's been sold and refund if they lost ( minus bid fee )
-- @param playerObj
-- @param cb - callback when check is complete
Plot.CheckBidRefund = function(playerObj, cb)
    if not( cb ) then cb = function() end end
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.CheckBidRefund] playerObj not provided.")
        return cb()
    end

    -- invalid player stop here
    if not( playerObj:IsValid() ) then return cb() end

    -- nothing to refund
    if not( playerObj:HasObjVar("BidData") ) then return cb() end

    local data = playerObj:GetObjVar("BidData")
    -- seriously, nothing to refund..
    if ( data == nil ) then return cb() end

    -- increase readability
    local amount, controller, endsAt = data[1],data[2],data[3]
    
    if ( GetNow() < endsAt ) then return cb() end
    -- according to our player bid data, the auction is over

    local plotData = GlobalVarRead("Plot."..controller.Id) -- have to read entire table to be sure plot wasn't destroyed
    -- if the plot data exists but the plot doesn't have an owner, it's not been sold off yet.
    if ( plotData ~= nil and plotData.Owner == nil ) then return cb() end

    -- if plot data exists and we are the owner of the plot, we won.
    local userId = playerObj:GetAttachedUserId()
    if ( plotData ~= nil and plotData.Owner == userId ) then
        -- we won!
        playerObj:SystemMessage("You won the plot auction for "..ValueToAmountStr(amount), "event")
        playerObj:DelObjVar("BidData")
        Plot.ClearActiveBid(playerObj, userId, cb)
        return
    end

    -- we didn't win :-( (or plot was destroyed)
    local refund = math.floor(amount - ( amount * ServerSettings.Plot.Auction.BidFee ))
    local bank = playerObj:GetEquippedObject("Bank")
    if ( bank == nil ) then
        DebugMessage("Cannot create bid refunds, player does not have a bank! PlayerId:"..playerObj.Id)
        return cb()
    end

    -- give the refund
    Create.Stack.InContainer("coin_purse", bank, refund, nil, function(coins)
        if ( coins and coins:GetObjVar("StackCount") == refund ) then
            -- refund was successful
            playerObj:DelObjVar("BidData")
            playerObj:SystemMessage("Plot auction lost, "..ValueToAmountStr(amount).." has been returned to your bank.", "event")
            Plot.ClearActiveBid(playerObj, userId, cb)
        else
            DebugMessage("Refund Failed for playerId: "..playerObj.Id)
            cb()
        end
    end)
end

--- Will finialize the sale, setting winning bidder as owner or deleting plot if no winners
-- @param controller
-- @param cb - callback function when complete
Plot.FinalizeSale = function(controller, bidData, cb)
    if not( cb ) then cb = function() end end
    if not( controller ) then
        LuaDebugCallStack("[Plot.FinalizeSale] controller not provided.")
        return cb()
    end

    if not( bidData ) then bidData = controller:GetObjVar("BidControllerData") end
    local max = 0
    local user = nil
    local winner = nil

    -- get the max bid
    for userId,data in pairs(bidData.Bids) do
        if ( data[1] > max ) then
            max = data[1]
            user = data[2]
            winner = userId
        end
    end

    -- if a winner
    if ( winner ) then
        -- give plot to them, and zero out balance
        Plot.SetOwner(controller, winner, function(success)
            if ( success ) then
                -- rename to default
                controller:SetObjVar("PlotName", Plot.DefaultName(user))
                SetItemTooltip(controller)
            end
           cb(success)
        end, true)
    else
        -- no one to claim the win, bye bye plot
        Plot.Destroy(controller, cb)
    end
end

--- Will calculate and apply the true lock down count for the provided plot and houses on the plot.
-- @param controller
Plot.CalculateTrueLockCount = function(controller)
    if not( controller ) then
        LuaDebugCallStack("[Plot.CalculateLockCount] controller not provided.")
        return
    end

    local plotLockdowns = 0
    local houses = {}
    local anyhouse = false

    Plot.ForeachLockdown(controller, function(item)
        if ( item and item:IsValid() ) then
            local house = Plot.GetHouseAt(controller, item:GetLoc(), false, true) -- checking roof bounds
            if ( house and house:IsValid() ) then
                anyhouse = true
                if not( houses[house] ) then houses[house] = {0,0} end
                if ( item:IsContainer() ) then
                    houses[house][2] = houses[house][2] + 1
                else
                    houses[house][1] = houses[house][1] + 1
                end
                if not( item:HasObjVar("PlotHouse") ) then
                    item:SetObjVar("PlotHouse", house)
                end
            else
                plotLockdowns = plotLockdowns + 1
                if ( item:HasObjVar("PlotHouse") ) then
                    item:DelObjVar("PlotHouse")
                end
            end
        end
    end)

    if ( plotLockdowns < 0 ) then
        controller:DelObjVar("LockCount")
    else
        controller:SetObjVar("LockCount", plotLockdowns)
    end
    if ( anyhouse ) then
        for house,data in pairs(houses) do
            if ( data[1] < 1 ) then
                house:DelObjVar("LockCount")
            else
                house:SetObjVar("LockCount", data[1])
            end
            if ( data[2] < 1 ) then
                house:DelObjVar("ContainerCount")
            else
                house:SetObjVar("ContainerCount", data[2])
            end
        end
    else
        -- no items were found in any houses, if there are actual houses on plot, empty their counts.
        Plot.ForeachHouse(controller, function(house)
            house:DelObjVar("LockCount")
            house:DelObjVar("ContainerCount")
        end)
    end
end

--- Calculate the tax rate for a plot given its boundsData
-- @param (array)boundsData
-- @return (number) rate
Plot.CalculateRate = function(boundsData)
    if not( boundsData ) then return 100 end
    local rate = 0
    for i=1,#boundsData do
        local size = boundsData[i][2]
        rate = rate + math.pow(size.X * size.Z, ServerSettings.Plot.Tax.RateCoefficient)
    end
    -- round to nearest silver
    rate = math.floor( math.ceil(rate) / 100 ) * 100
    return rate
end

Plot.CalculateRateController = function(controller)
    if not( controller ) then
        LuaDebugCallStack("[Plot.CalculateRateController] controller not provided.")
        return 100
    end
    
    local bounds = controller:GetObjVar("PlotBounds")
    return Plot.CalculateRate(bounds)
end

--- Given the the bounds of a plot, determine how many lockdowns are permitted.
-- @param (array)boundsData
-- @return (number) limit
Plot.CalculateLockdownLimit = function(boundsData)
    local limit = 0
    for i=1,#boundsData do
        local size = boundsData[i][2]
        -- .5 objects per sq unit
        limit = limit + math.ceil(size.X * size.Z * 0.5)
    end
    return limit
end

--- Calculate and return the calculated bound from boundData
-- @param ({Loc,Loc}) boundData - Array of Loc and Size {Loc(),Loc()}
-- @return (AABox2) bound
Plot.CalculateBound = function(boundData)
    if not( boundData ) then
        LuaDebugCallStack("[Plot.CalculateBound] boundData not provided.")
        return false
    end
    if not( boundData[1] ) then
        LuaDebugCallStack("[Plot.CalculateBound] loc not provided.")
        return false
    end
    if not( boundData[2] ) then
        LuaDebugCallStack("[Plot.CalculateBound] size not provided.")
        return false
    end
    return AABox2(boundData[1].X, boundData[1].Z, boundData[2].X, boundData[2].Z)
end

--- Calculate bound with a space of buffer, used to prevent real plots from being blocking and to enforce a bit of space always. Use the buffered bounds when checking for trees/camps/etc
-- @param (Loc,Loc) boundData - Array of Loc and Size {Loc(),Loc()}
-- @return (AABox2) bound
Plot.CalculateBufferBound = function(boundData)
    if not( boundData ) then
        LuaDebugCallStack("[Plot.CalculateBufferBound] boundData not provided.")
        return false
    end
    if not( boundData[1] ) then
        LuaDebugCallStack("[Plot.CalculateBufferBound] loc not provided.")
        return false
    end
    if not( boundData[2] ) then
        LuaDebugCallStack("[Plot.CalculateBufferBound] size not provided.")
        return false
    end
    return AABox2(boundData[1].X-5, boundData[1].Z-5, boundData[2].X+10, boundData[2].Z+10)
end

--- Get the AABox2 bounds of a plot
-- @param controller
-- @param (boolean)buffered (optional) - If true will return the buffered bound instead of real bound
-- @param (Loc)ignoreLoc (optional) - Loc that if a plot bound matches will not be included
-- @return AABox2 array of bounds
Plot.GetBounds = function(controller, buffered, ignoreLoc)
    if not( controller ) then
        LuaDebugCallStack("[Plot.GetBounds] controller not provided.")
        return false
    end

    local plotBounds = controller:GetObjVar("PlotBounds") or {}
    local bounds = {}
    for i=1,#plotBounds do
        if ( ignoreLoc == nil or not ignoreLoc:Equals(plotBounds[i][1]) ) then
            if ( buffered ) then
                bounds[i] = Plot.CalculateBufferBound(plotBounds[i])
            else
                bounds[i] = Plot.CalculateBound(plotBounds[i])
            end
        end
    end

    return bounds
end

--- Get the AABox2 buffered bounds of a plot, this is to ensure all plots have space between them
-- @param controller
-- @param (Loc)ignoreLoc (optional) - Loc that if a plot bound matches will not be included
-- @return AABox2 array of bounds, including buffered space
Plot.GetBufferedBounds = function(controller, ignoreLoc)
    return Plot.GetBounds(controller, true, ignoreLoc)
end

--- Plot adjust dry run
-- @param playerObj
-- @param controller - Plot Controller
-- @param amount - Lua Array {north,south,east,west} {1,0,0,0} for example
-- @param (number)i (optional) - bounds index, defaults to 1
-- @return bool, newBound, newLoc, newSize
Plot.TryAdjust = function(playerObj, controller, amount, i)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.TryAdjust] playerObj not provided.")
        return false
    end
    if not( controller ) then
        LuaDebugCallStack("[Plot.TryAdjust] controller not provided.")
        return false
    end
    if not( amount ) then
        LuaDebugCallStack("[Plot.TryAdjust] amount not provided.")
        return false
    end
    if not( Plot.IsOwner(playerObj, controller) ) then
        playerObj:SystemMessage("Only plot owners can adjust the size.", "info")
        return false
    end
    if not( i ) then i = 1 end
    local bounds = controller:GetObjVar("PlotBounds")
    if ( not bounds or not bounds[i] ) then return false end

    local north = amount[1] or 0
    local south = amount[2] or 0
    local east = amount[3] or 0
    local west = amount[4] or 0

    local size = bounds[i][2]
    local newSize = Loc(size.X+east+west, 0, size.Z+north+south)
    if not( Plot.ValidateSize(playerObj, newSize) ) then return false end

    local loc = bounds[i][1]
    local newLoc = Loc(loc.X-west, 0, loc.Z-south)

    local newBound = Plot.CalculateBound({newLoc,newSize})
    if not( Plot.ValidateBound(playerObj, newBound, newSize, loc) ) then return false end

    -- deny if there are any locked down items on the area we are giving up (if we are giving up land)
    if ( newSize.X * newSize.Z < size.X * size.Z ) then
        -- prevent if all objects are not in new size
        local o = nil
        Plot.ForeachLockdown(controller, function(object)
            if not( newBound:Contains(object:GetLoc()) ) then
                o = object
                return true -- break loop
            end
        end)
        if ( o ) then
            playerObj:SystemMessage("Cannot release land containing locked down objects.", "info")
            return false
        end

        local h = nil
        -- make sure all houses are still inside bounds as well
        Plot.ForeachHouseBound(controller, function(house, houseBounds, index)
            if ( not newBound:Contains(houseBounds[index]) ) then
                h = house
                return true -- break loop
            end
        end)
        if ( h ) then
            playerObj:SystemMessage("Cannot release land a house is on.", "info")
            return false
        end
    end

    return true, newBound, newLoc, newSize

end

Plot.IsOwnerForLoc = function(playerObj, loc)
    local controller = Plot.GetAtLoc(loc)
    return ( controller and Plot.IsOwner(playerObj, controller) ), controller
end

Plot.IsObjectInside = function(controller, object)
    return true -- TODO is object inside a house?
end

--- Adjust a plot by amount
-- @param playerObj
-- @param controller
-- @param amount - Lua Array {north,south,east,west} {1,0,0,0} for example
-- @param (number)i (optional) - bounds index, defaults to 1
Plot.Adjust = function(playerObj, controller, amount, i)
    local allow, newBound, newLoc, newSize = Plot.TryAdjust(playerObj, controller, amount, i)

    if ( allow ) then
        if ( Plot.SetBound(controller, newLoc, newSize, i) ) then
            -- move the markers
            local markers = Plot.GetMarkers(controller)
            for i=1,#markers do
                local marker = markers[i]
                if ( marker and marker:IsValid() ) then
                    marker:SetWorldPosition(Plot.MarkerLoc(newBound, i))
                end
            end
            local controllerLoc = Plot.ControllerLoc(newBound)
            controller:SetWorldPosition(controllerLoc)
            -- auto unstuck players inside the plot controller
            MoveMobilesOutOfObject(controller, controllerLoc)
        end
    end

end

--- Set/Update the variables on Plot Controller, this should be executed each time the size or location of a plot is changed.
-- @param (GameObj)controller - Plot Controller
-- @param (Loc)loc
-- @param (Loc)size
-- @param (number)i (optional) - bounds index, defaults to 1
-- @return none
Plot.SetBound = function(controller, loc, size, i)
    if not( controller ) then
        LuaDebugCallStack("[Plot.Update] controller not provided.")
        return false
    end
    if not( loc ) then
        LuaDebugCallStack("[Plot.Update] loc not provided.")
        return false
    end
    if not( size ) then
        LuaDebugCallStack("[Plot.Update] size not provided.")
        return false
    end
    if not( i ) then i = 1 end
    local bounds = controller:GetObjVar("PlotBounds") or {}
    bounds[i] = {loc,size}
    controller:SetObjVar("PlotBounds", bounds)
    controller:SetObjVar("LockLimit", Plot.CalculateLockdownLimit(bounds))
    return true
end

--- Determine if a plot by controller contains a location
-- @param controller - Plot Controller gameObj
-- @param loc
-- @param buffered - search the buffered bounds
-- @return boolean, bounds
Plot.ContainsLoc = function(controller, loc, buffered)
    if not( controller ) then
        LuaDebugCallStack("[Plot.ContainsLoc] controller not provided.")
        return false
    end
    if not( loc ) then
        LuaDebugCallStack("[Plot.ContainsLoc] loc not provided.")
        return false
    end
    local bounds = Plot.GetBounds(controller, buffered)
    for i=1,#bounds do
        if ( bounds[i]:Contains(loc) ) then return true, bounds, i end
    end
    return false, bounds
end

--- Determine is a houseObj has a loc in it
-- @param house - Plot House
-- @param (Loc)loc
-- @param buffered - Optionally check buffered bounds
-- @param roofBounds - Optionally check roof bounds vs object bounds.
Plot.HouseContainsLoc = function(house, loc, buffered, roofBounds)
    if not( house ) then
        LuaDebugCallStack("[Plot.HouseContainsLoc] house not provided.")
        return false
    end
    if not( loc ) then
        LuaDebugCallStack("[Plot.HouseContainsLoc] loc not provided.")
        return false
    end

    local houseData = Plot.GetHouseDataFromHouse(house)
    if ( houseData ) then
        local bounds = Plot.GetHouseBounds(houseData, house:GetLoc(), buffered, roofBounds)
        for i=1,#bounds do
            if ( bounds[i]:Contains(loc) ) then
                return true, bounds
            end
        end
    end
    return false
end

--- Given a loc will return the plot (if any) for that location.
-- @param (Loc)loc
-- @return Plot Controller or nil, calculated bounds
Plot.GetAtLoc = function(loc)
    if not( loc ) then
        LuaDebugCallStack("[Plot.GetAtLoc] loc not provided.")
        return nil, {}
    end

    local nearbyPlots = Plot.GetNearby(loc)
    for i=1,#nearbyPlots do
        local contains, bounds, index = Plot.ContainsLoc(nearbyPlots[i], loc)
        if ( contains ) then
            return nearbyPlots[i], bounds, index
        end
    end

    return nil, {}
end

-- safely determine if a mobile has control of the plot
-- @param playerObj
-- @param controller - Plot Controller obj
-- @return boolean
Plot.HasControl = function(playerObj, controller)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.HasControl] playerObj not provided.")
        return false
    end
    if not( controller ) then
        LuaDebugCallStack("[Plot.HasControl] controller not provided.")
        return false
    end
    local owner = playerObj:GetObjVar("controller")
    if ( owner ) then playerObj = owner end
    if not( IsPlayerCharacter(playerObj) ) then return false end
    return Plot.IsOwner(playerObj, controller)
end

Plot.HasHouseControl = function(playerObj, controller, house)
    return (Plot.IsOwner(playerObj, controller) or (house and Plot.IsHouseCoOwner(playerObj, house)))
end

--- Determine if a player can control an object in a house. (open locked doors or secure friend chests) Name is a little misleading, but this does not determine lockdown/release commands and similar.
-- @param playerObj
-- @param object
-- @param allowFriends - (optional) boolean, if true will allow this function to be successful for friends of a house
-- @return boolean
Plot.HasObjectControl = function(playerObj, object, allowFriends)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.HasObjectControl] playerObj not provided.")
        return false
    end
    if not( object ) then
        LuaDebugCallStack("[Plot.HasObjectControl] object object not provided.")
        return false
    end

    local house = object:GetObjVar("PlotHouse")
    if ( house ) then
        if ( allowFriends and Plot.IsHouseFriend(playerObj, house) ) then
            -- early success if allows friends and the player is a house friend 
            return true
        end
        local plot = house:GetObjVar("PlotController")
        return ( plot and Plot.HasHouseControl(playerObj, plot, house) )
    end

    return false
end

--- Determine if a plot has any houses, optionally only check for houses owned/co-owned by the provided playerObj
-- @param (HouseController)controller
-- @param playerObj - optional, if provided will only check houses owned by player
-- @return boolean
Plot.HasHouse = function(controller, playerObj)
    if not( controller ) then
        LuaDebugCallStack("[Plot.HasHouse] controller not provided.")
        return false
    end

    local found = false
    Plot.ForeachHouse(controller, function(house)
        if ( playerObj == nil or Plot.IsHouseCoOwner(playerObj, house) ) then
            found = true
            return true -- break loop
        end
    end)
    return found
end

Plot.CanTeleportToLoc = function(playerObj, loc, controller)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.CanTeleportToLoc] playerObj not provided.")
        return false
    end

    if not( controller ) then
        controller = Plot.GetAtLoc(loc)
    end

    -- no plot here, so sure.
    if ( controller == nil ) then
        return true
    end

    -- reassign to owner
    local owner = playerObj:GetObjVar("controller")
    if ( owner ) then playerObj = owner end

    -- if playerObj is not actually a playerObj, then no.
    if not( IsPlayerCharacter(playerObj) ) then return false end

    -- plot owners always have control
    if ( Plot.IsOwner(playerObj, controller) ) then return true end

    -- loc is in a house, only co-owners can teleport into there
    local house = Plot.GetHouseAt(controller, loc)
    if ( house and not Plot.IsHouseCoOwner(playerObj, house) ) then return false end

    -- loc not in a house, if they have and house, they can tele inside the plot
    return Plot.HasHouse(controller, playerObj)
end

--- Get the plot controller this object is in, if any
-- @param object
-- @return plot controller
Plot.GetForObject = function(object)
    if not( object ) then
        LuaDebugCallStack("[Plot.GetAtLoc] loc not provided.")
        return nil, {}
    end
    return Plot.GetAtLoc((object:TopmostContainer() or object):GetLoc())
end

--- Kick a mobile out of a plot, putting them near the mailbox
-- @param controller - plot controller to kick them out of
-- @param mobileObj to kick
Plot.KickMobile = function(controller, mobileObj)
    if not( controller ) then
        LuaDebugCallStack("[Plot.KickMobile] controller not provided.")
        return
    end
    if not( mobileObj ) then
        LuaDebugCallStack("[Plot.KickMobile] mobileObj not provided.")
        return
    end

    local markers = Plot.GetMarkers(controller)
    if ( markers[2] ) then
        local loc = markers[2]:GetLoc()
        loc.X = loc.X + 1.5
        loc.Z = loc.Z - 1.5
        mobileObj:SetWorldPosition(loc)
    end 
end

Plot.TryTransferOwnership = function(playerObj, controller, newOwner)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.TryTransferOwnership] playerObj not provided.")
        return
    end
    if not( controller ) then
        LuaDebugCallStack("[Plot.TryTransferOwnership] controller not provided.")
        return
    end
    if not( newOwner ) then
        LuaDebugCallStack("[Plot.TryTransferOwnership] newOwner not provided.")
        return
    end

    local oldUserId = Plot.GetOwner(controller)
    if ( oldUserId ~= playerObj:GetAttachedUserId() and not IsGod(playerObj) ) then
        return false, "NotYours"
    end

    local newUserId = newOwner:GetAttachedUserId()
    -- validate new owner can take a house
    if ( Plot.GetRemainingSlots(newUserId) < 1 and not IsGod(playerObj) ) then
        return false, "AlreadyOwner"
    end

    return true, oldUserId, newUserId
end

Plot.TransferOwnership = function(playerObj, controller, newOwner, cb)
    local allow, oldUserId, newUserId = Plot.TryTransferOwnership(playerObj, controller, newOwner)

    if ( allow ) then
        -- remove user entry for old owner
        Plot.UpdateUserPlotRecord(controller, oldUserId, function(success)
            if ( success ) then
                -- set the new owner
                Plot.SetOwner(controller, newUserId, function(success)
                    if ( success ) then
                        playerObj:SystemMessage("Plot Transfered to "..newOwner:GetName(), "event")
                        newOwner:SystemMessage(playerObj:GetName() .. " has transferred ownership of this plot to you.", "event")
                        controller:SetObjVar("PlotName", Plot.DefaultName(newOwner))
                        playerObj:SendMessage("UpdatePlotControlWindow")
                        SetItemTooltip(controller)
                        cb(true)
                    else
                        -- failed to set the owner, put old owner's user entry back.
                        Plot.UpdateUserPlotRecord(controller, oldUserId, function(success)
                            cb(false)
                        end)
                        playerObj:SystemMessage("Internal Server Error.", "info")
                    end
                end)
            else
                -- failed to remove old owner's entry.
                playerObj:SystemMessage("Internal Server Error.", "info")
                cb(false)
            end
        end, true)
    else
        if ( oldUserId == "NotYours" ) then
            playerObj:SystemMessage("That is not yours to transfer.", "info")
        elseif ( oldUserId == "AlreadyOwner" ) then
            playerObj:SystemMessage("That person cannot own another plot.", "info")
            --newOwner:SystemMessage("You cannot own another plot.","info")
        end
        cb(false)
    end
end

---- Decoration

Plot.RemainingLockdowns = function(controller)
    return controller:GetObjVar("LockLimit") - (controller:GetObjVar("LockCount") or 0)
end

Plot.AlterLockCountBy = function(controller, amount)
    local lockCount = ( controller:GetObjVar("LockCount") or 0 ) + amount
	if ( lockCount < 1 ) then
		controller:DelObjVar("LockCount")
	else
		controller:SetObjVar("LockCount", lockCount)
	end
end

Plot.RemainingContainers = function(controller)
    return controller:GetObjVar("ContainerLimit") - (controller:GetObjVar("ContainerCount") or 0)
end

Plot.AlterContainerCountBy = function(controller, amount)
    local lockCount = ( controller:GetObjVar("ContainerCount") or 0 ) + amount
	if ( lockCount < 1 ) then
		controller:DelObjVar("ContainerCount")
	else
		controller:SetObjVar("ContainerCount", lockCount)
	end
end

--- Dry run to lockdown an item
-- @param playerObj
-- @param amount
-- @param controller
-- @return boolean
Plot.TryLockdown = function(playerObj, controller, object)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.TryLockdown] playerObj not provided.")
        return false
    end
    if not( controller ) then
        LuaDebugCallStack("[Plot.TryLockdown] controller not provided.")
        return false
    end
    if not( object ) then
        LuaDebugCallStack("[Plot.TryLockdown] object not provided.")
        return false
    end
    if ( object:IsPermanent() or object:TopmostContainer() ~= nil ) then return false end

	if ( (object:GetSharedObjectProperty("Weight") or -1) == -1 ) then
        playerObj:SystemMessage("Cannot lock that down.", "info")
		return false
    elseif( object:IsMobile() ) then
        playerObj:SystemMessage("Cannot lock down humans or creatures.", "info")
        return false
    elseif( object:HasObjVar("IsPlotObject") ) then
        playerObj:SystemMessage("That is automatically locked down.", "info")
        return false
    elseif( object:IsInContainer() ) then
        playerObj:SystemMessage("Cannot lock down items inside containers.", "info")
        return false
    elseif (object:HasObjVar("DisableLockDown")) then
        playerObj:SystemMessage("Cannot lock that down.", "info")
        return false
    elseif( object:HasModule("hireling_merchant_sale_item")) then
        playerObj:SystemMessage("[$1839]", "info")
        return false
    elseif(IsLockedDown(object)) then
        playerObj:SystemMessage("That item is already locked down.", "info")
        return false
    end

    -- ensure close enough
    local loc = object:GetLoc()
    if ( playerObj:GetLoc():Distance(loc) > 40 ) then
        playerObj:SystemMessage("Too far away.", "info")
        return false
    end
    
    local house = Plot.GetHouseAt(controller, loc, false, true) -- checking roofbounds
    local isContainer = object:IsContainer()

    if ( isContainer and object:HasObjVar("locked") ) then
        playerObj:SystemMessage("Cannot lockdown containers that are locked.", "info")
        return false
    end

    if ( Plot.AtLimit(playerObj, controller, house, isContainer) ) then return false end

    -- ensure player has permission to lock down
    if ( Plot.IsOwner(playerObj, controller) ) then
        -- owners are only stopped here by it not being in the plot
        if not( Plot.ContainsLoc(controller, loc) ) then
            playerObj:SystemMessage("That is not inside your plot.", "info")
            return false
        end
    else
        -- otherwise if there is a house, they have to be co owner to that house
        if ( house == nil or not Plot.IsHouseCoOwner(playerObj, house) ) then
            playerObj:SystemMessage("That is not inside your house.", "info")
            return false
        end
    end

    return true, controller, house, isContainer
end

--- Get if plot or house is at limit for lockdowns / containers.
-- @param playerObj
-- @param controller - Plot Controller
-- @param house - Plot House
-- @param (boolean)isContainer - Check container limits instead? Only applies to houses.
-- @return (boolean) true if at limit
Plot.AtLimit = function(playerObj, controller, house, isContainer)
    if ( house ) then
        if ( house:HasModule("house_foundation") ) then
            playerObj:SystemMessage("Cannot lockdown on a house foundation.", "info")
            return true
        end
        if ( isContainer ) then
            if ( Plot.RemainingContainers(house) < 1 ) then
                playerObj:SystemMessage("House cannot hold anymore containers.", "info")
                return true
            end
        else
            if ( Plot.RemainingLockdowns(house) < 1 ) then
                playerObj:SystemMessage("House cannot hold anymore locked down objects.", "info")
                return true
            end
        end
    else
        if ( Plot.RemainingLockdowns(house or controller) < 1 ) then
            playerObj:SystemMessage("Plot cannot hold anymore locked down objects.", "info")
            return true
        end
    end
    return false
end

--- Lock down an object on a plot, will verify it can be locked down before doing the lockdown
-- @param playerObj
-- @param controller - Plot Controller
-- @param object
-- @return (boolean)success
Plot.Lockdown = function(playerObj, controller, object)
    local success, controller, house, isContainer = Plot.TryLockdown(playerObj, controller, object)

    if ( success ) then
        object:SetObjVar("LockedDown",true)
        object:SetObjVar("NoReset",true)
        object:SetObjVar("PlotController", controller)

        if ( house and isContainer ) then
            SetTooltipEntry(object,"locked_down","Secure",98)
            Plot.AlterContainerCountBy(house, 1)
            object:SetObjVar("SecureContainer", true)
            object:SetObjVar("locked", true)
        else
            SetTooltipEntry(object,"locked_down","Locked Down",98)
            Plot.AlterLockCountBy(house or controller, 1)
        end

        -- if locked down on a house 
        if ( house ) then
            -- set the house obj var (to prevent moving items outside of house bounds)
            object:SetObjVar("PlotHouse", house)
        else
            if ( isContainer ) then
                ClientDialog.Show{
                    TargetUser = playerObj,
                    DialogId = "UnsecureContainer",
                    TitleStr = "Container Not Secure",
                    DescStr = "Containers locked down outside are not secure.\n\nTo make a Container secure, place it in a house.",
                    Button1Str = "Ok",
                }
            end
        end
    
        if(object:DecayScheduled()) then
            object:RemoveDecay()
        end
        local containedObjects = object:GetContainedObjects()
        for i,j in pairs(containedObjects) do
            if (j:DecayScheduled()) then
                j:RemoveDecay()
            end
        end

        playerObj:SystemMessage("Object Locked Down.", "info")
    end

    return success
end

Plot.UpdateUI = function(playerObj)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.UpdateUI] playerObj not provided.")
        return false
    end
    if ( playerObj:HasModule("plot_control_window") ) then
        playerObj:SendMessage("UpdatePlotControlWindow")
    end
end

--- Try to release a locked down object, will not actually release the object.
-- @param playerObj
-- @param obj
-- @return true/false, controller, house, isPackedObject
Plot.TryRelease = function(playerObj, object)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.TryRelease] playerObj not provided.")
        return false
    end
    if not( object ) then
        LuaDebugCallStack("[Plot.TryRelease] object not provided.")
        return false
    end
    if ( object:IsPermanent() or not object:HasObjVar("LockedDown") ) then
        playerObj:SystemMessage("Cannot released that.", "info")
        return false
    end

    -- ensure close enough
    local loc = object:GetLoc()
    if ( playerObj:GetLoc():Distance(loc) > 20 ) then
        playerObj:SystemMessage("Too far away.", "info")
        return false
    end

    local isPackedObject = object:HasObjVar("IsPackedObject")
    if ( isPackedObject ) then
        if ( #FindItemsInContainerRecursive(object) > 0 ) then
            playerObj:SystemMessage("Cannot release, That is not empty!", "info")
            return false
        end
    end

    if not( IsLockedDown(object) ) then
        playerObj:SystemMessage("That is not locked down.", "info")
        return false
    end
    if ( object:HasObjVar("IsPlotObject") ) then
        playerObj:SystemMessage("That cannot be released.", "info")
        return false
    end

    local controller = object:GetObjVar("PlotController")

    -- locked down item without a controller? Allow it.
    if ( controller == nil ) then return true end

    local house = object:GetObjVar("PlotHouse")
    
    -- ensure permissions
    local grant = Plot.IsOwner(playerObj, controller)
    if ( not grant and house ) then
        grant = Plot.IsHouseCoOwner(playerObj, house)
    end

    if not( grant ) then
        if ( house ) then
            playerObj:SystemMessage("That is not inside your house.", "info")
        else
            playerObj:SystemMessage("That is not inside your plot.", "info")
        end
        return false
    end

    return true, controller, house, isPackedObject
end

--- Release a locked down object from a plot
-- @param playerObj
-- @param object - The object to release
Plot.Release = function(playerObj, controller, object)
    local success, controller, house, isPackedObject = Plot.TryRelease(playerObj, object)

    if ( success ) then

        if ( object:IsContainer() ) then
            CloseContainerRecursive(playerObj, object)
            if ( house ) then
                Plot.AlterContainerCountBy(house, -1)
                if not( isPackedObject ) then
                    object:DelObjVar("SecureContainer")
                    object:DelObjVar("locked")
                    RemoveTooltipEntry(object,"lock")
                end
            else
                Plot.AlterLockCountBy(controller, -1)
            end
        else
            -- remove a lockdown
            Plot.AlterLockCountBy(house or controller, -1)
        end

        -- handle packed objects
        if ( isPackedObject ) then
            PackObject(playerObj, object)
            return
        end

		object:DelObjVar("LockedDown")
		object:DelObjVar("NoReset")
        object:DelObjVar("PlotController")
        if ( house ) then
            object:DelObjVar("PlotHouse")
        end
		RemoveTooltipEntry(object,"locked_down")
		Decay(object)

		if(object:HasModule("hireling_merchant_sale_item")) then
			object:SendMessage("RemoveFromSale")
		end

		local saleItem = FindItemsInContainerRecursive(object, 
			function(item)
				return ( item:HasModule("hireling_merchant_sale_item") )
			end)

		for key,value in pairs(saleItem) do
			if (value:HasModule("hireling_merchant_sale_item")) then
				value:SendMessage("RemoveFromSale")
			end
        end

        playerObj:SystemMessage("Object Released.", "info")
    end
    
    return success
end

--- Try to unpack a packed object
-- @param playerObj
-- @param packedObj
-- @param loc
-- @return boolean, template, controller
Plot.TryUnpack = function(playerObj, packedObj, loc)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.TryUnpack] playerObj not provided.")
        return false
    end
    if not( packedObj ) then
        LuaDebugCallStack("[Plot.TryUnpack] packedObj not provided.")
        return false
    end
    if not( loc ) then
        LuaDebugCallStack("[Plot.TryUnpack] loc not provided.")
        return false
    end
    local template = packedObj:GetObjVar("UnpackedTemplate")
    if ( template == nil ) then
        LuaDebugCallStack("[Plot.TryUnpack] invalid packedObj provided.")
        return false
    end

    local controller = Plot.GetAtLoc(loc)
    if ( controller == nil ) then
        playerObj:SystemMessage("Can only unpack objects on a housing plot.", "info")
        return false
    end

    if not(IsPassable(loc)) then				
        playerObj:SystemMessage("[$2380]", "info")
        return false
    end

    -- look for a houseObj at this location
    local house = Plot.GetHouseAt(controller, loc, false, true) -- checking roof bounds
    local templateData = GetTemplateData(template) or {}
    local isContainer = ( templateData.LuaModules ~= nil and templateData.LuaModules.container ~= nil )

    local exteriorDecoration = packedObj:GetObjVar("ExteriorDecoration")
    if(exteriorDecoration and house) then
        playerObj:SystemMessage("This cannot be placed inside.", "info")
        return false
    end

    -- ensure permissions
    local grant = Plot.IsOwner(playerObj, controller)
    if ( not grant and house ) then
        grant = Plot.IsHouseCoOwner(playerObj, house)
    end

    if not( grant ) then
        if ( house ) then
            playerObj:SystemMessage("Can only unpack objects in your own house.", "info")
        else
            playerObj:SystemMessage("Can only unpack objects on your own plot.", "info")
        end
        return false
    end

    if ( Plot.AtLimit(playerObj, controller, house, isContainer) ) then return false end

    return true, controller, template, house, isContainer

end

--- Unpack a packed object, does not check before unpacking, this must be called from the context of the plot controller (send the controller a message of Unpack)
-- @param playerObj
-- @param packedObj
-- @param loc
-- @return boolean
Plot.Unpack = function(playerObj, packedObj, loc, cb)
    local success, controller, template, house, isContainer = Plot.TryUnpack(playerObj, packedObj, loc)

    if ( success ) then
        playerObj:PlayAnimation("kneel")

        local isExteriorDecoration = packedObj:GetObjVar("ExteriorDecoration")
        RegisterSingleEventHandler(EventType.CreatedObject, "UnpackCreate", function(success, objRef)
            if ( success ) then
                objRef:SetObjVar("IsPackedObject", true)
                objRef:SetObjVar("LockedDown", true)
                objRef:SetObjVar("NoReset", true)
                objRef:SetObjVar("PlotController", controller)
                if(isExteriorDecoration) then
                    objRef:SetObjVar("ExteriorDecoration",true)
                end

                if ( house ) then
                    objRef:SetObjVar("PlotHouse", house)
                else
                    if ( isContainer ) then
                        ClientDialog.Show{
                            TargetUser = playerObj,
                            DialogId = "UnsecureContainer",
                            TitleStr = "Container Not Secure",
                            DescStr = "Containers locked down outside are not secure.\n\nTo make a Container secure, place it in a house.",
                            Button1Str = "Ok",
                        }
                    end
                end

                if ( house and isContainer ) then
                    SetTooltipEntry(objRef,"locked_down","Secure",98)
                    objRef:SetObjVar("SecureContainer", true)
                    objRef:SetObjVar("locked", true)
                    Plot.AlterContainerCountBy(house, 1)
                else
                    SetTooltipEntry(objRef,"locked_down","Locked Down",98)
                    Plot.AlterLockCountBy(house or controller, 1)
                end

                MoveMobilesOutOfObject(objRef)
                
                packedObj:Destroy()

                if ( cb ) then cb(objRef) end
                
            else
                if ( cb ) then cb(nil) end
            end
        end)
        local success, error = pcall(function() CreateObj(template, loc, "UnpackCreate") end)
        if not( success ) then
            DebugMessage(error)
            cb(nil)
        end
    else
        if ( cb ) then cb(nil) end
    end
end

--- Convenience function to get the static houseData for a houseObj
-- @param houseObj
-- @return houseData
Plot.GetHouseDataFromHouse = function(houseObj)
    if not( houseObj ) then
        LuaDebugCallStack("[Plot.GetHouseDataFromHouse] houseObj not provided.")
        return nil
    end
    local data = houseObj:GetObjVar("HouseData")
    if ( data == nil ) then return nil end
    return Plot.GetHouseData(data[1], data[2])
end

--- Get the static housing data for a houseType and direction
-- @param houseType
-- @param direction 1,2,3,4 for North,South,East,West
-- @param return houseData, template, rotation
Plot.GetHouseData = function(houseType, direction)
    if not( houseType ) then
        LuaDebugCallStack("[Plot.GetHouseData] houseType not provided.")
        return nil
    end
    local staticData = HouseData[houseType]
    if ( staticData == nil ) then
        LuaDebugCallStack(string.format("[Plot.GetHouseData] invalid houseType '%s' provided.", houseType))
        return nil
    end
    if not( direction ) then direction = 1 end
    local houseData = deepcopy(( direction > 2 ) and staticData.east or staticData.south)

	if ( staticData.Resources ) then
        houseData.Resources = deepcopy(staticData.Resources)
    end
    if ( staticData.LockLimit ) then
        houseData.LockLimit = staticData.LockLimit
    end
    if ( staticData.ContainerLimit ) then
        houseData.ContainerLimit = staticData.ContainerLimit
    end

    houseData.Type = houseType
    houseData.Direction = direction

    if ( direction > 2 ) then
        houseData.Template = houseType .. "_east"
        houseData.Rotation = (direction==4) and Loc(0,180,0) or Loc(0,0,0)
    else
        houseData.Template = houseType .. "_south"
        houseData.Rotation = (direction==1) and Loc(0,180,0) or Loc(0,0,0)
    end

    return houseData
end

--- Get the AABox2 bounds given some houseData
-- @param houseData - return value from Plot.GetHouseData()
-- @param (Loc)loc
-- @param buffered - Optionally get the buffered house bounds (normal bounds with a bit of space added)
-- @param roofBounds - Optionally get the roof bounds of the house vs the object bounds
Plot.GetHouseBounds = function(houseData, loc, buffered, roofBounds)    
    if not( houseData ) then
        LuaDebugCallStack("[Plot.GetHouseBounds] houseData not provided.")
        return {}
    end
    if not( loc ) then
        LuaDebugCallStack("[Plot.GetHouseBounds] loc not provided.")
        return {}
    end

    local bounds = nil
    if ( roofBounds ) then
        bounds = GetTemplateRoofBounds(houseData.Template)
    else
        bounds = GetTemplateObjectBounds(houseData.Template)
    end
    if not( bounds ) then return {} end

    local houseBounds = {}
    for i=1,#bounds do
        local bound = bounds[i]:Rotate(houseData.Rotation.Y):Flatten():GetContainingAARect()

        local topLeft,topRight,bottomLeft,bottomRight = bound.TopLeft,bound.TopRight,bound.BottomLeft,bound.BottomRight
        local sizeX,sizeZ = topRight.X - topLeft.X,bottomLeft.Z - topLeft.Z

        if ( sizeX < 0 ) then
            topLeft.X = topLeft.X + sizeX
            sizeX = math.abs(sizeX)
        end

        if ( sizeZ < 0 ) then
            topLeft.Z = topLeft.Z + sizeZ
            sizeZ = math.abs(sizeZ)
        end
        
        if ( buffered ) then
            topLeft.X, topLeft.Z = topLeft.X - 3, topLeft.Z - 3
            sizeX, sizeZ = sizeX + 6, sizeZ + 6
        end

        -- convert it to AABox2
        houseBounds[#houseBounds+1] = AABox2(loc.X+topLeft.X, loc.Z+topLeft.Z, sizeX, sizeZ)
    end

    return houseBounds

end

--- Try to place a house
-- @param playerObj
-- @param loc
-- @param houseData
-- @return boolean, controller
Plot.TryPlaceHouse = function(playerObj, loc, houseData)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.TryPlaceHouse] playerObj not provided.")
        return false
    end
    if not( loc ) then
        LuaDebugCallStack("[Plot.TryPlaceHouse] loc not provided.")
        return false
    end
    if not( houseData ) then
        LuaDebugCallStack("[Plot.TryPlaceHouse] houseData not provided.")
        return false
    end

    local controller, bounds = Plot.GetAtLoc(loc)
    if ( controller == nil ) then
        playerObj:SystemMessage("Can only place houses on a housing plot.", "info")
        return false
    end

    if not( Plot.IsOwner(playerObj, controller) ) then
        playerObj:SystemMessage("Can only place houses on a plot you own.", "info")
        return false
    end

    if not(IsPassable(loc)) then
        playerObj:SystemMessage("Not a valid location to place that house.", "info")
        return false
    end

    houseData.Bounds = Plot.GetHouseBounds(houseData, loc)

    -- ensure house bounds are completely inside plot
    for i=1,#bounds do
        for ii=1,#houseData.Bounds do
            if not( bounds[i]:Contains(houseData.Bounds[ii]) ) then
                --[[for iii=1,#houseData.Bounds[ii].Points do
                    CreateObj("plot_marker", Plot.PointToLoc(houseData.Bounds[ii].Points[iii]))
                end]]
                playerObj:SystemMessage("House must be completely inside your plot.", "info")
                return false
            end
        end
    end

    -- ensure house bound does not overlap any existing homes ( and is far enough away from other homes )
    local h, hbounds = nil, nil
    Plot.ForeachHouseBound(controller, function(house, houseBounds, index)
        for i=1,#houseData.Bounds do
            if ( houseBounds[index]:Intersects(houseData.Bounds[i]) ) then
                h, hbounds = house, houseBounds
                return true --break loop
            end
        end
    end, true) -- buffered bounds

    if ( h ) then
        playerObj:SystemMessage("There is already a house there.", "info")
        return false
    end

    return true, controller

end

--- Create a house on a plot, does not check if house can/should be created at loc.
-- @param controller - Plot Controller
-- @param (Loc)loc
-- @param houseData
-- @param cb callback function(newHouse)
-- @param isFoundation - if true will create the house's foundation vs the entire built house.
Plot.CreateHouse = function(controller, loc, houseData, cb, isFoundation)
    if not( loc ) then
        LuaDebugCallStack("[Plot.CreateHouse] loc not provided.")
        return cb()
    end
    if not( houseData ) then
        LuaDebugCallStack("[Plot.CreateHouse] houseData not provided.")
        return cb()
    end
    if not( houseData.Bounds ) then
        LuaDebugCallStack("[Plot.CreateHouse] houseData.Bounds not provided.")
        return cb()
    end
    loc.Y = 0
    if ( isFoundation ) then houseData.Template = houseData.Type .. "_foundation" end

    -- override the callback to run our own logic before firing provided callback (if any)
    local fin = function(objRef)
        -- auto unstuck mobiles in the area
        if ( objRef ) then
            for i=1,#houseData.Bounds do
                MoveMobiles(Box2(houseData.Bounds[i]))
            end
        end
        if ( cb ) then cb(objRef) end
    end

    RegisterSingleEventHandler(EventType.CreatedObject, "CreateHouse", function(success, objRef)
        if ( success ) then
            objRef:SetObjVar("NoReset", true)
            objRef:SetObjVar("IsPlotObject", true)
            objRef:SetObjVar("IsHouse", true)
            objRef:SetObjVar("HouseData", {houseData.Type, houseData.Direction})
            objRef:SetObjVar("LockLimit", houseData.LockLimit or 10)
            objRef:SetObjVar("ContainerLimit", houseData.ContainerLimit or 1)
            
            -- add the plot control to the house
            objRef:SetObjVar("PlotController", controller)

            -- add the house to the plot control
            local houses = controller:GetObjVar("PlotHouses") or {}
            houses[#houses+1] = objRef
            controller:SetObjVar("PlotHouses", houses)

            if ( isFoundation ) then
                objRef:SetObjVar("HandlesDrop", true)
                objRef:AddModule("house_foundation")
                fin(objRef)
            else
                -- If not foundation, create sign and door
                Plot.CreateHouseSign(loc, houseData, objRef, function(houseSign)
                    if ( houseSign ) then
                        Plot.CreateHouseDoor(loc, houseData, objRef, function(houseDoor)
                            if ( houseDoor ) then
                                fin(objRef, houseSign, houseDoor)
                            else
                                -- failed to create house door
                                objRef:Destroy()
                                houseSign:Destroy()
                                cb(nil)
                            end
                        end)
                    else
                        -- failed to create house sign
                        objRef:Destroy()
                        cb(nil)
                    end
                end)
            end
        else
            -- failed to create house
            cb(nil)
        end
    end)
    -- since foundations don't have a South/East variant, we need to rotate them in those situations
    if ( isFoundation ) then
        -- east
        if ( houseData.Direction == 3 ) then
            houseData.Rotation = Loc(0,270,0)
        -- west
        elseif ( houseData.Direction == 4 ) then
            houseData.Rotation = Loc(0,90,0)
        end
    end
    CreateObjExtended(houseData.Template, nil, loc, houseData.Rotation, Loc(1,1,1), "CreateHouse")
end

--- Turn a foundation into a house
-- @param (GameObj) foundation
-- @param houseData - optional
-- @param (function) cb - Call back with house as first parameter when done.
Plot.FoundationToHouse = function(foundation, houseData, cb)
    if not( cb ) then cb = function(house) end end
    if not( foundation ) then
        LuaDebugCallStack("[Plot.FoundationToHouse] foundation not provided.")
        cb()
        return
    end
    local controller = foundation:GetObjVar("PlotController")
    local loc = foundation:GetLoc()
    if not( houseData ) then
        houseData = Plot.GetHouseDataFromHouse(foundation)
    end
    if not( houseData.Bounds ) then
        houseData.Bounds = Plot.GetHouseBounds(houseData, loc)
    end
    Plot.CreateHouse(controller, loc, houseData, function(house)
        if ( house ) then
            foundation:Destroy()
        end
        cb(house) 
    end)
end

--- Create a house sign and fire a callback when complete
-- @param loc - Location of the house sign
-- @param houseData - return value of Plot.GetHouseData
-- @param house - House object
-- @param cb - function(sign) -- Called with the new sign object as first parameter when complete.
Plot.CreateHouseSign = function(loc, houseData, house, cb)
    if not( cb ) then cb = function(objRef) end end
    if not( loc ) then
        LuaDebugCallStack("[Plot.CreateHouseSign] loc not provided.")
        return cb()
    end
    if not( houseData ) then
        LuaDebugCallStack("[Plot.CreateHouseSign] houseData not provided.")
        return cb()
    end
    if ( not houseData.SignTemplate or not houseData.SignLoc ) then
        LuaDebugCallStack(string.format("[Plot.CreateHouseSign] house type '%s' missing SignTemplate or SignLoc.", houseData.Type))
        return cb()
    end
    RegisterSingleEventHandler(EventType.CreatedObject, "CreateHouseSign", function(success, objRef)
        if ( objRef ) then
            SetItemTooltip(objRef)
            house:SetObjVar("HouseSign", objRef)
            objRef:SetObjVar("PlotHouse", house)
            objRef:SetObjVar("IsPlotObject", true)
            objRef:SetObjVar("NoReset", true)
        end
        cb(objRef)
    end)
    
    local rotation, location = Loc(0,houseData.SignRot or 0,0)
    if ( houseData.Direction == 1 or houseData.Direction == 4 ) then
        location = loc:Add(Loc(-houseData.SignLoc.X,houseData.SignLoc.Y,-houseData.SignLoc.Z))
    else
        location = loc:Add(houseData.SignLoc)
    end

    CreateObjExtended(houseData.SignTemplate, nil, location, rotation, Loc(1,1,1), "CreateHouseSign")
end

--- Create a house door and fire a callback when complete
-- @param loc - Location of the house door
-- @param houseData - return value of Plot.GetHouseData
-- @param house - House object
-- @param cb - function(door) -- Called with the new door object as first parameter when complete.
Plot.CreateHouseDoor = function(loc, houseData, house, cb)
    if not( cb ) then cb = function(objRef) end end
    if not( loc ) then
        LuaDebugCallStack("[Plot.CreateHouseDoor] loc not provided.")
        return cb()
    end
    if not( houseData ) then
        LuaDebugCallStack("[Plot.CreateHouseDoor] houseData not provided.")
        return cb()
    end
    if ( not houseData.DoorTemplate or not houseData.DoorLoc ) then
        LuaDebugCallStack(string.format("[Plot.CreateHouseDoor] house type '%s' missing DoorTemplate or DoorLoc.", houseData.Type))
        return cb()
    end
    RegisterSingleEventHandler(EventType.CreatedObject, "CreateHouseDoor", function(success, objRef)
        if ( objRef ) then
            SetItemTooltip(objRef)
            house:SetObjVar("HouseDoor", objRef)
            objRef:SetObjVar("PlotHouse", house)
            objRef:SetObjVar("IsPlotObject", true)
            objRef:SetObjVar("NoReset", true)
            Door.Lock(objRef)
        end
        cb(objRef)
    end)
    
    local rotation, location
    if ( houseData.Direction == 1 or houseData.Direction == 4 ) then
        location = loc:Add(Loc(-houseData.DoorLoc.X,houseData.DoorLoc.Y,-houseData.DoorLoc.Z))
        rotation = Loc(0,(houseData.DoorRot or 0)+180,0)
    else
        location = loc:Add(houseData.DoorLoc)
        rotation = Loc(0,houseData.DoorRot or 0,0)
    end

    CreateObjExtended(houseData.DoorTemplate, nil, location, rotation, Loc(1,1,1), "CreateHouseDoor")
end

--- Destroy a house via player confirmation, house must be empty of all lock downs and unpackables
-- @param playerObj - Player attempting to destroy house
-- @param house - House being destroyed
-- @return true/false
Plot.DestroyHouse = function(playerObj, house)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.DestroyHouse] playerObj not provided.")
        return false
    end
    if not( house ) then
        LuaDebugCallStack("[Plot.DestroyHouse] house not provided.")
        return false
    end

    local controller = house:GetObjVar("PlotController")

    if not( Plot.IsOwner(playerObj, controller) ) then
        playerObj:SystemMessage("Only plot owners can destroy houses.", "info")
        return false
    end

    if ( house:HasObjVar("LockCount") ) then
        playerObj:SystemMessage("Cannot destroy a house with locked down objects.", "info")
        return false
    end

    if ( house:HasObjVar("ContainerCount") ) then
        playerObj:SystemMessage("Cannot destroy a house with secure containers.", "info")
        return false
    end

    -- remove the house from the controller houses
    local houses = controller:GetObjVar("PlotHouses") or {}
    local newHouses = {}
    for i=1,#houses do
        if ( houses[i].Id ~= house.Id ) then
            newHouses[#newHouses+1] = houses[i]
        end
    end
    controller:SetObjVar("PlotHouses", houses)

    -- destroy house / sign / door
    local door = house:GetObjVar("HouseDoor")
    local sign = house:GetObjVar("HouseSign")
    if ( door ) then door:Destroy() end
    if ( sign ) then sign:Destroy() end
    house:Destroy()

    return true
end

--- Foreach house and each bound execute a callback
-- @param controller
-- @param cb
-- @return none
Plot.ForeachHouseBound = function(controller, cb, buffered, roofBounds)
    if not( controller ) then
        LuaDebugCallStack("[Plot.ForeachHouseBound] controller not provided.")
        return
    end
    if not( cb ) then cb = function() end end
    local houses = controller:GetObjVar("PlotHouses") or {}
    for i=1,#houses do
        local house = houses[i]
        if ( house:IsValid() ) then
            local data = Plot.GetHouseDataFromHouse(house)
            if ( data ) then
                local houseBounds = Plot.GetHouseBounds(data, house:GetLoc(), buffered, roofBounds)
                for ii=1,#houseBounds do
                    if ( cb(house, houseBounds, ii) ) then return end
                end
            end
        end
    end
end

--- Foreach house execute a callback
-- @param controller
-- @param cb
-- @return none
Plot.ForeachHouse = function(controller, cb)
    local houses = controller:GetObjVar("PlotHouses") or {}
    for i=1,#houses do
        local house = houses[i]
        if ( house and house:IsValid() ) then
            if ( cb(house) ) then return end -- allow early exits
        end
    end
end

--- Foreach locked down item on a plot, execute a callback
-- @param controller
-- @param cb
-- @return none
Plot.ForeachLockdown = function(controller, cb)
    local plotBounds = controller:GetObjVar("PlotBounds")
    local lockdowns = FindObjects(SearchMulti({
        -- will need to loop each bound when L shape are supported..
        SearchRange(plotBounds[1][1], ServerSettings.Plot.MaximumSize + 5),
        SearchObjVar("PlotController", controller),
        SearchObjVar("LockedDown", true),
    }), controller)
    for i=1,#lockdowns do
        local lockdown = lockdowns[i]
        if ( lockdown and lockdown:IsValid() ) then
            if ( cb(lockdown, i) ) then return end -- allow early exists
        end
    end
end

--- Foreach plot maker execute a callback
-- @param controller
-- @param cb
-- @return none
Plot.ForeachMarker = function(controller, cb)
    local markers = controller:GetObjVar("PlotMarkers") or {}
    for i=1,#markers do
        local marker = markers[i]
        if ( marker and marker:IsValid() ) then
            if ( cb(marker, i) ) then return end -- allow early exists
        end
    end
end

--- Will find a plot's house at a location
-- @param controller - Plot Controller
-- @param loc - Location to find house at
-- @param (bool)buffered - Optionally get bounds with a bit of buffered space
-- @param (bool) roofBounds - Optionally get the roof bounds for the house
-- @return gameObj (house) or nil
Plot.GetHouseAt = function(controller, loc, buffered, roofBounds)
    -- if there is no housing region at all, we can end here.
    if ( GetRegion("Housing") == nil ) then return nil end
    local h, b, i
    Plot.ForeachHouseBound(controller, function(house, bounds, index)
        if ( bounds[index]:Contains(loc) ) then
            h, b, i = house, bounds, index
            return true -- stop foreach
        end
    end, buffered, roofBounds)
    return h, b, i
end

--- Determine if a player can move a locked down object.
-- @param playerObj - Player trying to move the object
-- @param object - Locked down object trying to be moved
-- @return true/false
Plot.TryMove = function(playerObj, object)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.TryMove] playerObj not provided.")
        return false
    end
    if not( object ) then
        LuaDebugCallStack("[Plot.TryMove] object not provided.")
        return false
    end

    if ( object:IsPermanent() or object:HasObjVar("IsPlotObject") ) then
        playerObj:SystemMessage("Cannot move that.", "info")
        return false
    end

    if not( object:HasObjVar("LockedDown") ) then
        playerObj:SystemMessage("That is not locked down.", "info")
        return false
    end

    local controller = object:GetObjVar("PlotController")
    if ( controller == nil ) then return false end

    local house = object:GetObjVar("PlotHouse")

    if ( Plot.IsOwner(playerObj, controller) ) then
        return true, controller, house
    end

    if ( house and Plot.IsHouseCoOwner(playerObj, house) ) then
        return true, controller, house
    end

    if ( house ) then
        playerObj:SystemMessage("Can only move objects in your own house.", "info")
    else
        playerObj:SystemMessage("Can only move objects on your own plot.", "info")
    end


    return false
end

--- Attempt to move a locked down objects to a location via player action
-- @param playerObj - Player trying to move the object
-- @param object - Locked down object trying to be moved
-- @param loc - location to move object to
-- @return success(bool), controller(PlotController), house (if object in house)
Plot.TryMoveTo = function(playerObj, object, loc)
    if not( loc ) then
        LuaDebugCallStack("[Plot.TryMoveTo] loc not provided.")
        return false
    end
    local success, controller, house = Plot.TryMove(playerObj, object)

    if ( success ) then
        if ( house ) then
            if not( Plot.HouseContainsLoc(house, loc, false, true) ) then
                playerObj:SystemMessage("That is not in your house!", "info")
                return false
            end
        else
            if not( Plot.ContainsLoc(controller, loc) ) then
                playerObj:SystemMessage("That is not in your plot!", "info")
                return false
            end
            if ( Plot.GetHouseAt(controller, loc, false, true) ) then
                playerObj:SystemMessage("Cannot move an object from outside to inside a house.", "info")
                return false
            end
        end
    end

    return success, controller, house
end

--- Add a player as a co owner to a house via player action
-- @param playerObj - Player adding
-- @param newCoOwner - Player being added
-- @param house - The house object to add as co-owner to
-- @return true/false
Plot.AddHouseCoOwner = function(playerObj, newCoOwner, house)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.AddHouseCoOwner] playerObj not provided.")
        return false
    end
    if not( newCoOwner ) then
        LuaDebugCallStack("[Plot.AddHouseCoOwner] newCoOwner not provided.")
        return false
    end
    if not( house ) then
        LuaDebugCallStack("[Plot.AddHouseCoOwner] house not provided.")
        return false
    end
    if not( Plot.IsOwner(playerObj, house:GetObjVar("PlotController")) ) then
        playerObj:SystemMessage("Only plot owners can add house co-owners.", "info")
        return false
    end

    if not( IsPlayerCharacter(newCoOwner) ) then
        playerObj:SystemMessage("That is not a player!", "info")
        return false
    end

    local coOwners = house:GetObjVar("HouseCoOwners") or {}
    if ( coOwners[newCoOwner] == true ) then
        playerObj:SystemMessage("They are alread a co-owner of that house.", "info")
        return false
    end

    -- needs to be the last return false check
    if not( IsPlayerCharacter(newCoOwner) ) then
        return false
    end
    
    playerObj:SystemMessage(newCoOwner:GetName() .. " Added as House Co-Owner.", "event")
    newCoOwner:SystemMessage(playerObj:GetName() .. " Has Added You as a House Co-Owner.", "event")

    coOwners[newCoOwner] = true

    house:SetObjVar("HouseCoOwners", coOwners)

    Plot.UpdateUI(playerObj)

    return true
end

Plot.RemoveHouseCoOwner = function(playerObj, oldCoOwner, house)
    if not( playerObj ) then
        LuaDebugCallStack("[Plot.RemoveHouseCoOwner] playerObj not provided.")
        return false
    end
    if not( oldCoOwner ) then
        LuaDebugCallStack("[Plot.RemoveHouseCoOwner] oldCoOwner not provided.")
        return false
    end
    if not( house ) then
        LuaDebugCallStack("[Plot.RemoveHouseCoOwner] house not provided.")
        return false
    end
    if not( Plot.IsOwner(playerObj, house:GetObjVar("PlotController")) ) then
        playerObj:SystemMessage("Only plot owners can remove house co-owners.", "info")
        return false
    end

    local coOwners = house:GetObjVar("HouseCoOwners") or {}
    if ( coOwners[oldCoOwner] == true ) then
        coOwners[oldCoOwner] = nil
        house:SetObjVar("HouseCoOwners", coOwners)
    end

    return true

end

Plot.ShowControlWindow = function(playerObj,plotController,defaultTab)
    if not( playerObj:HasModule("plot_control_window") ) then
        playerObj:AddModule("plot_control_window")
    end

    playerObj:SendMessage("InitControlWindow", plotController, plotController, defaultTab)
end

Plot.CloseControlWindow = function(playerObj)
    if ( playerObj:HasModule("plot_control_window") ) then
        playerObj:SendMessage("ClosePlotControlWindow")
    end
end

--- Is a player inside a house
-- @param (Loc)loc
-- @param (bool)Does the player need to be an owner or coowner
-- @return boolean
Plot.IsInHouse = function (playerObj,needsControl)
    if not(playerObj) or not(playerObj:IsValid()) then
        return false
    end

    local playerLoc = playerObj:GetLoc()

    local controller = Plot.GetAtLoc(playerLoc)
    if not(controller) then
        return false
    end

    local house = Plot.GetHouseAt(controller,playerLoc)
    if not(house) then
        return false
    end

    if(needsControl and not(Plot.HasHouseControl(playerObj,controller,house))) then 
        return false
    end

    return true
end

-- calculate out the minimum plot size for a house
for house,data in pairs(HouseData) do
    local topLeft, bottomRight = Loc2(0,0), Loc2(0,0)
    local houseData = Plot.GetHouseData(house, 2) -- calculate facing south
    local houseBounds = Plot.GetHouseBounds(houseData, Loc(0,0,0))
    for i=1,#houseBounds do
        local bounds = houseBounds[i]
        if ( bounds.TopLeft.X < topLeft.X ) then topLeft.X = bounds.TopLeft.X end
        if ( bounds.TopLeft.Z < topLeft.Z ) then topLeft.Z = bounds.TopLeft.Z end
        if ( bounds.BottomRight.X > bottomRight.X ) then bottomRight.X = bounds.BottomRight.X end
        if ( bounds.BottomRight.Z > bottomRight.Z ) then bottomRight.Z = bounds.BottomRight.Z end
    end
    local diff = bottomRight - topLeft
    local x, y = math.ceil(diff.X),math.ceil(diff.Z)
    --if ( x == 0 or y == 0) then DebugMessage(house, x, y) else DebugMessage(x, y) end
    HouseData[house].min = {x,y}
end