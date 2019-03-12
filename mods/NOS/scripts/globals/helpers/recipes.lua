require 'default:globals.helpers.recipes'

function GetRecipeSkillRequired(mobileObj,recipe,material)
	local entry, skillName = GetRecipeFromEntryName(recipe)
	local modifier = 0
	if(material) then
		modifier = AllRecipes[skillName][material].DifficultyModifier or 1
	end
	return math.min(100,entry.MinLevelToCraft + modifier), math.min(100,entry.MaxLevelToGain + modifier)
end

function HasRecipe(user,recipe)
	-- DAB: Debug tool for crafting
	if(user:HasObjVar("AllRecipes")) then return true end

	local recipeRecipe = string.find(recipe, "Recipe")

	if (recipeRecipe ~= nil) then
		recipe = recipe.gsub(recipe, "Recipe", "")
	end

	local recipeTable = GetRecipeFromEntryName(recipe)
	if not(recipeTable) then
		LuaDebugCallStack("ERROR: HasRecipe called for invalid recipe " .. tostring(recipe))
	end
	
	if(recipeTable and recipeTable.NeedRecipe) then
		--get the data needed for determining if player has the recipe
		local userRecipies = user:GetObjVar("AvailableRecipies") or {}
		if not(userRecipies[recipe]) then
			return false
		end
	end

	return true
end