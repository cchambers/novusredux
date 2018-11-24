-- Equipment slots
--      RightHand
--	    LeftHand
--	    Head
--		Chest
--		Legs
--		Ring
--		Necklace
--		Backpack
--		Bank
--      TempPack
-- Body Parts
-- 		BodyPartHead
--		BodyPartHair

-- Equipment Object Variables
-- 		SpellConduit

-- Weapon Bonuses - Default to 0, Overriden in template using initializer to apply_bonuses module
--		BonusMinDamage
--      BonusMaxDamage
--      BonusSpeedOffset
--      BonusFinalDamage
--      BonusParryChance
--      BonusCritChance
--      BonusRangeOffset
--      BonusPenetration
--      BonusDurability
--      BonusRechargeTime
--      BonusNockTime
--      BonusDrawTime

-- Armor bonuses - Default to 0, Overriden in template using initializer to apply_bonuses module
--      BonusAbsorption
--      BonusEvasionModifier
--      BonusPiercingResist
--      BonusSlashingResist
--      BonusBashingResist
--      BonusManaBarrier
--      BonusStaminaModifier
--      BonusSwingSpeedModifier
--      BonusDurability


-- Shield bonuses - Default to 0, Overriden in template using initializer to apply_bonuses module
-- NOTE: Shields have some of the same possible bonuses as weapons and armor
--      BonusMinBlockChance
--      BonusIncreasedBlockChance
--      BonusAbsorption
--      BonusBlockCooldown
--      BonusBlockDuration
--      BonusSwingSpeedModifier
--      BonusEvasionModifier
--      BonusMinDamage
--      BonusMaxDamage
--      BonusFinalDamage

-- Harvesting Tools
--
--	BonusHarvestDelay
--	BonusHarvestEfficiency
--	BonusHarvestYield
--
--

-- these (except for Familiar) are used to determine item transfer from corpse on resurrect (among many other things)
ITEM_SLOTS = {
	"Head",
	"Chest",
	"Legs",
	"RightHand",
	"LeftHand",
	"Familiar",
	"Ring",
	"Necklace",
}

ARMORSLOTS = {
	"Head",
	"Chest",
	"Legs"
}

JEWELRYSLOTS = {
	"Ring",
	"Necklace",
}

function IsItemSlot(slotName)
	for i,itemSlot in pairs(ITEM_SLOTS) do
		if(slotName == itemSlot) then
			return true
		end
	end

	return false
end

function IsJewelrySlot(slotName)
	for i,jewelrySlot in pairs(JEWELRYSLOTS) do
		if(slotName == jewelrySlot) then
			return true
		end
	end

	return false
end

function IsArmorSlot(slotName)
	for i,armorSlot in pairs(ARMORSLOTS) do
		if(slotName == armorSlot) then
			return true
		end
	end

	return false
end

ITEM_DURABILITY_TABLE = {
	Fragile = 5,
	Flimsy = 20,
	Stout = 35,
	Sturdy = 50,
	Robust= 70,
	Stalwart= 90,
}

function ColorizeStatString(statStr,bonusValue, reverseStat)
	if(reverseStat == true) then bonusValue = -bonusValue end
	if (bonusValue == nil) then bonusValue = 0 end
	if( bonusValue > 0 ) then
		return "[08FF08]" .. statStr .. "[-]"
	elseif( bonusValue < 0 ) then
		return "[F04646]" .. statStr .. "[-]"
	else
		return "[A1ADCC]" .. statStr.. "[-]"
	end
end

function ColorItemName(item,durability)	
	if(item == nil) then
		LuaDebugCallStack("ITEM NAME")
		return
	end

	if(item:IsMobile()) then
		LuaDebugCallStack("ColorItemName on Mobile")
		return
	end

	local newName, color = StripColorFromString(item:GetName())
	-- if a color is specified, dont override it 	
	if (color == nil or color == "") then
		color = "D9D9D9"
	end
	if (durability == nil) then
		durability = item:GetObjVar("MaxDurability") or 0
	end

	if (durability >= ITEM_DURABILITY_TABLE.Flimsy) then
		color = "978161"
	elseif (durability >= ITEM_DURABILITY_TABLE.Stout) then
		color = "22D322"
	elseif (durability >= ITEM_DURABILITY_TABLE.Sturdy) then
		color = "39EAFF"
	elseif (durability >= ITEM_DURABILITY_TABLE.Robust) then
		color = "CF5BFF"
	elseif (durability >= ITEM_DURABILITY_TABLE.Stalwart) then
		color = "F7962E"
	end
	--f2ff2a - Boss/Special
	
	item:SetName("[" .. color .. "]" .. item:GetName() .. "[-]")
end

