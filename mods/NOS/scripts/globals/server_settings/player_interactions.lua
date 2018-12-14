ServerSettings.PlayerInteractions = {
	PlayerVsPlayerEnabled = true,
	PlayerVsPlayerConsensualOnly = false,

	-- setting this to true effectively disables PvP everywhere
	GuaranteedTownProtectionFullMap = false,

	-- These protect everyone but outcasts
	TownProtectionZones = {
		"GuardZone",
	},

	-- Protect everyone but outcasts/chaos/chaos vs temp chaos
	ProtectionZones = {
		"GuardZoneLarge",
		"Subregion-SewerDungeon",
		"Subregion-SewerDungeon2",
		"Subregion-SewerDungeon3",
		"Subregion-SewerDungeon4"
	},

	-- same as ProtectionZones, but entire maps
	ProtectionMaps = {
		"Founders",
	},

	-- areas a nearby physical guard should protect you from anyone despite your karma
	NeutralZones = {
		"Area-Oasis",
		"ForestOutpost",
		"Area-Pyros Landing"
	},

	GuardTowerProtectionRange = 15.0,
	GatekeeperProtectionRange = 15.0,
	--Guarded, GuardTower, 
	GuardProtectionEnterExitMsgMap = {
		["Town.Enter"] = "You are under the protection of the guards.",
		["Town.Exit"] = "You have left the protection of the guards.",
		["Protection.Enter"] = "[$1822]",
		["Protection.Exit"] =  "[$1821]",
		["Neutral.Enter"] = "[$3375]",
		["Neutral.Exit"] =  "[$3374]"
	},

	FullItemDropOnDeath = true, -- change player_corpse.xml template to adjust body decay time.
	ExileMurderCount = 5,
}