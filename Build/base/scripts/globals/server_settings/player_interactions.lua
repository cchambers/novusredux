ServerSettings.PlayerInteractions = {
	PlayerVsPlayerEnabled = true,
	PlayerVsPlayerConsensualOnly = false,

	GuardTowerProtectionRange = 15.0,
	GatekeeperProtectionRange = 15.0,
	GuaranteedGuardProtectionFullMap = false,
	GuaranteedGuardProtectionZones = {		
	}, 
	SlayImmediateProtectionZones = {
		"GuardZoneLarge","Subregion-SewerDungeon","Subregion-SewerDungeon2","Subregion-SewerDungeon3","Subregion-SewerDungeon4"
	},
	SlayImmediateProtectionMaps = {
		"Corruption",
		"Founders"
	},
	NeutralTownRegionNames = {
		"Area-Oasis", "ForestOutpost" 
	},
	--Guarded, GuardTower, 
	GuardProtectionEnterExitMsgMap = {
	["InstaKill.Enter"] = "[$1823]",
	["InstaKill.Exit"] = "[$1821]",
	["Guard.Enter"] = "[$1822]",
	["Guard.Exit"] =  "[$1821]",
	["GuardTower.Enter"] = "[$1822]",
	["GuardTower.Exit"] =  "[$1821]",
	["Area-Oasis.Enter"] = "[$3373]",
	["Area-Oasis.Exit"] =  "[$3372]",
	["ForestOutpost.Enter"] = "[$3375]",
	["ForestOutpost.Exit"] =  "[$3374]" },

	FullItemDropOnDeath = true, -- change player_corpse.xml template to adjust body decay time.
	ExileMurderCount = 5,
}