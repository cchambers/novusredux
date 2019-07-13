--MULTIPLE LEVER PUZZLE--
--Pull all levers in area to open door
--Not much of a puzzle really...

--Placed on a non-interactive door

function ResetPuzzle ()

	this:SetSharedObjectProperty("IsOpen", false)
	this:SetCollisionBoundsFromTemplate(this:GetCreationTemplateId())

	--Get object puzzle tag
	local puzzleTag = this:GetObjVar("PuzzleTag")
	if (puzzleTag == nil) then
		DebugMessage("No puzzle tag on ", this)
		return
	end

	--Find all objects with matching puzzle tag
	local puzzleObjects = FindObjects(SearchObjVar("PuzzleTag", puzzleTag))
	if (puzzleObjects == nil) then
		DebugMessage("No puzzle objects found")
		return
	end

	--Create table of puzzle_multiple_levers_lever from puzzle objects
	local levers = {}
	for i, puzzleObject in pairs(puzzleObjects) do
		if (puzzleObject ~= this) then
			if (puzzleObject:HasModule("lever")) then
				levers[puzzleObject] = false
			end
		end
	end

	if (levers == {}) then
		DebugMessage("No levers found, puzzle cannot be completed")
		this:SetSharedObjectProperty("IsOpen", true)
		return
	end

	for lever, active in pairs(levers) do
		lever:SendMessage("TryAddLeverListener", this)
		lever:SetSharedObjectProperty("IsActivated", false)
	end

	this:SetObjVar("PuzzleLevers", levers)

end

function CheckPuzzleCompleted()
	local levers = this:GetObjVar("PuzzleLevers") or {}

	local puzzleSolved = true

	for leverObj, activated in pairs(levers) do
		if not(activated) then
			puzzleSolved = false
		end
	end

	if (puzzleSolved) then
		CompletePuzzle()
	end
end

--Open the door, start timer for puzzle reset
function CompletePuzzle()
	this:SetSharedObjectProperty("IsOpen", true)
	this:ClearCollisionBounds()
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(30), "ResetPuzzle")
end

RegisterEventHandler(EventType.ModuleAttached, GetCurrentModule(),ResetPuzzle)

RegisterEventHandler(EventType.Message, "LeverPulled", 
	function(leverObj, activated)
		local levers = this:GetObjVar("PuzzleLevers") or {}
		if (levers[leverObj] ~= nil) then
			levers[leverObj] = activated
			this:SetObjVar("PuzzleLevers", levers)
			CheckPuzzleCompleted()
		end

	end)

RegisterEventHandler(EventType.Timer, "ResetPuzzle", ResetPuzzle)