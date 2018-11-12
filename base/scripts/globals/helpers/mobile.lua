

-- a list corresponding to each mobile mod and the stat that should be recalcuated when that mod changes,
MobileModRecalculateStat = {
	AccuracyPlus = { Accuracy = true },
	AccuracyTimes = { Accuracy = true },
	AgilityPlus = { Agility = true },
	AgilityTimes = { Agility = true },
	AttackPlus = { Attack = true },
	AttackTimes = { Attack = true },
	PowerPlus = { Power = true },
	PowerTimes = { Power = true },
	ForcePlus = { Force = true },
	ForceTimes = { Force = true },
	ConstitutionPlus = { Constitution = true },
	ConstitutionTimes = { Constitution = true },
	CritChancePlus = { CritChance = true },
	CritChanceTimes = { CritChance = true },
	DefensePlus = { Defense = true },
	DefenseTimes = { Defense = true },
	EvasionPlus = { Evasion = true },
	EvasionTimes = { Evasion = true },
	IntelligencePlus = { Intelligence = true },
	IntelligenceTimes = { Intelligence = true },
	StrengthPlus = { Strength = true },
	StrengthTimes = { Strength = true },
	WillPlus = { Will = true },
	WillTimes = { Will = true },
	WisdomPlus = { Wisdom = true },
	WisdomTimes = { Wisdom = true },

	-- max stats
	MaxHealthPlus = { MaxHealth = true },
	MaxHealthTimes = { MaxHealth = true },
	MaxManaPlus = { MaxMana = true },
	MaxManaTimes = { MaxMana = true },
	MaxStaminaPlus = { MaxStamina = true },
	MaxStaminaTimes = { MaxStamina = true },
	MaxVitalityPlus = { MaxVitality = true },
	MaxVitalityTimes = { MaxVitality = true },

	--regen stats
	HealthRegenPlus = { HealthRegen = true },
	HealthRegenTimes = { HealthRegen = true },
	ManaRegenPlus = { ManaRegen = true },
	ManaRegenTimes = { ManaRegen = true },
	StaminaRegenPlus = { StaminaRegen = true },
	StaminaRegenTimes = { StaminaRegen = true },
	VitalityRegenPlus = { VitalityRegen = true },
	VitalityRegenTimes = { VitalityRegen = true },

	-- other stats
	MoveSpeedPlus = { MoveSpeed = true },
	MoveSpeedTimes = { MoveSpeed = true },
	MountMoveSpeedPlus = { MoveSpeed = true },
	MountMoveSpeedTimes = { MoveSpeed = true },
}


function CanEquip(equipper,equipObject,equippedOn)
	Verbose("Mobile", "CanEquip",equipper,equipObject,equippedOn)
	if ( equipper:IsPlayer() ) then
		local weaponType = equipObject:GetObjVar("WeaponType")
		if ( weaponType and EquipmentStats.BaseWeaponStats[weaponType] and EquipmentStats.BaseWeaponStats[weaponType].NoCombat ~= true ) then
			local weaponClass = EquipmentStats.BaseWeaponStats[weaponType].WeaponClass
			if ( GetSkillLevel(equippedOn, EquipmentStats.BaseWeaponClass[weaponClass].WeaponSkill) < EquipmentStats.BaseWeaponStats[weaponType].MinSkill ) then
				local skillDisplayName = SkillData.AllSkills[EquipmentStats.BaseWeaponClass[weaponClass].WeaponSkill].DisplayName or EquipmentStats.BaseWeaponClass[weaponClass].WeaponSkill
				equipper:SystemMessage(EquipmentStats.BaseWeaponStats[weaponType].MinSkill.. " " .. skillDisplayName .. " required.", "info")
				return false
			end
		end
	end

	if (equippedOn:HasObjVar("OnlyEquipWeapons") and GetEquipSlot(equipObject) ~= "RightHand" and GetEquipSlot(equipObject) ~= "LeftHand") then
 		return false
	end

	if (equipObject:GetSharedObjectProperty("EquipSlot") == "Familiar") then
	 	return false
	end

	if(IsGod(equipper) or equippedOn == equipper) then
		return true
	end

	local owner = GetHirelingOwner(equippedOn)
	if ( owner and owner == equipper ) then
		return true
	end	

	return false
