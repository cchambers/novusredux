--- Check if a skillName is valid
-- @param skillName string
-- @return true if valid skillName
function IsValidSkill(skillName)
	local valid = ( SkillData.AllSkills[skillName] ~= nil )
	if not( valid ) then
		-- skill doesn't exist, this shouldn't happen.
		LuaDebugCallStack("[skills]ERROR: Invalid skillName '"..tostring(skillName).."' provided.")
	else
		-- disabled skills are also invalid.
		valid = ( SkillData.AllSkills[skillName].Disabled ~= true )
	end
	return valid
end

--- Retrieve the skill dictionary for a mobile
-- @param mobileObj
-- @return Skill Dictionary for mobileObj or empty table if not exist
function GetSkillDictionary(mobileObj)
	if ( mobileObj == nil ) then
		LuaDebugCallStack("[Skills] Nil mobileObj provided.")
		return {}
	end
	return mobileObj:GetObjVar("SkillDictionary") or {}
end

--- Convenience function to prevent multiple calls into the object database
-- @param skillName string
-- @param skillDictionary lua table, return value from GetSkillDictionary()
-- @return skill level or 0
function GetSkillLevelFromDictionary(skillName, skillDictionary)
	if ( skillDictionary and skillDictionary[skillName] ) then
		return skillDictionary[skillName]["SkillLevel"] or 0
	end
	return 0
end

--- Get the skill level for the given mobile.
-- @param mobileObj
-- @param skillName string
-- @param skillDictionary(optional) provide to prevent multiple calls to GetSkillDictionary
-- @param real(optional) boolean, pass true to get the real skill value without bonuses.
-- @return mobileObj skill level for skillName
function GetSkillLevel(mobileObj, skillName, skillDictionary, real)
	-- retrieve the entry
	local skillTable = GetSkillTable(mobileObj, skillName, skillDictionary)
	-- retrieve the value from the entry or 0 if no value (nil)
	local skillLevel = skillTable.SkillLevel or 0
	if ( real ) then
		return skillLevel
	else
		return skillLevel + (skillTable.SkillBonus or 0)
	end
end

--- Retrieves the skill table for skillName from the mobileObj's SkillDictionary
-- @param mobileObj
-- @param skillName
-- @param skillDictionary(optional) provide to prevent multiple calls to GetSkillDictionary
-- @return skill table for skillName or empty table if data doesn't exist.
function GetSkillTable(mobileObj, skillName, skillDictionary)
	skillDictionary = skillDictionary or GetSkillDictionary(mobileObj)
	-- return the table or empty table if no entry.
	return skillDictionary[skillName] or {}
end

--- Set the skill dictionary for a mobile
-- @param mobileObj
-- @param skillDictionary lua table
function SetSkillDictionary(mobileObj, skillDictionary)
	if(mobileObj == nil or mobileObj:IsValid() == false) then return end
	mobileObj:SetObjVar("SkillDictionary", skillDictionary)
end

--- Gets the cap of a skill, normally it's ServerSettings but if a player has set an artificial cap this will compensate.
-- @param mobileObj
-- @param skillName
-- @param skillDictionary(optional) provide to prevent multiple calls to GetSkillDictionary
-- @return value of mobileObj skill cap for skillName
function GetSkillCap(mobileObj, skillName, skillDictionary)
	local skillTable = GetSkillTable(mobileObj, skillName, skillDictionary)

	if ( skillTable.SkillCap == nil ) then
		-- artificial cap not specified.
		return ServerSettings.Skills.PlayerSkillCap.Single
	end

	-- prevent the skillTable from beating the ServerSettings
	return math.min(skillTable.SkillCap, ServerSettings.Skills.PlayerSkillCap.Single)
end

--- Gets the highest value a mobileObj has reached in a skill
-- @param mobileObj
-- @param skillName
-- @param skillDictionary(optional) provide to prevent multiple calls to GetSkillDictionary
-- @return highest value mobileObj reached in skillName
function GetSkillMaxAttained( mobileObj, skillName, skillDictionary )
	-- retrieve the entry
	local skillTable = GetSkillTable(mobileObj, skillName, skillDictionary)
	-- retrieve the value from the entry or their current skill if it doesn't exist.
	return skillTable.SkillMaxAttained or GetSkillLevel(mobileObj, skillName, skillDictionary)
end


--- Get the display name (pretty name) of a skill
-- @param skillName string
-- @return Display name of skillName
function GetSkillDisplayName( skillName )
	if ( IsValidSkill(skillName) ) then
		return SkillData.AllSkills[skillName].DisplayName or skillName
	end
	return skillName
