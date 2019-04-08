DEFAULT_DECAYTIME = 180

function ScheduleDecay(decayTime)
	if(decayTime == nil) then
		decayTime = this:GetObjVar("SlayDecayTime")		
	end

	if( decayTime == nil ) then
		decayTime = DEFAULT_DECAYTIME
	end

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(decayTime), "slay_decay")
end

RegisterSingleEventHandler(EventType.ModuleAttached, "slay_decay", 
	function()
		ScheduleDecay()
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, "Resurrect", 
	function()
		ScheduleDecay()
	end)


RegisterEventHandler(EventType.Message, "UpdateSlayDecay", 
	function(decayTime)
		ScheduleDecay(decayTime)
	end)

RegisterEventHandler(EventType.Timer, "slay_decay", 
	function()
		--DebugMessage(0)
		this:SendMessage("ProcessTrueDamage", this, 5000, this)
		PlayEffectAtLoc("VoidTeleportToEffect", this:GetLoc())
		CallFunctionDelayed(TimeSpan.FromSeconds(0.5), function ()
			this:Destroy()
		end)
	end)