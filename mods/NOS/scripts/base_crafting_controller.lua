require 'incl_resource_source'
require 'incl_magic_sys'
	
USAGE_DISTANCE = 5
RESOURCE_DIVISOR = 3

--this:ScheduleTimerDelay(TimeSpan.FromSeconds(1.5),"RemoveCraftingModule")
mCurUserTable = {}
mImprovementBias = 100
mCurImprovements = 1
mConsumeScheduled = false
mResourcesConsumed = false
mCraftingStage = 0
mCraftedItem = nil
mImprovingState = false
mItemToCraft = nil
mCrafting = false
mCraftingTemp = nil
mSkillLevel = 0
mBonusConsumed = false
mImprovementGuarantees = 0
mSkNum = 0
BASE_IMPROVEMENT_CHANCE = 45
BASE_IMPROVEMENT_REDUCTION_FACTOR = 3.5
mTool = nil
mAwaitingDialog = false
mCurPage = 0
mSkill = nil
skillName = nil
mResourceTable = nil
mDifficulty = nil
QualitySelectedTable = {}
mAutoCraft = false
mCurrentMaterial = nil

function GetResourceTemplateId(resource)
	if(resource == nil) then
		LuaDebugCallStack("ERROR: GetResourceTemplateId got nil")
		return
	elseif not(ResourceData.ResourceInfo[resource]) then
		LuaDebugCallStack("ERROR: GetResourceTemplateId no resource info for "..tostring(resource))
		return
	end

	return ResourceData.ResourceInfo[resource].Template
end

function GetPrimaryResource(recipeTable,quality)
	local highestValue = 0
	local highestResource = nil
	-- get the highest value resource used to make the item
	local resourceTable = GetQualityResourceTable(recipeTable.Resources,quality)
	if (resourceTable == nil) then return {} end
	for resourceType, count in pairs(resourceTable) do
		if(ResourceData.ResourceInfo[resourceType]~= nil) then
			local value = CustomItemValues[ResourceData.ResourceInfo[resourceType].Template]
			if(value ~=nil and value*count > highestValue) then
				highestValue = value*count 
				highestResource = resourceType
			end
		end
	end

	return highestResource
end

-- function HandleCraftRequest(userRequest,skill,stopCraftingOnFailure)
-- 	mResourceTable = nil
-- 	--DebugMessage("B")
-- 	if(this:HasTimer("CraftingTimer")) then
-- 		this:SystemMessage("[FA0C0C]You are already crafting something[-]","info")
-- 		if not(mCrafting) then
-- 			if (stopCraftingOnFailure) then
-- 			   CleanUp()
-- 			end
-- 		end
-- 		return
-- 	end

-- 	skillName = StripFromString(skill,"Skill")
-- 	if (mTool == nil) then 
-- 		CleanUp()
-- 		return
-- 	end
-- 	local fabCont = mTool:TopmostContainer() or mTool
-- 	local fabLoc = fabCont:GetLoc()
-- 	if(this:GetLoc():Distance(fabLoc) > USAGE_DISTANCE ) then
-- 		--DebugMessage("Too Far to Fabricate")
-- 		this:SystemMessage("[FA0C0C]You are too far to use that![-]","info")
-- 			if (stopCraftingOnFailure) then
-- 			   CleanUp()
-- 			end
-- 		return
-- 	end
-- 	if not(this:HasLineOfSightToObj(fabCont,ServerSettings.Combat.LOSEyeLevel)) and not(fabCont:HasObjVar("IgnoreLOS")) then 
-- 		this:SystemMessage("[FA0C0C]You cannot see that![-]","info")
-- 			if (stopCraftingOnFailure) then
-- 			   CleanUp()
-- 			end
-- 		return 
-- 	end
-- 	local backpackObj = this:GetEquippedObject("Backpack")
-- 	local craftTemplate = GetRecipeTableFromSkill(skill)[userRequest]
-- 	local canCreate, reason = CanCreateItemInContainer(GetCraftTemplate(userRequest),backpackObj, craftTemplate.StackCount)

-- 	if (not canCreate) then
-- 		if(reason == "full") then
-- 			this:SystemMessage("[FA0C0C]Your backpack is full![-]","info")
-- 		elseif(reason == "overweight") then
-- 			this:SystemMessage("[$1622]","info")
-- 		end
-- 		return
-- 	end
-- 	--if not(HasSkill(this,skill)) then
-- 	--	this:SystemMessage("[FA0C0C] You must learn the basics of "..skillName.." before you can craft items.","info")
-- 	--		if (stopCraftingOnFailure) then
-- 	--		   CleanUp()
-- 	--		end
-- 	--	return
-- 	--end
-- 	mItemToCraft = userRequest
-- 	local recipeTable = GetRecipeTableFromSkill(mSkill)[userRequest]
-- 	local resourceTable = recipeTable.Resources
-- 	local entryTable = {}
-- 	--D*ebugMessage("Here")

-- 	if (not HasRecipe(this,userRequest,skill)) then
-- 		this:SystemMessage("[$1623]" ..userRequest .. "[-]","info")
-- 			if (stopCraftingOnFailure) then
-- 			   CleanUp()
-- 			end
-- 		return
-- 	end

-- 	local reqSkillLev, maxSkillLev = GetRecipeSkillRequired(userRequest,mCurrentMaterial)
-- 	--DebugMessage("userRequest is "..tostring(userRequest))
-- 	--DebugMessage("skill is "..tostring(skill))
-- 	--DebugMessage("GetRecipeQuality(userRequest) is" ..tostring(GetRecipeQuality(userRequest)))
-- 	if (not HasRequiredCraftingSkill(this,userRequest,skill) ) then
-- 		this:SystemMessage("You don't have enough "..skillName.." skill to craft item: " ..userRequest .. "" .." - Need "..reqSkillLev..", Have "..GetSkillLevel(this,mSkill), "info")
-- 			if (stopCraftingOnFailure) then
-- 			   CleanUp()
-- 			end
-- 		return
-- 	end
-- 	--DebugMessage(DumpTable(resourceTable))
-- 	--DebugMessage("mCurrentMaterial is "..tostring(mCurrentMaterial))
-- 	if (not this:HasObjVar("CanCraftOutOfThinAir")) then
-- 		if not(HasResources(resourceTable, this, mCurrentMaterial)) then
-- 			this:SystemMessage("[$1624]" ..userRequest .. "[-]","info" )
-- 				if (stopCraftingOnFailure) then

-- 				   CleanUp()
-- 				end
-- 			return
-- 		else
-- 			mResourceTable = resourceTable
-- 			mHasMaterial = recipeTable.CanImprove
-- 			--DebugMessage("A")
-- 		end
-- 	end

-- 	this:RemoveTimer("CraftingTimer")
-- 	this:StopObjectSound("toolSound")
-- 	--mCraftingStage = 1		
-- 	mSkill = skill
-- 	mDifficulty = reqSkillLev

-- 	mSkillLevel = GetSkillLevel(this,mSkill)
-- 	local chance = SkillValueMinMax(mSkillLevel, reqSkillLev, maxSkillLev)	
-- 	mSuccess = CheckSkillChance(this,mSkill, mSkillLevel, chance)

-- 	DismountMobile(this)

-- 	local consumeTable = resourceTable
-- 	-- If this recipe conditionally consumes resources in failure cases, remove the ones that we don't want to consume
-- 	if not(mSuccess) and recipeTable.ConsumeOnFail then
-- 		consumeTable = {}
-- 		for resourceName,resourceAmount in pairs(resourceTable) do 
-- 			consumeTable[resourceName] = recipeTable.ConsumeOnFail[resourceName]
-- 		end
-- 	end
-- 	ConsumeResources(consumeTable, this, "crafting_controller", mCurrentMaterial)
-- end

