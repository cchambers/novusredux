function GetLevelText(abilityLevel)
	if(abilityLevel==1) then return "I" end
	if(abilityLevel==2) then return "II" end
	if(abilityLevel==3) then return "III" end
	return ""
end

function GetPrestigeAbilityDisplayName(prestigeClass,prestigeAbility)
	local paData = GetPrestigeAbility(prestigeClass,prestigeAbility)
	--LuaDebugCallStack(tostring(prestigeClass)..tostring(prestigeAbility))
	return paData.Action.DisplayName or prestigeAbility
end

function GetSlottedPrestigeAbility(playerObj,position)
	local objVarKey = "PrestigeAbility"..position
	-- make sure they have this prestige ability
	local slottedAbility = playerObj:GetObjVar(objVarKey)
	if ( slottedAbility ) then		
		local abilityLevel = GetPrestigeAbilityLevel(playerObj,slottedAbility.Class, slottedAbility.AbilityName)
		return slottedAbility.Class, slottedAbility.AbilityName, math.abs(abilityLevel)
	end
end

function BeginCastPrestigeAbility(playerObj, mobileObj, prestigeAbilityClass, prestigeAbilityName, prestigeAbility, castTime)
	if not( playerObj:HasTimer("CastPrestigeAbility") ) then
		if ( prestigeAbility.PreCast ~= nil ) then
			prestigeAbility.PreCast(playerObj, mobileObj)
		end
		if ( mobileObj ) then
			playerObj:StopMoving()
			LookAt(playerObj, mobileObj)
		end

		SetMobileMod(playerObj, "Disable", "PrestigeCast", true)
		ProgressBar.Show(
		{
			TargetUser = playerObj,
			Label = prestigeAbility.Action.DisplayName,
			Duration = castTime,
			DialogId = "CastPrestigeAbility",
			PresetLocation="AboveHotbar",
			CanCancel = true,
			CancelFunc = function()
				CancelCastPrestigeAbility(playerObj)
			end
		})
		playerObj:ScheduleTimerDelay(castTime, "CastPrestigeAbility", playerObj, mobileObj, prestigeAbilityClass, prestigeAbilityName)
	end
end

function CompleteCastPrestigeAbility(playerObj, mobileObj, prestigeAbilityClass, prestigeAbilityName)
	SetMobileMod(playerObj, "Disable", "PrestigeCast", nil)
	if ( mobileObj ) then
		LookAt(playerObj, mobileObj)
	end

	PerformPrestigeAbilityByName(playerObj, mobileObj, prestigeAbilityClass, prestigeAbilityName, true)

	if ( PrestigeData[prestigeAbilityClass].Abilities[prestigeAbilityName].PostCast ) then
		PrestigeData[prestigeAbilityClass].Abilities[prestigeAbilityName].PostCast(playerObj, mobileObj)
	end
end

function CancelCastPrestigeAbility(playerObj)
	if ( playerObj:HasTimer("CastPrestigeAbility") ) then
		playerObj:RemoveTimer("CastPrestigeAbility")
		if( playerObj:HasTimer("CastPrestigeAbilityClose") ) then
			playerObj:FireTimer("CastPrestigeAbilityClose") -- close progress bar
		end
		SetMobileMod(playerObj, "Disable", "PrestigeCast", nil)
		return true
	end
	return false
end

--- Convenience function to help when debugging an NPC performing CombatAbilities.
-- @param message(string) The error message
-- @param playerObj(mobileObj) The mobile that was performing the ability that caused the error
-- @param isPlayer(boolean) true is playerObj is a player, false otherwise.
-- @return false
function PrestigeAbilityError(message, playerObj, isPlayer)
	if ( isPlayer ) then
		playerObj:SystemMessage(message, "info")
	end
	--DebugMessage(playerObj, message)
	return false
end

