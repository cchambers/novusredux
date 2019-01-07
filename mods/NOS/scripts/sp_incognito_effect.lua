
mDecreaseAmount = 0

mDurationMinutes = 2

mBuffed = false

function HandleLoaded(caster)
	local skillLevel = GetSkillLevel(caster,"MagerySkill")

	if( this:HasTimer("IncognitoTimer") or IsImmortal(this) ) then
		return
	end

	this:SetObjVar("NameActual", this:GetName())

	local name = "hello world"

	if (IsMale(this)) then
		name = "a man"
	else
		name = "a woman"
	end

	this:SetName(name)

	this:SendMessage("UpdateName")
	
	AddBuffIcon(this,"IncognitoSpell","Incognito","Thunder Strike 04","You are ingonito.",false,mDurationMinutes*60)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "IncognitoTimer")

end

function CleanUp()
	this:SystemMessage("Incognito has worn off, revealing your true identity.")
	RemoveBuffIcon(this,"IncognitoSpell")
	this:SetName(this:GetObjVar("NameActual"))
	this:SendMessage("UpdateName")
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Timer, "IncognitoTimer", function()
	CleanUp()
	end)

RegisterEventHandler(EventType.Message, "SpellHitEffectsp_incognito_effect", 
	function(caster)
		HandleLoaded(caster)
	end)