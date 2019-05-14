--- Update the player's client weapon primary and secondary abilities.
-- @param playerObj playerObj player to update
function UpdatePlayerWeaponAbilities(playerObj)
	if ( playerObj == nil or not(playerObj:IsPlayer()) ) then return end
	-- update primary
	RequestAddUserActionToSlot(playerObj, GetWeaponAbilityUserAction(playerObj, true))
	-- update secondary
	RequestAddUserActionToSlot(playerObj, GetWeaponAbilityUserAction(playerObj, false))

	UpdateHotbar(playerObj)
end

--- Get the primary or secondary weapon ability table for a weapon.
-- @param mobileObj(optional) mobileObj object to get ability for, defaults to BareHand
-- @param primary(optional) boolean set true to get the primary weapon ability, false (or ommit) for secondary ability.
-- @return the table for weapon ability or nil if non-existant
function GetWeaponAbility(mobileObj, primary)
	if ( primary ~= true ) then primary = false end
	local weaponType = nil
	if ( mobileObj ) then
		-- -- first check for ghosts
		-- if ( mobileObj:HasObjVar("IsGhost") ) then
		-- 	if ( primary ) then
		-- 		return WeaponAbilitiesData["SpiritWalk"]
		-- 	else
		-- 		return WeaponAbilitiesData["EphemeralProjection"]
		-- 	end
		-- end
		-- then check for dynamic WeaponAbilities (npcs)
		local dynamicAbilities = mobileObj:GetObjVar("WeaponAbilities")
		if ( dynamicAbilities ~= nil ) then
			return WeaponAbilitiesData[dynamicAbilities[(primary and "primary") or "secondary"]]
		else
			-- dynamic abilities didn't provide anything, see if they have a weapon in RightHand
			local weaponObj = mobileObj:GetEquippedObject("RightHand")

			-- get the weaponType from the object.
			if ( weaponObj ~= nil ) then
				weaponType = weaponObj:GetObjVar("WeaponType")
			else
				-- never found a weapon, left or right, default to barehands.
				weaponType = "BareHand"
			end
		end
	end
	local tableName = "SecondaryAbility"
	if ( primary ) then
		tableName = "PrimaryAbility"
	end
	if ( EquipmentStats.BaseWeaponStats[weaponType] ~= nil ) then
		local weaponAbility = EquipmentStats.BaseWeaponStats[weaponType][tableName]
		if ( weaponAbility ~= nil ) then
			return WeaponAbilitiesData[weaponAbility]
		end
	end
	return nil
end

--- Get the user action table that will make up our action button on the hotbar.
-- @param mobileObj(optional) mobileObj object to get ability for, defaults to BareHand abilities.
-- @param primary(optional) boolean true for primary ability, false (or ommit) for secondary.
-- @return lua table of user action data.
function GetWeaponAbilityUserAction(mobileObj, primary)
	local abilityTable = GetWeaponAbility(mobileObj, primary)
	local primarySecondary = "Secondary"
	local slot = 30
	local icon = "secondaryability"
	if ( primary ) then
		slot = 29
		primarySecondary = "Primary"
		icon = "primaryability"
	end

	if ( abilityTable == nil or abilityTable.Action == nil ) then
		-- no ability, send a locked action.
		return {
				DisplayName = primarySecondary .. " Weapon Ability",
				Tooltip = "This weapon has no "..primarySecondary.." ability.",
				ID = primarySecondary,
				ActionType = "CombatAbility",
				ServerCommand = "",
				Icon = icon,
				Slot = slot
			}
	end

	-- start with the action table from our static data
	local ability = deepcopy(abilityTable.Action)
	-- update it with specifics.
	ability.ServerCommand = "wa "..primarySecondary
	ability.ID = primarySecondary
	ability.ActionType = "CombatAbility"
	if ( abilityTable.Stamina == nil ) then abilityTable.Stamina = 100 end
	if ( abilityTable.Stamina > 0 ) then
		ability.Requirements = { { "Stamina", (abilityTable.Stamina or 100) } }
	end
	ability.Slot = slot

	return ability
end

