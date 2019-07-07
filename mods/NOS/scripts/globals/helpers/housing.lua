function GetContainingHouseForObj(targetObj)
	local worldObj = targetObj:TopmostContainer() or targetObj

	return nil --GetContainingHouseForLoc(worldObj:GetLoc())
end

function MoveMobilesOutOfObject(object, loc)
	if not( loc ) then
		loc = object:GetLoc()
	end
	local bounds = GetTemplateObjectBounds(object:GetCreationTemplateId()) or {}
	for i=1,#bounds do
		local box = bounds[i]:Flatten()
		box:Expand(0.5)
		MoveMobiles(box:Add(box, loc))
	end
	return loc
end

function MoveMobiles(box)
	local mobiles = FindObjects(SearchMulti({SearchRect(box),SearchMobile()}),GameObj(0))
	-- if nothing to move, early exit success
	if ( #mobiles < 1 ) then return true end
	local allSuccess = true
	for i=1,#mobiles do
		if not( MoveMobile(mobiles[i], box) ) then
			allSuccess = false
		end
	end
	return allSuccess
end

--- Move a mobile outside of the provided box
-- @param mobile
-- @param box
-- @return true if moved, false if couldn't find a place to move them
function MoveMobile(mobile, box)
	local mobileLoc = mobile:GetLoc()
	local dungeonBounds = GetDungeonBounds()
	local start, center = nil,nil

	if not( dungeonBounds ) then
		local plot, bounds, index = Plot.GetAtLoc(mobileLoc)
		-- if the mobile is in a plot and they have no control to the plot
		if ( plot and not Plot.HasControl(mobile, plot) ) then
			-- start looking for a place to put them that's outside the plot
			start = (bounds[index].Height * bounds[index].Width) + 1
			center = bounds[index].Center
		end
	end
	if ( start == nil or center == nil ) then
		-- otherwise move them outside the provided box
		start, center = (box.Height * box.Width) + 1, box.Center
	end
	for i=1,200 do
		local loc = GetSpiralLoc(start+(i*2), center)
		if (
			( dungeonBounds and ValidDungeonPosition(dungeonBounds, loc) )
			or
			( not dungeonBounds and IsPassable(loc) )
		) then
			-- going 30 degrees at a time, loop a circle. 
			-- if from this loc they can path 14 units in any direction it's considered a valid location to move the mobile to.
			local canPathTo = false
			for ii=1,12 do
				if ( CanPathTo(loc, loc:Project(ii*30, 14)) ) then
					canPathTo = true
					break
				end
			end
			if ( canPathTo and (dungeonBounds or Plot.CanTeleportToLoc(mobile, loc)) ) then
				mobile:SetWorldPosition(loc)
				
				-- drop whatever is currently held at feet
				if ( mobile:IsPlayer() ) then
					local carriedObject = mobile:CarriedObject()
					if ( carriedObject ~= nil and carriedObject:IsValid() ) then
						carriedObject:SetWorldPosition(loc)
					end
				end
				return true
			end
		end
	end
	return false
end