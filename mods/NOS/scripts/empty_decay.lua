function CheckDecay()
	CallFunctionDelayed(TimeSpan.FromSeconds(5), function()
		if ( #this:GetContainedObjects() == 0 ) then
			local topmost = this:TopmostContainer() or this
			topmost:ScheduleDecay(TimeSpan.FromSeconds(60))
			this:DelModule("empty_decay")
		end
	end, "delay")
end

RegisterEventHandler(EventType.ContainerItemRemoved, "", function(contObj)
	CheckDecay()
end)

RegisterEventHandler(EventType.ModuleAttached, "empty_decay", function()
	CheckDecay()
end)