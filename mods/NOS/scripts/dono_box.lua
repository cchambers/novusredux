require 'container'

RegisterEventHandler(EventType.ContainerItemAdded, "", 
    function(addedObj)
		-- coins
		if(addedObj:GetObjVar("ResourceType") == "coins") then
			DebugMessage("That's a lotta dough!");
			PowerHourDonate(addedObj:GetObjVar("StackCount"))
			addedObj:Destroy()
    		-- get amount, credit to total, destroy.
		else
			addedObj:AddModule("dono_item")
		end
		
	end)
