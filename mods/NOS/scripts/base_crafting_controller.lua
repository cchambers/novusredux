require 'default:base_crafting_controller'

function HandleCraftRequest(userRequest,skill,stopCraftingOnFailure)
	mResourceTable = nil
	if(this:HasTimer("CraftingTimer")) then
		this:SystemMessage("[FA0C0C]You are already crafting something[-]","info")
		if not(mCrafting) then
			if (stopCraftingOnFailure) then
			   CleanUp()
			end
		end
		return
	end

	skillName = StripFromString(skill,"Skill")
	if (mTool == nil) then 
		CleanUp()
		return
	end
	local fabCont = mTool:TopmostContainer() or mTool
	local fabLoc = fabCont:GetLoc()
	if(this:GetLoc():Distance(fabLoc) > USAGE_DISTANCE ) then
		this:SystemMessage("[FA0C0C]You are too far to use that![-]","info")
			if (stopCraftingOnFailure) then
			   CleanUp()
			end
		return
	end
	if not(this:HasLineOfSightToObj(fabCont,ServerSettings.Combat.LOSEyeLevel)) and not(fabCont:HasObjVar("IgnoreLOS")) then 
		this:SystemMessage("[FA0C0C]You cannot see that![-]","info")
			if (stopCraftingOnFailure) then
			   CleanUp()
			end
		return 
	end
	local backpackObj = this:GetEquippedObject("Backpack")
	local craftTemplate = GetRecipeTableFromSkill(skill)[userRequest]
	local canCreate, reason = CanCreateItemInContainer(GetCraftTemplate(userRequest),backpackObj, craftTemplate.StackCount)

	if (not canCreate) then
		if(reason == "full") then
			this:SystemMessage("[FA0C0C]Your backpack is full![-]","info")
		elseif(reason == "overweight") then
			this:SystemMessage("[$1622]","info")
		end
		return
	end
	mItemToCraft = userRequest
	local recipeTable = GetRecipeTableFromSkill(mSkill)[userRequest]
	local resourceTable = recipeTable.Resources
	local entryTable = {}

	if (not HasRecipe(this,userRequest,skill)) then
		this:SystemMessage("[$1623]" ..userRequest .. "[-]","info")
			if (stopCraftingOnFailure) then
			   CleanUp()
			end
		return
	end

	local reqSkillLev, maxSkillLev = GetRecipeSkillRequired(this,userRequest,mCurrentMaterial)
	if (not HasRequiredCraftingSkill(this,userRequest,skill) ) then
		this:SystemMessage("You don't have enough "..skillName.." skill to craft item: " ..userRequest .. "" .." - Need "..reqSkillLev..", Have "..GetSkillLevel(this,mSkill), "info")
			if (stopCraftingOnFailure) then
			   CleanUp()
			end
		return
	end
	if (not this:HasObjVar("CanCraftOutOfThinAir")) then
		if not(HasResources(resourceTable, this, mCurrentMaterial)) then
			this:SystemMessage("[$1624]" ..userRequest .. "[-]","info" )
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

	mSkillLevel = GetSkillLevel(this,mSkill)
	local skillToCheck = mSkillLevel
	local addSkill = (GetSkillLevel(this,"ArmsLoreSkill") or 0.1) / 20
	local mentor = this:GetObjVar("MentorPath")
	local pre = addSkill
	if (mentor ~= nil) then
		if (mentor == "TradeTypeSkill") then
			addSkill = addSkill + (GetSkillLevel(this,"MentoringSkill") or 0.1) / 20
		end
	end
	local post = addSkill
	skillToCheck = skillToCheck + addSkill
	
	local chance = SkillValueMinMax(skillToCheck, reqSkillLev, maxSkillLev)
	mSuccess = CheckSkillChance(this, mSkill, skillToCheck, chance)
	

	local consumeTable = resourceTable
	if not(mSuccess) and recipeTable.ConsumeOnFail then
		consumeTable = {}
		for resourceName,resourceAmount in pairs(resourceTable) do 
			consumeTable[resourceName] = recipeTable.ConsumeOnFail[resourceName]
		end
	end
	ConsumeResources(consumeTable, this, "crafting_controller", mCurrentMaterial)
end
