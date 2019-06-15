Create = {}
Create.Custom = {}
Create.Stack = {}
Create.Temp = {}
Create.CustomTemp = {}

--- Create a template at location
-- @param template
-- @param loc - location to create at
-- @param cb - function(obj) callback
-- @param noTooltip - if true, will skip SetItemTooltip calls
Create.AtLoc = function(template, loc, cb, noTooltip)
    local id = template..uuid()
    RegisterSingleEventHandler(EventType.CreatedObject, id, function(success, obj)
        if ( success and noTooltip ~= true ) then SetItemTooltip(obj) end
        if ( cb ) then
            if ( success ) then
                cb(obj)
            else
                cb(nil)
            end
        end
    end)
    CreateObj(template, loc, id)
end

--- Create a template on a mobile's equipment
-- @param template
-- @param mobile - mobile to created equipped object on
-- @param cb - function(obj) callback
-- @param noTooltip - if true, will skip SetItemTooltip calls
Create.Equipped = function(template, mobile, cb, noTooltip)
    local id = template..uuid()
    RegisterSingleEventHandler(EventType.CreatedObject, id, function(success, obj)
        if ( success and noTooltip ~= true ) then SetItemTooltip(obj) end
        if ( cb ) then
            if ( success ) then
                cb(obj)
            else
                cb(nil)
            end
        end
    end)
    CreateEquippedObj(template, mobile, id)
end

--- Create a custom template at location
-- @param template
-- @param loc - location to create at
-- @param data - Template Data (GetTemplateData)
-- @param cb - function(obj) callback
-- @param noTooltip - if true, will skip SetItemTooltip calls
Create.Custom.AtLoc = function(template, data, loc, cb, noTooltip)
    local id = template..uuid()
    RegisterSingleEventHandler(EventType.CreatedObject, id, function(success, obj)
        if ( success and noTooltip ~= true ) then SetItemTooltip(obj) end
        if ( cb ) then
            if ( success ) then
                cb(obj)
            else
                cb(nil)
            end
        end
    end)
    CreateCustomObj(template, data, loc, id)
end

--- Create a template in a container
-- @param template
-- @param container - container gameObj
-- @param containerloc - (optional) location in container
-- @param cb - function(obj) callback
-- @param noTooltip - if true, will skip SetItemTooltip calls
Create.InContainer = function(template, container, containerloc, cb, noTooltip)
    local id = template..uuid()
    RegisterSingleEventHandler(EventType.CreatedObject, id, function(success, obj)
        if ( success and noTooltip ~= true ) then SetItemTooltip(obj) end
        if ( cb ) then
            if ( success ) then
                cb(obj)
            else
                cb(nil)
            end
        end
    end)
    if not( containerloc ) then
        containerloc = GetRandomDropPosition(container)
    end
    CreateObjInContainer(template, container, containerloc, id)
end

--- Create a template in a container
-- @param template
-- @param container - container gameObj
-- @param containerloc - (optional) location in container
-- @param data - Template Data (GetTemplateData)
-- @param cb - function(obj) callback
-- @param noTooltip - if true, will skip SetItemTooltip calls
Create.Custom.InContainer = function(template, data, container, containerloc, cb, noTooltip)
    local id = template..uuid()
    RegisterSingleEventHandler(EventType.CreatedObject, id, function(success, obj)
        if ( success and noTooltip ~= true ) then SetItemTooltip(obj) end
        if ( cb ) then
            if ( success ) then
                cb(obj)
            else
                cb(nil)
            end
        end
    end)
    if not( containerloc ) then
        containerloc = GetRandomDropPosition(container)
    end
    CreateCustomObjInContainer(template, data, container, containerloc, id)
end

--- Create a template in a mobile's backpack
-- @param template
-- @param mobile - mobileObj
-- @param containerloc - (optional) location in container
-- @param cb - function(obj) callback
-- @param noTooltip - if true, will skip SetItemTooltip calls
Create.InBackpack = function(template, mobile, containerloc, cb, noTooltip)
    if not( cb ) then cb = function(obj) end end
    local backpack = mobile:GetEquippedObject("Backpack")
    if ( backpack == nil ) then return cb(nil) end
    Create.InContainer(template, backpack, containerloc, function(obj)
        if ( obj ) then backpack:SendOpenContainer(mobile) end
        cb(obj)
    end, noTooltip)
end