end

-- This function swaps the mobiles current weapon with the one passed in
function DoEquip(equipObject, equippedOn, user)
	Verbose("Mobile", "DoEquip", equipObject, equippedOn, user)
	if( equippedOn == nil ) then
		LuaDebugCallStack("nil equippedOn provided .")
		return
	end
	if( user == nil ) then user = equippedOn end

	--BB HACK: For no equip
	if(equipObject:HasModule("temporary_no_equip_item")) then
		user:SystemMessage("[$1878]")
		equippedOn:SendMessage("BreakInvisEffect")
		return
	end

	local equipSlot = equipObject:GetSharedObjectProperty("EquipSlot")
	
	--GW Trade check hack for currently existing Pouch items that have Trade set on them. (FIXME)
	if equipSlot and equipSlot ~= "Trade" then
		if not( CanEquip(user, equipObject, equippedOn) ) then 
			user:SystemMessage("You can not equip that there.","info")
			return 
		end
		local oppositeHand = nil
		if ( equipSlot == "LeftHand" ) then
			oppositeHand = "RightHand"
		elseif ( equipSlot == "RightHand" ) then
			oppositeHand = "LeftHand"
		end

		local backpackObj = equippedOn:GetEquippedObject("Backpack")
		if (backpackObj ~= nil) then
			local equippedObj = equippedOn:GetEquippedObject(equipSlot)
			if( equippedObj ~= nil ) then
				-- dont swap for backpacks that could get wierd
	   			if(equipSlot ~= "Backpack") then
	   				local randomLoc = GetRandomDropPosition(equippedOn)
					equippedObj:MoveToContainer(backpackObj, randomLoc)
					equippedObj:SendMessage("WasUnequipped", equippedOn)
	   			else
					user:SystemMessage("You are already wearing something there.")
					return
				end
			end
			--#2HanderForceBothHands
			-- if just equipped a LeftHand or RightHand
			if ( oppositeHand ~= nil ) then
				oppositeHand = equippedOn:GetEquippedObject(oppositeHand)
				-- if there's something in the other hand
				if ( oppositeHand ~= nil ) then
					local unequipOpposite = false
					-- if the other hand is a 2hander
					if ( IsTwoHandedWeapon(oppositeHand) ) then
						-- allow some stuff to stay equipped with 2 handers
						if ( equipObject:GetObjVar("CanBeEquippedWithTwoHandedWeapon") ) then
							unequipOpposite = false
						else
							unequipOpposite = true
						end
					end
					-- if we are equipping a 2hander
					if ( IsTwoHandedWeapon(equipObject) ) then
						-- allow some stuff to stay equipped with 2 handers
						if ( oppositeHand:GetObjVar("CanBeEquippedWithTwoHandedWeapon") ) then
							unequipOpposite = false
						else
							unequipOpposite = true
						end
					end
					if ( unequipOpposite ) then
						-- unequip other hand
						local randomLoc = GetRandomDropPosition(equippedOn)
						oppositeHand:MoveToContainer(backpackObj, randomLoc)
						oppositeHand:SendMessage("WasUnequipped", equippedOn)
					end
				end
			end
			--#End2HanderForceBothHands

		else
			user:SystemMessage("You need a backpack to swap equipment.")
		end
	else
		user:SystemMessage("You cannot equip that.")
		return
	end
	equippedOn:SendMessage("BreakInvisEffect")
	equippedOn:EquipObject(equipObject)
	equipObject:SendMessage("WasEquipped")
end

