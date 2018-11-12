

function GetDurabilityValue(item)
	if(item == nil) then LuaDebugCallStack("nil item provided to GetDurabilityValue") end
	return item:GetObjVar("Durability") or GetMaxDurabilityValue(item)
end

function GetMaxDurabilityValue(item)
	if(item == nil) then LuaDebugCallStack("nil item provided to GetMaxDurabilityValue") end
	return item:GetObjVar("MaxDurability") or ServerSettings.Durability.DefaultMax
end

--- Get the string value of an item's durability
-- @param item
-- @param current(optional) double
-- @param max(optional) double
-- @return string
function GetDurabilityString(item, current, max)
	max = max or GetMaxDurabilityValue(item)
	current = current or GetDurabilityValue(item)
	current = math.min(current, max)

	if ( current == max ) then
		return nil
	end

	local percent = current / max
	if ( percent <= 0.10 ) then
		return "Badly Damaged"
	end
	if ( percent <= 0.25 ) then
		return "Damaged"
	end
	if ( percent <= 0.65 ) then
		return "Worn"
	end

	-- this is between New and Worn
	return "Slightly Worn"
end

--- Adjust the durability of an item. If current + amount is less than 1 the item will BREAK.
-- @param item
-- @param amount double(optional) Amount to adjust by, defaults to 0
-- @param current(optional) double Current item durability, will be read from object if not provided. 
-- @param max(optional) double Item's max durability, will be read from object if not provided.
function AdjustDurability(item, amount, current, max)
	if ( item == nil ) then
		LuaDebugCallStack("ERROR: nil item provided.")
		return
	end
	-- Blessed items cannot take damage (unless they are cursed)
	if ( item:HasObjVar("Blessed") and not item:HasObjVar("Cursed") ) then return end
	amount = amount or 0
	max = max or GetMaxDurabilityValue(item)
	current = ( current or GetDurabilityValue(item) ) + amount
	current = math.min(current, max)

	-- anything less than 1 BREAKS the item!
	if ( current < 1 ) then
		BreakItem(item)
		return
	end
	
	if ( current == max ) then
		-- when an item has full durability, it doesn't need this objvar.
		item:DelObjVar("Durability")
	else
		-- warn the player their item is about to break.
		if ( current <= ServerSettings.Durability.BreakWarnings ) then
			local holder = item:TopmostContainer()
			if ( holder and holder:IsPlayer() ) then
				holder:SystemMessage("Your " .. StripColorFromString(item:GetName()) .." is in danger of being destroyed!", "event")
			end
		end
		item:SetObjVar("Durability", current)
	end

	local durabilityString = GetDurabilityString(item, current, max)
	-- if the durability string has changed
	if ( durabilityString ~= GetDurabilityString(item, current - amount, max) ) then
		if ( durabilityString ) then
			-- update / add the string
			SetTooltipEntry(item, "Durability", durabilityString, -99999)
		else
			-- or remove the entry,
			RemoveTooltipEntry(item, "Durability")
		end
	end
end

--- Sets the maximum durability for an item
-- @param item
-- @param newMax
function SetMaxDurabilityValue(item, newMax)
	if ( item == nil ) then return LuaDebugCallStack("nil item provided.") end

	item:SetObjVar("MaxDurability", newMax)
	AdjustDurability(item, nil, nil, newMax)
end

function BreakItem(item)
	local holder = item:TopmostContainer()
	if ( holder ) then
		if ( holder:IsPlayer() ) then
			local weaponType = item:GetObjVar("WeaponType")
			if ( EquipmentStats.BaseWeaponStats[weaponType] and EquipmentStats.BaseWeaponStats[weaponType].WeaponClass == "Tool" ) then
				item:SendMessage("CancelHarvesting", holder)
			end
			
			-- do all the things that accompany unequipping an item.
			local tempPack = holder:GetEquippedObject("TempPack")
			if ( tempPack ) then
				item:MoveToContainer(tempPack, Loc(0,0,0))
			else
				item:SetWorldPosition(holder:GetLoc())
			end

			-- this is important enough to log it in the chat window and do an alert event
			holder:SystemMessage("Your " .. StripColorFromString(item:GetName()) .." has been destroyed!")
			holder:SystemMessage("Your " .. StripColorFromString(item:GetName()) .." has been destroyed!", "event")
		end
		holder:PlayObjectSound("Sunder")		
	end

	item:Destroy()
end