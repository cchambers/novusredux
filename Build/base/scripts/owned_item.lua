RegisterSingleEventHandler(EventType.ModuleAttached, "owned_item", 
	function()
		--this:SetSharedObjectProperty("Weight",-1)
		this:SetSharedObjectProperty("DenyPickup", true)
		this:SetObjVar("handlesPickup",true)
	end)
