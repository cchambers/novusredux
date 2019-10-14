mTotalProjs = 0
mTickCount = 0
mEndLoc = nil
mCaster = nil
mLoc = {}
COST_PER_UNIT = 5
function ValidateWall(targetLoc)
	----DebugMessage("--Debuggery Deh Yah")
	if (not (IsPassable(targetLoc))) then
		this:SystemMessage("You cannot place a paralyze field there.", "info")
		return false
	end

	if not (this:HasLineOfSightToLoc(targetLoc, ServerSettings.Combat.LOSEyeLevel)) then
		this:SystemMessage("You cannot place a paralyze field there.", "info")
		return false
	end

	return true
end

function InitiateParalyzeField(caster)
	if (mCaster == nil) then mCaster = caster end
	local startPoint = Loc(mLoc[0])
	local projAngle = startPoint:YAngleTo(mEndLoc)
	local mana = GetCurMana(this)
	local curProj = 1
	PlayEffectAtLoc("RedShadowFogEffect", startPoint, 10)
	local dist = startPoint:Distance(mEndLoc)
	while (curProj < dist) do
		local nextLoc = startPoint:Project(projAngle, curProj)
		if (this:HasLineOfSightToLoc(Loc(nextLoc))) then
			if (mana > (COST_PER_UNIT * curProj)) then
				mLoc[curProj] = nextLoc
				PlayEffectAtLoc("RedShadowFogEffect", nextLoc, 10)
				AdjustCurMana(this, -1 * COST_PER_UNIT)
				mTotalProjs = curProj
			else
				break
			end
		end
		curProj = curProj + 1
	end
	this:PlayObjectSound("event:/magic/fire/magic_fire_wall_of_fire", false, 6)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "ParalyzeFieldRemoveTimer")
	this:FireTimer("ParalyzeFieldTickTimer")
end
RegisterEventHandler(
	EventType.Timer,
	"ParalyzeFieldTickTimer",
	function()
		HandleParalyzeFieldTick()
	end
)

RegisterEventHandler(
	EventType.CreatedObject,
	"aoe_created",
	function(success, objRef)
		if (success) then
			objRef:SetObjVar("DecayTime", 5)
		end
	end
)
RegisterEventHandler(
	EventType.CreatedObject,
	"aoe_created_short",
	function(success, objRef)
		if (success) then
			objRef:SetObjVar("DecayTime", 3)
		end
	end
)

function HandleParalyzeFieldTick()
	--DebugMessage("Ticking: " ..mTickCount)
	if ((math.floor(mTickCount / 2) * mTickCount) == mTickCount) then
	--DebugMessage("Playing ParalyzeField")
	end
	if (mTickCount == -1) then
		return
	end
	for indy, fLocs in pairs(mLoc) do
		if (this:HasLineOfSightToLoc(Loc(fLocs))) then
			if (mTickCount == 0) then
				PlayEffectAtLoc("RedShadowFogEffect", Loc(fLocs), 10)
			end
			local mobiles =
				FindObjects(
				SearchMulti(
					{
						SearchRange(fLocs, 2.5),
						SearchMobile()
					}
				),
				GameObj(0)
			)
			local magery = GetSkillLevel(this, "MagerySkill")
			local percent = magery / ServerSettings.Skills.PlayerSkillCap.Single
			for i, v in pairs(mobiles) do
				if (ValidCombatTarget(this, v, true)) then
					if not( HasMobileEffect(v, "Paralyze") ) then
						v:SendMessage("StartMobileEffect", "Paralyze", this)
					end
				end
			end
		end
	end
	mTickCount = mTickCount + 1
	if (mTickCount > 0) then
		mTickCount = 0
	end
	--DebugMessage("Scheduling")
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1000), "ParalyzeFieldTickTimer")
end

RegisterEventHandler(
	EventType.Message,
	"ParalyzefieldSpellTargetResult",
	function(targetLoc)
		-- validate teleport
		--DebugMessage("--Debuggery Here2")
		----DebugMessage("Loc:" ..tostring(targetLoc))
		if not (ValidateWall(targetLoc)) then
			this:DelModule("sp_paralyzefield_effect")
			return
		end

		--	--DebugMessage("--Debuggery Here")

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "ParalyzeFieldRemoveTimer")
		mLoc = {}
		mLoc[0] = targetLoc
		mEndLoc = nil
		mTickCount = -1
		mTotalProjs = 0
		this:SystemMessage("Select field end point.", "info")
		this:RequestClientTargetLoc(this, "SelectParalyzeFieldEndPoint")
	end
)

RegisterEventHandler(
	EventType.Timer,
	"ParalyzeFieldRemoveTimer",
	function()
		this:DelModule("sp_paralyzefield_effect")
	end
)

RegisterEventHandler(
	EventType.ClientTargetLocResponse,
	"SelectParalyzeFieldEndPoint",
	function(success, endLoc)
		if not (success) then
			this:SystemMessage("[$2605]", "info")
			this:RequestClientTargetLoc(this, "SelectParalyzeFieldEndPoint")
			return
		end
		--DebugMessage("endLoc" ..tostring(endLoc))
		if (ValidateWall(endLoc)) then
			mCaster = this
			mEndLoc = endLoc
			--DebugMessage("InitWall")
			mTickCount = 0
			InitiateParalyzeField(mCaster)
		end
	end
)
