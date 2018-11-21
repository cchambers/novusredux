MapLocations = 
{ 
	Catacombs = {
		["Hub"] = Loc(-11,0,-33),
		["Level 1 Entrance"] = Loc(195,0,-35),
		["Level 2 Entrance"] = Loc(-30,0,-176),
		["Cerberus Room"] = Loc(53.7,0,-58.63),
		["Death Lair"] = Loc(190,0,-175),
	},
	TwoTowers = {
		["Spawn"] = Loc(-22,0,-34),
	},
	TestMap = {
		["Spawn"] = Loc(0,0,0),
	},
	Limbo = {
		["Center"] = Loc(0,0,0),
	},
	Pestilence = {
		["Entrance"] = Loc(195,0,-35),
	},
	Deception = {
		["Entrance"] = Loc(195,0,-35),
	},
	Contempt = {
		["Entrance"] = Loc(195,0,-35),
	},
	NewCelador = {			
		["Upper Plains: Graveyard"] = Loc(408,0,981),		
		["Upper Plains: Eldeir Village Spawn"] = Loc(291,0,892),		
		["Upper Plains: Sewer Entrance"] = Loc(249,0,869),
		
		["Southern Hills: Graveyard"] = Loc(749.9,0,-1272),
		["Southern Hills: Valus Spawn"] = Loc(878,0,-1116),
		["Southern Hills: Sewer Entrance"] = Loc(828.15,0,-1122.03),
		["Southern Hills: Catacombs Portal"] = Loc(257.98,0,-1334.62),
		["Southern Hills: Belhaven"] = Loc(-34.18,0,-1835.83),

		-- DAB TODO: Add for magical guide
		--["Southern Hills: Sewer Entrance"] = Loc(249,0,869),		
		
		["Frozen Tundra: 1"] = Loc(710,0,2161),
		["Outlands: 1"] = Loc(-1473,0,75),
		["Outlands: Red"] = Loc(-1587,0,669),

		["Barren Lands: Oasis"] = Loc(-2280,0,-806.5),

		["Black Forest: Outpost"] = Loc(2146,0,-403),

		["Southern Rim: Teleporter"] = Loc(-1323,0,-1844),
		["Southern Rim: Pyros Spawn"] = Loc(-2798,0,-2339.7),
		["Southern Rim: Graveyard"] = Loc(-2910.85,0,-2150.5),
		["Southern Rim: Sewer Entrance"] = Loc(-2757.5,0,-2191.4),

		["Eastern Frontier: Helm Spawn"] = Loc(2947.3,0,848.14),
		["Eastern Frontier: Graveyard"] = Loc(2855,0,1162.6),
		["Eastern Frontier: Sewer Entrance"] = Loc(2801.9,0,733.9),

		["Eldeir Sewer: Dungeon"] = Loc(2240,0,1734),
	},
}