end

--- Get the description of a skill
-- @param skillName string
-- @return Description of skillName
function GetSkillDescription( skillName )
	local description = ""
	if ( IsValidSkill(skillName) ) then
		description = SkillData.AllSkills[skillName].Description or description
	end
	return description
end

--- Get the cumulative value of all skills for a mobileObj
-- @param mobileObj
-- @param skillDictionary(optional) provide to prevent multiple calls to GetSkillDictionary
-- @return skillTotal
function GetSkillTotal( mobileObj, skillDictionary )
	skillDictionary = skillDictionary or GetSkillDictionary(mobileObj)
	local total = 0
	
	-- a convenience variable that will be reused in our iteration
	local skillLevel = 0
	for key,val in pairs (skillDictionary) do
		if ( SkillData.AllSkills[key] ~= nil ) then
			-- if skip isn't set or is false
			if not( SkillData.AllSkills[key].Skip ) then
				skillLevel = skillDictionary[key].SkillLevel or 0
				-- finally take our effective skillLevel value and add it onto the total.
				total = total + skillLevel
			end
		end
	end
	return total
end

--- Check if a mobileObj can gain to a specific level of skillName, more raw function that only checks against skill caps. Assumes skillName is valid.
-- @param mobileObj
-- @param skillName string
-- @param newSkillLevel double(optional) the number value of skillName to gain to, if not provided will add current level to ServerSettings.Skills.GainAmount
-- @param skillDictionary(optional) provide to prevent multiple calls to GetSkillDictionary
-- @return true if mobileObj can gain in skillName
function CanGainSkill( mobileObj, skillName, newSkillLevel, skillDictionary )
	skillDictionary = skillDictionary or GetSkillDictionary(mobileObj)
	local skillTable = GetSkillTable(mobileObj, skillName, skillDictionary)
	local oldSkillLevel = skillTable.SkillLevel or 0
	newSkillLevel = newSkillLevel or math.round(oldSkillLevel + ServerSettings.Skills.GainAmount, 1)
	-- check if new skill would breach SINGLE skill cap
	if ( newSkillLevel <= GetSkillCap(mobileObj, skillName, skillDictionary) ) then
		local difference = math.round(newSkillLevel - oldSkillLevel, 1)
		-- check if new skill would breach TOTAL skill cap
		return ( GetSkillTotal(mobileObj, skillDictionary) + difference <= ServerSettings.Skills.PlayerSkillCap.Total )
	end
	return false
end

--- Validate a skillName and a mobile's ability to gain in that skill, higher level checking if skill can be gained and takes more mobile specifics into account. This calls CanGainSkill internally.
-- @param mobileObj
-- @param skillName string
-- @return true if mobileObj can gain in skillName
function ValidateSkillGain( mobileObj, skillName )
	-- sanity check provided parameters
	if (skillName == nil) then
		LuaDebugCallStack("[skills] ERROR: nil skillName provided to ValidateSkillGain")
		return false
	end

	-- can't gain while dead.
	if( IsDead(mobileObj) ) then return false end

	-- mobile explicitly not alloud to gain skills.
	if( mobileObj:HasObjVar("NoSkillGain") ) then return false end

	-- invalid skill
	if not( IsValidSkill(skillName) ) then return false end

	-- prevent skill gain spam attempts from working.
	if ( mobileObj:HasTimer("SkillGainCheckTimer|"..tostring(skillName)) ) then return false end

	return CanGainSkill(mobileObj, skillName)
end

--- Helper function for giving us a number to use toward difficulty
-- @param value Value to check against difficulty
-- @param min Minimum difficulty
-- @param max Maximum difficulty
function SkillValueMinMax(value, min, max)
	return ( value - min ) / ( max - min )
end

--- Give a success / failure on a skill by skillName and a difficulty setting, also does a gain chance check.
-- note: This is useful for 'general' skill checking.
-- @param mobileObj
-- @param skillName string
-- @param difficulty double(optional) will use skillLevel as difficulty if not provided.
-- @param skipGains boolean(optional) If true, no skill/stat gains will be calculated.
-- @return true if success
function CheckSkill( mobileObj, skillName, difficulty, skipGains )
	local skillLevel = GetSkillLevel(mobileObj, skillName, nil, true)
	if ( difficulty == nil ) then
		difficulty = skillLevel
	end
		
	if (mobileObj:GetObjVar("NoGains")) then
		skipGains = true
	end

	return CheckSkillChance( mobileObj, skillName, skillLevel, SkillValueMinMax( skillLevel, difficulty - 25, difficulty + 25 ), skipGains )
