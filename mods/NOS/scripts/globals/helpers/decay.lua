DEFAULT_DECAYTIME = 180

function Decay(objref, time)
	time = time or DEFAULT_DECAYTIME

	if(objref:IsValid() == false) then
		return end
		
	if (objref:HasModule("pet_controller")) then
		time = DEFAULT_DECAYTIME * 10
	end
	objref:ScheduleDecay(TimeSpan.FromSeconds(time))
end