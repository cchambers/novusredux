require 'base_tool_resourceharvester'
DEPLETION_AVOIDANCE_SKILL_THRESHOLD = 40
DEPLETION_INCREASE_SKILL_THRESHOLD = 30
BASE_HARVEST_CHANCE = 10
ResourceHarvester.ToolType = "Knife"
ResourceHarvester.HarvestAnimation = "carve"
-- 0 means the animation does not loop
ResourceHarvester.HarvestAnimationDurationSecs = 0
ResourceHarvester.DefaultHarvestDelaySecs = 3
--
toolBonuses ={ 
	BonusHarvestDelay = { DisplayString = " Faster Harvesting Speed", reverseStat = true },
	BonusHarvestEfficiency = { DisplayString = " Increased Harvesting Efficiency", reverseStat = false },
	BonusHarvestYield = { DisplayString = "% Increased Harvesting Yield", reverseStat = false },
}

base_CompleteHarvest = ResourceHarvester.CompleteHarvest
ResourceHarvester.CompleteHarvest = function(objRef,user,depletionAmount)
	-- make sure the user is still valid
	if( user == nil or not(user:IsValid()) ) then return end

	user:PlayAnimation("kneel_standup")

	base_CompleteHarvest(objRef,user,depletionAmount)
end


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
		SetTooltipEntry(this,"tool_hunting_knife",myTooltipString)
	end
end

--
RegisterSingleEventHandler(EventType.ModuleAttached,"tool_hunting_knife",
	function ()
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "DelayedTooltipUpdate")
		ResourceHarvester.Initialize()
	end)

RegisterEventHandler(EventType.Timer, "DelayedTooltipUpdate", 
	function()
		UpdateToolTooltipString()
	end)

RegisterEventHandler(EventType.Message, "UpdateTooltip", 
	function()
		UpdateToolTooltipString()
	end)

ResourceHarvester.CollectResource = function(user,resourceType)
	local backpackObj = user:GetEquippedObject("Backpack")  
	if( backpackObj ~= nil ) then
		if( resourceType == nil ) then
			LuaDebugCallStack("ERROR: resourceType is nil.")
			return
		end
		if ( ResourceData.ResourceInfo[resourceType] == nil ) then
			DebugMessage("[tool_hunting_knife|ResourceHarvester.CollectResource] ERROR: resourceType '"..resourceType.."' does not exist in ResourceData.ResourceInfo.")
			return
		end

		--DebugMessage("RES TYPE:" .. resourceType)
		local resSkillList = ResourceData.ResourceInfo[resourceType]
		--
	--DebugTable(resSkillList)
		local resSkill = nil
		local skillVal = 0
		local curVal = 0
		local tSkill = nil
		for i,v in pairs(resSkillList) do
			tSkill = i
		--DebugMessage("TSkill:" .. tostring(i))
			if(HasSkill(user, i)) then
				curVal = GetSkillLevel(user,i)
				if(curVal >= skillVal) then
					resSkill = i
					skillVal = curVal
				end
			end
			if(resSkill == nil) then resSkill = tSkill end
		end
		local harvModVal = 1
		local depleteChance = 100
		if(resSkill ~= nil) and HasSkill(user,resSkill) then
			CheckSkill(user, resSkill)
			--user:SendMessage("RequestSkillGainCheck", resSkill) 
		end
	--DebugMessage(" Skill:" .. tostring(resSkill))
		
		-- dont factor skill bonus into stack amount
		local stackAmount = 1
		-- try to add to the stack in the players pack		
	    if not( TryAddToStack(resourceType,backpackObj,stackAmount) ) then
	    	-- no stack in players pack so create an object in the pack
	        local templateId = ResourceData.ResourceInfo[resourceType].Template
    		CreateObjInBackpackOrAtLocation(user,templateId, "create_huntingknife_harvest", stackAmount)
	    end

	    local displayName = GetResourceDisplayName(resourceType)
	    user:SystemMessage("You harvest some "..displayName..".","info")
	    user:NpcSpeech("[F4FA58]+1 "..displayName.."[-]","combat")
	end	

end

RegisterEventHandler(EventType.CreatedObject, "create_huntingknife_harvest", 
	function(success, objRef, amount)
		--DebugMessage("Created Object")
		if(success == true) then
			RequestSetStack(objRef,amount)
			local resName = objRef:GetObjVar("ResourceType")
			if(resName == nil) then return end
			if(amount < 2) then return end
		--local backpackObj = this:GetEquippedObject("Backpack")
			RequestSetStack(objRef,amount)
		end
	end)

