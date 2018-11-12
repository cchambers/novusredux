
--CLASS_MINOR = "MinorIngredient"

require 'base_cooking'
PENALTY_PER_PROP = .9
BASE_FOOD_DURATION = 10
mPreparationEffects = {}
mCookingItems = {}
mFinishedCooking = false
mFoodPot = nil
this:ScheduleTimerDelay(TimeSpan.FromSeconds(30), "COOKING_CLEANUP_TIMER")
mSkNum = 0
mCookDiff = 0
mModPenalties = {}
mGoodFood = false
mEpicFail = false
mHeatSource = nil
mBaseFillingness = 10

--ApplyBonusesToCookedFood
RegisterEventHandler(EventType.CreatedObject,"cooked_food_item", 
	function (success, objFood)
		if(success == false) then
			this:SystemMessage("[FA0C0C] You utterly fail your cooking attempt.[-]")
			CleanUp()
			return
		end

		cookingSkill = GetSkillLevel(this,"CookingSkill")

		local foodVals = {}
		local fillingness = 0
		local fillingnessMod = 1
		local durationMod = 1
		local duration = 0
		local resultMod = 1
		if(mGoodFood == false) then
			resultMod = .5
		end
		--DebugTable(mPreparationEffects)
		if(mEpicFail) then
			--DebugMessage("EPIC FAIL")
		
			fillingness = math.random(1,12)
			duration = math.random(15,20)
			foodVals["HealthRegenMod"]= {
			Multiplier = .5
			}
		else	
			--DebugMessage("Cooking")
			local myPotMod = mPreparationEffects.bonusPotency
			if(myPotMod == nil) then myPotMod = 1 end
			local bonusPotency = 0
			local potencyMod = 1
			if(mPreparationEffects["foodEffectPotencyMod"] ~= nil and mPreparationEffects["foodEffectPotencyMod"].Bonus ~= nil) then
				bonusPotency = mPreparationEffects["foodEffectPotencyMod"].Bonus
			end
			for prp, vals in pairs(mPreparationEffects) do
				--objFood:SetObjVar(prp, vals)
				--DebugMessage("PRP: ".. prp.. " |Vals: " .. vals)
				local filling = string.find(prp, "Fillingness")
				local dur = string.find(prp, "Duration")
				local potency = string.find(prp, "Potency")
				--if(filling == nil) and (dur == nil) and (potency == nil)then
				--DebugMessage("Filling :" ..tostring(filling))
				local bonVal = mPreparationEffects[prp].Bonus
				if (foodVals[prp] == nil ) then foodVals[prp] = {} end
				if(bonVal ~= nil and bonVal ~= 0) then
					if(mPreparationEffects[prp].BonusCount ~= nil and mPreparationEffects[prp].BonusCount > 1) then
						bonVal = bonVal * (math.pow(PENALTY_PER_PROP, mPreparationEffects[prp].BonusCount - 1 ))
					end
					foodVals[prp].Bonus = bonVal
				end
				local modVal = mPreparationEffects[prp].Multiplier
				if(modVal ~= nil and modVal ~= 1) then
					if(mPreparationEffects[prp].MultCount ~= nil and mPreparationEffects[prp].MultCount > 1) then
						modVal = modVal * (math.pow(PENALTY_PER_PROP, mPreparationEffects[prp].MultCount - 1 ))
					end
					foodVals[prp].Multiplier = modVal
				end
				--[[else
				if(filling ~= nil) then
					if(prp == "baseFillingness") then
						fillingness = fillingness + mPreparationEffects.baseFillingness
					else
						fillingnessMod = math.max(.1, vals)
					end
				else
					if(prp == "baseDuration") then
						duration = duration + vals
						else
						durationMod = math.max(.1, vals)
					end
				end
				]]
				--end
			end

			local bonusPot = 0
			local potencyMod = 1
			if(foodVals["foodEffectPotencyMod"] ~= nil and foodVals["foodEffectPotencyMod"].Bonus ~= nil) then bonusPot = foodVals["foodEffectPotencyMod"].Bonus end
			if(foodVals["foodEffectPotencyMod"] ~= nil) then potencyMod = foodVals["foodEffectPotencyMod"].Multiplier or 1 end
			for eff, valTab in pairs(foodVals) do
				local filling = string.find(eff, "Fillingness")
				local dur = string.find(eff, "Duration")
				local potency = string.find(eff, "Potency")
				if(filling == nil) and (dur == nil) and (potency == nil) then
					if(valTab.Bonus ~= nil) then

						local bonusVal = (valTab.Bonus + bonusPot) * potencyMod * resultMod
						valTab.Bonus = bonusVal
					end
					if(valTab.Multiplier ~= nil)  then	
						--DebugMessage("Potency Mod :" ..potencyMod)
						if(valTab.Multiplier >= 1) then
							local multVal = (valTab.Multiplier * potencyMod) * resultMod
							valTab.Multiplier = multVal
						else
								local multVal = (1 -valTab.Multiplier) * (potencyMod * resultMod)
								valTab.Multiplier = 1 - multVal
						end
					end

				end
			end
			
	
			
			--DebugMessage("FFFFFFF")
	
			fillingness = mBaseFillingness or 1
			local durFilling = fillingness * 30
			local bonusDuration = 0
			local durationMod = 1
			if(foodVals["foodEffectDurationMod"] ~= nil) then
				bonusDuration = 0 
				if(foodVals["foodEffectDurationMod"].Bonus ~= nil) then bonusDuratiion = foodVals["foodEffectDurationMod"].Bonus end
				durationMod = foodVals["foodEffectDurationMod"].Multiplier or 1
			end
			local bonusFillingness = 0	
			local fillingnessMod = 1
			if(foodVals["foodFillingnessMod"] ~= nil) then
				if(foodVals["foodFillingnessMod"].Bonus ~= nil) then bonusFillingness = foodVals["foodFillingnessMod"].Bonus end
				fillingnessMod = foodVals["foodFillingnessMod"].Multiplier or 1
			end
			duration = math.max(1,(durFilling + bonusDuration) * durationMod)
			--DebugMessage("Fillingness: " ..tostring(fillingness) .. " Mod:" ..fillingnessMod)
			fillingness = math.max(1, fillingness * fillingnessMod)
			mFoodVals = foodVals
			--DebugMessage("WFT")
		end
			--if(fillingness > maxFilling)
			--BB HERE Calculate foodvals before cooking so that food can be sure to be eaten. Apply to food on eating
		--Modify eating to account for new food values.
		objFood:SetObjVar("cooked", true)
		if not(IsTableEmpty(foodVals)) then
			foodVals["foodFillingnessMod"] = nil
			foodVals["foodEffectPotencyMod"] = nil
			foodVals["foodEffectDurationMod"] = nil
			objFood:SetObjVar("FoodBonuses", foodVals)
		end
		--DebugMessage("ValsTot: " .. CountTable(foodVals))
		objFood:SetObjVar("Duration" , duration)
		objFood:SetObjVar("FoodValue", fillingness)
		local cookString = "[33FFBB] You have cooked "
		if(mGoodFood == false) then cookString =  "[FA0C0C]You have burned " end
		mModPenalties = {}
		this:SystemMessage(cookString .. objFood:GetName() .."[-]")
		objFood:SendMessage("UpdateTooltip")
		--DebugMessage("Cooked Some Shit")
		this:FireTimer("COOKING_CLEANUP_TIMER")
	
end)


