
local _Range = 12
local _BidLock = nil

-- list of players viewing this window
local _Viewers = {}
-- list of recent bid amount, closing window clears this
local _FieldAmounts = {}

_Controller = this:GetObjVar("BidController")
_Loc = _Controller:GetLoc()

require 'NOS:plot_bid_shared'

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
        if ( user:IsValid() ) then
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
    
    local minBid = GetMinBid()
    if ( amount < minBid ) then
        user:SystemMessage(string.format("Minimum bid is %s.", ValueToAmountStr(minBid)), "info")
        if ( _FieldAmounts[user] ) then
            _FieldAmounts[user] = nil
        end
        return
    end

    local consume = amount
    if ( _BidData.Bids[userId] ) then
        consume = amount - _BidData.Bids[userId][1]
    end

    -- Are you sure?
    ClientDialog.Show{
        TargetUser = user,
        DialogId = "ConfirmBid",
        TitleStr = "Bid Confirm",
        DescStr = string.format("Bid %s?\n\n%s is due now and will be taken from your bank or backpack.\n\nYou will be refunded less 1%% bid fee in the event auction ends and you did not win.", ValueToAmountStr(amount), ValueToAmountStr(consume)),
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
    if ( IsDead(user) or user:GetLoc():Distance(_Loc) > _Range ) then return end

    local userId = user:GetAttachedUserId()

    if ( _Viewers[user] == nil ) then
        _Viewers[user] = {}
    end
    
    local active, now = _Controller:HasTimer("AuctionEnd"), GetNow()

    local dynamicWindow = DynamicWindow("PlotBidWindow", "Plot Auction",350,not active and 150 or 334,0,0,"")

    if not( active ) then
        if ( HasEnded(now) ) then
            dynamicWindow:AddLabel(165,20,"This Auction has ended.",0,0,18)
            active = false
        elseif not( HasStarted(now) ) then
            dynamicWindow:AddLabel(165,20,"Auction Will Start in:\n".. TimeSpanToWords(_StartTime - now),0,0,18,"center")
            active = false
        end
    end

    if ( active ) then
        dynamicWindow:AddLabel(165,20,"Top Bid: ".. (_BidData.Num > 0 and ValueToAmountStr(_BidData.Bid) or "None"),0,0,18,"center")
        dynamicWindow:AddLabel(165,46,"Your Bid:  "..(_BidData.Bids[userId] and ValueToAmountStr(_BidData.Bids[userId][1]) or "None"),0,0,18,"center")

        dynamicWindow:AddLabel(165,90,"Total Bids: ".._BidData.Num,0,0,18,"center")
        dynamicWindow:AddLabel(165,110,"Auction Ends in "..TimeSpanToWords(_Controller:GetTimerDelay("AuctionEnd")),0,0,18,"center")

        local minBid = ValueToAmounts(GetMinBid())

        local curX = 20 
        local i = 4
        while(i > 0) do
            local denomInfo = Denominations[i]
            local offset = 25
            if ( i == 1 ) then
                offset = 31
            elseif ( i == 2 ) then
                offset = 36
            elseif ( i == 3 ) then
                offset = 40
            end
            dynamicWindow:AddLabel(offset+curX,150,denomInfo.Color..denomInfo.Name.."[-]",0,0,18)
            local val = "0"
            if ( _FieldAmounts[user] and _FieldAmounts[user][denomInfo.Name] ~= nil ) then
                val = _FieldAmounts[user][denomInfo.Name] .. ""
            elseif ( minBid[denomInfo.Name] ~= nil ) then
                val = minBid[denomInfo.Name] .. ""
            end
            dynamicWindow:AddTextField(30+curX,170,50,20,denomInfo.Name,val)
            curX = curX + 60
            i = i - 1
        end

        dynamicWindow:AddButton(20,200,"Bid","Place Bid",290,26,"Will place this bid.","",false,"List", (_BidData.Bids[userId] and _BidData.Bids[userId][1] == _BidData.Bid) and "" or "")

        if ( IsTopBidder(userId) ) then
            dynamicWindow:AddLabel(165,240,"You are top bidder.",0,0,18,"center")
        end
        dynamicWindow:AddLabel(165,260,"Minimum Bid: "..ValueToAmountStr(GetMinBid()),0,0,18,"center")
    end

    user:OpenDynamicWindow(dynamicWindow, this)
end

RegisterEventHandler(EventType.Message, "ShowBidWindow", ShowDynamicWindow)

RegisterEventHandler(EventType.DynamicWindowResponse, "PlotBidWindow", function (user,returnId,fieldData)

    if ( _Viewers[user] ) then

        if ( returnId == "Bid" ) then
            local amount = 0
            for i=1,4 do
                local denomInfo = Denominations[i]
                local denomAmount = tonumber(fieldData[denomInfo.Name])
				if ( denomAmount ) then
					denomAmount = math.floor(denomAmount)
                    if ( denomAmount ~= nil ) then
                        if not( _FieldAmounts[user] ) then
                            _FieldAmounts[user] = {}
                        end
                        _FieldAmounts[user][denomInfo.Name] = denomAmount
                        amount = amount + ( denomAmount * denomInfo.Value )
					end
				end
            end
            Bid(user, amount)
        else
            _Viewers[user] = nil
            _FieldAmounts[user] = nil
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