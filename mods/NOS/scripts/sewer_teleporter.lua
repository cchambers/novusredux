require 'teleporter'

OverrideEventHandler("default:teleporter",EventType.Message, "UseObject", 
    function(user,usedType)
    	if(usedType == "Use" or usedType == "Activate") then 
    		if (user:GetObjVar("PickedProfession") == false) then
    			user:SendMessage("NewbieLeaveTown")
    		else
	    		ActivateTeleporter(user)
	    	end
    	elseif(usedType == "Set Destination") then
    		ShowSetDestinationWindow(user)
    	end
    end)