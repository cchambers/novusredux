require 'map_markers'
MobsSlain = 0
--TaskInfo = nil
--Hireling = nil
TOTAL_MOB_COUNT = 2

function EndRHirelingDiversion(taskComplete, fromHireling)
    RemoveDynamicMapMarker(this, "RHirelingTask")
    local hireling = this:GetObjVar("RHireling")
    if not (fromHireling) then
        if (hireling ~= nil) then
            if (hireling:IsValid()) then
                hireling:SendMessage("EndRHirelingDiversion", taskComplete)
            end
        end
    end
    this:DelObjVar("RHireling")
    this:DelObjVar("RHirelingTask")
    this:DelObjVar("TaskInfo")
    this:DelModule(GetCurrentModule())
end

function CompleteTask(user)
    local hireling = this:GetObjVar("RHireling")
    if (hireling ~= nil) then
            if (hireling:IsValid()) then
                hireling:SendMessage("CompleteTask", this)
            end
        end
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
    function()
    end)

RegisterEventHandler(EventType.Message, "InitHireling",
    function (hireling)
        MobsSlain = 0
        this:SetObjVar("RHireling", hireling)
        this:SetObjVar("TaskInfo", hireling:GetObjVar("RHirelingTask"))
        local taskInfo = this:GetObjVar ("TaskInfo")
        if (taskInfo.Count ~= nil) then
            TOTAL_MOB_COUNT = taskInfo.Count
        end
    end)

RegisterEventHandler(EventType.Message, "EndRHirelingDiversion",
    function (taskComplete)
        EndRHirelingDiversion(taskComplete, true)
    end)

RegisterEventHandler(EventType.Message, "VictimKilled",
    function (victim)
        local taskInfo = this:GetObjVar("TaskInfo")
        if (this:IsInRegion("Area-"..taskInfo.RegionalName) or GetRegionalName(this:GetLoc()) == taskInfo.RegionalName) then
            --local victimTemplateData = GetTemmplateData(victim:GetCreationTemplateId())
            --DebugMessage(victim:GetCreationTemplateId().."  "..TaskInfo.Template)
            if (victim:GetCreationTemplateId() == taskInfo.Template) then
                if (MobsSlain < TOTAL_MOB_COUNT) then
                    MobsSlain = MobsSlain + 1
                else
                    CompleteTask(this)
                    --EndRHirelingDiversion(true)
                end
            else
            end
        end
    end)

RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
        EndRHirelingDiversion(false)
    end)

RegisterEventHandler(EventType.Message, "EnteredRegionalName",
    function(regionalName)
        local taskInfo = this:GetObjVar("TaskInfo")
        if (taskInfo ~= nil) then
            if (regionalName ~= taskInfo.RegionalName) then
                RemoveDynamicMapMarker(this, "RHirelingTask")
            end
        end
    end)

RegisterEventHandler(EventType.LoadedFromBackup, "", 
    function()
        local hireling = this:GetObjVar("RHireling")
        if (hireling == nil or hireling:IsValid() == false) then
                EndRHirelingDiversion()
        end
    end)