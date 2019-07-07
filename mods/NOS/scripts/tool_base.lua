

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

function UpdateToolTooltipString()	
	local tooltipString = ""	
	for i, j in pairs(toolBonuses) do
		tooltipString = tooltipString .. GetModifierString(i)
	end
	
	if( tooltipString ~= "" ) then
		SetTooltipEntry(this,"tool_base",tooltipString)
	end
end

RegisterEventHandler(EventType.Timer, "DelayedTooltipUpdate", 
	function()
		UpdateToolTooltipString()
	end)

RegisterEventHandler(EventType.Message, "UpdateTooltip", 
	function()
		UpdateToolTooltipString()
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, "tool_base", 
	function()
		-- give other scripts some time to add bonuses before we update the tooltip
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "DelayedTooltipUpdate")
	end)
