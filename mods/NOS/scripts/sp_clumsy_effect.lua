
mDecreaseAmount = 0

mDurationMinutes = 2

mBuffed = false

function HandleLoaded()
	local skillLevel = GetSkillLevel(this,"ManifestationSkill")

	if( this:HasTimer("SpellClumsyBonusTimer") ) then
		this:RemoveTimer("SpellClumsyBonusTimer")
	end
	mDecreaseAmount = -math.floor(skillLevel/10)

	SetMobileMod(this, "AgilityPlus", "SpellClumsy", mDecreaseAmount)
	AddBuffIcon(this,"WeakenSpellBuff","Weaken","Thunder Strike 04","Agility is decreased by "..mDecreaseAmount,false,mDurationMinutes*60)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "SpellClumsyBonusTimer")
	if not( mBuffed ) then
		this:SystemMessage("Your agility has decreased by "..mDecreaseAmount, "event")
	end
	mBuffed = true
end

function CleanUp()
	SetMobileMod(this, "AgilityPlus", "SpellClumsy", nil)
	this:SystemMessage("Clumsy has worn off, increasing your agility by "..mDecreaseAmount, "event")
	RemoveBuffIcon(this,"WeakenSpellBuff")
	mDecreaseAmount = 0
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Timer, "SpellClumsyBonusTimer", function()
	CleanUp()
	end)

RegisterEventHandler(EventType.Message, "SpellHitEffectsp_clumsy_effect", 
	function(caster)
		HandleLoaded()
	end)