function HandleConsumeResourceResponse(success,transactionId)	

	--this:PlayAnimation("anvil_strike")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1.5),"AnimationTimer")
	this:SendMessage("EndCombatMessage")
	if (mTool ~= nil) then
		FaceObject(this,mTool)
	else
		CleanUp()
		return
	end
	-- DAB TODO: refund resources on failure
	if not(success) then
			CleanUp()
		return
	end
	if(transactionId ~= "crafting_controller") then
		--DebugMessage("Invalid Consume")
		CleanUp()
		return
	end
	if(mTool ~= nil) then
		local toolAnim = mTool:GetObjVar("ToolAnimation")
		if(toolAnim ~= nil) then
			this:PlayAnimation(toolAnim)
		end

		local toolSound = mTool:GetObjVar("ToolSound")
		if(toolSound ~= nil) then
			this:PlayObjectSound(toolSound,false,BASE_CRAFTING_DURATION)
		end
	end
	if (mCraftedItem == nil) then
		--DebugMessage("Crafting")
		
		SetMobileModExpire(this, "Disable", "Crafting", true, TimeSpan.FromSeconds(BASE_CRAFTING_DURATION))
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(BASE_CRAFTING_DURATION), "CraftingTimer")
		return
	end
	if not(mCraftedItem == nil) then
		--DebugMessage("Improving")
		mBonusConsumed = true

		SetMobileModExpire(this, "Disable", "Improving", true, TimeSpan.FromSeconds(BASE_CRAFTING_DURATION))
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(BASE_CRAFTING_DURATION), "CraftingTimer")
		return
	end
	CleanUp()	
end

function HandleCraftingTimer()
		if(mCraftedItem == nil) then mCraftingStage = 0 end
		mCraftingStage = mCraftingStage + 1
		if (not isImproving) then
			if (mAutoCraft) then
				this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"AutoCraftItem",mCurrentMaterial)
			end
		end
		if(mCraftingStage == 1) then
			CreateCraftedItem(mItemToCraft)
			--this:ScheduleTimerDelay(TimeSpan.FromSeconds(CRAFTING_BUFFER_DURATION), "CraftingTimer")
			return
		end
		--[[
		if not(mImprovingState) then
			CleanUp()
			return
		end
		]]--
end

function CreateCraftedItem(item)
	--this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(250),"ShowCraftingMenu")
	
	local itemTemplate = GetCraftTemplate(item)
	if(itemTemplate == nil)then
		--DebugMessage("CRAFT:MS: No template found for item :" .. tostring(item))
		CleanUp()
		return
	end

	if (mResourceTable) == nil then
		mResourceTable = {}
	end

	if ( mSuccess ) then
		local recp = GetRecipeTableFromSkill(mSkill)
		local recipeTable = recp[mItemToCraft]

		local backpackObj = this:GetEquippedObject("Backpack")
	 	local randomLoc = GetRandomDropPosition(this)
	 	mCraftingTemp = itemTemplate 

		local creationTemplateData=GetTemplateData(itemTemplate)
		local resourceType=nil

		-- Get resource type for items that are resources
		if (creationTemplateData ~= nil) then
			if creationTemplateData.ObjectVariables~=nil then
				resourceType=creationTemplateData.ObjectVariables.ResourceType
			end
		end

		-- Check if the item is a stackable resource
		if (resourceType ~= nil) and (creationTemplateData.LuaModules ~= nil) and (creationTemplateData.LuaModules.stackable ~= nil) then
			-- try to add to the stack in the players pack		
			local stackCount = recipeTable.StackCount or 1
			local stackSuccess, stackObj = TryAddToStack(resourceType,backpackObj,stackCount)
		    if not( stackSuccess ) then
			   	-- no stack in players pack so create an object in the pack
			   	CreateObjInBackpackOrAtLocation(this,itemTemplate,"crafted_item",false,stackCount)
		    	--DebugMessage(4)
		    else
		    	mResourceTable = nil
		    	HandleItemCreation(true,stackObj,true)
		    end
		    return -- Leave - we're done here
		end	

		weight = GetTemplateObjectProperty(itemTemplate,"Weight")
			 
		if(weight == -1) then
		    CreatePackedObjectInBackpack(this,itemTemplate,false,"crafted_item")    
		    --DebugMessage(2)        
		else
			CreateObjInBackpackOrAtLocation(this, itemTemplate,"crafted_item") 
			--DebugMessage(3)             
		end
	else
		this:SystemMessage("You fail and lose some materials.","info")
		ShowCraftingMenu()
	end

   	--CreateObjInContainer(itemTemplate, backpackObj, randomLoc, "crafted_item")
end

function GetCraftTemplate(item)
	--DebugMessage("GetCraftTemplate",mSkill,item)
	if (item == nil) then
		CleanUp()
		return
	end
	
	local recipeTable = GetRecipeTableFromSkill(mSkill)
	if(recipeTable == nil) then
		CleanUp()
		return
	end

	local tTable = recipeTable[item]

	if (tTable == nil) then
		CleanUp()
		return
	end
	--D*ebugTable(tTable)

	local defTemp = tTable.CraftingTemplateFile
	--DebugMessage(" : CraftingTemplateFile")
	if(defTemp == nil) then
		--DebugMessage("CRAFT:MS: No template found for item :" .. tostring(item))
		CleanUp()
		return
	end
	return defTemp
end
----------------------------------------------------------------------------


function AllItems(user)

	local craftingSkill = GetSkillLevel(user,mSkill)
	if(craftingSkill == nil) then 
		user:SystemMessage("[F7CC0A]You have not yet learned the basics of "..skillName..".[-]","info")
		CleanUp()
		return 
	end
	--DebugMessage("Skill:" .. tostring(craftingSkill))
	local canCraftTable = {}
	local craftTableIndex = 0
	local craftAdded = false
	local skillTable = GetRecipeTableFromSkill(mSkill)
	--DebugMessage("CanCraft Creating")
	
	for i, v in pairs(skillTable) do
		--DebugMessage(">> " .. tostring(i))
		local curReqSkill = 0
	--	for k,inf in pairs (v) do
	--		if(k ~= "Resources") then
	--			DebugTable(inf)
	--			DebugMessage("Skill Pres/Req: " ..tostring(craftingSkill) .. "/" .. tostring(inf.MinLevelToCraft))
				--if(craftingSkill >= v.MinLevelToCraft) then
					craftTableIndex = craftTableIndex + 1
					canCraftTable[i] = v
				--end
		--	end
	--	end
	end

	return canCraftTable
end

function UncraftableItems(user)
	--DebugMessage("CraftableItems:")

	local craftingSkill = GetSkillLevel(user,mSkill)
	if(craftingSkill == nil) then 
		user:SystemMessage("[F7CC0A]You have not yet learned the basics of "..skillName..".[-]","info")
		CleanUp()
		return 
	end
	--DebugMessage("Skill:" .. tostring(craftingSkill))
	local canCraftTable = {}
	local craftTableIndex = 0
	local craftAdded = false
	local skillTable = GetRecipeTableFromSkill(mSkill)
	--DebugMessage("CanCraft Creating")
	
	for i, v in pairs(skillTable) do
		--DebugMessage(">> " .. tostring(i))
		local curReqSkill = 0
	--	for k,inf in pairs (v) do
	--		if(k ~= "Resources") then
	--			DebugTable(inf)
	--			DebugMessage("Skill Pres/Req: " ..tostring(craftingSkill) .. "/" .. tostring(inf.MinLevelToCraft))
				if(not HasRecipe(this,i,mSkill)) then
					craftTableIndex = craftTableIndex + 1
					canCraftTable[i] = v
				end
		--	end
	--	end
	end

	return canCraftTable
end


function CraftableItems(user)
	--DebugMessage("CraftableItems:")

	local craftingSkill = GetSkillLevel(user,mSkill)
	if(craftingSkill == nil) then 
		user:SystemMessage("[F7CC0A]You have not yet learned the basics of "..skillName..".[-]","info")
		CleanUp()
		return 
	end
	--DebugMessage("Skill:" .. tostring(craftingSkill))
	local canCraftTable = {}
	local craftTableIndex = 0
	local craftAdded = false
	local skillTable = GetRecipeTableFromSkill(mSkill)
	--DebugMessage("CanCraft Creating")
	
	for i, v in pairs(skillTable) do
		--DebugMessage(">> " .. tostring(i))
		local curReqSkill = 0
	--	for k,inf in pairs (v) do
	--		if(k ~= "Resources") then
	--			DebugTable(inf)
	--			DebugMessage("Skill Pres/Req: " ..tostring(craftingSkill) .. "/" .. tostring(inf.MinLevelToCraft))
				if(craftingSkill >= v.MinLevelToCraft and HasRecipe(this,i,mSkill)) then
					craftTableIndex = craftTableIndex + 1
					canCraftTable[i] = v
				end
		--	end
	--	end
	end

	return canCraftTable
end


function TryCraftItem(user, userRequest,skill,noWindow)
	local entryTable = {}
	--DebugMessage("Here")
