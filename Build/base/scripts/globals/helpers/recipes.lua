CraftingQualitySkillMultiplier = {
	Fragile=0,
	Flimsy=0,
	Stout=2,
	Sturdy=3,
	Robust=4,
	Stalwart=5,
}

function GetRandomRecipe(minLevel,maxLevel,skill,world)
	local recipeTable = {}
	local recipeNameTable = {}
	for skillName,skillTable in pairs(AllRecipes) do
		if (skill == skillName or skill == nil) then
			for i,j in pairs(skillTable) do
				local isMinLevel = minLevel == nil or j.MinLevelToCraft > minLevel
				local isMaxLevel = maxLevel == nil or j.MinLevelToCraft <= maxLevel
				if (j.NeedRecipe == true and isMinLevel and isMaxLevel and (j.Map == nil or j.Map == world)) then
					table.insert(recipeTable,i)
					table.insert(recipeNameTable,j.DisplayName)
				end
			end
		end
	end
	if (IsTableEmpty(recipeTable) or IsTableEmpty(recipeNameTable)) then		
		LuaDebugCallStack("[incl_recipes] ERROR: Could not find recipe with the given specifications. Check the min skillevel,skill name,and maxskill level you are passing.")
		DebugMessage("ERROR:",tostring(minLevel),tostring(maxLevel),tostring(skill))
		return nil
	end
	local choice = math.random(1,#recipeTable)
	return recipeTable[choice],recipeNameTable[choice]
end

function GetSkillForRecipe (recipe)
	for skillName,recipeTable in pairs(AllRecipes) do
		if(recipeTable[recipe] ~= nil) then
			return skillName
		end	
	end
end

function GetRequiredSkillFromRecipe(recipe)
	for skillName,recipeTable in pairs(AllRecipes) do
		if(recipeTable[recipe] ~= nil) then
			return recipeTable[recipe].MinLevelToCraft
		end	
	end

	DebugMessage("ERROR: [incl_recipes|GetRequiredSkillFromRecipe] Invalid recipe specified ("..tostring(recipe)..")")
	return nil
end

--Very VERY unsafe. Do not use unless you're just checking for something, 
--ESPECIALLY if you have two recipes for one object
function GetRecipeForBaseTemplate(baseTemplate)
	for skillName,skillRecipeTable in pairs(AllRecipes) do
		for recipeName,recipeTable in pairs(skillRecipeTable) do
			if(recipeTable.CraftingTemplateFile == baseTemplate) then
				return recipeTable
			end
		end
	end
end
--Very VERY unsafe. Do not use unless you're just checking for something, 
--ESPECIALLY if you have two recipes for one object
function GetRecipeNameFromBaseTemplate(baseTemplate)
	for skillName,skillRecipeTable in pairs(AllRecipes) do
		for recipeName,recipeTable in pairs(skillRecipeTable) do
			if(recipeTable.CraftingTemplateFile == baseTemplate) then
				return recipeName
			end
		end
	end
end

function GetSkillRequiredForTemplate (baseTemplate)
	return GetSkillForRecipe(GetRecipeNameFromBaseTemplate(baseTemplate))
end

function GetRecipeSkillRequired(mobileObj,recipe,material)
	local entry, skillName = GetRecipeFromEntryName(recipe)
	local modifier = 0
	if(material) then
		local materialIndex = IndexOf(MaterialIndex[skillName],material)
		modifier = ((materialIndex-1)*ServerSettings.Crafting.MaterialSkillDifficultyModifier)
	end
	return math.min(100,entry.MinLevelToCraft + modifier), math.min(100,entry.MaxLevelToGain + modifier)
end

function HasRequiredCraftingSkill(mobileObj,recipe,usedSkill, material)
	return GetSkillLevel(mobileObj,usedSkill) >= (GetRecipeSkillRequired(mobileObj,recipe, material) or 0)
end

function HasRecipe(user,recipe)
	-- DAB: Debug tool for crafting
	if(user:HasObjVar("AllRecipes")) then return true end

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

function GetResourceConversionInformation(resourceClass)
	return resourceConversionInfo[resourceClass]	
end

function LearnAllRecipes(user)
	local userRecipes = {}
	
	for i, skillTable in pairs(AllRecipes) do
		for j, recipe in pairs(skillTable) do
			if (recipe.NeedRecipe == true) then
				userRecipes[j] = true
				user:SystemMessage("Learned "..j)
			end
		end
	end
	user:SetObjVar("AvailableRecipies",userRecipes)
end