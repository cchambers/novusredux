--Return a collection of orders that they have learned, and match their skill level.
function GetMinimumCraftingOrders(user)
	--DebugMessage(GetSkillLevel(user, "MetalsmithSkill"))
	local minSkillOrders = {}
	local knownRecipes = user:GetObjVar("AvailableRecipies") or {}
	local craftOrderSkill = this:GetObjVar("CraftOrderSkill")
	local recipeTable = GetRecipeTableFromSkill(craftOrderSkill)

	if (recipeTable ~= nil) then
		for i, order in pairs(CraftingOrderTable.CraftingOrders) do
			if (recipeTable[order.Recipe] ~= nil) then
				local material = order.Material or nil
				--If they have the skill
				if (HasRequiredCraftingSkill(user, order.Recipe, craftOrderSkill, material)) then
					local hasMaterialRecipe = true
					if(material ~= nil and recipeTable[material].NeedRecipe) then
						hasMaterialRecipe = knownRecipes[material]
					end

					local hasOrderRecipe = true
					if (recipeTable[order.Recipe].NeedRecipe) then 
						hasOrderRecipe = knownRecipes[order.Recipe]
					end

					--If they don't need a recipe, or if the order doesn't require a material
					if (hasMaterialRecipe and hasOrderRecipe) then
						minSkillOrders[#minSkillOrders + 1] = order
					end
				end
			else
				--DebugMessage("[Recipe "..order.Recipe.." does not exist]")
			end
		end
	end
	return minSkillOrders
end

--Returns a random crafting order based on a weighted random number.
function PickCraftingOrder(user)

	if (CraftingOrderTable == nil) then
		CraftingOrderTable = CraftingOrderDefines[this:GetObjVar("CraftOrderSkill")]
	end

	--Get known orders matching skill
	local availableOrders = GetMinimumCraftingOrders(user)
	local selectedOrder = nil

	if (#availableOrders > 0) then
		local weightScores = {}

		for i = 1, #availableOrders, 1 do
			local order = availableOrders[i]
			--Add Skill Weight
			weightScores[i] = (weightScores[i] or 0) + GetRecipeSkillRequired(order.Recipe, order.Material)

			--Add Material Weight
			weightScores[i] = weightScores[i] + GetCraftingOrderMaterialWeight(user, order)

			--Add Amount Weight
			--DebugMessage(GetCraftingOrderAmountWeight(user, order))
			weightScores[i] = weightScores[i] + GetCraftingOrderAmountWeight(user, order)

			weightScores[i] = weightScores[i] * weightScores[i]
		end

		--Sort by total score
		local sortedTable = {}
		for recipeIndex, score in pairs(weightScores) do 
			table.insert(sortedTable, {recipeIndex, score}) 
		end
		table.sort(sortedTable, function(a, b) return a[2] < b[2] end)

		--Get the weight sum
		local weightSum = 0
		--!Numerical loop!--
		for i, j in ipairs(sortedTable) do
			weightSum = weightSum + j[2]
		end

		--Pick a random weight
		local randomWeight = math.random(weightSum/2, weightSum)
		weightSum = 0
		--user:SystemMessage("___________________________________")

		--!Numerical loop!--
		for i, j in ipairs(sortedTable) do
			weightSum = weightSum + j[2]

			--local order = availableOrders[j[1]]
			--[[
			local material = order.Material or ""
			user:SystemMessage(order.Amount.." "..material.." "..order.Recipe)
			user:SystemMessage("Sum Weight: "..j[2].." TotalWeight: "..weightSum.." Random Weight:"..randomWeight)

			]]--
			if (weightSum >= randomWeight and selectedOrder == nil) then
				selectedOrder = availableOrders[j[1]]
			end
		end

		if (selectedOrder ~= nil) then
			return selectedOrder
		end
		DebugMessage("No available crafting orders. Picking random order.")
		return availableOrders[math.random(1, #availableOrders)]
	else
		return nil
	end
end

function GetCraftingOrderAmountWeight(user, order)

	local currentWeight = 1
	for i, j in pairs(CraftingOrderTable["AmountWeights"]) do
		--user:SystemMessage(j.Amount.." "..order.Amount)

		currentWeight = j.Weight

		if (j.Amount >= order.Amount) then
			return tonumber(j.Weight)
		end
	end
	return currentWeight
end

function GetCraftingOrderMaterialWeight(user, order)
	local weight = 0
	if (CraftingOrderTable["MaterialWeights"][order.Material] ~= nil) then
		weight = CraftingOrderTable["MaterialWeights"][order.Material]
	else
		weight = CraftingOrderTable["MaterialWeights"]["Default"]
	end
	return weight
end

function AddCommission(user, orderInfo)
	--If player is already commissioned, pull up corresponding order and set new order info
	if (GetCommission(user) ~= nil) then return end
	local commissions = this:GetObjVar("Commissions") or {}

	--Commission includes the order info, and wether it's been accepted by the player
	commissions[user] = {orderInfo, false}
	this:SetObjVar("Commissions", commissions)
end

function GetCommission(user)
	local commissions = this:GetObjVar("Commissions")
	if (commissions ~= nil) then
		if (commissions[user] ~= nil) then return commissions[user] end
	end
	return nil
end

function CommissionAccepted(user)
	local commissions = this:GetObjVar("Commissions")
	if (commissions	== nil) then return nil end
	commissions[user][2] = true
	this:SetObjVar("Commissions", commissions)
end

function HandleOrderSubmission(target, user)
    if (target == nil) then return end

    text = ""
    response = {}

    response[1] = {}
    response[1].text = ""
    response[1].handle = "Close" 
    
    local orderInfo = target:GetObjVar("OrderInfo")
    local orderOwner = target:GetObjVar("OrderOwner")
    
    --If there's no owner, continue anyways (useful for orders created using /create).
    if (orderOwner ~= nil) then
    	--If the order was not issued to the current player. 
	    if (orderOwner ~= user) then
	    	text = "This order doesn't belong to you! I will only reward a crafting order that's been issued directly to you."
	        response[1].text = "Sorry. My mistake."
	        NPCInteractionLongButton(text,this,user,"Responses",response)
	        return
	    end

		--If the order CraftOrderSkill doesn't match up with the skill of the recipe
		if (GetRecipeTableFromSkill(this:GetObjVar("CraftOrderSkill"))[orderInfo.Recipe] == nil) then
			text = "I'm not qualified to reward this crafting order. Heck, I don't even make these! I can't help you here pal. Go find another trader."
	        response[1].text = "Sorry. My mistake."
	        NPCInteractionLongButton(text,this,user,"Responses",response)
	        return
		end
	end

	--If the order is complete, issue reward and destroy the order.
    if (target:GetObjVar("OrderComplete")) then
    	if (CraftingOrderTable == nil) then
			CraftingOrderTable = CraftingOrderDefines[this:GetObjVar("CraftOrderSkill")]
		end

        target:Destroy()

        user:SystemMessage("Completed Crafting Order", "info")
		user:PlayEffect("HealEffect")
		user:PlayObjectSound("event:/ui/quest_complete",false)

        text = "Everything checks out. Here's your payment. If you need more work, feel free to check in with me. I might have something more fruitful for you."
        response[1].text = "You're welcome"
        
        --Reset commission
        local commissions = this:GetObjVar("Commissions") or {}
        commissions[user] = nil
        this:SetObjVar("Commissions", commissions)

        --Handle reward
        CreateStackInBackpack(user,"coin_purse", CraftingOrderDefines.Coins[orderInfo.RewardCoins])
    	local templatesSpawned = LootTables.SpawnLoot(target:GetObjVar("OrderInfo").LootTables,user:GetEquippedObject("Backpack"))

    	local lifetimeStats = user:GetObjVar("LifetimePlayerStats")
    	lifetimeStats.CraftingOrdersDone = (lifetimeStats.CraftingOrdersDone or 0) + 1
    	CheckAchievementStatus(user, "Crafting", "CraftingOrder", lifetimeStats.CraftingOrdersDone)

    	if (target:GetObjVar("OrderInfo").RewardRecipes ~= nil) then
    		local recipeRewards = target:GetObjVar("OrderInfo").RewardRecipes
    		if (recipeRewards ~= nil) then
	    		if (CraftingOrderTable.CraftingOrderRecipes[recipeRewards] ~= nil) then
	    			local loot = LootTables.SpawnLoot(CraftingOrderTable.CraftingOrderRecipes[recipeRewards], user:GetEquippedObject("Backpack"))
	    			for index, lootName in pairs(loot) do
	    				table.insert(templatesSpawned, lootName)
	    			end
		    	end
		    end
	    else
    		local loot = LootTables.SpawnLoot(CraftingOrderTable.CraftingOrderRecipes, user:GetEquippedObject("Backpack"))
    		for index, lootName in pairs(loot) do
				table.insert(templatesSpawned, lootName)
			end
	    end

    	local rewardString = "You have recieved "
    	if (#templatesSpawned > 1) then
	    	for index, templateName in pairs(templatesSpawned) do
	    		local templateData = GetTemplateData(templateName)
	    		if (index >= #templatesSpawned) then
	    			rewardString = rewardString.." and "..templateData.Name
	    		else
	    			rewardString = rewardString..templateData.Name..", "
	    		end
	    	end
	    else
	    	local templateData = GetTemplateData(templatesSpawned[1])
	    	rewardString = rewardString.." "..templateData.Name
	    end

	    rewardString = rewardString.."."
    	user:SystemMessage(rewardString,"info")
    	--DebugMessage(target:GetObjVar("OrderInfo").LootTables[1].LootItems[1].StackCountMin.." stack count min")

    	seed = math.random(1,3)
		if(seed == 1) then this:PlayAnimation("yes_two")
		elseif (seed == 2) then this:PlayAnimation("no_one")
		elseif (seed == 3) then this:PlayAnimation("yes_one")
		end
    else
        text = "That's not what I'm looking for."
        response[1].text = "Sorry!"
    end

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function CreateCraftingOrder(user, orderInfo)
	backpackObj = user:GetEquippedObject("Backpack") 
    backpackObj:SendOpenContainer(user) 
    local dropPos = GetRandomDropPosition(backpackObj)
    CreateObjInContainer("crafting_order", backpackObj, dropPos, "CreatedCraftingOrder", orderInfo, user)
end