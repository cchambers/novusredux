require 'incl_gametime'

function BroadcastTimeUpdate()		
	local loggedOnUsers = FindPlayersInRegion()
	for index,playerObj in pairs(loggedOnUsers) do
		playerObj:SendClientMessage("TimeUpdate", {GetCurrentTimeOfDay(), GetDaylightDurationSecs(), GetNighttimeDurationSecs()})
	end
end

RegisterEventHandler(EventType.Message,"SetTime",
	function(hours,minutes)		
		
		--DebugMessage("Attempt time change")
		if( minutes == nil ) then minutes = 0 end

		-- offset by 6 hours so a 12 hour day begins at 6am instead of noon
		local gameTimeHours = (hours + (minutes/60)) - ServerSettings.Time.DaylightStartOffset
		if( gameTimeHours < 0 ) then
			gameTimeHours = 24 + gameTimeHours
		end

		local gameTimePct = gameTimeHours / 24		

		-- get current time with no offset
		local currentTimePct = GetTimeOfDayPct(0)

		local offsetPct = gameTimePct - currentTimePct
		local offsetSecs = offsetPct * GetTotalDayDurationSecs()

		this:SetObjVar("ShardTimeOffset",offsetSecs)

		BroadcastTimeUpdate()
	end)

RegisterSingleEventHandler(EventType.ModuleAttached,"shard_time_controller",
	function()		
		BroadcastTimeUpdate()
	end)

if( initializer ~= nil ) then
	if(initializer.DaylightDurationSecs ~= nil ) then
		this:SetObjVar("DaylightDurationSecs",initializer.DaylightDurationSecs)
	else
		this:SetObjVar("DaylightDurationSecs",DEFAULT_DAYLIGHT_DURATION_SECS)
	end

	if(initializer.NighttimeDurationSecs ~= nil ) then
		this:SetObjVar("NighttimeDurationSecs",initializer.NighttimeDurationSecs)
	else
		this:SetObjVar("NighttimeDurationSecs",DEFAULT_NIGHTTIME_DURATION_SECS)
	end
end