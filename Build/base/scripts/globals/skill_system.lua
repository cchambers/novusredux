--Skill System

--[[
	
]]
function GetSkillPotency(skillAmount)
	if(skillAmount == nil) then return 0 end
	if (skillAmount <= 0) then return 0 end --Natural logarithm of 0 is undefined
	--[[	if(skillAmount <= 1) then return .02 end --Natural log less than 1 is negative
		if(skillAmount == 1) then return .03 end --Natural log of 1 is 0

	return ((math.log(skillAmount) * skillAmount)/math.log(10)) --because math.log(#,x) still returns the natural log regardless of base specified x
	]]
	local potencyFactor = ServerSettings.Skills.SkillPowerFactor or 1.35
	local potBonus = ServerSettings.Skills.SkillPowerBonusK or 2
	return (math.pow(skillAmount + 2, potencyFactor))
	--((.5 + (.005 * skillAmount)) * skillAmount)
end

--Returns Sum to skill as a Fraction of maximum skill sum
function GetSkillPctPotency(skillAmount)
--	--DebugMessage("-----------------Skill Pct Potency")
		
	return(GetSkillPotency(skillAmount)/GetSkillPotency(ServerSettings.Skills.PlayerSkillCap.Single))
	--return((skillAmount * .5 * (skillAmount +1)) /5050)
end

--Return a % value of the current skill vs the skill cap
function GetSkillPct(targMob,skillName,skillVal)
	return skillVal / GetSkillCap(targMob,skillName)
end


function GetSpecificSkillPctPotency(targMob,skillName)
	skillVal = GetSkillLevel(targMob,skillName)

	return(GetSkillPctPotency(skillVal))
end

--Sum to Skill Number
function GetSkillSumLevel(skillAmount)
	return(skillAmount * .5 * (skillAmount+1))
end

--This is important if you set the flag in server settigns that skills have to be learned.
--You would want to check for HasSkill before checking the skill value since not having a skill
--returns a value of from the GetSkillLevel function.
function HasSkill(targMob, skillName)
	local skillTab = SkillData.AllSkills[skillName]
	if (skillTab == nil) then
	 	return false
	end
	
	local mustLearn = ServerSettings.Skills.MustLearnSkills and SkillData.AllSkills[skillName].MustBeLearned
	if(mustLearn == false) then return true end

	local mySkillDict = targMob:GetObjVar("SkillDictionary")	
	if(mySkillDict == nil) then
	 	return false
	end
	
	local mySpecSkillDict = mySkillDict[skillName]
	--DebugMessage(" Dict Present")
	if(mySpecSkillDict == nil) then
		return false
	end
	return true
end

--Legacy Functionality allowing skills to be directly usable separate from the ability icon
function IsDirectUsableSkill(skillName)
	 local skSubTab = SkillData.AllSkills[skillName]
	 if (skSubTab == nil) then return false end
	 if(skSubTab.DirectlyUsable == true) then return true end
	 return false
end

function GetSkillDisplayName(skillName)
	if ( skillName == nil ) then
		LuaDebugCallStack("ERROR: skillName is nil.")
		return "N/A"
	end
	if ( SkillData.AllSkills[skillName] == nil ) then
		LuaDebugCallStack("[skill_system|GetSkillDisplayName] ERROR: skillName '"..skillName.."' does not exist in SkillData.AllSkills")
		return "N/A"
	end
	local dispName = SkillData.AllSkills[skillName].DisplayName
	return dispName
end

function GetSkillDescription(skillName)
	if ( skillName == nil ) then
		LuaDebugCallStack("ERROR: skillName is nil.")
		return "N/A"
	end
	if ( SkillData.AllSkills[skillName] == nil ) then
		LuaDebugCallStack("[skill_system|GetSkillDescription] ERROR: skillName '"..skillName.."' does not exist in SkillData.AllSkills")
		return "N/A"
	end
	local desc = SkillData.AllSkills[skillName].Description
	if (desc == nil) then return "" end
	return desc
end

function IsCombatSkill(skillName)
	return false
end

function IsCombatSupportSkill(skillName)
	return false
end

function GetSkillClass(skillName)
	local myTab = SkillData.AllSkills[skillName]
	if(myTab == nil) then return false end
	local mySkType = myTab.SkillType
	--DebugMessage("Skill Type:" ..tostring(mySkType))
	return mySkType.SkillClass

end

function GetCombatSkillTotal(targMob)	
	--DebugMessage("Checking Combat Skill Total")
	local mySkillsTable = targMob:GetObjVar("SkillDictionary") or {}

	local myTotSkill = 0	
	local mySkTable = {}
	local mySkPlus = 0
	for keys, vals in pairs (mySkillsTable) do
		--DebugMessage("factoring Skill: " .. tostring(keys))
		if(IsCombatSkill(keys)) then
			mySkTable = mySkillsTable[keys]
			mySkPlus = mySkTable.SkillLevel
			if (mySkPlus == nil) then mySkPlus = 0 end
			myTotSkill = myTotSkill + mySkPlus
		end
	end

	return myTotSkill
end

function GetCombatSupportSkillTotal(targMob)
	--DebugMessage("Checking Combat Skill Total")
	local mySkillsTable = targMob:GetObjVar("SkillDictionary") or {}

	local myTotSkill = 0	
	local mySkTable = {}
	local mySkPlus = 0
	for keys, vals in pairs (mySkillsTable) do
		--DebugMessage("factoring Skill: " .. tostring(keys))
		if(IsCombatSupportSkill(keys)) then
			mySkTable = mySkillsTable[keys]
			mySkPlus = mySkTable.SkillLevel
			if (mySkPlus == nil) then mySkPlus = 0 end
			myTotSkill = myTotSkill + mySkPlus
		end
	end

	return myTotSkill
end