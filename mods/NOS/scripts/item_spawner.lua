SPAWN_DELAY_SECS = 60*5
SPAWN_REMOVE_SECS = 60*20

if (initializer ~= nil) then
	this:SetObjVar("ItemTemplates",initializer.ItemTemplates)
	this:SetObjVar("ItemLocations",initializer.ItemLocations)
	this:SetObjVar("MaxItems"     ,initializer.MaxItems)
	SPAWN_REMOVE_SECS = SPAWN_DELAY_SECS * initializer.MaxItems
	this:SetObjVar("ItemInstances",{})
end

RegisterEventHandler(EventType.Timer,"item_spawn",
	function ()
		--DebugMessage("item_spawn")
		itemInstances = this:GetObjVar("ItemInstances")
		maxItems 	  = this:GetObjVar("MaxItems")
		itemLocations = this:GetObjVar("ItemLocations")
		itemTemplates = this:GetObjVar("ItemTemplates")
		--Spawn a new item
		if (#itemInstances < maxItems) then
			local nextItem = itemTemplates[math.random(1,#itemTemplates)]
			local i = math.random(1,#itemLocations)
			local start = i
			local stop = false
			while stop == false do --(start + #itemLocations >= i) do
				if (i % #itemLocations ~= 0) then--don't go to zero
					if itemLocations[i % #itemLocations].Occupied ~= true then
						i = i % #itemLocations
						--DebugMessage("location found")
						stop = true
					end
					if start + #itemLocations > i then stop = true end
				end
				if (stop ~= true) then
					i = i + 1
				end
			end
			--DebugMessage("item spawning")
			CreateObj(nextItem, itemLocations[i].Location, "item_spawned", itemLocations[i].Location)
		end
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(SPAWN_DELAY_SECS),"item_spawn")
	end)

RegisterEventHandler(EventType.Timer,"delete_item",
	function (item,location)
		--DebugMessage("delete_item")
		--DFB TODO: Check if players are around before despawning
		if (item ~= nil) then 
			itemLocations = this:GetObjVar("ItemLocations")
			for i,j in pairs(itemLocations) do
				if (tostring(j.Location) == tostring(item:GetLoc())) then
					j.Occupied = false --unmark the location
					item:Destroy() -- if it's still there delete it
					table.remove(itemInstances,item)
					--DebugMessage("item removed")
					this:SetObjVar("ItemInstances",itemInstances)
				end
			end
		end
	end)

RegisterEventHandler(EventType.CreatedObject,"item_spawned",
	function (success,objRef,location)
		SetItemTooltip(objRef)
		--DebugMessage("item_spawned")
		itemInstances = this:GetObjVar("ItemInstances")
		itemLocations = this:GetObjVar("ItemLocations")
		for i,j in pairs(itemLocations) do
			if (tostring(j.Location) == tostring(location)) then
				j.Occupied = true --if the location's occupied mark it
				--DebugMessage("location occupied")
			end
		end
		table.insert(itemInstances,{Object = objRef,Location = location}) --added it to list of items
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(SPAWN_REMOVE_SECS),"delete_item",objref,location) --limited time only
		this:SetObjVar("ItemInstances",itemInstances) 
	end)

this:ScheduleTimerDelay(TimeSpan.FromSeconds(SPAWN_DELAY_SECS),"item_spawn")
this:FireTimer("item_spawn")