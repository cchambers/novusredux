mAmount = 0

mDurationMinutes = 2

mBuffed = false

function HandleLoaded(caster)
	local skillLevel = GetSkillLevel(caster, "MagerySkill")

	if (this:HasTimer("SpellBlessBonusTimer")) then
		this:RemoveTimer("SpellBlessBonusTimer")
	end
	mAmount = math.floor(skillLevel / 10)

	SetMobileMod(this, "AgilityPlus", "SpellBlessAgility", mAmount)
	SetMobileMod(this, "IntelligencePlus", "SpellBlessIntel", mAmount)
	SetMobileMod(this, "StrengthPlus", "SpellBlessStrength", mAmount)
	AddBuffIcon(
		this,
		"WeakenSpellBuff",
		"Bless",
		"Thunder Strike 04",
		"Stats increased by " .. mAmount,
		false,
		mDurationMinutes * 60
	)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "SpellBlessBonusTimer")
	if not (mBuffed) then
		this:SystemMessage("Bless! Your stats have increased by " .. mAmount, "event")
	end
	mBuffed = true
end 

function CleanUp()
	SetMobileMod(this, "AgilityPlus", "SpellBlessAgility", nil)
	SetMobileMod(this, "IntelligencePlus", "SpellBlessIntel", nil)
	SetMobileMod(this, "StrengthPlus", "SpellBlessStrength", nil)
	this:SystemMessage("Bless has worn off, decreasing your stats by " .. mAmount, "event")
	RemoveBuffIcon(this, "WeakenSpellBuff")
	mAmount = 0
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(
	EventType.Timer,
	"SpellBlessBonusTimer",
	function()
		CleanUp()
	end
)

RegisterEventHandler(
	EventType.Message,
	"SpellHitEffectsp_bless_effect",
	function(caster)
		HandleLoaded(caster)
	end
)
