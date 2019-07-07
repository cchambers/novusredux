DEFAULT_DECAYTIME = 180

function Decay(decayTime)
	if(decayTime == nil) then
		decayTime = this:GetObjVar("ObjVarDecayTime")		
	end

	if( decayTime == nil ) then
		decayTime = DEFAULT_DECAYTIME
	end

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(decayTime), "objvar_decay")
end

RegisterSingleEventHandler(EventType.ModuleAttached, "objvar_decay", 
	function()
		Decay()
	end)

RegisterEventHandler(EventType.Message, "UpdateObjVarDecay", 
	function(decayTime)
		Decay(decayTime)
	end)

RegisterEventHandler(EventType.Timer, "objvar_decay", 
	function()
		this:DelObjVar(this:GetObjVar("ObjVarDel"))
		this:DelObjVar("ObjVarDel")
		this:DelModule(GetCurrentModule())
	end)