mAmount = 0

mDurationMinutes = 10

mBuffed = false

function HandleLoaded(caster)
	local skillLevel = GetSkillLevel(caster, "MagerySkill")

	if (this:HasTimer("SpellCunningBonusTimer")) then
		this:RemoveTimer("SpellCunningBonusTimer")
	end
	mAmount = math.floor(skillLevel / 10)

	SetMobileMod(this, "IntelligencePlus", "SpellCunning", mAmount)
	AddBuffIcon(
		this,
		"WeakenSpellBuff",
		"Cunning",
		"Thunder Strike 04",
		"Intelligence is increased by " .. mAmount,
		false,
		mDurationMinutes * 60
	)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "SpellCunningBonusTimer")
	if not (mBuffed) then
		this:SystemMessage("Your intelligence has increased by " .. mAmount, "event")
	end
	mBuffed = true
	RegisterSingleEventHandler(EventType.Message, "NOSDebuff", CleanUp)
end 

function CleanUp()
	SetMobileMod(this, "IntelligencePlus", "SpellCunning", nil)
	this:SystemMessage("Cunning has worn off, decreasing your intelligence by " .. mAmount, "event")
	RemoveBuffIcon(this, "WeakenSpellBuff")
	mAmount = 0
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(
	EventType.Timer,
	"SpellCunningBonusTimer",
	function()
		CleanUp()
	end
)

RegisterEventHandler(
	EventType.Message,
	"SpellHitEffectsp_cunning_effect",
	function(caster)
		HandleLoaded(caster)
	end
)
