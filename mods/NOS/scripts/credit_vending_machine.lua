mBUYWINDOW = nil

mScaleBase = 10
mScaleIncrease = 0.1
mScaleMin = 8
mScaleMax = 20

mRandomRecipes = ServerSettings.Crafting.RandomRecipes
mRandomWeapons = ServerSettings.Executioner.RandomTemplateList

function rem(amount)
	return amount * mScaleBase
end

function ShowVendingWindow(user)
	local fontname = "PermianSlabSerif_Dynamic_Bold"

	local fontsize = rem(2)

	mBUYWINDOW = DynamicWindow("CREDITVENDING", "Something new?", 390, 260, 47, 68, "Draggable", "Center")
	
	mBUYWINDOW:AddLabel(100, 10, "5 Credits", 160, 30, rem(2), "center", false, true, fontname)
	mBUYWINDOW:AddButton(20, 70, "random_magic_weapon", "Magic Weapon", 160, 26, tostring("Random! There are "..#mRandomWeapons.." different types."), "", false, "Default", "default")
	mBUYWINDOW:AddButton(20, 40, "random_dye", "Normal Dye Tub", 160, 26, tostring("Random! There are 800 to collect."), "", false, "Default", "default")
	
	mBUYWINDOW:AddLabel(280, 10, "15 Credits", 160, 30, rem(2), "center", false, true, fontname)
	mBUYWINDOW:AddButton(200, 40, "random_recipe", "Rare Recipe", 160, 26, tostring("Random! There are "..#mRandomRecipes.." to collect."), "", false, "Default", "default")
	mBUYWINDOW:AddButton(200, 70, "random_dye_rare", "Rare Dye Tub", 160, 26, tostring("Random! There are 100 to collect."), "", false, "Default", "default")
	
	user:OpenDynamicWindow(mBUYWINDOW)
end

RegisterEventHandler(
	EventType.Message,
	"UseObject",
	function(user, usedType)
		ShowVendingWindow(user)
	end
)

RegisterEventHandler(
	EventType.DynamicWindowResponse,
	"CREDITVENDING",
	function(user, buttonId)
		local items = {}
		local value = 99999
		local points = user:GetObjVar("Credits")
		if (buttonId == "" or buttonId == nil) then return end
		if (buttonId == "random_recipe") then
			value = 15
			local what = tostring("recipe_"..mRandomRecipes[math.random(1, #mRandomRecipes)])
			items[what] = 1
		elseif (buttonId == "random_magic_weapon") then
			value = 5
			items["random_executioner_weapon_60_100"] = 1
		elseif (buttonId == "random_dye") then
			value = 5
			items["dye_tub_random_common"] = 1
		elseif (buttonId == "random_dye_rare") then
			value = 15
			items["dye_tub_random_rare"] = 1
		end

		if (points >= value) then
			points = points - value
			user:SetObjVar("Credits", points)
			
			for item, amount in pairs(items) do
				if (amount > 1) then
					CreateStackInBackpack(user, item, amount)
				else 
					CreateObjInBackpack(user, item)
				end
			end
		else
			user:SystemMessage(tostring("You ([bada55]" .. points.."[-]) cannot afford that ([ff0000]" .. value .. "[-]) yet.", "info"))
		end
	end
)

-- * each point can be used to buy things from CW equipment vending machines