CeladorData = 
{
	MayorLocations = { 
	    { Name = "Carpenter", Loc = Loc(306.5,0.0,900.5), Facing = 52 },    
	    { Name = "Fountain", Loc = Loc(305.0,0.0,895.84), Facing = 52 },
	    { Name = "Alchemist",  Loc = Loc(296.8,0.0,906.4), Facing = 349 ,Type = "Merchant"},
	    { Name = "AlchemistCrate",  Loc = Loc(300.8,0.0,906.7), Facing = 349 ,Type = "Merchant"},
	    { Name = "Tailor", Loc = Loc(289.3,0.0,893.2), Facing = 242 ,Type = "Merchant"},
	    { Name = "GeneralStore", Loc = Loc(294.5,0.0,880.0), Facing = 166 ,Type = "Merchant"},
	    { Name = "GeneralStoreBoxes", Loc = Loc(293.5,0.0,878.77), Facing = 150 ,Type = "Merchant"},
	    { Name = "VillageWell", Loc = Loc(307.5,0.0,875.4), Facing = 222 },    
	},
	--DFB TODO: Restore Monoliths for another quest.
	MonolithSpawnLocations = {
		Loc(-174.13, 0.3753853, 74.57),
		Loc(-177.93, 0.3753853, 75.85),
		Loc(-180.61, 0.3753853, 78.7),
		Loc(-182.67, 0.7990913, 86.38),
		Loc(-178.52, 0.3753853, 92.65),
		Loc(-168.57, 0.3753853, 92.37),
		Loc(-166.31, 0.3753853, 90.94),
		Loc(-164.8, 0.3753853, 88.26),
		Loc(-165.2, 0.3753853, 84.92),
		Loc(-172.14, 0.3753853, 73.94),
	},
	MineLocations = 
	{ 
		{Loc = Loc(-338.3,0,1161.4), Facing = 204 },
		{Loc = Loc(-342.1,0,1179.7), Facing = 350 },
		--[[{Loc = Loc( -343.5,0.0,1182.5), Facing = 50 },
		{Loc = Loc( -338,0.0,1176), Facing = 180 },
		{Loc = Loc( -339,0.0,1160), Facing = 212 },
		{Loc = Loc( -334,0.0,1155), Facing = 240 },
		{Loc = Loc( -331,0.0,1158), Facing = 79 },
		{Loc = Loc( -327,0.0,1164), Facing = 157 },
		{Loc = Loc( -318.6,0.0,1149), Facing = 157 },
		{Loc = Loc( -314,0.0,1146), Facing = 300 },
		{Loc = Loc( -302.4,0.0,1148.8), Facing = 76 },
		{Loc = Loc( -298,0.0,1152), Facing = 230 },
		{Loc = Loc( -297,0.0,1144), Facing = 316 },
		{Loc = Loc( -298.9,0.0,1138.2), Facing = 213 },
		{Loc = Loc( -303.5,0.0,1141.4), Facing = 213 },
		{Loc = Loc( -306,0.0,1142), Facing = 160 },
		{Loc = Loc( -300.7,0.0,1153), Facing = 176 },
		{Loc = Loc( -297.3,0.0,1165), Facing = 72 },
		{Loc = Loc( -296,0.0,1158), Facing = 72 },
		{Loc = Loc( -291,0.0,1156), Facing = 322 },
		{Loc = Loc( -303.8,0.0,1172.6), Facing = 90 },
		{Loc = Loc( -295,0.0,1170), Facing = 90 },
		{Loc = Loc( -304,0.0,1184), Facing = 90 },
		{Loc = Loc( -304,0.0,1189), Facing = 0 },
		{Loc = Loc( -307.3,0.0,1192.8), Facing = 60 },
		{Loc = Loc( -309,0.0,1198), Facing = 90 },
		{Loc = Loc( -309,0.0,1202), Facing = 90 },
		{Loc = Loc( -329,0.0,1195), Facing = 270 },
		{Loc = Loc( -322.3,0.0,1180.1), Facing = 200 },
		{Loc = Loc( -333,0.0,1193), Facing = 270 },]]
	},
	CeladorLocations = 
	{ 
		{ Name = "Carpenter", Loc = Loc(306.5,0.0,899.9), Facing = 52 },
		{ Name = "Inn1", Loc = Loc(241.1,0.0,865.9), Facing = 166 ,Type = "Merchant"},
		{ Name = "Inn2", Loc = Loc(242.9,0.0,864.9), Facing = 234 ,Type = "Merchant"},
		{ Name = "Inn3", Loc = Loc(242.8,0.0,874.7), Facing = 356 ,Type = "Merchant"},
		{ Name = "Inn4", Loc = Loc(244.4,0.0,874.8), Facing = 356 ,Type = "Merchant"},
		{ Name = "Inn5", Loc = Loc(242.3,0.0,873.4), Facing = 273 ,Type = "Merchant"},
		{ Name = "Inn6", Loc = Loc(244.3,0.0,872.5999999999999), Facing = 222 ,Type = "Merchant"},
		{ Name = "Fountain", Loc = Loc(305.0,0.0,894.56), Facing = 52 },
		{ Name = "Alchemist",  Loc = Loc(296.8,0.0,903), Facing = 349 ,Type = "Merchant"},
		{ Name = "AlchemistCrate",  Loc = Loc(300.8,0.0,902.6999999999999), Facing = 349 ,Type = "Merchant"},
		{ Name = "Tailor", Loc = Loc(289.3,0.0,893.2), Facing = 242 ,Type = "Merchant"},
		{ Name = "GeneralStore", Loc = Loc(298.5,0.0,882.4), Facing = 166 ,Type = "Merchant"},
		{ Name = "GeneralStoreBoxes", Loc = Loc(299.5,0.0,880.4), Facing = 150 ,Type = "Merchant"},
		{ Name = "VillageWell", Loc = Loc(309.5,0.0,876), Facing = 222 },
		{ Name = "Blacksmith1", Loc = Loc(261.2,0.0,925.4), Facing = 33 ,Type = "Merchant"},
		{ Name = "Blacksmith2", Loc = Loc(263.2,0.0,925.3), Facing = 342,Type = "Merchant" },
		{ Name = "Petra", Loc = Loc(288.2,0.0,952.3), Facing = 270 },
		{ Name = "Petra", Loc = Loc(353.2,0.0,903.3), Facing = 340 },
	},
}

