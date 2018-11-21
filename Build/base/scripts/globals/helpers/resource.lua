




function ValidateUseResource(user, resourceObj)
	if ( user == nil or not user:IsValid() ) then
		LuaDebugCallStack("[resource_effects]", "Invalid/nil user provided.")
		return false
	end

	if ( user:HasObjVar("Disabled") ) then
		user:SystemMessage("Cannot use that right now.", "info")
		return false
	end

	if ( resourceObj:TopmostContainer() ~= user ) then
		user:SystemMessage("That must be in your backpack to use it.","info")
		return false
	end

	return true
end

function ValidateUseResourceTarget(target, user, resourceType)

	if not( ResourceEffectData[resourceType] ) then return false end

	if( target == nil or not target:IsValid() ) then
		return false
	end

	if ( ResourceEffectData[resourceType].Beneficial and not AllowFriendlyActions(user, target, true) ) then
		return false
	end
	
	-- target must be a mobile
	if ( ResourceEffectData[resourceType].RequireMobileTarget and not target:IsMobile() ) then
		user:SystemMessage("Invalid target.", "info")
		return false
	end

	return true
end

--- Has same module context call restrictions, See StartMobileEffect()
function UseResource(user, target, resourceObj, resourceType, useType)

    resourceType = resourceType or resourceObj:GetObjVar("ResourceType")

	if ( not resourceType or not ResourceEffectData[resourceType] or ResourceEffectData[resourceType].NoUse == true ) then
		user:SystemMessage("Cannot think of a way to use that.", "info")
		return true
	end

	-- since we are checking in a non-async way for the success, StartMobileEffect must always be called on the user 
		-- since it will be called within a LuaVM context that exists on user.
	if (
		-- if useType is provided and we have a specific handle for the useType
		(
			useType ~= nil
			and
			ResourceEffectData[resourceType].MobileEffectUseCases ~= nil
			and
			ResourceEffectData[resourceType].MobileEffectUseCases[useType] ~= nil
			and
			StartMobileEffect(user, ResourceEffectData[resourceType].MobileEffectUseCases[useType].MobileEffect, target, ResourceEffectData[resourceType].MobileEffectUseCases[useType].MobileEffectArgs or {})
		)
		-- fall back on using the default mobile effect if no specific handle for the useType is found
		or
		(
			( 	
				ResourceEffectData[resourceType].MobileEffectUseCases == nil
				or
				ResourceEffectData[resourceType].MobileEffectUseCases[useType] == nil
			)
			and
			ResourceEffectData[resourceType].MobileEffect ~= nil
			and
			StartMobileEffect(user, ResourceEffectData[resourceType].MobileEffect, target, ResourceEffectData[resourceType].MobileEffectArgs or {})
		)
	) then
		if ( FoodStats.BaseFoodStats[resourceType] == nil and not ResourceEffectData[resourceType].NoConsume == true ) then
			if not ( ConsumeResourceBackpack(user, resourceType, 1) ) then
				return false
			end
		end
	else
		-- effect failed for whatever reason, queue up the targeting again.
		if ( ResourceEffectData[resourceType].SelfOnly ~= true ) then
			QueueUseResourceTarget(user, resourceObj, resourceType)
		end
		return false
	end

	if ( ResourceEffectData[resourceType].Beneficial ) then
		CheckKarmaBeneficialAction(user, target)
	end

	user:PlayObjectSound("Use", true)
	return true
end

--- Has same module context call restrictions, See StartMobileEffect()
function TryUseResource(user, resourceObj, useType)
	local resourceType = resourceObj:GetObjVar("ResourceType")
    if ( resourceType == nil or user:HasTimer("AntispamResourceUse") or not ValidateUseResource(user, resourceObj) ) then return false end
	user:ScheduleTimerDelay(TimeSpan.FromSeconds(0.5), "AntispamResourceUse")

	-- used the item, break invis
	user:SendMessage("BreakInvisEffect", "UseResource")

	-- attempt to eat if this is food
	if ( resourceType == nil or ( FoodStats.BaseFoodStats[resourceType] ~= nil and not TryEatFood(user, resourceType, resourceObj) ) ) then
		return false
	end

	local resourceEffect = ResourceEffectData[resourceType]
	-- no resource effect, no reason to continue.
	if ( not resourceEffect ) then
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
		else
			if ( ValidateUseResourceTarget(user, user, resourceType) ) then
				return UseResource(user, user, resourceObj, resourceType, useType)
			end
		end
	end
	
	QueueUseResourceTarget(user, resourceObj, resourceType, useType)

	return true
end

function QueueUseResourceTarget(user, resourceObj, resourceType, useType)

    local eventId = "UseResourceTarget" .. uuid()
    RegisterSingleEventHandler(EventType.ClientTargetGameObjResponse, eventId, function(target, user)
        if ( ValidateUseResource(user, resourceObj) and ValidateUseResourceTarget(target, user, resourceType) ) then
            UseResource(user, target, resourceObj, resourceType, useType)
        end
    end)
    -- ask for a target.
	user:RequestClientTargetGameObj(user, eventId)

end

function GetResourceTooltipTable(resourceType, tooltipInfo)
	tooltipInfo = tooltipInfo or {}

    if ( resourceType and ResourceEffectData[resourceType] ) then

		if ( ResourceEffectData[resourceType].Tooltip ) then
			for i,entry in pairs(ResourceEffectData[resourceType].Tooltip) do
				tooltipInfo["Tip"..i] = {
					TooltipString = entry,
					Priority = 0,
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
		AddUseCase(resourceObj, case, (i == 1), "HasObject")
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