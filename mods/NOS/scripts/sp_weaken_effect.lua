
mDecreaseAmount = 0

mDurationMinutes = 2

mBuffed = false

function HandleLoaded()
	local skillLevel = GetSkillLevel(this,"MagerySkill")

	if( this:HasTimer("SpellWeakenBonusTimer") ) then
		this:RemoveTimer("SpellWeakenBonusTimer")
	end
	mDecreaseAmount = -math.floor(skillLevel/10)

	SetMobileMod(this, "StrengthPlus", "SpellWeaken", mDecreaseAmount)
	AddBuffIcon(this,"WeakenSpellBuff","Weaken","Thunder Strike 04","Strength is decreased by "..mDecreaseAmount,false,mDurationMinutes*60)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "SpellWeakenBonusTimer")
	if not( mBuffed ) then
		this:SystemMessage("Your strength has decreased by "..mDecreaseAmount, "event")
	end
	mBuffed = true
end

function CleanUp()
	SetMobileMod(this, "StrengthPlus", "SpellWeaken", nil)
	this:SystemMessage("Weaken has worn off, increasing your strength by "..mDecreaseAmount, "event")
	RemoveBuffIcon(this,"WeakenSpellBuff")
	mDecreaseAmount = 0
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Timer, "SpellWeakenBonusTimer", function()
	CleanUp()
	end)

RegisterEventHandler(EventType.Message, "SpellHitEffectsp_weaken_effect", 
	function(caster)
		HandleLoaded()
	end)