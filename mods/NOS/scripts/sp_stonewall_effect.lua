mTicksCount = -1
mDeleting = false
mTargets = {}
mLastHit = {}
mCaster = nil
mFirstTick = 0
mLoc = nil
mSkill = 0
mHeight = 0
mMaxHeight = 3
mIncrement = 0.5
mTimer = 0.3

function InitStoneWall(caster, skill)
	mCaster = caster
	mTickCount = math.floor(skill / 2)
	mSkill = skill
	mFirstTick = mTickCount
	mLoc = this:GetLoc()

	this:SetCollisionBoundsFromTemplate("wall_graveyard")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(mTimer), "StoneWallTickTimer")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(.005), "StoneWallGrowTimer")


	local mobiles =
		FindObjects(
		SearchMulti(
			{
				SearchRange(mLoc, 2.25),
				SearchMobile()
			}
		),
		GameObj(0)
	)

	this:NpcSpeech(tostring(#mobiles))

	if (#mobiles > 0) then
		this:FireTimer("EndStoneWallTimer")
	end
	
end

RegisterEventHandler(
	EventType.EnterView,
	"StoneWallAoe",
	function(objEntering)
		if (mTickCount == mFirstTick) then
			mDeleting = true
			--	DebugMessage("Deleting")
			DelView("StoneWallAoe")
			CallFunctionDelayed(
				TimeSpan.FromSeconds(.5),
				function()
					this:FireTimer("EndStoneWallTimer")
				end
			)
			return
		end
		-- UnstickPlayer(objEntering)
	end
)
-- RegisterEventHandler(EventType.LeaveView, "StoneWallAoe",
-- function(objLeaving)
-- 	local cTargs = {}
-- 	for i=1, #mTargets do
-- 		if(mTargets[i] ~= objLeaving) then
-- 			cTargs[#cTargs + 1] = mTargets[i]
-- 		else
-- 			mLastHit[objLeaving] = nil
-- 		end
-- 	end
-- 	mTargets = cTargs
-- end)

function HandleStoneWallTick()
	if (mDeleting) then
		return
	end
	local thisTick = ServerTimeMs()
	for i = 1, #mTargets do
		--v:NpcSpeech("Burning Burning burning")
		if (not IsDead(mTargets[i])) then
			mLastHit[mTargets[i]] = thisTick
			mCaster:SendMessage("RequestMagicalAttack", "Energywall", mTargets[i], mCaster, true)
		end
	end

	mTickCount = mTickCount - 1
	if (mTickCount < 1) then
		EndEffect()
		return
	end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(mTimer), "StoneWallTickTimer")
end

function HandleStoneWallGrow()
	if (mDeleting) then
		return
	end
	if (mHeight >= mMaxHeight) then
		return
	end
	mHeight = mHeight + (0.2 / mIncrement)
	this:SetScale(Loc(1.5, mHeight, 1.5))
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(.005), "StoneWallGrowTimer")
end

RegisterEventHandler(EventType.Timer, "StoneWallTickTimer", HandleStoneWallTick)
RegisterEventHandler(EventType.Timer, "StoneWallGrowTimer", HandleStoneWallGrow)

RegisterEventHandler(
	EventType.Message,
	"InitStoneWall",
	function(args)
		InitStoneWall(args.Caster, args.Skill)
	end
)

function EndEffect()
	this:Destroy()
end

RegisterEventHandler(
	EventType.Timer,
	"EndStoneWallTimer",
	function()
		EndEffect()
	end
)

this:ScheduleTimerDelay(TimeSpan.FromSeconds(60), "EndStoneWallTimer")