function PerformPrestigeAbilityByName(playerObj, mobileObj, prestigeAbilityClass, prestigeAbilityName, castComplete)
	local isPlayer = IsPlayerCharacter(playerObj)
    local abilityLevel = GetPrestigeAbilityLevel(playerObj,prestigeAbilityClass, prestigeAbilityName, not isPlayer)
		
	if(abilityLevel > 0) then
		local prestigeAbility = GetPrestigeAbility(prestigeAbilityClass, prestigeAbilityName, abilityLevel)

		if(HasPrestigeSkillRequirements(playerObj, prestigeAbility, abilityLevel) == false) then
			return PrestigeAbilityError("You lack the skill levels to use this ability.", playerObj, isPlayer)
		end
		-- we have the prestige ability that's set to this position
		if ( prestigeAbility ~= nil and prestigeAbility.Levels[abilityLevel] ~= nil ) then
			local abilityLevelData = prestigeAbility.Levels[abilityLevel]

			if ( prestigeAbility.NoMount == true ) then
				local mountObj = GetMount(playerObj)
				if ( mountObj ) then
					DismountMobile(playerObj, mountObj)
				end
			end

			-- when an ability requires a ranged weapon
			if ( prestigeAbility.RequireRanged or prestigeAbility.PreventRanged ) then
				local rightHand = playerObj:GetEquippedObject("RightHand")
				if ( prestigeAbility.RequireRanged ) then
					if ( rightHand == nil or not IsRangedWeapon(rightHand) ) then
						return PrestigeAbilityError("Ranged weapon required.", playerObj, isPlayer)
					end
				else
					if ( rightHand ~= nil and IsRangedWeapon(rightHand) ) then
						return PrestigeAbilityError("Cannot use ranged weapon.", playerObj, isPlayer)
					end
				end
			end
			-- when an ability requires a shield
			if ( prestigeAbility.RequireShield ) then
				local leftHand = playerObj:GetEquippedObject("LeftHand")
				if ( leftHand == nil or not leftHand:HasObjVar("ShieldType") ) then
					return PrestigeAbilityError("Shield required.", playerObj, isPlayer)
				end
			end
			-- when an ability requires heavy armor
			if ( prestigeAbility.RequireHeavyArmor and not IsWearingHeavyArmor(playerObj) ) then
				return PrestigeAbilityError("Heavy armor required.", playerObj, isPlayer)
			end
			
			-- when an ability requires a specific weapon type
			if ( prestigeAbility.RequireWeaponClass and GetWeaponClass(playerObj:GetEquippedObject("RightHand")) ~= prestigeAbility.RequireWeaponClass ) then
				return PrestigeAbilityError(prestigeAbility.RequireWeaponClass.." required.", playerObj, isPlayer)
			end			
			
			-- when an ability requires a target, validate we have a target.
			if ( prestigeAbility.RequireTarget or prestigeAbility.RequireCombatTarget ) then
				if ( mobileObj == nil ) then
					return PrestigeAbilityError("Target is required.", playerObj, isPlayer)
				end

				-- required combat target, validate the target is valid combat target.
				if ( prestigeAbility.RequireCombatTarget and not ValidCombatTarget(playerObj, mobileObj) ) then
					return PrestigeAbilityError("Invalid target.", playerObj, isPlayer)
				end
				-- prevent trying to apply a non stacking effect multiple times
				if ( abilityLevelData.TargetMobileEffect ~= nil and not MobileEffectLibrary[abilityLevelData.TargetMobileEffect].ShouldStack and HasMobileEffect(mobileObj, abilityLevelData.TargetMobileEffect) ) then
					return PrestigeAbilityError("Target already affected.", playerObj, isPlayer)
				end
				-- require behind target
				if ( prestigeAbility.RequireBehindTarget and not IsBehind(playerObj, mobileObj) ) then
					return PrestigeAbilityError("Must be behind target.", playerObj, isPlayer)
				end
				-- default all RequireTarget prestige abilities to require a valid range of the weapon
				-- but if Range is set, use that to calculate instead.
				if ( (abilityLevelData.Range ~= nil and not WithinCombatRange(playerObj, mobileObj, abilityLevelData.Range)) 
					or (abilityLevelData.Range == nil and not WithinWeaponRange(playerObj, mobileObj)) ) then
					return PrestigeAbilityError("Too far away.", playerObj, isPlayer)
				end

				if (not playerObj:HasLineOfSightToObj(mobileObj,ServerSettings.Combat.LOSEyeLevel)) then
					return PrestigeAbilityError("Cannot see target.", playerObj, isPlayer)
				end
			end

			if not( prestigeAbility.NoCombat == true ) then
				-- force combat mode cause they used a prestige ability.
				playerObj:SendMessage("ForceCombat")
			end
			-- break cloak too
			if not( prestigeAbility.AllowCloaked == true ) then
				playerObj:SendMessage("BreakInvisEffect", "Prestige")
			end

			-- when an ability has a cast timer, and the cast is not complete
			if ( prestigeAbility.Levels[abilityLevel].CastTime ~= nil and castComplete ~= true ) then
				playerObj:SendMessage("ClearSwingTimers")
				BeginCastPrestigeAbility(playerObj, mobileObj, prestigeAbilityClass, prestigeAbilityName, prestigeAbility, prestigeAbility.Levels[abilityLevel].CastTime)
				return false
			end
			
			-- reset swing timers when using most abilities.
			if ( prestigeAbility.NoResetSwing ~= true or castComplete == true ) then
				playerObj:SendMessage("ResetSwingTimer", 0, "All")
			end

			-- clear any queued weapon abilities
			playerObj:SendMessage("ClearQueuedWeaponAbility")
			-- set a quick timer to prevent a queued weapon ability from sneaking in and applying to this ability as well
			playerObj:ScheduleTimerDelay(TimeSpan.FromSeconds(0.1), "RecentAbilityUsed")

			-- if the ability has a mobile effect for the mobile doing the ability
			if ( abilityLevelData.MobileEffect ~= nil ) then
				-- apply the effect to that mobile
				StartMobileEffect(playerObj, abilityLevelData.MobileEffect, mobileObj, (abilityLevelData.MobileEffectArgs or {}) )
			end
			-- if the ability has a mobile effect for a target
			if ( mobileObj ~= nil and abilityLevelData.TargetMobileEffect ~= nil ) then
				-- apply the effect to the target.
				mobileObj:SendMessage("StartMobileEffect", abilityLevelData.TargetMobileEffect, playerObj, (abilityLevelData.TargetMobileEffectArgs or {}))
			end

			if ( isPlayer ) then
				StartPrestigePositionCooldown(playerObj, prestigeAbilityClass, prestigeAbilityName, abilityLevelData.Cooldown)
			end

			return true
		end
	else
		PrestigeAbilityError("Unabled to perform ability.", playerObj, isPlayer)
	end
