mAmount = 0

mDurationMinutes = 2

mBuffed = false

function HandleLoaded()
	local skillLevel = GetSkillLevel(this, "MagerySkill")

	if (this:HasTimer("SpellStrengthBonusTimer")) then
		this:RemoveTimer("SpellStrengthBonusTimer")
	end
	mAmount = math.floor(skillLevel / 10)

	SetMobileMod(this, "StrengthPlus", "SpellStrength", mAmount)
	AddBuffIcon(
		this,
		"WeakenSpellBuff",
		"Strength",
		"Thunder Strike 04",
		"Strength is increased by " .. mAmount,
		false,
		mDurationMinutes * 60
	)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "SpellStrengthBonusTimer")
	if not (mBuffed) then
		this:SystemMessage("Your strength has increased by " .. mAmount, "event")
	end
	mBuffed = true
end 

function CleanUp()
	SetMobileMod(this, "StrengthPlus", "SpellStrength", nil)
	this:SystemMessage("Strength has worn off, decreasing your strength by " .. mAmount, "event")
	RemoveBuffIcon(this, "WeakenSpellBuff")
	mAmount = 0
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(
	EventType.Timer,
	"SpellStrengthBonusTimer",
	function()
		CleanUp()
	end
)

RegisterEventHandler(
	EventType.Message,
	"SpellHitEffectsp_strength_effect",
	function(caster)
		HandleLoaded()
	end
)
