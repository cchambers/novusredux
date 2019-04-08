require "default:base_crafting_controller"

function HandleCraftRequest(userRequest, skill, stopCraftingOnFailure)
	mResourceTable = nil
	if (this:HasTimer("CraftingTimer")) then
		this:SystemMessage("[FA0C0C]You are already crafting something[-]", "info")
		if not (mCrafting) then
			if (stopCraftingOnFailure) then
				CleanUp()
			end
		end
		return
	end

	skillName = StripFromString(skill, "Skill")
	if (mTool == nil) then
		CleanUp()
		return
	end
	local fabCont = mTool:TopmostContainer() or mTool
	local fabLoc = fabCont:GetLoc()
	if (this:GetLoc():Distance(fabLoc) > USAGE_DISTANCE) then
		this:SystemMessage("[FA0C0C]You are too far to use that![-]", "info")
		if (stopCraftingOnFailure) then
			CleanUp()
		end
		return
	end
	if not (this:HasLineOfSightToObj(fabCont, ServerSettings.Combat.LOSEyeLevel)) and not (fabCont:HasObjVar("IgnoreLOS")) then
		this:SystemMessage("[FA0C0C]You cannot see that![-]", "info")
		if (stopCraftingOnFailure) then
			CleanUp()
		end
		return
	end
	local backpackObj = this:GetEquippedObject("Backpack")
	local craftTemplate = GetRecipeTableFromSkill(skill)[userRequest]
	local canCreate, reason = CanCreateItemInContainer(GetCraftTemplate(userRequest), backpackObj, craftTemplate.StackCount)

	if (not canCreate) then
		if (reason == "full") then
			this:SystemMessage("[FA0C0C]Your backpack is full![-]", "info")
		elseif (reason == "overweight") then
			this:SystemMessage("[$1622]", "info")
		end
		return
	end
	mItemToCraft = userRequest
	local recipeTable = GetRecipeTableFromSkill(mSkill)[userRequest]
	local resourceTable = recipeTable.Resources
	local entryTable = {}

	if (not HasRecipe(this, userRequest, skill)) then
		this:SystemMessage("[$1623]" .. userRequest .. "[-]", "info")
		if (stopCraftingOnFailure) then
			CleanUp()
		end
		return
	end

	local reqSkillLev, maxSkillLev = GetRecipeSkillRequired(this, userRequest, mCurrentMaterial)
	if (not HasRequiredCraftingSkill(this, userRequest, skill)) then
		this:SystemMessage("You don't have enough " .. skillName .. " skill to craft item: " .. userRequest .. "" .. " - Need " .. reqSkillLev .. ", Have " .. GetSkillLevel(this, mSkill), "info")
		if (stopCraftingOnFailure) then
			CleanUp()
		end
		return
	end
	if (not this:HasObjVar("CanCraftOutOfThinAir")) then
		if not (HasResources(resourceTable, this, mCurrentMaterial)) then
			this:SystemMessage("[$1624]" .. userRequest .. "[-]", "info")
			if (stopCraftingOnFailure) then
				CleanUp()
			end
			return
		else
			mResourceTable = resourceTable
			mHasMaterial = recipeTable.CanImprove
		end
	end

	this:RemoveTimer("CraftingTimer")
	this:StopObjectSound("toolSound")
	mSkill = skill
	mDifficulty = reqSkillLev

	mSkillLevel = GetSkillLevel(this, mSkill)
	local skillToCheck = mSkillLevel
	local LoreBoost = (GetSkillLevel(this, "ArmsLoreSkill") or 0.1) / 20
	local mentor = this:GetObjVar("MentorPath")
	if (mentor ~= nil and mentor == "TradeTypeSkill") then
		LoreBoost = LoreBoost + (GetSkillLevel(this, "MentoringSkill") or 0.1) / 20
	end
	if (LoreBoost < 1) then
		LoreBoost = 0
	end

	skillToCheck = reqSkillLev - LoreBoost

	local chance = SkillValueMinMax(mSkillLevel, skillToCheck, maxSkillLev)
	mSuccess = CheckSkillChance(this, mSkill, mSkillLevel, chance)

	local consumeTable = resourceTable
	if not (mSuccess) and recipeTable.ConsumeOnFail then
		consumeTable = {}
		for resourceName, resourceAmount in pairs(resourceTable) do
			consumeTable[resourceName] = recipeTable.ConsumeOnFail[resourceName]
		end
	end
	ConsumeResources(consumeTable, this, "crafting_controller", mCurrentMaterial)
