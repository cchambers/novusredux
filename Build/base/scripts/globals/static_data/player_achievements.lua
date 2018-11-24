--[[
	-----------Achievement format-----------
	AchievementCategory{
		AchievementType = {
			{"AchievementName",AchievementRequirement,"Description",RewardTable}
			Add more achievement levels if applicable
		}
	}
]]

AllAchievements = {
	SkillAchievements = {
		AlchemySkill = {
			{"Alchemist"				,30		,"Given to those who can practice alchemy."						,{Title = "Apprentice Alchemist"				}},
			{"Journeyman Alchemist"		,50		,"Given to those who are good at alchemy."						,{Title = "Journeyman Alchemist"	}},
			{"Master Alchemist"			,80		,"Given to those who have mastered the art of alchemy."			,{Title = "Master Alchemist"		}},
			{"Grandmaster Alchemist"	,100	,"Given to those who are among the most profound alchemists."	,{Title = "Grandmaster Alchemist"	}},
		},
		
		AnimalLoreSkill = {
			{"Ranger"					,30		,"Given to those who are animal trainers."							,{Title = "Apprentice Ranger"				}},
			{"Journeyman Ranger"		,50		,"Given to those who are decent animal tamers."						,{Title = "Journeyman Ranger"		}},
			{"Master Ranger"			,80		,"Given to those who are masters and attuned to animals."			,{Title = "Master Ranger"			}},
			{"Grandmaster Ranger"		,100	,"Given to those who are renound for their ability with animals."	,{Title = "Grandmaster Ranger"	}},
		},

		AnimalTamingSkill = {
			{"Animal Tamer"				,30		,"Given to those who are animal trainers."							,{Title = "Apprentice Animal Tamer"				}},
			{"Journeyman Tamer"			,50		,"Given to those who are decent animal tamers."						,{Title = "Journeyman Tamer"			}},
			{"Master Animal Tamer"		,80		,"Given to those who are masters and attuned to animals."			,{Title = "Master Animal Tamer"		}},
			{"Grandmaster Animal Tamer"	,100	,"Given to those who are renound for their ability with animals."	,{Title = "Grandmaster Animal Tamer"	}},
		},

		ArcherySkill = {
			{"Archer"				,30		,"Given to those who have skill in archery."				,{Title = "Apprentice Archer"				}},
			{"Journeyman Archer"	,50		,"Given to those who have exceptional skill in archery."	,{Title = "Journeyman Archer"	}},
			{"Master Archer"		,80		,"Given to those who have mastered the art of archery."		,{Title = "Master Archer"		}},
			{"Grandmaster Archer"	,100	,"Given to those who are among the most profound archers."	,{Title = "Grandmaster Archer"	}},
		},

		--[[BardSkill = {
			{"Bard"				,30		,"Given to those who have skill in art of music."				,{Title = "Apprentice Bard"			}},
			{"Journeyman Bard"	,50		,"Given to those who have exceptional skill in art of music."	,{Title = "Journeyman Bard"	}},
			{"Master Bard"		,80		,"Given to those who have mastered the art of music."			,{Title = "Master Bard"		}},
			{"Grandmaster Bard"	,100	,"Given to those who are among the most profound bards."		,{Title = "Grandmaster Bard"}},
		},]]

		BashingSkill = {
			{"Maceman"					,30		,"Given to those who have skill in bashing."					,{Title = "Apprentice Maceman"				}},
			{"Journeyman Maceman"		,50		,"Given to those who have exceptional skill in bashing."		,{Title = "Journeyman Maceman"	}},
			{"Master Maceman"			,80		,"Given to those who could crush the skull of an elephant."		,{Title = "Master Maceman"		}},
			{"Grandmaster Maceman"		,100	,"Given to those who could crush the skull of a dragon."		,{Title = "Grandmaster Maceman"	}},
		},


		BeastmasterySkill = {
			{"Beastmaster"				,30		,"Given to those who can tame a beast."							,{Title = "Apprentice Beastmaster"				}},
			{"Journeyman Beastmaster"	,50		,"Given to those who are good at taming beasts."				,{Title = "Journeyman Beastmaster"	}},
			{"Master Beastmaster"		,80		,"Given to those who have mastered the art of beast taming."	,{Title = "Master Beastmaster"		}},
			{"Grandmaster Beastmaster"	,100	,"Given to those who are among the most profound beastmaster."	,{Title = "Grandmaster Beastmaster"	}},
		},

		BlockingSkill = {
			{"Defender"					,30		,"Given to those who can block blows."								,{Title = "Apprentice Defender"			}},
			{"Journeyman Defender"		,50		,"Given to those who are good at blocking blows."					,{Title = "Journeyman Defender"	}},
			{"Master Defender"			,80		,"Given to those who have mastered the art of blocking blows."		,{Title = "Master Defender"		}},
			{"Grandmaster Defender"		,100	,"Given to those who are among the most profound defenders."		,{Title = "Grandmaster Defender"}},
		},

		BrawlingSkill = {
			{"Brawler"					,30		,"Given to those who have skill in Brawler."					,{Title = "Apprentice Brawler"				}},
			{"Journeyman Brawler"		,50		,"Given to those who have exceptional skill in Brawler."		,{Title = "Journeyman Brawler"	}},
			{"Master Brawler"			,80		,"Given to those who could crush the skull of an elephant."		,{Title = "Master Brawler"		}},
			{"Grandmaster Brawler"		,100	,"Given to those who could crush the skull of a dragon."		,{Title = "Grandmaster Brawler"	}},
		},

		ChannelingSkill = {
			{"Channeler"					,30		,"Given to those who can channel magic."								,{Title = "Apprentice Channeler"				}},
			{"Journeyman Channeler"			,50		,"Given to those who are good at channeling magic."						,{Title = "Journeyman Channeler"	}},
			{"Master Channeler"				,80		,"Given to those who have mastered the art of channeling magic."		,{Title = "Master Channeler"		}},
			{"Grandmaster Channeler"		,100	,"Given to those who are the greatest sorcerers who have ever lived."	,{Title = "Grandmaster Channeler"	}},
		},

		CookingSkill = {
			{"Chef"					,30		,"Given to those who can cook."									,{Title = "Apprentice Chef"			}},
			{"Journeyman Chef"		,50		,"Given to those who are good at cooking."						,{Title = "Journeyman Chef"	}},
			{"Master Chef"			,80		,"Given to those who have mastered the art of cooking."			,{Title = "Master Chef"		}},
			{"Grandmaster Chef"		,100	,"Given to those who know everything there is about cooking."	,{Title = "Grandmaster Chef"}},
		},

		EvocationSkill = {
			{"Evoker"				,30		,"Given to those who can cast damaging spells."							,{Title = "Apprentice Evoker"			}},
			{"Journeyman Evoker"	,50		,"Given to those who are good at casting damaging spells."				,{Title = "Journeyman Evoker"	}},
			{"Master Evoker"		,80		,"Given to those who have mastered the art of damaging spells."			,{Title = "Master Evoker"		}},
			{"Grandmaster Evoker"	,100	,"Given to those who know everything there is about damaging spells."	,{Title = "Grandmaster Evoker"}},
		},

		FabricationSkill = {
			{"Tailor"					,30		,"Given to those who can spin a loom."								,{Title = "Apprentice Tailor"				}},
			{"Journeyman Tailor"		,50		,"Given to those who are good at fabrication."						,{Title = "Journeyman Tailor"	}},
			{"Master Tailor"			,80		,"Given to those who have mastered the art of fabrication."			,{Title = "Master Tailor"		}},
			{"Grandmaster Tailor"		,100	,"Given to those who know everything there is about fabrication."	,{Title = "Grandmaster Tailor"	}},
		},

		FishingSkill = {
			{"Fisherman"					,30		,"Given to those who can fish."									,{Title = "Apprentice Fisherman"				}},
			{"Journeyman Fisherman"			,50		,"Given to those who are good at the art of fishing."			,{Title = "Journeyman Fisherman"	}},
			{"Master Fisherman"				,80		,"Given to those who have mastered the art of fishing."			,{Title = "Master Fisherman"		}},
			{"Grandmaster Fisherman"		,100	,"Given to those who know everything there is about fishing."	,{Title = "Grandmaster Fisherman"	}},
		},

		HealingSkill = {
			{"Healer"				,30		,"Given to those who are gifted in healing"							,{Title = "Apprentice Healer"				}},
			{"Journeyman Healer"	,50		,"Given to those who are good at the art of healing."				,{Title = "Journeyman Healer"	}},
			{"Master Healer"		,80		,"Given to those who have mastered the art of healing."				,{Title = "Master Healer"		}},
			{"Grandmaster Healer"	,100	,"Given to those who are the greatest healers who have ever lived."	,{Title = "Grandmaster Healer"	}},
		},

		HeavyArmorSkill = {
			{"Man-at-arms"				,30		,"Given to those who can wear heavy armor."									,{Title = "Apprentice Man-at-arms"				}},
			{"Journeyman Man-at-arms"	,50		,"Given to those who can block attacks with heavy armor on."				,{Title = "Journeyman Man-at-arms"	}},
			{"Master Man-at-arms"		,80		,"Given to those who have mastered blocking attacks with heavy armor on."	,{Title = "Master Man-at-arms"		}},
			{"Grandmaster Man-at-arms"	,100	,"Given to those who are among the most profound man-at-arms."				,{Title = "Grandmaster Man-at-arms"	}},
		},

		HidingSkill = {
			{"Hider"				,30		,"Given to those who can hide."							,{Title = "Apprentice Hider"				}},
			{"Journeyman Hider"		,50		,"Given to those who are good at hiding."				,{Title = "Journeyman Hider"	}},
			{"Master Hider"			,80		,"Given to those who have mastered the hiding."			,{Title = "Master Hider"		}},
			{"Grandmaster Hider"	,100	,"Given to those who are among the most profound hider.",{Title = "Grandmaster Hider"	}},
		},

		InscriptionSkill = {
			{"Scribe"				,30		,"Given to those who knows about inscription."						,{Title = "Apprentice Scribe"				}},
			{"Journeyman Scribe"	,50		,"Given to those who are good at inscription."						,{Title = "Journeyman Scribe"	}},
			{"Master Scribe"		,80		,"Given to those who have mastered inscription."					,{Title = "Master Scribe"		}},
			{"Grandmaster Scribe"	,100	,"Given to those who know everything there is about inscription."	,{Title = "Grandmaster Scribe"	}},
		},

		LancingSkill = {
			{"Lancer"				,30		,"Given to those who can use lance."						,{Title = "Apprentice Lancer"				}},
			{"Journeyman Lancer"	,50		,"Given to those who have skill in lancing."				,{Title = "Journeyman Lancer"	}},
			{"Master Lancer"		,80		,"Given to those who have mastered the art of lancing."		,{Title = "Master Lancer"		}},
			{"Grandmaster Lancer"	,100	,"Given to those who are among the most profound lancers."	,{Title = "Grandmaster Lancer"	}},
		},

		LightArmorSkill = {
			{"Agile Defender"				,30		,"Given to those who can wear light armor."									,{Title = "Apprentice Agile Defender"				}},
			{"Journeyman Agile Defender"	,50		,"Given to those who can block attacks with light armor on."				,{Title = "Journeyman Agile Defender"	}},
			{"Master Agile Defender"		,80		,"Given to those who have mastered blocking attacks with light armor on."	,{Title = "Master Agile Defener"		}},
			{"Grandmaster Agile Defender"	,100	,"Given to those who are among the most profound agile defender."			,{Title = "Grandmaster Agile Defender"	}},
		},

		LumberjackSkill = {
			{"Lumberjack"				,30		,"Given to those who have learned to chop wood."					,{Title = "Apprentice Lumberjack"				}},
			{"Journeyman Lumberjack"	,50		,"Given to those who are good at lumberjacking."					,{Title = "Journeyman Lumberjack"	}},
			{"Master Lumberjack"		,80		,"Given to those who have mastered the art of lumberjacking."		,{Title = "Master Lumberjack"		}},
			{"Grandmaster Lumberjack"	,100	,"Given to those who know everything there is about lumberjacking."	,{Title = "Grandmaster Lumberjack"	}},
		},

		MagicAffinitySkill = {
			{"Medium"					,30		,"Given to those who can absorb the magic in the world."							,{Title = "Apprentice Medium"				}},
			{"Journeyman Medium"		,50		,"Given to those who are good at absorbing magic in the world."						,{Title = "Journeyman Medium"	}},
			{"Master Medium"			,80		,"Given to those who have mastered the ability to absorb the magic in the world."	,{Title = "Master Medium"		}},
			{"Grandmaster Medium"		,100	,"Given to those who have become one with the magic of the world."				,{Title = "Grandmaster Medium"	}},
		},

		ManifestationSkill = {
			{"Mage"					,30		,"Given to those who have learned the art of magic."		,{Title = "Apprentice Mage"			}},
			{"Journeyman Mage"		,50		,"Given to those who are good at the art of magic."			,{Title = "Journeyman Mage"	}},
			{"Master Mage"			,80		,"Given to those who have mastered the art of magic."		,{Title = "Master Mage"		}},
			{"Grandmaster Mage"		,100	,"Given to those who are among the most profound mages."	,{Title = "Grandmaster Mage"}},
		},

		--[[MarksmanshipSkill = {
			{"Marksman"					,30		,"Given to those who have learned the art of marksmanship."	,{Title = "Apprentice Marksman"			}},
			{"Journeyman Marksman"		,50		,"Given to those who are good at the art of marksmanship."	,{Title = "Journeyman Marksman"	}},
			{"Master Marksman"			,80		,"Given to those who have mastered the art of marsmanship."	,{Title = "Master Marksman"		}},
			{"Grandmaster Marksman"		,100	,"Given to those who are among the most profound marksman."	,{Title = "Grandmaster Marksman"}},
		},]]

		MeleeSkill = {
			{"Fighter"					,30		,"Given to those who have learned how to fight."							,{Title = "Apprentice Fighter"				}},
			{"Journeyman Fighter"		,50		,"Given to those who are powerful in the art of figthing."					,{Title = "Journeyman Fighter"	}},
			{"Master Fighter"			,80		,"Given to those who are among the most profound in the art of fighting."	,{Title = "Master Fighter"		}},
			{"Grandmaster Fighter"		,100	,"Given to those who are the greatest in fighting."							,{Title = "Grandmaster Fighter"	}},
		},

		MetalsmithSkill = {
			{"Metalsmith"					,30		,"Given to those who have learned metalsmithing."				,{Title = "Apprentice Metalsmith"				}},
			{"Journeyman Metalsmith"		,50		,"Given to those who are good at metalsmithing."				,{Title = "Journeyman Metalsmith"	}},
			{"Master Metalsmith"			,80		,"Given to those who have mastered metalsmithing."				,{Title = "Master Metalsmith"		}},
			{"Grandmaster Metalsmith"		,100	,"Given to those who are among the most profound metalsmiths."	,{Title = "Grandmaster Metalsmith"	}},
		},

		MiningSkill = {
			{"Miner"					,30		,"Given to those who have learned mining."					,{Title = "Apprentice Miner"				}},
			{"Journeyman Miner"			,50		,"Given to those who are good at mining."					,{Title = "Journeyman Miner"	}},
			{"Master Miner"				,80		,"Given to those who have mastered the art of mining."		,{Title = "Master Miner"		}},
			{"Grandmaster Miner"		,100	,"Given to those who know everything there is about mining.",{Title = "Grandmaster Miner"	}},
		},

		--[[MusicianshipSkill = {
			{"Musician"					,30		,"Given to those who have learned the art of music."		,{Title = "Apprentice Musician"			}},
			{"Journeyman Musician"		,50		,"Given to those who are good at the art of music."			,{Title = "Journeyman Musician"	}},
			{"Master Musician"			,80		,"Given to those who have mastered the art of music."		,{Title = "Master Musician"		}},
			{"Grandmaster Musician"		,100	,"Given to those who know everything there is about music."	,{Title = "Grandmaster Musician"}},
		},]]

		--[[NecromancySkill = {
			{"Necromancer"				,30		,"Given to those who have learned the art of necromancy."		,{Title = "Apprentice Necromancer"				}},
			{"Journeyman Necromancer"	,50		,"Given to those who are good at the art of necromancy."		,{Title = "Journeyman Necromancer"	}},
			{"Master Necromancer"		,80		,"Given to those who have mastered the art of necromancy."		,{Title = "Master Necromancer"		}},
			{"Grandmaster Necromancer"	,100	,"Given to those who are among the most profound necromancers."	,{Title = "Grandmaster Necromancer"	}},
		},]]

		PiercingSkill = {
			{"Assassin"					,30		,"Given to those who have learned how to use shortswords."					,{Title = "Apprentice Assassin"			}},
			{"Journeyman Assassin"		,50		,"Given to those who are powerful in the art of shortswords."					,{Title = "Journeyman Assassin"	}},
			{"Master Assassin"			,80		,"Given to those who are among the most profound in the art of shortswords."	,{Title = "Master Assassin"		}},
			{"Grandmaster Assassin"		,100	,"Given to those who are the greatest in shortswords."							,{Title = "Grandmaster Assassin"}},
		},

		SlashingSkill = {
			{"Swordsman"					,30		,"Given to those who have skill in slashing."				,{Title = "Apprentice Swordsman"				}},
			{"Journeyman Swordsman"			,50		,"Given to those who have skill in slashing."				,{Title = "Journeyman Swordsman"	}},
			{"Master Swordsman"				,80		,"Given to those who are among the most profound swordsmen.",{Title = "Master Swordsman"		}},
			{"Grandmaster Swordsman"		,100	,"Given to those who are among the greatest swordsmen."		,{Title = "Grandmaster Swordsman"	}},
		},

		StealthSkill = {
			{"Shadow Walker"				,30		,"Given to those who have learned the art of stealth."				,{Title = "Apprentice Shadow Walker"				}},
			{"Journeyman Shadow Walker"		,50		,"Given to those who are good at the art of stealth."				,{Title = "Journeyman Shadow Walker"	}},
			{"Master Shadow Walker"			,80		,"Given to those who have mastered the art of stealth."				,{Title = "Master Shadow Walker"		}},
			{"Grandmaster Shadow Walker"	,100	,"Given to those who are among the most profound shadow walkers."	,{Title = "Grandmaster Shadow Walker"	}},
		},

		TreasureHuntingSkill = {
			{"Treasure Hunter"				,30		,"Given to those who have learned how to treasure hunt."			,{Title = "Apprentice Treasure Hunter"				}},
			{"Journeyman Treasure Hunter"	,50		,"Given to those who are good at treasure hunting."					,{Title = "Journeyman Treasure Hunter"	}},
			{"Master Treasure Hunter"		,80		,"Given to those who have mastered the art of treasure hunt."		,{Title = "Master Treasure Hunter"		}},
			{"Grandmaster Treasure Hunter"	,100	,"Given to those who are among the most profound treasure hunters."	,{Title = "Grandmaster Treasure Hunter"	}},
		},

		WoodsmithSkill = {
			{"Carpenter"					,30		,"Given to those who have learned carpentry."				,{Title = "Apprentice Carpenter"				}},
			{"Journeyman Carpenter"			,50		,"Given to those are good at carpentry."						,{Title = "Journeyman Carpenter"	}},
			{"Master Carpenter"				,80		,"Given to those who have mastered carpentry."				,{Title = "Master Carpenter"		}},
			{"Grandmaster Carpenter"		,100	,"Given to those who are among the most profound carpentry."	,{Title = "Grandmaster Carpenter"	}},
		},
	},

	ActivityAchievements = {
		HouseBuilding = {
			{"Builder"		,1		,"Given to those who have constructed a house", {Renown = "ActivityOne"}},
		},

		Guild = {
			{"Guild Member"		,1		,"Given to those who join a guild", {Renown = "ActivityOne"}},
		},

		Dungeon = {
			{"Catacombs Explorer"		,1		,"Given to those who have opened the portal to The Catacombs", {Renown = "ActivityOne"}},
		},

		LandOwner = {
			{"Land Owner"		,1		,"Given to those who acquire a building plot", {Renown = "ActivityOne"}},
		},

		BountiesNumber = {
			{"Novice Bounty Hunter"			,1		,"Given to those who complete 1 mission from a mission dispatcher."		,{Renown = "BountyOne"}},
			{"Skilled Bounty Hunter"		,10		,"Given to those who complete 10 missions from a mission dispatcher."	,{Renown = "BountyTwo"}},
			{"Chief Bounty Hunter"			,100	,"Given to those who complete 100 missions from a mission dispatcher."	,{Renown = "BountyThree"}},
		},

		AbilityCount = {
			{"Ability Trainee"		,1		,"Given to those who unlock 1 trained ability."		,{Renown = "AbilityOne"}},
			{"Ability Scholar"		,2		,"Given to those who unlock 2 trained abilities."	,{Renown = "AbilityTwo"}},
			{"Ability Chief"		,3		,"Given to those who unlock 3 trained abilities."	,{Renown = "AbilityThree"}},
		},
	},

	--[[
	LocationAchievements = {
		["Cultist Ruins"] = {
			{"Cultist Ruins Adventure"		,1		,"Description", {Renown = "LocationOne"}},
		},

		["Wyvern's Rest"] = {
			{"Wyvern's Rest Adventurer"		,1		,"Description", {Renown = "LocationOne"}},
		},

		["Misty Caverns"] = {
			{"Misty Caverns Excavator"		,1		,"Description", {Renown = "LocationOne"}},
		},

		["Belhaven"] = {
			{"Belhaven Visitor"		,1		,"Description", {Renown = "LocationOne"}},
		},

		["Trinit"] = {
			{"Trinit Visitor"		,1		,"Description", {Renown = "LocationOne"}},
		},

		["Breca Mines"] = {
			{"Breca Mines Excavator"		,1		,"Description", {Renown = "LocationOne"}},
		},

		["Pirate's Grotto"] = {
			{"Pirate's Grotto Adventurer"		,1		,"Description", {Renown = "LocationOne"}},
		},

		["Gazer Island"] = {
			{"Gazer Island Adventurer"		,1		,"Description", {Renown = "LocationOne"}},
		},

		["Helm Mines"] = {
			{"Helm Mines Excavator"		,1		,"Description", {Renown = "LocationOne"}},
		},
	},]]
	
	ExecutionerAchievements = {
		Undead = {
			{"Undead Slayer"		,10		,"Use an Undead Executioner weapon to kill 10 Undead."	,{Renown = "ExecutionerOne"}},
			{"Undead Executioner"	,100	,"Use an Undead Executioner weapon to kill 100 Undead."	,{Renown = "ExecutionerTwo"}},
		},

		Dragon = {
			{"Dragon Slayer"		,10		,"Use a Dragon Executioner weapon to kill 10 Dragons."	,{Renown = "ExecutionerOne"}},
			{"Dragon Executioner"	,100	,"Use a Dragon Executioner weapon to kill 100 Dragons."	,{Renown = "ExecutionerTwo"}},
		},

		Humanoid = {
			{"Humanoid Slayer"		,10		,"Use a Humanoid Executioner weapon to kill 10 Humanoids."	,{Renown = "ExecutionerOne"}},
			{"Humanoid Executioner"	,100	,"Use a Humanoid Executioner weapon to kill 100 Humanoids."	,{Renown = "ExecutionerTwo"}},
		},

		Reptile = {
			{"Reptile Slayer"		,10		,"Use a Reptile Executioner weapon to kill 10 Reptiles."	,{Renown = "ExecutionerOne"}},
			{"Reptile Executioner"	,100	,"Use a Reptile Executioner weapon to kill 100 Reptiles."	,{Renown = "ExecutionerTwo"}},
		},

		Ork = {
			{"Ork Slayer"		,10		,"Use an Ork Executioner weapon to kill 10 Orks."	,{Renown = "ExecutionerOne"}},
			{"Ork Executioner"	,100	,"Use an Ork Executioner weapon to kill 100 Orks."	,{Renown = "ExecutionerTwo"}},
		},

		Arachnid = {
			{"Arachnid Slayer"		,10		,"Use an Arachnid Executioner weapon to kill 10 Arachnids."		,{Renown = "ExecutionerOne"}},
			{"Arachnid Executioner"	,100	,"Use an Arachnid Executioner weapon to kill 100 Arachnids."	,{Renown = "ExecutionerTwo"}},
		},

		Animal = {
			{"Animal Slayer"		,10		,"Use an Animal Executioner weapon to kill 10 Animals."	,{Renown = "ExecutionerOne"}},
			{"Animal Executioner"	,100	,"Use an Animal Executioner weapon to kill 100 Animals.",{Renown = "ExecutionerTwo"}},
		},

		Demon = {
			{"Demon Slayer"			,10		,"Use a Demon Executioner weapon to kill 10 Demons."	,{Renown = "ExecutionerOne"}},
			{"Demon Executioner"	,100	,"Use a Demon Executioner weapon to kill 100 Demons."	,{Renown = "ExecutionerTwo"}},
		},

		Giant = {
			{"Giant Slayer"			,10		,"Use a Giant Executioner weapon to kill 10 Giants."	,{Renown = "ExecutionerOne"}},
			{"Giant Executioner"	,100	,"Use a Giant Executioner weapon to kill 100 Giants."	,{Renown = "ExecutionerTwo"}},
		},

		--[[
		Ent = {
			{"Vegetation Slayer"		,10		,"Use a Vegetation Executioner weapon to kill 10 Giants."	,{Renown = "ExecutionerOne"}},
			{"Vegetation Executioner"	,100	,"Use a Vegetation Executioner weapon to kill 100 Giants."	,{Renown = "ExecutionerTwo"}},
		},]]
	},

	PvPAchievements = {
		PvP = {
			VersusAny = {
				{"The Warrior"			,25		,"Given to those who have slain 25 or more players."	,{Renown = "PvPOne"}},
				{"The Champion"			,50		,"Given to those who have slain 50 or more players."	,{Renown = "PvPTwo"}},
				{"The Conquerer"		,100	,"Given to those who have slain 100 or more players."	,{Renown = "PvPThree"}},
			},

			VersusRed = {
				{"Judge and Jury"	,25		,"Given to those who have slain 25 or more Outcast players."	,{Renown = "PvPOne"}},
				{"Adjudicator"		,50		,"Given to those who have slain 50 or more Outcast players."	,{Renown = "PvPTwo"}},
				{"The Hero"			,100	,"Given to those who have slain 100 or more Outcast players."	,{Renown = "PvPThree"}},
			},

			VersusBlue = {
				{"Murderer"		,25		,"Given to those who have slain 25 or more Trustworthy players."	,{Renown = "PvPOne"}},
				{"Slaughterer"	,50		,"Given to those who have slain 50 or more Trustworthy players."	,{Renown = "PvPTwo"}},
				{"Serial Killer",100	,"Given to those who have slain 100 or more Trustworthy players."	,{Renown = "PvPThree"}},
			},
		},

		Karma = {
			KarmaGood = {
				{"The Honest"			,5000		,"Given to those who have gained a reputation for making the world a better place."	,{Title = "The Honest"}},
				{"The Trustworthy"		,10000		,"Given to those who's kindness and heroism is known throughout the land."			,{Title = "The Trustworthy"}},
			},

			--Karma for these achievements are negative. Sign gets changed upon achievement check, so values here should be positive
			KarmaBad = {
				{"The Scoundrel"		,5000		,"Given to those who are known to do harm to others."						,{Title = "The Scoundrel"}},
				{"The Outcast"			,10000		,"Given to those who's reputation as a murderer has spread far and wide."	,{Title = "The Outcast"}},
			},
		},

		Allegiance = {
			FireAllegiance = {
				{"Fire Acolyte"		,0.2		,"Given to those who have 20 favor with the fire god.", {Title = "Fire Acolyte"		}},
				{"Touchbearer"		,0.5		,"Given to those who have 50 favor with the fire god.", {Title = "Touchbearer"		}},
				{"Ember Sentinel"	,0.8		,"Given to those who have 80 favor with the fire god.", {Title = "Ember Sentinel"	}},
				{"Adrent Flame"		,0.95		,"Given to those who have 95 favor with the fire god.", {Title = "Adrent Flame"		}},
				{"Overseer of Fire"	,0.99		,"Given to those who have 99 favor with the fire god.", {Title = "Overseer of Fire"	}},
			},

			WaterAllegiance = {
				{"Water Servant"		,0.2		,"Given to those who have 20 favor with the water god.", {Title = "Water Servant"		}},
				{"Water Worshipper"		,0.5		,"Given to those who have 50 favor with the water god.", {Title = "Water Worshipper"	}},
				{"Elder Mystic"			,0.8		,"Given to those who have 80 favor with the water god.", {Title = "Elder Mystic"		}},
				{"Rain Bringer"			,0.95		,"Given to those who have 95 favor with the water god.", {Title = "Rain Bringer"		}},
				{"Lord of the Storm"	,0.99		,"Given to those who have 99 favor with the water god.", {Title = "Lord of the Storm"	}},
			},
		},
	},

	BossKillsAchievements = {
		Death = {
			{"Death Slayer"					,1		,"Given to those who have killed Death."				,{Renown = "BossKillsOne"}},
		},

		AncientDragon = {
			{"Ancient Dragon Slayer"		,1		,"Given to those who have killed Vazguhn the Ancient."	,{Renown = "BossKillsOne"}},
		},

		AncientTreeLord = {
			{"Ancient Tree Lord Slayer"		,1		,"Given to those who have killed Lord Barkas."			,{Renown = "BossKillsOne"}},
		},

		Cultist = {
			{"Cultist Emancipator"			,1		,"Given to those who have killed Cultist King Alexis."	,{Renown = "BossKillsOne"}},
		},

		Champion = {
			{"Champion Slayer"			,1		,"Given to those who have killed 1 Champion foe"			,{Renown = "BossKillsOne"}},
		},
	},

	CraftingAchievements = {
		CraftingOrder = {
			{"Novice Crafter"		,1			,"Given to those who have completed 1 crafting order."		,{Renown = "CraftingOne"}},
			{"Skilled Crafter"		,10			,"Given to those who have completed 10 crafting order."		,{Renown = "CraftingOne"}},
			{"Chief Crafter"		,100		,"Given to those who have completed 100 crafthing order."	,{Renown = "CraftingOne"}},
		},

		MetalsmithSkillRecipe = {
			{"Metalsmith Scholar"	,1		,"Given to those who have learned every Metalsmithing recipe."	,{Renown = "CraftingAdvancedOne"}},
		},

		FabricationSkillRecipe = {
			{"Fabrication Scholar"	,1		,"Given to those who have learned every Fabrication recipe."	,{Renown = "CraftingAdvancedOne"}},
		},

		WoodsmithSkillRecipe = {
			{"Carpentry Scholar"	,1		,"Given to those who have learned every Carpentry recipe."	,{Renown = "CraftingAdvancedOne"}},
		},
	},

	FishingAchievements = {
		FishingNumber = {
			{"Angler"			,1			,"Given to those who catch 1 fish."		,{Renown = "FishingOne"}},
			{"Skilled Angler"	,100		,"Given to those who catch 100 fish."	,{Renown = "FishingTwo"}},
			{"Chief Angler"		,1000		,"Given to those who catch 1000 fish."	,{Renown = "FishingThree"}},
		},

		AetherFish = {
			{"Golden Fisherman"		,1		,"Given to those who catch golden aether fish."	,{Renown = "FishingAdvancedOne"}},
		},

		FishingSize = {
			{"Novice Fisherman"		,1		,"Given to those who catch a large fish."		,{Renown = "FishingOne"}},
			{"Skilled Fisherman"	,2		,"Given to those who catch a huge fish."		,{Renown = "FishingTwo"}},
			{"Chief Fisherman"		,3		,"Given to those who catch a gigantic fish."	,{Renown = "FishingOne"}},
			{"Legendary Fisherman"	,4		,"Given to those who catch a legendary fish."	,{Renown = "FishingOne"}},
		},

		FishingTreasure = {
			{"Sunken Treasure Hunter"			,1		,"Given to those who fish up 1 sunken treasure chests."			,{Renown = "FishingOne"}},
			{"Skilled Sunken Treasure Hunter"	,10		,"Given to those who fish up 10 sunken treasure chests."		,{Renown = "FishingTwo"}},
			{"Chief Sunken Trasure Hunter"		,100	,"Given to those who fish up 100 sunken treasure chests."		,{Renown = "FishingOne"}},
		},
	},

	RenownAchievements = {
		RenownAmount = {
			{"The Honorable"	,1000		,"Given to those who have gained 1000 renown.", 	{Title = "The Honorable"	}},
			{"The Glorius"		,5000		,"Given to those who have gained 5000 renown.", 	{Title = "The Glorius"		}},
			{"The Exalted"		,10000		,"Given to those who have gained 10000 renown.", 	{Title = "The Exalted"		}},
		},
	},

	TreasureHuntingAchievements = {
		TreasureNumber = {
			{"Novice Treasure Hunter"		,1		,"Given to those who dig up 1 treasure chest.", 	{Renown = "TreasureHuntingOne"	}},
			{"Skilled Treasure Hunter"		,10		,"Given to those who dig up 10 treasure chest.", 	{Renown = "TreasureHuntingTwo"	}},
			{"Chief Treasure Hunter"		,100	,"Given to those who dig up 100 treasure chest.", 	{Renown = "TreasureHuntingThree"}},
		},

		["Fancy Map"] = {
			{"Fancy Treasure Hunter"			,1		,"Given to those who dig up 1 treasure chest using a fancy map.", 	{Renown = "TreasureHuntingAdvancedOne"	}},
			{"Skilled Fancy Treasure Hunter"	,10		,"Given to those who dig up 10 treasure chest using a fancy map.", 	{Renown = "TreasureHuntingAdvancedTwo"	}},
			{"Chief Fancy Treasure Hunter"		,100	,"Given to those who dig up 100 treasure chest using a fancy map.", {Renown = "TreasureHuntingAdvancedThree"}},
		},

		DecipherPrecise = {
			{"Cryptographer"		,1		,"Given to those who decipher a precise map.", {Renown = "TreasureHuntingAdvancedOne"}},
		},
	},

	OtherAchievements = {
	},
}

