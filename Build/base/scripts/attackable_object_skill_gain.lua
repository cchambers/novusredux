--[[
	Set the combat skill on the attackable object, 
		when players hit the object these set skills will be used to determine the gains.
]]

RegisterEventHandler(EventType.ModuleAttached,"attackable_object_skill_gain",
	function ( ... )

		-- make it look attackable
		AddUseCase(this,"Attack",true)

		local level = 0
		if ( initializer ~= nil and initializer.SkillLevel ~= nil ) then
			level = initializer.SkillLevel
		end

		this:SetObjVar("SkillDictionary", {
			BrawlingSkill = {
				SkillLevel = level
			}
		})
	end)

	--[[
		training dummies do not support NpcSpeech, so until that becomes an option or another way is found, dummies cannot spit out damage
RegisterEventHandler(EventType.Message, "DamageInflicted", function(damager, damageAmount, damageType, isCrit, wasBlocked, isReflected)
	
	--to account for more absorbing then damage and prevent 0 damage done (or NaN or Infinity)
	if ( damageAmount < 1 or damageAmount ~= damageAmount or damageAmount > 999999999 ) then
		damageAmount = 1
	else
		damageAmount = math.round(damageAmount)
	end

	--this:NpcSpeech("[FCF914]"..damageAmount.."[-]", "combat")
	--damager:NpcSpeech("[FCF914]"..damageAmount.."[-]", "combat")
end)
]]