--- Start the cooldown for a weapon ability
-- @param mobileObj
-- @param primary
-- @param cooldown TimeSpan
function StartWeaponAbilityCooldown(mobileObj, primary, cooldown)
	if ( mobileObj == nil ) then
		return LuaDebugCallStack("nil mobileObj provided.")
	end
	cooldown = cooldown or TimeSpan.FromMinutes(4)
	local primarySecondary = primary and "Primary" or "Secondary"
	mobileObj:ScheduleTimerDelay(cooldown, "weapon_ability_" .. primarySecondary)
	if ( mobileObj:IsPlayer() ) then
		mobileObj:SendClientMessage("ActivateCooldown", {
			"CombatAbility",
			primarySecondary,
			cooldown.TotalSeconds
		})
	end
end

--- Reset the cooldown for a weapon ability
-- @param mobileObj
-- @param primary(optional) reset primary or secondary weapon ability
function ResetWeaponAbilityCooldown(mobileObj, primary)
	local primarySecondary = primary and "Primary" or "Secondary"
	local weapon_ability_timer = "weapon_ability_" .. primarySecondary
	if ( mobileObj:HasTimer(weapon_ability_timer) ) then

		-- a timer exists, so the client should prevent the button, let's fix that
		mobileObj:SendClientMessage("ActivateCooldown", {
			"CombatAbility",
			primarySecondary,
			0	
		})
		-- then clear the timer
		mobileObj:RemoveTimer(weapon_ability_timer)
	end
end

--- Queue the primary or secondary ability for the weapon a mobile is holding until next successful attack.
-- @param mobileObj mobile that is performing the ability
-- @param primary(optional) boolean set true if you want to perform the primary weapon ability, false (or ommit) for secondary
function QueueWeaponAbility(mobileObj, primary, weaponAbility)
	if ( mobileObj:HasTimer("RecentAbilityUsed") ) then return end
	local primarySecondary = primary and "Primary" or "Secondary"

	if not( weaponAbility ) then
		weaponAbility = GetWeaponAbility(mobileObj, primary)
	end

	if ( weaponAbility.AllowDead ~= true and IsDead(mobileObj) ) then
		return false
	end

	if ( weaponAbility == nil ) then
		-- this weapon doesn't have an ability
		LuaDebugCallStack("Tried to Queue Weapon Ability that does not exist.")
	else
		if ( weaponAbility.SkillRequired == true ) then
			if ( GetSkillLevel(mobileObj, (weaponAbility.RequiredSkill or "DuelingSkill")) < ServerSettings.WeaponAbilities.SkillRequirements[primarySecondary] ) then
				return false -- doesn't meet skill requirements.
			end
		end

		local queuedAbility = {
			Stamina = weaponAbility.Stamina or 100, -- default to 100 incase stamina isn't set.
			ActionId = primarySecondary
		}

		if ( queuedAbility.Stamina > 0 and GetCurStamina(mobileObj) < queuedAbility.Stamina ) then
			return
		end

		if ( weaponAbility.Instant == true ) then
			-- prevent instant abilites if there's a cooldown
			if ( mobileObj:HasTimer("weapon_ability_" .. primarySecondary) ) then return false end
			-- dismount on instant abilities
			DismountMobile(mobileObj)
		end

		-- skill weapon abilities will queue a target
		if ( weaponAbility.QueueTarget ) then			
			if(weaponAbility.QueueTarget == "Any") then				
				mobileObj:RequestClientTargetAnyObj(mobileObj,"AbilitySelectTarget")
			elseif(weaponAbility.QueueTarget == "Loc") then
				mobileObj:RequestClientTargetLoc(mobileObj,"AbilitySelectTarget")
			else
				mobileObj:RequestClientTargetGameObj(mobileObj,"AbilitySelectTarget")
			end
			mobileObj:SendMessage("RegisterAbilitySelectTarget",primary,weaponAbility)
			return
		end

		-- handle instant abilites
		if ( weaponAbility.Instant == true ) then
			-- default to require a target, but if no target is true, skip enforcing target
			local target = weaponAbility.Target
			if not( weaponAbility.NoTarget == true ) then
				target = mobileObj:GetObjVar("CurrentTarget")
				if ( target == nil ) then
					if ( mobileObj:IsPlayer() ) then
						mobileObj:SystemMessage("Target required.", "info")
					end
					return
				end
				
				if ( (weaponAbility.Range ~= nil and not WithinCombatRange(mobileObj, target, weaponAbility.Range)) 
					or (weaponAbility.Range == nil and not WithinWeaponRange(mobileObj, target)) ) then
					if ( mobileObj:IsPlayer() ) then
						mobileObj:SystemMessage("Too far away.", "info")
					end
					return false
				end
			end

			if not( weaponAbility.AllowCloaked == true ) then
				-- instant ability, break cloak (unless specified not to)
				mobileObj:SendMessage("BreakInvisEffect", "Action")
			end
			
			if ( PerformWeaponAbility(mobileObj, target, weaponAbility, true) ) then
				-- instant ability, trigger the cooldown.
				StartWeaponAbilityCooldown(mobileObj, primary, weaponAbility.Cooldown)

				if not( weaponAbility.NoCombat == true ) then
					-- force combat mode cause they used a weapon ability.
					mobileObj:SendMessage("ForceCombat")
				end
			end
			return
		end

		queuedAbility.AllowCloaked = weaponAbility.AllowCloaked

		if (weaponAbility.Action.DisplayName) then
			queuedAbility.DisplayName = weaponAbility.Action.DisplayName
		end

		-- pass along the combat mods, 
		-- this is done since applying a combat mod via mobile effect will be done through a message and,
		-- the weapon ability is performed directly before the hit action. This is mostly to allow the next weapon swing to have changed damage.
		if ( weaponAbility.CombatMods ) then
			queuedAbility.CombatMods = weaponAbility.CombatMods
		end

		-- if we want to bypass normal hit actions
		if ( weaponAbility.SkipHitAction ) then
			queuedAbility.SkipHitAction = true
		end

		-- pass along mobile effects to apply to mobile performing ability
		if ( weaponAbility.MobileEffect ~= nil ) then
			queuedAbility.MobileEffect = weaponAbility.MobileEffect
			queuedAbility.MobileEffectArgs = weaponAbility.MobileEffectArgs
		end
		-- pass along any mobile effects to apply to target of mobile performing ability
		if ( weaponAbility.TargetMobileEffect ~= nil ) then
			queuedAbility.TargetMobileEffect = weaponAbility.TargetMobileEffect
			queuedAbility.TargetMobileEffectArgs = weaponAbility.TargetMobileEffectArgs
		end

		mobileObj:SendMessage("QueueWeaponAbility", queuedAbility)
	end
