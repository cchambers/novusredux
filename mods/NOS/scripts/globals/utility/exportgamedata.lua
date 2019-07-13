-- PLATFORM SPECIFIC 
os.execute("mkdir export")

-- SPELL DATA --
DebugMessage("-- WRITING SPELLS.CSV")
local spellsFile = io.open("export/spells.csv","w")
io.output(spellsFile)
for spellName,spellData in pairs(SpellData.AllSpells) do
	local description = StripFromString(StripFromString(spellData.SpellTooltipString,"\n"),",")
	io.write((spellData.SpellDisplayName or spellName)..","..spellData.Skill..","..tostring(spellData.manaCost)..","..tostring(description)..","..tostring(spellData.SpellEnabled).."\n")
end
io.close(spellsFile)

-- DAB TODO add more skill info
DebugMessage("-- WRITING SKILLS.CSV")
local skillsFile = io.open("export/skills.csv","w")
io.output(skillsFile)
for skillName,skillData in pairs(SkillData.AllSkills) do
	io.write(skillName..","..(skillData.DisplayName or skillName).."\n")
end
io.close(skillsFile)

-- crafting recipes
DebugMessage("-- WRITING RECIPES.CSV")
local recipeFile = io.open("export/recipes.csv","w")
io.output(recipeFile)
for skillName,recipes in pairs(AllRecipes) do
	for recipe, recipeData in pairs(recipes) do
		local description = recipeData.Description or ""
		description = StripFromString(StripFromString(description,"\n"),",")

		local itemValue = 0
		local resourceTable = recipeData.Resources
		local canImprove = ((recipeData.CanImprove ~= nil) and recipeData.CanImprove) or false

		-- DAB TODO: Fix this!
		--[[if(canImprove) then
			resourceTable = recipeData.Resources.Flimsy			
		end
		
		for resourceItem,count in pairs(resourceTable) do
			local template = ResourceData.ResourceInfo[resourceItem].Template			
			if(CustomItemValues[template] ~= nil) then				
				itemValue = itemValue + (CustomItemValues[template] * count)
			end
		end]]

		io.write(skillName..","..recipeData.DisplayName..","..recipeData.MinLevelToCraft..","..tostring(canImprove)..","..tostring(itemValue).."\n")
	end
end
io.close(recipeFile)

DebugMessage("-- WRITING MERCHANTS.CSV")
local merchantFile = io.open("export/merchants.csv","w")
io.output(merchantFile)
for i,templateName in pairs(GetAllTemplateNames()) do
	DebugMessage("---- LOADING: "..templateName)
	local templateData = GetTemplateData(templateName)
	if(templateData.LuaModules) then
		for moduleName,initializer in pairs(templateData.LuaModules) do
			if(moduleName ~= "scene_item_spawner" and initializer.ItemInventory ~= nil) then
				--DebugMessage("---- PRINTING MERCHANT: "..templateName)
				for i,itemInfo in pairs(initializer.ItemInventory) do				
					io.write(templateName..","..itemInfo.Template..","..(itemInfo.Price and tostring(itemInfo.Price) or "")..","..(itemInfo.Amount and tostring(itemInfo.Amount) or "")..","..(itemInfo.UnlimitedStock ~= nil and tostring(itemInfo.UnlimitedStock) or "false").."\n")
				end
			end
		end
	end
end
io.close(merchantFile)