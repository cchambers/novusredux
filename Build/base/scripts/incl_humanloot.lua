function EquipMobile(equipTable,lootTables,destroyExistingItems,spawnLoot,ignoreBodyParts)	
	--DebugMessage("EquipMobile: "..DumpTable(equipTable).."\n\n"..tostring(lootTables),tostring(destroyExistingItems),tostring(ignoreBodyParts))
	-- store this for later
	for i,equipObj in pairs(this:GetAllEquippedObjects()) do
		local slotName = GetEquipSlot(equipObj)
		local isItemSlot = IsItemSlot(slotName)

		local shouldDestroy = false
		if(slotName == "Backpack" and destroyExistingItems) then
			equipObj:Destroy()
		elseif(isItemSlot and equipTable ~= nil) then
			equipObj:Destroy()
		elseif(not(isItemSlot) and not(ignoreBodyParts)) then
			equipObj:Destroy()
		end
	end

	if(lootTables ~= nil and not(spawnLoot)) then
		this:SetObjVar("LootTables",lootTables)		
	end

	-- if we already have a backpack and we should spawn loot just do it
	local backpackObj = this:GetEquippedObject("Backpack")	
	if(spawnLoot and backpackObj) then
		LootTables.SpawnLoot(lootTables,backpackObj)
	end

	local hairColor = nil

	-- if we have loot but no equipment just make a backpack to put the loot in
	if( equipTable == nil and lootTables ~= nil and backpackObj == nil) then
		--DebugMessage("Creating backpack")
		if(spawnLoot) then
			CreateEquippedObj("backpack", this, "humanloot_backpack",nil,lootTables)
		else
			CreateEquippedObj("backpack", this, "humanloot_backpack")
		end
	elseif(equipTable ~= nil) then
		for slot,templates in pairs(equipTable) do
			--DebugMessage("DOING",DumpTable(templates),tostring(slot),tostring(ignoreBodyParts),tostring(IsItemSlot(slot)))
			if not(ignoreBodyParts) or IsItemSlot(slot) or slot == "Backpack" then
				local templateName = ""
				local templateHue = nil

				if(#templates > 0) then
					if (type(templates[1]) == "table") then
							-- if this is not nil we are using the
							-- advanced loot table version
							if(templates[1].Template ~= nil) then
								local availableItems = FilterLootItemsByChance(templates)
								local itemIndex = GetRandomLootItemIndex(availableItems)
								if(itemIndex and availableItems[itemIndex]) then
									templateName = availableItems[itemIndex].Template
									templateHue = availableItems[itemIndex].Hue
								end
							else
								local equipEntry = templates[math.random(1,#templates)]
								
								if (type(equipEntry) == "string") then
									templateName = equipEntry
								elseif (type(equipEntry) == "table") then
									templateName = equipEntry[1]
									templateHue = equipEntry[2]
								end
							end
					elseif (type(templates[1]) == "string") then
						templateName = templates[1]
						if (#templates > 1) then
							templateHue = templates[2]
						end
					end
				end
				--DebugMessage("templateName is "..tostring(templateName))
				--DebugMessage("templateHue is "..tostring(templateHue))
				--DebugMessage("slot is "..tostring(slot))


				--get a hue if it has one, then set it
				if( templateName ~= "" ) then
					--DebugMessage("CHECK!")
					-- destroyExistingItems destroys the backpack on the next frame so you can't check for nil here
					if( slot == "Backpack" and (backpackObj == nil or destroyExistingItems) ) then
						--DebugMessage("SPAWN!")
						if(spawnLoot) then
							CreateEquippedObj(templateName, this, "humanloot_backpack", templateHue, lootTables)
						else
							CreateEquippedObj(templateName, this, "humanloot_backpack", templateHue)
						end
					else
						--DebugMessage("--CREATE "..templateName)		
						if (slot == "BodyPartHead" and templateHue) then
							if(type(templateHue) == "number") then
								this:SetHue(templateHue)
							else
								this:SetColor(templateHue)
							end
						-- Change facial hair color or hair color if color is different from one another
						elseif (slot == "BodyPartHair" or slot == "BodyPartFacialHair") and (templateHue or hairColor) then
							if (hairColor == nil) then
								hairColor = templateHue
							else
								templateHue = hairColor
							end
						end
						if(templateName == nil or templateName == "" or templateName == "nil") then
							DebugMessage("Attempt to create nil object from creator: " .. this:GetName())
						else
							CreateEquippedObj(templateName, this, "humanloot_equipped", templateHue)
						end
					end
				else
					--DebugMessage("--SKIP (DESTROY): "..slot)
					local currentEquipped = this:GetEquippedObject(slot)
					if (currentEquipped ~= nil) then
						currentEquipped:Destroy()
					end

					-- DAB HACK: Hack to set body hue from equipment defines in template
					if(templateHue and slot=="BodyPartHead") then
						--DebugMessage("AAA",tostring(templateHue))
						if(type(templateHue) == "number") then
							this:SetHue(templateHue)
						else
							this:SetColor(templateHue)
						end
					end
				end
			end
		end		
	end
end

function HandleBackpackCreated(success, objref, hue, lootTables)	
	if (hue ~= nil) then
		if(type(hue) == "number") then
			objref:SetHue(hue)
		else
			objref:SetColor(hue)
		end
	end

	if(lootTables) then
		LootTables.SpawnLoot(lootTables,objref)
	end

	local name,color = StripColorFromString(objref:GetName())	
	name = StripColorFromString(this:GetName()) .. "'s Backpack"
	if(color) then
		name = color .. name .. "[-]"
	end
	objref:SetName(name)
end

function HandleEquippedObjectCreated(success, objref, hue)
	--if (objRef ~= nil) then 
	--	DebugMessage(objRef:GetName())
	--end
	--DebugMessage(tostring(success).." and " ..tostring(objref))
	if (hue ~= nil) then
		if(type(hue) == "number") then
			objref:SetHue(hue)
		else
			objref:SetColor(hue)
		end
	end
	if ( IsPlayerCharacter(this) ) then
		SetItemTooltip(objref)
	end
end

RegisterEventHandler(EventType.CreatedObject, "humanloot_backpack", HandleBackpackCreated)
RegisterEventHandler(EventType.CreatedObject, "humanloot_equipped", HandleEquippedObjectCreated)