RegisterEventHandler(EventType.Timer,"CheckStatueInBackpack",function ( ... )
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(4),"CheckStatueInBackpack")
	local topmost = this:TopmostContainer()
	if (topmost == nil) then
		this:Destroy()
		return
	end
	local backpackObj = topmost:GetEquippedObject("Backpack")
	local list = FindItemsInContainerRecursive(backpackObj,
        function(item)            
            return item:GetCreationTemplateId() == this:GetObjVar("SummonObjTemplate")
        end)
	if (list == nil or #list == 0) then
		this:Destroy()
		return
	end
end)
this:ScheduleTimerDelay(TimeSpan.FromSeconds(4),"CheckStatueInBackpack")