--[[	if not(HasResources(resourceTable, user)) then
		user:SystemMessage("[$1625]" ..userRequest .. "[-]","info")
		return
	end
]]--
	if (this:HasTimer("CraftingTimer")) then
		return
	end
	local craftingSkill = GetSkillLevel(user,mSkill)
	if(craftingSkill == nil) then 
		DebugMessage("ERROR: Nil Skill Request")
		return 
	end
	mItemToCraft = userRequest
	mImprovingState = false
	mCraftedItem = nil
	mImprovementGuarantees = 0
	mCurImprovements = 1
	--DebugMessage("Reset Improvment guarantees 1")
	local canCraftTable = {}
	local craftTableIndex = 0
	local craftAdded = false
	local curReqSkill = 0
	local curTemp = nil
	local skillTable = GetRecipeTableFromSkill(mSkill)
	if not(skillTable) then 
		LuaDebugCallStack("ERROR: GetRecipeTableFromSkill returned nil table: "..tostring(mSkill))
		return 
	end

			--DebugMessage("Skill Req: " ..tostring(inf.MinLevelToCraft) ..  " Has: " ..craftingSkill)
			--DebugMessage("userRequest is "..tostring(userRequest))
	local minSk = skillTable[userRequest].MinLevelToCraft
	--DebugMessage("craftingSkill is "..tostring(craftingSkill).."minSk is "..tostring(minSk).." curReqSkill is "..tostring(curReqSkill))
	if(craftingSkill >= minSk) and (minSk >= curReqSkill) then
		curReqSkill = minSk
		curTemp = skillTable[userRequest][C_TEMP]
		--DebugMessage("Cur Temp" .. tostring(curTemp))
	end
	HandleCraftRequest(userRequest,skill,false)

end

---------------------------------------------------------------

function HandleItemCreation(success,objRef,wasStacked,stackCount)	
	mResourceTable = nil
	--DebugMessage("B")
	if not(success == true) then
		this:SystemMessage("[FA0C0C]You fail to create the item.[-]","info")
		CleanUp()
		--BBTodo -- RefundResources(mItemToCraft)
		return
	end
	mCraftedItem = objRef
	mImprovementBias = 0

	objRef:SetObjVar("Crafter", this)
	objRef:SetObjVar("CraftedBy", this:GetName())

	if ( mHasMaterial ) then
		ApplyCraftedMaterialProperties(objRef, mCurrentMaterial, mSkillLevel)
		mHasMaterial = false
	end	
	
	local recipeTable = GetRecipeTableFromSkill(mSkill)[mItemToCraft]
	local name = objRef:GetName()

	if (objRef:GetObjVar("ResourceType") == "PackedObject") then
		name = StripColorFromString(GetTemplateObjectName(mCraftingTemp)).." (Packed)"
	end

	if not(wasStacked) then
		objRef:SetName(name)
	end

	if(stackCount) then
		RequestAddToStack(objRef,stackCount - 1)
	end

	SetItemTooltip(objRef)

	this:SystemMessage("Crafted " .. name .. ".", "info")
	
	mCraftingTemp = nil
	if (not mAutoCraft) then
		mCraftedItem = nil
		--DebugMessage("Reset Improvment guarantees 2")
		--ShowCraftingMenu(objRef, false, false) -- why not this?
		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(250),"ShowCraftingMenu",objRef,false,false)
		mImprovementGuarantees = 0
	end
end

function CannotCraftReason(item)
	local resourceTable = GetRecipeTableFromSkill(mSkill)[item].Resources	

	if (not HasRecipe(this,item,mSkill)) then
		return "Recipe not learned."
	end

	if not HasRequiredCraftingSkill(this,item,mSkill) and not this:GetObjVar("CanCraftOutOfThinAir") then
		return "Not enough skill."
	end

	if not(HasResources(resourceTable, this, mCurrentMaterial)) then
		return "Not enough resources."
	end

	DebugMessage("[base_crafting_controller|CannotCraftReason] ERROR: called when player can craft item")

	return "I am the walrus."
end

function CanCraftItem(item)
	local resourceTable = GetRecipeTableFromSkill(mSkill)[item].Resources	

	if not(HasResources(resourceTable, this, mCurrentMaterial) )and not this:GetObjVar("CanCraftOutOfThinAir") then
		return false
	end

	if (not HasRecipe(this,item,mSkill)) then
		return false
	end

	if (not HasRequiredCraftingSkill(this,item,mSkill) ) then
		return false
	end
	return true
end

-- you can pass either the base or bonus stat name in here
function GetCraftingStat(template,statName)
	local strippedName = string.gsub(statName, "Base", "")
	strippedName = string.gsub(strippedName, "Bonus", "")
	
	--DFB TODO: Crafting bonus stats?
	weaponType = GetTemplateObjVar(template,"WeaponType") 
	armorType = GetTemplateObjVar(template,"ArmorClass")
	--DebugMessage("weaponType = " ..tostring(weaponType))
	--DebugMessage("armorType = "..tostring(armorType))

	if( weaponType ~= nil and EquipmentStats.BaseWeaponStats[weaponType] ~= nil ) then
		return EquipmentStats.BaseWeaponStats[weaponType][statName]
	end

	if (armorType ~= nil and EquipmentStats.BaseArmorStats[armorType] ~= nil) then
		return EquipmentStats.BaseArmorStats[armorType][statName]
	end
end

function GetClassBaseStat(class,statName)
	if (class ~= nil and statName ~= nil) then
		return EquipmentStats.BaseWeaponClass[class][statName]
	end
end

STAMINA_DEFAULT = 28
function GetCraftingDescription(template,recipe,object)
	local weaponType = GetTemplateObjVar(template,"WeaponType") 
	local armorType = GetTemplateObjVar(template,"ArmorClass")
	--DebugMessage("_-----------------------_")
	--DebugMessage("TEMPLATE IS "..tostring(template))
	--DebugMessage("item weaponType = " ..tostring(weaponType))
	--DebugMessage("item armorType = "..tostring(armorType))

	return recipe.Description
end

function GetRecipeSelectedQuality(recipeID)
	if (mQuality ~= nil) then return mQuality end
	return QualitySelectedTable[recipeID] or "Flimsy"
end

function GetImprovementGuarantees(qualityLevel)
	return ImprovementGuarantees[qualityLevel]
end

function ConsumeBonusResources(mItemToCraft)
--DebugMessage("Here " .. mItemToCraft)
	local recipeTable = GetRecipeTableFromSkill(mSkill)[mItemToCraft]
	local resourceTable = GetQualityResourceTable(recipeTable.Resources,mCurrentMaterial)
	local cost = 0
	local tempTable = {}
	local tableSize = 0
	for resourceType, count in pairs(resourceTable) do
		--DebugMessage("RT: " .. resourceType .. " CT: " .. count)
		cost = math.max(count / 5, 1)
		if(cost > 0) then
			tableSize = tableSize + 1
			tempTable[resourceType] = math.floor(cost)
		end
	end
	--D*ebugTable(tempTable)
	if(tableSize > 0) then
	--DebugMessage("Attempted Bonus Consume")

		ConsumeResources(tempTable, this, "crafting_controller", mCurrentMaterial)
	end

end

function ApplyImprovementToItem(item, improvement)
	 if (improvement == nil) then return false end
	 local grade = craftBonusInfoTable[improvement].Grade or 0
	 if grade == 0 then return end
	 local curVal = item:GetObjVar(improvement) or 0
	 --DebugMessage("Cur Val:" .. curVal)
	 local maxVal = craftBonusInfoTable[improvement].Cap or 0
	 --DebugMessage("Max Val:" .. maxVal)
	 if maxVal == 0 then return end
	 local newVal = curVal + grade
	 local biasAdd = craftBonusInfoTable[improvement].Weight or 100
	 	if(grade < 0) then
		 	if(newVal < maxVal) then return end
		 	item:SetObjVar(improvement, newVal)
		 	item:SendMessage("UpdateTooltip")
		 	mImprovementBias = mImprovementBias + biasAdd
		 	item:SetObjVar("ImprovementLevel", mImprovementBias)
		 	return true
	 	end
	 	--DebugMessage("newVal is "..tostring(newVal),"maxVal is "..tostring(maxVal))
		if(newVal <= maxVal) then
			item:SetObjVar(improvement, newVal)
			if(improvement == "BonusDurability") then			
				item:SendMessage("AlterBaseDurabilityMessage", grade)
			else
				item:SendMessage("UpdateTooltip")
			end
	 		mImprovementBias = mImprovementBias + biasAdd
	 		item:SetObjVar("ImprovementLevel", mImprovementBias)
		 	return true
		end
	--DebugMessage("RETURNED FALSE")
	return false
end


