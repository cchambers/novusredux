mAmount = 0

mDurationMinutes = 10

mBuffed = false

function HandleLoaded(caster)
	local skillLevel = GetSkillLevel(caster, "MagerySkill")

	if (this:HasTimer("SpellAgileBonusTimer")) then
		this:RemoveTimer("SpellAgileBonusTimer")
	end
	mAmount = math.floor(skillLevel / 10)

	SetMobileMod(this, "AgilityPlus", "SpellAgile", mAmount)
	AddBuffIcon(
		this,
		"WeakenSpellBuff",
		"Agile",
		"Thunder Strike 04",
		"Agility is increased by " .. mAmount,
		false,
		mDurationMinutes * 60
	)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "SpellAgileBonusTimer")
	if not (mBuffed) then
		this:SystemMessage("Your agility has increased by " .. mAmount, "event")
	end
	mBuffed = true
	RegisterSingleEventHandler(EventType.Message, "NOSDebuff", CleanUp)
end 

function CleanUp()
	SetMobileMod(this, "AgilityPlus", "SpellAgile", nil)
	this:SystemMessage("Agility has worn off, decreasing your agility by " .. mAmount, "event")
	RemoveBuffIcon(this, "WeakenSpellBuff")
	mAmount = 0
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(
	EventType.Timer,
	"SpellAgileBonusTimer",
	function()
		CleanUp()
	end
)

RegisterEventHandler(
	EventType.Message,
	"SpellHitEffectsp_agile_effect",
	function(caster)
		HandleLoaded(caster)
	end
)