end

--- Perform a trained prestige ability
-- @param playerObj player that is performing the ability
-- @param mobileObj(optional) target of the ability
-- @param prestigeClass class of ability to perform
-- @param prestigeAbility name of ability to perform
-- @return true if the ability was performed successfully. (no guarantee the mobile effects worked proper)
function PerformPrestigeAbility(playerObj, mobileObj, prestigeClass, prestigeAbility)
	if( IsDead(playerObj) ) then return false end

	local isPlayer = IsPlayerCharacter(playerObj)
	if ( IsMobileDisabled(playerObj) ) then
		return PrestigeAbilityError("Cannot use that right now.", playerObj, isPlayer)
	end

	position = ValidatePrestigeAbilityPosition(position)
	if ( playerObj:HasTimer("pa_"..prestigeClass.."_"..prestigeAbility) ) then
		return PrestigeAbilityError("On Cooldown.", playerObj, isPlayer)
	end

	-- no training on skill abilities right now just perform
	if(prestigeClass == "Skills") then
		return PerformPrestigeAbilityByName(playerObj,mobileObj,prestigeClass,prestigeAbility,false)
	end
	
	for i=1,3 do
		local objVarKey = "PrestigeAbility"..i
	    -- make sure they have this prestige ability
	    local slottedAbility = playerObj:GetObjVar(objVarKey)
	    if ( slottedAbility and slottedAbility.Class == prestigeClass and slottedAbility.AbilityName == prestigeAbility ) then	    	
		    return PerformPrestigeAbilityByName(playerObj,mobileObj,prestigeClass,prestigeAbility,false)
	    end
	end
	playerObj:SystemMessage("Ability not trained.","info")
	return false