function CanCookThisFilling(filling)
	if(filling == nil) then return false end
	local maxFilling = ServerSettings.Misc.FoodFillingnessCap or 40
	if(filling > maxFilling) then return false end
	return true
end

--CreateFood
RegisterEventHandler(EventType.Timer, "CraftingTimer",
	function ()
	local myLoc = this:GetLoc()
	local fireLoc = mHeatSource:GetLoc()
	if(mHeatSource == nil) then
		CleanUp()
		return
	end
	local dist = myLoc:Distance(fireLoc)
	if(dist > 2) then
			this:SystemMessage("[$1772]")
			CleanUp()
		return
	end
		mFinishedCooking = true
--DebugMessage("Creating MEat Stew")
	HandleSkillGainCheck()
		local backpackObj = this:GetEquippedObject("Backpack")
 			local randomLoc = GetRandomDropPosition(this)
 			local itemTemplate = "cooked_stew"
	--local cookingEffectiveness = GetSkillPotency(cookingSkill)
	local diffEffect = mCookDiff - mSkNum
	local diffMod = 1
	if(diffEffect > 0) then
		diffMod = math.min(.1,(mCookDiff /mSkNum))
	else
		diffMod = 1 + ((diffEffect/mSkNum) * -1)
	end

	local epicFail = 1 + math.max(0,diffEffect)
	local cookRoll = math.random(1,100)
	local cookResult = cookRoll / diffMod
	local cookChance = (mCookDiff / mSkNum) * 60

	--DebugMessage("Roll: " ..cookRoll .. " diffMod: " ..diffMod .. " cookChance: " ..cookChance .. " Result: " ..cookResult )
	if(cookResult < epicFail) then
		mEpicFail = true
	end
	if(cookResult > cookChance) and not mEpicFail then
		mGoodFood = true
	else
		itemTemplate = "burnt_stew"
	end
   			--DebugMessage("Making Item")
   			CreateObjInContainer(itemTemplate, backpackObj, randomLoc, "cooked_food_item")
   			--DebugMessage("Item Made")


	end)
