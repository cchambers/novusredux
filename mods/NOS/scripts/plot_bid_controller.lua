
_Controller = this
_Window = this:GetObjVar("BidWindow")

require 'plot_bid_shared'

function Save()
    this:SetObjVar("BidControllerData", _BidData)
end

function CleanUp()
    Plot.FinalizeSale(this, _BidData, function()
        -- do a refund to any bidders in the region (player tick will take care of checking if they are offline or in a different region)
        for userId,data in pairs(_BidData.Bids) do
            if ( data[2] and data[2]:IsValid() ) then
                data[2]:SendMessage("CheckBidRefund")
            end
        end
        -- check not deleted
        if ( this:IsValid() ) then
            -- clean up obj vars
            this:DelObjVar("BidControllerData")
            this:DelObjVar("StartBids")
            this:DelObjVar("BidWindow")
            this:DelModule("plot_bid_controller")
            if ( _Window and _Window:IsValid() ) then
                -- destroy forsale sign window that controls UI
                _Window:SendMessage("CleanUp")
            end
        end
    end)
end

function OnBidSuccess(user, userId, amount, consume)

    local userBidData = user:GetObjVar("BidData") or {0,this,_EndTime}
    -- these could be different in the event a player bid with two different characters on the same account.
    userBidData[1] = userBidData[1] + consume
    -- save player data
    user:SetObjVar("BidData", userBidData)

    -- set the user
    _BidData.Bids[userId][1] = amount
    -- the current bid
    _BidData.Bid = amount
    _BidData.Num = _BidData.Num + 1

    -- inform player
    user:SystemMessage("Current bid is "..ValueToAmountStr(amount)..".", "info")

    if ( _Window ) then
        _Window:SendMessage("OnBidSuccess", _BidData)
    end

    -- and save incase of crash during auction
    Save()

end

function OnBidFailure(msg)
    if ( _Window ) then
        _Window:SendMessage("OnBidFailure", msg)
    end
end

-- attempts to take the money and bid, without confirmation
-- @param user
-- @param amount - Full amount to bid
function DoBid(user, amount)

    local minBid = GetMinBid()
    if ( amount < minBid ) then
        OnBidFailure("The minimum bid is "..ValueToAmountStr(minBid))
        return
    end

    local userId = user:GetAttachedUserId()

    -- setup the data that will be saved to the controller
    if not( _BidData.Bids[userId] ) then
        _BidData.Bids[userId] = {0, user}
    end

    -- how much money to consume from the player in this transaction
    local consume = amount - _BidData.Bids[userId][1]

    -- prevent negative amounts..
    if ( consume < 1 ) then
        OnBidFailure("Negative bid prevented.")
        return
    end

    if ( ConsumeResourceContainer(user, "coins", consume) ) then
        if ( GlobalVarReadKey("Bid.Active", userId) == nil ) then
            -- write global active bid before continuing (to prevent other characters on same account from bidding else where)
            SetGlobalVar("Bid.Active", function(record)
                record[userId] = this
                return true
            end, function(success)
                if ( success ) then
                    -- continue on
                    OnBidSuccess(user, userId, amount, consume)
                else
                    _BidData.Bids[userId] = nil
                    -- on failure, refund the gold consumed.
                    Create.Stack.InBackpack("coin_purse", user, consume, nil, function()
                        OnBidFailure("Internal Server Error. Coin should be refunded to your backpack.")
                    end)
                end
            end)
        else
            -- continue on
            OnBidSuccess(user, userId, amount, consume)
        end
    else
        _BidData.Bids[userId] = nil
        OnBidFailure("Not enough coin to make that bid.")
    end
end

RegisterEventHandler(EventType.Message, "DoBid", DoBid)

-- fired when auction starts
RegisterEventHandler(EventType.Timer, "AuctionStart", function()
    this:ScheduleTimerDelay(_EndTime - GetNow(), "AuctionEnd")
    if ( _Window ) then _Window:SendMessage("UpdateAll") end
end)
-- fire when auction ends
RegisterEventHandler(EventType.Timer, "AuctionEnd", CleanUp)


-- if the auction has already ended, finalize it.
if ( HasEnded(_TimeOfInit) ) then
    CleanUp()
else
    -- ensure our timers
    if ( IsActive(_TimeOfInit) ) then
        this:ScheduleTimerDelay(_EndTime - _TimeOfInit, "AuctionEnd")
    elseif not( HasStarted(_TimeOfInit) ) then
        this:ScheduleTimerDelay(_StartTime - _TimeOfInit, "AuctionStart")
    end
end


RegisterEventHandler(EventType.Message, "Debug", function()
    if ( this:HasTimer("AuctionEnd") ) then
        DebugMessage("AuctionEnd", TimeSpanToWords(this:GetTimerDelay("AuctionEnd")))
    end
    if ( this:HasTimer("AuctionStart") ) then
        DebugMessage("AuctionStart", TimeSpanToWords(this:GetTimerDelay("AuctionStart")))
    end
end)