end

--- Initiate the cooldown for a prestige ability by position
-- @param playerObj
-- @param position
-- @param cooldown TimeSpan
function StartPrestigePositionCooldown(playerObj, prestigeClass, prestigeAbility, cooldown)
	if ( playerObj == nil ) then
		return LuaDebugCallStack("nil playerObj provided.")
	end
	cooldown = cooldown or TimeSpan.FromMinutes(4)
	local prestige_ability_id = string.format("pa_%s_%s", prestigeClass, prestigeAbility)
	playerObj:ScheduleTimerDelay(cooldown, prestige_ability_id)
	playerObj:SendClientMessage("ActivateCooldown", {
		"CombatAbility",
		prestige_ability_id,
		cooldown.TotalSeconds
	})
end

--- Reset the cooldown for a prestige ability by assigned position
-- @param playerObj
-- @param position
function ResetPrestigeCooldown(playerObj, prestigeClass, prestigeAbility)
	local prestige_ability_id = string.format("pa_%s_%s", prestigeClass, prestigeAbility)
	if ( playerObj:HasTimer(prestige_ability_id) ) then

		-- a timer exists, so the client should prevent the button, let's fix that
		playerObj:SendClientMessage("ActivateCooldown", {
			"CombatAbility",
			prestige_ability_id,
			0
		})
		-- then clear the timer
		playerObj:RemoveTimer(prestige_ability_id)
	end
end

--- Determine if a given prestige class string is valid
-- @param prestigeClass string, cases sensative, FieldMage for example.
-- @return true if valid prestige class
function ValidPrestigeClass(prestigeClass)
	return PrestigeData[prestigeClass] ~= nil
end

function HasPrestigeSkillRequirements(playerObj, prestigeAbility, abilityLevel)
	if not(prestigeAbility.Levels[abilityLevel].Prerequisites) then
		return true
	end

	for skillName,skillLevel in pairs(prestigeAbility.Levels[abilityLevel].Prerequisites) do
		if(type(skillLevel) == "table") then
			local skillOptions = skillLevel
			local hasSkillReq = false
			for skillName,skillLevel in pairs(skillOptions) do
				if(GetSkillLevel(playerObj,skillName) >= skillLevel) then
					hasSkillReq = true
				end
			end

			if not(hasSkillReq) then
				return false
			end
		else
			if(GetSkillLevel(playerObj,skillName) < skillLevel) then
				return false
			end
		end
	end
end

function HasPrestigePrerequisites(playerObj,prestigeClass,prestigeAbility,abilityLevel)
	local prestigeAbility = GetPrestigeAbility(prestigeClass,prestigeAbility)
	if(prestigeAbility and prestigeAbility.Levels[abilityLevel] and prestigeAbility.Levels[abilityLevel].Prerequisites) then
		for skillName,skillLevel in pairs(prestigeAbility.Levels[abilityLevel].Prerequisites) do
			-- subtable means one of the listed skills are required
			if(type(skillLevel) == "table") then
				local skillOptions = skillLevel
				local hasSkillReq = false
				for skillName,skillLevel in pairs(skillOptions) do
					if(GetSkillLevel(playerObj,skillName) >= skillLevel) then
						hasSkillReq = true
					end
				end

				if not(hasSkillReq) then
					return false
				end
			else
				if(GetSkillLevel(playerObj,skillName) < skillLevel) then
					return false
				end
			end
		end
	end

	return true
end

