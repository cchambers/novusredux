

mScaleBase = 10
mScaleIncrease = 0.1
mScaleMin = 8
mScaleMax = 20

USE_RANGE = 2

function rem(amount) 
	return amount * mScaleBase
end

function DoTeleport(user, targetLoc, destRegionAddress)
	if (user:HasModule("sitting")) then
		user:SendMessage("StopSitting")
	end

	TeleportUser(this, user, targetLoc, destRegionAddress)
end

function ActivateTeleporter(user)
	local newTime = ServerTimeSecs()
	local carriedObject = user:CarriedObject()
	local destLoc = this:GetObjVar("Destination")
	if (type(destLoc) == "string") then
		destLoc = Loc.ConvertFrom(destLoc)
	end

	if (destLoc ~= nil) then
		DoTeleport(user, destLoc, this:GetObjVar("RegionAddress"))
		return
	end

	user:SystemMessage(this:GetObjVar("InvalidUseMessage") or "The portal fails to respond to your presence.")
end

function CheckChar(user)
	local success = true
	local items = FindItemsInContainerRecursive(user:GetEquippedObject("Backpack"),
	function (item)
		success = false
		return
	end)

	local RightHand = user:GetEquippedObject("RightHand")
	if (RightHand ~= nil) then success = false end
	local LeftHand = user:GetEquippedObject("LeftHand")
	if (LeftHand ~= nil) then success = false end
	local Chest = user:GetEquippedObject("Chest")
	if (Chest ~= nil) then success = false end
	local Legs = user:GetEquippedObject("Legs")
	if (Legs ~= nil) then success = false end
	local Head = user:GetEquippedObject("Head")
	if (Head ~= nil) then success = false end

	local remainingPets = GetRemainingActivePetSlots(user)
	local maxPets = MaxActivePetSlots(user)
	
	if (maxPets ~= remainingPets) then
		user:SystemMessage("Stable your pets.","info")
		success = false
	end
	return success
end

function ChooseClass(user)
	if (CheckChar(user) == false) then
		user:SystemMessage("You still have some stuff on your character. Bank it or trash it!","info")
		return false
	else
		local fontname = "PermianSlabSerif_Dynamic_Bold"
		
		local fontsize = rem(2)

		mCLASS = DynamicWindow("CHOOSECLASS", "Choose Starting Class", 450, 260, 47, 68, "Draggable", "TopLeft")

		mCLASS:AddLabel(75, 10, "RANGER", 110, 30, rem(2), "center", false, true, fontname)
		mCLASS:AddButton(20, 40, "cw_kit_ranger_light", "Ranger (Light)", 110, 24, "Shortbow/Leather", "", true, "Default", "default")
		mCLASS:AddButton(20, 70, "cw_kit_ranger_heavy", "Ranger (Heavy)", 110, 24, "Warbow/Leather", "", true, "Default", "default")

		
		mCLASS:AddLabel(75, 110, "MAGE", 110, 30, rem(2), "center", false, true, fontname)
		mCLASS:AddButton(20, 140, "cw_kit_mage", "Mage", 110, 24, "Staff/Crucible/Cloth", "", true, "Default", "default")


		mCLASS:AddLabel(300, 10, "WARRIOR", 110, 30, rem(2), "center", false, true, fontname)
		
		mCLASS:AddLabel(235, 30, "HEAVY", 110, 30, rem(1.5), "center", false, true, fontname)
		mCLASS:AddLabel(355, 30, "LIGHT", 110, 30, rem(1.5), "center", false, true, fontname)
		
		mCLASS:AddButton(180, 50, "cw_kit_warrior_heavy_bashing", "Bashing", 110, 24, "War Hammer/Plate", "", true, "Default", "default")
		mCLASS:AddButton(180, 80, "cw_kit_warrior_heavy_lancing", "Lancing", 110, 24, "Halberd/Plate", "", true, "Default", "default")
		mCLASS:AddButton(180, 110, "cw_kit_warrior_heavy_slashing", "Slashing", 110, 24, "Katana/Shield/Chain", "", true, "Default", "default")
		mCLASS:AddButton(180, 140, "cw_kit_warrior_heavy_piercing", "Piercing", 110, 24, "Dagger/Shield/Chain", "", true, "Default", "default")

		mCLASS:AddButton(300, 50, "cw_kit_warrior_light_bashing", "Bashing", 110, 24, "Mace/Shield/Chain", "", true, "Default", "default")
		mCLASS:AddButton(300, 80, "cw_kit_warrior_light_lancing", "Lancing", 110, 24, "Spear/Chain", "", true, "Default", "default")
		mCLASS:AddButton(300, 110, "cw_kit_warrior_light_slashing", "Slashing", 110, 24, "Katana/Shield/Chain", "", true, "Default", "default")
		mCLASS:AddButton(300, 140, "cw_kit_warrior_light_piercing", "Piercing", 110, 24, "Dagger/Shield/Chain", "", true, "Default", "default")
		user:OpenDynamicWindow(mCLASS)
	end
end


function KitConfirm(user, kit)
	if (CheckChar(user) == true) then
		if (kit == nil) then return false end
		CreateObjInBackpack(user, kit)

		local teamHue = this:GetHue()
		if (not(user:HasObjVar("HueActual"))) then
			user:SetObjVar("HueActual", user:GetHue())
			user:SetHue(teamHue)
		end
		user:PlayEffect("ShockwaveEffect")
		user:SetObjVar("ColorwarPlayer", true)
		CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function ( ... )
			ActivateTeleporter(user)
			end)
	else
		user:SystemMessage("You trying to sneak stuff in on me?", "info")
	end
end


RegisterEventHandler(
			EventType.DynamicWindowResponse,
			"CHOOSECLASS",
			function(user, buttonId)
				if (buttonId ~= nil and buttonId ~= "") then
					KitConfirm(user, buttonId)
				end
				return
			end
		)

RegisterEventHandler(
	EventType.EnterView,
	"TeleportPlayer",
	function(user)
		if (this:GetSharedObjectProperty("Weight") >= 0) then
			DelView("TeleportPlayer")
			return
		end
		-- prevent repeated teleports
		if (user:HasTimer("TeleportDelay") or user:HasTimer("EnteringWorld")) then
			return
		end

		ChooseClass(user)
	end
)

RegisterEventHandler(
	EventType.Message,
	"UseObject",
	function(user, usedType)
		if (usedType == "Use" or usedType == "Activate") then
			-- SHOW "CHOOSE YOUR CLASS KIT" WINDOW
			ChooseClass(user)
		end
	end
)

RegisterEventHandler(
	EventType.ModuleAttached,
	"colorwar_teleporter",
	function(...)
		
		AddView("TeleportPlayer", SearchPlayerInRange(1.0, true))
		local portalName = this:GetObjVar("PortalName")
		if (portalName) then
			this:SetName(portalName)
			this:DelObjVar("PortalName")
		end
		AddUseCase(this, "Activate", true)
	end
)
