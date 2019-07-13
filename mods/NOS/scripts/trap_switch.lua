RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Use") then return end
        
        local isActivated = not this:GetSharedObjectProperty("IsActivated");            
        this:SetSharedObjectProperty("IsActivated", isActivated)       

        local trapTemplateId = this:GetObjVar("TrapTemplate")
        if( trapTemplateId ~= nil ) then
            local trapObj = FindObject(SearchTemplate(trapTemplateId,10)) 
            if( trapObj ~= nil) then
                if(isActivated) then
                    trapObj:SetSharedObjectProperty("IsTriggered", true)
                    --DebugMessage("Closing trap")
                else
                    trapObj:SetSharedObjectProperty("IsTriggered", false)
                    --DebugMessage("Opening trap")
                end
            end
        end
    end)