RegisterEventHandler(EventType.Timer, "CookingGainTimer",
function ()
	if(this:HasTimer("CraftingTimer")) and (mFinishedCooking ~= false) then
			HandleSkillSkillGainCheck()
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(math.random(3,7)), "CookingGainTimer")
			return
	end

end)

function HandleSkillGainCheck()
	if not(HasSkill(this,"CookingSkill")) then
		CleanUp()
		return
	end
	local myLoc = this:GetLoc()
	local fireLoc = mHeatSource:GetLoc()
	local dist = myLoc:Distance(fireLoc)
	if(dist > 2) then
			this:SystemMessage("[$1773]")
			CleanUp()
		return
	end

	this:SendMessage("RequestSkillGainCheck",  "CookingSkill", mCookDiff)
end


--PrepFoodEffects
RegisterEventHandler(EventType.Message, "StartCookingMessage", 
function (cookingArgs)
	--DebugMessage("Starting Cooking")
	local objFoodPot = cookingArgs.tool
	if(objFoodPot:TopmostContainer() ~= this) then
		CleanUp()
		return
	end
	mHeatSource = cookingArgs.heatSource
	if(mHeatSource == nil) then
		CleanUp()
		return
	end
	local myLoc = this:GetLoc()
	local fireLoc = mHeatSource:GetLoc()
	local dist = myLoc:Distance(fireLoc)
	if(dist > 3) then
			this:SystemMessage("[$1774]")
			CleanUp()
			return
	end
	if not(HasSkill(this, "CookingSkill")) then
		this:SystemMessage("[$1775]")
		CleanUp()
		return
	end

	if(this:HasTimer("CraftingTimer")) then
		this:SystemMessage("[$1776]")
		CleanUp()
		return
	end

	mFoodPot = objFoodPot
	local foodPotLoc = objFoodPot:TopmostContainer()
	if(foodPotLoc ~= this) then
		this:SystemMessage("[$1777]")
		CleanUp()
		return
	end
	mCookingItems = objFoodPot:GetContainedObjects()
	if(mCookingItems == nil) then 
			CleanUp()
		return
	end
	local totalDiff = 0
	local maxDiff = 0
	mSkNum = GetSkillLevel(this,"CookingSkill")

	--D*ebugTable(mCookingItems)
	local curFV = 0
	for f, e in pairs(mCookingItems) do
		local curDiff = 10
		if(e:HasObjVar("CookingDifficulty")) then
			curDiff = e:GetObjVar("CookingDifficulty") 
		end
		totalDiff = curDiff + totalDiff
		if(maxDiff < curDiff) then maxDiff = curDiff end
		local fv = e:GetObjVar("FoodValue")
		if(fv == nil) then
			this:SystemMessage(e:GetName() .. "[FA0C0C] is not a valid ingredient for cooking.[-]")
			mFinishedCooking = true
			CleanUp()
			return
		end
		local fc = GetStackCount(e)
		if(fc == nil) then fc = 1 end
		--DebugMessage("FV: " .. fv)
		curFV = curFV + (fv * fc)
		local foodFx = e:GetObjVar("FoodEffects")
		if not (foodFx == nil) then 
		--DebugMessage(foodFx)
	 		for eft, nval in pairs(foodFx) do
	 			local tBon = 0
	 			if(nval.Bonus ~= nil) then tBon = nval.Bonus end 
	 			local inEff = mPreparationEffects[eft]
	 			local curBon = 0
	 			local bonCount = 0
	 			if(inEff == nil) then mPreparationEffects[eft] = {} end
				if(inEff ~= nil and mPreparationEffects[eft].Bonus ~= nil) then 
					curBon = mPreparationEffects[eft].Bonus
					if(mPreparationEffects[eft].BonusCount ~= nil) then 
						bonCount = mPreparationEffects[eft].BonusCount 
		 			end 
		 		end
	 			if(tBon ~= 0) then
	 				mPreparationEffects[eft].Bonus = tBon + curBon
	 				if(tBon > 0) then bonCount = bonCount + 1 end  --Ignore penalties
		 			mPreparationEffects[eft].BonusCount = bonCount
		 		end
	 			local tMod = nval.Multiplier
	 			local curMod = 1
	 			if(tMod ~= nil) then
	 				local multCount = 0
	 				if(inEff ~= nil and mPreparationEffects[eft].Multiplier ~= nil) then 
	 					curMod = mPreparationEffects[eft].Multiplier
	 					local cVal = mPreparationEffects[eft].MultCount
	 					if(cVal ~= nil) then multCount = mPreparationEffects[eft].MultCount end
	 				end
	 				if(tMod > 1) then multCount = multCount + 1 end --Ignore Penalties
	 				mPreparationEffects[eft].Multiplier = curMod * tMod
	 				mPreparationEffects[eft].MultCount = multCount 
	 			end
	 		end
	 	end
	 end
		mBaseFillingness = curFV
		if not(CanCookThisFilling(curFV)) then
			this:SystemMessage("[$1778]", "event")
			FailClean()
			return
		end
		local avgDiff = math.max(0,totalDiff / #mCookingItems)
		local cookSize = #mCookingItems
		mCookDiff = cookSize + math.max(avgDiff, maxDiff) + (totalDiff / 10 )

		local cookTime = math.max(5,(#mCookingItems + avgDiff) / 6)	
		ProgressBar.Show(
		{
			TargetUser = this,
			Label="Cooking",
			Duration=TimeSpan.FromSeconds(cookTime)
		})
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(cookTime), "CraftingTimer", cookTime - 10)
		this:PlayObjectSound("SoupCook")
		objFoodPot:SendMessage("ConsumeIngredients")
end)

function FailClean()
	if(this:HasTimer("CraftingTimer")) then
		this:RemoveTimer("CraftingTimer")
	end
	if(this:HasTimer("COOKING_CLEANUP_TIMER")) then
		this:RemoveTimer("COOKING_CLEANUP_TIMER")
	end
	this:DelModule("cooking_controller") 

end
function CleanUp()
	--mFoodPot:SendMessage("DurabilityLossCheckMessage", "Use", false, this, this)
	mCookingItems = {}
	mPreparationEffects = {}
	mFoodPot = nil
	if(mFinishedCooking == false) then
		this:SystemMessage("[F7CC0A] You burn the contents to ash.[-]")
	end
	if(this:HasTimer("CraftingTimer")) then
		this:RemoveTimer("CraftingTimer")
	end
	if(this:HasTimer("COOKING_CLEANUP_TIMER")) then
		this:RemoveTimer("COOKING_CLEANUP_TIMER")
	end
	ProgressBar.Cancel("Cooking",this)

	this:DelModule("cooking_controller")
end

RegisterEventHandler(EventType.StartMoving, "", 
	function()
		--DebugMessage(this:GetName() .. " started Moving")
	end)

RegisterEventHandler(EventType.Timer, "COOKING_CLEANUP_TIMER" , CleanUp)
RegisterEventHandler(EventType.Message, "COOKING_CRAFTING_REQUEST", PrepareFood)
RegisterEventHandler(EventType.CreatedObject,"cooking_crafted_item", HandleFoodCreated)