Door = {}

Door.AutoCloseDelay = TimeSpan.FromSeconds(5)
Door.OpenCloseDelay = TimeSpan.FromSeconds(1)

Door.Open = function(door, autoclose, template)
    if not( door ) then
        LuaDebugCallStack("[Door.Open] door object not provided.")
        return false
    end
    local Door = Door
    if ( Door.IsOpen(door) ) then return end
    door:SetSharedObjectProperty("IsOpen", true)
    door:ClearCollisionBounds()
    if ( autoclose ) then
        if not( door:HasModule("door_auto_close") ) then
            door:AddModule("door_auto_close")
        end
        door:SendMessage("AutoClose")
    end
end

Door.Close = function(door, template)
    if not( door ) then
        LuaDebugCallStack("[Door.Close] door object not provided.")
        return false
    end
    local Door = Door
    if not( Door.IsOpen(door) ) then return end
    door:SetSharedObjectProperty("IsOpen", false)
    door:SetCollisionBoundsFromTemplate(template or door:GetCreationTemplateId())
    -- auto unstuck them
    MoveMobilesOutOfObject(door)
end

Door.IsOpen = function(door)
    if not( door ) then
        LuaDebugCallStack("[Door.IsOpen] door object not provided.")
        return false
    end
    return ( door:GetSharedObjectProperty("IsOpen") )
end

Door.Lock = function(door, silent)
    if not( door ) then
        LuaDebugCallStack("[Door.Lock] door object not provided.")
        return false
    end
    if ( Door.IsLocked(door) ) then return end
    door:SetObjVar("locked",true)
    if not( silent ) then
        door:PlayObjectSound("event:/objects/doors/door/door_lock")
    end
    SetTooltipEntry(door,"lock","[FF0000]*Locked*[-]",-1)
end

Door.Unlock = function(door, silent)
    if not( door ) then
        LuaDebugCallStack("[Door.Unlock] door object not provided.")
        return false
    end
    if not( Door.IsLocked(door) ) then return end
    door:DelObjVar("locked")
    if not( silent ) then
        door:PlayObjectSound("event:/objects/doors/door/door_unlock")
    end
    RemoveTooltipEntry(door,"lock")
end

Door.IsLocked = function(door)
    if not( door ) then
        LuaDebugCallStack("[Door.IsLocked] door object not provided.")
        return false
    end
    return door:HasObjVar("locked")
end