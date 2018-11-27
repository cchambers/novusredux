LootTables = {}

-- LootTables is an array of loot tables
-- Each table can have the following values
--   NumCoins - The number of coins to spawn in the container
-- NOTE: itemCreatedOverride should still call LootItemCreated to set stack, color etc
function LootTables.SpawnLoot(lootTables,destContainer,objVars)
	--DebugMessage(1)
	-- fill the mob's backpack
	if( lootTables ~= nil ) then
		-- if this mob has money
		--D*ebugTable(curLootTable)
		--DebugMessage(2)

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
			CreateObjInContainer("coin_purse", destContainer, dropPos, "LootCoinPurse", totalCoins,objVars)
			RegisterSingleEventHandler(EventType.CreatedObject, "LootCoinPurse", LootCoinPurseCreated)
		end
		
		local itemsSpawned = {}
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
									CreateObjInContainer(template, destContainer, dropPos, "LootObject",stackCount,color,callback,objVars)
									table.insert(itemsSpawned, template)
								end

							else								
								local dropPos = GetRandomDropPosition(destContainer)

								if(availableItems[itemIndex].Packed) then
									CreatePackedObjectInContainer(itemTemplateId,false,destContainer,dropPos,"LootObject")
									table.insert(itemsSpawned, itemTemplateId)
								else
									CreateObjInContainer(itemTemplateId, destContainer, dropPos, "LootObject",stackCount,color,objVars)
									table.insert(itemsSpawned, itemTemplateId)
								end

								if( availableItems[itemIndex].Unique == true ) then								
									table.remove(availableItems,itemIndex)
								end
							end
							--itemsSpawned = itemsSpawned + 1
						end
					end					
				end
			end
		end

		if(#itemsSpawned > 0) then			
			-- NOTE: This never gets unregistered
			RegisterEventHandler(EventType.CreatedObject, "LootObject", LootItemCreated)
		end
		return itemsSpawned
	end
end

function DistributeBossRewards(nearbyCombatants, lootTables, achievementName)
	for i,j in pairs(nearbyCombatants) do
        local skipPlayer = false
        if (IsDead(j)) then skipPlayer = true end

        if not (skipPlayer) then

        	if (achievementName ~= nil) then
        		CheckAchievementStatus(j, "BossKills", achievementName, 1)
        	end

        	if (lootTables == nil) then
        		return
        	end

            local backpackObj = j:GetEquippedObject("Backpack")
            if (backpackObj ~= nil) then
	            backpackObj:SendOpenContainer(j)
	            LootTables.SpawnLoot(lootTables, backpackObj)
	            j:SystemMessage("You have been rewarded for defeating the boss.","info")
	        end
        end
    end
end

function LootItemCreated(success,objref,stackCount,color,objVars)
	if (color ~= nil) then
		objref:SetColor(color)
	end
	if (stackCount>1) then
		RequestSetStack(objref,stackCount)
	end

	SetItemTooltip(objref)

	if (objVars ~= nil) then
		for i, j in pairs(objVars) do
			objref:SetObjVar(i, j)
		end
	end
end

function LootCoinPurseCreated(success,objRef,numCoins,objVars)
	if( success == true ) then
		-- fill the mob's backpack
		if( numCoins ~= nil and numCoins > 0 ) then			
				objRef:SendMessage("SetCoins",{Gold = numCoins})
		end
	end
end