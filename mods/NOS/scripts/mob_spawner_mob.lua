--Attached to mobs created by a destructable_mob_spawner

RegisterEventHandler(EventType.Timer, "check_valid", 
	function ()
		local source = this:GetObjVar("Source")

		if( source == nil or not(source:IsValid())) then
			--DebugMessage("Destroying at A")
			this:Destroy()
		else
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(4 + math.random()),"check_valid")
		end
	end)

RegisterEventHandler(EventType.Message, "HasDiedMessage",
	function(killer)
		local source = this:GetObjVar("Source")
		source:SendMessage("mobSlain", this)
	end)

this:ScheduleTimerDelay(TimeSpan.FromSeconds(4 + math.random()),"check_valid")