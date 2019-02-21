require 'container'

RegisterEventHandler(EventType.ContainerItemAdded, "", 
    function(addedObj)
		-- coins
		local total = this:GetObjVar("DonationWorth")
		if(addedObj:GetObjVar("ResourceType") == "coins") then
			total = total + addedObj:GetObjVar("StackCount")
			addedObj:Destroy()
		else
			local value = GetItemValue(addedObj) or 1
			DebugMessage(value)
			if (value < 5) then value = 5 end
			DebugMessage(tostring("+" .. value))
			total = total + value
			addedObj:Destroy()
		end

		this:SendMessage("RefreshWeight")
		this:SetObjVar("DonationWorth", total)

		SetItemTooltip(this)
	end)

	RegisterEventHandler(EventType.ModuleAttached, "dono_pouch", HandleModuleLoaded)