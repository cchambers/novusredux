require 'magic_item'

function DetermineMagicness()
	this:SetObjVar("MagicArmorBonus", RandomBonus())
	--DetermineSkillMagicness()
	if ( Success(0.60) ) then
		DetermineDurabilityMagicness()
	end
end

base_GetNameString = GetNameString
function GetNameString(name)
	local armorBonusIndex = this:GetObjVar("MagicArmorBonus") or 0
	if ( armorBonusIndex > 0 ) then
		name = name .. " of "..MagicItemArmorModStrings[armorBonusIndex]
	end
	
	return base_GetNameString(name)
end

function UpdateInfo()
	local name, color = GetNameColor()
	this:SetName(color .. GetNameString(name) .. "[-]")

	local armorBonusIndex = this:GetObjVar("MagicArmorBonus") or 0
	local armorBonusString = ""
	if ( armorBonusIndex > 0 ) then
		armorBonusString = "Armor Bonus: "..MagicItemArmorModifiers[armorBonusIndex].."\n"
	end

	tooltipString = armorBonusString .. GetSkillBonusTooltipString()

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