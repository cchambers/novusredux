DEFAULT_POTION_COOLDOWN = 120
function GetPotCooldown(user, pot)
	local potType = pot:GetObjVar("PotionType")
	local tCoolBon,tCoolMult = 0,1
	if(potType ~= nil) then
		tCoolBon,tCoolMult = GetScriptStatMods(user,potType .. "PotionTypeCooldownMod")
	end
	local uCoolBon,uCoolMult = GetScriptStatMods(user,"PotionCooldownMod")
	local potCool = pot:GetObjVar("Cooldown") or DEFAULT_POTION_COOLDOWN
	if (potCool == 0) then return 0 end
	potCool = math.max(1,(potCool * tCoolMult * uCoolMult) + tCoolBon + uCoolBon)
	return potCool
end


function TryUsePotion(user, pot)
	if(pot == nil) or (user == nil) then return end
	if(pot:TopmostContainer() ~= user) then 
			user:SystemMessage("[$1713]")
		return 
	end
	if(IsCooling(user,pot)) then
		user:SystemMessage("[$1714]")
		return
	end
	if(IsDead(user)) then
		user:SystemMessage("[$1715]")
		return
	end		
	DebugMessage("FROZE: " ..tostring(user:IsMobileFrozen()))
	local potResourceName = pot:GetObjVar("ResourceType")
	if(potResourceName == nil) then 
		DebugMessage("NO RESOURCE")
			return 
		end

	local potScript = pot:GetObjVar("PotionScript")
	local cooldown = GetPotCooldown(user, pot)
	local potType = pot:GetObjVar("PotionType")
	if(cooldown > 0) then 
		user:ScheduleTimerDelay(TimeSpan.FromSeconds(cooldown), potType .. "CooldownTimer")
	end
DebugMessage("Adding PotScript")
	if(potScript ~= nil) and (not user:HasModule(potScript)) then
		user:AddModule(potScript)
	end
	user:SendMessage("DrinkPot", potScript)
	RequestConsumeResource(user,potResourceName,1,"DrinkPot")

end

function IsCooling(user, pot)
	local potType = pot:GetObjVar("PotionType")
	if(potType == nil) then return false end
	if(user:HasTimer(potType .. "CooldownTimer")) then
		return true
	end
	return false
end
