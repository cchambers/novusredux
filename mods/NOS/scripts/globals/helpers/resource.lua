




function ValidateUseResource(user, resourceObj, resourceEffect)
	if ( user == nil or not user:IsValid() ) then
		LuaDebugCallStack("[resource_effects] Invalid/nil user provided.")
		return false
	end

	if ( user:HasObjVar("Disabled") ) then
		user:SystemMessage("Cannot use that right now.", "info")
		return false
	end

	if ( resourceEffect.Range and resourceObj:TopmostContainer() == nil ) then
		if ( user:DistanceFrom(resourceObj) > resourceEffect.Range ) then
			user:SystemMessage("Too far away.", "info")
			return false
		end
	else
		if not( IsInBackpack(resourceObj, user) ) then
			user:SystemMessage("That must be in your backpack to use.","info")
			return false
		end
	end

	return true
end

function ValidateUseResourceTarget(target, user, resourceType)

	local resourceEffect = ResourceEffectData[resourceType]
	if not( resourceEffect ) then return false end

	if( target == nil or not target:IsValid() ) then
		return false
	end

	if ( resourceEffect.Beneficial and not AllowFriendlyActions(user, target, true) ) then
		return false
	end
	
	-- target must be a mobile
	if ( resourceEffect.RequireMobileTarget and not target:IsMobile() ) then
		user:SystemMessage("Invalid Target.", "info")
		return false
	end

	return true
end

--- Has same module context call restrictions, See StartMobileEffect()
function UseResource(user, target, resourceObj, resourceType, useType)

    resourceType = resourceType or resourceObj:GetObjVar("ResourceType")

	local resourceEffect = ResourceEffectData[resourceType]
	if ( not resourceType or not resourceEffect or resourceEffect.NoUse == true ) then
		user:SystemMessage("Cannot Think Of A Way To Use That.", "info")
		return true
	end

	-- since we are checking in a non-async way for the success, StartMobileEffect must always be called on the user 
		-- since it will be called within a LuaVM context that exists on user.
	if (
		-- if useType is provided and we have a specific handle for the useType
		(
			useType ~= nil
			and
			resourceEffect.MobileEffectUseCases ~= nil
			and
			resourceEffect.MobileEffectUseCases[useType] ~= nil
			and
			StartMobileEffect(user, resourceEffect.MobileEffectUseCases[useType].MobileEffect, 
				-- via ternary pass the resourceObj as the target, or send the provided target.
				resourceEffect.MobileEffectObjectAsTarget and resourceObj or target,
				-- via ternary pass the resourceObj as the args, or send the provided args.
				resourceEffect.MobileEffectUseCases[useType].MobileEffectObjectAsArgs and resourceObj or resourceEffect.MobileEffectUseCases[useType].MobileEffectArgs
			)
		)
		-- fall back on using the default mobile effect if no specific handle for the useType is found
		or
		(
			( 	
				resourceEffect.MobileEffectUseCases == nil
				or
				resourceEffect.MobileEffectUseCases[useType] == nil
			)
			and
			resourceEffect.MobileEffect ~= nil
			and
			StartMobileEffect(user, resourceEffect.MobileEffect, 
				-- via ternary pass the resourceObj as the target, or send the provided target.
				resourceEffect.MobileEffectObjectAsTarget and resourceObj or target,
				-- via ternary pass the resourceObj as the args, or send the provided args.
				resourceEffect.MobileEffectObjectAsArgs and resourceObj or resourceEffect.MobileEffectArgs
			)
		)
	) then
		if ( FoodStats.BaseFoodStats[resourceType] == nil and not resourceEffect.NoConsume == true ) then
			if not ( ConsumeResourceBackpack(user, resourceType, 1) ) then
				return false
			end
		end
	else
		-- effect failed for whatever reason, queue up the targeting again.
		if ( resourceEffect.SelfOnly ~= true ) then
			QueueUseResourceTarget(user, resourceObj, resourceType)
		end
		return false
	end

	if ( resourceEffect.Beneficial ) then
		CheckKarmaBeneficialAction(user, target)
	end

	user:PlayObjectSound("Use", true)

	return true
end

--- Has same module context call restrictions, See StartMobileEffect()
function TryUseResource(user, resourceObj, useType)
	local resourceType = resourceObj:GetObjVar("ResourceType")
    if ( resourceType == nil or user:HasTimer("AntispamResourceUse") ) then return false end
	user:ScheduleTimerDelay(TimeSpan.FromSeconds(0.5), "AntispamResourceUse")

	-- used the item, break invis
	user:SendMessage("BreakInvisEffect", "Action")

	-- attempt to eat if this is food
	if ( resourceType == nil or ( FoodStats.BaseFoodStats[resourceType] ~= nil and not TryEatFood(user, resourceType, resourceObj) ) ) then
		return false
	end

	local resourceEffect = ResourceEffectData[resourceType]
	-- no resource effect, no reason to continue.
	if ( not resourceEffect or not ValidateUseResource(user, resourceObj, resourceEffect) ) then
		return false
	end

	-- some stuff still has modules on it and receives messages.
	--- this is mostly a way to handle legacy items (specifically implemented for scrolls)
	if ( resourceEffect.SendUseObject ) then
		resourceObj:SendMessage("UseObject", user, GetResourceUseCases(resourceType)[1])
		return true
	end

	if ( resourceEffect.NoMount ) then
		local mountObj = GetMount(user)
		if ( mountObj ) then
			DismountMobile(user, mountObj)
		end
	end

	if ( resourceEffect.RequireSkill ) then
		local skillDictionary = GetSkillDictionary(user)
		for skill,level in pairs(resourceEffect.RequireSkill) do
			if ( GetSkillLevel(user, skill, skillDictionary) < level ) then
				user:SystemMessage("Requires "..level.." "..(SkillData.AllSkills[skill].DisplayName or skill)..".", "info")
				return false
			end
		end
	end

	if ( resourceEffect.SelfOnly == true ) then
		return UseResource(user, resourceObj, resourceObj, resourceType, useType)
	end

	if ( resourceEffect.NoAutoTarget ~= true and user:HasObjVar("AutotargetEnabled") ) then
		local target = user:GetObjVar("CurrentTarget")
		if ( target and ValidateUseResourceTarget(target, user, resourceType) ) then
			return UseResource(user, target, resourceObj, resourceType, useType)
		end
	end
	
	QueueUseResourceTarget(user, resourceObj, resourceType, useType)

	return true
