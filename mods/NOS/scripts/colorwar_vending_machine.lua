mBUYWINDOW = nil

mScaleBase = 10
mScaleIncrease = 0.1
mScaleMin = 8
mScaleMax = 20

function rem(amount)
	return amount * mScaleBase
end

function ShowVendingWindow(user)
	local fontname = "PermianSlabSerif_Dynamic_Bold"

	local fontsize = rem(2)

	mBUYWINDOW = DynamicWindow("CWVENDING", "Need some gear?", 390, 260, 47, 68, "Draggable", "Center")

	mBUYWINDOW:AddButton(20, 40, "cw_bandages", "25 Bandages", 160, 24, "Heal thyself!", "", false, "Default", "default")
	mBUYWINDOW:AddButton(
		20,
		70,
		"cw_mage_spellbook",
		"Full Spellbook",
		160,
		24,
		"Become a mage!",
		"",
		false,
		"Default",
		"default"
	)
	mBUYWINDOW:AddButton(
		20,
		100,
		"cw_chain_set",
		"Chain Armor",
		160,
		24,
		"Ringle dingle.",
		"",
		false,
		"Default",
		"default"
	)
	mBUYWINDOW:AddButton(
		20,
		130,
		"cw_executioner_weapon",
		"Random Magic Weapon",
		160,
		24,
		"Chop, smash, poke, and shoot!",
		"",
		false,
		"Default",
		"default"
	)

	mBUYWINDOW:AddButton(190, 40, "cw_mage_crucible", "Crucible", 160, 24, "Potions?", "", false, "Default", "default")
	mBUYWINDOW:AddButton(190, 70, "cw_arrows", "150 Arrows", 160, 24, "Pew pew.", "", false, "Default", "default")
	mBUYWINDOW:AddButton(
		190,
		100,
		"cw_leather_set",
		"Leather Armor",
		160,
		24,
		"Swish swash.",
		"",
		false,
		"Default",
		"default"
	)
	mBUYWINDOW:AddButton(190, 130, "cw_plate_set", "Plate Armor", 160, 24, "Clink clank.", "", false, "Default", "default")
	if (user:HasTimer("ColorWarDeath")) then
		mBUYWINDOW:AddButton(20, 160, "cw_rekit", "RE-KIT AFTER RES", 330, 40, "ONCE A MINUTE, DON'T SPAM PLS.", "", true, "Default", "default")
	end

	user:OpenDynamicWindow(mBUYWINDOW)
end

RegisterEventHandler(
	EventType.Message,
	"UseObject",
	function(user, usedType)
		if not (user:HasObjVar("ColorWarPlayer")) then
			return
		end
		ShowVendingWindow(user)
	end
)

RegisterEventHandler(
	EventType.DynamicWindowResponse,
	"CWVENDING",
	function(user, buttonId)
		local items = {}
		local value = 0
		local points = user:GetObjVar("ColorWarPoints")
		if (buttonId == "cw_bandages") then
			value = 2
			items = {bandage = 25}
		elseif (buttonId == "cw_mage_spellbook") then
			value = 3
			items = {cw_mage_spellbook = 1}
		elseif (buttonId == "cw_chain_set") then
			value = 4
			items = {
				cw_warrior_light_helm = 1,
				cw_warrior_light_chest = 1,
				cw_warrior_light_leggings = 1
			}
		elseif (buttonId == "cw_executioner_weapon") then
			value = 5
			items = {cw_executioner_weapon = 1}
		elseif (buttonId == "cw_mage_crucible") then
			value = 2
			items = {cw_mage_crucible = 1}
		elseif (buttonId == "cw_arrows") then
			value = 3
			items = {arrow = 150}
		elseif (buttonId == "cw_leather_set") then
			value = 4
			items = {
				cw_ranger_helm = 1,
				cw_ranger_chest = 1,
				cw_ranger_leggings = 1
			}
		elseif (buttonId == "cw_plate_set") then
			value = 5
			items = {
				cw_warrior_heavy_helm = 1,
				cw_warrior_heavy_chest = 1,
				cw_warrior_heavy_leggings = 1
			}
		elseif (buttonId == "cw_rekit") then
			if not(user:HasTimer("NoRekitTimer")) then
				local kit = user:GetObjVar("ColorWarKit")
				CreateObjInBackpack(user, kit)
				user:ScheduleTimerDelay(TimeSpan.FromMinutes(1),"NoRekitTimer")
			else 
				user:SystemMessage("You are doing that too fast.", "info")
			end
		end

		if (points >= value) then
			points = points - value
			user:SetObjVar("ColorWarPoints", points)
			
			for item, amount in pairs(items) do
				if (amount > 1) then
					CreateStackInBackpack(user, item, amount)
				else 
					CreateObjInBackpack(user, item)
				end
			end
		else
			user:SystemMessage(tostring("You cannot afford that yet: [ff0000]" .. value .. "[-] > " .. points), "info")
		end
	end
)

-- * each point can be used to buy things from CW equipment vending machines
