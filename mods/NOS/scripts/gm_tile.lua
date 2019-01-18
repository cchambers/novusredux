mTileType = "pit_wall"
mWallStart = nil
mWallEnd = nil
mWallInstances = nil


function HandleModuleLoaded()
	this:RequestClientTargetLoc(this, "SelectTileStartPoint")
	RegisterEventHandler(EventType.ClientTargetLocResponse, "SelectTileStartPoint", StartPointChosen)
end

function StartPointChosen(success, target)
	mWallStart = target
	mTileObj = "pit_wall"
		this:SystemMessage("Select End Point for Tile")
		this:RequestClientTargetLoc(this, "SelectTileEndPoint")
		RegisterEventHandler(EventType.ClientTargetLocResponse, "SelectTileEndPoint",
		function(success, wallLoc)
			if(wallLoc == nil) then
				return
			end
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "TileTargetTimeout")
			mWallEnd = wallLoc
			CreateWall()
		end)
end

function CreateWall()
	local projAngle = mWallStart:YAngleTo(mWallEnd)
	Facing = math.fmod(projAngle + 85, 360)
	local dist = mWallStart:Distance(mWallEnd)
	this:NpcSpeech(tostring(dist))
	local curProj = 0

	while(curProj <= dist) do
		local nextLoc = mWallStart:Project(projAngle,curProj)
		CreateObj("pit_wall",nextLoc,"pit_wallloc_created")
		curProj = curProj + 1
	end
	mWallInstances = curProj
	RegisterEventHandler(EventType.CreatedObject,"pit_wallloc_created",function (success,objRef)
		if (success) then
			objRef:SetRotation(objRef:GetRotation() + Loc(0,Facing,0))
		end
		mWallInstances = mWallInstances - 1
		if(mWallInstances < 1) then
			UnregisterEventHandler("",EventType.CreatedObject,"pit_wallloc_created")
		end
	end)
end

RegisterSingleEventHandler(EventType.ModuleAttached, "gm_tile", HandleModuleLoaded)