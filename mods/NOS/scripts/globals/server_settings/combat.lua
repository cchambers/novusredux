ServerSettings.Combat = {
	LOSEyeLevel = 1.9,
	DefaultBodySize = 0.8,

	MaxMinions = 3,

	NoSelfDamageOnAOE = true,
	AoEGuildDamageDefault = true,

	PlayerEndCombatPulse = 5,
	NPCEndCombatPulse = 20,

	MinimumSwingSpeed = 0.5, --fastest possible swing speed

	NoHideRange = 8, -- can not hide if within X units of another mob

	MountedAttackersCanTriggerDaze = false,
	DazedOnDamageWhileMounted = true, --Apply Daze to mounted mobs when they receive damage
	DismountWhileDazed = true, --Check to see if dazed targets have a chance to be dismounted.
	DismountWhileDazedChance = 50, -- Chance to be dismounted when sustaining damage while dazed.
	MountedAttackersCanTriggerDismount = false,

	BowStopMinDelay = TimeSpan.FromSeconds(1), --Minimum amount of time a bow will fire after stopping

	CastSwingDelay = TimeSpan.FromSeconds(1), --Amount of time to add to swing on a successful spell cast
}