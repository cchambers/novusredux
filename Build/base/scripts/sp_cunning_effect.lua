
mIncreaseAmount = 0

mDurationMinutes = 2

mBuffed = false

function HandleLoaded()
	local skillLevel = GetSkillLevel(this,"ManifestationSkill")

	if( this:HasTimer("SpellIntelligenceBonusTimer") ) then
		this:RemoveTimer("SpellIntelligenceBonusTimer")
	end
	mIncreaseAmount = math.floor(skillLevel/10)

	SetMobileMod(this, "IntelligencePlus", "SpellIntelligence", mIncreaseAmount)
	AddBuffIcon(this,"IntelligenceSpellBuff","Intelligence","Cold Mastery","Intelligence is increased by "..mIncreaseAmount,false,mDurationMinutes*60)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "SpellIntelligenceBonusTimer")
	if not( mBuffed ) then
		this:SystemMessage("Your Intelligence has increased by "..mIncreaseAmount, "event")
	end
	mBuffed = true
end

function CleanUp()
	SetMobileMod(this, "IntelligencePlus", "SpellIntelligence", nil)
	this:SystemMessage("Intelligence has worn off, decreasing by "..mIncreaseAmount, "event")
	RemoveBuffIcon(this,"IntelligenceSpellBuff")
	mIncreaseAmount = 0
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Timer, "SpellIntelligenceBonusTimer", function()
	CleanUp()
	end)

RegisterEventHandler(EventType.Message, "SpellHitEffectsp_Intelligence_effect", 
	function(caster)
		HandleLoaded()
	end)