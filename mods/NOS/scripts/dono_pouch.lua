require "container"

RegisterEventHandler(
	EventType.ContainerItemAdded,
	"",
	function(addedObj)
		-- coins


		if (addedObj:IsContainer()) then
			local objects = FindItemsInContainerRecursive(addedObj)
			for i, j in pairs(objects) do
				local randomLoc = GetRandomDropPosition(this)
				j:MoveToContainer(this, randomLoc)
			end
		elseif (addedObj:GetObjVar("ResourceType") == "coins") then
			local total = this:GetObjVar("DonationWorth")
			total = total + addedObj:GetObjVar("StackCount")
			this:SetObjVar("DonationWorth", total)
			addedObj:Destroy()
		else
			local value = GetItemValue(addedObj) or 1
			if (value < 5) then
				value = 5
			end
			if (addedObj:HasObjVar("StackCount")) then
				value = value * addedObj:GetObjVar("StackCount")
			end
			
			local total = this:GetObjVar("DonationWorth")
			total = total + value
			this:SetObjVar("DonationWorth", total)
			addedObj:Destroy()
		end
		this:SendMessage("RefreshWeight")
		SetItemTooltip(this)
	end
)

-- RegisterEventHandler(EventType.ModuleAttached, "dono_pouch", HandleModuleLoaded)