SubregionDisplayNames = 
{
	UpperPlains = "Upper Plains",
	BarrenLands = "Barren Lands",
	SewerDungeon = "Eldeir Sewers",
	BlackForest = "Black Forest",
	EasternFrontier = "Eastern Frontier",
	SouthernRim = "Southern Rim",
	SouthernHills = "Southern Hills"
}

--Used for RHireling map markers
PointsOfInterest = 
{
	--Eastern Frontier
		["Mer Beach"] = Loc(2200.18,0,1362.32),
		["Destroyed Town"] = Loc(1781.20,0,973.24),
		["Lich Area"] = Loc(2893.38,0,112.26),
		["Helm Graveyard"] = Loc(2854.61,0,1161.73),
	--UpperPlains
		["Haunted Ruins"] = Loc(52.40178,0,78.06),
		["Dark Web Wood"] = Loc(568.6567,0,288.4), 
		["Abandoned Shrine"] = Loc(1456.41,0,1170.65),
		["Haunted Ruins"] = Loc(52.40178,0,78.06),
		["Giant Steppes"] = Loc(1041,0,717),
		["Eldeir Graveyard"] = Loc(407,0,980),
	--SouthernRim
		["Orc Camp"] = Loc(-2442,0,-2239),
		["Wolves Den"] = Loc(-350,0,-959),
		["Waterfall Cave"] = Loc(167,0,-644),
		["Pyros Graveyard"] = Loc(-2945, 0, -2139),
	--SouthernHills
		["Breca Mines"] = Loc(562, 0, -1341),
		["Lich Ruins"] = Loc(945,0,-2179),
		["Upper Valus Cemetary"] = Loc(299,0,-1354),
		["Valus Cemetary Peak"] = Loc(302,0,-1307),
		["Lower Valus Cemetary"] = Loc(201,0,-1354),
	--BlackForest
		["Harpy Nests"] = Loc(1432,0,-533),
		["Northern Mushroom Grove"] = Loc(1700,0,-158),
		["Southern Mushroom Grove"] = Loc(1700,0,-158),
		["Troll Den"] = Loc(1303,0,334),
		["Eastern Troll Den"] = Loc(2300,0,6.9),
		["Spider Nest"] = Loc(2908,0,-1173),
	--BarrenLands
		["Gazer Isle"] = Loc(-1110,0,-1410),
		["Mahjo Lake"] = Loc(-2641.187,0,-1372.708),
		["Scorched Print Mesa"] = Loc(-1772.5,0,-423.8),
		["Oasis Graveyard"] = Loc(-2230,0,-871)
}
