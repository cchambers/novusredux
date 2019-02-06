require 'base_tool_resourceharvester'

QUALITY_IMPROVEMENT_SKILL_THRESHOLD = 40
FAIL_CHANCE_SKILL_THRESHOLD = 30
BASE_UPGRADE_CHANCE = 10

ResourceHarvester.ToolType = "BareHands"
ResourceHarvester.HarvestAnimation = "forage"
ResourceHarvester.HarvestStopAnimation = "kneel_standup"
-- 0 means the animation does not loop
ResourceHarvester.HarvestAnimationDurationSecs = 0
ResourceHarvester.DefaultHarvestDelaySecs = 2

RegisterSingleEventHandler(EventType.ModuleAttached,"tool_barehands",
	function ()
		ResourceHarvester.Initialize()
	end)

mUser = nil

ResourceHarvester.CollectResource = function(user,resourceType)
	local backpackObj = user:GetEquippedObject("Backpack")  
	if( backpackObj ~= nil ) then		
	
		local HarvestingSkill = GetSkillLevel(user, "HarvestingSkill")
		local maxAmount = math.floor((HarvestingSkill / 33) + 1)
		local stackAmount = math.random(1, maxAmount)
		local spawnerObj = this:GetObjVar("Spawner")
		
		if(spawnerObj) then
			spawnerObj:SendMessage("MobHasDied",this)
		end		
		
		-- see if the user gets an upgraded version
		resourceType = GetHarvestResourceType(user,resourceType)
		if (resourceType == nil) then return end
			--DebugMessage("ResType:" .. resourceType)
    		--DebugTable(ResourceData.ResourceInfo[resourceType])
			-- try to add to the stack in the players pack
    	if( not( TryAddToStack(resourceType,backpackObj,stackAmount)) and ResourceData.ResourceInfo[resourceType] ~= nil ) then
    		-- no stack in players pack so create an object in the pack
        	local templateId = ResourceData.ResourceInfo[resourceType].Template
    		CreateObjInBackpackOrAtLocation(user, templateId, "create_foraging_harvest", stackAmount)
    	end

	    local displayName = GetResourceDisplayName(resourceType)
	    user:SystemMessage("You harvest some "..displayName..".","info")
		mUser = user
	    user:NpcSpeech("[F4FA58]+"..stackAmount.." "..displayName.."[-]","combat")
	end	
end

base_CompleteHarvest = ResourceHarvester.CompleteHarvest
ResourceHarvester.CompleteHarvest = function(objRef,user)
	-- make sure the user is still valid
	if( user == nil or not(user:IsValid()) ) then return end

	local HarvestingSkill = GetSkillLevel(user, "HarvestingSkill")
	local skipGains = false;
	local HarvestGateMin = objRef:GetObjVar("HarvestGateMin") or 0
	local HarvestGateMax = objRef:GetObjVar("HarvestGateMax") or 100
	if ((HarvestingSkill < HarvestGateMin) or (HarvestingSkill > HarvestGateMax)) then skipGains = true end

	CheckSkillChance(user, "HarvestingSkill", HarvestingSkill, 0.4, skipGains)

	local resInfoTab = GetResourceSourceInfo(objRef)

	if(resInfoTab == nil) then
		local sourceId = GetResourceSourceId(objRef)
		local name = ((objRef ~= nil and objRef:IsValid() and not(objRef:IsPermanent())) and objRef:GetName()) or ""
		local IsPermanent = (objRef ~= nil and objRef:IsValid() and (objRef:IsPermanent()))
		LuaDebugCallStack("ERROR: CompleteHarvest called with no source info Object: "..tostring(objRef).." SourceId: "..tostring(sourceId).. " Name: "..name.." IsPermanent: "..tostring(IsPermanent))
		user:DelObjVar("IsHarvesting")
		return
	end

	base_CompleteHarvest(objRef,user,1)
end

RegisterEventHandler(EventType.CreatedObject, "create_foraging_harvest", 
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