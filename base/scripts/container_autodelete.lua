require 'container'

RegisterEventHandler(EventType.ContainerItemAdded, "", 
    function(addedObj)
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "auto_delete"..addedObj.Id, addedObj)

        RegisterEventHandler(EventType.Timer,"auto_delete"..addedObj.Id,
            function()
                if(addedObj:IsValid() and addedObj:ContainedBy() == this) then
                    addedObj:Destroy()
                end
                UnregisterEventHandler("container_autodelete",EventType.Timer,"autodelete"..addedObj.Id)
            end)
    end)

RegisterSingleEventHandler(EventType.ModuleAttached,"container_autodelete",
	function ()
		SetTooltipEntry(this,"autodelete","[$1771]")
	end)