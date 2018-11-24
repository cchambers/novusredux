
local _Range = 12
local _BidLock = nil

-- list of players viewing this window
local _Viewers = {}

_Controller = this:GetObjVar("BidController")
_Loc = _Controller:GetLoc()

require 'plot_bid_shared'

function CleanUp()
    -- close the window for all viewers
    for user,data in pairs(_Viewers) do
        if ( user:IsValid() ) then
            user:CloseDynamicWindow("PlotBidWindow")
        end
    end
    this:Destroy()
end

if ( not _Controller or not _Controller:IsValid() ) then
    CleanUp()
end

function UpdateAll()
    for user,data in pairs(_Viewers) do
        if ( user:IsValid() and user:GetLoc():Distance(_Loc) <= _Range ) then
            ShowDynamicWindow(user)
        end
    end
end

function OnBidSuccess(bidData)
    _BidData = bidData
    -- clear bid lock
    _BidLock = nil
    -- update the window for all viewers
    UpdateAll()
end

-- attempts to take the money and bid, without confirmation
-- @param user
-- @param amount - Full amount to bid
function DoBid(user, amount)
    if ( _BidLock ) then
        user:SystemMessage("Someone else is currently bidding.", "info")
        return
    end

    local userId = user:GetAttachedUserId()

    -- check the account has room for another plot
    if ( Plot.GetRemainingSlots(userId) < 1 and not IsGod(user) ) then
        user:SystemMessage("At maximum plots, cannot own another one.", "info")
        return
    end

    local activeBidController = GlobalVarReadKey("Bid.Active", userId)
    if ( activeBidController ~= nil and activeBidController.Id ~= _Controller.Id ) then
        user:SystemMessage("This account has an active bid, only one bid per account allowed at any time.", "info")
        return
    end

    _BidLock = user
    _Controller:SendMessage("DoBid", user, amount)
end

-- attempt to take the money and bid, with confirmation
function Bid(user, amount)
    local userId = user:GetAttachedUserId()

    if ( IsTopBidder(userId) ) then
        user:SystemMessage("You already have the top bid.", "info")
        return
    end

    if ( _Viewers[user] and _Viewers[user].SkipConfirm ) then
        DoBid(user, amount)
        return
    end

    -- Are you sure?
    ClientDialog.Show{
        TargetUser = user,
        DialogId = "ConfirmBid",
        TitleStr = "Bid Confirm",
        DescStr = string.format("Bid %s? Entire payment is required now and will be taken from your bank or backpack. You will be refunded less 1%% bid fee in the event you are out bid.", ValueToAmountStr(GetMinBid())),
        Button1Str = "Place Bid",
        Button2Str = "Cancel",
        ResponseObj = this,
        ResponseFunc = function( player, buttonId )
            buttonId = tonumber(buttonId)
            if ( player == user and buttonId == 0 ) then
                DoBid(user, amount)
            end
        end,
    }

end

function ShowDynamicWindow(user)
    local userId = user:GetAttachedUserId()
    local dynamicWindow = DynamicWindow("PlotBidWindow", "Plot Auction",350,334,0,0,"")

    if ( _Viewers[user] == nil ) then
        _Viewers[user] = {}
    end
    
    local active, now = _Controller:HasTimer("AuctionEnd"), GetNow()

    if not( active ) then
        if ( HasEnded(now) ) then
            dynamicWindow:AddLabel(40,20,"This Auction has ended.",0,0,18)
            active = false
        elseif not( HasStarted(now) ) then
            dynamicWindow:AddLabel(40,20,"Auction Will Start in ".. TimeSpanToWords(TimeSpan.FromSeconds(_StartTime - now)),0,0,18)
            active = false
        end
    end

    if ( active ) then
        dynamicWindow:AddLabel(40,20,"Top Bid: ".. (_BidData.Num > 0 and ValueToAmountStr(_BidData.Bid) or "None"),0,0,18)
        dynamicWindow:AddLabel(40,46,"Your Bid:  "..(_BidData.Bids[userId] and ValueToAmountStr(_BidData.Bids[userId][1]) or "None"),0,0,18)
        dynamicWindow:AddLabel(40,72,"Total Bids: ".._BidData.Num,0,0,18)

        dynamicWindow:AddLabel(40,100,"Auction Ends in "..TimeSpanToWords(_Controller:GetTimerDelay("AuctionEnd")),0,0,18)

        dynamicWindow:AddLabel(40,240,"Skip Confirm:",0,0,18)
        if ( _Viewers[user].SkipConfirm ) then
            dynamicWindow:AddImage(190,240,"Checkbox32px_On",24,24)
        else
            dynamicWindow:AddImage(190,240,"Checkbox32px_Off",24,24)
        end

        dynamicWindow:AddLabel(40,180,"Minimum Bid: "..ValueToAmountStr(GetMinBid()),0,0,18)

        dynamicWindow:AddButton(20,200,"Bid","Place Bid",290,26,"Will place this bid.","",false,"List", (_BidData.Bids[userId] and _BidData.Bids[userId][1] == _BidData.Bid) and "" or "")
    end

    user:OpenDynamicWindow(dynamicWindow, this)
end

RegisterEventHandler(EventType.Message, "ShowBidWindow", ShowDynamicWindow)

RegisterEventHandler(EventType.DynamicWindowResponse, "PlotBidWindow", function (user,returnId)

    if ( _Viewers[user] ) then

        if ( returnId == "Bid" ) then
            Bid(user, GetMinBid())
        elseif ( returnId == "SkipOn" ) then
            _Viewers[user].SkipConfirm = true
        elseif ( returnId == "SkipOff" ) then
            _Viewers[user].SkipConfirm = nil
        else
            _Viewers[user] = nil
            return
        end

        ShowDynamicWindow(user)

    end

end)

RegisterEventHandler(EventType.Message, "UpdateAll", UpdateAll)
RegisterEventHandler(EventType.Message, "CleanUp", CleanUp)
RegisterEventHandler(EventType.Message, "OnBidSuccess", OnBidSuccess)
RegisterEventHandler(EventType.Message, "OnBidFailure", function(msg)
    if ( _BidLock and _BidLock:IsValid() ) then
        _BidLock:SystemMessage(msg, "info")
    end
    _BidLock = nil
end)

RegisterEventHandler(EventType.LeaveView, "BidRange", function(mobile)
    if ( _Viewers[mobile] ) then
        mobile:CloseDynamicWindow("PlotBidWindow")
        _Viewers[mobile] = nil
    end
end)
AddView("BidRange", SearchMobileInRange(_Range))