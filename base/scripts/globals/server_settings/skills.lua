ServerSettings.Skills = {
	MustLearnSkills = false,
		
	PlayerSkillCap = {
		Single = 100,
		Total = 600,
	},

	-- multiplies all gain chances by this amount, set to 1 for no effect, lower for slower gains, higher for quicker gains.
	GainFactor = 1,
	-- upon a successful gain attempt, this amount will be added to the skill level.
	GainAmount = 0.1,
	-- under this level, a gain will always happen when checked.
	GuaranteedGainThreshold = 10,
	-- the gain chance will be multiplied by this amount if they are attempting to gain a skill point they have gained before but used the artifical cap to lower.
	RegainBonusModifier = 3,
	-- these are bonuses to skill gain, given the threshold criteria is met, GainAmount will be increased, respectively.
	LowerLevelGains = {
		-- under this level, UpperThresholdGainAmount will be applied.
		UpperThreshold = 20,
		UpperThresholdGainAmount = 0.2,
		-- under this level, LowerThresholdGainAmount will be applied.
		LowerThreshold = 10,
		LowerThresholdGainAmount = 0.3,
	},
	HigherLevelGains = {
		-- above this level, gains will become more difficult (lower chance to gain)
		DifficultyThreshold = 80
	},
	AntiMacro = {
		-- this is per skill, prevents spam gains
		TimeSpanBetweenGains = TimeSpan.FromSeconds(4),
	}
}