end

function ShowCraftingMenu(createdObject, isImproving, canImprove, improveResultString, improveString)
	if (mSkill == "MetalsmithSkill") then
		local anvil = FindObjects(
			SearchMulti(
				{
					SearchObjectInRange(5), --in 10 units
					SearchObjVar("ToolSkill", "MetalsmithSkill") -- this is from NPE but serves our purpose...
				}
			)
		)

		if (#anvil == 0) then
			this:SystemMessage("You need to be near an anvil or forge to use this.", "info")
			return
		end

		-- local hammers = {}

		-- -- look for hammers in their backpack
		-- local backpack = this:GetEquippedObject("Backpack")
		-- if ( backpack ) then
		-- 	hammers = FindItemsInContainerRecursive(backpack, 'SmithHammer')
		-- end

		-- -- look for one equipped
		-- local equipped = this:GetEquippedObject("RightHand")
		-- if ( equipped ) then
		-- 	if (equipped:GetType() == 'SmithHammer') then
		-- 		table.insert(hammers, equipped)
		-- 	end
		-- end

		-- if (#hammers == 0) then 
		-- 	this:SystemMessage("You need a hammer of some sort to do this.")
		-- 	return
		-- end
	end

	isImproving = false
	if (this:HasTimer("CraftingTimer")) then
		return
	end
	if (this:HasTimer("AutoCraftItem")) then
		return
	end
	if (mAutoCraft == true) then
		mAutoCraft = false
	end
	if not (RecipeCategories[mSkill]) then
		--DebugMessage("ERROR: Crafting menu for skill with no recipes! "..tostring(mSkill) )
		return
	end

	this:RemoveTimer("RemoveCraftingModule")
	--save it to an obj var so players can come back and not have to select the quality again.
	mCurrentTab = mCurrentTab or "Materials"
	skillName = mSkill
	local subCategoryTable = {}
	for i, j in pairs(RecipeCategories[skillName]) do
		if (j.Name == mCurrentTab) then
			subCategoryTable = j.Subcategories
			break
		end
	end
	--DebugMessage(mCurrentTab)
	--DebugMessage(mCurrentCategory)
	--DebugMessage(DumpTable(subCategoryTable))
	if (mCurrentCategory == nil) then
		for i, j in pairs(subCategoryTable) do
			mCurrentCategory = j[1]
			break
		end
	end
	--DebugMessage(mCurrentCategory)
	--DebugMessage("mCurrentCategory is "..tostring(mCurrentCategory))
	--DebugMessage("mCurrentTab is " .. tostring(mCurrentTab))
	local mainWindow = DynamicWindow("CraftingWindow", StripColorFromString(mTool:GetName()), 805, 510, -410, -280, "", "Center")
	local numCategories = CountTable(RecipeCategories[skillName])

	local buttons = {}
	for i, j in pairs(RecipeCategories[skillName]) do
		table.insert(buttons, {Text = j.Name})
	end

	AddTabMenu(
		mainWindow,
		{
			ActiveTab = mCurrentTab,
			Buttons = buttons
		}
	)

	--Add the images for each sub window
	mainWindow:AddImage(0, 37 - 9, "BasicWindow_Panel", 94, 437, "Sliced")
	mainWindow:AddImage(95, 37 - 9, "BasicWindow_Panel", 210, 437, "Sliced")
	mainWindow:AddImage(306, 37 - 9, "BasicWindow_Panel", 478, 437, "Sliced")
	--Next create 2 scroll windows.

	--One for subcategories
	local subCategories = ScrollWindow(3, 43 - 9, 78, 426, 69) --423 not 430?
	--add all the sub categories for that category
	--DebugMessage(DumpTable(RecipeCategories[skillName][mCurrentTab]))
	local categories = {}
	for i, j in pairs(subCategoryTable) do
		categories[i] = j
	end
	for i, j in pairs(categories) do
		newElement = ScrollElement()
		local selected = "default"
		if (mCurrentCategory == j[1]) then
			selected = "pressed"
		end
		local subCatDisplayName = j[2] or j[1]
		local subCatIconName = j[3] or j[1]
		newElement:AddButton(3, 3, "ChangeSubcategory|" .. tostring(j[1]), "", 64, 64, tostring(subCatDisplayName), "", false, "List", selected)
		newElement:AddImage(3, 3, "CraftingCategory_" .. tostring(subCatIconName), 0, 0)

		subCategories:Add(newElement)
	end
	--One for actual recipes
	local recipeList = ScrollWindow(94, 36, 196, 426, 26)
	--add all the recipes for that category

	--first sort the recipes
	local recipes = {}
	for i, j in pairs(AllRecipes[skillName]) do
		if (j.Category == mCurrentTab and j.Subcategory == mCurrentCategory) then
			j.Name = i
			table.insert(recipes, j)
		end
	end
	table.sort(
		recipes,
		function(a, b)
			if (a.MinLevelToCraft < b.MinLevelToCraft) then
				return true
			else
				return false
			end
		end
	)

	if (mRecipe == nil and #recipes > 0) then
		mRecipe = recipes[1].Name
	end
	--DebugMessage("mRecipe is " .. tostring(mRecipe))

	--add the recipes
	local hasRecipes = false
	for i, j in pairs(recipes) do
		hasRecipes = true
		newElement = ScrollElement()
		local selected = "default"
		if (mRecipe == j.Name) then
			selected = "pressed"
		end
		--DebugMessage(j.Category," is category")
		--Checking for guild faction recipes

		local ItemName = j.DisplayName
		if (HasRecipe(this, j.Name)) then
			newElement:AddButton(6, 0, "ChangeRecipe|" .. tostring(j.Name), "", 178, 26, ItemName, "", false, "List", selected)
			newElement:AddLabel(22, 6, ItemName, 155, 30, 16, "", false, false, "")
			recipeList:Add(newElement)
		else
			-- newElement:AddButton(6,0,"ChangeRecipe|"..tostring(j.Name),"",178,26,ItemName.."\n[D70000]You have not learned this recipe[-]","",false,"List",selected)
			-- newElement:AddLabel(22,6,"[999999]"..ItemName.."[-]",155,30,16,"",false,false,"")
		end
		--DebugMessage("it should be added")
	end
	mainWindow:AddScrollWindow(subCategories)
	if (hasRecipes) then
		mainWindow:AddScrollWindow(recipeList)
	end
	newElement = nil
	--create the craft window
	if (mRecipe ~= nil and mRecipe ~= "None" and skillName ~= nil) then
		----------------IMPROVEMENT WINDOW---------------------------
		--(skillName,mRecipe)
		--DebugMessage("mRecipe is "..mRecipe)
		local recipeTable = AllRecipes[skillName][mRecipe]
		if (recipeTable == nil) then
			DebugMessage("ERROR: Attempted to display recipe that is missing recipe table entry. " .. tostring(mRecipe))
		else
			-- verify the material for the given recipe
			if (recipeTable.CanImprove) then
				local first = nil
				local found = false
				for i = 1, #MaterialIndex[skillName] do
					if (recipeTable.Resources[MaterialIndex[skillName][i]] ~= nil) then
						if (first == nil) then
							first = MaterialIndex[skillName][i]
						end
						if (mCurrentMaterial == MaterialIndex[skillName][i]) then
							found = true
						end
					end
				end
				if not (found) then
					mCurrentMaterial = first
				end
			else
				mCurrentMaterial = nil
			end

			--DebugMessage("Current Material ", mCurrentMaterial)

			--DebugMessage("Getting here")
			--Add the portrait
			mainWindow:AddImage(314, 38, "DropHeaderBackground", 100, 100, "Sliced")
			mainWindow:AddImage(319, 43, tostring(GetTemplateIconId(recipeTable.CraftingTemplateFile)), 90, 90, "Object", nil, Materials[mCurrentMaterial] or 0)
			if (recipeTable.StackCount) then
				mainWindow:AddLabel(385, 105, tostring(recipeTable.StackCount), 350, 26, 26)
			end

			local Description = GetCraftingDescription(recipeTable.CraftingTemplateFile, recipeTable)

			--add the craft button
			local reason = ""
			local craftText = "Craft"
			local craftAllText = "Craft All"
			local enableCraft = "default"
			if (not CanCraftItem(mRecipe)) then
				craftText = "[555555]Craft[-]"
				craftAllText = "[555555]Craft All[-]"
				enableCraft = "disabled"
				reason = "[D70000]" .. CannotCraftReason(mRecipe) .. "[-]"
			end
			if (not HasRequiredCraftingSkill(this, mRecipe, mSkill)) then
				skillColor = "[D70000]"
			else
				skillColor = ""
			end
			--DebugMessage("i is "..tostring(i))
			local skillReq, maxSkill = GetRecipeSkillRequired(this, mRecipe, mCurrentMaterial)
			local minSkillLabel = skillColor .. "Minimum " .. GetSkillDisplayName(skillName) .. " Skill: " .. tostring(math.max(0, skillReq)) .. "[-]"

			mainWindow:AddButton(489, 422 - 9, mRecipe, craftText, 120, 0, "Craft this item.", "", true, "", enableCraft)
			mainWindow:AddButton(489 - 150, 422 - 9, "CraftAll", craftAllText, 120, 0, "Craft this item until you run out of resources.", "", true, "", enableCraft)
			--add the cannot craft message if you can't craft it=
			local recipeTitle = GetRecipeItemName(recipeTable, mCurrentMaterial) or (recipeTable.DisplayName)
			if (recipeTable.StackCount) then
				recipeTitle = recipeTitle .. " x " .. tostring(recipeTable.StackCount)
			end
			mainWindow:AddLabel(424, 46 - 9, recipeTitle, 350, 26, 26)
			--Add the label
			mainWindow:AddLabel(633, 421 - 9, reason, 150, 0, 16, "", false, false, "PermianSlabSerif_16_Dynamic")
			--Add the min skill
			mainWindow:AddLabel(420 - 16 + 20, 68 - 12 + 10 + 6 - 9, minSkillLabel, 200, 20, 16, "", false, false, "PermianSlabSerif_16_Dynamic")
			if (Description) then
				if (type(Description) == "string") then
					--scrollElement:AddLabel(215,30,"Description: "..Description,330,60,15
					--Add the description)
					mainWindow:AddLabel(314, 158 - 9, "[A1ADCC]Description: [-]" .. Description, 460, 70, 18)
				elseif type(Description) == "table" then
					--DebugMessage(DumpTable(Description))
					mainWindow:AddLabel(314, 158 - 9, "[A1ADCC]Description: [-]" .. Description[1], 460, 70, 18)
					--Add the bonuses if applicable
					mainWindow:AddLabel(403, 248 - 6 - 9, Description[2], 200, 70, 16)
					mainWindow:AddLabel(564, 248 - 6 - 9, Description[3], 200, 70, 16)
					--mainWindow:AddLabel(420-16,82-12+10,"Select Quality Type:",150,20,16)
					--scrollElement:AddLabel(215,30,"Stats:",110,60,15)
					--scrollElement:AddLabel(265,30,Description[1],110,60,15)
					--scrollElement:AddLabel(340,30,Description[2],110,60,15)
					--scrollElement:AddLabel(445,30,Description[3],110,60,15)
					mainWindow:AddImage(309 + 6, 228 - 9, "Divider", 475 - 16, 0, "Sliced") --
				else
					DebugMessage("[base_crafting_controller|DisplayItem] ERROR: Crafting description is not string or table. This should never happen.")
				end
			end
			--add the section bars
			mainWindow:AddImage(419 + 7, 145 - 9, "Divider", 360 - 14, 0, "Sliced")
			mainWindow:AddImage(309 + 6, 323 - 9, "Divider", 470 - 12, 0, "Sliced") --
			--Add the quality levels

			if (recipeTable.CanImprove) then
				local index = 0
				local count = 0
				local buttonsAdded = 0
				local backpack = this:GetEquippedObject("Backpack")
				for i = 1, #MaterialIndex[skillName] do
					if (recipeTable.Resources[MaterialIndex[skillName][i]] ~= nil) then
						count = count + 1
						local resourceTable = GetQualityResourceTable(recipeTable.Resources, MaterialIndex[skillName][i])
						local myResources = CountResourcesInContainer(backpack, MaterialIndex[skillName][i])
						if (resourceTable ~= nil and myResources > 0) then
							if (MaterialIndex[skillName][i] == mCurrentMaterial) then
								index = buttonsAdded
							end
							buttonsAdded = buttonsAdded + 1
							--DebugMessage(resourceTable)
							userActionData = GetDisplayItemActionData(mRecipe, recipeTable, MaterialIndex[skillName][i])
							--DebugMessage(userActionData)
							mainWindow:AddUserAction(374 + (50 * buttonsAdded), 88, userActionData, 40)
						end
					end
				end

				if (buttonsAdded == 0) then
					mainWindow:AddLabel(424, 88, "[FFFFFF]You are missing the required resources![-]", 50, 0, 18, "left", false, false)
				else
					mainWindow:AddImage(420 + (50 * index), 85, "CraftingWindowWeaponTypeHighlight", 47, 47)
				end
			else
				local userActionData = GetDisplayItemActionData(mRecipe, recipeTable)
				mainWindow:AddUserAction(424, 88, userActionData, 40)
			end

			-- Add the trivial tag if necesary
			if (GetSkillLevel(this, mSkill) > maxSkill) then
				mainWindow:AddImage(670, 40, "DropHeaderBackground", 100, 25, "Sliced")
				mainWindow:AddLabel(720, 46, "[DAA520]Trivial[-]", 50, 0, 18, "center", false, false)
				mainWindow:AddButton(670, 40, "", "", 100, 25, "[$1632]", "", false, "Invisible")
			end

			--Add the resources required
			-----------------------------------------------------------------------------------------------------------
			local qualityResourceTable = GetQualityResourceTable(recipeTable.Resources, mCurrentMaterial)

			if (qualityResourceTable == nil) then
				LuaDebugCallStack("Nil qualityResource Table for recipe " .. recipeTable.DisplayName .. " current material: " .. mCurrentMaterial)
				return
			end

			--calculate the total size of the resources required section
			local SIZE_PER_RESOURCE = 50
			local resourceSectionSize = CountTable(qualityResourceTable)
			--set the starting position to be the size/2
			local resourceStartLocation = 530 - 8 - ((resourceSectionSize * SIZE_PER_RESOURCE) / 2) + 10
			local position = resourceStartLocation
			local count = 0
			--for each resource required
			for i, j in pairs(qualityResourceTable) do
				local myResources = CountResourcesInContainer(this:GetEquippedObject("Backpack"), i)
				local resourcesRequired = j
				local resultString = myResources .. " / " .. resourcesRequired
				--get the resources required
				--count the resources the player has
				local resourceTemplate = GetResourceTemplateId(i)
				if (resourceTemplate ~= nil) then
					local tooltipString = "You need " .. tostring(resourcesRequired - myResources) .. " more " .. GetResourceDisplayName(i)
					if (myResources >= resourcesRequired) then
						tooltipString = "You'll need to use " .. tostring(resourcesRequired) .. " " .. GetResourceDisplayName(i) .. " to craft this. You have " .. tostring(myResources) .. "."
					end
					--add the image highlighted if you have the resource
					local resourceHue = nil
					if (HasResources(recipeTable.Resources, this, mCurrentMaterial)) then
						mainWindow:AddImage(resourceStartLocation + (SIZE_PER_RESOURCE) * (count) + 20, 345 - 9, "CraftingItemsFrame", 38, 38)
					else
						mainWindow:AddImage(resourceStartLocation + (SIZE_PER_RESOURCE) * (count) + 20, 345 - 9, "CraftingNoItemsFrame", 38, 38)
						resourceHue = "AAAAAA"
					end
					--invisible button that does a tooltip
					mainWindow:AddButton(resourceStartLocation + (SIZE_PER_RESOURCE) * (count) + 20, 345 - 9, "", "", 38, 38, tooltipString, "", false, "Invisible")
					--add the icon
					mainWindow:AddImage(resourceStartLocation + (SIZE_PER_RESOURCE) * (count) + 23, 348 - 9, tostring(GetTemplateIconId(resourceTemplate)), 32, 32, "Object", resourceHue, Materials[mCurrentMaterial] or 0)
					--display it red if they don't have it
					if (myResources < resourcesRequired) then
						resultString = "[D70000]" .. resultString .. "[-]"
					end
					--add the label
					mainWindow:AddLabel(resourceStartLocation + (SIZE_PER_RESOURCE) * (count) + 42, 390 - 9, resultString, 50, 20, 16, "center", false, false, "PermianSlabSerif_16_Dynamic")
					count = count + 1
				else
					DebugMessage("ERROR: Recipe has invalid ingredient resource. " .. tostring(mRecipe))
				end
			end
		end
	elseif (createdObject ~= nil or isImproving) then
		--label--display the OK button
		local recipeTable = AllRecipes[skillName][mRecipe]
		--Add the label
		--DebugMessage("mQuality is " ..tostring(mQuality))
		local countString = ""
		if (mCount) > 1 then
			countString = mCount .. " "
		end
		local resultLabel = improveResultString or ("You have crafted: " .. countString .. tostring(GetRecipeItemName(recipeTable, mQuality)))
		--if the label isn't specified

		--Add the bars
		--add the description (if it's not destroyed)
		local Description = GetCraftingDescription(recipeTable.CraftingTemplateFile, recipeTable, createdObject)

		mainWindow:AddImage(498, 46 + 25 - 9, "ObjectPictureFrame", 100, 100, "Sliced")
		mainWindow:AddImage(520, 61 + 25 - 9, tostring(GetTemplateIconId(recipeTable.CraftingTemplateFile)), 64, 64, "Object")
		mainWindow:AddLabel(550, 181 - 9, resultLabel, 490, 40, 24, "center")
		mainWindow:AddImage(309 + 6, 214 - 9, "Divider", 470 - 12, 0, "Sliced") --
		if (canImprove) then
			mainWindow:AddImage(309 + 6, 309 - 9, "Divider", 470 - 12, 0, "Sliced") --
		end

		if (canImprove and Description) then
			if (type(Description) == "string") then
				--scrollElement:AddLabel(215,30,"Description: "..Description,330,60,15
				--Add the description)
				mainWindow:AddLabel(309, 158 - 9, Description, 460, 70, 16)
			elseif type(Description) == "table" then
				--DebugMessage(DumpTable(Description))
				--Add the bonuses if applicable
				mainWindow:AddLabel(403, 248 - 6 - 9, Description[2], 200, 70, 16)
				mainWindow:AddLabel(564, 248 - 6 - 9, Description[3], 200, 70, 16)
			else
				DebugMessage("[base_crafting_controller|DisplayItem] ERROR: Crafting description is not string or table. This should never happen.")
			end
		end
		if (createdObject ~= nil and recipeTable.CanImprove) then
			--otherwise
			--if it's improving
			local improveLabel = improveString
			mainWindow:AddLabel(545, 335 - 9, improveLabel, 500, 30, 22, "center")
			--add the chance to break or improve
			local improvementString = ""
			if (mImprovementGuarantees > 0) then
				improvementString = "\n[F7CC0A]" .. tostring(mImprovementGuarantees) .. " Improvements Remaining[-]"
			else
				improvementString = improvementString .. "\n[009715]" .. math.floor(GetImprovementChance()) .. "% Chance to Improve Item[-]"
				improvementString = improvementString .. "\n[FA0C0C]" .. math.floor(GetBreakChance()) .. "% Chance to Break Item[-]"
			end
			mainWindow:AddLabel(545, 360 - 15 - 9, improvementString, 200, 50, 16, "center")
			--add the improve button
			mainWindow:AddButton(416, 425 - 9, "Improve", "Improve", 120, 30, "[$1633]", "", true)
			--add the cancel button
			mainWindow:AddButton(565, 425 - 9, "Cancel", "Cancel", 120, 30, "Don't improve the item.", "", false)
		else
			mainWindow:AddButton(489, 422 - 9, "OK", "OK", 120, 30, "Return to the crafting menu.", "", false)
		end
	else
		--This should never happen
		mainWindow:AddLabel(560, 50 - 9, "Select a recipe for details.", 150, 20, 16, "center")
	end
	mQuality = nil
	this:OpenDynamicWindow(mainWindow, this)

	--this:ScheduleTimerDelay(TimeSpan.FromSeconds(60),"RemoveCraftingModule")
end
