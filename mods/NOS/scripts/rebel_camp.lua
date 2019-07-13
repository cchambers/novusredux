require 'NOS:cultist_camp'

DifficultySettings = 
{
	['Easy'] = {
		['CultistCount'] = 2,
		['CultistTemplates'] =  { "rebel", "rebel_female","traitor_militia", },
		['TreasureTemplate'] = "treasurechest_rebel_easy",
	},

	['Medium'] = {
		['CultistCount'] = 3,
		['CultistTemplates'] =  { "traitor_militia", "rebel","rebel_mage", "rebel_mage_female", "rebel_female", },
		['TreasureTemplate'] = "treasurechest_rebel_medium",
	},

	['Hard'] = {
		['CultistCount'] = 3,
		['CultistTemplates'] =  { "traitor_militia", "rebel","rebel_mage", "rebel_mage_female", "rebel_female", "traitor_guard",},
		['BossTemplates'] = { "rebel_captain", "rebel_captain_mage" },
		['TreasureTemplate'] = "treasurechest_rebel_hard",	
	},

	['CultistEasy'] = {
		['CultistCount'] = 2,
		['CultistTemplates'] =  { "cultist_mage_apprentice", "cultist_warrior_rookie","cultist_mage_apprentice_female", "cultist_warrior_rookie_female" },
		['TreasureTemplate'] = "treasurechest_cultistcamp_easy",
	},

	['CultistMedium'] = {
		['CultistCount'] = 2,
		['CultistTemplates'] =  { "cultist_mage_apprentice", "cultist_mage_devout", "cultist_warrior_rookie", "cultist_warrior_veteran", "cultist_mage_apprentice_female", "cultist_mage_devout_female", "cultist_warrior_rookie_female", "cultist_warrior_veteran_female" },
		['TreasureTemplate'] = "treasurechest_cultistcamp_medium",
	},

	['CultistHard'] = {
		['CultistCount'] = 3,
		['CultistTemplates'] =  { "cultist_mage_apprentice", "cultist_mage_devout", "cultist_warrior_rookie", "cultist_warrior_veteran", "cultist_mage_apprentice_female", "cultist_mage_devout_female", "cultist_warrior_rookie_female", "cultist_warrior_veteran_female"},
		['BossTemplates'] = { "cultist_boss_archmage", "cultist_boss_weaponmaster" },
		['TreasureTemplate'] = "treasurechest_cultistcamp_hard",	
	}
}