AchievementsReward = {
	Renown = {
		ActivityOne = 40,
		
		LocationOne = 100,

		ExecutionerOne = 40,
		ExecutionerTwo = 100,

		PvPOne = 20,
		PvPTwo = 100,
		PvPThree = 500,

		BossKillsOne = 40,

		AbilityOne = 40,
		AbilityTwo = 100,
		AbilityThree = 200,

		AbilityAdvancedOne = 100,
		AbilityAdvancedTwo = 500,

		CraftingOne = 40,
		CraftingTwo = 100,
		CraftingThree = 200,

		CraftingAdvancedOne = 500,

		BountiesOne = 20,
		BountiesTwo = 50,
		BountiesThree = 100,

		TreasureHuntingOne = 10,
		TreasureHuntingTwo = 40,
		TreasureHuntingThree = 80,

		TreasureHuntingAdvancedOne = 100,
		TreasureHuntingAdvancedTwo = 200,
		TreasureHuntingAdvancedThree = 500,

		FishingOne = 10,
		FishingTwo = 40,
		FishingThree = 100,

		FishingAdvancedOne = 100,
		FishingAdvancedTwo = 200,
		FishingAdvancedThree = 300,

		BountyOne = 10,
		BountyTwo = 40,
		BountyThree = 100,
	},
}