mBUYWINDOW = nil

mScaleBase = 10
mScaleIncrease = 0.1
mScaleMin = 8
mScaleMax = 20

mRandomRecipes = ServerSettings.Crafting.RandomRecipes

function rem(amount)
	return amount * mScaleBase
end

function ShowVendingWindow(user)
	local fontname = "PermianSlabSerif_Dynamic_Bold"

	local fontsize = rem(2)

	mBUYWINDOW = DynamicWindow("CREDITVENDING", "WELCOME!", 390, 260, 47, 68, "Draggable", "Center")

	mBUYWINDOW:AddButton(20, 40, "random_recipe", "Rare Recipe - 10 Credits", 160, 24, tostring("Random! There are "..#mRandomRecipes.." to collect."), "", false, "Default", "default")
	
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
		local value = 0
		local points = user:GetObjVar("Credits")
		if (buttonId == "random_recipe") then
			value = 10
			local what = tostring("recipe_"..mRandomRecipes[math.random(1, #mRandomRecipes)])
			items[what] = 1
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
			user:SystemMessage(tostring("You cannot afford that yet: [ff0000]" .. value .. "[-] > [bada55]" .. points), "info")
		end
	end
)

-- * each point can be used to buy things from CW equipment vending machines
