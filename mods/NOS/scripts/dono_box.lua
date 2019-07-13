require 'NOS:container'

RegisterEventHandler(EventType.ContainerItemAdded, "", 
    function(addedObj)
		-- coins
		local worth = addedObj:GetObjVar("DonationWorth")
		if(addedObj:GetObjVar("ResourceType") == "coins") then
			DebugMessage("Gold added...");
			PowerHourDonate(addedObj:GetObjVar("StackCount"))
			addedObj:Destroy()
    		-- get amount, credit to total, destroy.
		elseif (worth ~= nil) then
			PowerHourDonate(worth)
			addedObj:Destroy()
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
