mPulsesLeft = 0
mLoc = nil
EARTHQUAKE_DAMAGE_RANGE = 6
RegisterEventHandler(EventType.Timer, "EarthquakePulseTimer",
function ()
	if(mLoc == nil) then 
		mLoc = this:GetLoc()
	end
	--this:PlayEffect("ScreenShakeEffect", 2)
	--if(math.fmod(mPulsesLeft,2) == 0) then
	this:PlayEffect("EarthquakeDustEffect")
	--end		
	mPulsesLeft = mPulsesLeft - 1
	local mobiles = FindObjects(SearchMulti({
					SearchRange(mLoc,EARTHQUAKE_DAMAGE_RANGE),
					SearchMobile()}), GameObj(0))
	for i,v in pairs(mobiles) do
		--v:NpcSpeech("OOh I'm Shaking") end
		if(not IsDead(v)) then
			this:SendMessage("RequestMagicalAttack", "Earthquake", v, this, true)
			--v:PlayEffectWithArgs("ScreenShakeEffect", 10.0,"Magnitude=5,Roughness=5,FadeOutTime=2")
		end

	end

	if ( not this:IsInRegion("Town") ) then
		this:PlayEffectWithArgs("ScreenShakeEffect", 10.0,"Magnitude=5,FadeOutTime=3")
	end

	if(mPulsesLeft > 0) then 
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(.6), "EarthquakePulseTimer")
	else
		this:FireTimer("EndEarthquakeTimer")
	end

end)


RegisterEventHandler(EventType.Message, "CompletionEffectsp_earthquake_effect",
	function ()
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "EarthquakePulseTimer")
		mPulsesLeft = 5
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(4), "EndEarthquakeTimer")
	end)



RegisterEventHandler(EventType.Timer, "EndEarthquakeTimer",
function() 
	this:DelModule("sp_earthquake_effect")
end)