ServerSettings.CharacterCreation = {	
	--ShouldSelectUniverse = false,
	--StartingMap = "TestMap",
	--StartingLocations = { 
	--	{ Name = "Test Map", MapLocation = "Spawn" },
	--}

	ShouldSelectUniverse = true,
	StartingMap = "NewCelador",
	StartingLocations = { 
		{ Name = "Eldeir Village", Subregion = "UpperPlains", MapLocation = "Upper Plains: Eldeir Village Spawn", Description="Eldeir Village is located in the resource rich Upper Plains of Celador. Eldeir is known for its flourishing artisan community and bustling market place." },
		{ Name = "Valus", Subregion = "SouthernHills", MapLocation = "Southern Hills: Valus Spawn", Description="The City of Valus is home to some of the most wealthy nobles in all of Celador. Valus has some of the finest merchants and traders come there from the far reaches of Celador to peddle their wares." },
		{ Name = "Helm", Subregion = "EasternFrontier", MapLocation = "Eastern Frontier: Helm Spawn", Description="Helm is a hotspot for miners and blacksmiths due to it's proximity of the nearby mines." },
	},

	AlternateStartingLocations = {
		{ Name = "Pyros' Landing", Subregion = "SouthernRim", MapLocation = "Southern Rim: Pyros Spawn", Description="Pyros' Landing is a beautiful city located on the tip of the Southern Rim of Celador." },
		{ Name = "Oasis Outpost", Subregion = "BarrenLands", MapLocation = "Barren Lands: Oasis", Description="The neutral outpost in the Barren Lands. Beware this is located in a Wilderness area." },
		{ Name = "Black Forest Outpost", Subregion = "SouthernHills", MapLocation = "Black Forest: Outpost", Description="The neutral outpost in the Black Forest. Beware this is located in a Wilderness area." },
	},

	MaxStartingSkillValue = 30,
	StartingSkillCap = 100,
}