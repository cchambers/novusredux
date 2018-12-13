mTicksCount = -1
mDeleting = false
mTargets = {}
mLastHit = {}
mCaster = nil
mFirstTick = 0
mSkill = 0



function InitEnergyWall(caster, skill)
	AddView("EnergyWallAoe", SearchMobileInRange(.5))
	mCaster = caster
	mTickCount = math.floor(skill/2)
	mSkill = skill
	mFirstTick = mTickCount
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(.5), "EnergyWallTickTimer")
end


RegisterEventHandler(EventType.EnterView, "EnergyWallAoe", 
	function(objEntering)
		if(mTickCount == mFirstTick) then
			mDeleting = true
		--	DebugMessage("Deleting")
			DelView("EnergyWallAoe")
			CallFunctionDelayed(TimeSpan.FromSeconds(.5), 
			function()
						this:FireTimer("EndEnergyWallTimer")
			end)
			return
		end
		if(objEntering ~= mCaster) then 
			mTargets[#mTargets + 1] = objEntering
			mCaster:SendMessage("RequestMagicalAttack", "Energywall", objEntering, mCaster, true)
			mLastHit[objEntering] = ServerTimeMs()
		end

	end)
RegisterEventHandler(EventType.LeaveView, "EnergyWallAoe", 
	function(objLeaving)
		local cTargs = {}
		for i=1, #mTargets do
			if(mTargets[i] ~= objLeaving) then
				cTargs[#cTargs + 1] = mTargets[i]
			else
				mLastHit[objLeaving] = nil
			end
		end
		mTargets = cTargs
	end)

function HandleEnergyWallTick()
	if(mDeleting) then return end
	local thisTick = ServerTimeMs()
	for i=1,#mTargets  do
		--v:NpcSpeech("Burning Burning burning")
		if(not IsDead(mTargets[i])) then
			mLastHit[mTargets[i]] = thisTick
			mCaster:SendMessage("RequestMagicalAttack", "Energywall", mTargets[i], mCaster, true)
		end
	end

	mTickCount = mTickCount -1
	if(mTickCount < 1) then 
		EndEffect()
		return
	end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "EnergyWallTickTimer")
end

RegisterEventHandler(EventType.Timer, "EnergyWallTickTimer", HandleEnergyWallTick)

RegisterEventHandler(EventType.Message,"InitEnergyWall", 
	function(args)
		InitEnergyWall(args.Caster, args.Skill)
		end)

function EndEffect()
	this:Destroy()
end


RegisterEventHandler(EventType.Timer, "EndEnergyWallTimer", 
	function()
		EndEffect()
	end)

this:ScheduleTimerDelay(TimeSpan.FromSeconds(60), "EndEnergyWallTimer")