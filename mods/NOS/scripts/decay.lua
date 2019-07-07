DEFAULT_DECAYTIME = 180

function ScheduleDecay(decayTime)

	--If the creature is pet, set decay time to be 10 times longer
	if (this:HasModule("pet_controller")) then
		decayTime = DEFAULT_DECAYTIME * 10
	end

	if(decayTime == nil) then
		decayTime = this:GetObjVar("DecayTime")		
	end

	if( decayTime == nil ) then
		decayTime = DEFAULT_DECAYTIME
	end

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(decayTime), "decay")
end

RegisterSingleEventHandler(EventType.ModuleAttached, "decay", 
	function()
		ScheduleDecay()
	end)

RegisterEventHandler(EventType.Message, "UpdateDecay", 
	function(decayTime)
		ScheduleDecay(decayTime)
	end)

RegisterEventHandler(EventType.Timer, "decay", 
	function()
		this:Destroy()
	end)