require 'trapped_object'

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Use" and usedType ~= "Open/Close") then return end

    	if (this:HasTimer("CloseDoor")) then return end
        OpenDoor()
        TriggerTrap()
    end)

this:SetObjVar("ResetTime",5)

function CloseDoor()
    this:SetSharedObjectProperty("IsOpen", false)
    this:SetCollisionBoundsFromTemplate(this:GetCreationTemplateId())
    --DebugMessage("Closing door")
end
RegisterEventHandler(EventType.Timer,"CloseDoor",CloseDoor)
function OpenDoor()
    this:SetSharedObjectProperty("IsOpen", true)
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"CloseDoor")
    --this:ClearCollisionBounds()
end

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function()
        AddUseCase(this,"Open/Close",true)
    end)