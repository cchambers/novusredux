require 'container'

function HandleModuleLoaded() 
	-- this:SetObjVar("DonationsWorth")
end

RegisterEventHandler(EventType.ContainerItemAdded, "", 
    function(addedObj)
		-- coins
		local total = this:GetObjVar("DonationWorth")
		if(addedObj:GetObjVar("ResourceType") == "coins") then
			total = total + addedObj:GetObjVar("StackCount")
			addedObj:Destroy()
		else
			local value = GetItemValue(addedObj) or 1
			if (value < 1) then value = 1 end
			total = total + total
			addedObj:Destroy()
		end

		this:SendMessage("RefreshWeight")
		this:SetObjVar("DonationWorth", total)

		while true do
			total, k = string.gsub(total, "^(-?%d+)(%d%d%d)", "%1,%2")
			if (k == 0) then
				break
			end
		end

		SetTooltipEntry(this,"worth","Worth: " .. total .. "g")
	end)

	RegisterEventHandler(EventType.ModuleAttached, "dono_pouch", HandleModuleLoaded)