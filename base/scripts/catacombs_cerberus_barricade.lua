RegisterEventHandler(EventType.Message, "OnDoorOpen", 
    function()              
        this:SetSharedObjectProperty("IsTriggered", false)  
        this:ClearCollisionBounds()      
    end)

RegisterEventHandler(EventType.Message, "OnDoorClose", 
    function()              
        this:SetSharedObjectProperty("IsTriggered", true)        
        this:SetCollisionBoundsFromTemplate(this:GetCreationTemplateId())
    end)