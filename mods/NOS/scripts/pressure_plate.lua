function SetPlateActivated(isActivated)
    this:SetSharedObjectProperty("IsActivated", isActivated)  

    local trapTemplateId = this:GetObjVar("TrapTemplate")
    if (trapTemplateId ~= nil) then
        local trapObj = FindObjects(SearchTemplate(trapTemplateId,10)) 
        if( trapObj ~= nil) then
            for i,j in pairs(trapObj) do
                j:SetSharedObjectProperty("IsTriggered", isActivated)
            end
        end
    end
end

RegisterEventHandler(EventType.EnterView, "Activate", 
    function(user)
        if (IsDead(user) or user:HasModule("npe_magical_guide")) then
          return
        end
        SetPlateActivated(true)
    end)

RegisterEventHandler(EventType.LeaveView, "Activate", 
    function(user)
        local mobileObjects = GetViewObjects("Activate")
        if(#mobileObjects == 0) then
            SetPlateActivated(false)
        end
    end)

AddView("Activate", SearchMobileInRange(1.0, true))

RegisterEventHandler(EventType.Message,"UseObject",
    function(user, usedType)
        if(usedType == "Use") then
            user:PathTo(this:GetLoc(),ServerSettings.Stats.RunSpeedModifier)
        end
    end)