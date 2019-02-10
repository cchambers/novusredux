function GetRandomTemplate()
	local type = {"ring", "necklace"}
	local gem = {"ruby", "topaz", "sapphire"}
	local quality = {"perfect", "imperfect", "flawed"}
	if ( initializer ) then 
		if (initializer.Types) then type = initializer.Types end
		if (initializer.Gems) then gem = initializer.Gems end
		if (initializer.Qualities) then quality = initializer.Qualities end
	end
	local template = tostring(type[math.random(1,#type)] .. "_" .. gem[math.random(1,#gem)] .. "_" .. quality[math.random(1,#quality)])
	return template
end

function RandomJewelry()
	-- handle on item created (This is the reason we need to use this module and can't put this global)
	RegisterSingleEventHandler(EventType.CreatedObject, "Random.JewelryCreated", function(success, objRef)
		if ( success ) then
			-- all good
		end
		-- Destroy the temporary item we used to run this script and create the weapon.
		this:Destroy()
	end)
	
	local template = GetRandomTemplate()
	-- get the container this item is in (if any)
	local container = this:ContainedBy()
	if ( container == nil ) then
		-- drop it on the ground.
		CreateObj(template, this:GetLoc(), "Random.JewelryCreated")
	else
		-- put it in the container
		local dropPos = GetRandomDropPosition(container)
    	CreateObjInContainer(template, container, dropPos, "Random.JewelryCreated")
	end
end

RandomJewelry()