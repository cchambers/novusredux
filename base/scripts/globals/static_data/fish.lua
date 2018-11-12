--chance to catch a fish at 0 skill
BASE_CATCH_CHANCE = 20

AllFish = {

	--EXAMPLE:
	--Fish_Resource_Name = { 
	--	Template = Template of the fish to spawn
	--	Weight = Weight of the side of the die when rolled, if it lands on this side, then you caught this fish
	--	MinSkill = The point at which you can start gaining on this fish
	--},

	--Junk
	--LeatherBoot = {
	--},
	--Fish
	Barrelfish = {
		Template = "resource_fish_barrel",
		SchoolTemplate = "fish_school_barrel",
		DisplayName = "Barrel Fish",
		MinSkill = 5,
	},
	Terofish = {
		Template = "resource_fish_tero",
		SchoolTemplate = "fish_school_tero",
		DisplayName = "Tero Fish",
		MinSkill = 25,
	},
	SpottedTerofish = {
		Template = "resource_fish_spotted_tero",
		SchoolTemplate = "fish_school_spottedtero",
		DisplayName = "Spotted Tero Fish",
		MinSkill = 45,
	},
	FourEyeSalar = {
		Template = "resource_fish_foureyed_salar",
		SchoolTemplate = "fish_school_foureyedsalar",
		DisplayName = "Four-Eyed Salar",
		MinSkill = 65,
	},
	RazorFish = {
		Template = "resource_fish_razor",
		SchoolTemplate = "fish_school_razor",
		DisplayName = "Razor-Fish",
		MinSkill = 85,
	},
	--Atherfish are not found in schools.
	AetherFish = {
		Template = "resource_fish_golden_aether",
		DisplayName = "Golden Aether-Fish",
		MinSkill = 90,
	},
}