

mUsesTable = {}
toolBonuses ={ 
}

function GetModifierString(bonusName)
	local modStr = "" 
	local bonusValue = 0
	if(this:HasObjVar(bonusName)) then
		bonusValue = this:GetObjVar(bonusName)
	end
	if( bonusValue == 0 ) then
		return ""
	elseif( bonusValue > 0 ) then
		modStr = "+" .. tostring(bonusValue) .. " " .. toolBonuses[bonusName].DisplayString
	else
		modStr = tostring(bonusValue) .. " " .. toolBonuses[bonusName].DisplayString
	end

	return ColorizeStatString(modStr,bonusValue, toolBonuses[bonusName].reverseStat) .. "\n"
end

function GetToolBonusString()
end

function UpdateToolTooltipString()
	local tooltipString = ""
	for i, j in pairs(toolBonuses) do
		tooltipString = tooltipString .. GetModifierString(i)
	end

	if( tooltipString ~= "" ) then
		SetTooltipEntry("harvest_tool",tooltipString)
	end
end

function ValidateUse(user)
	if( user == nil or not(user:IsValid()) ) then
		DebugMessage("ERROR: User Not Valid")
		return false
	end

	if( this:TopmostContainer() == user ) then
		return true
	end
	--TODO Add Distance Check
	return true
end

RegisterEventHandler(EventType.Timer, "DelayedTooltipUpdate", 
	function()
		UpdateToolTooltipString()
	end)
RegisterEventHandler(EventType.Message, "UpdateTooltip", 
	function()
		UpdateToolTooltipString()
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, "harvest_tool_base", 
	function()
		-- give other scripts some time to add bonuses before we update the tooltip
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "DelayedTooltipUpdate")
	end)
