require 'NOS:base_ai_settings'

function GenerateName()
    local newName = nil
    local TemplateName = this:GetObjVar("TemplateName") or GetTemplateObjectName(this:GetCreationTemplateId())
    if (AI.GetSetting("Age") < 6) then
        newName = "Young " .. TemplateName
    elseif  (AI.GetSetting("Age") <= 13) then
        newName = TemplateName
    elseif  (AI.GetSetting("Age") <= 30) then
        newName = "Old " .. TemplateName
    else
        newName = "Elder " .. TemplateName
    end

    this:SetName(newName)
    this:SendMessage("UpdateName")
end

ANIMAL_DIFFICULTY_MODIFIER = 1.7
function ChangeAge(newAge) 
    --LuaDebugCallStack("ChangeAge".." "..tostring(this.Id).." "..tostring(newAge))
    AI.SetSetting("Age",newAge)
    local newScale= AI.GetSetting("Age")*AI.GetSetting("AgeScaleModifier");
    if (AI.GetSetting("ScaleToAge") == true and newScale < AI.GetSetting("MaxAgeScale") ) then --if AI has scale range then
        local assignScale = newScale*this:GetObjVar("SpawnScale")
        if (type(assignScale) == "number") then
            assignScale = Loc(assignScale,assignScale,assignScale)
        end
        this:SetScale(assignScale)
        --DebugMessage("Scale to age for " .. this:GetName() .. (AI.GetSetting("Age")/10))
    end

    --DFB NOTE: We have to keep this here because it completely nerfed and screwed up a lot of mobs.
    --KH NOTE: Leaving this here after the SetMobileMod convert to see if the debug stack shows up
    RequestAddStatMod(this,"DamageMod", "Age", "Multiplier", AI.GetSetting("Age")*AI.GetSetting("AgeScaleModifier")*ANIMAL_DIFFICULTY_MODIFIER)   

    -- DAB: Disabling Health modifier from age because Jeffrey
    --if (AI.GetSetting("AgeHealthModifier") ~= 1) then --if AI has health range then
        --DebugMessage("Current health is "..tostring(GetCurHealth(this)))
        --DebugMessage("Current Max health is "..tostring(GetMaxHealth(this)))
    --    local currentHealthPercent = GetCurHealth(this)/GetMaxHealth(this)
    --    local spawnHealth = this:GetObjVar("SpawnHealth")
    --    local newMaxHealth = spawnHealth * AI.GetSetting("Age")*AI.GetSetting("AgeScaleModifier")*ANIMAL_DIFFICULTY_MODIFIER
        --DebugMessage("New base health is "..tostring(newMaxHealth))
    --    this:SetObjVar("BaseHealth",newMaxHealth)
        --DebugMessage("new cur health is "..tostring(newMaxHealth*currentHealthPercent))
    --    SetCurHealth(this,newMaxHealth*currentHealthPercent)
    --end

    GenerateName()
end

RegisterEventHandler(EventType.Timer, "AgeTimer", 
    function ()
        if( AI.GetSetting("Age") > AI.GetSetting("MaxAge") and math.random(1,10) == 1) then            
            this:SendMessage("ProcessTrueDamage", this, 5000, true)
            return
        end

        --Have mob age by 0.4 every ten minutes
        --DebugMessage("Running change age")
        ChangeAge(AI.GetSetting("Age") + AI.GetSetting("AgeIncrement"))
        
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(AI.GetSetting("AgeCheckFrequencySecs")), "AgeTimer")
    end)
        --Run once module loading code.

--ability to change age remotely, (ie fountain of youth, etc.)
RegisterEventHandler(EventType.Message,"ChangeAge",
    function(newAge)
        ChangeAge(newAge)
    end)

-- override OnCreate in base_ai_mob
local oldCreate = OnCreate
function OnCreate()
    oldCreate()

    if (not this:HasObjVar("SpawnHealth")) then
        this:SetObjVar("SpawnHealth",this:GetObjVar("BaseHealth") or ServerSettings.Stats.NPCBaseHealth)
    end
    if (not this:HasObjVar("TemplateName")) then
        this:SetObjVar("TemplateName",this:GetName())
    end
    if (not this:HasObjVar("SpawnScale")) then
        this:SetObjVar("SpawnScale",this:GetScale())
    end

    --DebugMessage("OnCreate",this.Id)
    --If we have this function we have the age module
    if (this:HasObjVar("AI-Age") == false) then            
        ChangeAge(AI.GetSetting("Age") + math.random(-2,2))            
    else
        ChangeAge(AI.GetSetting("Age"))
    end
end

this:ScheduleTimerDelay(TimeSpan.FromSeconds(AI.GetSetting("AgeCheckFrequencySecs")), "AgeTimer")