BASE_POISON_DAMAGE = 4
MAX_POISON_TICKS = 11
MIN_POISON_TICKS = 10
POISON_HEAL_MOD = .8
mBasePoisonDamage = 0
mPoisonTicks = 0
this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(2200), "ValidatePoisonEffect")

m_Resisted = false

function HandleLoaded()
	if not(this:HasObjVar("sp_poison_effectSource")) then
		EndEffect()
		return
	end
	local myPoisonSource = this:GetObjVar("sp_poison_effectSource")
	if not(myPoisonSource:IsValid()) then
		EndEffect()
		return
	end
	-- when immune this effect cannot apply
	if ( IsMobileImmune(this) ) then
		EndEffect()
		return
	end

	m_Resisted = CheckActiveSpellResist(this)

	SetMobileMod(this, "HealingReceivedTimes", "Poison", -0.60)
	local poisonSkill = GetSkillLevel(myPoisonSource,"ManifestationSkill")
	local durSkill = GetSkillLevel(myPoisonSource,"ChannelingSkill")
	local ticks = math.max(MIN_POISON_TICKS, MAX_POISON_TICKS)
	mPoisonTicks = ticks
	AddBuffIcon(this,"Poison Cloud", "Poisoned", "Poison Cloud", "1-3 damage every 2 seconds." .. "\nCannot be healed.", true)
	if this:IsPlayer() then
		this:SystemMessage("[33CC33]You feel nauseous.[-]")
	end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(3.5), "PoisonEffectTickTimer", myPoisonSource)
	this:PlayEffect("PoisonSpellEffect")
end

RegisterEventHandler(EventType.Message, "SpellHitEffectsp_poison_effect", 
	function(poisoner)
		AdvanceConflictRelation(poisoner, this)
		HandleLoaded()
	end)

RegisterEventHandler(EventType.Timer, "PoisonEffectTickTimer", 
	function (poisonSource)
		if(mPoisonTicks > 0) then
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(3.5), "PoisonEffectTickTimer", poisonSource)
			local min = 1
			max = 3
			if ( m_Resisted ) then
				min = 0.5
				max = 1.5
			end
			this:SendMessage ("ProcessTypeDamage", poisonSource, math.random(min, max), false, "Poison")
			mPoisonTicks = mPoisonTicks - 1
			return
		end
		EndEffect()
	end)

RegisterEventHandler(EventType.Timer, "ValidatePoisonEffect", 
	function()
		if not(this:HasTimer("PoisonEffectTickTimer")) then
			EndEffect()
			return
		end
	end)

RegisterEventHandler(EventType.Message, "CurePoison",
	function()
		EndEffect()
	end)

RegisterEventHandler(EventType.Message, "EndPoisonEffect", 
	function()
		EndEffect()
	end)
RegisterEventHandler(EventType.Message,"HasDiedMessage",
	function()
		EndEffect()
	end)

function EndEffect()
	SetMobileMod(this, "HealingReceivedTimes", "Poison", nil)
	if(this:HasTimer("PoisonEffectTickTimer")) then this:RemoveTimer("PoisonEffectTickTimer") end
	RemoveBuffIcon(this,"Poison Cloud")
	this:StopEffect("PoisonSpellEffect")
	this:DelModule("sp_poison_effect")
end