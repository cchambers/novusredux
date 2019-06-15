RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Use" and usedType ~= "Operate") then return end
        
        local doorTemplateId = this:GetObjVar("DoorTemplate")
        if( doorTemplateId ~= nil ) then
            local doorObjects = FindObjects(SearchTemplate(doorTemplateId,10)) 
            if( #doorObjects > 0) then
                -- assume there is only one door in range and use the first one            
                local doorObj = doorObjects[1]
                local isOpen = doorObj:GetSharedObjectProperty("IsOpen");
            
                if( isOpen ) then
                    doorObj:SetSharedObjectProperty("IsOpen", false)
                    doorObj:SetCollisionBoundsFromTemplate(doorObj:GetCreationTemplateId())
                    --DebugMessage("Closing door")
                else
                    doorObj:SetSharedObjectProperty("IsOpen", true)
                    doorObj:ClearCollisionBounds()
                    --DebugMessage("Opening door")
                end
            end
        end
    end)

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function()
        AddUseCase(this,"Operate",true)        
    end)