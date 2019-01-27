mDurationMinutes = 10

function HandleLoaded(caster)

	if( this:HasTimer("IncognitoTimer") or IsImmortal(this) or this:HasModule("npe_player") or not(IsPlayerCharacter(this))) then
		return
	end

	local skillLevel = GetSkillLevel(caster,"MagerySkill")
	mDurationMinutes = skillLevel / 10
	this:SetObjVar("NameActual", this:GetName())

	local name = "hello world"

	if (IsMale(this)) then
		name = "a man"
	else
		name = "a woman"
	end

	this:SetName(name)

	this:SendMessage("UpdateName")
	
	AddBuffIcon(this,"IncognitoSpell","Incognito","Thunder Strike 04","You are incognito.",false,mDurationMinutes*60)
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "IncognitoTimer")

end

function CleanUp()
	this:SystemMessage("Incognito has worn off, revealing your true identity.")
	RemoveBuffIcon(this,"IncognitoSpell")
	this:SetName(this:GetObjVar("NameActual"))
	this:DelObjVar("NameActual")
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