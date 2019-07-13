require 'container'

RegisterEventHandler(EventType.ContainerItemAdded, "", 
    function(addedObj)
    	if(addedObj:GetObjVar("ResourceType") == "coins") then
    		addedObj:SendMessage("ChangeUp")
    	end
    end)