HELLPORTAL_DAMAGE_RANGE = 6
mCentreLoc = nil
mPull = true
mRemoving = false

function InitiateEffect()
--	DebugMessage(1)
	PlayEffectAtLoc("BlackHoleEffect",mCentreLoc, 7)
	CreateTempObj("spell_aoe",mCentreLoc,"aoe_created")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1.5), "HellportalTimer")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(7), "RemoveHellPortalTimer")
end

RegisterEventHandler(EventType.CreatedObject,"aoe_created",function (success,objRef)
	if (success) then
		objRef:SetObjVar("DecayTime",7)
	end
end)

function PulseEffect()
	local mobiles = FindObjects(SearchMulti({
					SearchRange(mCentreLoc,HELLPORTAL_DAMAGE_RANGE),
					SearchMobile()}), GameObj(0))
		for i,v in pairs(mobiles) do
		--v:NpcSpeech("Burning Burning burning")
		if(not IsDead(v) and v ~= this) then
			local vLoc = v:GetLoc()
			local vDist = mCentreLoc:Distance(vLoc)
			local cAng = mCentreLoc:YAngleTo(vLoc)
			local pullStrength = 10 - vDist
			local pullTake = .5 * pullStrength
			local pullToDist = math.max(0,vDist - pullTake)
			local pullLoc = mCentreLoc:Project(cAng, pullToDist)
			if(mPull) then v:PushTo(pullLoc, 6,GetBodySize(v)) end
			if(vDist < 2) then
				SetMobileModExpire(v, "Freeze", "BlackHole", true, TimeSpan.FromSeconds(1))
				this:SendMessage("RequestMagicalAttack", "Blackhole", v, this, true)
			end
			if(mPull) then 
				mPull = false
			else
				mPull = true
			end

		end
	end
end

RegisterEventHandler(EventType.Timer,"RemoveHellPortalTimer",
	function()
		mRemoving = false
		PlayEffectAtLoc("BuffEffect_D",mCentreLoc, 3)
		this:DelModule("sp_blackhole_effect")
	end)

RegisterEventHandler(EventType.Timer, "HellportalTimer",
function() 
	PulseEffect()
	if(mRemoving == false) then this:ScheduleTimerDelay(TimeSpan.FromSeconds(.4), "HellportalTimer") end
end)

local function ValidateHellportal(targetLoc)
	--DebugMessage("Debuggery Deh Yah")
	if( not(IsPassable(targetLoc)) ) then
		this:SystemMessage("[$2601]")
		return false
	end

	if not(this:HasLineOfSightToLoc(targetLoc,ServerSettings.Combat.LOSEyeLevel)) then
		this:SystemMessage("[$2602]")
		return false
	end
	return true
end

function EndEffect()
	this:FireTimer("RemoveHellPortalTimer")
end

RegisterSingleEventHandler(EventType.Message, "BlackholeSpellTargetResult",
function (targetLoc)
		--DebugMessage(0)
	-- validate FlamePillar
	if not(ValidateHellportal(targetLoc)) then
		EndEffect() 
		return
	end
	mCentreLoc = targetLoc
	InitiateEffect()
end)