function GetEquipSlot(targetObj)
	return targetObj:GetSharedObjectProperty("EquipSlot")
end

function MoveEquipmentToGround(target,ignoreChest)

	local backpackObj = target:GetEquippedObject("Backpack")
    local leftHand = target:GetEquippedObject("LeftHand")
    local rightHand = target:GetEquippedObject("RightHand")
    local chest = target:GetEquippedObject("Chest")
    local legs = target:GetEquippedObject("Legs")
    local head = target:GetEquippedObject("Head")
   --DebugMessage(this:GetLoc()+Loc(math.random()-0.5,0,math.random()-0.5))
    if (lefHand ~= nil) then leftHand:SetWorldPosition(target:GetLoc()+Loc(math.random()-0.5,0,math.random()-0.5)) end
    if (rightHand ~= nil) then rightHand:SetWorldPosition(target:GetLoc()+Loc(math.random()-0.5,0,math.random()-0.5)) end
    if (chest ~= nil and not ignoreChest) then chest:SetWorldPosition(target:GetLoc()+Loc(math.random()-0.5,0,math.random()-0.5)) end
    if (legs ~= nil) then legs:SetWorldPosition(target:GetLoc()+Loc(math.random()-0.5,0,math.random()-0.5)) end
    if (head ~= nil) then head:SetWorldPosition(target:GetLoc()+Loc(math.random()-0.5,0,math.random()-0.5)) end
    if (backpackObj ~= nil) then
		local lootObjects = backpackObj:GetContainedObjects()
		--DebugMessage(DumpTable(lootObjects))
		for i,j in pairs(lootObjects) do 
			--DebugMessage("Yes it's happening")
			j:SetWorldPosition(target:GetLoc()+Loc(math.random()-0.5,0,math.random()-0.5))
			Decay(j)
		end
	else
		local lootObjects = target:GetContainedObjects()
		--DebugMessage(DumpTable(lootObjects))
		for i,j in pairs(lootObjects) do 
			--DebugMessage("Yes it's happening")
			j:SetWorldPosition(target:GetLoc()+Loc(math.random()-0.5,0,math.random()-0.5))
			Decay(j)
		end
	end
end