end

--- Perform a weapon ability (usually it's been queued)
-- @param mobileObj mobile performing ability
-- @param target
-- @param data, expected format: { Stamina = 20, MobileEffect = "MobileEffectName", MobileEffectArgs = { Duration = TimeSpan.FromSeconds(1) } } for example
-- @param hitSuccess boolean - Was the weapon ability a hit or miss?
-- @return true if the stamina was enough and taken
function PerformWeaponAbility(mobileObj, target, data, hitSuccess)
	if ( GetCurStamina(mobileObj) < data.Stamina ) then return false end
	if ( hitSuccess ) then
		if ( mobileObj and data.MobileEffect ) then
			StartMobileEffect(mobileObj, data.MobileEffect, target, (data.MobileEffectArgs or {}))
		end
		if ( target and data.TargetMobileEffect ) then
			target:SendMessage("StartMobileEffect", data.TargetMobileEffect, mobileObj, (data.TargetMobileEffectArgs or {}))
		end
		if ( data.Stamina > 0 ) then
			AdjustCurStamina(mobileObj, -data.Stamina)
		end
	else
		mobileObj:SendMessage("ExecuteMissAction", target)
	end
	return true
end

--- Handler function for client requests to use a weapon ability.
-- @param playerObj mobileObj player attempting to perform ability.
-- @param primarySecondary string if Primary will attempt to perform the primary weapon ability.
function PlayerUseWeaponAbility(playerObj, primarySecondary)
	if( playerObj == nil ) then return end
	QueueWeaponAbility(playerObj, ( primarySecondary == "Primary" ))
end