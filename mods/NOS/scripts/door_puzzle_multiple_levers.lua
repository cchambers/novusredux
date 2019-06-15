--MULTIPLE LEVER DOOR PUZZLE--
--A single door that requires pulling multiple levers to open

function ResetPuzzle()
    --Get puzzle tag
    local puzzleTag = this:GetObjVar("PuzzleTag")
    if (puzzleTag == nil) then
        DebugMessage("No puzzle tag on door_puzzle_multiple_levers ", this)
        success = false
    end

    --Get puzzle objects matching leverPuzzleTag
    local puzzleObjects = FindObjects(SearchObjVar("LeverPuzzleTag",puzzleTag))
    if (puzzleObjects == nil) then 
        DebugMessage("No puzzle objects.")
        success = false
    end

    levers = {}

    for index, puzzleObject in pairs(puzzleObjects) do
        
    end
end