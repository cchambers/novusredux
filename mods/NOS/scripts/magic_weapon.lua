require 'magic_item'

function DetermineMagicness()
	this:SetObjVar("MagicDamageBonus", RandomBonus())
	local weaponType = this:GetObjVar("WeaponType") or "BareHand"
	if ( Success(0.80) ) then
		--DetermineSkillMagicness("Vigor") --EquipmentStats.BaseWeaponStats[weaponType]["WeaponDamageType"])
	end
	if ( Success(0.60) ) then
		DetermineDurabilityMagicness()
	end
end

base_GetNameString = GetNameString
function GetNameString(name)
	local damageBonusIndex = this:GetObjVar("MagicDamageBonus") or 0
	if ( damageBonusIndex > 0 ) then
		name = name .. " of "..MagicItemDamageModStrings[damageBonusIndex]
	end
	
	return base_GetNameString(name)
end

function UpdateInfo()
	local name, color = GetNameColor()
	this:SetName(color .. GetNameString(name) .. "[-]")

	local damageBonusIndex = this:GetObjVar("MagicDamageBonus") or 0
	local damageBonusString = ""
	if ( damageBonusIndex > 0 ) then
		damageBonusString = "Damage Bonus: "..MagicItemDamageModifiers[damageBonusIndex].."\n"
	end

	tooltipString = damageBonusString .. GetSkillBonusTooltipString()

	if( tooltipString ~= "" ) then
		SetTooltipEntry(this,"magic_info", tooltipString)
	end
end


RegisterSingleEventHandler(EventType.Message, "IdentifyItem",
	function()
		if ( this:GetObjVar("Identified") ) then return end
		DetermineMagicness()
		this:SetObjVar("Identified", true)
		UpdateInfo()
	end)


RegisterEventHandler(EventType.Message, "UpdateInfo",
	function()
		UpdateInfo()
	end)