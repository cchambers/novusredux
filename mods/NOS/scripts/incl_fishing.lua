--DFB TODO: Factor in different fishing rods, fishing bonuses, instant fishing abilities, and the skill/size of the fish.
BASE_SCHOOL_WEIGHT = 1200
CATCH_SKILL_FACTOR = 45
DEFAULT_SCHOOl_OF_FISH_TEMPLATE = "fish_school_barrel"
SCHOOL_OF_FISH_RANGE = 5
BASE_REEL_CHANCE = 20 

-- finds the first dynamic resource region entry this object applies to and return the info
function GetFishResourceTable(fishController,targetLoc)
    if not(fishController) then
    	return {}
    end

    local fishResourceRegions = fishController:GetObjVar("FishRegions")
	if not(fishResourceRegions) then
    	return {}
    end

	for i,regionFish in pairs(fishResourceRegions) do
		--DebugMessage("CHECKING REGION",tostring(regionFish.Region))
		if(regionFish.Region == nil or regionFish.Region == "Global" or IsLocInRegion(targetLoc,regionFish.Region)) then
			return regionFish.Fish
		end
	end

	return {}
end

function GetTotalFishWeight(fishResourceTable,minSkillCutoff)
	-- -1 means include all fish
	minSkillCutoff = minSkillCutoff or -1

	local returnWeight = 0	
	for fishName,fishWeight in pairs(fishResourceTable) do
		local minSkill = AllFish[fishName].MinSkill
		if(minSkill > minSkillCutoff) then
			returnWeight = returnWeight + fishWeight
		end
	end
	--DebugMessage("--returnWeight is "..tostring(returnWeight))
	return returnWeight
end

function GetSchoolOfFishTypeRoll(fishResourceTable,minSkillCutoff)	
	-- -1 means include all fish
	minSkillCutoff = minSkillCutoff or -1

	local totalFishWeight = GetTotalFishWeight(fishResourceTable,minSkillCutoff)
	local roll = math.random() * totalFishWeight
	--DebugMessage("--roll is "..tostring(roll))
	local count = 0
	for fishType,fishWeight in pairs(fishResourceTable) do
		local minSkill = AllFish[fishType].MinSkill		
		if (minSkill > minSkillCutoff) then
			--DebugMessage("--CHECKING: ",tostring(roll),tostring(count),tostring(count + fishWeight))
			if (roll >= count and roll < (count + fishWeight) and AllFish[fishType].SchoolTemplate ~= nil) then
				return AllFish[fishType].SchoolTemplate
			else
				count = count + fishWeight
			end
		end
	end
	return nil
end

function GetFishSize()
	local totalSizeWeight = 0	
	for fishSize,sizeWeight in pairs(ServerSettings.Resources.Fish.SizeChance) do
		totalSizeWeight = totalSizeWeight + sizeWeight
	end

	local fishSizeRoll = math.random() * totalSizeWeight

	local count = 0
	for fishSize,sizeWeight in pairs(ServerSettings.Resources.Fish.SizeChance) do
		if (fishSizeRoll >= count) and (fishSizeRoll < sizeWeight + count ) then
			return fishSize
		else
			count = count + sizeWeight
		end
	end
end

function TestFishSize()
	for i=1,30 do
		DebugMessage("Fish found to be "..tostring(GetFishSize()))
	end
end

function IsValidFish(fishName)
	for i,j in pairs(AllFish) do
		if (i == fishName) then
			return true
		end
	end
	return false
end

function GetNearbySchoolOfFish(targetLoc)
	if (targetLoc == nil) then return end
	--DebugMessage(tostring(targetLoc).." is targetloc")
	return FindObject(SearchMulti({SearchRange(targetLoc,SCHOOL_OF_FISH_RANGE),SearchHasObjVar("SchoolOfFish")}))
    --DebugMessage("Fish found  " ..DumpTable(schoolsOfFish))
end

--returns the fish that you caught.
function GetFishRoll(fishResourceTable)
	local roll = 0

	local weight = GetTotalFishWeight(fishResourceTable)
	--DebugMessage("Total weight is "..tostring(weight))
	if (initialRoll ~= nil) then 
		roll = initialRoll
	else 
		roll = math.random() * weight
	end
	--pick the fish
	local count = 0
	for fishName,fishWeight in pairs(fishResourceTable) do

		--DebugMessage("fish is "..tostring(fishTable.DisplayName))
		--DebugMessage("roll is "..tostring(roll))
		--DebugMessage("count is "..tostring(count))
		--DebugMessage("CHECK: ",roll > count,roll < fishTable.Weight + count )
		if (roll >= count) and (roll < fishWeight + count ) then
			local fish = {}
			fish.Template = AllFish[fishName].Template
			fish.Size = GetFishSize()
			fish.DisplayName = AllFish[fishName].DisplayName
			fish.MinSkill = AllFish[fishName].MinSkill
			return fish
		else
			count = count + fishWeight
		end
	end
	return nil
end

function GetFishSuccessRoll(user,fishInfo)
	if (fishInfo == nil) then return false end

	-- add some difficulty based on size (Size 5 fish adds 20 to min skill)
	local minSkill = fishInfo.MinSkill + ((fishInfo.Size - 1)*5)

	-- we skip the skill gain here because it would be awkward to gain here
	return CheckSkill( user, "FishingSkill", minSkill, true )
end