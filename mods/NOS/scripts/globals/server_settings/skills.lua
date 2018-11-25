ServerSettings.Skills = {
	MustLearnSkills = false,
		
	PlayerSkillCap = {
		Single = 100,
		Total = 5000,
	},

	-- multiplies all gain chances by this amount, set to 1 for no effect, lower for slower gains, higher for quicker gains.
	GainFactor = 2,
	-- upon a successful gain attempt, this amount will be added to the skill level.
	GainAmount = 0.1,
	-- the gain chance will be multiplied by this amount if they are attempting to gain a skill point they have gained before but used the artifical cap to lower.
	RegainBonusMultiplier = 3,
	-- the gain chance will be multiplied by this amount if they are under the effect of a power hour potion
	PowerHourMultiplier = 2,
	-- these are bonuses to skill gain, given the threshold criteria is met, GainAmount will be increased, respectively.
	LowerLevelGains = {
		-- under this level, UpperThresholdGainAmount will be applied.
		UpperThreshold = 20,
		UpperThresholdGainAmount = 0.2,
		-- under this level, LowerThresholdGainAmount will be applied.
		LowerThreshold = 10,
		LowerThresholdGainAmount = 0.3,
		-- under this level skills gains will be easier (higher chance to gain)
		DifficultyThreshold = 20,
	},
	HigherLevelGains = {
		-- above this level, gains will become more difficult (lower chance to gain)
		DifficultyThreshold = 80
	},
	AntiMacro = {
		-- this is per skill, prevents spam gains
		TimeSpanBetweenGains = TimeSpan.FromSeconds(2),
	}
}