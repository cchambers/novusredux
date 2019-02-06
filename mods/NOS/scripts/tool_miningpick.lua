require 'default:tool_miningpick'

ResourceHarvester.CollectResource = function(user,resourceType)
	--DebugMessage("tool_miningpick.lua: CollectResource(): "..resourceType)
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
	    	CreateObjInBackpackOrAtLocation(user,templateId, "create_miningpick_harvest", mHarvestedStackCount)
	    end

	    local displayName = GetResourceDisplayName(resourceType)
	    user:SystemMessage("Harvested "..mHarvestedStackCount.." "..displayName..".", "info")
	    user:NpcSpeech("[F4FA58]+"..mHarvestedStackCount.." "..displayName.."[-]", "combat")
	end	
end