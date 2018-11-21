require 'incl_packed_object'

RegisterSingleEventHandler(EventType.ModuleAttached, "fill_container", 
	function()
		for i,itemInfo in pairs(initializer.Items) do
			local location = itemInfo.Location or GetRandomDropPosition(this)
			if not(itemInfo.Packed) then				
				CreateObjInContainer(itemInfo.Template,this,location)
			else
				CreatePackedObjectInContainer(itemInfo.Template,this,location)
			end
		end

		CallFunctionDelayed(TimeSpan.FromSeconds(5),function() this:DelModule("fill_container") end)
	end)