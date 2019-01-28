
RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(),
	function()	
		this:SetObjVar("ColorwarItem", true)
		this:SetObjVar("NoDecay", true)
	end)