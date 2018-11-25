mAmount = 0

mDurationMinutes = 2

mBuffed = false

function HandleLoaded()
	local skillLevel = GetSkillLevel(this, "ManifestationSkill")

	if (this:HasTimer("SpellCurseBonusTimer")) then
		this:RemoveTimer("SpellCurseBonusTimer")
	end
	mAmount = -math.floor(skillLevel / 10)

	SetMobileMod(this, "AgilityPlus", "SpellCurseAgility", mAmount)
	SetMobileMod(this, "IntelligencePlus", "SpellCurseIntel", mAmount)
	SetMobileMod(this, "StrengthPlus", "SpellCurseStrength", mAmount)
	AddBuffIcon(
		this,
		"WeakenSpellBuff",
		"Curse",
		"Thunder Strike 04",
		"Stats increased by " .. mAmount,
		false,
		mDurationMinutes * 60
	)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "SpellCurseBonusTimer")
	if not (mBuffed) then
		this:SystemMessage("Cursed! Your stats have decresed by " .. mAmount, "event")
	end
	mBuffed = true
end 

function CleanUp()
	SetMobileMod(this, "AgilityPlus", "SpellCurseAgility", nil)
	SetMobileMod(this, "IntelligencePlus", "SpellCurseIntel", nil)
	SetMobileMod(this, "StrengthPlus", "SpellCurseStrength", nil)
	this:SystemMessage("Curse has worn off, increasing your stats by " .. mAmount, "event")
	RemoveBuffIcon(this, "WeakenSpellBuff")
	mAmount = 0
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(
	EventType.Timer,
	"SpellCurseBonusTimer",
	function()
		CleanUp()
	end
)

RegisterEventHandler(
	EventType.Message,
	"SpellHitEffectsp_curse_effect",
	function(caster)
		HandleLoaded()
	end
)
