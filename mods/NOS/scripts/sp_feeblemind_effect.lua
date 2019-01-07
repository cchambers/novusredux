mDecreaseAmount = 0

mDurationMinutes = 10

mBuffed = false

function HandleLoaded(caster)
	local skillLevel = GetSkillLevel(caster, "MagerySkill")

	if (this:HasTimer("SpellFeeblemindBonusTimer")) then
		this:RemoveTimer("SpellFeeblemindBonusTimer")
	end
	mDecreaseAmount = -math.floor(skillLevel / 10)

	SetMobileMod(this, "IntelligencePlus", "SpellFeeblemind", mDecreaseAmount)
	AddBuffIcon(
		this,
		"WeakenSpellBuff",
		"Feeblemind",
		"Thunder Strike 04",
		"Intelligence is decreased by " .. mDecreaseAmount,
		false,
		mDurationMinutes * 60
	)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "SpellFeeblemindBonusTimer")
	if not (mBuffed) then
		this:SystemMessage("Your intelligence has decreased by " .. mDecreaseAmount, "event")
	end
	mBuffed = true
end

function CleanUp()
	SetMobileMod(this, "IntelligencePlus", "SpellFeeblemind", nil)
	this:SystemMessage("Feeblemind has worn off, increasing your intelligence by " .. mDecreaseAmount, "event")
	RemoveBuffIcon(this, "WeakenSpellBuff")
	mDecreaseAmount = 0
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(
	EventType.Timer,
	"SpellFeeblemindBonusTimer",
	function()
		CleanUp()
	end
)

RegisterEventHandler(
	EventType.Message,
	"SpellHitEffectsp_feeblemind_effect",
	function(caster)
		HandleLoaded(caster)
	end
)
