
RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(),
	function()	
		this:SetObjVar("ColorWarItem", true)
		this:SetObjVar("NoDecay", true)
	end)