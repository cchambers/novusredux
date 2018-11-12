STAT_GAIN_DELAY = 10

-- the order of these is very important.
StatGainStates =
{
	"Down", --1
	"Lock", --2
	"Up",   --3
}

--- Gets all the data saved on the mobileObj representing each stat's state, (Up(3)/Lock(2)/Down(1))
-- @param mobileObj
-- @return luaTable
function GetStatGainStatus(mobileObj)
	return VerifyStatGainStatusTable( mobileObj:GetObjVar("StatGainStatus") )
end

function SaveStatGainStatus(mobileObj, gainStatus)
	if ( mobileObj and gainStatus ) then
		mobileObj:SetObjVar("StatGainStatus", gainStatus)
	end
end

function VerifyStatGainStatusTable(gainStatus)
	if ( gainStatus ~= nil and #gainStatus == 2 ) then return gainStatus end
	-- If things get out of hand, check that [1] and [2] are tables?
	return {
		{}, -- [1] down,
		{}, -- [2] locked,
		-- if a stat isn't in the table it means that stat is in Up(3) state.
	}
end

--- Given a gainStatus table and a statName, will return the index number representing the current state of the stat.
-- @param gainStatus luaTable Return value of GetStatGainStatus()
-- @param statName string The stat name to get, these are full stat names, not abreviations.
-- @return double Index of current stat.
function GetStatGainStateIndex(gainStatus, statName)
	if ( gainStatus ) then
		if ( gainStatus[1] and gainStatus[1][statName] ) then return 1 end --down
		if ( gainStatus[2] and gainStatus[2][statName] ) then return 2 end --locked
	end
	return 3 -- up
end

--- Exactly like GetStatGainStateIndex but returns a string of the state, not the index.
-- @param gainStatus luaTable Return value of GetStatGainStatus()
-- @param statName string The stat name to get, these are full stat names, not abreviations.
-- @return string State of current stat.
function GetStatGainState(gainStatus, statName)
	return StatGainStates[GetStatGainStateIndex(gainStatus, statName)]
end

--- Set the gain state of a stat
-- @param gainStatus luaTable Return value of GetStatGainStatus()
-- @param statName string The stat name to get, these are full stat names, not abreviations.
-- @param newStateIndex double The index representing the new state this stat should be set to
-- @return luaTable The altered gainStatus
function SetStatGainState(gainStatus, statName, newStateIndex)
	gainStatus = gainStatus or {{},{}}

	-- remove old setting if pertinent
	local oldStateIndex = GetStatGainStateIndex(gainStatus, statName)
	if ( oldStateIndex ~= 3 and gainStatus[oldStateIndex] ) then
		gainStatus[oldStateIndex][statName] = nil 
	end

	-- on state Up(3) we don't have to set anything
	if ( newStateIndex ~= 3 ) then
		-- set new setting
		gainStatus[newStateIndex][statName] = true
	end

	return gainStatus
end

--- Returns a random stat for a mobile that is A) in Down state, and B) greater than server settings IndividualStatMin
-- @param mobileObj
-- @param gainStatus(optional) Value from GetStatGainStatus(), read from mobile if not provided
-- @return string The (non-abbreviated) stat name, nil if nothing found.
function GetRandomLosableStat(mobileObj, gainStatus)
	gainStatus = gainStatus or GetStatGainStatus(mobileObj)
	if ( gainStatus and gainStatus[1] ) then
		local list = {}
		for stat,val in pairs(gainStatus[1]) do
			if ( GetBaseStatValue(mobileObj, stat) > ServerSettings.Stats.IndividualStatMin ) then
				table.insert(list, stat)
			end
		end
		if ( #list > 0 ) then
			return list[math.random(1,#list)]
		end
	end
	return nil
end

function ToggleStatGainState(mobileObj, statName)
	local gainStatus = GetStatGainStatus(mobileObj)

	local newIndex = (GetStatGainStateIndex(gainStatus, statName) % #StatGainStates) + 1

	SaveStatGainStatus(mobileObj, SetStatGainState(gainStatus, statName, newIndex))
end

function FixStatTotalMax(mobileObj, gainStatus, statsTotal)
	gainStatus = gainStatus or GetStatGainStatus(mobileObj)
	statsTotal = statsTotal or GetTotalBaseStats(mobileObj)

	-- let immortals have crazy stats if they want.
	if ( IsImmortal(mobileObj) ) then return statsTotal end

	local tries = 0
	local maxTries = 50

	while( statsTotal > ServerSettings.Stats.TotalPlayerStatsCap ) do
		if ( tries > maxTries ) then
			-- we've hit the limit.
			LuaDebugCallStack("Attempted to fix mobile ("..tostring(mobileObj)..") stat total cap and hit max tries (maxTries:"..maxTries.."), this should only be a problem if it keeps occuring.")
			return statsTotal
		end
		local removeStat = GetRandomLosableStat(mobileObj, gainStatus)
		if not( removeStat ) then
			-- need to pick any random stat now since there were none in the down state we could use.
			local list = {}
			for stat,data in pairs(StatStats) do
				-- skip stats in the down state since we've already check them.
				if ( not gainStatus[1] or not gainStatus[1][stat] ) then
					-- they only count if they are > than the absolute minimum
					if ( GetBaseStatValue(mobileObj, stat) > ServerSettings.Stats.IndividualStatMin ) then
						table.insert(list, stat)
					end
				end
			end
			if ( #list > 0 ) then
				removeStat = list[math.random(1,#list)]
			end
		end
		-- if STILL no removeable stat (which seems highly unlikely..) then just end it here.
		if not ( removeStat ) then return statsTotal end

		-- remove 1 in the stat,
		SetStatByName(mobileObj, removeStat, GetBaseStatValue(mobileObj, removeStat) - 1)
		statsTotal = statsTotal - 1

		-- up our tries (prevent a run away loop)
		tries = tries + 1
	end

	return statsTotal
end

--- Gain 1 in a stat, fixing total cap and removing stats in Down(1) state along the way.
-- @param mobileObj
-- @param statName string The stat name to get, these are full stat names, not abreviations.
-- @param gainStatus(optional) luaTable Return value of GetStatGainStatus(), will be read from mobileObj if not provided
-- @param currentValue double(optional) The current value of the stat, if not provided will be read from mobileObj
function GainStatValue(mobileObj, statName, gainStatus, currentValue)
	gainStatus = gainStatus or GetStatGainStatus(mobileObj)

	local removeStat = nil
	local statsTotal = GetTotalBaseStats(mobileObj)

	if ( statsTotal > ServerSettings.Stats.TotalPlayerStatsCap ) then
		-- we have a problem here..
		statsTotal = FixStatTotalMax(mobileObj, gainStatus, statsTotal)
	end

	-- only continue if this stat is set to up.
	if ( GetStatGainState(gainStatus, statName) ~= "Up" ) then return end

	if ( statsTotal >= ServerSettings.Stats.TotalPlayerStatsCap ) then
		removeStat = GetRandomLosableStat(mobileObj, gainStatus)
		-- currently at cap, can only continue given we have a stat that can be removed
		if ( removeStat == nil ) then return end
	end

	currentValue = currentValue or GetBaseStatValue(mobileObj, statName)
	local newValue = math.clamp(
		ServerSettings.Stats.IndividualStatMin,
		ServerSettings.Stats.IndividualPlayerStatCap,
		currentValue + 1
	)

	-- no reason to continue
	if ( currentValue == newValue ) then return end

	-- loose stat if applicable
	if ( removeStat ) then
		SetStatByName(mobileObj, removeStat, GetBaseStatValue(mobileObj, removeStat) - 1)
	end

	-- set the new stat value
	SetStatByName(mobileObj, statName, newValue)

	if ( mobileObj:IsPlayer() ) then
		mobileObj:SystemMessage("You have gained ".. statName .. ". Now ".. newValue, "event")
	end
end

function StatGainByChance( mobileObj, statName, chance, statValue )
	
	if ( Success(chance) and not mobileObj:HasTimer("StatGainTimer") ) then
		
		local gainStatus = GetStatGainStatus(mobileObj)

		GainStatValue(mobileObj, statName, gainStatus, statValue)

		mobileObj:ScheduleTimerDelay(TimeSpan.FromSeconds(STAT_GAIN_DELAY), "StatGainTimer")
	end
	
end