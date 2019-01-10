
mStages = 8
mStage = 0
mAmount = 0.85

function HandleLoaded()
	local scale = this:GetScale()
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(250),"JustDisappear")
end

RegisterEventHandler(EventType.Timer,"JustDisappear",function ( effect )
	if (mStage == mStages) then 
		local loc = this:GetLoc()
		PlayEffectAtLoc("CloakEffect", loc)
		this:Destroy()
	end
	this:SetScale(mAmount * this:GetScale())
	mStage = mStage + 1
    this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(250),"JustDisappear")
end)

RegisterSingleEventHandler(EventType.ModuleAttached, "released_pet", HandleLoaded)