--- Create a template at a location, assigning StackCount before creation
-- @param template
-- @param count - stack count
-- @param loc - location in world
-- @param cb - function(obj) callback
-- @param noTooltip - if true, will skip SetItemTooltip calls
Create.Stack.AtLoc = function(template, count, loc, cb, noTooltip)
    if not( cb ) then cb = function(obj) end end
    if ( count < 1 ) then return cb(nil) end

    local id = template..uuid()
    RegisterSingleEventHandler(EventType.CreatedObject, id, function(success, obj)
        if ( success and noTooltip ~= true ) then SetItemTooltip(obj) end
        if ( success ) then
            cb(obj)
        else
            cb(nil)
        end
    end)
    
    -- set the stack count before creating
    local templateData = GetTemplateData(template)
    if not( templateData.ObjectVariables ) then templateData.ObjectVariables = {} end
    templateData.ObjectVariables.StackCount = count

    CreateCustomObj(template, templateData, loc, id)
end

--- Create a template in a container, assigning StackCount before creation
-- @param template
-- @param container - container gameObj
-- @param count - stack count
-- @param containerloc - (optional) location in container
-- @param cb - function(obj) callback
-- @param noTooltip - if true, will skip SetItemTooltip calls
-- @param noAutoStack - if true, will create a new object of this stack size, default behavior is to add to any existing stacks.
Create.Stack.InContainer = function(template, container, count, containerloc, cb, noTooltip, noAutostack)
    if not( cb ) then cb = function(obj) end end
    if ( count < 1 ) then return cb(nil) end

    -- get the template id
    local templateData = GetTemplateData(template)

    -- if this template isn't stackable then create a single one of them
    if ( not templateData.LuaModules or (not templateData.LuaModules.stackable and not templateData.LuaModules.coins) ) then
        Create.InContainer(template, container, containerloc, cb, noTooltip)
        return
    end

    if not( noAutoStack ) then
        if ( templateData.ObjectVariables and templateData.ObjectVariables.ResourceType ) then
            -- look for an existing stack of this type
            local items = container:GetContainedObjects()
            for i=1,#items do
                if ( items[i]:GetObjVar("ResourceType") == templateData.ObjectVariables.ResourceType ) then
                    -- adjust the stack by amount.
                    items[i]:SendMessage("AdjustStack", count)
                    cb(items[i])
                    -- early exit cause task is complete.
                    return
                end
            end
        end
    end

    local id = template..uuid()
    RegisterSingleEventHandler(EventType.CreatedObject, id, function(success, obj)
        if ( success and noTooltip ~= true ) then SetItemTooltip(obj) end
        if ( success ) then
            cb(obj)
        else
            cb(nil)
        end
    end)
    
    -- set the stack count before creating
    if not( templateData.ObjectVariables ) then templateData.ObjectVariables = {} end
    templateData.ObjectVariables.StackCount = count
    
    if not( containerloc ) then
        containerloc = GetRandomDropPosition(container)
    end

    CreateCustomObjInContainer(template, templateData, container, containerloc, id)
end

--- Create a template in a mobile's backpack, assigning StackCount before creation
-- @param template
-- @param mobile - mobileObj
-- @param count - stack count
-- @param containerloc - (optional) location in container
-- @param cb - function(obj) callback
-- @param noTooltip - if true, will skip SetItemTooltip calls
-- @param noAutoStack - if true, will create a new object of this stack size, default behavior is to add to any existing stacks.
Create.Stack.InBackpack = function(template, mobile, count, containerloc, cb, noTooltip, noAutostack)
    local backpack = mobile:GetEquippedObject("Backpack")
    if not( cb ) then cb = function(obj) end end
    if ( backpack == nil ) then return cb(nil) end
    Create.Stack.InContainer(template, backpack, count, containerloc, function(obj)
        if ( obj ) then backpack:SendOpenContainer(mobile) end
        cb(obj)
    end, noTooltip)
end

--- Create a TEMPORARY (no backup) template at location
-- @param template
-- @param loc - location to create at
-- @param cb - function(obj) callback
-- @param tooltip - if true, will perform SetItemTooltip calls
Create.Temp.AtLoc = function(template, loc, cb, tooltip)
    local id = template..uuid()
    RegisterSingleEventHandler(EventType.CreatedObject, id, function(success, obj)
        if ( success and tooltip ) then SetItemTooltip(obj) end
        if ( cb ) then
            if ( success ) then
                cb(obj)
            else
                cb(nil)
            end
        end
    end)
    CreateTempObj(template, loc, id)
end

--- Create a custom TEMPORARY (no backup) template at location
-- @param template
-- @param loc - location to create at
-- @param data - Template Data (GetTemplateData)
-- @param cb - function(obj) callback
-- @param tooltip - if true, will perform SetItemTooltip calls
Create.CustomTemp.AtLoc = function(template, data, loc, cb, tooltip)
    local id = template..uuid()
    RegisterSingleEventHandler(EventType.CreatedObject, id, function(success, obj)
        if ( success and tooltip == true ) then SetItemTooltip(obj) end
        if ( cb ) then
            if ( success ) then
                cb(obj)
            else
                cb(nil)
            end
        end
    end)
    CreateCustomTempObj(template, data, loc, id)
end