function TryApplyImprovementToItem(item,guarantee)	
	if(item == nil) then 
		CleanUp() 
		return
	end
	if not(item:IsValid()) then 
		CleanUp()
		return
	end

	local myAvTab = GetAvailableImprovements(item)
	--DebugMessage("TryApplyImprovementToItem",tostring(item),DebugTable(myAvTab))
	if(myAvTab ~= nil) then 
		local maxTries = 20
		--if (not guarantee) then
		--	maxTries = 1
		--end
		for i=1,maxTries do
			local result  = myAvTab[math.random(#myAvTab)]

			--DebugMessage("ApplyImprovementToItem",result)
			if (ApplyImprovementToItem(item,result)) then
		 		this:SystemMessage("[33FFBB]You have improved the item. ("..result..")[-]","info")
		 		ShowImprovementClientDialogString(true,"[33FFBB]You have improved the item.[-]")
		 		return
			end		
		end
	end

	--we failed to improve the item.
	this:SystemMessage("[FA0C0C]You fail to improve the item.","info")
	ShowImprovementClientDialogString(true,"[FA0C0C]You fail to improve the item.")

	return
end

function GetAvailableImprovements(item)
	local eqClass = GetEquipmentClass(item)
	--DebugMessage("Class: " .. eqClass)
	return classAvailableBonusTable[eqClass]
end

function GetImprovementChance()
	--DebugMessage("mCurImprovements is ",mCurImprovements,"mImprovementGuarantees is ",mImprovementGuarantees,"Metalsmith skill is "..tostring(mSkNum))
	local reductionCount = math.max(0,mCurImprovements - mImprovementGuarantees)
	local improvementChance = (1 + (mSkNum / 150)) * BASE_IMPROVEMENT_CHANCE
	--DebugMessage("Reduction count is "..tostring(reductionCount))
	return math.max(0,(improvementChance - (reductionCount * BASE_IMPROVEMENT_REDUCTION_FACTOR)))
end

function GetBreakChance()
	return (100 - GetImprovementChance()) / 2.5
end

function AttemptToImproveItem()
	if(mCraftedItem == nil)  then 
		CleanUp() 
		return
	end
	if not(mCraftedItem:TopmostContainer() == this) then
		this:SystemMessage("[$1630]","info")
		CleanUp()
		return
	end	

	local mustBeatRoll = 100 - GetImprovementChance()
	local breakChance = GetBreakChance()
	local myRoll = math.random(0,100) --/ (1 + (mImprovementBias/100))
	--DebugMessage(this:GetName() .. " Rolled: " .. myRoll .. " MustBeat: " .. mustBeatRoll .. " Bias:" .. (1 + (mImprovementBias /100)))
	if (mImprovementGuarantees > 0) then
		--DebugMessage("Removing improvment guarentees")
		mImprovementGuarantees = mImprovementGuarantees - 1
		TryApplyImprovementToItem(mCraftedItem,true)
		return
	end
	mCurImprovements = mCurImprovements + 1
	if(myRoll > mustBeatRoll) then
		TryApplyImprovementToItem(mCraftedItem)
		return
	end
	if(myRoll < breakChance) then
		this:SystemMessage("[FA0C0C]You have destroyed the item.","info")
		--mDialog = true
		this:RemoveTimer("CraftingTimer")
		mCraftedItem:Destroy()
		mCraftedItem = nil
		--DebugMessage("Reset Improvment guarantees 3")
		mImprovementGuarantees = 0
		ShowCraftingMenu(nil,true,false,"[FA0C0C]You have destroyed the item.[-]")
		return
	end
	this:SystemMessage("[FA0C0C]You fail to improve the item.","info")
	ShowImprovementClientDialogString(true,"[FA0C0C]You fail to improve the item.")
end

function CleanUp()
    this:PlayAnimation("idle")
	--if(this:HasTimer("CraftingTimer")) then this:RemoveTimer("CraftingTimer") end
	this:CloseDynamicWindow("CraftingWindow")
	--DebugMessage(GetCurrentModule())
	this:DelModule(GetCurrentModule())
end

function InterruptCrafting()
	if(this:HasTimer("CraftingTimer")) then
	    this:PlayAnimation("idle")
		--refund resources here
		SetMobileMod(this, "Disable", "Crafting", nil)
		this:RemoveTimer("CraftingTimer")
		--DebugMessage(DumpTable(mResourceTable))
		--DFB NOTE: Removed resource refunding
		--[[if (mResourceTable ~= nil) and (not mImprovingState) and ResourceData.ResourceInfo ~= nil then
			local backpackObj = this:GetEquippedObject("Backpack") 
			for i,j in pairs(mResourceTable) do
				if(ResourceData.ResourceInfo[i]) then
					local creationTemplate = ResourceData.ResourceInfo[i].Template
					--DebugMessage(j)
					--LuaDebugCallStack("Refunding here...")
					CreateObjInBackpack(this,creationTemplate,"RefundResources",j) 
				else
					DebugMessage("ERROR: Attempted to refund invalid resource "..tostring(i))
				end
		    end
		    mResourceTable = nil
		else
			--DebugMessage("[base_crafting_controller|InterruptCrafting] ERROR: Interrupted crafting without refunding resources!")
		end	
		]]--	
	end
	CallFunctionDelayed(TimeSpan.FromSeconds(0.1),function() CleanUp() end)
end

function ShowImprovementClientDialogString(moreImprovement,overrideString)
	local string = "Improve this item?"
	if (moreImprovement) then
		string = "Continue improving this item?"
	end


	ShowCraftingMenu(mCraftedItem,true,true,overrideString,string)
	--[[Old, we have a window for this now.
	ClientDialog.Show{
			TargetUser = this,
			DialogId = "ItemCrafted",
			TitleStr = "Continue Crafting?",
			DescStr = string,
			Button1Str = "Confirm",
			Button2Str = "Cancel",
			ResponseFunc = HandleDialogResult,
		}--]]
end

function HandleDialogResult(user, buttonId)
	buttonId = tonumber(buttonId)
	--DebugMessage("Dialog Received")
	--DebugMessage("DL: " ..dialogId)
	if( user ~= this ) then
		return
	end
	--DebugMessage(" Button :" .. buttonId .. " dialogId :" .. dialogId)
	if (buttonId == 0 and user == this) then

		local toolAnim = mTool:GetObjVar("ToolAnimation")
		if(toolAnim ~= nil) then
			this:PlayAnimation(toolAnim)
		end

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1.5),"AnimationTimer")
		if (mTool ~= nil) then
			FaceObject(this,mTool)
		else
			CleanUp()
			return
		end		

		--mDialog = false
		mImprovingState = true
		this:RemoveTimer("RemoveCraftingModule")
		
		if not (this:HasTimer("CraftingTimer")) then
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(IMPROVEMENT_DURATION), "CraftingTimer")
			-- DAB NOTE: Do not consume resources for improvements!
		    --DebugMessage("Improving item")
			--if(mBonusConsumed == false) then
			--	ConsumeBonusResources(mItemToCraft)	
			--end
		end
			return
	end
	
		this:SystemMessage("[57FA0C]You have stopped trying to improve the item. [-]","info")
		mImprovingState = false
		--DebugMessage("Reset Improvment guarantees 2")
		mCraftedItem = nil
		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(250),"ShowCraftingMenu")
		mImprovementGuarantees = 0
end

function HandleCraftingMenuResponse(user,id)
	--DebugMessage("Getting here")
	local skill = mSkill
	--DebugMessage(id)
	if not (user == this) then 
		CleanUp()
		return
	end
	local result = StringSplit(id,"|")
	local action = result[1]
	local arg = result[2]

	local newTab = HandleTabMenuResponse(id)
	if(newTab) then
		mCurrentTab = newTab
		mCurrentCategory = nil
		mRecipe = nil
		ShowCraftingMenu()
		return
	end

	if (action == "ChangeSubcategory") then
		mCurrentCategory = arg
		mRecipe = nil
		ShowCraftingMenu()
		return
	end
	if (action == "ChangeRecipe") then
		mRecipe = arg
		ShowCraftingMenu()
		return
	end
	if (action == "OK") then
		ShowCraftingMenu()
		return
	end
	if (action == "Improve") then
		HandleDialogResult(user, 0)
		return
	end
	if (action == "Cancel") then
		HandleDialogResult(user, 1)
		return
	end
	--[[if id == "All" then
		mCurrentTab = id
		ShowCraftingMenu()
		return
	end
	if id == "Known" then
		mCurrentTab = id
		ShowCraftingMenu()
		return
	end
	if id == "Not Learned" then
		mCurrentTab = id
		ShowCraftingMenu()
		return
	end--]]
	if (id == "CraftAll") then
		TryCraftItem(this, mRecipe, skill,false)
		mAutoCraft = true
		return
	end
	if(id == "") then
		return
	end
	if (id == nil) then
		CleanUp()
		return
	end
	TryCraftItem(this, id, skill,false)
