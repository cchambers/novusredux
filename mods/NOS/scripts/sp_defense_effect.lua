
mIncreaseAmount = 0

mDurationMinutes = 2

mBuffed = false

function HandleLoaded()
	local skillLevel = GetSkillLevel(this,"MagerySkill")

	if( this:HasTimer("SpellDefenseBonusTimer") ) then
		this:RemoveTimer("SpellDefenseBonusTimer")
	end
	mIncreaseAmount = math.floor(skillLevel/10) * 2

	SetMobileMod(this, "DefensePlus", "SpellDefense", mIncreaseAmount)
	AddBuffIcon(this,"DefenseSpellBuff","Defense","Deflect","Defense is increased by "..mIncreaseAmount,false,mDurationMinutes*60)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "SpellDefenseBonusTimer")
	if not( mBuffed ) then
		this:SystemMessage("Your Defense has increased by "..mIncreaseAmount, "event")
	end
	mBuffed = true
end

function CleanUp()
	SetMobileMod(this, "DefensePlus", "SpellDefense", nil)
	this:SystemMessage("Defense has worn off, decreasing by "..mIncreaseAmount, "event")
	RemoveBuffIcon(this,"DefenseSpellBuff")
	mIncreaseAmount = 0
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Timer, "SpellDefenseBonusTimer", function()
	CleanUp()
	end)

RegisterEventHandler(EventType.Message, "SpellHitEffectsp_defense_effect", 
	function(caster)
		HandleLoaded()
	end)