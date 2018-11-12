
RES_PERCENTAGE = 0.6

function HandleLoaded()
	if not(this:HasObjVar("sp_resurrect_effectSource")) then
		EndEffect(true)
		return
	end
	local myResSource = this:GetObjVar("sp_resurrect_effectSource")
	if not(myResSource:IsValid()) then
		EndEffect(true)
		return
	end

	if ( this:IsPlayer() ) then
		this:SystemMessage("Your body and spirit resolve.", "info")
	end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(3), "ResurrectTimer", myResSource)
	this:PlayEffect("GreenPortalEffect") 
end

function EndEffect(delayed)
	local finalFunc = function()
		this:StopEffect("GreenPortalEffect",3)
		this:DelModule("sp_resurrect_effect")
		this:DelObjVar("sp_resurrect_effectSource")
	end
	if ( delayed ) then
		-- cannot detach in the same frame we attached, Handled Loaded is called in attach.
		CallFunctionDelayed(TimeSpan.FromSeconds(0.001), finalFunc)
	else
		finalFunc()
	end
end

RegisterEventHandler(EventType.Timer, "EndResEffect", 
	function ()
		EndEffect()
	end)
RegisterEventHandler(EventType.Message, "CritEffectsp_resurrect_effect", 
	function ()
		HandleLoaded()
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, "sp_resurrect_effect", 
	function ()
		HandleLoaded()
	end)

RegisterEventHandler(EventType.Timer, "ResurrectTimer", 
	function (resSource)		
		this:SendMessage("Resurrect",0.5,resSource)
		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1500), "EndResEffect")
	end)