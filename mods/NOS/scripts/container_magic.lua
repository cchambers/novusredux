require "default:container"

if (initializer ~= nil) then
    if (initializer.ResourceTypes ~= nil) then
        local ResourceTypeTable = {}
        for k, v in pairs(initializer.ResourceTypes) do
            table.insert(ResourceTypeTable, v)
        end
        this:SetObjVar("ResourceTypes", ResourceTypeTable)
    end
end

function CheckAllItems()
    local succeed = true
    local ResourceTypes = this:GetObjVar("ResourceTypes")
    local objects = FindItemsInContainerRecursive(this)

    for i, j in pairs(objects) do
        local xx = false
        local type = j:GetObjVar("ResourceType") or nil
        if (type == nil) then
            return false
        end
        for k, v in pairs(ResourceTypes[1]) do
            if (ResourceTypes[1][k] == type) then
                xx = true
            end
        end
        if (xx == false) then
            return false
        end
    end
    return true
end

function HandleMagicContainer()
    if(CheckAllItems()) then
        this:SetSharedObjectProperty("Weight", "1")
    else
        this:SetSharedObjectProperty("Weight", "500")
    end
end

function RefreshWeight()
    HandleMagicContainer()
end

RegisterEventHandler(EventType.ContainerItemAdded, "", HandleMagicContainer)

RegisterEventHandler(EventType.ContainerItemRemoved, "", HandleMagicContainer)

UnregisterEventHandler("", EventType.Message,"RefreshWeight")
UnregisterEventHandler("", EventType.Message,"AdjustWeight")