function BuildPrestigePrerequisitesString(prestigeClass,prestigeAbility,abilityLevel,sep)
	local sep = sep or "\n"	
	local out = ""

	local prestigeAbility = GetPrestigeAbility(prestigeClass,prestigeAbility)
	if(prestigeAbility and prestigeAbility.Levels[abilityLevel] and prestigeAbility.Levels[abilityLevel].Prerequisites) then
		for skillName,skillLevel in pairs(prestigeAbility.Levels[abilityLevel].Prerequisites) do
			if(type(skillLevel) == "table") then
				local skillOptions = skillLevel
				for skillName,skillLevel in pairs(skillOptions) do
					out = out .. skillLevel.." "..GetSkillDisplayName(skillName).." or "
				end
				out = string.sub(out,1,-4) .. "\n"
			else
				out = out .. skillLevel.." "..GetSkillDisplayName(skillName) .. sep
			end
		end
	end
	return out
end

--- Get the prestige class data by prestige class name.
-- @param prestigeClass string, name of class
-- @return lua data table for class or nil if invalid class.
function GetPrestigeClass(prestigeClass)
	return PrestigeData[prestigeClass]
end

function GetPrestigeDisplayName(prestigeClass)
	if(PrestigeData[prestigeClass]) then
		return PrestigeData[prestigeClass].DisplayName or prestigeClass
	end
end

function GetPrestigeAbilityClass(prestigeAbility)
	for className,classData in pairs(PrestigeData) do
		if(classData.Abilities and classData.Abilities[prestigeAbility]) then
			return className
		end
	end
end

function GetPrestigeAbility(prestigeClass, prestigeAbility)
	if( not(prestigeClass) ) then
		prestigeClass = GetPrestigeAbilityClass(prestigeAbility)
	end

	if ( prestigeAbility and prestigeClass and PrestigeData[prestigeClass] and PrestigeData[prestigeClass].Abilities ) then
		return PrestigeData[prestigeClass].Abilities[prestigeAbility]
	end
	return nil
end

function UnlockPrestigeAbility(playerObj, prestigeClass, prestigeAbility, abilityLevel)
	local unlockedAbilityLevels = playerObj:GetObjVar("PrestigeAbilityLevels") or {}
	unlockedAbilityLevels[prestigeClass] = unlockedAbilityLevels[prestigeClass] or {}
	unlockedAbilityLevels[prestigeClass][prestigeAbility] = abilityLevel

	playerObj:SetObjVar("PrestigeAbilityLevels",unlockedAbilityLevels)
end

function SlotPrestigeAbility(playerObj, prestigeClass, prestigeAbility, position)
	--DebugMessage("SlotPrestigeAbility",tostring(playerObj),tostring(prestigeClass),tostring(prestigeAbility),tostring(position))
	if not(position) then
		for i=1,3 do
			local objVarKey = "PrestigeAbility"..i
			local positionInfo = playerObj:GetObjVar(objVarKey)
			if((not(position) and not(positionInfo)) or (positionInfo and positionInfo.AbilityName == prestigeAbility)) then
				position = i
			end
		end
	end

	if(position) then
		local abilityInfo = { Class = prestigeClass, AbilityName = prestigeAbility }
		local objVarKey = "PrestigeAbility"..position
		-- make sure they have this prestige class and ability
		playerObj:SetObjVar(objVarKey,abilityInfo)		

		playerObj:SendMessage("UpdatePrestigeBook")
		return position
	end
end

function HasPrestigeAbility(playerObj, prestigeClass, prestigeAbility, abilityLevel)
	local unlockedAbilityLevels = playerObj:GetObjVar("PrestigeAbilityLevels") or {}
	--DebugMessage("HasPrestigeAbility",tostring(playerObj),tostring(prestigeClass),tostring(prestigeAbility),tostring(abilityLevel))
	if(unlockedAbilityLevels[prestigeClass] and unlockedAbilityLevels[prestigeClass][prestigeAbility]) then
		return unlockedAbilityLevels[prestigeClass][prestigeAbility] >= abilityLevel
	end
end

