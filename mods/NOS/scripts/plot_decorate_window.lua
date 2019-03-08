

local obj, targetName, iconId, iconHue
local step = 1

function Init(decoObj)
    if not( SetDecoTarget(decoObj) ) then        
        CleanUp()
    end
end

function SetDecoTarget(decoObj)
    if ( decoObj ~= nil and Plot.TryMove(this, decoObj) ) then
        obj = decoObj
        targetName = obj:GetName() or "Unnamed Object"

        iconId = obj:GetIconId()
        iconHue = obj:GetColor()
        UpdateWindow()

        return true
    end

    return false
end

function CleanUp()
    this:DelModule("plot_decorate_window")
    this:CloseDynamicWindow("PlotDecorateWindow")
end

function UpdateWindow()
    local dynamicWindow = DynamicWindow("PlotDecorateWindow", "Decorate",380,350,0,0,"")

    --dynamicWindow:AddImage(8,32,"BasicWindow_Panel",314,244,"Sliced")

	dynamicWindow:AddLabel(20,20,"Decorate Target:",0,0,18)
	dynamicWindow:AddImage(130,12,"TextFieldChatUnsliced",180,30,"Sliced")
	dynamicWindow:AddLabel(140,20,targetName,146,20,18)
    dynamicWindow:AddButton(284,15,"ChangeTarget","",0,0,"Select a new decorate target.","",false,"Plus")

	dynamicWindow:AddLabel(80,48,"Height",80,0,16,"center")
	dynamicWindow:AddButton(50,68,"PushUp","",0,0,"Push an item up in the air.","",false,"UpButtonSquare")
	dynamicWindow:AddButton(85,68,"PushDown","",0,0,"Push an item down towards the ground.","",false,"DownButtonSquare")

	dynamicWindow:AddLabel(80,98,"X-Axis",80,0,16,"center")
	dynamicWindow:AddButton(50,118,"RotXCCW","",0,0,"Rotate X-Axis.","",false,"","",DecorateButtonSprites.RotateCCW)
	dynamicWindow:AddButton(85,118,"RotXCW","",0,0,"Rotate X-Axis.","",false,"","",DecorateButtonSprites.RotateCW)

    dynamicWindow:AddLabel(80,148,"Y-Axis",80,0,16,"center")
	dynamicWindow:AddButton(50,168,"RotYCCW","",0,0,"Rotate Y-Axis.","",false,"","",DecorateButtonSprites.RotateCCW)
    dynamicWindow:AddButton(85,168,"RotYCW","",0,0,"Rotate Y-Axis.","",false,"","",DecorateButtonSprites.RotateCW)

    dynamicWindow:AddLabel(80,198,"Z-Axis",80,0,16,"center")
	dynamicWindow:AddButton(50,218,"RotZCCW","",0,0,"Rotate Z-Axis.","",false,"","",DecorateButtonSprites.RotateCCW)
    dynamicWindow:AddButton(85,218,"RotZCW","",0,0,"Rotate Z-Axis.","",false,"","",DecorateButtonSprites.RotateCW)

	dynamicWindow:AddLabel(80,248,"Change Speed",80,0,16,"center")
	--dynamicWindow:AddButton(60,268,"Step","x"..step,40,0,"[$1827]","",false,"","",DecorateButtonSprites.Blank)

    --dynamicWindow:AddLabel(200,248,"Set Speed",80,0,16,"center")
    dynamicWindow:AddButton(60,268,"Speed01","x0.1",40,0,"Set Speed to 0.1","",false,"","",DecorateButtonSprites.Blank)
    dynamicWindow:AddButton(110,268,"Speed05","x0.5",40,0,"Set Speed to 0.5","",false,"","",DecorateButtonSprites.Blank)
    dynamicWindow:AddButton(160,268,"Speed1","x1",40,0,"Set Speed to 1","",false,"","",DecorateButtonSprites.Blank)
    dynamicWindow:AddButton(210,268,"Speed2","x2",40,0,"Set Speed to 2","",false,"","",DecorateButtonSprites.Blank)
    dynamicWindow:AddButton(260,268,"Speed4","x4",40,0,"Set Speed to 4","",false,"","",DecorateButtonSprites.Blank)
    dynamicWindow:AddButton(310,268,"Speed8","x8",40,0,"Set Speed to 8","",false,"","",DecorateButtonSprites.Blank)

	dynamicWindow:AddImage(177,103,"TextFieldChatUnsliced",94,94,"Sliced")
	if(iconId ~= nil) then
		dynamicWindow:AddImage(192,120,tostring(iconId),64,64,"Object",iconHue)
	end

	dynamicWindow:AddButton(200,78,"PushNorth","",0,0,"Push an item towards the North.","",false,"NorthArrow")
	dynamicWindow:AddButton(200,198,"PushSouth","",0,0,"Push an item towards the South.","",false,"SouthArrow")
	dynamicWindow:AddButton(152,124,"PushWest","",0,0,"Push an item towards the West.","",false,"WestArrow")
	dynamicWindow:AddButton(270,124,"PushEast","",0,0,"Push an item towards the East.","",false,"EastArrow")	
    
    this:OpenDynamicWindow(dynamicWindow, this)