function DoUnequip(equipObject,equippedOn,user)
	if( equippedOn == nil ) then
		LuaDebugCallStack("nil equippedOn provided.")
	end
	if( user == nil ) then user = equippedOn end

	-- check valid object
	if( equipObject ~= nil and equipObject:IsValid() ) then
		local equipSlot = GetEquipSlot(equipObject)
		-- check it is equipped in that slot
		if(equipSlot ~= nil and equippedOn:GetEquippedObject(equipSlot) == equipObject) then
			local backpackObj = equippedOn:GetEquippedObject("Backpack")
			-- make sure we have a backpack
			if( backpackObj ~= nil) then				
   				local randomLoc = GetRandomDropPosition(backpackObj)
   				-- try to put the object in the container
   				if(TryPutObjectInContainer(equipObject, backpackObj, randomLoc)) then
   					equipObject:SendMessage("WasUnequipped", equippedOn)
					equippedOn:SendMessage("BreakInvisEffect")
				end
			end
		end
	end
end

--- Set a mobile mod, exactly the same as CombatMod but in base_mobile.lua (or player.lua) VM space. 
--- If the type is of Plus (MoveSpeedPlus for example), the value supplied will be added to the value this is modding, happens before Times mods are applied.
--- If the type is of Times (MoveSpeedTimes for example), when supplying -0.3 the final value will be 70% of original value, while supplying 0.30 the final value will be 130% of the original value. It's done this way so multiple mods added together will give us a fair number back.
-- @param mobileObj mobile to set mod on
-- @param modName string, the name of the mod to set, these can be found at the top of base_mobile_mods.lua
-- @param modId string, Identifier of the mod, use this Id to overwrite or remove any existing mods.
-- @param modValue any, the value to apply in this mod. (pass nil to remove a mod)
function SetMobileMod(mobileObj, modName, modId, modValue)
	if(mobileObj ~= nil) then
		mobileObj:SendMessage("MobileMod", modName, modId, modValue)
	end
end

--- Does exactly what SetMobileMod does, but will automatically remove the mod after the given timespan, it's safe to remove this manually before the time is up.
-- @param mobileObj mobile to set mod on
-- @param modName string, the name of the mod to set, these can be found in base_mobile_mods.lua
-- @param modId string, Identifier of the mod, use this Id to overwrite or remove any existing mods.
-- @param modValue any, the value to apply in this mod. (pass nil to remove a mod)
-- @param modExpire timespan, how long before the mod is automically removed.
function SetMobileModExpire(mobileObj, modName, modId, modValue, modExpire)
	if(mobileObj ~= nil) then
		mobileObj:SendMessage("MobileModExpire", modName, modId, modValue, modExpire)
	end
end

--- This is a glorified combiner, it adds all the values in a table together and gives a final modifier.
-- @param modTable the table full of each mod value
-- @param base(optional) Zero ( 0 ) if not provided. For Times tables we use a base of 1. So 0.3 ends up being 1.3 and -0.3 ends up 0.7
-- @return returns all values in the table added together, plus base.
function GetMobileMod(modTable, base)
	base = base or 0
	if(modTable) then
		for id,v in pairs(modTable) do			
			base = base + v
		end
	end
	return base
end

--- Copy of GetMobileMod but just named different to look better in the seperate scope.
function GetCombatMod(modTable, base)
	return GetMobileMod(modTable, base)
end

--- CombatMods work similar to MobileMods, though they do not effect derived stats and are applied ontop of any MobileMods, also they live in the combat.lua VM space.
-- @param mobileObj mobile to set mod on
-- @param modName string, the name of the mod to set, these can be found at the top of combat.lua
-- @param modId string, Identifier of the mod, use this Id to overwrite or remove any existing mods.
-- @param modValue any, the value to apply in this mod. (set nil to remove a mod)
function SetCombatMod(mobileObj, modName, modId, modValue)
	if(mobileObj ~= nil) then
		mobileObj:SendMessage("CombatMod", modName, modId, modValue)
	end
end

--- Determine if a mobile is mounted or not
-- @param mobileObj
-- @return true if mobileObj is mounted
function IsMounted(mobileObj)
	return ( GetMount(mobileObj) ~= nil )
end

--- Get the mounted object for a player, it's a convenience function to help make things look more clean but really it's just returning the equipped object at Mount slot.
-- @param mobileObj
-- @return mobileObj or nil if no mount
function GetMount(mobileObj)
	return mobileObj:GetEquippedObject("Mount")
end