end

-- function ShowCraftingMenu(createdObject,isImproving,canImprove,improveResultString,improveString)
-- 	isImproving = false
-- 	if (this:HasTimer("CraftingTimer")) then return end
-- 	if (this:HasTimer("AutoCraftItem")) then return end
-- 	if (mAutoCraft == true) then mAutoCraft = false end
-- 	if not(RecipeCategories[mSkill]) then
-- 		--DebugMessage("ERROR: Crafting menu for skill with no recipes! "..tostring(mSkill) )
-- 		return
-- 	end

-- 	this:RemoveTimer("RemoveCraftingModule")
-- 	--save it to an obj var so players can come back and not have to select the quality again.
-- 	mCurrentTab = mCurrentTab or "Materials"
-- 	skillName = mSkill
-- 	local subCategoryTable = {}
-- 	for i,j in pairs(RecipeCategories[skillName]) do
-- 		if (j.Name == mCurrentTab) then
-- 			subCategoryTable = j.Subcategories
-- 			break
-- 		end
-- 	end
-- 	--DebugMessage(mCurrentTab)
-- 	--DebugMessage(mCurrentCategory)
-- 	--DebugMessage(DumpTable(subCategoryTable))
-- 	if (mCurrentCategory == nil) then
-- 		for i,j in pairs(subCategoryTable) do
-- 			mCurrentCategory = j[1]
-- 			break
-- 		end
-- 	end
-- 	--DebugMessage(mCurrentCategory)
-- 	--DebugMessage("mCurrentCategory is "..tostring(mCurrentCategory))
-- 	--DebugMessage("mCurrentTab is " .. tostring(mCurrentTab))	
-- 	local mainWindow = DynamicWindow("CraftingWindow",StripColorFromString(mTool:GetName()),805,510,-410,-280,"","Center")
-- 	local numCategories = CountTable(RecipeCategories[skillName])

-- 	local buttons = {}
-- 	for i,j in pairs(RecipeCategories[skillName]) do
-- 		table.insert(buttons,{Text = j.Name})
-- 	end

-- 	AddTabMenu(mainWindow,
-- 	{
--         ActiveTab = mCurrentTab, 
--         Buttons = buttons
--     })	
		
-- 	--Add the images for each sub window
-- 	mainWindow:AddImage(0,37-9,"BasicWindow_Panel",94,437,"Sliced")
-- 	mainWindow:AddImage(95,37-9,"BasicWindow_Panel",210,437,"Sliced")
-- 	mainWindow:AddImage(306,37-9,"BasicWindow_Panel",478,437,"Sliced")
-- 	--Next create 2 scroll windows.

-- 	--One for subcategories
-- 	local subCategories = ScrollWindow(3,43-9,78,426,69) --423 not 430?
-- 	--add all the sub categories for that category
-- 	--DebugMessage(DumpTable(RecipeCategories[skillName][mCurrentTab]))
-- 	local categories = {}
-- 	for i,j in pairs(subCategoryTable) do 
-- 		categories[i] = j
-- 	end
-- 	for i,j in pairs(categories) do
-- 		newElement = ScrollElement()
-- 		local selected = "default"
-- 		if (mCurrentCategory == j[1]) then
-- 			selected = "pressed"
-- 		end
-- 		local subCatDisplayName = j[2] or j[1]
-- 		local subCatIconName = j[3] or j[1]
-- 		newElement:AddButton(3,3,"ChangeSubcategory|"..tostring(j[1]),"",64,64,tostring(subCatDisplayName),"",false,"List",selected)
-- 		newElement:AddImage(3,3,"CraftingCategory_"..tostring(subCatIconName),0,0)
		
-- 		subCategories:Add(newElement)
-- 	end
-- 	--One for actual recipes
-- 	local recipeList = ScrollWindow(94,36,196,426,26)
-- 		--add all the recipes for that category

-- 	--first sort the recipes
-- 	local recipes = {}
-- 	for i,j in pairs(AllRecipes[skillName]) do 
-- 		if (j.Category == mCurrentTab and j.Subcategory == mCurrentCategory) then
-- 			j.Name = i
-- 			table.insert(recipes,j)
-- 		end
-- 	end
-- 	table.sort(recipes,function (a,b)
-- 		if (a.MinLevelToCraft < b.MinLevelToCraft) then
-- 			return true
-- 		else
-- 			return false
-- 		end
-- 	end)

