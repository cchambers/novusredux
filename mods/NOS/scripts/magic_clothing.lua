require 'NOS:magic_item'

function UpdateInfo()
	local name, color = GetNameColor()
	this:SetName(color .. GetSkillNameString(name) .. "[-]")

	local skillBonusString = GetSkillBonusTooltipString()

	if( skillBonusString ~= "" ) then
		SetTooltipEntry(this,"magic_info", skillBonusString)
	end
end

RegisterSingleEventHandler(EventType.Message, "IdentifyItem",
	function()
		if ( this:GetObjVar("Identified") ) then return end
		--DetermineSkillMagicness()
		
		this:SetObjVar("Identified", true)
		UpdateInfo()
	end)

RegisterEventHandler(EventType.Message, "UpdateInfo",
	function()
		UpdateInfo()
	end)