Events = {
	auction = {
		{ Time=TimeSpan.FromSeconds(0), Actor = "Serenia", Event = "PlayAnimation", Args = { Anim="idle" } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Serenia", Event = "Heal" },
		{ Time=TimeSpan.FromSeconds(0), Actor = "Serenia", Event = "SetPos", Args = { Pos = Loc(-225.83,0,719.70) } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Serenia", Event = "SitChair", Args = { ChairObj = GameObj(70991) } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Marcos", Event = "SetPos", Args = { Pos = Loc(-223.73,0,719.27), Facing = 271 } },		
		{ Time=TimeSpan.FromSeconds(0), Actor = "Ezekiel", Event = "ExitCombat" },		
		{ Time=TimeSpan.FromSeconds(0), Actor = "Ezekiel", Event = "SetPos", Args = { Pos = Loc(-222.90, 0, 711.48), Facing = 92 } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Ezekiel", Event = "Resurrect"},
		{ Time=TimeSpan.FromSeconds(0), Actor = "Ezekiel", Event = "SetHP", Args = { Amount = 10 }},
		{ Time=TimeSpan.FromSeconds(0), Actor = "Ezekiel", Event = "PrestigeAbility", Args = { Class = "Skills", Name = "Hide" } },
		{ Time=TimeSpan.FromSeconds(0), Actor = "Theos", Event = "SetPos", Args = { Pos = Loc(-216.27,0,711.34), Facing = 172 } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Theos", Event = "ExitCombat" },	
	 
		{ Time=TimeSpan.FromSeconds(1), Actor = "Marcos", Event = "PlayAnimation", Args = { Anim="transaction" } },	
		{ Time=TimeSpan.FromSeconds(3), Actor = "Serenia", Event = "Stand", Args = { } },	
		{ Time=TimeSpan.FromSeconds(4), Actor = "Serenia", Event = "PathTo", Args = { Pos = Loc(-225.63,0,721.39)} },		
		{ Time=TimeSpan.FromSeconds(8), Actor = "Marcos", Event = "SetPos", Args = { Facing = 5 } },		
		{ Time=TimeSpan.FromSeconds(5), Actor = "Serenia", Event = "PathTo", Args = { Pos = Loc(-221.32,0,718.48)} },	
		{ Time=TimeSpan.FromSeconds(8), Actor = "Serenia", Event = "PathTo", Args = { Pos = Loc(-218.15,0,714.26)} },	
		{ Time=TimeSpan.FromSeconds(10), Actor = "Marcos", Event = "MoveTo", Args = { Pos = Loc(-219.86,0,719.8) } },		
		{ Time=TimeSpan.FromSeconds(16), Actor = "Serenia", Event = "UseObject", Args = { Target = GameObj(71024), UseType="Open/Close" } },	
		{ Time=TimeSpan.FromSeconds(16.1), Actor = "Serenia", Event = "PathTo", Args = { Pos = Loc(-218.12,0,713.05)} },	
		{ Time=TimeSpan.FromSeconds(16.4), Actor = "Serenia", Event = "MoveTo", Args = { Pos = Loc(-218,0,708.5)} },	
		{ Time=TimeSpan.FromSeconds(17.7), Actor = "Ezekiel", Event = "MoveTo", Args = { Pos = Loc(-218,0,709.83)} },
		{ Time=TimeSpan.FromSeconds(13.4), Actor = "Marcos", Event = "MoveTo", Args = { Pos = Loc(-219.28,0,724.84) } },	
		{ Time=TimeSpan.FromSeconds(22.8), Actor = "Ezekiel", Event = "SetPos", Args = { Facing = 177 } },		
		{ Time=TimeSpan.FromSeconds(22.8), Actor = "Ezekiel", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Serenia" } },	
		{ Time=TimeSpan.FromSeconds(23.0), Actor = "Theos", Event = "MoveTo", Args = { Pos = Loc(-216.66,0,710.07), Speed=4.5} },	
		{ Time=TimeSpan.FromSeconds(23.6), Actor = "Theos", Event = "SetPos", Args = { Facing = 254 } },		
		{ Time=TimeSpan.FromSeconds(23.4), Actor = "Theos", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Ezekiel" } },	

		{ Time=TimeSpan.FromSeconds(23.95), Actor = "Serenia", Event = "MoveTo", Args = { Pos = Loc(-223.67,0,702.17), Speed=4.5} },	
		{ Time=TimeSpan.FromSeconds(26), Actor = "Serenia", Event = "MoveTo", Args = { Pos = Loc(-224.28,0,691.98), Speed=1.5 } },	
		{ Time=TimeSpan.FromSeconds(33.0), Actor = "Serenia", Event = "MoveTo", Args = { Pos = Loc(-239,0,690.75), Speed=1.5 } },	
		{ Time=TimeSpan.FromSeconds(42.5), Actor = "Serenia", Event = "MoveTo", Args = { Pos = Loc(-238.21,0,696.28), Speed=1.5 } },	
		{ Time=TimeSpan.FromSeconds(46.4), Actor = "Serenia", Event = "SetPos", Args = { Facing = 87 } },	
		{ Time=TimeSpan.FromSeconds(46.4), Actor = "Serenia", Event = "PlayAnimation", Args = { Anim="gavel" } },	
	},
	guildhouse = {
		{ Time=TimeSpan.FromSeconds(0), Actor = "Elinari", Event = "SetPos", Args = { Pos = Loc(-1751.76,0,-576.07), Facing=129 } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Elinari", Event = "Stand" },
		{ Time=TimeSpan.FromSeconds(0), Actor = "Elinari", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Adaline", Event = "SetPos", Args = { Pos = Loc(-1738.45,0,-565.91), Facing=38 } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Adaline", Event = "Unmount" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Horse ", Event = "SetPos", Args = { Pos = Loc(-1745.63,0,-573.44), Facing=196 } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Adaline", Event = "PetOrder", Args = { TargetName = "Horse ", CommandName = "stay" } },	

		{ Time=TimeSpan.FromSeconds(5), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(-1742.42,0,-566.57), Speed=3 } },	
		{ Time=TimeSpan.FromSeconds(5.5), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(-1742.66,0,-569.27), Speed=3 } },	
		{ Time=TimeSpan.FromSeconds(6), Actor = "Adaline", Event = "UseObject", Args = { Target = GameObj(492), UseType="Open/Close" } },	
		{ Time=TimeSpan.FromSeconds(6.25), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(-1742.78,0,-574.79), Speed=3 } },	
		{ Time=TimeSpan.FromSeconds(7.2), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(-1745.33,0,-573.75), Speed=3 } },	
		{ Time=TimeSpan.FromSeconds(7.5), Actor = "Adaline", Event = "Mount", Args = {TargetName = "Horse " } },	
		{ Time=TimeSpan.FromSeconds(5.5), Actor = "Elinari", Event = "CastSpell", Args = { SpellName = "Portal", Target = GameObj(314250) } },	
		{ Time=TimeSpan.FromSeconds(7.6), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(-1748.91,0,-575.97), Speed=4 } },	
		{ Time=TimeSpan.FromSeconds(9), Actor = "Elinari", Event = "UseObject", Args = { SearchTemplate = "portal", UseType="Activate" } },
		{ Time=TimeSpan.FromSeconds(9.2), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(-1751.59,0,-576.25), Speed=4 } },	
		{ Time=TimeSpan.FromSeconds(9.7), Actor = "Adaline", Event = "UseObject", Args = { SearchTemplate = "portal", UseType="Activate" } },
	},
	brigand = {
		{ Time=TimeSpan.FromSeconds(0), Actor = "Hawkfire", Event = "ExitCombat" },
		{ Time=TimeSpan.FromSeconds(0), Actor = "Min", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Seylara", Event = "ExitCombat" },
		{ Time=TimeSpan.FromSeconds(0), Actor = "Adaline", Event = "ExitCombat" },		
		{ Time=TimeSpan.FromSeconds(0), Actor = "Adaline", Event = "SetPos", Args = { Pos = Loc(1870.01,0,29.53), Facing=65 } },
		{ Time=TimeSpan.FromSeconds(0), Actor = "Horse", Event = "SetPos", Args = { Pos = Loc(1870.01,0,29.53), Facing=196 } },
		{ Time=TimeSpan.FromSeconds(0), Actor = "Hawkfire", Event = "SetPos", Args = { Pos = Loc(1857.764,0,181.762), Facing=187 } },
		{ Time=TimeSpan.FromSeconds(0), Actor = "Min", Event = "SetPos", Args = { Pos = Loc(1858.973,0,182.2625), Facing=187 } },
		{ Time=TimeSpan.FromSeconds(0), Actor = "Seylara", Event = "SetPos", Args = { Pos = Loc(1856.373,0,182.6745), Facing=187 } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Adaline", Event = "Mount", Args = {TargetName = "Horse" } },

		{ Time=TimeSpan.FromSeconds(2), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(1876.54,0,44.86), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(4), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(1890.54,0,51.67), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(6), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(1896.36,0,55.53), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(7.5), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(1900,0,61.79), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(8.2), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(1905.14,0,84.20), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(11.5), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(1889.98,0,133.14), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(19), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(1867.69,0,146.54), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(22), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(1854.16,0,167.09), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(24), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(1847.66,0,184.82), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(27.5), Actor = "Adaline", Event = "MoveTo", Args = { Pos = Loc(1833.55,0,195.78), Speed=4 } },

		--{ Time=TimeSpan.FromSeconds(1), Actor = "Hawkfire", Event = "AttackTarget", Args = {TargetName = "Adaline " } },
		{ Time=TimeSpan.FromSeconds(20), Actor = "Hawkfire", Event = "WeaponAbility", Args = { IsPrimary=false, TargetName="Adaline" } },
		{ Time=TimeSpan.FromSeconds(22), Actor = "Hawkfire", Event = "PlayAnimation", Args = { Anim="draw_bow" } },
		{ Time=TimeSpan.FromSeconds(20.2), Actor = "Min", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Adaline" } },
		{ Time=TimeSpan.FromSeconds(22.2), Actor = "Min", Event = "PlayAnimation", Args = { Anim="draw_bow" } },
		{ Time=TimeSpan.FromSeconds(20.3), Actor = "Seylara", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Adaline" } },
		{ Time=TimeSpan.FromSeconds(22.4), Actor = "Seylara", Event = "PlayAnimation", Args = { Anim="draw_bow" } },
		{ Time=TimeSpan.FromSeconds(26.5), Actor = "Adaline", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Seylara" } },	
	},
	merchanttown = {
		{ Time=TimeSpan.FromSeconds(0), Actor = "Merif", Event = "SetPos", Args = { Pos = Loc(229.91,0,-1957.16), Facing=34 } },
		{ Time=TimeSpan.FromSeconds(0), Actor = "Merif", Event = "PlayAnimation", Args = { Anim="idle" } },
		{ Time=TimeSpan.FromSeconds(1), Actor = "Merif", Event = "MoveTo", Args = { Pos = Loc(241.26,0,-1960.24), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(3.8), Actor = "Merif", Event = "MoveTo", Args = { Pos = Loc(250.81,0,-1956.02), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(6.7), Actor = "Merif", Event = "SetPos", Args = { Facing = 35 } },
		{ Time=TimeSpan.FromSeconds(8.5), Actor = "Merif", Event = "PlayAnimation", Args = { Anim="transaction" } },

		{ Time=TimeSpan.FromSeconds(0), Actor = "Theos", Event = "SetPos", Args = { Pos = Loc(216,0,-1971.9), Facing=34 } },
		{ Time=TimeSpan.FromSeconds(2), Actor = "Theos", Event = "MoveTo", Args = { Pos = Loc(224.98,0,-1960.04), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(5.5), Actor = "Theos", Event = "MoveTo", Args = { Pos = Loc(234.59,0,-1958.93), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(8), Actor = "Theos", Event = "MoveTo", Args = { Pos = Loc(242.19,0,-1962.87), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(9.5), Actor = "Theos", Event = "MoveTo", Args = { Pos = Loc(244.49,0,-1968.60), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(11.5), Actor = "Theos", Event = "MoveTo", Args = { Pos = Loc(256.05,0,-1973.49), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(14.5), Actor = "Theos", Event = "MoveTo", Args = { Pos = Loc(268.32,0,-1968.82), Speed=4 } },

		{ Time=TimeSpan.FromSeconds(0), Actor = "Solaris", Event = "SetPos", Args = { Pos = Loc(269.21,0,-1973.94), Facing=307 } },
		{ Time=TimeSpan.FromSeconds(2.5), Actor = "Solaris", Event = "MoveTo", Args = { Pos = Loc(262.58,0,-1967.70), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(4), Actor = "Solaris", Event = "MoveTo", Args = { Pos = Loc(259.39,0,-1961.08), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(6.5), Actor = "Solaris", Event = "MoveTo", Args = { Pos = Loc(249.04,0,-1955.70), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(9), Actor = "Solaris", Event = "MoveTo", Args = { Pos = Loc(241.95,0,-1959.94), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(11), Actor = "Solaris", Event = "MoveTo", Args = { Pos = Loc(214.51,0,-1954.60), Speed=4 } },

		{ Time=TimeSpan.FromSeconds(0), Actor = "Marcos", Event = "SetPos", Args = { Pos = Loc(235.02,0,-1977.36), Facing=35 } },
		{ Time=TimeSpan.FromSeconds(1), Actor = "Marcos", Event = "MoveTo", Args = { Pos = Loc(242.71,0,-1968.23), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(3.5), Actor = "Marcos", Event = "MoveTo", Args = { Pos = Loc(248.41,0,-1956.7), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(6), Actor = "Marcos", Event = "MoveTo", Args = { Pos = Loc(245.59,0,-1953.96), Speed=4 } },

		{ Time=TimeSpan.FromSeconds(0), Actor = "Aokis", Event = "SetPos", Args = { Pos = Loc(262.86,0,-1961.17), Facing=23 } },
		{ Time=TimeSpan.FromSeconds(3), Actor = "Aokis", Event = "MoveTo", Args = { Pos = Loc(255.99,0,-1974.17), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(6.5), Actor = "Aokis", Event = "MoveTo", Args = { Pos = Loc(240.47,0,-1967.74), Speed=4 } },

		{ Time=TimeSpan.FromSeconds(0), Actor = "Jasc", Event = "SetPos", Args = { Pos = Loc(269.29,0,-1977.16), Facing=305 } },
		{ Time=TimeSpan.FromSeconds(0), Actor = " Horse ", Event = "SetPos", Args = { Pos = Loc(269.29,0,-1977.16), Facing=305 } },
		{ Time=TimeSpan.FromSeconds(0), Actor = "Jasc", Event = "Mount", Args = {TargetName = " Horse " } },

		{ Time=TimeSpan.FromSeconds(0), Actor = "Heather |POP|", Event = "PrestigeAbility", Args = { Class = "Skills", Name = "Hide" } },
		{ Time=TimeSpan.FromSeconds(0), Actor = "Heather |POP", Event = "SetPos", Args = { Pos = Loc(259.91,0,-1949.54), Facing=200 } },
		{ Time=TimeSpan.FromSeconds(3), Actor = "Heather |POP|", Event = "MoveTo", Args = { Pos = Loc(257.4,0,-1956.45)} },
		{ Time=TimeSpan.FromSeconds(9), Actor = "Heather |POP|", Event = "MoveTo", Args = { Pos = Loc(260.53,0,-1957.20)} },

		{ Time=TimeSpan.FromSeconds(0), Actor = "Emy", Event = "SetPos", Args = { Pos = Loc(244.7,0,-1978.31), Facing=359 } },
		{ Time=TimeSpan.FromSeconds(5), Actor = "Emy", Event = "UseObject", Args = { Target = GameObj(324377), UseType="Open/Close" } },
		{ Time=TimeSpan.FromSeconds(6.5), Actor = "Emy", Event = "MoveTo", Args = { Pos = Loc(246.95,0,-1971.32), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(8), Actor = "Emy", Event = "MoveTo", Args = { Pos = Loc(257.10,0,-1973.03), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(10), Actor = "Emy", Event = "MoveTo", Args = { Pos = Loc(261.51,0,-1967.13), Speed=4 } },
		{ Time=TimeSpan.FromSeconds(12), Actor = "Emy", Event = "MoveTo", Args = { Pos = Loc(263.41,0,-1961.24), Speed=4 } },	
	},

	valus = {
		-- water
		{ Time=TimeSpan.FromSeconds(0), Actor = "Zerdoza", Event = "Resurrect" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Caerbanog", Event = "Resurrect" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Ranghar", Event = "Resurrect" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Mengbilar", Event = "Resurrect" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Solaris", Event = "Resurrect" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Tharalik", Event = "Resurrect" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Grimskab", Event = "Resurrect" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Brave SirRobin", Event = "Resurrect" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Zerdoza", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Caerbanog", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Ranghar", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Mengbilar", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Solaris", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Tharalik", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Grimskab", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Brave SirRobin", Event = "ExitCombat" },	


		{ Time=TimeSpan.FromSeconds(0), Actor = "Zerdoza", Event = "ClearPathTarget" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Zerdoza", Event = "SetPos", Args = { Pos = Loc(889.37,0,-1173.85), Facing=129 } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Caerbanog", Event = "SetPos", Args = { Pos = Loc(890.95,0,-1175.38), Facing=129 } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Ranghar", Event = "SetPos", Args = { Pos = Loc(887.24,0,-1174.89), Facing=129 } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Mengbilar", Event = "SetPos", Args = { Pos = Loc(887.19,0,-1177.67), Facing=129 } },	
		-- fire
		{ Time=TimeSpan.FromSeconds(0), Actor = "Solaris", Event = "SetPos", Args = { Pos = Loc(923.82,0,-1185.81), Facing=129 } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Tharalik", Event = "ClearPathTarget" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Tharalik", Event = "SetPos", Args = { Pos = Loc(923.05,0,-1183.96), Facing=129 } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Grimskab", Event = "SetPos", Args = { Pos = Loc(922.41,0,-1181.95), Facing=129 } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Brave SirRobin", Event = "SetPos", Args = { Pos = Loc(926.44,0,-1185.44), Facing=129 } },	
		-- blacksmith
		{ Time=TimeSpan.FromSeconds(0), Actor = "Merif", Event = "SetPos", Args = { Pos = Loc(914.65,0,-1164.65), Facing=292 } },			
		{ Time=TimeSpan.FromSeconds(0), Actor = "Merif", Event = "PlayAnimation", Args = { Anim="idle" } },		

		-- spectators
		{ Time=TimeSpan.FromSeconds(0), Actor = "Herald", Event = "Mount", Args = { TargetName = " Horse " } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Herald", Event = "SetPos", Args = { Pos = Loc(909.77,0,-1140.79), Facing=292 } },			
		{ Time=TimeSpan.FromSeconds(0), Actor = "Hexx", Event = "Mount", Args = { TargetName = "  Horse  " } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Hexx", Event = "SetPos", Args = { Pos = Loc(907.86,0,-1140.44), Facing=292 } },			
		{ Time=TimeSpan.FromSeconds(0), Actor = "Warg", Event = "PetOrder", Args = { TargetName = "Jane", CommandName = "follow" } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Jane", Event = "SetPos", Args = { Pos = Loc(887.56,0,-1179.98), Facing=292 } },			
		{ Time=TimeSpan.FromSeconds(0), Actor = "Warg", Event = "SetPos", Args = { Pos = Loc(887.56,0,-1179.98), Facing=292 } },			

		-- blacksmith
		{ Time=TimeSpan.FromSeconds(1), Actor = "Merif", Event = "PlayAnimation", Args = { Anim="blacksmith" } },		
		{ Time=TimeSpan.FromSeconds(10), Actor = "Merif", Event = "PlayAnimation", Args = { Anim="idle" } },			
		{ Time=TimeSpan.FromSeconds(11), Actor = "Merif", Event = "MoveTo", Args = { Pos = Loc(913.63,0,-1171.50), Speed=4 } },	
		{ Time=TimeSpan.FromSeconds(12.4), Actor = "Merif", Event = "MoveTo", Args = { Pos = Loc(918.20,0,-1179.93), Speed=4 } },	
		{ Time=TimeSpan.FromSeconds(14), Actor = "Merif", Event = "MoveTo", Args = { Pos = Loc(926.91,0,-1185.45), Speed=4 } },			

		-- spectators
		{ Time=TimeSpan.FromSeconds(8), Actor = "Herald", Event = "MoveTo", Args = { Pos = Loc(907.88,0,-1160.26), Speed=5 } },
		{ Time=TimeSpan.FromSeconds(8.5), Actor = "Hexx", Event = "MoveTo", Args = { Pos = Loc(908.34,0,-1156.07), Speed=5 } },
		{ Time=TimeSpan.FromSeconds(8), Actor = "Jane", Event = "MoveTo", Args = { Pos = Loc(894.94,0,-1168.94), Speed=4 } },	
		{ Time=TimeSpan.FromSeconds(11), Actor = "Jane", Event = "MoveTo", Args = { Pos = Loc(897.53,0,-1140.81), Speed=4 } },		

		-- water moves in
		{ Time=TimeSpan.FromSeconds(1), Actor = "Caerbanog", Event = "MoveTo", Args = { Pos = Loc(898.23,0,-1167.56), Speed=4 } },	
		{ Time=TimeSpan.FromSeconds(2.5), Actor = "Zerdoza", Event = "MoveTo", Args = { Pos = Loc(896.07,0,-1166.52), Speed=4 } },	
		{ Time=TimeSpan.FromSeconds(3.1), Actor = "Ranghar", Event = "MoveTo", Args = { Pos = Loc(895.62,0,-1168.01), Speed=4 } },	
		{ Time=TimeSpan.FromSeconds(1.0), Actor = "Mengbilar", Event = "MoveTo", Args = { Pos = Loc(897.48,0,-1170.28), Speed=4 } },	

		{ Time=TimeSpan.FromSeconds(5.2), Actor = "Caerbanog", Event = "SetPos", Args = { Facing=262 } },
		{ Time=TimeSpan.FromSeconds(5.5), Actor = "Zerdoza", Event = "SetPos", Args = { Facing=139 } },
		{ Time=TimeSpan.FromSeconds(6.0), Actor = "Mengbilar", Event = "SetPos", Args = { Facing=1 } },	

		-- fire moves in
		{ Time=TimeSpan.FromSeconds(3), Actor = "Grimskab", Event = "MoveTo", Args = { Pos = Loc(906.4,0,-1166.49), Speed=4 } },	
		{ Time=TimeSpan.FromSeconds(4.5), Actor = "Solaris", Event = "MoveTo", Args = { Pos = Loc(909.22,0,-1168.48), Speed=4 } },	
		{ Time=TimeSpan.FromSeconds(4.5), Actor = "Tharalik", Event = "MoveTo", Args = { Pos = Loc(904.92,0,-1168.06), Speed=4 } },	
		{ Time=TimeSpan.FromSeconds(4.5), Actor = "Brave SirRobin", Event = "MoveTo", Args = { Pos = Loc(906.64,0,-1169.32), Speed=4 } },	

		-- water notices
		{ Time=TimeSpan.FromSeconds(6.0), Actor = "Ranghar", Event = "SetPos", Args = { Facing=85 } },
		{ Time=TimeSpan.FromSeconds(6.4), Actor = "Ranghar", Event = "PlayAnimation", Args = { Anim="throatslash" } },		

		-- water warrior 1 attacks
		{ Time=TimeSpan.FromSeconds(7.7), Actor = "Caerbanog", Event = "SetPos", Args = { Facing=123 } },
		{ Time=TimeSpan.FromSeconds(7.9), Actor = "Caerbanog", Event = "AttackTarget", Args = { TargetName="Grimskab" } },
		{ Time=TimeSpan.FromSeconds(8.5), Actor = "Caerbanog", Event = "PrestigeAbility", Args = { Class = "Knight", Name = "Charge", TargetName = "Grimskab" } },
		
		-- water warrior 2 attacks 
		{ Time=TimeSpan.FromSeconds(8.5), Actor = "Zerdoza", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Solaris" } },
		{ Time=TimeSpan.FromSeconds(8.8), Actor = "Zerdoza", Event = "PathToTarget", Args = { TargetName="Solaris", Speed=4 } },	

		-- fire warrior 1 attacks
		{ Time=TimeSpan.FromSeconds(8.5), Actor = "Tharalik", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Caerbanog" } },

		-- water warrior 1 vanguard
		{ Time=TimeSpan.FromSeconds(9.0), Actor = "Caerbanog", Event = "PrestigeAbility", Args = { Class = "Knight", Name = "Vanguard" } },
		{ Time=TimeSpan.FromSeconds(12), Actor = "Caerbanog", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Grimskab" } },
		{ Time=TimeSpan.FromSeconds(15), Actor = "Caerbanog", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Grimskab" } },

		-- water caster 1 casts
		{ Time=TimeSpan.FromSeconds(9.0), Actor = "Ranghar", Event = "MoveTo", Args = { Pos = Loc(899.69,0,-1165.56), Speed=4 } },	
		{ Time=TimeSpan.FromSeconds(9.5), Actor = "Ranghar", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Solaris" } },	
		{ Time=TimeSpan.FromSeconds(11), Actor = "Ranghar", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Solaris" } },	
		{ Time=TimeSpan.FromSeconds(12.5), Actor = "Ranghar", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Solaris" } },	
		{ Time=TimeSpan.FromSeconds(14), Actor = "Ranghar", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Solaris" } },	
		{ Time=TimeSpan.FromSeconds(15.5), Actor = "Ranghar", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Solaris" } },	
		{ Time=TimeSpan.FromSeconds(17), Actor = "Ranghar", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Solaris" } },	
		{ Time=TimeSpan.FromSeconds(18.5), Actor = "Ranghar", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Solaris" } },

		-- fire caster 1 casts
		{ Time=TimeSpan.FromSeconds(10.8), Actor = "Brave SirRobin", Event = "CastSpell", Args = { SpellName = "Defense", TargetName = "Grimskab" } },	
		{ Time=TimeSpan.FromSeconds(12.6), Actor = "Brave SirRobin", Event = "CastSpell", Args = { SpellName = "Greaterheal", TargetName = "Grimskab" } },	
		{ Time=TimeSpan.FromSeconds(14.4), Actor = "Brave SirRobin", Event = "CastSpell", Args = { SpellName = "Heal", TargetName = "Grimskab" } },	
		{ Time=TimeSpan.FromSeconds(16.2), Actor = "Brave SirRobin", Event = "CastSpell", Args = { SpellName = "Heal", TargetName = "Grimskab" } },	
		{ Time=TimeSpan.FromSeconds(18.0), Actor = "Brave SirRobin", Event = "CastSpell", Args = { SpellName = "Heal", TargetName = "Grimskab" } },	
		{ Time=TimeSpan.FromSeconds(19.8), Actor = "Brave SirRobin", Event = "CastSpell", Args = { SpellName = "Heal", TargetName = "Grimskab" } },	
		{ Time=TimeSpan.FromSeconds(21.6), Actor = "Brave SirRobin", Event = "CastSpell", Args = { SpellName = "Heal", TargetName = "Grimskab" } },

		{ Time=TimeSpan.FromSeconds(8.5), Actor = "Tharalik", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Caerbanog" } },
		{ Time=TimeSpan.FromSeconds(14), Actor = "Tharalik", Event = "WeaponAbility", Args = { IsPrimary=false, TargetName="Caerbanog" } },		
		{ Time=TimeSpan.FromSeconds(14.5), Actor = "Tharalik", Event = "PathToTarget", Args = { TargetName="Zerdoza", Speed=4 } },	
		{ Time=TimeSpan.FromSeconds(15), Actor = "Tharalik", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Zerdoza" } },

		-- water archer 
		{ Time=TimeSpan.FromSeconds(8.5), Actor = "Mengbilar", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Grimskab" } },
		{ Time=TimeSpan.FromSeconds(13), Actor = "Mengbilar", Event = "WeaponAbility", Args = { IsPrimary=false, TargetName="Grimskab" } },
		{ Time=TimeSpan.FromSeconds(16), Actor = "Mengbilar", Event = "WeaponAbility", Args = { IsPrimary=false, TargetName="Grimskab" } },

		-- fire warrior 2 attacks
		{ Time=TimeSpan.FromSeconds(9.2), Actor = "Grimskab", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Caerbanog" } },
		{ Time=TimeSpan.FromSeconds(13), Actor = "Grimskab", Event = "WeaponAbility", Args = { IsPrimary=false, TargetName="Caerbanog" } },
		{ Time=TimeSpan.FromSeconds(16), Actor = "Grimskab", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Caerbanog" } },

		{ Time=TimeSpan.FromSeconds(11.0), Actor = "Solaris", Event = "CastSpell", Args = { SpellName = "Electricbolt", TargetName = "Mengbilar" } },
		{ Time=TimeSpan.FromSeconds(12.6), Actor = "Solaris", Event = "CastSpell", Args = { SpellName = "Electricbolt", TargetName = "Mengbilar" } },	
		{ Time=TimeSpan.FromSeconds(14.4), Actor = "Solaris", Event = "CastSpell", Args = { SpellName = "Electricbolt", TargetName = "Mengbilar" } },	
		{ Time=TimeSpan.FromSeconds(16.2), Actor = "Solaris", Event = "CastSpell", Args = { SpellName = "Electricbolt", TargetName = "Mengbilar" } },	
		{ Time=TimeSpan.FromSeconds(18.0), Actor = "Solaris", Event = "CastSpell", Args = { SpellName = "Electricbolt", TargetName = "Mengbilar" } },	
		{ Time=TimeSpan.FromSeconds(19.8), Actor = "Solaris", Event = "CastSpell", Args = { SpellName = "Electricbolt", TargetName = "Mengbilar" } },	
		{ Time=TimeSpan.FromSeconds(21.6), Actor = "Solaris", Event = "CastSpell", Args = { SpellName = "Electricbolt", TargetName = "Mengbilar" } },		
	},
	dragon = {
		{ Time=TimeSpan.FromSeconds(0), Actor = "Vazguhn", Event = "SetPos", Args = { Pos = Loc(-2710.39,0,-786.5), Facing=27 } },	

		{ Time=TimeSpan.FromSeconds(0), Actor = "Warg", Event = "SetPos", Args = { Pos = Loc(-2698.12,0,-782.45), Facing=252 } },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Warg", Event = "ClearPathTarget" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Jane", Event = "SetPos", Args = { Pos = Loc(-2700.69,0,-782.01), Facing=255 } },	

		{ Time=TimeSpan.FromSeconds(0), Actor = "Theos", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Adaline", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Lumia", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Danue Sunrider", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Crucible", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Graycloud", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Calheb", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Elinari", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Warg", Event = "ExitCombat" },	
		{ Time=TimeSpan.FromSeconds(0), Actor = "Vazguhn", Event = "ExitCombat" },	

		{ Time=TimeSpan.FromSeconds(1.1), Actor = "Theos", Event = "AttackTarget", Args = { TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(1.3), Actor = "Adaline", Event = "AttackTarget", Args = { TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(1.5), Actor = "Lumia", Event = "AttackTarget", Args = { TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(1), Actor = "Danue Sunrider", Event = "AttackTarget", Args = { TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(1), Actor = "Crucible", Event = "AttackTarget", Args = { TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(1), Actor = "Graycloud", Event = "AttackTarget", Args = { TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(1), Actor = "Calheb", Event = "AttackTarget", Args = { TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(1), Actor = "Elinari", Event = "AttackTarget", Args = { TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(3), Actor = "Jane", Event = "PetOrder", Args = { TargetName="Warg", CommandName="kill", CommandTargetName="Vazguhn" } },

		{ Time=TimeSpan.FromSeconds(1.0), Actor = "Elinari", Event = "CastSpell", Args = { SpellName = "Electricbolt", TargetName = "Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(3.6), Actor = "Elinari", Event = "CastSpell", Args = { SpellName = "Electricbolt", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(5.4), Actor = "Elinari", Event = "CastSpell", Args = { SpellName = "Electricbolt", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(7.2), Actor = "Elinari", Event = "CastSpell", Args = { SpellName = "Electricbolt", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(9.0), Actor = "Elinari", Event = "CastSpell", Args = { SpellName = "Electricbolt", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(10.8), Actor = "Elinari", Event = "CastSpell", Args = { SpellName = "Electricbolt", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(12.6), Actor = "Elinari", Event = "CastSpell", Args = { SpellName = "Electricbolt", TargetName = "Vazguhn" } },	

		{ Time=TimeSpan.FromSeconds(1.0), Actor = "Crucible", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(2.2), Actor = "Crucible", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(3.5), Actor = "Crucible", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(4.2), Actor = "Crucible", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(5.1), Actor = "Crucible", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(6.0), Actor = "Crucible", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(7.5), Actor = "Crucible", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	

		{ Time=TimeSpan.FromSeconds(1.3), Actor = "Danue", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(2.7), Actor = "Danue", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(3.9), Actor = "Danue", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(4.4), Actor = "Danue", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(5.8), Actor = "Danue", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(6.4), Actor = "Danue", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(7.5), Actor = "Danue", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	

		{ Time=TimeSpan.FromSeconds(1.7), Actor = "Calheb", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(3.1), Actor = "Calheb", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(4.2), Actor = "Calheb", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(5.4), Actor = "Calheb", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(6.1), Actor = "Calheb", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(7.2), Actor = "Calheb", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	
		{ Time=TimeSpan.FromSeconds(8.5), Actor = "Calheb", Event = "CastSpell", Args = { SpellName = "Fireball", TargetName = "Vazguhn" } },	

		{ Time=TimeSpan.FromSeconds(1), Actor = "Theos", Event = "PrestigeAbility", Args = { Class = "Knight", Name = "Vanguard" } },
		{ Time=TimeSpan.FromSeconds(4), Actor = "Theos", Event = "PrestigeAbility", Args = { Class = "Knight", Name = "Vanguard" } },
		{ Time=TimeSpan.FromSeconds(7), Actor = "Theos", Event = "PrestigeAbility", Args = { Class = "Knight", Name = "Vanguard" } },
		{ Time=TimeSpan.FromSeconds(2), Actor = "Theos", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(4.3), Actor = "Theos", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(6.2), Actor = "Theos", Event = "WeaponAbility", Args = { IsPrimary=false, TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(8.5), Actor = "Theos", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Vazguhn" } },

		{ Time=TimeSpan.FromSeconds(1.5), Actor = "Adaline", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(4), Actor = "Adaline", Event = "WeaponAbility", Args = { IsPrimary=false, TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(6), Actor = "Adaline", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(8.5), Actor = "Adaline", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(10), Actor = "Adaline", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Vazguhn" } },

		{ Time=TimeSpan.FromSeconds(1.5), Actor = "Lumia", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(3), Actor = "Lumia", Event = "WeaponAbility", Args = { IsPrimary=false, TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(5), Actor = "Lumia", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(8), Actor = "Lumia", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(10), Actor = "Lumia", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Vazguhn" } },

		{ Time=TimeSpan.FromSeconds(1.2), Actor = "Graycloud", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(2.5), Actor = "Graycloud", Event = "WeaponAbility", Args = { IsPrimary=false, TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(3.6), Actor = "Graycloud", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(5.8), Actor = "Graycloud", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Vazguhn" } },
		{ Time=TimeSpan.FromSeconds(6.3), Actor = "Graycloud", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Vazguhn" } },

		{ Time=TimeSpan.FromSeconds(0.1), Actor = "Vazguhn", Event = "AttackTarget", Args = { IsPrimary=true, TargetName="Theos" } },
		{ Time=TimeSpan.FromSeconds(1), Actor = "Vazguhn", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Theos" } },
	},
}

--[[Events = {
	{ Time=TimeSpan.FromSeconds(0), Actor = "Ezekiel", Event = "ExitCombat" },	
	{ Time=TimeSpan.FromSeconds(0), Actor = "Ezekiel", Event = "PrestigeAbility", Args = { Class = "Skills", Name = "Hide" } },

	{ Time=TimeSpan.FromSeconds(1), Actor = "Ezekiel", Event = "WeaponAbility", Args = { IsPrimary=true, TargetName="Serenia" } },	
	--{ Time=TimeSpan.FromSeconds(0), Actor = "Serenia", Event = "SetPos", Args = { Pos = Loc(-218.15,0,714.26) } },		
	--{ Time=TimeSpan.FromSeconds(1), Actor = "Serenia", Event = "UseObject", Args = { Target = GameObj(71024), UseType="Open/Close" } },	
}]]

EventFuncs = {
	Create = function ( args)
		CreateObj(args.Template,args.Pos)
	end,

	Destroy = function (actorObj)
		actorObj:Destroy()
	end,

	Mount = function (actorObj,args)
		if(args.TargetName) then
			args.Target = GetActor(args.TargetName)
		end
		MountMobile(actorObj,args.Target)
	end,

	Unmount = function (actorObj,args)
		DismountMobile(actorObj)
	end,

	PetOrder = function (actorObj,args)
		if(args.TargetName) then
			args.Target = GetActor(args.TargetName)
		end
		if(args.CommandTargetName) then
			args.CommandTarget = GetActor(args.CommandTargetName)
		end
		SendPetCommandTo(args.Target, args.CommandName, args.CommandTarget, true)
	end,

	Heal = function (actorObj)
		local curHealth = math.floor(GetCurHealth(actorObj))
		local healAmount = GetMaxHealth(actorObj) - curHealth

		SetCurHealth(actorObj,curHealth + healAmount)
	end,

	Resurrect = function (actorObj)
		actorObj:SendMessage("Resurrect",1.0,nil,true)
	end,

	SetHP = function (actorObj,args)
		SetCurHealth(actorObj,args.Amount)
	end,

	SitChair = function(actorObj,args)
		args.ChairObj:SendMessage("ForceSit",actorObj)
	end,

	Stand = function (actorObj)
		actorObj:SendMessage("StopSitting")
	end,

	SetPos = function (actorObj,args)
		if(args.Pos) then
			actorObj:SetWorldPosition(args.Pos)
		else
			actorObj:StopMoving()
		end
		if(args.Facing) then
			actorObj:SetFacing(args.Facing)
		end
	end,

	AttackTarget = function ( actorObj,args)
		if(args.TargetName) then
			args.Target = GetActor(args.TargetName)
		end
		actorObj:SendMessage("AttackTarget",args.Target)
	end,

	PrestigeAbility = function (actorObj,args)
		if(args.TargetName) then
			args.Target = GetActor(args.TargetName)
		end
		actorObj:SendMessage("PerformPrestigeAbilityByName",args.Target,args.Class,args.Name,false)
	end,

	CastSpell = function (actorObj,args)
		if(args.TargetName) then
			args.Target = GetActor(args.TargetName)
		end
		actorObj:SendMessage("CastSpellMessage",args.SpellName,actorObj,args.Target)
	end,

	WeaponAbility = function (actorObj,args)
		if(args.TargetName) then
			args.Target = GetActor(args.TargetName)
		end

		QueueWeaponAbility(actorObj, args.IsPrimary)
		actorObj:SendMessage("ForceCombat",args.Target)				
	end,

	ExitCombat = function (actorObj)
		actorObj:SendMessage("ClearTarget")
		actorObj:SendMessage("EndCombatMessage")
	end,

	PlayAnimation = function (actorObj,args)
		actorObj:PlayAnimation(args.Anim)
	end,

	PathTo = function (actorObj,args)
		actorObj:PathTo(args.Pos,(args.Speed or 1))
	end,

	PathToTarget = function (actorObj,args)
		if(args.TargetName) then
			args.Target = GetActor(args.TargetName)
		end

		actorObj:PathToTarget(args.Target,(args.Range or 2.0),(args.Speed or 1))
	end,

	ClearPathTarget = function (actorObj)
		actorObj:ClearPathTarget()
	end,

	MoveTo = function (actorObj,args)
		actorObj:MoveTo(args.Pos,(args.Speed or 1))
	end,

	UseObject = function (actorObj,args)
		if(args.SearchTemplate) then
			args.Target = FindObject(SearchTemplate(args.SearchTemplate,OBJECT_INTERACTION_RANGE),actorObj)
		end

		if( ValidResourceUseCase(args.Target, args.UseType) ) then
			TryUseResource(actorObj, args.Target, args.UseType)
		else
			--DebugMessage("SENDING "..args.UseType.." to "..args.Target:GetName())
			args.Target:SendMessage("UseObject",actorObj,args.UseType)
		end
	end
}

actorObjs = {}
function GetActor(name)
	if(actorObjs[name] and actorObjs[name]:IsValid()) then return actorObjs[name] end

	for i,nearbyNpc in pairs(FindObjects(SearchMobileInRange(300))) do
		if (nearbyNpc:GetName():match(name)) then
			actorObjs[name] = nearbyNpc
			return nearbyNpc
		end
	end
end

curEvent = nil
function Play(eventType)	
	curEvent = eventType

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"Ticker")

	for eventIndex,eventData in pairs(Events[eventType]) do
		if not(eventData.TotalSeconds == 0) then
			this:ScheduleTimerDelay(eventData.Time,"event"..eventIndex)
			RegisterSingleEventHandler(EventType.Timer,"event"..eventIndex,function() ExecuteEvent(eventIndex) end)
		end
	end
end
RegisterEventHandler(EventType.Message,"play",Play)

function Stop(eventType)
	curEvent = eventType

	for eventIndex, eventData in pairs(Events[eventType]) do
		if(eventData.Time.TotalSeconds == 0) then
			ExecuteEvent(eventIndex)
		end
		UnregisterEventHandler("",EventType.Timer,"event"..eventIndex)
	end

	UnregisterEventHandler("",EventType.Timer,"Ticker")
end
RegisterEventHandler(EventType.Message,"stop",Stop)

function ExecuteEvent(eventIndex)
	local eventData = Events[curEvent][eventIndex]
	if(eventData.Actor) then
		local actorObj = GetActor(eventData.Actor)
		if(actorObj) then
			--actorObj:NpcSpeech(tostring(eventData.Event))
			EventFuncs[eventData.Event](actorObj,eventData.Args)
		end
	else
		EventFuncs[eventData.Event](eventData.Args)
	end
end

RegisterEventHandler(EventType.ClientUserCommand, "play",Play)
RegisterEventHandler(EventType.ClientUserCommand, "stop",Stop)

count = 1
RegisterEventHandler(EventType.Timer,"Ticker",
	function ()
		--this:NpcSpeech(tostring(count))
		count = count + 1
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"Ticker")
	end)