--require 'base_magic_sys'
local ICERAIN_DAMAGE_RANGE = 3.5
local mTargetLoc = nil
local mRainActive = false
local mPulse = 0
local function ValidateIceRain(targetLoc)
	--DebugMessage("Debuggery Deh Yah")
	if( not(IsPassable(targetLoc)) ) then
		this:SystemMessage("[$2612]")
		return false
	end

	if not(this:HasLineOfSightToLoc(targetLoc,ServerSettings.Combat.LOSEyeLevel)) then
		this:SystemMessage("[$2613]")
		return false
	end
	return true
end

RegisterEventHandler(EventType.Message,"IcerainSpellTargetResult",
	function (targetLoc)
		-- validate FlamePillar
--DebugMessage("Debuggery Here2")
		if not(ValidateIceRain(targetLoc)) then
			EndEffect()
			return
		end
		--DebugMessage("TARGETED!!")
	--DebugMessage("Debuggery Here")
		if(mRainActive == false) then
			mTargetLoc = targetLoc
		end
		mPulse = 0
	
		mRainActive = true
		this:FireTimer("IcerainPulse")
		this:PlayObjectSound("IceRain")
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(8),"IcerainRemove",mTargetLoc)
	end)



RegisterEventHandler(EventType.Timer, "IcerainPulse",
	function()
		if(mRainActive == false) then
			EndEffect()
			return
		end
		--DebugMessage("PULSE!!")
		if(math.fmod(mPulse,3)== 0 ) then
				PlayEffectAtLoc("IceRainEffect",mTargetLoc, 3)
				CreateTempObj("spell_aoe",mTargetLoc,"aoe_created")
			end
	local mobiles = FindObjects(SearchMulti({
					SearchRange(mTargetLoc,ICERAIN_DAMAGE_RANGE),
					SearchMobile()}), GameObj(0))
	for i,v in pairs(mobiles) do
		--v:NpcSpeech("Burning Burning burning")
		if(not IsDead(v)) then
			this:SendMessage("RequestMagicalAttack", "Icerain", v, this, true)
			--if(not v:HasModule("sp_burn_effect")) then
			--	v:SetObjVar("sp_burn_effectSource" , this)
			--	v:AddModule("sp_burn_effect")
			--end
		end
	end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "IcerainPulse")

end)

RegisterEventHandler(EventType.CreatedObject,"aoe_created",function (success,objRef)
	if (success) then
		objRef:SetObjVar("DecayTime",3)
	end
end)

RegisterEventHandler(EventType.Timer,"IcerainRemove",
	function()
		EndEffect()
	end)


function EndEffect()
	--DebugMessage("Ending!!")
	if(this:HasTimer("IcerainRemove")) then this:RemoveTimer("IcerainRemove") end
	if(this:HasTimer("IcerainPulse")) then this:RemoveTimer("IcerainPulse") end
	this:StopObjectSound("IceRain",false,0.0)
	this:DelModule("sp_ice_rain_effect")
end