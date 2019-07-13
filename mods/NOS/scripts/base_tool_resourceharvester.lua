require 'incl_resource_source'

-- NOTE: any resource tool can set HarvestDelay objvar to override the default
ResourceHarvester = 
{
	ToolType = "Wood",
	HarvestAnimation = "attack",
	HarvestStopAnimation = "idle",	
	HarvestAnimationDurationSecs = 1.2,	
	DefaultHarvestDelaySecs = 6,
}

VALID_USE_RANGE = 6

lastWeapon = nil

mCurrentHarvestCount = 0

DEFAULT_QUALITY_IMPROVEMENT_SKILL_THRESHOLD = 20
DEFAULT_QUALITY_IMPROVEMENT_SKILL_THRESHOLD_MAX = 30
DEFAULT_QUALITY_IMPROVEMENT_MAX_UPGRADE_CHANCE = 30

function GetHarvestResourceType(user,baseResourceType,resSkill)
	local resInfo = ResourceData.ResourceInfo[baseResourceType]
	if(resInfo.AlternateHarvestResources == nil) then return baseResourceType end

	if resSkill and not(HasSkill(user,resSkill)) then return baseResourceType end

	local skillVal = 100
	if(resSkill) then 
		skillVal = GetSkillLevel(user,resSkill)
	end

	for i,alternateResInfo in pairs(resInfo.AlternateHarvestResources) do
		local maxUpgradeChance = alternateResInfo.MaxUpgradeChance or DEFAULT_QUALITY_IMPROVEMENT_MAX_UPGRADE_CHANCE
		local upgradeChance = maxUpgradeChance

		if(resSkill) then
			local skillThreshold = alternateResInfo.SkillThreshold or DEFAULT_QUALITY_IMPROVEMENT_SKILL_THRESHOLD
			local skillThresholdMax = alternateResInfo.SkillThresholdMax or DEFAULT_QUALITY_IMPROVEMENT_SKILL_THRESHOLD_MAX
			

			-- chance to upgrade starts at the threshold and caps out at the max	
			local startPotency = GetSkillPctPotency(skillThreshold)
			local endPotency = GetSkillPctPotency(skillThresholdMax)
			local potencyRange = endPotency - startPotency

			local curPotency = GetSkillPctPotency(skillVal)
			-- subtract the potency by the start and divide by the range to get your current percentage in the range
			-- clamp it to 0-1 so it stops at the max
			upgradeChance = math.clamp(((curPotency - startPotency) / potencyRange), 0, 1) * maxUpgradeChance
		end

		local upRoll = math.random(0,100)

		--DebugMessage("UpG Chance:" .. upgradeChance .. " Roll:" ..upRoll .. " Type:" .. alternateResInfo.ResourceType)
		if(upRoll < upgradeChance) then
			--DebugMessage("UPPED")
			return alternateResInfo.ResourceType
		end
	end

	return baseResourceType
end

function BeginHarvest(objRef,user,alreadyHarvesting)
	if (objRef == nil or not objRef:IsValid()) then return end
	-- skip checking perm objs (trees, rocks, etc)
	local useRange = VALID_USE_RANGE
	if(ResourceHarvester.UseRange ~= nil) then
		useRange = ResourceHarvester.UseRange
	end
	local objLocation = objRef:GetLoc()
	local myLocation = user:GetLoc()
	if( myLocation:Distance2(objLocation) > useRange ) then
		CallFunctionDelayed(TimeSpan.FromSeconds(2), function()
			-- reset the primary weapon ability cooldown much quicker since it was a range fail
			ResetWeaponAbilityCooldown(user, true)
		end)
		user:SystemMessage("You are too far away.","info")
		return
	end

	local tool = GetHarvestToolInBackpack(user,GetRequiredTool(objRef))
	if( GetRequiredTool(objRef) ~= ResourceHarvester.ToolType ) then
		--DebugMessage("ToolType: " .. ResourceHarvester.ToolType)
		user:SystemMessage(string.format("You can't use your %s for that.", ResourceHarvester.ToolType), "info")
		return
	end

	if ( not objRef:IsPermanent() ) then
		if ( objRef:HasObjVar("guardKilled") ) then
			user:SystemMessage("[$1726]","info")
			return
		end
		if ( CheckKarmaLoot(user, objRef) == false ) then return end
	end
	
	if ( IsMounted(user) ) then
		DismountMobile(user)
	end

	if (not alreadyHarvesting) then
		SetMobileMod(user,"Busy","BusyHarvesting",true)
		user:SetObjVar("HarvestingTool",this)
		user:SendMessage("EndCombatMessage")
		user:SetObjVar("IsHarvesting", true)
		user:SetFacing(myLocation:YAngleTo(objLocation))
		--DebugMessage("PLAYANIM")
		user:PlayAnimation(ResourceHarvester.HarvestAnimation)			
	end
	this:SendMessage("BreakInvisEffect", "Action")
	this:SendMessage("EndCombatMessage")

	local bonusHarvestDelay = this:GetObjVar("BonusHarvestDelay") or 0
	local harvestModifier = math.clamp(1 + bonusHarvestDelay, 0.5, 5.0)
	
	local baseHarvestDelaySecs = this:GetObjVar("HarvestDelaySecs") or ResourceHarvester.DefaultHarvestDelaySecs
	local harvestDelaySecs = baseHarvestDelaySecs * harvestModifier

	-- fire a timer when harvesting is complete
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(harvestDelaySecs),"CompleteHarvest",user,objRef)
end

