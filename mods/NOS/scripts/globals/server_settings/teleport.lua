
-- TODO: OPTIMIZE: Have each gatekeeper store in the ObjVar("Destinations") an array of destinations via LuaTable (array) instead of each entire table

ServerSettings.Teleport = {
	Destination = {
		PyrosLanding = {
			DisplayName="Pyros Landing",
			Price=1000,
			World="NewCelador",
			--Destination=Loc(-2650.23,0,-2074.61), -- inside tower
			Destination=Loc(-2649.25,0,-2077.82),
			DestFacing=163,
			Subregion="SouthernRim"
		},
		EldeirVillage = {
			DisplayName="Eldeir Village",
			Price=1000,
			World="NewCelador",
			--Destination=Loc(256.71,0,797.02),--in tower
			Destination=Loc(259.77,0,797.04),
			DestFacing=91,
			Subregion="UpperPlains"
		},
		Crossroads = {
			DisplayName="Crossroads",
			Price=1000,
			World="NewCelador",
			--Destination=Loc(-660.16,0,-1601.23), --in tower
			Destination=Loc(-659.07,0,-1604.55),
			DestFacing=170,
			Subregion="SouthernRim"
		},
		Helm = {
			DisplayName="Helm",
			Price=1000,
			World="NewCelador",
			--Destination=Loc(2452.12,0,630.44),--in tower
			Destination=Loc(2452.31,0,627.41),
			DestFacing=180,
			Subregion="EasternFrontier"
		},
		Valus = {
			DisplayName="Valus",
			Price=1000,
			World="NewCelador",
			--Destination=Loc(986.30,0,-1274.96), -- inside tower
			Destination=Loc(987.39,0,-1277.97),
			DestFacing=165,
			Subregion="SouthernHills"
		},
		BlackForest = {
			DisplayName="Black Forest Outpost",
			Price=1000,
			World="NewCelador",
			--Destination=Loc(1834.29,0,-367.49), -- inside tower
			Destination=Loc(1835.83,0,-370.55),
			DestFacing=154,
			Subregion="BlackForest"
		},
		Oasis = {
			DisplayName="Oasis",
			Price=1000,
			World="NewCelador",
			--Destination=Loc(-2109.76,0,-681.27), -- inside tower
			Destination=Loc(-2109.76,0,-684.92),
			DestFacing=180,
			Subregion="BarrenLands"
		},
		CatacombsEntrance = {
			DisplayName="Catacombs",
			--Price=1000,
			World="NewCelador",
			Destination=Loc(945.42,0,-2141.51),
			DestFacing=180,
			Subregion="SouthernHills"
		}
	},

	NoEntryUserPortal = 
	{
		"Subregion-BarrenLands",
		"Subregion-BlackForest",
		"Arena"
	}
}