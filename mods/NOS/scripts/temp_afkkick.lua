KICK_CHECK_FREQ_SECS = 5 * 60
hasMoved = true

-- DAB TODO: Fix AFK kick timer so actions break it
--this:ScheduleTimerDelay(TimeSpan.FromSeconds(KICK_CHECK_FREQ_SECS), "MoveCheck")

RegisterEventHandler(EventType.Timer, "MoveCheck", 
	function ()
		if( hasMoved == false ) then
			DebugMessage("INFO: Kicking user "..this:GetName().." for AFK")
			this:KickUser("You have been idle for too long.")
			return
		end

		hasMoved = false
		--this:ScheduleTimerDelay(TimeSpan.FromSeconds(KICK_CHECK_FREQ_SECS), "MoveCheck")
	end)

RegisterEventHandler(EventType.Arrived, "", 
	function ()
		hasMoved = true
	end)