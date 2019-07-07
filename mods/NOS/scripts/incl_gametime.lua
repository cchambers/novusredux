timeController = nil
function GetTimeController()
	if( this:HasModule("shard_time_controller") ) then
		return this
	end

	if( timeController == nil or not timeController:IsValid() ) then
		timeController = FindObjectWithTag("TimeController")
	end

	return timeController
end

function InGameTimeSpan(startTime,endTime)
	local currentTime = GetGameTimeOfDay()

	if (startTime == endTime) then
		DebugMessage("[incl_gametime|InGameTimeSpan] ERROR: startTime is equal to endTime!")
		return false
	elseif endTime % 24 < startTime then
		return endTime % 24 >= currentTime or currentTime > startTime
	else
		return endTime % 24 >= currentTime and currentTime > startTime
	end
end

--DFB HACK/TODO: This may vary across maps.
function IsNightTime()
	return GetGameTimeOfDay() < ServerSettings.Time.DaylightStartOffset 
				or GetGameTimeOfDay() > (ServerSettings.Time.DaylightStartOffset + GetGameDaylightDuration())
end

function IsDayTime()
	return not IsNightTime()
end

--gets the number of real world minutes to ingame midnight
function RealMinutesToMidnight()
	local currentTime = GetGameTimeOfDay()
	return ((24 - currentTime)/24)*60
end

function GetDaylightDurationSecs()
	local controller = GetTimeController()
	local daylightDurationSecs = ServerSettings.Time.DayDuration * 60
	if( controller ~= nil and controller:HasObjVar("DaylightDurationSecs")) then
		daylightDurationSecs = controller:GetObjVar("DaylightDurationSecs")
	end

	return daylightDurationSecs
end

function GetNighttimeDurationSecs()
	local controller = GetTimeController()
	local nighttimeDurationSecs = 0
	if (ServerSettings.Time.DayNightCycleEnabled) then
		nighttimeDurationSecs = ServerSettings.Time.NightDuration * 60
		if( controller ~= nil and controller:HasObjVar("NighttimeDurationSecs")) then
			nighttimeDurationSecs = controller:GetObjVar("NighttimeDurationSecs")
		end
	end

	return nighttimeDurationSecs
end

function GetTotalDayDurationSecs()
	return GetDaylightDurationSecs() + GetNighttimeDurationSecs()
end

function GetTimeOffset()
	local controller = GetTimeController()
	local offset = 0
	if( controller ~= nil ) then
		offset = controller:GetObjVar("ShardTimeOffset") or 0
	end

	return offset
end

--returns the number of ingame hours per day
function GetGameDaylightDuration()
	return GetDaylightDurationSecs()/60*24
end

--returns the number of ingame hours per night
function GetGameNightDuration()
	return GetNighttimeDurationSecs()/60*24
end

function GetTimeOfDayPct(timeOffset)
	--Returns percentage of the day complete
	if( timeOffset == nil ) then timeOffset = GetTimeOffset() end
	
	local serverTimeSecs = (ServerTimeMs() / 1000.0) + timeOffset
	local tmp, currentTimePct = math.modf(serverTimeSecs / GetTotalDayDurationSecs())

	return currentTimePct
end

function GetCurrentTimeOfDay()
	local currentTimePct = GetTimeOfDayPct()

	currentTimeSecs = currentTimePct * GetTotalDayDurationSecs()
	return currentTimeSecs
end

-- returns time in terms of 24 hour day
function GetGameTimeOfDay()
	local currentTimePct = GetTimeOfDayPct()

	--offset by 4 hours so that daylight starts 4 hours later than midnight
	currentTimeGameHours = (currentTimePct * 24) + ServerSettings.Time.DaylightStartOffset
	if( currentTimeGameHours >= 24 ) then
		currentTimeGameHours = currentTimeGameHours - 24
	end

	return currentTimeGameHours
end

function GetGameTimeOfDayString()
	local currentTimeGameHours = GetGameTimeOfDay()

	local hour,minutePct = math.modf(currentTimeGameHours)

	return tostring(hour)..":"..string.format("%02d",(math.floor(minutePct*60)))
end

function SendTimeUpdate(playerObj)
	playerObj:SendClientMessage("TimeUpdate", {GetCurrentTimeOfDay(), GetDaylightDurationSecs(), GetNighttimeDurationSecs()})
end