RegisterEventHandler(
	EventType.Message,
	"UseObject",
	function(user, usedType)
		user:SetObjVar("ColorWarWaiting", true)
	end
)