
-- if/when we start supporting L shaped plots, this can be used toward that cause.
local boundIndex = 1

local controller,plotBounds,newPlotBounds,size,newSize,rate,newRate,newCost,amount,step,canAdjust

function Init(plotController)
    controller = plotController

    if ( controller == nil ) then
        CleanUp()
        return
    end

    Reset()
end

function Reset()
    amount = {0,0,0,0}
    canAdjust = true
    step = 1

    plotBounds = controller:GetObjVar("PlotBounds") or {}
    newPlotBounds = deepcopy(plotBounds)
    size = plotBounds[boundIndex][2]
    newSize = size
    rate = Plot.CalculateRate(plotBounds)
    newRate = rate
    newCost = 0

    UpdateWindow()
    UpdateClientPreview(Plot.CalculateBound(plotBounds[boundIndex]))
end

function CanCommit()
    local allZero = true
    for i=1,4 do 
        if( amount[i] ~= 0 ) then
            allZero = false 
        end
    end

    return not(allZero) and canAdjust
end

function UpdateClientPreview(newBound)
    local color = canAdjust and "0FB900" or "B90002"

    -- Data format:
    --    - id (string)
    --    - Color (string)
    --    - Top (float)
    --    - Left (float)
    --    - Bottom (float)
    --    - Right (float)
    --    - Height (float)
    this:SendClientMessage("UpdateLocalLandPreview",{"plot_preview",color,newBound.Top,newBound.Left,newBound.Bottom,newBound.Right,0.5})
end

function AdjustAmount(amt)
    for i=1,4 do amount[i] = amount[i] + amt[i] end

    local newCanAdjust, newBound, newLoc, newNewSize = Plot.TryAdjust(this, controller, amount)

    if not( newCanAdjust ) then
        for i=1,4 do amount[i] = amount[i] - amt[i] end
        return 
    end

    newSize = newNewSize
    if ( newSize.X == size.X and newSize.Z == size.Z ) then
        Reset()
        return
    end
    newPlotBounds[boundIndex] = {newBound, newSize}
    newRate = Plot.CalculateRate(newPlotBounds)
    newCost = math.max(0, Plot.CalculateCost(newPlotBounds) - Plot.CalculateCost(plotBounds))

    canAdjust = newCanAdjust
    UpdateClientPreview(newBound)
end

function CleanUp()
    this:DelModule("plot_resize_window")
    this:CloseDynamicWindow("PlotResizeWindow")

    this:SendClientMessage("ClearLocalLandPreview","plot_preview")
end

function UpdateWindow()
    local dynamicWindow = DynamicWindow("PlotResizeWindow", "Resize Plot",442,220,0,0,"")    
    
    local offsetX = 16
    local offsetY = 18
	dynamicWindow:AddButton(offsetX+38,offsetY+0,"North","",0,0,"","",false,"NorthArrow")
    dynamicWindow:AddButton(offsetX+50,offsetY+26,"NorthS","",24,13,"","",false,"DownArrow")
    dynamicWindow:AddButton(offsetX+38,offsetY+100,"South","",0,0,"","",false,"SouthArrow")
    dynamicWindow:AddButton(offsetX+50,offsetY+87,"SouthS","",24,13,"","",false,"UpArrow")
    dynamicWindow:AddButton(offsetX+0,offsetY+36,"West","",0,0,"","",false,"WestArrow")
    dynamicWindow:AddButton(offsetX+26,offsetY+48,"WestS","",13,24,"","",false,"RightArrow")
    dynamicWindow:AddButton(offsetX+98,offsetY+36,"East","",0,0,"","",false,"EastArrow")
    dynamicWindow:AddButton(offsetX+85,offsetY+48,"EastS","",13,24,"","",false,"LeftArrow")

    dynamicWindow:AddImage(154,8,"BasicWindow_Panel",250,127,"Sliced")
    dynamicWindow:AddImage(156,8,"HeaderRow_Bar",246,26,"Sliced")    
    dynamicWindow:AddLabel(287,14,"Information",0,0,20,"center",false,true)

    local can = CanCommit()
    
    local signX = ((newSize.X - size.X) < 0) and "" or "+"
    local signZ = ((newSize.Z - size.Z) < 0) and "" or "+"
    dynamicWindow:AddLabel(162,44,string.format("New Size: %d ("..signX.."%d) x %d ("..signZ.."%d)", newSize.X, newSize.X - size.X, newSize.Z, newSize.Z - size.Z),0,0,18)
    if(can) then
        dynamicWindow:AddLabel(162,64,string.format("New Taxes: %s", GetAmountStrShort(ValueToAmounts(newRate))),0,0,18)        
        dynamicWindow:AddLabel(162,84,"Commit Cost: ".. (newCost > 0 and GetAmountStrShort(ValueToAmounts(newCost)) or "0"),0,0,18)        
    end

    dynamicWindow:AddButton(154,135,"Commit","Commit",250,23,"","",false,"",(can and "") or "disabled")


    --if (  ) then
	--    dynamicWindow:AddButton(50,225,"Confirm","Confirm",0,0,"Confirm New Plot Size","",false)	
    --end

    --dynamicWindow:AddImage(32,230,"Divider",264,1,"Sliced")
    
    this:OpenDynamicWindow(dynamicWindow, this)
