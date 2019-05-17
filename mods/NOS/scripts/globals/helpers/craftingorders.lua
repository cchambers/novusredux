--Used for debugging CO tables
function RunCraftOrderTest()
	for definesKey, definesTable in pairs(CraftingOrderDefines) do
		if (definesTable.CraftingOrderRecipes ~= nil) then
			DebugMessage("-----CHECKING "..definesKey.." RECIPE REWARDS-----")
			VerifyCraftingOrderRecipeRewards(definesTable)
		else
			--No valid recipe reward table
			DebugMessage("No recipe reward table found for "..definesKey..". Check defines_"..definesKey.."_crafting_orders.lua")
		end

		if (AllRecipes[definesKey] ~= nil) then
			DebugMessage("-----CHECKING "..definesKey.." CRAFTING ORDERS-----")
			VerifyCraftingOrders(definesTable, definesKey)
		else
			--Recipe table is invalid
			DebugMessage("No recipe table found for "..definesKey..". Check defines_"..definesKey.."_crafting_orders.lua")
		end
	end
end

function VerifyCraftingOrderRecipeRewards(craftOrderDefinesTable)

	local passedTest = true

	for lootTableIndex, lootTable in pairs(craftOrderDefinesTable.CraftingOrderRecipes) do
		for lootItemIndex, lootItem in pairs (lootTable.LootItems) do
			local templateData = GetTemplateData(lootItem.Template)
			if (templateData == nil) then
				DebugMessage("Recipe '"..lootItem.Template.."' does not exist")
				passedTest = false
			else
				--DebugMessage(lootItem.Template)
			end	
		end
	end

	if (passedTest) then
		DebugMessage("All recipes are valid :D")
	end
end

function VerifyCraftingOrders(craftOrderDefinesTable, craftOrderSkill)

	local recipeTable = AllRecipes[craftOrderSkill]

	for craftOrderIndex, craftOrder in pairs(craftOrderDefinesTable.CraftingOrders) do

		local shouldPrintId = false

		--Check if recipe exists
		if (recipeTable[craftOrder.Recipe] == nil) then
			DebugMessage("--Recipe '"..craftOrder.Recipe.."' does not exist in '"..craftOrderSkill.."' recipe table")
			shouldPrintId = true
		end

		--Check if RewardCoins entry exists
		if (CraftingOrderDefines.Coins[craftOrder.RewardCoins] == nil) then
			DebugMessage("--Craft order coin amount '"..craftOrder.RewardCoins.."' does not exist in reward coins table")
			shouldPrintId = true
		end

		--Check if amount is valid
		if (craftOrder.Amount ~= nil) then
			if (craftOrder.Amount <= 0) then
				DebugMessage("--Craft order amount '"..craftOrder.Amount.."' cannot be below 0")
				shouldPrintId = true
			end
		else
			DebugMessage("--No craft order amount entry")
			shouldPrintId = true
			--Amount is nil
		end

		--If craft order needs material, check if material is valid
		if (craftOrder.Material ~= nil) then
			if (Materials[craftOrder.Material] == nil) then
				DebugMessage("--Craft order material '"..craftOrder.Material.."' does not exist")
				shouldPrintId = true
			end
		end

		if (shouldPrintId) then
			DebugMessage("+CRAFT ORDER+")
			DebugMessage("Recipe:", craftOrder.Recipe)
			DebugMessage("Amount:", craftOrder.Amount)
			if (craftOrder.Material ~= nil) then
				DebugMessage("Material:", craftOrder.Material)
			end
		end

	end
end