--- Mount a mobile onto another mobile
-- @param mobileObj
-- @param mountObj
function MountMobile(mobileObj, mountObj)
	-- prevent exceptions
	if ( mobileObj == nil ) then
		LuaDebugCallStack("nil mobileObj provided to MountMobile.")
		return false
	end

	if (IsMobileDisabled(mobileObj)) then
		if (mobileObj:IsPlayer()) then
			mobileObj:SystemMessage("Cannot mount now.", "info")
		end
		return false
	end

	if ( HasMobileEffect(mobileObj, "NoMount") ) then
		if ( mobileObj:IsPlayer() ) then
			mobileObj:SystemMessage("Cannot mount yet.", "info")
		end
		return false
	end

	if ( mobileObj:IsInRegion("NoMount") ) then
		if ( mobileObj:IsPlayer() ) then
			mobileObj:SystemMessage("Cannot mount here.", "info")
		end
		return false
	end
	-- prevent mounting when already mounted
	if ( mobileObj:GetEquippedObject("Mount") ~= nil ) then
		if ( mobileObj:IsPlayer() ) then
			mobileObj:SystemMessage("Already mounted.", "info")
		end
		return false
	end
	-- prevent exceptions
	if ( mountObj == nil ) then
		LuaDebugCallStack("nil mountObj provided to MountMobile.")
		return false
	end
	if ( GetEquipSlot(mountObj) == "Mount" ) then
		-- clear target if the mount is the current target
		if ( mobileObj:GetObjVar("CurrentTarget") == mountObj ) then
			mobileObj:SendMessage("ClearTarget")
		end
		RemoveUseCase(mountObj, "Mount")
		mountObj:SetObjectOwner(nil)
		mobileObj:EquipObject(mountObj)
		--break invis/hide effects
		mobileObj:SendMessage("BreakInvisEffect");
		-- mark movespeed stat dirty
		mobileObj:SendMessage("RecalculateStats", {MoveSpeed=true})
		AddUseCase(mobileObj,"Dismount",true,"IsSelf")
	end
end

--- Dismount a mobile, does nothing if not mounted
-- @param mobileObj
-- @param mountObj(optional)
-- @return boolean true if dismounted, false otherwise.
function DismountMobile(mobileObj, mountObj)
	mountObj = mountObj or GetMount(mobileObj)
	if ( mobileObj and mountObj ) then
		--TODO IR A hack to fix horse teleporting
		--Can be removed on next client release
		local speed = mountObj:GetBaseMoveSpeed()
		mountObj:SetBaseMoveSpeed(speed + 0.1)
		mountObj:SetBaseMoveSpeed(speed)
		
		mountObj:SetWorldPosition(mobileObj:GetLoc())
		mobileObj:SendMessage("RecalculateStats", {MoveSpeed=true})-- mark movespeed stat dirty
		mountObj:SetObjectOwner(mobileObj)
		AddUseCase(mountObj,"Mount",true,"IsController")
		RemoveUseCase(mobileObj,"Dismount")
		mobileObj:SendMessage("BreakInvisEffect", "Mount")
		mountObj:SendMessage("BreakInvisEffect", "Mount")
		mobileObj:SendMessage("StartMobileEffect", "NoMount")
		return true
	end
	return false
end

function IsWearingHeavyArmor(mobileObj, hasShield)
	if ( mobileObj == nil ) then return false end
	--if ( hasShield == true ) then return true end
	for i,slot in pairs(ARMORSLOTS) do
		if ( GetArmorClass(mobileObj:GetEquippedObject(slot)) == "Heavy" ) then
			return true
		end
	end
	return false
end

-- Some mobs have the same animation set as humans. 
function HasHumanAnimations(mobileObj)
	-- mobs that can equip armor use the same rig as humans and therefore have the same animation set
	return mobileObj:HasObjectTag("CanEquipArmor")
end

function Resisted(mobileObj)
	if Success(0.5*((GetWill(mobileObj) - ServerSettings.Stats.IndividualStatMin) / (ServerSettings.Stats.IndividualPlayerStatCap - ServerSettings.Stats.IndividualStatMin))) then
		mobileObj:NpcSpeech("[99ffbb]*resisted*[-]", "combat")
		return true
	end
	return false
end