
mIncreaseAmount = 0

mDurationMinutes = 2

mBuffed = false

function HandleLoaded()
	local skillLevel = GetSkillLevel(this,"ManifestationSkill")

	if( this:HasTimer("SpellAgilityBonusTimer") ) then
		this:RemoveTimer("SpellAgilityBonusTimer")
	end
	mIncreaseAmount = math.floor(skillLevel/10)

	SetMobileMod(this, "AgilityPlus", "SpellAgility", mIncreaseAmount)
	AddBuffIcon(this,"AgilitySpellBuff","Agility","Blazing Speed","Agility is increased by "..mIncreaseAmount,false,mDurationMinutes*60)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "SpellAgilityBonusTimer")
	if not( mBuffed ) then
		this:SystemMessage("Your Agility has increased by "..mIncreaseAmount, "event")
	end
	mBuffed = true
end

function CleanUp()
	SetMobileMod(this, "AgilityPlus", "SpellAgility", nil)
	this:SystemMessage("Agility has worn off, decreasing by "..mIncreaseAmount, "event")
	RemoveBuffIcon(this,"AgilitySpellBuff")
	mIncreaseAmount = 0
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Timer, "SpellAgilityBonusTimer", function()
	CleanUp()
	end)

RegisterEventHandler(EventType.Message, "SpellHitEffectsp_agility_effect", 
	function(caster)
		HandleLoaded()
	end)