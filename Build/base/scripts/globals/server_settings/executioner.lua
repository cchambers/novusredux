--[[
	Executioner is a mod applied to weapons to make them more powerful against certain mobile team types.
]]

ServerSettings.Executioner = {
 
	-- Modifier applied to final damage of Executioner weapons when hitting the correct MobileKind for the weapon
	LevelModifier = {
		3, -- level 1
		6, -- level 2
		9, -- level 3
	},

	-- This will be put on the tooltip of the weapon and %s will be replaced with the MobileKind of the weapon.
	LevelString = {
		"%s of Ruin",
		"%s of Power",
		"%s of Vanquishing",
	},


	-- The default intensity of an executioner weapon when created randomly
	DefaultIntensity = {0, 50},
	-- List of templates that are possible to be created via random_executioner_weapon.lua
	RandomTemplateList = {
		"weapon_katana",
		"weapon_longsword",
		"weapon_broadsword",
		"weapon_saber",
		"weapon_greataxe",
		"weapon_largeaxe",
		"weapon_mace",
		"weapon_maul",
		"weapon_hammer",
		"weapon_quarterstaff",
		"weapon_warhammer",
		"weapon_warfork",
		"weapon_spear",
		"weapon_vouge",
		"weapon_halberd",
		"weapon_shortbow",
		"weapon_longbow",
		"weapon_warbow",
		"weapon_dagger",
		"weapon_kryss",
		"weapon_poniard",
		"weapon_bone_dagger",
	},
	-- List of all possible mobile team types for a weapon created via random_executioner_weapon.lua
	RandomMobileKinds = {
		"Undead",
		"Dragon",
		"Humanoid",
		"Reptile",
		"Ork",
		"Arachnid",
		"Animal",
		"Demon",
		"Giant",
	},
}