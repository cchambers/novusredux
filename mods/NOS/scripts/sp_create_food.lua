foods = {
	"item_bread",
	"item_cheese_slice",
	-- "item_cheese_plate",
	-- "item_cheese_wheel",
	-- "item_mead",
	"item_meat_loaf",
	-- "item_meat_leg_bone_grilled",
	-- "item_meat_bone_grilled_plate"
}

function doCreateFood(target)
	startAt = 1
	endAt = math.random(startAt, CountTable(foods))
	CreateTempObj(foods[endAt], target, "created_food")
	PlayEffectAtLoc("TeleportToEffect", target)
end

function CleanUp()
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(
	EventType.CreatedObject,
	"created_food",
	function(success, objRef)
		-- DecayTime is the time (in seconds) before the item disappears.
		objRef:SetObjVar("DecayTime", 15)
		if (objRef:HasModule("summoned_food")) then
			-- this item already has the summoned_food module applied
		else
			-- it doesn't (most cases)
			objRef:AddModule("summoned_food")
		end

		-- stacking can reset scripts causing unwanted stuff...
		-- and most food has the stackable module applied
		if (objRef:HasModule("stackable")) then
			objRef:DelModule("stackable")
		end 

		CleanUp()
	end
)

RegisterEventHandler(
	EventType.Message,
	"CreateFoodSpellTargetResult",
	function(targetLoc)
		-- can't actually get skill levels here because the player object isn't passed...
		-- local MagerySkill = GetSkillLevel(this, "Magery")
		-- DebugMessage("level " .. MagerySkill)
		doCreateFood(targetLoc)
	end
)