--helper function that searches an object for all it's equippable objects and equips them randomly on the mob
function AutoEquipMob(target,container)
	local onlyHands = target:GetObjVar("OnlyEquipWeapons")
	local lootObjects = container:GetContainedObjects()
    local leftHand = {}
    local rightHand = {}
    local chest = {}
    local legs = {}
    local head = {}
	for i,j in pairs(lootObjects) do 
		if (GetEquipSlot(j) == "LeftHand") then
			table.insert(leftHand,j)
		elseif (GetEquipSlot(j) == "RightHand") then
			table.insert(rightHand,j)
		elseif (GetEquipSlot(j) == "Chest") then
			table.insert(chest,j)
		elseif (GetEquipSlot(j) == "Legs") then
			table.insert(legs,j)
		elseif (GetEquipSlot(j) == "Head") then
			table.insert(head,j)
		end
	end
	if (not onlyHands) then
		if (#head > 0) then
			target:EquipObject(head[math.random(1,#head)])
		end
		if (#legs > 0) then
			target:EquipObject(legs[math.random(1,#legs)])
		end
		if (#chest > 0) then
			target:EquipObject(chest[math.random(1,#chest)])
		end
	end
	if (#leftHand > 0) then
		target:EquipObject(leftHand[math.random(1,#leftHand)])
	end
	if (#rightHand > 0) then
		target:EquipObject(rightHand[math.random(1,#rightHand)])
	end
end

function GetEquipmentTooltipTable(item, tooltipInfo)
	tooltipInfo = tooltipInfo or {}
	
	local weaponType = item:GetObjVar("WeaponType")
	if ( weaponType ) then
		if ( EquipmentStats.BaseWeaponStats[weaponType] ~= nil and EquipmentStats.BaseWeaponStats[weaponType].NoCombat ~= true ) then
			local weaponClass = EquipmentStats.BaseWeaponStats[weaponType].WeaponClass

			-- add weapon type display name
			if ( EquipmentStats.BaseWeaponClass[weaponClass] and EquipmentStats.BaseWeaponClass[weaponClass].DisplayName ) then
				tooltipInfo.WeaponType = {
					TooltipString = EquipmentStats.BaseWeaponClass[weaponClass].DisplayName,
					Priority = 6,
				}
			end

			-- add attack
			if ( EquipmentStats.BaseWeaponStats[weaponType].Attack ) then
				local bonus = item:GetObjVar("AttackBonus") or 0
				local str = " Attack"
				if ( bonus > 0 ) then str = string.format("%s (+%d%%)", str, bonus) end
				tooltipInfo.Attack = {
					TooltipString = EquipmentStats.BaseWeaponStats[weaponType].Attack..str,
					Priority = 5,
				}

				bonus = item:GetObjVar("AccuracyBonus") or 0
				if ( bonus > 0 ) then
					tooltipInfo.Accuracy = {
						TooltipString = string.format("+%d Accuracy", bonus),
						Priority = 4,
					}
                end
			end

			-- add speed tip
			if ( EquipmentStats.BaseWeaponStats[weaponType].Speed ) then
				tooltipInfo.Speed = {
					TooltipString = "Speed " .. EquipmentStats.BaseWeaponStats[weaponType].Speed,
					Priority = 3,
				}
			end

			-- add power
			if ( EquipmentStats.BaseWeaponStats[weaponType].Power ) then
				tooltipInfo.Power = {
					TooltipString = EquipmentStats.BaseWeaponStats[weaponType].Power.." Power",
					Priority = 2,
				}
			end

			-- add force
			if ( EquipmentStats.BaseWeaponStats[weaponType].Force ) then
				tooltipInfo.Force = {
					TooltipString = EquipmentStats.BaseWeaponStats[weaponType].Force.." Force",
					Priority = 1,
				}
			end
		end
	end

	local armorType = item:GetObjVar("ArmorType")
	if ( armorType ) then
		if ( EquipmentStats.BaseArmorStats[armorType] ~= nil ) then
			local armorClass = EquipmentStats.BaseArmorStats[armorType].ArmorClass
			local equipSlot = GetEquipSlot(item)

			-- add armor class
			tooltipInfo.ArmorClass = {
				TooltipString = armorClass,
				Priority = 20,
			}
			
			-- add armor rating
			local bonus = item:GetObjVar("ArmorBonus") or 0
			if ( bonus > 0 ) then
				tooltipInfo.ArmorRating = {
					TooltipString = string.format("+%d Defense", bonus),
					Priority = 3,
				}
			end

			-- add stamina regen modifier
			local staminaModifier = EquipmentStats.BaseArmorClass[armorClass][equipSlot].StaRegenModifier or 0
			if ( staminaModifier > 0 ) then
				tooltipInfo.StamMod = {
					TooltipString = staminaModifier .. " Stamina Regeneration",
					Priority = 2,
				}
			end

			--[[ TODO: Re-enabled per item mana regen bonus
			--add mana regen modifier
			local manaModifier = EquipmentStats.BaseArmorStats[armorType][equipSlot].ManaRegenModifier or 0
			if ( manaModifier > 0 ) then
				tooltipInfo.ManaMod = {
					TooltipString = "+"..manaModifier .. " Mana Regeneration",
					Priority = 1,
				}
			end
			]]
		end
	end

	local shieldType = item:GetObjVar("ShieldType")
	if ( shieldType ) then

		local bonus = item:GetObjVar("ArmorBonus") or 0
		local str = " Armor Rating"
		if ( bonus > 0 ) then str = string.format("%s (+%d)", str, bonus) end

		-- add armor rating
		tooltipInfo.ArmorRating = {
			TooltipString = EquipmentStats.BaseShieldStats[shieldType].ArmorRating .. str,
			Priority = 3,
		}

		--add mana regen modifier
		local manaModifier = EquipmentStats.BaseShieldStats[shieldType].ManaRegenModifier or 0
		if ( manaModifier > 0 ) then
			tooltipInfo.ManaMod = {
				TooltipString = "+"..manaModifier .. " Mana Regeneration",
				Priority = 1,
			}
		end

	end

	local jewelryType = item:GetObjVar("JewelryType")
	if ( jewelryType ) then
		local typeData = JewelryTypeData[jewelryType]
		if ( typeData.Will ) then
			tooltipInfo.WillStatMod = {
				TooltipString = string.format("+%s Will", typeData.Will),
				Priority = 3,
			}
		end
		if ( typeData.Wis ) then
			tooltipInfo.WisStatMod = {
				TooltipString = string.format("+%s Wisdom", typeData.Wis),
				Priority = 3,
			}
		end
		if ( typeData.Con ) then
			tooltipInfo.ConStatMod = {
				TooltipString = string.format("+%s Constitution", typeData.Con),
				Priority = 3,
			}
		end
	end
	-- this rest of this function only applies to weapons and armor (stuff that can be equipped in hand or on body)
	if ( not weaponType and not armorType and not shieldType and not jewelryType ) then return tooltipInfo end


	-- add durability.
	local durabilityString = GetDurabilityString(item)
	if ( durabilityString ) then
		tooltipInfo.Durability = {
			TooltipString = durabilityString,
			Priority = -99999,
		}
	end

	return tooltipInfo
end