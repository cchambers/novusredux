
local controller
local _FieldAmounts = {}

function Init(controllerObj)    
    controller = controllerObj

    if ( controller == nil ) then
        CleanUp()
        return
    end

    UpdateWindow()
end


function CleanUp()
    this:DelModule("plot_tax_window")
    this:CloseDynamicWindow("PlotTaxWindow")
end

function GetTaxRate(cb)
    if not( cb ) then cb = function(rate) end end
    local address = GlobalVarReadKey("Plot."..controller.Id, "Region")
    if ( address == ServerSettings.RegionAddress ) then
        cb(Plot.CalculateRateController(controller))
    else
        RegisterSingleEventHandler(EventType.Message, "PlotRateResponse", cb)
        MessageRemoteClusterController(address, "PlotRateRequest", this, controller)
    end
end

function UpdateWindow()
    if not( controller ) then
        CleanUp()
        return
    end

    local dynamicWindow = DynamicWindow("PlotTaxWindow", "Tax Payment",260,230,0,0,"")
    
    local curY = 10 
    local i = 4
	while(i > 0) do
		local denomInfo = Denominations[i]
		dynamicWindow:AddLabel(20,curY+4,denomInfo.Color..denomInfo.Name.."[-]",0,0,18)
		dynamicWindow:AddTextField(20+147,curY,50,20,denomInfo.Name,_FieldAmounts[denomInfo.Name] or "0")
		curY = curY + 30
		i = i - 1
    end

    dynamicWindow:AddButton(10,140,"Pay","Deposit",220,26,"Deposit money into plot lockbox. (Non-Refundable)","",false,"List")
    
    this:OpenDynamicWindow(dynamicWindow, this)
end

RegisterEventHandler(EventType.DynamicWindowResponse, "PlotTaxWindow", function(user,returnId,fieldData)

    if ( user == this ) then

        if ( returnId == "Pay" ) then
            local amount = 0
            for i=1,4 do
                local denomInfo = Denominations[i]
                local denomAmount = tonumber(fieldData[denomInfo.Name])
				if ( denomAmount ) then
					denomAmount = math.floor(denomAmount)
                    if ( denomAmount ~= nil and denomAmount > 0 ) then
                        amount = amount + ( denomAmount * denomInfo.Value )
					end
				end
            end
            if ( amount < ServerSettings.Plot.Tax.MinimumPayment ) then
                this:SystemMessage("Minimum tax payment is "..ValueToAmountStr(ServerSettings.Plot.Tax.MinimumPayment), "info")
                return
            end

            GetTaxRate(function(rate)
                local max = math.floor(rate * ServerSettings.Plot.Tax.MaxBalanceRateModifier)
                local balance = GlobalVarReadKey("Plot."..controller.Id, "Balance") or 0
                
                if ( balance >= max ) then
                    this:SystemMessage("This plot's tax balance is full.", "info")
                    return
                end

                local total = amount + balance
                if ( total > max ) then
                    amount = max - balance
                    this:SystemMessage("This plot's maximum tax balance is "..ValueToAmountStr(max)..", payment adjusted to "..ValueToAmountStr(amount), "info")
                end
                
                -- Are you sure?
                ClientDialog.Show{
                    TargetUser = this,
                    DialogId = "ConfirmPayTax",
                    TitleStr = "Pay Tax Confirm",
                    DescStr = "Pay "..ValueToAmountStr(amount).." towards plot's tax balance? This is non-refundable.",
                    Button1Str = "Pay",
                    Button2Str = "Cancel",
                    ResponseObj = this,
                    ResponseFunc = function( user, buttonId )
                        if ( user == this and tonumber(buttonId) == 0 ) then
    
                            -- try to consume the payment
                            if not( ConsumeResourceContainer(this, "coins", amount) ) then
                                this:SystemMessage("Cannot afford tax payment.", "info")
                                return
                            end
            
                            -- add the tax
                            Plot.AddTax(controller, amount, this, function(success)
                                if ( success ) then
                                    this:SystemMessage(ValueToAmountStr(amount).." added to property tax.", "info")
                                    if ( this:HasModule("plot_control_window") ) then
                                        this:SendMessage("UpdatePlotControlWindow")
                                    end
                                else
                                    -- uid message for quick log checking
                                    local uid = uuid()
                                    this:SystemMessage("Internal Server Error. UID: "..uid)
                                    -- TODO Re-create their coins here..
                                    DebugMessage("!!COINS LOST!! amount:"..amount.." for playerObj.Id:"..this.Id.." UID:"..uid)
                                end
                                this:CloseDynamicWindow("PlotTaxWindow")
                            end)

                        end
                    end,
                }
            end)
            return -- don't cleanup
        end
    end
    
    CleanUp()
end)

RegisterEventHandler(EventType.Message, "CloseTaxWindow", CleanUp)
RegisterEventHandler(EventType.Message, "InitTaxWindow", Init)

