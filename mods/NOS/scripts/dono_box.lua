require 'container'

RegisterEventHandler(EventType.ContainerItemAdded, "", 
    function(addedObj)
		-- coins
		if(addedObj:GetObjVar("ResourceType") == "coins") then
			DebugMessage("Gold added...");
			PowerHourDonate(addedObj:GetObjVar("StackCount"))
			addedObj:Destroy()
    		-- get amount, credit to total, destroy.
		else
			addedObj:AddModule("dono_item")
		end
		
	end)


	RegisterEventHandler(EventType.ContainerItemRemoved, "", 
	function(itemRemoved)
		if (itemRemoved:HasModule("dono_item")) then
			itemRemoved:DelModule("dono_item")
			this:SendMessage("RefreshWeight")
		end
    end)
