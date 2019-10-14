DECAY_RANGE = 20
MIN_DECAY_TIME =  1*60*60
MAX_DECAY_TIME =  3*60*60

function ScheduleDecayTimer(forceDecayTime)
	local delaySecs = forceDecayTime or this:GetObjVar("DecayTime")
	if not(delaySecs) then
		delaySecs = math.random(MIN_DECAY_TIME,MAX_DECAY_TIME)
	end

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(delaySecs),"MobDecayTimer")
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),function ( ... )
        ScheduleDecayTimer()
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"",function ( ... )
		--DFB HACK: Fix it so that pets cannot just vanish.
		if (this:HasModule("pet_controller")) then 
			this:DelModule("spawn_decay") 
			return
		end
        ScheduleDecayTimer()
	end)

RegisterEventHandler(EventType.Timer,"MobDecayTimer",function ( ... )
		--DFB HACK: Fix it so that pets cannot just vanish.
		if (this:HasModule("pet_controller") or IsInCombat(this)) then 
			this:DelModule("spawn_decay") 
			return
		elseif not FindObject(SearchPlayerInRange(DECAY_RANGE)) then
			if(this:HasEventHandler(EventType.Message,"Destroy")) then
				this:SendMessage("Destroy")
			else
				this:Destroy()
			end
		else
			-- wait a minute and try again
			ScheduleDecayTimer(60)
		end
	end)

RegisterEventHandler(EventType.Message,"RefreshSpawnDecay",
	function ()
		ScheduleDecayTimer()
	end)