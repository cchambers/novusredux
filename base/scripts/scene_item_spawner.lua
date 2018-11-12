SPAWN_DELAY_SECS = 60*60

-- first time setup
if(initializer ~= nil) then
	local itemContainers = {}
	if initializer.ItemContainers ~= nil then
		for index, itemEntry in pairs(initializer.ItemContainers) do
			local findResult = FindObjects(SearchMulti(
	      		{
	      			SearchObjVar("itemContainer",itemEntry.Name),
					SearchObjectInRange(10),
	  			}))

			if( #findResult > 0 ) then				
				local contObj = findResult[1]

				itemContainers[itemEntry.Name] = contObj

				if(itemEntry.DisplayName ~= nil) then
					contObj:SetName(itemEntry.DisplayName)
				end

				if(itemEntry.TooltipStr ~= nil) then
					SetTooltipEntry(contObj,"scene_item_container",itemEntry.TooltipStr)
				end
			end
		end
	end
	itemInstances = {}
	if (initializer.ItemInventory ~= nil) then
		for index, itemEntry in pairs(initializer.ItemInventory) do
			if (itemEntry.RelativeLoc ~= nil) then
				if( itemEntry.Container ~= nil and itemContainers[itemEntry.Container] ~= nil) then
					itemLoc = ParseLoc(itemEntry.RelativeLoc)
				else
					itemLoc = this:GetLoc():Add(ParseLoc(itemEntry.RelativeLoc))
				end
			else
				itemLoc = ParseLoc(itemEntry.Loc)
			end
			
			local itemRot = Loc(0,0,0)
			local itemScale = Loc(1,1,1)
			if( itemEntry.Rotation ~= nil ) then
				itemRot = ParseLoc(itemEntry.Rotation)
			end

			if( itemLoc ~= nil) then
				local contObj = nil
				if( itemEntry.Container ~= nil and itemContainers[itemEntry.Container] ~= nil) then
					contObj = itemContainers[itemEntry.Container]				
				end

				if( itemEntry.Container ~= nil and contObj == nil ) then
					DebugMessage("ERROR: [HouseController:Init] Item container not found for item "..itemEntry.Template)
				else
					local args = 
					{
						Template = itemEntry.Template,
						Container = contObj,
						Location = itemLoc,
						Rotation = itemRot,
						Scale = itemScale
					}
					--table.insert(itemInstances,args)
					--DebugMessage("itemEntry.Template: "..tostring(itemEntry.Template).." Location:"..tostring(itemLoc))
					CreateObjExtended(itemEntry.Template,contObj,itemLoc,itemRot,itemScale,"house_item_created",args)
				end
			end
		end
	end
	this:SetObjVar("ItemInstances",itemInstances)
end

function HandleItemCreated(success,objRef,refTable)	
	if(success) then
		--attach an owned item script
		local itemInstances = this:GetObjVar("ItemInstances") or {}
		for i,j in pairs (itemInstances) do 
			if (j.Template == refTable.Template and j.Location == refTable.Location  ) then
				table.remove(itemInstances,i)
			end
		end
		local args = 
		{
			object = objRef,
			Template = refTable.Template,
			Container = refTable.Container,
			Location = refTable.Location,
			Rotation = refTable.Rotation,
			Scale = refTable.Scale
		}
		table.insert(itemInstances,args)
		--DebugMessage(DumpTable(itemInstances))
		--DebugMessage("Attaching owned module")
		this:SetObjVar("ItemInstances",itemInstances)
		objRef:AddModule("owned_item")
	end
end

RegisterEventHandler(EventType.CreatedObject, "house_item_created", HandleItemCreated)


RegisterEventHandler(EventType.Timer,"item_spawn",
	function ()
		--DebugMessage("item_spawn")
		local itemInstances = this:GetObjVar("ItemInstances") or {}
		--Spawn a new item
		for i,j in pairs (itemInstances) do
			--if the item is gone, doesn't exist, or it's nil for whatever reason, then respawn it
			if (j.object == nil or not j.object:IsValid() or j.object:GetLoc() ~= j.Location ) then
				--DebugMessage("item spawning")
					local args = 
					{
						Template = j.Template,
						Container = j.Container,
						Location = j.Location,
						Rotation = j.Rotation,
						Scale = j.Scale
					}
				CreateObjExtended(j.Template,j.Container,j.Location,j.Rotation,j.Scale,"house_item_created",args)
				--DFB NOTE: If there's anything special we do regarding items being discovered missing do it here
			end
		end
		this:SetObjVar("ItemInstances",itemInstances)
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(SPAWN_DELAY_SECS),"item_spawn")
	end)

this:ScheduleTimerDelay(TimeSpan.FromSeconds(SPAWN_DELAY_SECS),"item_spawn")