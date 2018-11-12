ServerSettings.AI = {
	Casting = {
		-- used in lieu of absent Ai-HealthPercentToAllowHeal
		HealthPercentToAllowHeal = 0.5,

		--[[
			frequency that caster ai are aloud to cast spells, random is chosen between the two.
			
			used in lieu of absent Ai-MinSecondsBetweenCasts and/or Ai-MaxSecondsBetweenCasts object variables
		]]
		MinSecondsBetweenCasts = 2,
		MaxSecondsBetweenCasts = 5
	}
}