
local ignore = {}

ignore[1] = true

local others = {}

function GetRandomHue()
    local rnd
    while ( rnd == nil or ignore[rnd] == true ) do
        rnd = math.random(1, 1024)
    end
    return rnd
end

Current_Hue = 0

function HueSelf(hue)
    if ( hue == nil ) then hue = 0 end
    hue = math.clamp(hue, 0, 1024)
    local items = {
        this:GetEquippedObject("Head"),
        this:GetEquippedObject("Chest"),
        this:GetEquippedObject("Legs"),
        this:GetEquippedObject("LeftHand"),
        this:GetEquippedObject("RightHand"),
    }
    if ( #items < 1 ) then
        table.insert(items, this)
    end
    for i=1,#items do
        if ( items[i] ~= nil ) then
            items[i]:SetHue(hue)
        end
    end
    Current_Hue = hue
    for i=1,#others do
        if ( others[i] ~= nil and others[i]:IsValid() ) then
            others[i]:SendMessage("sethue", hue)
        end
    end
end

function ShowHueWindow(user)

	local dynamicWindow = DynamicWindow(
		"HueWindow", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
		"Browse Hues", --(string) Title of the window for the client UI
		225, --(number) Width of the window
		60
    )
    
    dynamicWindow:AddButton(
        15, --(number) x position in pixels on the window
        20, --(number) y position in pixels on the window
        "dec", --(string) return id used in the DynamicWindowResponse event
        "Prev", --(string) text in the button (defaults to empty string)
        0, --(number) width of the button (defaults to width of text)
        0,--(number) height of the button (default decided by type of button)
        "Prev Hue"
    )
    
    dynamicWindow:AddTextField(80,0,50,20,"SetHue",(Current_Hue or 0).."")
    
    dynamicWindow:AddButton(
        80, --(number) x position in pixels on the window
        20, --(number) y position in pixels on the window
        "set", --(string) return id used in the DynamicWindowResponse event
        "Set", --(string) text in the button (defaults to empty string)
        0, --(number) width of the button (defaults to width of text)
        0,--(number) height of the button (default decided by type of button)
        "Set to this hue"
    )
    
    dynamicWindow:AddButton(
        135, --(number) x position in pixels on the window
        20, --(number) y position in pixels on the window
        "inc", --(string) return id used in the DynamicWindowResponse event
        "Next", --(string) text in the button (defaults to empty string)
        0, --(number) width of the button (defaults to width of text)
        0,--(number) height of the button (default decided by type of button)
        "Next Hue"
    )

    user:OpenDynamicWindow(dynamicWindow)
    
end

RegisterEventHandler(EventType.DynamicWindowResponse, "HueWindow", function(user, returnId, extra)
    if ( extra == nil ) then extra = {} end
    local hue = 0
    if ( extra.SetHue ) then
        hue = tonumber(extra.SetHue)
    end
    if ( returnId == "inc" ) then
        hue = hue + 1
        if ( hue > 1024 ) then
            hue = 0
        end
        HueSelf(hue)
    elseif ( returnId == "dec" ) then
        hue = hue - 1
        if ( hue < 0 ) then
            hue = 1024
        end
        HueSelf(hue)
    elseif ( returnId == "set" ) then
        HueSelf(hue)
    else
        return
    end
    ShowHueWindow(user)
end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "OtherTarget", function(target)
    table.insert(others, target)
end)

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),function ( ... )
    AddUseCase(this,"Hue",false)
    AddUseCase(this,"Add Other",false)
    HueSelf(GetRandomHue())
end)

RegisterEventHandler(EventType.Message,"UseObject",function (user,useType)
    if (not useType == "Hue" or not useType == "Add Other") then return end

    if ( useType == "Hue" ) then
        ShowHueWindow(user)
    else
        user:RequestClientTargetGameObj(this, "OtherTarget")
    end
end)

RegisterEventHandler(EventType.Message, "sethue", function(hue)
    HueSelf(hue)
end)