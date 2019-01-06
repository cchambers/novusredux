mTotalProjs = 0
mTickCount = 0
mEndLoc = nil
mLoc = {}
COST_PER_UNIT = 5
function ValidateWall(targetLoc)
	----DebugMessage("--Debuggery Deh Yah")
	if (not (IsPassable(targetLoc))) then
		this:SystemMessage("[$2603]", "info")
		return false
	end

	if not (this:HasLineOfSightToLoc(targetLoc, ServerSettings.Combat.LOSEyeLevel)) then
		this:SystemMessage("[$2604]", "info")
		return false
	end

	return true
end

function InitiatePoisonField()
	local startPoint = Loc(mLoc[0])
	local projAngle = startPoint:YAngleTo(mEndLoc)
	local mana = GetCurMana(this)
	local curProj = 1
	PlayEffectAtLoc("PoisonSpellEffect", startPoint, 5)
	local dist = startPoint:Distance(mEndLoc)
	while (curProj < dist) do
		local nextLoc = startPoint:Project(projAngle, curProj)
		if (this:HasLineOfSightToLoc(Loc(nextLoc))) then
			if (mana > (COST_PER_UNIT * curProj)) then
				mLoc[curProj] = nextLoc
				PlayEffectAtLoc("PoisonSpellEffect", nextLoc, 5)
				AdjustCurMana(this, -1 * COST_PER_UNIT)
				mTotalProjs = curProj
			else
				break
			end
		end
		curProj = curProj + 1
	end
	this:PlayObjectSound("event:/magic/fire/magic_fire_wall_of_fire", false)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "PoisonFieldRemoveTimer")
	this:FireTimer("PoisonFieldTickTimer")
end
RegisterEventHandler(
	EventType.Timer,
	"PoisonFieldTickTimer",
	function()
		HandlePoisonFieldTick()
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

function HandlePoisonFieldTick()
	--DebugMessage("Ticking: " ..mTickCount)
	if ((math.floor(mTickCount / 2) * mTickCount) == mTickCount) then
	--DebugMessage("Playing PoisonField")
	end
	if (mTickCount == -1) then
		return
	end
	for indy, fLocs in pairs(mLoc) do
		--DebugMessage("CHECK 1 WOF: ",this:HasLineOfSightToLoc(Loc(fLocs)))
		if (this:HasLineOfSightToLoc(Loc(fLocs))) then
			if (mTickCount == 0) then
				--DebugMessage("Playing")
				--CreateTempObj("spell_aoe",Loc(fLocs),"aoe_created_short")
				PlayEffectAtLoc("PoisonSpellEffect", Loc(fLocs), 10)
			end
			----DebugMessage("PULSE!!")
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
			for i, v in pairs(mobiles) do
				--v:NpcSpeech("Burning Burning burning")
				if (ValidCombatTarget(this, v, true)) then
					StartMobileEffect(v, "Poison", this, {
						MinDamage = math.max(1, 3 * percent),
						MaxDamage = math.max(1, 8 * percent),
						PulseMax = math.max(1, 6),
					})
				end
			end
		end
	end
	mTickCount = mTickCount + 1
	if (mTickCount > 0) then
		mTickCount = 0
	end
	--DebugMessage("Scheduling")
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1000), "PoisonFieldTickTimer")
end

RegisterEventHandler(
	EventType.Message,
	"PoisonfieldSpellTargetResult",
	function(targetLoc)
		-- validate teleport
		--DebugMessage("--Debuggery Here2")
		----DebugMessage("Loc:" ..tostring(targetLoc))
		if not (ValidateWall(targetLoc)) then
			this:DelModule("sp_poisonfield_effect")
			return
		end

		--	--DebugMessage("--Debuggery Here")

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "PoisonFieldRemoveTimer")
		mLoc = {}
		mLoc[0] = targetLoc
		mEndLoc = nil
		mTickCount = -1
		mTotalProjs = 0
		this:SystemMessage("Select field end point.", "info")
		this:RequestClientTargetLoc(this, "SelectPoisonFieldEndPoint")
	end
)

RegisterEventHandler(
	EventType.Timer,
	"PoisonFieldRemoveTimer",
	function()
		this:DelModule("sp_poisonfield_effect")
	end
)

RegisterEventHandler(
	EventType.ClientTargetLocResponse,
	"SelectPoisonFieldEndPoint",
	function(success, endLoc)
		if not (success) then
			this:SystemMessage("[$2605]", "info")
			this:RequestClientTargetLoc(this, "SelectPoisonFieldEndPoint")
			return
		end
		--DebugMessage("endLoc" ..tostring(endLoc))
		if (ValidateWall(endLoc)) then
			mEndLoc = endLoc
			--DebugMessage("InitWall")
			mTickCount = 0
			InitiatePoisonField()
		end
	end
)
