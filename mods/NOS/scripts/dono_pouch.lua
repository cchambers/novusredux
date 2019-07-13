require "NOS:container"

RegisterEventHandler(
	EventType.ContainerItemAdded,
	"",
	function(addedObj)
		-- coins
		local total = this:GetObjVar("DonationWorth")
		if (addedObj:GetObjVar("ResourceType") == "coins") then
			total = total + addedObj:GetObjVar("StackCount")
			addedObj:Destroy()
		elseif (addedObj:IsContainer()) then
			local objects = FindItemsInContainerRecursive(addedObj)
			for i, j in pairs(objects) do
				local randomLoc = GetRandomDropPosition(this)
				j:MoveToContainer(this, randomLoc)
			end
			CallFunctionDelayed(TimeSpan.FromSeconds(2), function() 
				addedObj:Destroy()
			end)
		else
			local value = GetItemValue(addedObj) or 1
			if (value < 5) then
				value = 5
			end
			total = total + value
			addedObj:Destroy()
		end
		this:SendMessage("RefreshWeight")
		this:SetObjVar("DonationWorth", total)
		SetItemTooltip(this)
	end
)

RegisterEventHandler(EventType.ModuleAttached, "dono_pouch", HandleModuleLoaded)
