
mIncreaseAmount = 0

mDurationMinutes = 2

mBuffed = false

function HandleLoaded()
	local skillLevel = GetSkillLevel(this,"MagerySkill")

	if( this:HasTimer("SpellPowerBonusTimer") ) then
		this:RemoveTimer("SpellPowerBonusTimer")
	end
	mIncreaseAmount = math.floor(skillLevel/10) * 2

	SetMobileMod(this, "AttackPlus", "SpellPower", mIncreaseAmount)
	AddBuffIcon(this,"AttackSpellBuff","Attack","Sap2","Attack is increased by "..mIncreaseAmount,false,mDurationMinutes*60)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "SpellPowerBonusTimer")
	if not( mBuffed ) then
		this:SystemMessage("Your Attack has increased by "..mIncreaseAmount, "event")
	end
	mBuffed = true
end

function CleanUp()
	SetMobileMod(this, "AttackPlus", "SpellPower", nil)
	this:SystemMessage("Attack has worn off, decreasing by "..mIncreaseAmount, "event")
	RemoveBuffIcon(this,"AttackSpellBuff")
	mIncreaseAmount = 0
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Timer, "SpellPowerBonusTimer", function()
	CleanUp()
	end)

RegisterEventHandler(EventType.Message, "SpellHitEffectsp_power_effect", 
	function(caster)
		HandleLoaded()
	end)