end

function HandleDecorateWindowResponse(returnId)
    if(returnId == "ChangeTarget") then
        this:SystemMessage("Select a locked down object.","info")
        RegisterEventHandler(EventType.ClientTargetGameObjResponse, "DecoTarget", function(targetObj)
            if ( targetObj and targetObj ~= obj and targetObj:IsValid() ) then
                SetDecoTarget(targetObj)
            end
        end)
        this:RequestClientTargetGameObj(this, "DecoTarget")
    elseif(returnId == "PushNorth") then
        PushDecoObject(Loc(0,0,0.1))
    elseif(returnId == "PushSouth") then
        PushDecoObject(Loc(0,0,-0.1))
    elseif(returnId == "PushEast") then
        PushDecoObject(Loc(0.1,0,0))
    elseif(returnId == "PushWest") then
        PushDecoObject(Loc(-0.1,0,0))
    elseif(returnId == "PushUp") then
        PushDecoObject(Loc(0,0.1,0))
    elseif(returnId == "PushDown") then
        PushDecoObject(Loc(0,-0.1,0))
    elseif(returnId == "RotXCW") then	
        RotateDecoObject(Loc(5,0,0))			
    elseif(returnId == "RotXCCW") then
        RotateDecoObject(Loc(-5,0,0))
    elseif(returnId == "RotYCW") then	
        RotateDecoObject(Loc(0,5,0))			
    elseif(returnId == "RotYCCW") then
        RotateDecoObject(Loc(0,-5,0))
    elseif(returnId == "RotZCW") then	
        RotateDecoObject(Loc(0,0,5))			
    elseif(returnId == "RotZCCW") then
        RotateDecoObject(Loc(0,0,-5))
    elseif(returnId == "Speed01") then
        step = 0.1
        UpdateWindow()
    elseif(returnId == "Speed05") then
        step = 0.5
        UpdateWindow()
    elseif(returnId == "Speed1") then
        step = 1
        UpdateWindow()
    elseif(returnId == "Speed2") then
        step = 2
        UpdateWindow()
    elseif(returnId == "Speed4") then
        step = 4
        UpdateWindow()
    elseif(returnId == "Speed8") then
        step = 8
        UpdateWindow()
    else
        -- nothing matched
        return false			
    end

    -- something matched
    return true
end

function PushDecoObject(direction)
	local newLoc = obj:GetLoc() + (step*direction)
    if ( Plot.TryMoveTo(this, obj, newLoc) ) then
        obj:SetWorldPosition(newLoc)
        -- auto unstuck when decorating ontop of mobiles
        MoveMobilesOutOfObject(obj, newLoc)
    end
end

function RotateDecoObject(direction)
    if ( Plot.TryMove(this, obj) ) then
        obj:SetRotation(obj:GetRotation() + (step*direction))
    end
end


-- Events
RegisterEventHandler(EventType.DynamicWindowResponse, "PlotDecorateWindow", function (user,returnId)		
    if (
        user ~= this
        or
        obj == nil
        or
        not obj:IsValid()
        or
        not Plot.TryMove(this, obj)
        or
        not HandleDecorateWindowResponse(returnId)
    ) then
        CleanUp()
    end
end)

RegisterEventHandler(EventType.Message, "InitDecorate", Init)

