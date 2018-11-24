mRandom = nil

mRandomItems = {
	{ "weapon_katana", "magic_weapon" },
	{ "weapon_longsword", "magic_weapon" },
	{ "weapon_broadsword", "magic_weapon" },
	{ "weapon_saber", "magic_weapon" },
	{ "weapon_mace", "magic_weapon" },
	{ "weapon_war_mace", "magic_weapon" },
	{ "weapon_hammer", "magic_weapon" },
	{ "weapon_maul", "magic_weapon" },
	{ "weapon_dagger", "magic_weapon" },
	{ "weapon_kryss", "magic_weapon" },
	{ "weapon_poniard", "magic_weapon" },
	{ "weapon_bone_dagger", "magic_weapon" },
	{ "weapon_warhammer", "magic_weapon" },
	{ "weapon_quarterstaff", "magic_weapon" },
	{ "weapon_warfork", "magic_weapon" },
	{ "weapon_spear", "magic_weapon" },
	{ "weapon_voulge", "magic_weapon" },
	{ "weapon_halberd", "magic_weapon" },
	{ "weapon_shortbow", "magic_weapon" },
	{ "weapon_warbow", "magic_weapon" },
	{ "weapon_longbow", "magic_weapon" },
	{ "weapon_largeaxe", "magic_weapon" },
	{ "weapon_greataxe", "magic_weapon" },

	--[[
	Armor
	]]

	{ "armor_fullplate_leggings", "magic_armor" },
	{ "armor_fullplate_tunic", "magic_armor" },
	{ "armor_fullplate_helm", "magic_armor" },
	{ "armor_leather_tunic", "magic_armor" },
	{ "armor_leather_hood", "magic_armor" },
	{ "armor_leather_legs", "magic_armor" },
	{ "robe_linen_leggings", "magic_armor" },
	{ "robe_linen_helm", "magic_armor" },
	{ "robe_linen_tunic", "magic_armor" },

	{ "shield_buckler", "magic_armor" },
}

function RandomItem()
	mRandom = math.random(1, #mRandomItems)
	-- get the container this item is in
	local container = this:ContainedBy()
	if ( container == nil ) then
		CreateObj(mRandomItems[mRandom][1], this:GetLoc(), "magic_item_created")
	else
		local dropPos = GetRandomDropPosition(container)
    	CreateObjInContainer(mRandomItems[mRandom][1], container, dropPos, "magic_item_created")
	end
end

RegisterEventHandler(EventType.CreatedObject, "magic_item_created", function(success, objRef, amount)
		SetItemTooltip(objRef)
		objRef:SetObjVar("Intensity", (initializer.Intensity or MagicItemDefaultIntensity))
		objRef:AddModule(mRandomItems[mRandom][2])
		this:Destroy()
	end)

RandomItem()