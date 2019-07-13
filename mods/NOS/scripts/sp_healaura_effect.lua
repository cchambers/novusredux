require "NOS:incl_magic_sys"

FLAMEAURA_DAMAGE_RANGE = 3.5
--local ignoreView = true
PULSE_COST = -2
PULSE_SPEED = 1000
mPulseID = 0
mTargetsIR = {}
--DebugMessage("flameaura ATTACHY")
mUpkeep = 1
mActive = false
FLAME_AURA_MS_MOD = .8

function StartHealAuraEffect()
	--DebugMessage("Starting")
	--this:SetObjVar("Dangerous",true)
	if (mActive == false) then
		mActive = true
		this:SetObjVar("AuraofhealBonusCastingOffset", -.4)
	else
		EndEffect()
		--DebugMessage("Ending It")
		return
	end
	if not (HasView("HealAuraView")) then
		AddView("HealAuraView", SearchMobileInRange(FLAMEAURA_DAMAGE_RANGE, true))
	end
	local upkeepCost = GetSpellInformation("Auraofheal", "upkeepCost")
	if (upkeepCost ~= nil) and (upkeepCost ~= 0) then
		mUpkeep = upkeepCost
		SetMobileMod(this, "ManaRegenPlus", "HealAuraUpkeep", upkeepCost)
	end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "HealAuraPulse")
	--this:SetObjVar("FlameauraBonusCastingOffset", 1.2)
	this:PlayObjectSound("event:/magic/fire/magic_fire_wall_of_fire", false)

	AddBuffIcon(this, "FlameAura", "Heal Aura", "healaura", "[$2606]", true, 30)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(30), "HealAuraRemove")
	this:PlayEffect("RadiationAuraEffect")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(6), "HealEffectLoop")
end

RegisterEventHandler(
	EventType.Timer,
	"HealEffectLoop",
	function()
		this:PlayEffect("RadiationAuraEffect")
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(6), "HealEffectLoop")
	end
)
RegisterEventHandler(
	EventType.Message,
	"CompletionEffectsp_radiationaura_effect",
	function()
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "HealAuraLaunchTimer")
		StartHealAuraEffect()
	end
)

function EndEffect()
	this:DelObjVar("AuraofhealBonusCastingOffset")
	this:RemoveTimer("HealAuraPulse")
	this:RemoveTimer("HealAuraRemove")
	this:RemoveTimer("HealEffectLoop")
	RemoveBuffIcon(this, "HealAura")
	this:StopEffect("HealAuraEffect")
	SetMobileMod(this, "ManaRegenPlus", "HealAuraUpkeep", nil)
	DelView("HealAuraView")
	this:FireTimer("HealAuraCleanUpTimer")
end

RegisterEventHandler(
	EventType.EnterView,
	"HealAuraView",
	function(damTarget)
		local myPulseId = mPulseID + 1
		if (myPulseId > 3) then
			myPulseId = 0
		end
		mTargetsIR[damTarget] = myPulseId
	end
)

RegisterEventHandler(
	EventType.Timer,
	"HealAuraPulse",
	function()
		this:SendMessage("BreakInvisEffect", "Casting")
		local curMana = GetCurMana(this)
		if (curMana < (-1 * PULSE_COST)) then
			EndEffect()
			return
		end
		local charge = false
		local hit = false
		mPulseID = mPulseID + 1
		if (mPulseID > 3) then
			mPulseID = 0
		end
		hit = false
		for i, v in pairs(mTargetsIR) do
			if (mTargetsIR[i] == mPulseID) then
				if (not IsDead(i)) and (i:ContainedBy() == nil) then
					hit = true
					this:SendMessage("RequestMagicalAttack", "Auraofheal", i, this, true)
				end
			end
		end
		if (hit) then
			this:PlayObjectSound("event:/magic/misc/magic_water_greater_heal", false)
			AdjustCurMana(this, PULSE_COST)
		end

		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(PULSE_SPEED), "HealAuraPulse")
	end
)

RegisterEventHandler(
	EventType.LeaveView,
	"HealAuraView",
	function(objLeavin)
		mTargetsIR[objLeavin] = nil
	end
)

RegisterEventHandler(
	EventType.Message,
	"HasDiedMessage",
	function()
		EndEffect()
	end
)
RegisterEventHandler(
	EventType.Timer,
	"HealAuraRemove",
	function()
		EndEffect()
	end
)

RegisterEventHandler(
	EventType.Timer,
	"HealAuraCleanUpTimer",
	function()
		--this:DelObjVar("Dangerous")
		this:DelModule("sp_radiationaura_effect")
	end
)
