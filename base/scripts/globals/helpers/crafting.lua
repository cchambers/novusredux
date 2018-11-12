

QualityNameColors = {
	Flimsy = "978161",
	Stout = "22d322",
	Sturdy = "4D80F6",
	Robust = "B65AF3",
	Stalwart = "EA821A",
}

QualityIndex = {
	Flimsy = 1,
	Stout = 2,
	Sturdy = 3,
	Robust = 4,
	Stalwart = 5,
}

ImprovementGuarantees = {
	Flimsy = 0,
	Stout = 1,
	Sturdy = 2,
	Robust = 3,
	Stalwart = 4,
}

-- this allows recipes to either specify a single set of resources (for items with no quality)
-- or a table of resource sets, one for each quality level
function GetQualityResourceTable(resourceTable,quality)	
	-- if the resource table has subtables, then this recipe supports multiple quality levels
	local hasSubtables = true
	for k,v in pairs(resourceTable) do
		if(hasSubtables and type(v)~="table") then
			hasSubtables = false
		end
	end
	
	if(hasSubtables) then
		return resourceTable[quality]
	else
		return resourceTable	
	end
end

function HasResources(resourceTable, user, quality)
	local backpackObj = user:GetEquippedObject("Backpack")
	if( backpackObj == nil ) then	
		user:SystemMessage("You have no backpack equipped.")
		return false
	end

	local qualityResourceTable = resourceTable
	--DebugMessage("qualityResourceTable is "..tostring(qualityResourceTable))
	if ( quality ~= nil ) then		
		if ( CountTable(resourceTable) == 0) then
			return true
		end	

		qualityResourceTable = GetQualityResourceTable(resourceTable,quality)
		--DebugMessage("qualityResourceTable is now "..tostring(qualityResourceTable))
		if( qualityResourceTable == nil ) then
			return false
		end
	end
	for resourceType,count in pairs(qualityResourceTable) do
		--DebugMessage("count is "..tostring(count))
		--DebugMessage(DumpTable(count))

		--DFB NOTE: For future reference, if you're scratching your head wondering why count is a table, then you're passing a nil quality for an item that has quality
		if( CountResourcesInContainer(backpackObj,resourceType) < count ) then
			--DebugMessage("Count is "..tostring(count))
			--user:SystemMessage("You need more "..resourceType..".")
			return false 
		end		
	end

	return true
end


function ConsumeResources(resourceTable,user,transactionId,quality)
	local backpackObj = user:GetEquippedObject("Backpack")  

   	if( backpackObj == nil ) then 
   		return false
	end

	if(transactionId == nil) then transactionId = user end	

	local qualityResourceTable = resourceTable
	if(quality ~= nil) then
		-- we have already confirmed we can consume the resourceTypes so just assume everything is peachy		
		qualityResourceTable = GetQualityResourceTable(resourceTable,quality)
		if(qualityResourceTable == nil) then
			return false
		end
	end

	for resourceType,count in pairs(qualityResourceTable) do
		--DebugMessage("resourceType is "..tostring(resourceType))
		--DebugMessage("Count="..tostring(count))
		if( CountResourcesInContainer(backpackObj,resourceType) < count ) then
			return false 
		end	
		RequestConsumeResource(user,resourceType,count,transactionId,user)
	end

	return true
end

function GetRecipeItemName(recipeTable,material)
	if (recipeTable == nil) then
		LuaDebugCallStack("ERROR: recipeTable is nil") 
	end
	local materialName = ""
	if ( material and Materials[material] and ResourceData.ResourceInfo[material].CraftedItemPrefix ~= nil ) then
		materialName = ResourceData.ResourceInfo[material].CraftedItemPrefix .. " "
	end
	return materialName .. ( recipeTable.DisplayName or GetTemplateObjectName(recipeTable.CraftingTemplateFile) )
end

function GetItemNameFromRecipe(recipe)
	for skillName,recipeTable in pairs(AllRecipes) do
		if(recipeTable[recipe] ~= nil) then
			return recipeTable[recipe].DisplayName
		end
	end

	DebugMessage("ERROR: [incl_recipes|GetItemNameFromRecipe] Invalid recipe specified ("..tostring(recipe)..")")
	return nil
end

function GetRecipeFromEntryName(recipe)
	for skillName,recipeTable in pairs(AllRecipes) do
		if(recipeTable[recipe] ~= nil) then
			return recipeTable[recipe], skillName
		end
	end
	
	DebugMessage("ERROR: [incl_recipes|GetRecipeFromEntryName] Invalid recipe specified ("..tostring(recipe)..")")
	return nil
