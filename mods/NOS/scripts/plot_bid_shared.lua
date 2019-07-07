
_BidData = _Controller:GetObjVar("BidControllerData") or {}
if not( _BidData.Bids ) then _BidData.Bids = {} end
if not( _BidData.Bid ) then _BidData.Bid = Plot.CalculateStartingBid(_Controller) end
if not( _BidData.Num ) then _BidData.Num = 0 end

_TimeOfInit = GetNow()
_StartTime = _Controller:GetObjVar("StartBids") or _TimeOfInit
_EndTime = _StartTime + ServerSettings.Plot.Auction.Length

function GetMinBid()
    return math.ceil(_BidData.Bid + (_BidData.Bid * 0.01))
end

function IsTopBidder(userId)
    return _BidData.Bids[userId] and _BidData.Bids[userId][1] == _BidData.Bid or false
end

function HasStarted(now)
    if not( now ) then
        now = GetNow()
    end
    return now > _StartTime
end

function HasEnded(now)
    if not( now ) then
        now = GetNow()
    end
    return now > _EndTime
end

function IsActive(now)
    return HasStarted(now) and not HasEnded(now)
end