end

function QueueUseResourceTarget(user, resourceObj, resourceType, useType)
    if ( ResourceEffectData[resourceType].TargetMessage ) then
        user:SystemMessage(ResourceEffectData[resourceType].TargetMessage, ResourceEffectData[resourceType].TargetMessageType or "info")
    end

    RegisterSingleEventHandler(EventType.ClientTargetGameObjResponse, "UseResourceTarget", function(target, user)
        if ( ValidateUseResource(user, resourceObj, ResourceEffectData[resourceType]) and ValidateUseResourceTarget(target, user, resourceType) ) then
            UseResource(user, target, resourceObj, resourceType, useType)
        end
    end)
    -- ask for a target.
	user:RequestClientTargetGameObj(user, "UseResourceTarget")

end

function GetResourceTooltipTable(resourceType, tooltipInfo, item)
	tooltipInfo = tooltipInfo or {}

    if ( resourceType and ResourceEffectData[resourceType] ) then

		if ( ResourceEffectData[resourceType].Tooltip ) then
			for i=1,#ResourceEffectData[resourceType].Tooltip do
				tooltipInfo["Tip"..i] = {
					TooltipString = ResourceEffectData[resourceType].Tooltip[i],
					Priority = -i,
				}
			end
		end

		if ( ResourceEffectData[resourceType].RequireSkill ) then
			for skill,level in pairs(ResourceEffectData[resourceType].RequireSkill) do
				if ( IsValidSkill(skill) ) then
					tooltipInfo["SkillReq"..skill] = {
						TooltipString = "Requires "..level.." "..(SkillData.AllSkills[skill].DisplayName or skill),
						Priority = -1,
					}
				end
			end
		end

		if ( ResourceEffectData[resourceType].TooltipFunc ) then
			tooltipInfo = ResourceEffectData[resourceType].TooltipFunc(tooltipInfo, item)
		end

    end

	return tooltipInfo
end

function CallResourceInitFunc(item, resourceType)	
	if(ResourceEffectData[resourceType] and ResourceEffectData[resourceType].InitFunc) then
		ResourceEffectData[resourceType].InitFunc(item)
	end
end

function ApplyResourceUsecases(resourceObj, resourceType)
	for i,case in pairs(GetResourceUseCases(resourceType)) do
		local condition = nil
		if ( ResourceEffectData[resourceType] and ResourceEffectData[resourceType].UseCaseConditions and ResourceEffectData[resourceType].UseCaseConditions[i] ) then
			condition = ResourceEffectData[resourceType].UseCaseConditions[i]
		end
		
		AddUseCase(resourceObj, case, (i == 1), condition or "HasObject")
	end
end

function GetResourceUseCases(resourceType)
	if not( resourceType ) then return {} end

	if ( FoodStats.BaseFoodStats[resourceType] ~= nil ) then
		if ( FoodStats.BaseFoodStats[resourceType].UseCases ) then
			return FoodStats.BaseFoodStats[resourceType].UseCases
		else
			return { "Eat" }
		end
	else
		if ( ResourceEffectData[resourceType] ~= nil ) then
			if ( ResourceEffectData[resourceType].UseCases ) then
				return ResourceEffectData[resourceType].UseCases
			else
				return { "Use" }
			end
		end
	end

	return {}
end

function ValidResourceUseCase(resourceObj, useCase)	
	local resourceType = resourceObj:GetObjVar("ResourceType")
	if ( resourceType ) then
		if ( ResourceEffectData[resourceType] and ResourceEffectData[resourceType].OldSchoolUseCases ) then
			for i,case in pairs(ResourceEffectData[resourceType].OldSchoolUseCases) do
				if ( case == useCase ) then return false end
			end
		end
		local useCases = {
			"Use",
			"Eat"
		}
		if ( ResourceEffectData[resourceType] and ResourceEffectData[resourceType].UseCases ) then
			useCases = ResourceEffectData[resourceType].UseCases
		end
		if ( FoodStats.BaseFoodStats[resourceType] and FoodStats.BaseFoodStats[resourceType].UseCases ) then
			useCases = FoodStats.BaseFoodStats[resourceType].UseCases
		end
		for i,case in pairs(useCases) do
			if ( case == useCase ) then return true end
		end
	end
	return false
end