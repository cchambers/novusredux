require 'container'

RegisterEventHandler(EventType.ContainerItemAdded, "", 
    function(addedObj)
		
		-- coins
		if(addedObj:GetObjVar("ResourceType") == "coins") then
    		-- get amount, credit to total, destroy.
		end
		

	end)
	