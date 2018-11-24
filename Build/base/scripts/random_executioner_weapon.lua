


function GetLevelByIntensity()
	local intensity = ServerSettings.Executioner.DefaultIntensity
	if ( initializer ) then intensity = initializer.Intensity end
	local random = math.random(intensity[1] or 0, intensity[2] or 0)

	if ( 60 > random ) then
		return 1
	else
		random = random - 60
	end

	if ( 30 > random ) then
		return 2
	end

	return 3
end

function RandomExecutionerWeapon()

	-- handle on item created (This is the reason we need to use this module and can't put this global)
	RegisterSingleEventHandler(EventType.CreatedObject, "executioner_weapon_created", function(success, objRef)
		if ( success ) then
			-- set the random level
			objRef:SetObjVar("ExecutionerLevel", GetLevelByIntensity())
			-- set the random mobile kind
			objRef:SetObjVar("Executioner", ServerSettings.Executioner.RandomMobileKinds[
				math.random(1, #ServerSettings.Executioner.RandomMobileKinds)
			])
			-- set the tooltip
			SetItemTooltip(objRef)
		end
		-- Destroy the temporary item we used to run this script and create the weapon.
		this:Destroy()
	end)
	local template = ServerSettings.Executioner.RandomTemplateList[math.random(1, #ServerSettings.Executioner.RandomTemplateList)]

	-- get the container this item is in (if any)
	local container = this:ContainedBy()
	if ( container == nil ) then
		-- drop it on the ground.
		CreateObj(template, this:GetLoc(), "executioner_weapon_created")
	else
		-- put it in the container
		local dropPos = GetRandomDropPosition(container)
    	CreateObjInContainer(template, container, dropPos, "executioner_weapon_created")
	end
end

RandomExecutionerWeapon()