end

--- Gives a success / failure on a skill by skillLevel and success chance, also does a gain check.
-- @param mobileObj
-- @param skillName string
-- @param skillLevel double(optional) if not provided, the skill level will be read from the mobileObj
-- @param chance double(optional) Percent based between 0 and 1, if not provided it will use the skill level as the percent, for example 40 skill is 40% chance.
-- @param skipGains boolean(optional) If true, no skill/stat gains will be calculated.
-- @return true if success
function CheckSkillChance( mobileObj, skillName, skillLevel, chance, skipGains )
	-- cache some global variables for quicker indexing
	local ss = ServerSettings

	local skillDictionary = GetSkillDictionary(mobileObj)
	-- this skill level is the one used in the success chance calculation (ie skill + skillbuffs)
	skillLevel = skillLevel or GetSkillLevel(mobileObj, skillName, skillDictionary)

	if ( chance == nil ) then
		chance = 1 - ( ( ss.Skills.PlayerSkillCap.Single - math.max(skillLevel, 0.1) ) / ss.Skills.PlayerSkillCap.Single )		
	end

	-- allow skipping gains from a parameter, and disallow NPCs from gaining at all, and disallow gains at a campfire.
	if ( not skipGains and IsPlayerCharacter(mobileObj) ) then
		-- we need the REAL skill level (minus any buffs) to do an accurate gain check 
		-- (where as non-real is used for our chance)
		local skillTable = skillDictionary[skillName] or {}
		skillTable.SkillLevel = skillTable.SkillLevel or 0.1

		-- early exit cause anti macro stopped us
		if not( AntiMacroAllow(mobileObj, skillName, skillLevel) ) then
			return Success(chance)
		end

		local effects = {"LowVitality"}
		-- include campfire as a blocking gain effect, unless the skill alows it.
		if not( SkillData.AllSkills[skillName].AllowCampfireGains == true ) then effects[2] = "Campfire" end
		local mobileEffects = mobileObj:GetObjVar("MobileEffects") or {}
		local preventGain = HasAnyMobileEffect(mobileObj, effects, mobileEffects)
		
		-- only continue skill check if there is room to skill gain
		if ( skillTable.SkillLevel < (skillTable.SkillCap or ss.Skills.PlayerSkillCap.Single) ) then
			
			-- generate the gain chance
			local gc = GenerateGainChance(skillTable.SkillLevel, chance, SkillData.AllSkills[skillName].GainFactor or 1)

			if ( gc > 0 ) then
				-- check preventGain all the way down here so we can only hit the user with a message when they would have gained.
				if ( preventGain ) then
					if not( mobileObj:HasTimer("GainWarn") ) then
						local hasCampfireEffect, hasVitalityEffect = ContainsMobileEffect(mobileEffects, "Campfire"), ContainsMobileEffect(mobileEffects, "LowVitality")
						
						if ( hasCampfireEffect ) then
							mobileObj:SystemMessage("You feel too at ease to improve your skills.","info")						
						elseif ( hasVitalityEffect ) then
							mobileObj:SystemMessage("You are too exhausted to improve your skills.","info")
						end
						
						mobileObj:ScheduleTimerDelay(TimeSpan.FromSeconds(10),"GainWarn")
					end
					return Success( chance )
				end

				-- apply a bonus for having already gained in the skill past this point before
				if ( skillTable.SkillLevel < (skillTable.SkillMaxAttained or 0) ) then
					gc = gc * ServerSettings.Skills.RegainBonusMultiplier
				end

				if ( ContainsMobileEffect(mobileEffects, "PowerHourBuff") ) then
					gc = gc * ServerSettings.Skills.PowerHourMultiplier
				end
				
				SkillGainByChance( mobileObj, skillName, skillTable.SkillLevel, gc * ServerSettings.Skills.GainFactor )
			end
		end

		-- save cpu cycles when there is zero chance of gaining.
		if ( not preventGain and not SkillData.AllSkills[skillName].NoStatGain == true ) then
			local m = math
			local stat = nil
			local i = m.random(1,2)
			if ( i == 1 ) then
				-- try to gain for the specific stat for this skill
				stat = SkillData.AllSkills[skillName].PrimaryStat or "Strength"
			else
				-- gain chance for the skill primary stat and also a skill gain for 'Secondary' stats (they can be gained from any stat gaining skills)
				stat = ss.Stats.AllSkillStats[m.random(1,#ss.Stats.AllSkillStats)]
			end

			local realStatLevel = GetBaseStatValue(mobileObj, stat)
			if (
				realStatLevel < ss.Stats.IndividualPlayerStatCap
				and
				-- "arbitrary check to insure that players stats are just scaling to some degree with the age of the character a little bit" - Miphon
				( i ~= 2 or (realStatLevel*2 <= skillTable.SkillLevel) )
			) then
				-- (increasing difficulty near stat cap)
				local gainFactor = m.max(0.025, 1 - (realStatLevel / ss.Stats.TotalPlayerStatsCap))
				
				if ( StatStats[stat] and StatStats[stat].GainFactor ) then
					gainFactor = StatStats[stat].GainFactor * gainFactor
				else
					gainFactor = 1 * gainFactor
				end

				-- multiply realStatLevel by the ratio of skillMax:statMax since GenerateGainChance works off of skillMax server settings
				local gc = GenerateGainChance(realStatLevel * (ss.Skills.PlayerSkillCap.Single/ss.Stats.IndividualPlayerStatCap), chance, gainFactor)
				if ( gc > 0 ) then
					--mobileObj:NpcSpeech(stat.." Gain Chance: "..(gc * ss.Stats.GainFactor))
					StatGainByChance( mobileObj, stat, gc * ss.Stats.GainFactor, realStatLevel )
				end
			end
		end
	end

	--mobileObj:NpcSpeech("Chance: "..chance)

	return Success( chance )
end

--- helper function extracted to allow application for stats/skills
-- @param gainFactor double(optional) defaults to 1
-- @param gc double(optional) base gain factor for equation, defaults to 0.5
-- @return decimal based percent double
function GenerateGainChance(level, chance, gainFactor, gc)
	-- if you have no chance at success or full chance at success, can no longer gain
	if (chance <= 0 or chance >= 1) then return 0 end
	local ss = ServerSettings.Skills

	gainFactor = gainFactor or 1
	gc = gc or 0.5

	gc = gc + ( ( ss.PlayerSkillCap.Single - level ) / ss.PlayerSkillCap.Single )

	--gc = gc + ( ( - ( 1.75 * chance - 0.83 ) ^ 2 ) + 0.85 ) * 0.85

	--gc = gc / 3

	gc = gc * gainFactor

	gc = math.max(0.01, gc / 1.75)
	gc = gc * 0.9

	local mod = 105
	if ( level > ss.HigherLevelGains.DifficultyThreshold ) then
		mod = 300
	elseif ( level < ss.LowerLevelGains.DifficultyThreshold ) then
		mod = 25
	end

	gc = gc *  ( ( ss.PlayerSkillCap.Single - (level - (ss.PlayerSkillCap.Single * 0.8) ) ) / mod )
	--DebugMessage("gc: " .. gc)
	return gc
end

function AntiMacroAllow(mobileObj, skillName, skillLevel)
	-- return false to prevent skill gain via anti macro code
	return true
end

function AntiMacroDeplete(mobileObj, skillName, skillLevel)
	-- implement anti macro deplete code here
end

--- Performs a skill gain on the mobileObj, given it was a success the mobile will move up in skill level.
-- @param mobileObj
-- @param skillName (should be the real skill level excluding all buffs and whatnot) string
-- @param skillLevel double Real skill level, if not provided it will be read from mobileObj
-- @param chance double
function SkillGainByChance( mobileObj, skillName, skillLevel, chance )
	if not( IsValidSkill(skillName) ) then return end
	if ( Success(chance) ) then
		-- location based anti macro code
		AntiMacroDeplete(mobileObj, skillName, skillLevel)
		-- trigger our anti gain spam
		mobileObj:ScheduleTimerDelay(ServerSettings.Skills.AntiMacro.TimeSpanBetweenGains, "SkillGainCheckTimer|"..tostring(skillName))
		-- start with default gain amount
		local gainAmount = ServerSettings.Skills.GainAmount
		-- modify the gain amount depending if certain criteria is satisfied
		if ( skillLevel < ServerSettings.Skills.LowerLevelGains.UpperThreshold ) then
			if ( skillLevel < ServerSettings.Skills.LowerLevelGains.LowerThreshold ) then 
				gainAmount = ServerSettings.Skills.LowerLevelGains.LowerThresholdGainAmount
			else
				gainAmount = ServerSettings.Skills.LowerLevelGains.UpperThresholdGainAmount
			end
		end
		local newSkillLevel = skillLevel + gainAmount
		-- finally adjust the skill by the gain amount.
		SetSkillLevel(mobileObj, skillName, newSkillLevel, true)
	end
end

--- Set a mobile's skill level to a provided value
-- @param mobileObj
-- @param skillName string
-- @param newSkillLevel double value to set skillName to
-- @param gained boolean (optional) if true will alert players of gains/unlocks and cache LastSkillGain, will also enforce CanGainSkill(mobileObj, skillName, newSkillLevel)
function SetSkillLevel( mobileObj, skillName, newSkillLevel, gained )
	if not( IsValidSkill(skillName) ) then return end

	local skillDictionary = GetSkillDictionary(mobileObj)

	if ( gained and not(CanGainSkill(mobileObj, skillName, newSkillLevel, skillDictionary)) ) then return end
	
	local skillTable = GetSkillTable(mobileObj, skillName, skillDictionary)

	-- hold onto old skill level for later to calculate the difference for information purposes
	local oldSkillLevel = skillTable.SkillLevel or 0
	-- calculate new skill level, staying above 0 but under skill cap (rounded to nearest tenth)
	-- modifying the skillTable with the new calculated skill value
	skillTable.SkillLevel = math.round(math.clamp(newSkillLevel, 0, GetSkillCap(mobileObj, skillName, skillDictionary)), 1)

	-- on gains, cache the moment the last gain took place (Why is this even necessary?)
	if(gained == true) then skillTable.LastSkillGain = ServerTimeMs() end

	-- assign the updated skillTable to the skillDictionary, containing our new level and if gained, new last gain time
	skillDictionary[skillName] = skillTable

	-- update the mobile's skill dictionary with our modified skillDictionary
	SetSkillDictionary(mobileObj, skillDictionary)

	mobileObj:SendMessage("OnSkillLevelChanged", skillName)

	--Check if player still meets the requirement to use skill titles after skill level changed
	CheckTitleRequirement(mobileObj, skillName)

	-- TODO: Just store skills locally for easy access (What does this mean? 9/13/17)
	if( mobileObj:IsPlayer() ) then
		if ( gained ) then
			local difference = math.round(newSkillLevel - oldSkillLevel, 1)
			if(difference > 0) then
				mobileObj:SystemMessage("You have gained skill in " .. GetSkillDisplayName(skillName) .. ". Now " .. tostring(skillTable.SkillLevel) .. " (+"..tostring(difference)..")","info")
			else
				mobileObj:SystemMessage("You have lost skill in " .. GetSkillDisplayName(skillName) .. ". Now " .. tostring(skillTable.SkillLevel) .. " ("..tostring(difference)..")","info")
			end
		end
	end

	-- check for skill achievement
	CheckAchievementStatus(mobileObj, "Skill", skillName,newSkillLevel, {TitleCheck = "Skill"})
end

function GetSkillUpdateVect(mobileObj,skillName,skillDict)
	local skillLevel = GetSkillLevelFromDictionary(skillName, skillDict)
	local curUpdate = {	
		skillName,
		math.floor(skillLevel),
		ServerSettings.Skills.PlayerSkillCap.Single,
		(skillLevel - math.floor(skillLevel)) * 10,
		10,
		mobileObj }		

	return curUpdate
end

function UpdateClientSkill(playerObj,mobileObj,skillName)
	if( not(playerObj:IsPlayer()) ) then
		return
	end	

	if skillName ~= nil and not(IsValidSkill(skillName)) then
		return
	end

	local skillDict = mobileObj:GetObjVar("SkillDictionary")
	if( skillDict == nil ) then
		return
	end
	
	-- send all of them
	if( skillName == nil ) then
		local skillUpdates = {}
		for skillName, skillEntry in pairs(SkillData.AllSkills) do
			if( skillEntry["Skip"]~=true) then								
				local skillUpdate = GetSkillUpdateVect(mobileObj,skillName,skillDict)
				table.insert(skillUpdates,skillUpdate)
			end
		end

		playerObj:SendClientMessage("UpdateSkills", skillUpdates)
	-- send just the one specified
	else
		local skillData = SkillData.AllSkills[skillName]
		if( skillData ~= nil ) then
			if( skillData["Skip"]~=true) then
				local skillUpdate = GetSkillUpdateVect(mobileObj,skillName,skillDict)
				playerObj:SendClientMessage("UpdateSkills", {skillUpdate})
			end
		end
	end
end