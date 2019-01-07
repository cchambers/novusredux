RegisterEventHandler(
	EventType.Message,
	"UseObject",
	function(user, usedType)
		user:SystemMessage("You have been restored.")
		user:SetStatValue("Health", GetMaxHealth(this))
		user:SetStatValue("Mana", 250)
		user:SetStatValue("Stamina", 250)
	end
)