-- 	if (mRecipe == nil and #recipes > 0) then
-- 		mRecipe = recipes[1].Name		
-- 	end
-- 	--DebugMessage("mRecipe is " .. tostring(mRecipe))

-- 	--add the recipes
-- 	local hasRecipes = false
-- 	for i,j in pairs(recipes) do
-- 		newElement = ScrollElement()
-- 		local selected = "default"
-- 		if (mRecipe == j.Name) then selected = "pressed" end
-- 		--DebugMessage(j.Category," is category")
-- 		--Checking for guild faction recipes

-- 		local showRecipe = true
-- 		if (showRecipe) then
-- 			if (HasRecipe(this,j.Name)) then
-- 				newElement:AddButton(6,0,"ChangeRecipe|"..tostring(j.Name),"",178,26,"Recipe for a "..j.DisplayName,"",false,"List",selected)
-- 				newElement:AddLabel(22,6,j.DisplayName,155,30,16,"",false,false,"")
-- 			else
-- 				newElement:AddButton(6,0,"ChangeRecipe|"..tostring(j.Name),"",178,26,"Recipe for a "..j.DisplayName.."\n[D70000]You have not learned this recipe[-]","",false,"List",selected)
-- 				newElement:AddLabel(22,6,"[999999]"..j.DisplayName.."[-]",155,30,16,"",false,false,"")
-- 			end
-- 			hasRecipes = true
-- 			--DebugMessage("it should be added")
-- 			recipeList:Add(newElement)
-- 		end
-- 	end
-- 	mainWindow:AddScrollWindow(subCategories)
-- 	if (hasRecipes) then
-- 		mainWindow:AddScrollWindow(recipeList)
-- 	end
-- 	newElement = nil
-- 	--create the craft window
-- 	if (mRecipe ~= nil and mRecipe ~= "None" and skillName ~= nil) then
-- 		--(skillName,mRecipe)
-- 		--DebugMessage("mRecipe is "..mRecipe)
-- 		local recipeTable = AllRecipes[skillName][mRecipe]
-- 		if(recipeTable == nil) then
-- 			DebugMessage("ERROR: Attempted to display recipe that is missing recipe table entry. " .. tostring(mRecipe))
-- 		else

-- 			-- verify the material for the given recipe
-- 			if ( recipeTable.CanImprove ) then
-- 				local first = nil
-- 				local found = false
-- 				for i=1,#MaterialIndex[skillName] do
-- 					if ( recipeTable.Resources[MaterialIndex[skillName][i]] ~= nil ) then
-- 						if ( first == nil ) then first = MaterialIndex[skillName][i] end
-- 						if ( mCurrentMaterial == MaterialIndex[skillName][i] ) then
-- 							found = true
-- 						end
-- 					end
-- 				end
-- 				if not( found ) then
-- 					mCurrentMaterial = first
-- 				end
-- 			else
-- 				mCurrentMaterial = nil
-- 			end

-- 			--DebugMessage("Current Material ", mCurrentMaterial)

-- 			--DebugMessage("Getting here")
-- 		    --Add the portrait
-- 			mainWindow:AddImage(314,38,"DropHeaderBackground",100,100,"Sliced")
-- 			mainWindow:AddImage(319,43,tostring(GetTemplateIconId(recipeTable.CraftingTemplateFile)),90,90,"Object",nil,Materials[mCurrentMaterial] or 0)
-- 			if(recipeTable.StackCount) then
-- 				mainWindow:AddLabel(385,105,tostring(recipeTable.StackCount),350,26,26)
-- 			end

-- 			local Description = GetCraftingDescription(recipeTable.CraftingTemplateFile,recipeTable)

-- 		    --add the craft button
-- 		    local reason = ""
-- 			local craftText = "Craft"
-- 			local craftAllText = "Craft All"
-- 			local enableCraft = "default"
-- 			if (not CanCraftItem(mRecipe)) then
-- 				craftText = "[555555]Craft[-]"
-- 				craftAllText = "[555555]Craft All[-]"
-- 				enableCraft = "disabled"
-- 				reason = "[D70000]"..CannotCraftReason(mRecipe).."[-]"
-- 			end
-- 			if (not HasRequiredCraftingSkill(this,mRecipe,mSkill) ) then
-- 				skillColor = "[D70000]"
-- 			else
-- 				skillColor = ""
-- 			end
-- 			--DebugMessage("i is "..tostring(i))		
-- 			local skillReq, maxSkill = GetRecipeSkillRequired(mRecipe,mCurrentMaterial)
-- 			local minSkillLabel = skillColor.."Minimum "..GetSkillDisplayName(skillName).." Skill: " ..tostring(math.max(0, skillReq)).."[-]"

-- 			mainWindow:AddButton(489,422-9,mRecipe,craftText,120,0,"Craft this item.","",true,"",enableCraft)
-- 			mainWindow:AddButton(489-150,422-9,"CraftAll",craftAllText,120,0,"Craft this item until you run out of resources.","",true,"",enableCraft)
-- 			--add the cannot craft message if you can't craft it=
-- 			local recipeTitle = GetRecipeItemName(recipeTable,mCurrentMaterial) or (recipeTable.DisplayName)
-- 			if(recipeTable.StackCount) then
-- 				recipeTitle = recipeTitle .. " x "..tostring(recipeTable.StackCount)
-- 			end
-- 			mainWindow:AddLabel(424,46-9,recipeTitle,350,26,26)
-- 			--Add the label
-- 			mainWindow:AddLabel(633,421-9,reason,150,0,16,"",false,false,"PermianSlabSerif_16_Dynamic")
-- 			--Add the min skill
-- 			mainWindow:AddLabel(420-16+20,68-12+10+6-9,minSkillLabel,200,20,16,"",false,false,"PermianSlabSerif_16_Dynamic")
-- 			if(Description) then
-- 				if (type(Description) == "string") then
-- 					mainWindow:AddLabel(314,158-9,"[A1ADCC]Description: [-]"..Description,460,70,18)
-- 				--scrollElement:AddLabel(215,30,"Description: "..Description,330,60,15
-- 				--Add the description)
-- 				elseif type(Description) == "table" then
-- 					--DebugMessage(DumpTable(Description))
-- 					mainWindow:AddLabel(314,158-9,"[A1ADCC]Description: [-]"..Description[1],460,70,18)
-- 					--Add the bonuses if applicable
-- 					mainWindow:AddLabel(403,248-6-9,Description[2],200,70,16)
-- 					mainWindow:AddLabel(564,248-6-9,Description[3],200,70,16)
-- 					--mainWindow:AddLabel(420-16,82-12+10,"Select Quality Type:",150,20,16)
-- 					--scrollElement:AddLabel(215,30,"Stats:",110,60,15)
-- 					--scrollElement:AddLabel(265,30,Description[1],110,60,15)
-- 					--scrollElement:AddLabel(340,30,Description[2],110,60,15)
-- 					--scrollElement:AddLabel(445,30,Description[3],110,60,15) 
-- 					mainWindow:AddImage(309+6,228-9,"Divider",475-16,0,"Sliced") --
-- 				else
-- 					DebugMessage("[base_crafting_controller|DisplayItem] ERROR: Crafting description is not string or table. This should never happen.")
-- 				end	
-- 			end
-- 			--add the section bars
-- 			mainWindow:AddImage(419+7,145-9,"Divider",360-14,0,"Sliced")
-- 			mainWindow:AddImage(309+6,323-9,"Divider",470-12,0,"Sliced") --
-- 			--Add the quality levels

-- 			if ( recipeTable.CanImprove ) then
-- 				local index = 0
-- 				local count = 0
-- 				for i=1,#MaterialIndex[skillName] do
-- 					if ( recipeTable.Resources[MaterialIndex[skillName][i]] ~= nil ) then
-- 						if ( MaterialIndex[skillName][i] == mCurrentMaterial ) then
-- 							index = count
-- 						end
-- 						count = count + 1
-- 						local resourceTable = GetQualityResourceTable(recipeTable.Resources, MaterialIndex[skillName][i])
-- 						if ( resourceTable ~= nil ) then
-- 							--DebugMessage(resourceTable)
-- 							userActionData = GetDisplayItemActionData(mRecipe,recipeTable,MaterialIndex[skillName][i])
-- 							--DebugMessage(userActionData)
-- 							mainWindow:AddUserAction(374+(50*count),88,userActionData,40)
-- 						end
-- 					end
-- 				end
-- 				mainWindow:AddImage(420+(50*index),85,"CraftingWindowWeaponTypeHighlight",47,47)
-- 			else
-- 				local userActionData = GetDisplayItemActionData(mRecipe,recipeTable)
-- 				mainWindow:AddUserAction(424,88,userActionData,40)
-- 			end

-- 			-- Add the trivial tag if necesary
-- 			if(GetSkillLevel(this,mSkill) > maxSkill) then
-- 				mainWindow:AddImage(670,40,"DropHeaderBackground",100,25,"Sliced")
-- 				mainWindow:AddLabel(720,46,"[DAA520]Trivial[-]",50,0,18,"center",false,false)
-- 				mainWindow:AddButton(670,40,"","",100,25,"[$1632]","",false,"Invisible")
-- 			end

-- 			--Add the resources required
-- 			-----------------------------------------------------------------------------------------------------------
-- 			local qualityResourceTable = GetQualityResourceTable(recipeTable.Resources,mCurrentMaterial)

-- 			if ( qualityResourceTable == nil ) then
-- 				LuaDebugCallStack("Nil qualityResource Table for recipe "..recipeTable.DisplayName.." current material: "..mCurrentMaterial)
-- 				return
-- 			end

-- 			--calculate the total size of the resources required section
-- 			local SIZE_PER_RESOURCE = 50
-- 			local resourceSectionSize = CountTable(qualityResourceTable)
-- 			--set the starting position to be the size/2
-- 			local resourceStartLocation = 530 - 8 - ((resourceSectionSize*SIZE_PER_RESOURCE)/2)+10
-- 			local position = resourceStartLocation
-- 			local count = 0
-- 			--for each resource required
-- 			for i,j in pairs(qualityResourceTable) do
-- 				local myResources = CountResourcesInContainer(this:GetEquippedObject("Backpack"), i)
-- 				local resourcesRequired = j
-- 				local resultString =  myResources.. " / " .. resourcesRequired
-- 				--get the resources required
-- 				--count the resources the player has
-- 				local resourceTemplate = GetResourceTemplateId(i)
-- 				if(resourceTemplate ~= nil) then
-- 					local tooltipString = "You need " ..tostring(resourcesRequired - myResources).." more "..GetResourceDisplayName(i)
-- 					if (myResources >= resourcesRequired) then
-- 						tooltipString = "You'll need to use "..tostring(resourcesRequired).. " "..GetResourceDisplayName(i).." to craft this. You have "..tostring(myResources).."."
-- 					end
-- 					--add the image highlighted if you have the resource
-- 					local resourceHue = nil
-- 					if (HasResources(recipeTable.Resources, this, mCurrentMaterial)) then
-- 						mainWindow:AddImage(resourceStartLocation+(SIZE_PER_RESOURCE)*(count)+20,345-9,"CraftingItemsFrame",38,38)
-- 					else
-- 						mainWindow:AddImage(resourceStartLocation+(SIZE_PER_RESOURCE)*(count)+20,345-9,"CraftingNoItemsFrame",38,38)
-- 						resourceHue = "AAAAAA"
-- 					end
-- 					--invisible button that does a tooltip
-- 					mainWindow:AddButton(resourceStartLocation+(SIZE_PER_RESOURCE)*(count)+20,345-9,"","",38,38,tooltipString,"",false,"Invisible")
-- 					--add the icon
-- 					mainWindow:AddImage(resourceStartLocation+(SIZE_PER_RESOURCE)*(count)+23,348-9,tostring(GetTemplateIconId(resourceTemplate)),32,32,"Object",resourceHue,Materials[mCurrentMaterial] or 0)
-- 					--display it red if they don't have it
-- 					if (myResources < resourcesRequired) then
-- 						resultString = "[D70000]" .. resultString .. "[-]"
-- 					end
-- 					--add the label
-- 					mainWindow:AddLabel(resourceStartLocation+(SIZE_PER_RESOURCE)*(count)+42,390-9,resultString,50,20,16,"center",false,false,"PermianSlabSerif_16_Dynamic")
-- 					count = count + 1
-- 				else
-- 					DebugMessage("ERROR: Recipe has invalid ingredient resource. "..tostring(mRecipe))
-- 				end
-- 			end
-- 		end
-- 	----------------IMPROVEMENT WINDOW---------------------------
-- 	elseif (createdObject ~= nil or isImproving) then
-- 		local recipeTable = AllRecipes[skillName][mRecipe]
-- 		--Add the label 
-- 		--DebugMessage("mQuality is " ..tostring(mQuality))
-- 		local countString = ""
-- 		if (mCount) > 1 then
-- 			countString = mCount .. " "
-- 		end
-- 		local resultLabel = improveResultString or ("You have crafted: "..countString..tostring(GetRecipeItemName(recipeTable,mQuality)))
-- 			--if the label isn't specified

-- 		--Add the bars
-- 		--add the description (if it's not destroyed)
-- 		local Description = GetCraftingDescription(recipeTable.CraftingTemplateFile,recipeTable,createdObject)
		
-- 		mainWindow:AddImage(498,46+25-9,"ObjectPictureFrame",100,100,"Sliced")
-- 		mainWindow:AddImage(520,61+25-9,tostring(GetTemplateIconId(recipeTable.CraftingTemplateFile)),64,64,"Object")
-- 		mainWindow:AddLabel(550,181-9,resultLabel,490,40,24,"center")
-- 		mainWindow:AddImage(309+6,214-9,"Divider",470-12,0,"Sliced") --
-- 		if (canImprove) then
-- 			mainWindow:AddImage(309+6,309-9,"Divider",470-12,0,"Sliced") --
-- 		end

-- 		if (canImprove and Description) then
-- 			if (type(Description) == "string") then
-- 				mainWindow:AddLabel(309,158-9,Description,460,70,16)
-- 			--scrollElement:AddLabel(215,30,"Description: "..Description,330,60,15
-- 			--Add the description)
-- 			elseif type(Description) == "table" then
-- 				--DebugMessage(DumpTable(Description))
-- 				--Add the bonuses if applicable
-- 				mainWindow:AddLabel(403,248-6-9,Description[2],200,70,16)
-- 				mainWindow:AddLabel(564,248-6-9,Description[3],200,70,16)
-- 			else
-- 				DebugMessage("[base_crafting_controller|DisplayItem] ERROR: Crafting description is not string or table. This should never happen.")
-- 			end	
-- 		end
-- 		if (createdObject ~= nil and recipeTable.CanImprove) then
-- 		--if it's improving 
-- 			local improveLabel = improveString
-- 			mainWindow:AddLabel(545,335-9,improveLabel,500,30,22,"center")
-- 			--add the chance to break or improve
-- 			local improvementString = ""
-- 			if (mImprovementGuarantees > 0) then
-- 				improvementString = "\n[F7CC0A]"..tostring(mImprovementGuarantees).." Improvements Remaining[-]"		 
-- 			else		
-- 				improvementString = improvementString .."\n[009715]"..math.floor(GetImprovementChance()).."% Chance to Improve Item[-]"
-- 				improvementString = improvementString .."\n[FA0C0C]"..math.floor(GetBreakChance()).."% Chance to Break Item[-]"
-- 			end
-- 			mainWindow:AddLabel(545,360-15-9,improvementString,200,50,16,"center")
-- 			--add the improve button
-- 			mainWindow:AddButton(416,425-9,"Improve","Improve",120,30,"[$1633]","",true)
-- 			--add the cancel button
-- 			mainWindow:AddButton(565,425-9,"Cancel","Cancel",120,30,"Don't improve the item.","",false)
-- 		--otherwise 
-- 		else
-- 			mainWindow:AddButton(489,422-9,"OK","OK",120,30,"Return to the crafting menu.","",false)
-- 		end
-- 			--label--display the OK button
-- 	else
-- 		--This should never happen
-- 		mainWindow:AddLabel(560,50-9,"Select a recipe for details.",150,20,16,"center")
-- 	end
-- 	mQuality = nil
-- 	this:OpenDynamicWindow(mainWindow,this)

-- 	--this:ScheduleTimerDelay(TimeSpan.FromSeconds(60),"RemoveCraftingModule")
-- end

function GetDisplayItemActionData(recipeName,recipeTable,material)
	local displayName = GetRecipeItemName(recipeTable,material)
	local tooltip = "[$1634]"

	local templateName = nil
	local template = nil

	if ( recipeTable.CanImprove and material ) then
		templateName = AllRecipes[mSkill][material].CraftingTemplateFile
	else
		templateName = recipeTable.CraftingTemplateFile
	end

	-- load the template data
	template = GetTemplateData(templateName)
	if not(template) then
		DebugMessage("ERROR: Template not found: "..tostring(templateName).. " Recipe: "..tostring(recipeName))
		return nil
	end

	--DebugMessage(tostring(icon))
	return {
		ID = ( material or "" ).."="..recipeName,
		ActionType = "Crafted",
		DisplayName = displayName,
		Tooltip = tooltip,
		IconObject = template.ClientId,
		IconHue = Materials[material] or template.Hue or 0,
		Enabled = true,
		--Requirements = {
		--	{mSkill,GetRecipeSkillRequired(this,recipeName)}
		--},
		--ServerCommand = "ActivateQualityVariation "..recipeName.. " "..quality
		ServerCommand = Materials[material] ~= nil and "ChangeMaterial "..material or nil
	}
end

--[[function DisplayItem(scrollWindow,i,j)
	-- DAB TODO: HACK THIS ADDRESSES MOST OF THE LARGE PACKET SIZE ISSUES
	-- Remove this when we optimize the dynamic window code
	if (not(HasRecipe(this,i)) and GetSkillLevel(this,mSkill)<(j.MinLevelToCraft or 1000)) then return end

	local selectedQuality = GetRecipeSelectedQuality(i)

	--if (count <= TEMP_max_count) then
	local resourcesString = "Resources Required: "

	endSkillColor = "[-]"
	local reason = ""
	--DebugMessage("i is "..tostring(i))
	if (not HasRequiredCraftingSkill(this,i,mSkill) ) then
		skillColor = "[D70000]"
		reason = "[9D3E3A]Not enough skill required.[-]"
	else
		skillColor = ""
	end
	if (not HasResources(j.Resources,this,selectedQuality) ) then
		resourceColor = "[D70000]"
		reason = "[9D3E3A]Not enough resources required.[-]"
	else
		resourceColor = ""
	end
	local minSkillLabel = "Min Skill: " ..skillColor..tostring(GetRecipeSkillRequired(this,i,selectedQuality))..endSkillColor
	local Description = GetCraftingDescription(j.CraftingTemplateFile,j)
	if (Description == nil) then
		Description = "Item"
	end


	--x draw a line before the crafting button at 600,15
	--x draw 8 blank resource objects AT resource required positions
	--draw selection highlight image for quality level'
	--stats start at 215 35
	--first list at 260,35, by 4 elements
	--second list at 350 35
	--third list at 475,35

	--scrollElement:AddImage(0,12,"CraftingWindowSectionBackground",740,132,"Sliced")
	--scrollElement:AddLabel(15,75,,100,100,15)--label for minimum skill
	--scrollElement:AddImage(205,5,"VerticalWindowDivider",1,80)
	-- scrollElement:AddImage(595,5,"VerticalWindowDivider",1,120)

	--DebugMessage("Description is "..tostring(Description))
	if (type(Description) == "string") then
		--scrollElement:AddLabel(215,30,"Description: "..Description,330,60,15)
	elseif type(Description) == "table" then
		--scrollElement:AddLabel(215,30,"Stats:",110,60,15)
		--scrollElement:AddLabel(265,30,Description[1],110,60,15)
		--scrollElement:AddLabel(340,30,Description[2],110,60,15)
		--scrollElement:AddLabel(445,30,Description[3],110,60,15)
	else
		DebugMessage("[base_crafting_controller|DisplayItem] ERROR: Crafting description is not string or table. This should never happen.")
	end	

	local qualityResourceTable = GetQualityResourceTable(j.Resources,selectedQuality)
   --[[	if(qualityResourceTable ~= nil) then   		
		--160 320 , 50x
		local count = 0
		for l,m in pairs(qualityResourceTable) do
			local displayName = l
			if not(ResourceData.ResourceInfo[l] ) then DebugMessage("[base_crafting_controller|DisplayItem] ERROR: Resource has invalid name, Recipe: "..i) return end
			if( ResourceData.ResourceInfo[l].DisplayName ~= nil) then
				displayName = ResourceData.ResourceInfo[l].DisplayName
			end
			resourcesString = tostring(resourcesString) .. " " .. tostring(m) .. " " .. tostring(displayName) .. ","
		end
		resourcesString = StripTrailingComma(resourcesString)
		scrollElement:AddLabel(15,105,resourcesString,300,100,15)--label for resources required
	end
	
	local userActionData = GetDisplayItemActionData(i,j,"Flimsy")
	scrollElement:AddUserAction(15,30,userActionData,32)

	if (j.CanImprove) then
		local resourceTable = GetQualityResourceTable(j.Resources,"Stout")
		if(resourceTable ~= nil) then
			userActionData = GetDisplayItemActionData(i,j,"Stout")
			scrollElement:AddUserAction(52,30,userActionData,32)
		end

		local resourceTable = GetQualityResourceTable(j.Resources,"Sturdy")
		if(resourceTable ~= nil) then
			userActionData = GetDisplayItemActionData(i,j,"Sturdy")
			scrollElement:AddUserAction(89,30,userActionData,32)
		end
		
		local resourceTable = GetQualityResourceTable(j.Resources,"Robust")
		if(resourceTable ~= nil) then
			userActionData = GetDisplayItemActionData(i,j,"Robust")
			scrollElement:AddUserAction(126,30,userActionData,32)
		end

		local resourceTable = GetQualityResourceTable(j.Resources,"Stalwart")
		if(resourceTable ~= nil) then
			userActionData = GetDisplayItemActionData(i,j,"Stalwart")
			scrollElement:AddUserAction(163,30,userActionData,32)
		end
	end

	--local qualityIndex = QualityIndex[selectedQuality]
	--scrollElement:AddImage(15+37*(qualityIndex-1)-3,30-3,"CraftingWindowWeaponTypeHighlight")

	--local craftText = "Craft"
	--if (not CanCraftItem(i)) then
	--	craftText = "[555555]Craft[-]"
	--	--reason = CannotCraftReason(i)
	--end

	scrollElement:AddButton(605,55,i,craftText,120,45,"Craft this item.",nil,true)
	--grey out the whole thing if we don't know the recipe
	if (not HasRecipe(this,i,mSkill)) then
		scrollElement:AddImage(0,12,"GreyOutImage",740,132,"Sliced","000000")
		reason = "[9D3E3A]You do not know this recipe.[-]"
		--scrollElement:AddImage(0,0,"CraftingWindowSectionHeader",300,28,"Sliced","888888")
	else
		--scrollElement:AddImage(0,0,"CraftingWindowSectionHeader",300,28,"Sliced")
	end

	scrollElement:AddLabel(605,20,reason,120,30,15)
	scrollElement:AddLabel(25,5,j.DisplayName,300,100,17)--label with name of item
	
	scrollWindow:Add(scrollElement)
end
--]]

RegisterEventHandler(EventType.DynamicWindowResponse,"CraftingProgressBar",function ( ... )
	InterruptCrafting(true)
end)

RegisterEventHandler(EventType.Timer,"ShowCraftingMenu",function ( ... )
	ShowCraftingMenu(...)
end)

RegisterEventHandler(EventType.ClientUserCommand, "ChangeMaterial",
function (material)
	if ( this:HasTimer("CraftingTimer") or not Materials[material] ) then return end
	mCurrentMaterial = material
	ShowCraftingMenu()
end)

RegisterEventHandler(EventType.Message, "InitiateCrafting",
function (fabTool,skill,initialTab)
	if(fabTool == nil) then CleanUp() end
	mTool = fabTool
	mSkill = skill
	if not(mCurrentTab) then
		mCurrentTab = initialTab
		mCurrentCategory = nil
	end

	local fabCont = mTool:TopmostContainer() or mTool
	local fabLoc = fabCont:GetLoc()
	if(this:GetLoc():Distance(fabLoc) > USAGE_DISTANCE ) then
		--DebugMessage("Too Far to Fabricate")
		this:SystemMessage("[FA0C0C]You are too far to use that![-]")
		CleanUp()
		return
	end

	ShowCraftingMenu()
end)

--This fires when the client object command is droppe
RegisterEventHandler(EventType.ClientObjectCommand,"dropAction",
	function (user,sourceId,actionType,actionId,slot)
		if(sourceId == "CraftingWindow" and slot ~= nil) then
			
			local result = StringSplit(actionId,"=")
			--DebugMessage(actionId.." is actionId")
			recipe = result[2] or result[1]
			quality = result[1]

			--DebugMessage ("quality is "..tostring(quality) .. " recipe is "..tostring(recipe))
			local recipeTable = GetRecipeTableFromSkill(mSkill)[recipe]
			local itemName = GetRecipeItemName(recipeTable,quality)
			local itemName,color = StripColorFromString(itemName)
			local displayName = "Craft "..itemName
			if(color ~= nil) then
				displayName = color.."Craft "..itemName.."[-]"
			end

			--DebugMessage("recipeTable is "..tostring(recipeTable))
			local hotbarAction = {
				ID = actionId,
				ActionType = "CraftItem",
				DisplayName = displayName,
				Tooltip = "Craft this item.", --DFBTODO ADD RESOURCES ETC
				IconObject = GetTemplateIconId(recipeTable.CraftingTemplateFile),
				Enabled = true,
				Requirements = {
					{mSkill,GetRecipeSkillRequired(recipe,mCurrentMaterial)}
				},
				ServerCommand = "CraftItem "..recipe.." "..quality.." "..mSkill,
			}
			hotbarAction.Slot = tonumber(slot)
			RequestAddUserActionToSlot(user,hotbarAction)
		end
	end)

RegisterEventHandler(EventType.Timer,"AutoCraftItem", function(quality)
	mQuality = quality
	mCount = (mCount or 1) + 1
	TryCraftItem(this, mRecipe, mSkill,true,mQuality)
end)

function HandleCraftItem(user,recipe,quality,skill,tool)
	if (this:HasTimer("CraftingTimer")) then
		return
	end
	this:RemoveTimer("AutoCraftItem")
	mAutoCraft = false
	mSkill = skill
	mQuality = quality
	--TEMP 
	mTool = tool
	--/TEMP
	mRecipe = recipe
	this:CloseDynamicWindow("CraftingWindow")
    --DebugMessage("user is "..tostring(user).." recipe is "..tostring(recipe).." quality is "..tostring(quality).." skill is "..tostring(skill))
	TryCraftItem(this, recipe, skill,true,quality)
end

RegisterEventHandler(EventType.CreatedObject,"RefundResources",
	function(success,objRef,amount)
		if ( amount ~= nil and amount > 1) then 
			RequestSetStack(objRef,amount)
		end
		--finish cleaning up
		this:PlayAnimation("idle")
		if(this:HasTimer("CraftingTimer")) then this:RemoveTimer("CraftingTimer") end	
		CleanUp()
	end)

RegisterEventHandler(EventType.Timer,"AnimationTimer",
	function(user)
		if(this:HasTimer("CraftingTimer")) then 
			--local toolAnim = mTool:GetObjVar("ToolAnimation")
			--if(toolAnim ~= nil) then
			--	this:PlayAnimation(toolAnim)
			--end
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(1.5),"AnimationTimer")
			if (mTool ~= nil) then
				FaceObject(this,mTool)
			else
				CleanUp()
				return
			end
		elseif not(mAutoCraft) then
    		this:PlayAnimation("idle")
    	end
	end)

RegisterEventHandler(EventType.Message,"CraftItem",HandleCraftItem)
RegisterEventHandler(EventType.Timer,"RemoveCraftingModule", CleanUp)
RegisterEventHandler(EventType.Timer,"CraftingTimer", HandleCraftingTimer)
RegisterEventHandler(EventType.CreatedObject,"crafted_item", HandleItemCreation)
RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", HandleConsumeResourceResponse)
RegisterEventHandler(EventType.DynamicWindowResponse, "CraftingWindow", HandleCraftingMenuResponse)
RegisterEventHandler(EventType.StartMoving, "" , InterruptCrafting)

-- require "default:base_crafting_controller"
-- NOS from here
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
	local reqSkillLev, maxSkillLev = GetRecipeSkillRequired(userRequest, mCurrentMaterial)
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
			local skillReq, maxSkill = GetRecipeSkillRequired(mRecipe, mCurrentMaterial)
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
