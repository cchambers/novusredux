-- Set the string value of the Untiy Region name and a table spawnInfo containing key1=Count (i.e., number of objects)
-- and key2=TemplateId (i.e., the Id # of the template file)
-- Example:
--
--    local spawnInfo = 
--    {
--        { ["Count"] = 10, ["TemplateId"] = 71 }, -- Red Soldier
--        { ["Count"] = 1, ["TemplateId"] = 70 }  -- Red Chief
--    }
--
--    Properties.SetSpawnInfo(spawnInfo)
--    Properties.SetRegionName("RedWarcamp")
--
-- Run controller by calling Functions.Init() after defining properties

Properties = {}
Functions = {}

regionName = ""
spawnInfo = {}

-- Public Properties and Functions

function Properties.GetRegionName()
    return regionName
end

function Properties.SetRegionName(value)
    regionName = value
end

function Properties.GetSpawnInfo()
    return spawnInfo
end

function Properties.SetSpawnInfo(value)
    spawnInfo = value
end

function Functions.Init()
    Controller()
end

-- Private Functions

function GetRandomSpawnLoc()    
    local region = GetRegion(regionName)
    if( region == nil ) then
        return
    end

    local maxTries = 20
    local spawnLoc = GetRegion(regionName):GetRandomLocation()
    -- try to find a passable location
    while(maxTries > 0 and not(IsPassable(spawnLoc)) ) do
        spawnLoc = GetRegion(regionName):GetRandomLocation()
        maxTries = maxTries - 1
    end

    return spawnLoc
end

function CheckVect(data, len)
    if #data > len then
        for i=len+1,#data do 
            table.remove(data,i)
        end
    end
end

function CheckSpawn(data, templateId)
    for index=1, #data do
        local obj = data[index]
        if (obj == nil or not(obj:IsValid()) ) then
            local callbackData = {templateId, index}
            CreateObj(templateId, GetRandomSpawnLoc(), "created", callbackData)
        end
    end
end

function OnObjectCreated(success, objRef, callbackData)
    if success then
        local spawnData = this:GetObjVar("spawnData")        

        local template = callbackData[1]
        local index = callbackData[2]
        
        local listNum = IndexOf(spawnInfo,template,
                function(entry,template) 
                    return entry.TemplateId == template
                end )

        spawnData[listNum][index] = objRef

        this:SetObjVar("spawnData", spawnData)
    end
end

function Controller()
    local spawnData = this:GetObjVar("spawnData")

    if spawnData == nil then
        spawnData = {}
        for i=1,10 do
            spawnData[i] = {}                
        end
    end

    for index, element in pairs(spawnInfo) do
        CheckVect(spawnData[index], element.Count)
    end
    
    this:SetObjVar("spawnData", spawnData)

    for index, element in pairs(spawnInfo) do
        CheckSpawn(spawnData[index], element.TemplateId)
    end
end

RegisterEventHandler(EventType.CreatedObject, "created", OnObjectCreated)