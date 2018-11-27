
mIncreaseAmount = 0

mDurationMinutes = 2

mBuffed = false

function HandleLoaded(caster)
	local skillLevel = GetSkillLevel(caster,"ManifestationSkill")

	if( this:HasTimer("SpellStrengthBonusTimer") ) then
		this:RemoveTimer("SpellStrengthBonusTimer")
	end
	mIncreaseAmount = math.floor(skillLevel/10)

	SetMobileMod(this, "StrengthPlus", "SpellStrength", mIncreaseAmount)
	AddBuffIcon(this,"StrengthSpellBuff","Strength","Imbue Holy","Strength is increased by "..mIncreaseAmount,false,mDurationMinutes*60)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "SpellStrengthBonusTimer")
	if not( mBuffed ) then
		this:SystemMessage("Your strength has increased by "..mIncreaseAmount, "event")
	end
	mBuffed = true
end

function CleanUp()
	SetMobileMod(this, "StrengthPlus", "SpellStrength", nil)
	this:SystemMessage("Strength has worn off, decreasing by "..mIncreaseAmount, "event")
	RemoveBuffIcon(this,"StrengthSpellBuff")
	mIncreaseAmount = 0
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Timer, "SpellStrengthBonusTimer", function()
	CleanUp()
	end)

RegisterEventHandler(EventType.Message, "SpellHitEffectsp_strength_effect", 
	function(caster)
		HandleLoaded(caster)
	end)