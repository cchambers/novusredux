RegisterEventHandler(EventType.Message, "DamageDealtOut", function(dmgSource,finalDamage,isCrit, damageAmt, damageInfo)
	DebugMessage("--------DAMAGE-----")
	if(damageInfo ~= nil) then 
		if(this:GetObjVar("DamageVerbose")) then
			local retStr = ""
			for f,v in pairs(damageInfo) do
				retStr = retStr .. "\n" .. tostring(f) .. " -> " .. tostring(v)
			end
			this:SystemMessage(retStr)
		else
			DebugTable(damageInfo) 
		end
	end

	DebugMessage("Mana Regen: " ..this:GetStatRegenRate("Mana"))

end)