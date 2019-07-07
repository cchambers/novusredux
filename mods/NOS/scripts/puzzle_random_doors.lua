--LEVER AND DOOR PUZZLE--
--Puzzle contains an equal number of doors and switches
--The door a switch opens is randomized
--When you pull a switch, one door opens, but two more doors close

function ResetPuzzle()

	--DebugMessage("Resetting puzzle")

	local success = true

	--Get puzzle tag
	local leverPuzzleTag = this:GetObjVar("LeverPuzzleTag")
	if (leverPuzzleTag == nil) then
		DebugMessage("No puzzle tag on puzzle_random_doors ", this)
		success = false
 	end

	--Get puzzle objects matching leverPuzzleTag
	local puzzleObjects = FindObjects(SearchObjVar("LeverPuzzleTag",leverPuzzleTag))
	if (puzzleObjects == nil) then 
		DebugMessage("No puzzle objects.")
		success = false
	end

	--Determine if puzzle object is door, or lever
	local doors = {}
	local levers = {}

	for i, puzzleObject in pairs(puzzleObjects) do
		if (puzzleObject ~= this) then
			if (puzzleObject:HasModule("lever")) then
				table.insert(levers, puzzleObject)
				puzzleObject:SetObjVar("PuzzleController", this)
			elseif (puzzleObject:HasModule("door")) then
				table.insert(doors, puzzleObject)
			end
		end
	end

	--Get list of doors to be assigned to random levers
	local randomizedDoors = {}
	for i, door in pairs(doors) do
		table.insert(randomizedDoors, door)
	end
	--DebugMessage("-----Dumping RandomizedDoors-----")
	--DebugMessage(DumpTable(randomizedDoors))

	--Get list of levers to be assigned to random doors
	local randomizedLevers = {}
	for i, lever in pairs(levers) do
		if not(lever:HasObjVar("DoorId")) then
			table.insert(randomizedLevers, lever)
		end
	end
	--DebugMessage("-----Dumping RandomizedLevers-----")
	--DebugMessage(DumpTable(randomizedLevers))

	--Shuffle random door table
	for i = #randomizedDoors, 1, -1 do
		local rand = math.random(i)
		randomizedDoors[i], randomizedDoors[rand] = randomizedDoors[rand], randomizedDoors[i]
	end

	--Close all doors
	for i = #doors, 1, -1 do
        doors[i]:SetSharedObjectProperty("IsOpen", false)
	end

	--Reset levers
	for i = #levers, 1, -1 do
		levers[i]:SetSharedObjectProperty("IsActivated", false)
	end

	--Create empty table of doors containing table of levers
	local doorLeverTable = {}
	for i, randomDoor in pairs(randomizedDoors) do
		doorLeverTable[randomDoor] = {}
	end

	--Add randomized levers to randomized doors
	for i, randomDoor in pairs(randomizedDoors) do
		table.insert(doorLeverTable[randomDoor], randomizedLevers[i])
	end

	--DebugMessage("------Dumping DoorLeverTable------")
	--DebugMessage(DumpTable(doorLeverTable))

	--Add levers matched to doors by DoorId
	for i, lever in pairs(levers) do
		--If it's an escape lever, find the matching door and add to doors list of levers
		if (lever:HasObjVar("DoorId")) then
			local door = GetDoorById(doors, lever:GetObjVar("DoorId"))

			table.insert(doorLeverTable[door], lever)
		end
		lever:SendMessage("TryAddLeverListener", this)
	end

	if (success == false) then
		DebugMessage("Puzzle initialization failed")
		return
	end

	this:SetObjVar("Levers", levers)
	--DebugMessage(DumpTable(doorLeverTable))
	this:SetObjVar("DoorLeverTable", doorLeverTable)

end

function GetDoorById(doorTable, doorId)
	for i, door in pairs(doorTable) do
		if (door:GetObjVar("DoorId") == doorId) then
			return door
		end
	end
end

function ToggleDoor(doorObj)
	local doorLeverTable = this:GetObjVar("DoorLeverTable")
	for door, leverTable in pairs(doorLeverTable) do
		if (doorObj == door) then
			local doorOpen = not door:GetSharedObjectProperty("IsOpen")
			door:SetSharedObjectProperty("IsOpen", doorOpen)
			for i, lever in pairs(leverTable) do
				lever:SetSharedObjectProperty("IsActivated", doorOpen)
				if(doorOpen) then
					door:ClearCollisionBounds()
				else
					door:SetCollisionBoundsFromTemplate(door:GetCreationTemplateId())
				end
			end
		end
	end
end

function CloseAdjacentDoors(leverObject)
	local levers = this:GetObjVar("Levers") or {}

	for i, j in pairs(levers) do
		if (j == leverObject) then
			if (i > 1 and i < #levers) then
				levers[i-1]:SendMessage("ToggleLever", true)
				levers[i+1]:SendMessage("ToggleLever", true)
			elseif (i <= 1) then
				levers[#levers]:SendMessage("ToggleLever", true)
				levers[i+1]:SendMessage("ToggleLever", true)
			elseif(i >= #levers) then
				levers[1]:SendMessage("ToggleLever", true)
				levers[#levers-1]:SendMessage("ToggleLever", true)
			end
			return
		end
	end
end

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function()
    	ResetPuzzle()
    	this:ScheduleTimerDelay(TimeSpan.FromMinutes(120), "ResetPuzzle")
    end)

RegisterEventHandler(EventType.Message, "ResetPuzzle", ResetPuzzle)

RegisterEventHandler(EventType.Message, "LeverPulled", 
	function(leverObj)

		local doorLeverTable = this:GetObjVar("DoorLeverTable")
		for door, leverTable in pairs(doorLeverTable) do
			for i, lever in pairs(leverTable) do
				if (lever == leverObj) then
					ToggleDoor(door)
					return
				end
			end
		end

	end)