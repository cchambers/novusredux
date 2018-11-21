SHRINK_SIZE = 0.5
DURATION = 4
PLAYERTEMPLATE_MALE = "playertemplate_male"
DEFAULT_MALE_HAIR = "hair_male"
PLAYERTEMPLATE_FEMALE = "playertemplate_female"
DEFAULT_FEMALE_HAIR = "hair_female"
DEFAULT_HAIR_HUE = "0xFF554838"

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),function(...)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"TriggerSexPotion")
	--this:ScheduleTimerDelay(TimeSpan.FromSeconds(DURATION), "SizePotionTimer")
end)

RegisterEventHandler(EventType.Timer,"TriggerSexPotion",function(...)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(DURATION),"EndEffect")
	local hair = this:GetEquippedObject("BodyPartHair")
	if (hair ~= nil) then
		hair:Destroy()
	end
	if (IsFemale(this)) then
		this:SetAppearanceFromTemplate(PLAYERTEMPLATE_MALE)
		--CreateEquippedObj(DEFAULT_MALE_HAIR, this, "created_hair")
	else
		this:SetAppearanceFromTemplate(PLAYERTEMPLATE_FEMALE)
		--CreateEquippedObj(DEFAULT_FEMALE_HAIR, this, "created_hair")
	end
	this:SystemMessage("You turn into the opposite sex!")
	this:SystemMessage("Your hair falls out! Better find a Transmorgifier!")
end)

function EndEffect()
	--this:SystemMessage("The shrinking effect has worn off.")
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Message, "HasDiedMessage", 
	function()
		EndEffect()
	end)

RegisterEventHandler(EventType.Timer,"EndEffect",function ( ... )
	EndEffect()
end)

RegisterEventHandler(EventType.CreatedObject,"created_hair",
	function(user)
		local currentEquipped = this:GetEquippedObject("BodyPartHair")
		currentEquipped:SetColor(DEFAULT_HAIR_HUE)--set the equipped object to the template in the index
	end)