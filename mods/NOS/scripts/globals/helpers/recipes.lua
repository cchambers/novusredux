require 'default:globals.helpers.recipes'

function HasRecipe(user,recipe)
	-- DAB: Debug tool for crafting
	if(user:HasObjVar("AllRecipes")) then return true end

	local recipeRecipe = recipe.find("Recipe")

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