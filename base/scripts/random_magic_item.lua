mRandom = nil

mRandomItems = {
	{ "lweapon_katana", "magic_weapon" },
	{ "lweapon_longsword", "magic_weapon" },
	{ "lweapon_mace", "magic_weapon" },
	{ "lweapon_maul", "magic_weapon" },
	{ "lweapon_warfork", "magic_weapon" },
	{ "lweapon_staff", "magic_weapon" },
	{ "lweapon_rapier", "magic_weapon" },
	{ "lweapon_axe", "magic_weapon" },
	{ "lweapon_battle_axe", "magic_weapon" },
	{ "lweapon_club", "magic_weapon" },
	{ "lweapon_dagger", "magic_weapon" },
	{ "lweapon_halberd", "magic_weapon" },
	{ "lweapon_war_hammer", "magic_weapon" },
	{ "lweapon_glaive", "magic_weapon" },
	{ "lweapon_longbow", "magic_weapon" },

	--[[
	Armor
	]]
	{ "larmor_plate_leggings", "magic_armor" },
	{ "larmor_plate_tunic", "magic_armor" },
	{ "larmor_plate_helm", "magic_armor" },
	{ "larmor_bone_helm", "magic_armor" },
	{ "larmor_bone_leggings", "magic_armor" },
	{ "larmor_bone_tunic", "magic_armor" },
	{ "larmor_scale_helm", "magic_armor" },
	{ "larmor_scale_tunic", "magic_armor" },
	{ "larmor_scale_leggings", "magic_armor" },
	{ "larmor_leather_tunic", "magic_armor" },
	{ "larmor_leather_hood", "magic_armor" },
	{ "larmor_leather_legs", "magic_armor" },
	{ "larmor_studded_leather_leggings", "magic_armor" },
	{ "larmor_studded_leather_helm", "magic_armor" },
	{ "larmor_studded_leather_tunic", "magic_armor" },
	{ "lshield_buckler", "magic_armor" },
	{ "lshield_kite", "magic_armor" },
	{ "lshield_bone", "magic_armor" },
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