function RequestResource(objRef,user,depletionAmount)
	-- send resource request
	-- first check to see if the source iteself handles the request
	if( not(objRef:IsPermanent()) and objRef:HasObjVar("HandlesHarvest") ) then
		objRef:SendMessage("RequestResource",this,user,depletionAmount)
	else
		local sourceId = GetResourceSourceId(objRef)
		if(sourceId == nil) then
			--LuaDebugCallStack("ERROR: CompleteHarvest called with invalid sourceId Object: "..tostring(objRef))
			return
		end

		-- otherwise send the request tothe resource controller if it has one
		local resourceController = FindObjectWithTag("MapResourceController")
		if( resourceController ~= nil ) then
			--DebugMessage("Getting here.")
			resourceController:SendMessage("RequestResource",this,user,objRef,depletionAmount)
		-- finally, fall back to getting the resource type directly off the source info
		else
			local sourceInfo = GetResourceSourceInfo(objRef)
			if( sourceInfo ~= nil ) then
				local resourceType = sourceInfo.ResourceType
				ResourceHarvester.CollectResource(user,resourceType)
			end
		end
	end
end

RegisterEventHandler(EventType.Message, "RequestResourceResponse", function(success,user,resourceType,objRef,countRemaining,failReason)
	-- if successfully got a resource from the object
	if ( success ) then
		-- make sure the user is still valid
		if( user == nil or not(user:IsValid()) ) then return end

		-- give the resource harvested
		ResourceHarvester.CollectResource(user,resourceType)

		-- if the item we are harvesting has more than 0 left
		if ( countRemaining > 0 ) then
			mCurrentHarvestCount = mCurrentHarvestCount + 1

			-- harvest again
			BeginHarvest(objRef,user,true)

			-- hack to keep animation playing through entire harvest.
			if ( mCurrentHarvestCount >= 4 ) then
				user:PlayAnimation(ResourceHarvester.HarvestAnimation)
				mCurrentHarvestCount = 0
			end
		else
			CancelHarvesting(user)
		end
	else
		if ( failReason == "Depleted" ) then
			user:SystemMessage("All resources depleted.", "info")
		end
		CancelHarvesting(user)
	end
end)

function ResourceHarvester.CompleteHarvest(objRef,user,depletionAmount)
	RequestResource(objRef,user,depletionAmount or 1)
end

function HandleInteract(objRef,user)
	if( objRef ~= nil ) then
		BeginHarvest(objRef,user)
	end
end

function CancelHarvesting(user)
	SetMobileMod(user,"Busy","BusyHarvesting")
	this:RemoveTimer("CompleteHarvest")
	ProgressBar.Cancel("Harvesting",user)
	user:PlayAnimation(ResourceHarvester.HarvestStopAnimation)
	user:DelObjVar("HarvestingTool")
	user:DelObjVar("IsHarvesting")
end

function ResourceHarvester.Initialize()
	-- the map controller looks at this objvar
	this:SetObjVar("ToolType",ResourceHarvester.ToolType)
end

function ResourceHarvester.CollectResource(user,resourceType)
	local backpackObj = user:GetEquippedObject("Backpack") 
	if( backpackObj ~= nil ) then

		-- try to add to the stack in the players pack		
	    if not( TryAddToStack(resourceType,backpackObj,1) ) then
	    	-- no stack in players pack so create an object in the pack
	        local templateId = ResourceData.ResourceInfo[resourceType].Template
	    	CreateObjInBackpackOrAtLocation(user,templateId)
	    end

	    local displayName = GetResourceDisplayName(resourceType)
	    --user:SystemMessage("You harvest some "..displayName..".")
	    user:NpcSpeech("[F4FA58]+1 "..displayName.."[-]","combat")
	end	
end

function ResourceHarvester.OnHarvestFailed(user,failReason)
	if (failReason == nil) then
		user:SystemMessage("You fail to harvest the resource.","info")
		return
	end
	if(failReason:match("MinSkill")) then
		local minSkill = failReason:sub(10)
		user:SystemMessage("[$1727]"..minSkill..")","info")
	else
		user:SystemMessage("[$1728]","info")
	end
end

-- DAB NOTE: This is now done as a weapon ability
--[[RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Harvest" and usedType ~= "Mine" and usedType ~= "Chop" and usedType ~= "Skin") then return end
		
		user:RequestClientTargetAnyObj(this, "harvestObj")
	end)

RegisterEventHandler(EventType.ClientTargetAnyObjResponse, "harvestObj",
	function (objRef,user)
		HandleInteract(objRef,user)
	end)

]]


RegisterEventHandler(EventType.Message, "HarvestObject",
	function (objRef, user)
		mCurrentHarvestCount = 0
		HandleInteract(objRef,user)
	end)

RegisterEventHandler(EventType.Timer,"CompleteHarvest",
	function(user,objRef)					
		if not (objRef:IsValid()) then
			user:SystemMessage("There is no resource to harvest.", "info")
			CancelHarvesting(user)
		else
			ResourceHarvester.CompleteHarvest(objRef,user)
		end

		if ( this ~= user ) then
			if ( Success(ServerSettings.Durability.Chance.OnToolUse) and IsPlayerCharacter(user) ) then
				AdjustDurability(this, -1)
			end
		end
		
	end)

RegisterEventHandler(EventType.Message,"CancelHarvesting",
	function (user)
		CancelHarvesting(user)
	end)
