require 'container'

RegisterEventHandler(EventType.ContainerItemAdded, "", 
    function(addedObj)
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "auto_delete"..addedObj.Id, addedObj)

        RegisterEventHandler(EventType.Timer,"auto_delete"..addedObj.Id,
            function()
                if(addedObj:IsValid() and addedObj:ContainedBy() == this) then
                    -- addedObj:Destroy()
                    local donoBoxes = FindObjectsWithTag("Donation_Box")
                    for k, v in pairs(donoBoxes) do 
                        local box = donoBoxes[k]
			            local randomLoc = GetRandomDropPosition(box)
                        addedObj:MoveToContainer(box, randomLoc)
                        break
                    end
                    CallFunctionDelayed(TimeSpan.FromSeconds(1), HandleContentsChanged)
                end
                UnregisterEventHandler("container_autodelete",EventType.Timer,"autodelete"..addedObj.Id)
            end)
    end)

RegisterSingleEventHandler(EventType.ModuleAttached,"container_autodelete",
	function ()
		SetTooltipEntry(this,"autodelete","[$1771]")
    end)