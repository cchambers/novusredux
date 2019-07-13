require 'base_tool_resourceharvester'

DEPLETION_AVOIDANCE_SKILL_THRESHOLD = 40
DEPLETION_INCREASE_SKILL_THRESHOLD = 30


ResourceHarvester.ToolType = "Axe"
ResourceHarvester.HarvestAnimation = "choptree"
ResourceHarvester.HarvestAnimationDurationSecs = 1.2
ResourceHarvester.DefaultHarvestDelaySecs = 2

RegisterSingleEventHandler(EventType.ModuleAttached,"tool_lumberaxe",
	function ()
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "DelayedTooltipUpdate")
		ResourceHarvester.Initialize()
	end)

toolBonuses ={ 
	BonusHarvestDelay = { DisplayString = " Faster Harvesting Speed", reverseStat = true },
	BonusHarvestEfficiency = { DisplayString = " Increased Harvesting Efficiency", reverseStat = false },
	BonusHarvestYield = { DisplayString = "% Increased Harvesting Yield", reverseStat = false },
}

function GetModifierString(bonusName)
	local modStr = "" 
	local bonusValue = 0
	if(this:HasObjVar(bonusName)) then
		bonusValue = this:GetObjVar(bonusName)
	end
	if( bonusValue == 0 ) then
		return ""
	elseif( bonusValue > 0 ) then
		modStr = "+" .. tostring(bonusValue) .. " " .. toolBonuses[bonusName].DisplayString
	else
		modStr = tostring(bonusValue) .. " " .. toolBonuses[bonusName].DisplayString
	end

	return ColorizeStatString(modStr,bonusValue, toolBonuses[bonusName].reverseStat) .. "\n"
end

function UpdateToolTooltipString()
	local tooltipString = ""
	--DebugMessage("UpdateToolTooltipString")
	local myTooltipString = ""
	for i, j in pairs(toolBonuses) do
		myTooltipString = myTooltipString .. GetModifierString(i)
	end

	if( myTooltipString ~= "" ) then
		SetTooltipEntry(this,"tool_lumberaxe",myTooltipString)
	end
end

mHarvestedStackCount = 1

-- ResourceHarvester.CollectResource = function(user,resourceType)
-- 	local backpackObj = user:GetEquippedObject("Backpack")  
-- 	if( backpackObj ~= nil ) then

-- 		--DebugMessage("RES TYPE:" .. resourceType)
-- 		local resSkill = ResourceData.ResourceInfo[resourceType].HarvestBonusSkill		
-- 		local skillVal = 0
-- 		if(resSkill) then
-- 			skillVal = GetSkillLevel(user,resSkill)
-- 		end

-- 		mHarvestedStackCount = 1
-- 		if( Success(0.25) ) then
-- 			mHarvestedStackCount = 2
-- 		end

-- 		local difficulty = 1
-- 		if ( ResourceData.ResourceInfo[resourceType].Difficulty ) then
-- 			difficulty = SkillValueMinMax( skillVal, ResourceData.ResourceInfo[resourceType].Difficulty.Min or 100, ResourceData.ResourceInfo[resourceType].Difficulty.Max or 100)
-- 		end
-- 		--user:NpcSpeech("Difficulty: "..difficulty)
-- 		if resSkill == nil or not CheckSkillChance( user, resSkill, skillVal, difficulty ) then	
-- 	    	user:SystemMessage("Failed to harvest any usable resources.", "info")
-- 			return
-- 		end

-- 		-- see if the user gets an upgraded version
-- 		resourceType = GetHarvestResourceType(user,resourceType,resSkill)
-- 		if (resourceType == nil) then return end
		
-- 		-- try to add to the stack in the players pack		
-- 	    if not( TryAddToStack(resourceType,backpackObj,mHarvestedStackCount) ) then
-- 	    	-- no stack in players pack so create an object in the pack
-- 	        local templateId = ResourceData.ResourceInfo[resourceType].Template
-- 	    	CreateObjInBackpackOrAtLocation(user,templateId, "create_lumberaxe_harvest", mHarvestedStackCount)
-- 	    end

