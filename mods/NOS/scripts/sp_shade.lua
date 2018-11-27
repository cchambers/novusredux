foods = {
	"Degenerates like you belong on a cross!",
	"The best part of waking up is not being next to you.",
	"You look like I need a drink!"
}

mDurationMinutes = 2

mBuffed = false

function HandleLoaded(caster)
	local skillLevel = GetSkillLevel(caster,"ManifestationSkill")

	if( this:HasTimer("SpellShadeBonusTimer") ) then
		this:RemoveTimer("SpellShadeBonusTimer")
	end

	AddBuffIcon(this,"StrengthSpellBuff","Strength","Imbue Holy","lol",false,mDurationMinutes*60)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "SpellShadeBonusTimer")
	if not( mBuffed ) then
		this:SystemMessage("Your confidence has decreased slightly.")
	end
	mBuffed = true
end

function CleanUp()
	this:SystemMessage("You regain your confidence.")
	RemoveBuffIcon(this,"StrengthSpellBuff")
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Timer, "SpellShadeBonusTimer", function()
	CleanUp()
	end)

RegisterEventHandler(EventType.Message, "SpellHitEffectsp_strength_effect", 
	function(caster)
		HandleLoaded(caster)
	end)