Factions = 
{	
	--Cultists
	{
	Name = "Cult of the Star Dweller",
	InternalName = "Cultists",
	Zones = {"CultistRuins"},
	AcceptanceLevel = 10,
	MinFriendlyLevel = 6,
	MinSpecialTitleLevel = 30,
	MinAcceptanceLevel = 10,
	MinFaction = -50,
	MaxFaction = 50,
	},

	--Villagers
	{
	Name = "Republic of Petra",
	InternalName = "Villagers",
	Zones = {"Town"},
	AcceptanceLevel = 10,
	MinFriendlyLevel = -30,
	MinSpecialTitleLevel = 30,
	MinAcceptanceLevel = 10,
	MinFaction = -50,
	MaxFaction = 50,
	},

	--Rebels
	{
	Name = "Southern Rim Rebels",
	InternalName = "Rebels",
	Zones = {"RebelEncampment"},
	AcceptanceLevel = 10,
	MinFriendlyLevel = 0,
	MinSpecialTitleLevel = 30,
	MinAcceptanceLevel = 10,
	MinFaction = -50,
	MaxFaction = 50,
	},

	{
	--Bandits
	Name = "Bandit Guild",
	InternalName = "Bandits",
	Zones = {},
	AcceptanceLevel = 10,
	MinFriendlyLevel = 10,
	MinSpecialTitleLevel = 20,
	MinAcceptanceLevel = 10,
	MinFaction = -50,
	MaxFaction = 50,
	},
	{
	--Wayward
	Name = "Followers of the Wayun",
	InternalName = "Wayun",
	Zones = {},
	AcceptanceLevel = 10,
	MinFriendlyLevel = 0,
	MinSpecialTitleLevel = 20,
	MinAcceptanceLevel = 10,
	MinFaction = -50,
	MaxFaction = 50,
	},
	--Falk's Gang
	{
	Name = "Falk's Gang",
	InternalName = "Falk",
	Zones = {},
	AcceptanceLevel = 35,
	MinFriendlyLevel = 10,
	MinSpecialTitleLevel = 35,
	MinAcceptanceLevel = 20,
	MinFaction = -50,
	MaxFaction = 50,
	},
	--Falk's Gang
	{
	Name = "Legions of the Void",
	InternalName = "UndeadGraveyard",
	Zones = {},
	AcceptanceLevel = 35,
	MinFriendlyLevel = 10,
	MinSpecialTitleLevel = 45,
	MinAcceptanceLevel = 20,
	MinFaction = -50,
	MaxFaction = 50,
	},
	--Falk's Gang
	{
	Name = "Clan of the Red Sun",
	InternalName = "Nomads",
	Zones = {},
	AcceptanceLevel = 35,
	MinFriendlyLevel = 10,
	MinSpecialTitleLevel = 45,
	MinAcceptanceLevel = 20,
	MinFaction = -50,
	MaxFaction = 50,
	},
	{
	Name = "Brotherhood of Tethys",
	InternalName = "Crusaders",
	Zones = {},
	AcceptanceLevel = 10,
	MinFriendlyLevel = -30,
	MinSpecialTitleLevel = 30,
	MinAcceptanceLevel = 10,
	MinFaction = -50,
	MaxFaction = 50,
	},
}

--Patron gods for player guilds
PlayerGuildFactions = {
	Water = 
	{		
		Icon = "WaterFactionSymbolLarge",
		NameColor = "[2E9AF2]",
		PatronGodName = "[2E9AF2]Tethys[-]",
		PatronGodFullName = "[2E9AF2]Tethys the Water Goddess[-]",
		ChooseDescription = "[$2697]",
		Description = "[$2698]",
		FriendlyWith = {
			--"Strangers","Neutral"
			"Neutral"
		},
		HostileWith = {
			"Fire"
		},
		Enabled = true,
	},
	Fire = 
	{		
		Icon = "FireFactionSymbolLarge",
		PatronGodName = "[F72A2A]Pyros[-]",
		NameColor = "[F72A2A]",
		PatronGodFullName = "[F72A2A]Pyros the Fire God[-]",
		ChooseDescription = "[$2699]",
		Description = "[$2700]",
		FriendlyWith = {
			--"Strangers","Neutral"
			"Neutral",
		},
		HostileWith = {
			"Water",
		},
		Enabled = true,
	},
	Strangers = 
	{		
		Icon = "",
		NameColor = "[B658F5]",
		PatronGodName = "[B658F5]Strangers[-]",
		PatronGodFullName = "[B658F5]The Strangers[-]",
		ChooseDescription = "[$2701]",
		Description = "[$2702]",
		FriendlyWith = {
			"Strangers","Fire","Water",
		},
		HostileWith = {
		},
		Enabled = false,
	},
	--DFB TODO: Other gods.
}
