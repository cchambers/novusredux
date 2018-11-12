LootTables = {}

local mItemsToSpawn = 0

-- LootTables is an array of loot tables
-- Each table can have the following values
--   NumCoins - The number of coins to spawn in the container

function LootTables.SpawnLoot(lootTables,destContainer)
	--DebugMessage(1)
	-- fill the mob's backpack
	if( lootTables ~= nil ) then
		-- if this mob has money
		--D*ebugTable(curLootTable)
		--DebugMessage(2)
		mItemsToSpawn = 0

		-- DAB TODO: Remove this when we figure out what mob it is
		for key, subTable in pairs(lootTables) do			
			if(type(subTable) ~= "table") then
				DebugMessage("ERROR: Invalid loot table for mob: "..this:GetCreationTemplateId())
				lootTables[key] = {}
			end
		end

		-- add up all the coins
		local totalCoins = 0
		for key, subTable in pairs(lootTables) do
			local numCoins = subTable.NumCoins or 0
			if(subTable.NumCoinsMin or subTable.NumCoinsMax) then
				numCoins = math.random((subTable.NumCoinsMin or 0),(subTable.NumCoinsMax or 0))
			end
			totalCoins = totalCoins + numCoins
		end
		if(totalCoins > 0) then
			local dropPos = GetRandomDropPosition(destContainer)
			CreateObjInContainer("coin_purse", destContainer, dropPos, "LootCoinPurse", totalCoins)
		end
		
		for key, subTable in pairs(lootTables) do
			--DebugMessage(3)
			-- if the mob has items
			if( subTable.LootItems ~= nil ) then
				local itemCount = subTable.NumItems or 0
				if(subTable.NumItemsMin or subTable.NumItemsMax) then
					itemCount = math.random((subTable.NumItemsMin or 0),(subTable.NumItemsMax or 0))
				end
				--DebugMessage("MIN: "..subTable.MinItems..", MAX: "..subTable.MaxItems..", COUNT: "..itemCount)
				if(itemCount > 0) then
					--DebugMessage(DumpTable(subTable.LootItems))
					local availableItems = FilterLootItemsByChance(subTable.LootItems)

					--DebugMessage(DumpTable(availableItems))		
					for i=1,itemCount do
						if( #availableItems > 0 ) then
							local itemIndex = GetRandomLootItemIndex(availableItems)
							local itemTemplateId = availableItems[itemIndex].Template
							local color = availableItems[itemIndex].Color
							local stackCount = availableItems[itemIndex].StackCount or 1
							if(availableItems[itemIndex].StackCountMin or availableItems[itemIndex].StackCountMax) then
								stackCount = math.random((availableItems[itemIndex].StackCountMin or 0),(availableItems[itemIndex].StackCountMax or 0))
							end
							--DebugMessage("itemIndex is "..tostring(itemIndex))
							--DebugMessage(tostring(availableItems[itemIndex]).." is bleh")
							--DebugMessage(tostring(availableItems[itemIndex].Templates).." is narm")
							-- if its unique then remove it from the list

							if (availableItems[itemIndex].Templates ~= nil) then
								for index,template in pairs(availableItems[itemIndex].Templates) do

									local dropPos = GetRandomDropPosition(destContainer)
								--DebugMessage("itemTemplateId: "..(tostring(template)))
									CreateObjInContainer(template, destContainer, dropPos, "LootObject",stackCount,color)
								end

							else
								if( availableItems[itemIndex].Unique == true ) then
								
									table.remove(availableItems,itemIndex)
								end
								local dropPos = GetRandomDropPosition(destContainer)
								--DebugMessage("itemTemplateId: "..(tostring(itemTemplateId)))

								CreateObjInContainer(itemTemplateId, destContainer, dropPos, "LootObject",stackCount,color)
							end

							mItemsToSpawn = mItemsToSpawn + 1
						end
					end					
				end
			end
		end
	end
end

function HandleCoinPurseCreated(success, objref, numCoins)
	if( success == true ) then
		-- fill the mob's backpack
		if( numCoins ~= nil and numCoins > 0 ) then			
			RequestSetStackCount(objref,numCoins)
		end
	end
end


function DistributeBossRewards(nearbyCombatants, lootTables)
	for i,j in pairs(nearbyCombatants) do
        local skipPlayer = false
        if (IsDead(j)) then skipPlayer = true end

        if not (skipPlayer) then
            local backpackObj = j:GetEquippedObject("Backpack")
            if (backpackObj ~= nil) then
	            backpackObj:SendOpenContainer(j)
	            LootTables.SpawnLoot(lootTables, backpackObj)
	            j:SystemMessage("You have been rewarded for defeating the boss.")
	        end
        end
    end
end

RegisterEventHandler(EventType.CreatedObject, "LootCoinPurse", HandleCoinPurseCreated)

RegisterEventHandler(EventType.CreatedObject, "LootObject", 
	function (success,objref,stackCount,color)		
		mItemsToSpawn = mItemsToSpawn - 1

		if (color ~= nil) then
			objref:SetColor(color)
		end
		if (stackCount>1) then
			RequestSetStack(objref,stackCount)
		end

		SetItemTooltip(objref)
	end)
