

function ValidDungeonPosition(dungeonBounds, pos)
	if not ( pos ) then return false end
	if not ( dungeonBounds ) then dungeonBounds = GetDungeonBounds() end
	if not ( dungeonBounds ) then return false end
	if ( IsPassable(pos) ) then
		local pos2 = Loc2(pos)
		for i=1,#dungeonBounds do
			if ( dungeonBounds[i]:Contains(pos2) ) then
				return true
			end
		end
	end
	return false
end

function GetDungeonBounds()
	if ( IsDungeonMap() ) then
		-- get dungeon tiles
		local tileObjs = FindPermanentObjects(PermanentObjSearchMulti{
            --PermanentObjSearchRect(entry.Region), --TODO Optimize this to grab only nearby rect
            PermanentObjSearchHasObjectBounds(),
            PermanentObjSearchVisualState("Default")
		})
		local dungeonBounds = {}
		for i=1,#tileObjs do
			local bounds = tileObjs[i]:GetPermanentObjectBounds()
			for ii=1,#bounds do
				dungeonBounds[#dungeonBounds+1] = bounds[ii]:Flatten()
			end
		end
		return #dungeonBounds>0 and dungeonBounds or nil
	end
	return nil
end