end

function HandleResizeWindowResponse(returnId)
    if(returnId == "North") then
        AdjustAmount({1*step,0,0,0})
    elseif(returnId == "NorthS") then
        AdjustAmount({-1*step,0,0,0})
    elseif(returnId == "South") then
        AdjustAmount({0,1*step,0,0})
    elseif(returnId == "SouthS") then
        AdjustAmount({0,-1*step,0,0})
    elseif(returnId == "East") then
        AdjustAmount({0,0,1*step,0})
    elseif(returnId == "EastS") then
        AdjustAmount({0,0,-1*step,0})
    elseif(returnId == "West") then
        AdjustAmount({0,0,0,1*step})
    elseif(returnId == "WestS") then
        AdjustAmount({0,0,0,-1*step})
    elseif(returnId == "Commit" ) then
        Confirm()
    elseif(returnId == "StepDown") then
        if ( step <= -10 ) then return end
        -- decrease by 1
        step = step - 1
        if ( step == 0 ) then step = -1 end
    elseif(returnId == "StepUp") then
        if ( step >= 10 ) then return end
        -- increment by 1
        step = step + 1
        if ( step == 0 ) then step = 1 end
    else
        -- nothing matched
        return false			
    end

    UpdateWindow()
    -- something matched
    return true
end

function Confirm()
    local costStr = ValueToAmountStr(newCost,false,true)
    if ( costStr == "" ) then costStr = "Nothing" end
    -- Are you sure?
    ClientDialog.Show{
        TargetUser = this,
        DialogId = "ResizePlotConfirm",
        TitleStr = "Resize Plot",
        DescStr = string.format("Do you wish to resize your plot? %s will be due immediately and your new weekly tax payment will be %s.", costStr, ValueToAmountStr(newRate,false,true)),
        Button1Str = "Resize Plot",
        Button2Str = "Cancel",
        ResponseObj = this,
        ResponseFunc = function( user, buttonId )
            buttonId = tonumber(buttonId)
            if ( user == this and buttonId == 0 ) then
                if ( newCost < 1 or ConsumeResourceContainer(this, "coins", newCost) ) then
                    Plot.Adjust(this, controller, amount)
                    Plot.TaxWarn(this)
                    Reset()
                else
                    this:SystemMessage("Cannot afford that.", "info")
                end
            end
        end
    }
end

-- Events
RegisterEventHandler(EventType.DynamicWindowResponse, "PlotResizeWindow", function (user,returnId)		
    if (
        user ~= this
        or
        not Plot.IsOwner(this, controller)
        or
        not HandleResizeWindowResponse(returnId)
    ) then
        CleanUp()
    end
end)

RegisterEventHandler(EventType.Message, "InitResize", Init)