-- 	    local displayName = GetResourceDisplayName(resourceType)
-- 	    user:SystemMessage("Harvested "..mHarvestedStackCount.." "..displayName..".", "info")
-- 	    user:NpcSpeech("[F4FA58]+"..mHarvestedStackCount.." "..displayName.."[-]", "combat")
-- 	end	

-- end

base_CompleteHarvest = ResourceHarvester.CompleteHarvest
ResourceHarvester.CompleteHarvest = function(objRef,user)
	base_CompleteHarvest(objRef,user,1)
end

RegisterEventHandler(EventType.CreatedObject, "create_lumberaxe_harvest", 
	function(success, objRef, amount)
		--DebugMessage("Created Object")
		if(success == true) then
			SetItemTooltip(objRef)
			local resName = objRef:GetObjVar("ResourceType")
			if(resName == nil) then return end
			if(amount < 2) then return end
		--local backpackObj = this:GetEquippedObject("Backpack")
			RequestSetStack(objRef,amount)
		end
	end)

RegisterEventHandler(EventType.Timer, "DelayedTooltipUpdate", 
	function()
		UpdateToolTooltipString()
	end)

RegisterEventHandler(EventType.Message, "UpdateTooltip", 
	function()
		UpdateToolTooltipString()
	end)

-- NOS EDITS

ResourceHarvester.CollectResource = function(user,resourceType)
	--DebugMessage("tool_lumberaxe.lua: CollectResource(): "..resourceType)
	local backpackObj = user:GetEquippedObject("Backpack")
	if( backpackObj ~= nil ) then
		local resSkill = ResourceData.ResourceInfo[resourceType].HarvestBonusSkill
		local skillVal = 0
		if(resSkill) then
			skillVal = GetSkillLevel(user,resSkill)
		end

		mHarvestedStackCount = 1
		if( Success(0.25) ) then
			mHarvestedStackCount = 2
		end

		-- failed skill check chance, lose the resource
		local difficulty = 1
		if ( ResourceData.ResourceInfo[resourceType].Difficulty ) then
			difficulty = SkillValueMinMax( skillVal, ResourceData.ResourceInfo[resourceType].Difficulty.Min or 100, ResourceData.ResourceInfo[resourceType].Difficulty.Max or 100)
		end

		--user:NpcSpeech("Difficulty: "..difficulty)
		if resSkill == nil or not CheckSkillChance( user, resSkill, skillVal, difficulty ) then
	    	user:SystemMessage("Failed to harvest any usable resources.", "info")
			return
		end

		-- If it hasn't failed, add extra based on Harvesting Skill.
		-- Max number of goods per harvesting skill:
		-- Skill:   0   20  40  60  80  100
		-- # Goods: 0   0   0   0   1   1
		-- Has appriximately a 16% chance to get an extra resource at 80.
		-- Has approximately a 28% chance to get an extra resource at GM.
		local HarvestingSkill = GetSkillLevel(user, "HarvestingSkill")
		local maxHarvestingChance = math.floor(HarvestingSkill / 13)
		local harvestingBonus = 0
		if(math.random(0, maxHarvestingChance) > 5) then
			harvestingBonus = 1
		end
		mHarvestedStackCount = mHarvestedStackCount + harvestingBonus

		-- see if the user gets an upgraded version
		resourceType = GetHarvestResourceType(user,resourceType,resSkill)
		if (resourceType == nil) then return end
		
		-- try to add to the stack in the players pack
	    if not( TryAddToStack(resourceType,backpackObj,mHarvestedStackCount) ) then
	    	-- no stack in players pack so create an object in the pack
	        local templateId = ResourceData.ResourceInfo[resourceType].Template
	    	CreateObjInBackpackOrAtLocation(user,templateId, "create_lumberaxe_harvest", mHarvestedStackCount)
	    end

	    local displayName = GetResourceDisplayName(resourceType)
	    user:SystemMessage("Harvested "..mHarvestedStackCount.." "..displayName..".", "info")
	    user:NpcSpeech("[F4FA58]+"..mHarvestedStackCount.." "..displayName.."[-]", "combat")
	end	
end