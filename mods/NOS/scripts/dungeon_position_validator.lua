local mLastValidPosition = nil
local mDungeonBounds = nil

function IsValidPosition(pos)	
	local isValid = IsPassable(pos)
	if(isValid) then
		local curPos2 = Loc2(pos)
		for i,dungeonBounds in pairs(mDungeonBounds) do
			if(dungeonBounds:Contains(curPos2)) then
				return true
			end
		end
	end

	return false
end

function DoValidate()
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(5 + math.random()),"DoValidate")
	
	local pos = this:GetLoc()
	if(IsValidPosition(pos)) then
		mLastValidPosition = pos
	else
		if(this:IsPlayer()) then
			if(mLastValidPosition ~= nil) then
				this:SetWorldPosition(mLastValidPosition)
			else
				this:SetWorldPosition(GetPlayerSpawnPosition(this))
			end
		else
			this:FireTimer("MobDecayTimer")
			this:DelModule("dungeon_position_validator")
		end
	end
end
RegisterEventHandler(EventType.Timer,"DoValidate",function() DoValidate() end)

function OnLoad()
	local tileObjs = FindPermanentObjects(PermanentObjSearchMulti{
        PermanentObjSearchHasObjectBounds(),
        PermanentObjSearchVisualState("Default")
    })
    mDungeonBounds = {}
    for i,tileObj in pairs(tileObjs) do
    	for i,bounds in pairs(tileObj:GetPermanentObjectBounds()) do
    		table.insert(mDungeonBounds,bounds:Flatten())
    	end
    end

    this:ScheduleTimerDelay(TimeSpan.FromSeconds(5 + math.random()),"DoValidate")
end

RegisterSingleEventHandler(EventType.ModuleAttached,"dungeon_position_validator",
	function ()
		OnLoad()
	end)

RegisterSingleEventHandler(EventType.LoadedFromBackup,"",
	function ()
		OnLoad()
	end)

-- this message needs to be called any time the dungeon reconfigures itself (Catacombs)
RegisterEventHandler(EventType.Message,"DungeonStateChange",
	function ()
		OnLoad()
	end)