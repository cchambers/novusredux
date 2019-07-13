function CheckDecay()
	CallFunctionDelayed(TimeSpan.FromSeconds(5), function()
		--DebugMessage(#this:GetContainedObjects() .. " Contained Object")
		if(#this:GetContainedObjects() == 0) then
			local topmost = this:TopmostContainer() or this
			topmost:SetObjVar("DecayTime",60)	
			topmost:SendMessage("UpdateDecay")
		end
	end,"delay")
end

RegisterEventHandler(EventType.ContainerItemRemoved, "", 
	function(contObj)
		CheckDecay()
	end)

RegisterEventHandler(EventType.ModuleAttached, "empty_decay",
	function()
		CheckDecay()
	end)