function GetPrestigeAbilityLevel(playerObj, prestigeClass, prestigeAbility, isNPC)
	local prestigeAbilityData = GetPrestigeAbility(prestigeClass, prestigeAbility)

	if(prestigeAbilityData == nil) then return 0 end

	-- some abilities do not scale
	if(#prestigeAbilityData.Levels == 1) then
		return 1
	end

	local unlockedAbilityLevel = 0
	local unlockedAbilityLevels = playerObj:GetObjVar("PrestigeAbilityLevels") or {}
	if(unlockedAbilityLevels[prestigeClass] and unlockedAbilityLevels[prestigeClass][prestigeAbility]) then
		unlockedAbilityLevel = unlockedAbilityLevels[prestigeClass][prestigeAbility]
	end

	-- don't require NPCs to have the skill reqs.
	if ( isNPC ) then return unlockedAbilityLevel end
	
	if(unlockedAbilityLevel > 0) then
		local canUse = false
		for i=unlockedAbilityLevel,1,-1 do
			local abilityLevelData = prestigeAbilityData.Levels[i]
			canUse = HasPrestigePrerequisites(playerObj,prestigeClass,prestigeAbility,i)
			if(canUse) then
				--DebugMessage("GetPrestigeAbilityLevel",tostring(prestigeClass),tostring(prestigeAbility),tostring(i))
				return i		
			else
				return -i
			end
		end
	end

	--DebugMessage("GetPrestigeAbilityLevel",tostring(prestigeClass),tostring(prestigeAbility),0)
	return 0
end

--- Validate a prestige ability position
-- @param position(optional) validate a position, currently 1, 2, or 3 only. Defaults to 1
-- @return valid position
function ValidatePrestigeAbilityPosition(position)
	position = tonumber(position)
	if ( position == nil ) then position = 1 end
	if ( position < 1 ) then position = 1 end
	if ( position > 3 ) then position = 3 end
	return position
end

--- Given a player and a position, returns the ability name/class at given position if any
-- @param playerObj
-- @param position, prestige position (1, 2, or 3)
-- @return AbilityName, AbilityClass
function GetPrestigeAbilityNameClass(playerObj, position)
	if not(position) then
		LuaDebugCallStack("HAAA")
	end

	local abilityInfo = playerObj:GetObjVar("PrestigeAbility"..position)
	if (abilityInfo) then			
		return abilityInfo.AbilityName, abilityInfo.Class
	end
end

--- Get the user action table that will make up our action button on the hotbar.
-- @param playerObj mobileObj
-- @param position(optional)
-- @param prestigeAbility(optional) string, will use the player's prestige ability at given position if available.
-- @return lua table of user action data, nil on error (maybe player isn't prestiged?)
function GetPrestigeAbilityUserAction(playerObj, position, prestigeClass, prestigeAbility)
	if not(prestigeAbility) then
		prestigeAbility, prestigeClass = GetPrestigeAbilityNameClass(playerObj, position)
	end

	--DebugMessage("GetPrestigeAbilityUserAction",tostring(playerObj),tostring(position),tostring(prestigeClass),tostring(prestigeAbility))

	position = ValidatePrestigeAbilityPosition(position)	

	if(prestigeClass and prestigeAbility) then
		local ability = GetPrestigeAbility(prestigeClass, prestigeAbility)
		if ( ability and ability.Action ~= nil) then			
			local abilityLevel = GetPrestigeAbilityLevel(playerObj,prestigeClass, prestigeAbility)
			
			local isLocked = abilityLevel <= 0
			
			if ( isLocked ) then abilityLevel = math.abs(abilityLevel) end

			local abilityAction = deepcopy(ability.Action)
			abilityAction.DisplayName = abilityAction.DisplayName .. " " .. GetLevelText(abilityLevel)
			abilityAction.ServerCommand = "pa ".. prestigeClass .. " " .. prestigeAbility
			abilityAction.ID = "pa_"..prestigeClass.."_"..prestigeAbility
			abilityAction.ActionType = "CombatAbility"
			abilityAction.Locked = isLocked

			abilityAction.Tooltip = GetPrestigeAbilityTooltip(prestigeAbility, abilityLevel)

			if ( isLocked ) then
				local requireStr = BuildPrestigePrerequisitesString(prestigeClass,prestigeAbility,1)	
				abilityAction.Tooltip = (abilityAction.Tooltip or "") .. "\n\n[FF0000]Requires:\n"..requireStr.."[-]"
			end
			
			return abilityAction,true
		end
	end

	local id = "empty_pa_"..position
	if(prestigeClass and prestigeAbility) then
		id = "pa_"..prestigeClass.."_"..prestigeAbility
	end

	return {
		ID=id,
		ActionType="CombatAbility",
		DisplayName="Not Trained",
		Icon="Blank_Silver",
		Tooltip="Visit an ability trainer to train abilities.",
		Enabled=false,
		ServerCommand="",
		Locked=true,
	},false
end


--- Get the position a prestige ability is assigned to for a player.
-- @param playerObj
-- @param prestigeAbility string, name of prestige ability.
-- @return position of ability or nil if player doesn't have this ability assigned.
function GetPrestigeAbilityPosition(playerObj, prestigeAbility)
	if ( playerObj ~= nil ) then
		for i=1,3 do
			local abilityInfo = playerObj:GetObjVar("PrestigeAbility"..i)
			if ( abilityInfo and abilityInfo.AbilityName == prestigeAbility) then				
				return i
			end
		end
	end
	return nil
end

function UpdatePrestigeAbilityAction(playerObj,position)
	local curAction, hasAbility = GetPrestigeAbilityUserAction(playerObj, position)
	if(hasAbility) then
		UpdateMatchingUserActions(playerObj, curAction)
	end
end

--- Convenience function to update all prestige ability actions for a player
-- @param playerObj
function UpdateAllPrestigeAbilityActions(playerObj)
	UpdatePrestigeAbilityAction(playerObj,1)
	UpdatePrestigeAbilityAction(playerObj,2)
	UpdatePrestigeAbilityAction(playerObj,3)
end

function AddPrestigeXP(playerObj,amount)
	IncrementObjVar(playerObj,"LifetimePrestigeXP",amount)

	local prestigeXP = GetPrestigeXP(playerObj)
	if(prestigeXP + amount > ServerSettings.Prestige.PrestigePointXP) then
		local pointAmount = math.floor((prestigeXP + amount) / ServerSettings.Prestige.PrestigePointXP)
		IncrementObjVar(playerObj,"PrestigePoints",pointAmount)
		playerObj:SendMessage("UpdateSkillTracker")
		prestigeXP = prestigeXP - ServerSettings.Prestige.PrestigePointXP
	end
	playerObj:SetStatValue("PrestigeXP",prestigeXP + amount)

	playerObj:NpcSpeech(amount.." XP","combat")
end

function ConsumePrestigePoints(playerObj,amount)
	IncrementObjVar(playerObj,"PrestigePoints",-amount)
	playerObj:SendMessage("UpdateSkillTracker")
end

function GetPrestigeXP(playerObj)
	return playerObj:GetStatValue("PrestigeXP")
end

function GetPrestigePoints(playerObj)
	return playerObj:GetObjVar("PrestigePoints") or 0
end

function ValidateAbilityUnlock(playerObj,prestigeClass,prestigeAbility,abilityLevel,bookObj,options)
	options = options or {
		NoBook = false,
		NoPoints = false,
	}

    -- validate book
    --DebugMessage("ValidateAbilityUnlock",tostring(bookObj),tostring(bookObj:GetObjVar("PrestigeAbility")),tostring(prestigeAbility))
    if not(options.NoBook) and ( not(bookObj) or not(bookObj:IsValid())
            or not(bookObj:GetObjVar("PrestigeAbility") == prestigeAbility)
            or not(bookObj:TopmostContainer() == playerObj) ) then
        return false,"MissingBook"
    end

    -- validate xp requirement
    if not(options.NoPoints) and (GetPrestigePoints(playerObj) < ServerSettings.Prestige.AbilityLevelPointCost[abilityLevel]) then
	    return false,"Points"
    end

    -- prevent them from going backwards.
    if(HasPrestigeAbility(playerObj, prestigeClass, prestigeAbility, abilityLevel + 1)) then
        return false,"LessThanCurrent"
    end  

    -- validate skill requirement
    local canUse = HasPrestigePrerequisites(playerObj,prestigeClass,prestigeAbility,abilityLevel)
    if not(canUse) then
        return false,"MissingSkill"
    end

    return true
end

function GetPrestigeAbilityTooltip(prestigeAbility,abilityLevel)
	if not(prestigeAbility) then return "" end

	local paData = GetPrestigeAbility(nil,prestigeAbility)
	if not(paData) then return "" end

	local tooltip = paData.Action.Tooltip

	local abilityLevelData = paData.Levels[abilityLevel]
	if ( abilityLevelData ) then
		if ( abilityLevelData.Tooltip ) then
			tooltip = (tooltip or "") ..abilityLevelData.Tooltip.."\n"
		end

		if ( abilityLevelData.Cooldown ) then
			tooltip = (tooltip or "") .. "\n"..TimeSpanToWords(abilityLevelData.Cooldown, true).." cooldown"
		end

		if ( abilityLevelData.Range ) then
			tooltip = (tooltip or "") .. "\n"..abilityLevelData.Range.." unit range"
		end

		if ( paData.RequireWeaponClass ) then
			tooltip = (tooltip or "") .. "\n" .. paData.RequireWeaponClass .. " required"
		end

		if ( paData.RequireHeavyArmor ) then
			tooltip = (tooltip or "") .. "\nHeavy armor required"
		end

		if ( paData.RequireShield ) then
			tooltip = (tooltip or "") .. "\nShield required"
		end

		if ( paData.NoMount == true ) then
			tooltip = (tooltip or "") .. "\nCannot be used mounted"
		end
	end

	return tooltip or ""
end

function GiveMobileMinimumSkillXpForAbility(mobileObj, prestigeAbility, abilityLevel)
	abilityLevel = tonumber(abilityLevel or "1")
	local paData = GetPrestigeAbility(nil, prestigeAbility)
	if(paData) then
		local levelData = paData.Levels[abilityLevel]
		for skillName,skillLevel in pairs(levelData.Prerequisites) do
			if(type(skillLevel) == "table") then
				local skillOptions = skillLevel
				local isSet = false
				for skillName,skillLevel in pairs(skillOptions) do
					if(not(isSet) and GetSkillLevel(mobileObj,skillName) <= skillLevel) then
						SetSkillLevel(mobileObj,skillName,skillLevel)
						mobileObj:SystemMessage(skillName.." set to "..tostring(skillLevel))
						isSet = true
					end
				end
			else
				if(GetSkillLevel(mobileObj,skillName) < skillLevel) then
					SetSkillLevel(mobileObj,skillName,skillLevel)
					mobileObj:SystemMessage(skillName.." set to "..tostring(skillLevel))
				end
			end
		end

		local xpReq = ServerSettings.Prestige.AbilityLevelPointCost[abilityLevel] * ServerSettings.Prestige.PrestigePointXP
		AddPrestigeXP(mobileObj, xpReq)
	end
end

--- Sets up CombatAbilities for NPCs
function SetInitializerCombatAbilities(mobile, templateAbilites)
	mobile:SetObjVar("CombatAbilities", templateAbilites)
	local combatAbilityLevels = {}
	for i,data in pairs(templateAbilites) do
		local class = GetPrestigeAbilityClass(data[1])
		mobile:SetObjVar("PrestigeAbility" .. i, {
			Class = class,
			AbilityName = data[1]
		})
		combatAbilityLevels[class] = combatAbilityLevels[class] or {}
		combatAbilityLevels[class][data[1]] = (data[2] or 1)
	end
	mobile:SetObjVar("PrestigeAbilityLevels", combatAbilityLevels)
end