
local weapons = {
	"weapon_katana",
	"weapon_longsword",
	"weapon_broadsword",
	"weapon_saber",
	"weapon_mace",
	"weapon_war_mace",
	"weapon_hammer",
	"weapon_maul",
	"weapon_dagger",
	"weapon_kryss",
	"weapon_poniard",
	"weapon_bone_dagger",
	"weapon_warhammer",
	"weapon_quarterstaff",
	"weapon_warfork",
	"weapon_spear",
	"weapon_voulge",
	"weapon_halberd",
	"weapon_shortbow",
	"weapon_warbow",
	"weapon_longbow",
	"weapon_largeaxe",
	"weapon_greataxe",
}
local armors = {
    --[[
    Armor
    ]]

	"armor_fullplate_leggings",
	"armor_fullplate_tunic",
	"armor_fullplate_helm",
	"armor_leather_chest",
	"armor_leather_helm",
	"armor_leather_leggings",
	"robe_linen_leggings",
	"robe_linen_helm",
	"robe_linen_tunic",

	"shield_buckler",
}

function CreateAll()
	local templateData
	local total = #weapons + #armors
	local done = 0
	local CheckDone = function()
		done = done + 1
		if ( done >= total ) then
			this:DelModule("create_all_perfect_weapon_armor")
		end
	end
	for i=1,#weapons do
		templateData = GetTemplateData(weapons[i])
		if not( templateData.ObjectVariables ) then templateData.ObjectVariables = {} end
		templateData.ObjectVariables.AttackBonus = 100
		templateData.ObjectVariables.AccuracyBonus = 25
		templateData.ObjectVariables.Durability = 200
		templateData.ObjectVariables.CraftedBy = "Citadel Studios"
		Create.Custom.InContainer(weapons[i], templateData, this, nil, CheckDone)
	end
	for i=1,#armors do
		templateData = GetTemplateData(armors[i])
		if not( templateData.ObjectVariables ) then templateData.ObjectVariables = {} end
		templateData.ObjectVariables.ArmorBonus = 2
		templateData.ObjectVariables.Durability = 200
		templateData.ObjectVariables.CraftedBy = "Citadel Studios"
		Create.Custom.InContainer(armors[i], templateData, this, nil, CheckDone)
	end
end

CreateAll()