end

function GetRecipeTableFromSkill(usedSkill)
	--DebugMessage(usedSkill," is used skill")
	if(AllRecipes[usedSkill] ~= nil) then
		return AllRecipes[usedSkill]
	end

	DebugMessage("ERROR: [incl_recipes|GetRecipeTableFromSkill] Invalid skill specified ("..tostring(usedSkill)..")")
	return nil
end

--- When crafting something out of a material (vs a resource) the resource get a weighted roll dependant on the type of material
--- Note: This is expected to be called BEFORE setting tooltips on the item!
-- @param objRef(GameObj) The recently created object.
-- @param material(string) The string name of the material the item was created from
-- @param skillLevel(number) The skill level of the skill used to create the item
-- @return none
function ApplyCraftedMaterialProperties(objRef, material, skillLevel)
	if ( objRef == nil ) then
		LuaDebugCallStack("[ApplyCraftedMaterialProperties] Nil objRef provided.")
		return
	end
	if ( Materials[material] == nil ) then
		LuaDebugCallStack("[ApplyCraftedMaterialProperties] Invalid material '"..tostring(material).."' provided.")
		return
	end
	if ( skillLevel == nil ) then
		LuaDebugCallStack("[ApplyCraftedMaterialProperties] Invalid skillLevel '"..tostring(skillLevel).."' provided.")
		return
	end
	local skillPercent = skillLevel / ServerSettings.Skills.PlayerSkillCap.Single

	-- pre-pend the name with the material
	local name = StripColorFromString(objRef:GetName())
	if ( ResourceData.ResourceInfo[material].CraftedItemPrefix ~= nil ) then
		objRef:SetName(string.format("%s %s", ResourceData.ResourceInfo[material].DisplayName, name))
	else
		objRef:SetName(name)
	end
	-- set the color from material
	objRef:SetHue(Materials[material])
	-- set an objvar of the type of material
	objRef:SetObjVar("Material", material)
	-- increase the max durability
	if ( ServerSettings.Crafting.MaterialBonus.Durability[material] > 0 ) then
		local durability = GetMaxDurabilityValue(objRef)
		-- add skill bonus
		durability = durability + math.floor( ServerSettings.Crafting.SkillBonus.Durability.Max * skillPercent )
		objRef:SetObjVar("MaxDurability", durability + ServerSettings.Crafting.MaterialBonus.Durability[material])
	end

	-- add weapon bonuses
	if ( objRef:HasObjVar("WeaponType") ) then
		local bonus = WeightedRandom(0, ServerSettings.Crafting.MaterialBonus.Attack.Max, ServerSettings.Crafting.MaterialBonus.Attack.Weight[material])
		-- add the skill bonus
		bonus = bonus + math.floor( ServerSettings.Crafting.SkillBonus.Attack.Max * skillPercent )
		objRef:SetObjVar("AttackBonus", bonus)
		return
	end

	-- add armor bonuses
	if ( objRef:HasObjVar("ArmorType") or objRef:HasObjVar("ShieldType") ) then
		local bonus = WeightedRandom(0, ServerSettings.Crafting.MaterialBonus.Armor.Max, ServerSettings.Crafting.MaterialBonus.Armor.Weight[material])
		-- add skill bonus
		bonus = bonus + ( ServerSettings.Crafting.SkillBonus.Armor.Max * skillPercent )
		-- the pool for armor is so small, it's been doubled.
		objRef:SetObjVar("ArmorBonus", math.floor(bonus * 0.5))
		return
	end

end

function GetItemCraftedMaterial(item,recipeTable)
	local material = item:GetObjVar("Material")
	if(material) then
		return material
	end

	if not(recipeTable)  then
		recipeTable = GetRecipeForBaseTemplate(itemBaseTemp)		
	end

	if(recipeTable and recipeTable.CanImprove) then
		for materialType,v in pairs(recipeTable.Resources) do
			for skillName,materialList in pairs(MaterialIndex) do
				local baseMaterial = materialList[1]
				if(materialType == baseMaterial) then
					return materialType
				end

				-- HACK: Fabrication has two base materials!
				if(skillName == "FabricationSkill") then
					baseMaterial = materialList[4]
					if(materialType == baseMaterial) then
						return materialType
					end
				end
			end
		end
	end
end